-- Test 1: Attempt to create an order with no items (should be prevented by application logic)   ok
-- This is tested by trying to delete the only item from an order

-- First create a test order with one item
INSERT INTO Cuisine (name) VALUES ('Indonesian');
INSERT INTO Item (name, price, cuisine) VALUES ('Rendang', 4, 'Indonesian');
INSERT INTO Staff (id, name) VALUES ('STAFF-01', 'Kat');
INSERT INTO Cook (staff, cuisine) VALUES ('STAFF-01', 'Indonesian');
INSERT INTO Food_Order (id, date, time, payment_method, total_price) VALUES ('ORDER-1', '2024-01-01', '12:00:00', 'cash', 10);
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('ORDER-1', 'Rendang', 'STAFF-01', 2);

-- Delete the only item (should fail). Expected: ERROR: Order ORDER-1 must have at least one item
DELETE FROM Prepare WHERE order_id = 'ORDER-1';

-- Test 2: Attempt to assign staff to cook item from wrong cuisine   ok
INSERT INTO Cuisine (name) VALUES ('Vietnamese');
INSERT INTO Item (name, price, cuisine) VALUES ('Bun Cha', 3, 'Vietnamese');
INSERT INTO Food_Order (id, date, time, payment_method, total_price) VALUES ('ORDER-2', '2024-09-08', '3:00:00', 'cash', 6);

-- Expected: ERROR: Staff STAFF-01 is not assigned to cook cuisine for item Bun Cha
INSERT INTO Prepare (order_id, item, staff, qty) VALUES ('ORDER-2', 'Bun Cha', 'STAFF-01', 1);

-- Run below statement after running all of the insert statements in test_1
-- Expected: Staff STAFF-01 is not assigned to cook cuisine for item Bun Cha
UPDATE Prepare SET item = 'Bun Cha'
WHERE order_id = 'ORDER-1';


-- Test 3: Attempt to create order for member before registration date
-- 1st subtest for trigger3
INSERT INTO Member (phone, firstname, lastname, reg_date, reg_time)
VALUES (12345678, 'FN', 'LN', '2024-01-02', '12:00:00');
INSERT INTO Food_Order (id, date, time, payment_method, total_price)
VALUES ('ORDER-3', '2024-01-01', '11:00:00', 'cash', 10);

-- Expected: ERROR: Order for member 12345678 occurs before registration
INSERT INTO Ordered_By (order_id, member)
VALUES ('ORDER-3', 12345678);

-- 2nd subtest (on table food_order)
INSERT INTO Member (phone, firstname, lastname, reg_date, reg_time)
VALUES (88888888, 'FN1', 'LN1', '2024-03-16', '12:00:00');
INSERT INTO Food_Order (id, date, time, payment_method, total_price)
VALUES ('ORDER-4', '2025-07-08', '2:00:00', 'cash', 5);
INSERT INTO Ordered_By (order_id, member) VALUES ('ORDER-4',88888888);

-- Expected: ERROR: Order for member 88888888 occurs before registration
UPDATE Food_Order SET date = '2023-07-08' WHERE id = 'ORDER-4';

-- Test 4: Verify total_price is correctly calculated and updated
-- Create a new order with multiple items
INSERT INTO Food_Order (id, date, time, payment_method, total_price)
VALUES ('ORDER-6', '2024-01-03', '12:00:00', 'cash', 0);

-- Add items to the order
INSERT INTO Prepare (order_id, item, staff, qty)
VALUES 
    ('ORDER-6', 'Bun Cha', 'STAFF-03', 5),
    ('ORDER-6', 'Rendang', 'STAFF-03', 1);

-- Check total_price 
SELECT total_price FROM Food_Order WHERE id = 'ORDER-6';

-- Now register as member and apply discount
INSERT INTO Ordered_By (order_id, member)
VALUES ('ORDER-6', 88888888);

-- Check total_price with discount (should be 17)
SELECT total_price FROM Food_Order WHERE id = 'ORDER-6';