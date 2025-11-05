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
	p_item_price NUMERIC;
	p_cuisine VARCHAR(256);
	p_staff_name VARCHAR(256);
    existing_order_count INTEGER;
    member_exists INTEGER;
BEGIN
	-- Create new order if it doesn't exist
    IF NOT EXISTS (SELECT * FROM Food_Order WHERE id = p_order_id) THEN
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

	IF p_item_name = 'Rendang' THEN
    	p_item_price := 4;
    	p_cuisine := 'Indonesian';
	END IF;

	IF p_item_name = 'Ayam Balado' THEN
    	p_item_price := 4;
    	p_cuisine := 'Indonesian';
	END IF;

	IF p_item_name = 'Gudeg' THEN
    	p_item_price := 3;
	    p_cuisine := 'Indonesian';
	END IF;

	IF p_item_name = 'Rinderrouladen' THEN
    	p_item_price := 3.5;
    	p_cuisine := 'German';
	END IF;

	IF p_item_name = 'Sauerbraten' THEN
    	p_item_price := 4;
    	p_cuisine := 'German';
	END IF;

	IF p_item_name = 'Bun Cha' THEN
    	p_item_price := 3;
    	p_cuisine := 'Vietnamese';
	END IF;

	IF p_item_name = 'Thunder Tea Rice' THEN
    	p_item_price := 2.5;
    	p_cuisine := 'Chinese';
	END IF;

	IF p_item_name = 'Palak Paneer' THEN
    	p_item_price := 4;
    	p_cuisine := 'Indian';
	END IF;

	INSERT INTO Cuisine (name) VALUES (p_cuisine);
	INSERT INTO Item (name, price, cuisine) VALUES (p_item_name, p_item_price, p_cuisine);

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

	IF p_staff_id = 'STAFF-01' THEN p_staff_name := 'Kat'; END IF;
	IF p_staff_id = 'STAFF-02' THEN p_staff_name := 'Kat'; END IF;
	IF p_staff_id = 'STAFF-03' THEN p_staff_name := 'Taro'; END IF;
	IF p_staff_id = 'STAFF-04' THEN p_staff_name := 'Owens'; END IF;
	IF p_staff_id = 'STAFF-05' THEN p_staff_name := 'Migi'; END IF;
	IF p_staff_id = 'STAFF-06' THEN p_staff_name := 'Dari'; END IF;
	IF p_staff_id = 'STAFF-07' THEN p_staff_name := 'Ida'; END IF;
	IF p_staff_id = 'STAFF-08' THEN p_staff_name := 'Neyu'; END IF;
	IF p_staff_id = 'STAFF-09' THEN p_staff_name := 'Rodion'; END IF;
	IF p_staff_id = 'STAFF-10' THEN p_staff_name := 'Neon'; END IF;
	IF p_staff_id = 'STAFF-11' THEN p_staff_name := 'Evan'; END IF;
	IF p_staff_id = 'STAFF-12' THEN p_staff_name := 'Gerion'; END IF;

	INSERT INTO Staff (id, name) VALUES (p_staff_id, p_staff_name);
	
    -- Add item to order (increment quantity if already exists)
    INSERT INTO Prepare (order_id, item, staff, qty)
    VALUES (p_order_id, p_item_name, p_staff_id, 1)
    ON CONFLICT (order_id, item, staff) 
    DO UPDATE SET qty = Prepare.qty + 1;
	
END;
$$ LANGUAGE plpgsql;


-- --
-- SELECT * FROM cuisine;
-- SELECT * FROM item;
-- SELECT * FROM member;
-- SELECT * FROM food_order;
-- SELECT * FROM prepare;

-- CALL insert_order_item('20240301002', '2024-03-01', '12:19:23', 'card', '5108-7574-2920-6803', 'mastercard', 93627414, 'Ayam Balado', 'STAFF-03');
