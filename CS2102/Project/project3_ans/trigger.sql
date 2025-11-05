-- triggers.sql
-- trigger definitions and creations

-- Trigger 1: Ensure each order has at least one item
CREATE OR REPLACE FUNCTION check_order_has_items()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if after deletion, the order has at least one item
	IF NOT EXISTS (SELECT 1 FROM Prepare WHERE order_id = OLD.order_id) THEN
		RAISE EXCEPTION 'Order % must have at least one item', OLD.order_id;
	END IF;

	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_order_has_items
    AFTER DELETE ON Prepare
    FOR EACH ROW
    EXECUTE FUNCTION check_order_has_items();

-- Trigger 2: Ensure staff is assigned to cook the item's cuisine
CREATE OR REPLACE FUNCTION check_staff_cuisine()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the staff is assigned to cook the cuisine of the item
    IF NOT EXISTS (
        SELECT 1 
        FROM Cook c 
        JOIN Item i ON i.name = NEW.item 
        WHERE c.staff = NEW.staff AND c.cuisine = i.cuisine
    ) THEN
        RAISE EXCEPTION 'Staff % is not assigned to cook cuisine for item %', NEW.staff, NEW.item;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_staff_cuisine
    BEFORE INSERT OR UPDATE ON Prepare
    FOR EACH ROW
    EXECUTE FUNCTION check_staff_cuisine();

-- Trigger 3: Ensure member orders occur after registration  ok
CREATE OR REPLACE FUNCTION check_member_registration_time()
RETURNS TRIGGER AS $$
DECLARE
    member_reg_date DATE;
    member_reg_time TIME;
BEGIN
    -- Get member's registration date and time
    SELECT reg_date, reg_time INTO member_reg_date, member_reg_time
    FROM Member 
    WHERE phone = NEW.member;
    
    -- Check if order date/time is before registration date/time
    IF (NEW.order_id IN (SELECT order_id FROM Ordered_By WHERE member = NEW.member)) THEN
        DECLARE
            order_date DATE;
            order_time TIME;
        BEGIN
            SELECT date, time INTO order_date, order_time
            FROM Food_Order 
            WHERE id = NEW.order_id;
            
            IF (order_date < member_reg_date OR 
               (order_date = member_reg_date AND order_time < member_reg_time)) THEN
                RAISE EXCEPTION 'Order for member % occurs before registration', NEW.member;
            END IF;
        END;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_member_registration_time_food_order()
RETURNS TRIGGER AS $$
DECLARE
	member_reg_date DATE;
    member_reg_time TIME;
	order_date DATE;
	order_time TIME;
	member INTEGER;
BEGIN
	-- Get member's registration date and time
	SELECT m.reg_date, m.reg_time, m.phone INTO member_reg_date, member_reg_time, member
	FROM Member m
	JOIN Ordered_By ob ON m.phone = ob.member
	JOIN Food_Order fo ON fo.id = ob.order_id
	WHERE fo.id = NEW.id; 

	-- Check if order date/time is before registration date/time
	SELECT date, time INTO order_date, order_time
	FROM Food_Order 
		WHERE id = NEW.id;    
		IF (order_date < member_reg_date OR (order_date = member_reg_date AND order_time < member_reg_time)) THEN
			RAISE EXCEPTION 'Order for member % occurs before registration', member;
		END IF;  

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_member_registration_time
    BEFORE INSERT ON Ordered_By
    FOR EACH ROW
    EXECUTE FUNCTION check_member_registration_time();

CREATE OR REPLACE TRIGGER trigger_member_registration_time_food_order
	BEFORE UPDATE ON Food_Order
    FOR EACH ROW
    EXECUTE FUNCTION check_member_registration_time_food_order();
	
-- Trigger 4: Maintain correct total_price in Food_Order
CREATE OR REPLACE FUNCTION update_order_total_price()
RETURNS TRIGGER AS $$
DECLARE
    calculated_total NUMERIC;
    item_count INTEGER;
    is_member BOOLEAN;
    discount NUMERIC := 0;
BEGIN
    -- Calculate total price based on Prepare table
    SELECT COALESCE(SUM(p.qty * i.price), 0)
    INTO calculated_total
    FROM Prepare p
    JOIN Item i ON p.item = i.name
    WHERE p.order_id = COALESCE(NEW.order_id, OLD.order_id);
    
    -- Check if order has a member
    SELECT EXISTS (
        SELECT 1 FROM Ordered_By WHERE order_id = COALESCE(NEW.order_id, OLD.order_id)
    ) INTO is_member;
    
    -- Count total items in order
    SELECT COALESCE(SUM(qty), 0)
    INTO item_count
    FROM Prepare
    WHERE order_id = COALESCE(NEW.order_id, OLD.order_id);
    
    -- Apply discount if applicable
    IF is_member AND item_count >= 4 THEN
        discount := 2;
    END IF;
    
    calculated_total := calculated_total - discount;
    IF calculated_total < 0 THEN
        calculated_total := 0;
    END IF;
    
    -- Update the total_price in Food_Order
    UPDATE Food_Order 
    SET total_price = calculated_total 
    WHERE id = COALESCE(NEW.order_id, OLD.order_id);
    
    RETURN CASE 
        WHEN TG_OP = 'DELETE' THEN OLD 
        ELSE NEW 
    END;
END;
$$ LANGUAGE plpgsql;

-- Triggers to maintain total_price
CREATE OR REPLACE TRIGGER trigger_update_total_insert
    AFTER INSERT OR UPDATE OR DELETE ON Prepare
    FOR EACH ROW
    EXECUTE FUNCTION update_order_total_price();

-- Also trigger when Ordered_By changes (affects discount)
CREATE OR REPLACE TRIGGER trigger_update_total_member
    AFTER INSERT OR UPDATE OR DELETE ON Ordered_By
    FOR EACH ROW
    EXECUTE FUNCTION update_order_total_price();