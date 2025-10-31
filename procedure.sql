-- procedure.sql
-- Stored procedure to simplify order creation

CREATE OR REPLACE PROCEDURE insert_order_item(
    p_order_id VARCHAR(256),
    p_order_date DATE,
    p_order_time TIME,
    p_payment_method VARCHAR(10),
    p_card VARCHAR(256),
    p_card_type VARCHAR(256),
    p_member_phone INTEGER,
    p_item_name VARCHAR(256),
    p_staff_id VARCHAR(256)
)
AS $$
DECLARE
    existing_order_count INTEGER;
    member_exists INTEGER;
BEGIN
    -- Check if order already exists
    SELECT COUNT(*) INTO existing_order_count
    FROM Food_Order
    WHERE id = p_order_id;
    
    -- Create new order if it doesn't exist
    IF existing_order_count = 0 THEN
        INSERT INTO Food_Order (id, date, time, payment_method, card, card_type, total_price)
        VALUES (
            p_order_id,
            p_order_date,
            p_order_time,
            p_payment_method,
            CASE WHEN p_payment_method = 'card' THEN p_card ELSE NULL END,
            CASE WHEN p_payment_method = 'card' THEN p_card_type ELSE NULL END,
            0  -- Initial total_price, will be updated by trigger
        );
    END IF;
    
    -- Link member to order if provided and not already linked
    IF p_member_phone IS NOT NULL THEN
        SELECT COUNT(*) INTO member_exists
        FROM Member
        WHERE phone = p_member_phone;
        
        IF member_exists > 0 THEN
            INSERT INTO Ordered_By (order_id, member)
            VALUES (p_order_id, p_member_phone)
            ON CONFLICT (order_id) DO NOTHING;
        END IF;
    END IF;
    
    -- Add item to order (increment quantity if already exists)
    INSERT INTO Prepare (order_id, item, staff, qty)
    VALUES (p_order_id, p_item_name, p_staff_id, 1)
    ON CONFLICT (order_id, item, staff) 
    DO UPDATE SET qty = Prepare.qty + 1;
    
END;
$$ LANGUAGE plpgsql;