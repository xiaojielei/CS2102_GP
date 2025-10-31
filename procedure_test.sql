INSERT INTO Cuisine (name) VALUES 
    ('Indonesian'), ('German'), ('Vietnamese'), ('Indian'), ('Singaporean')
ON CONFLICT (name) DO NOTHING;

INSERT INTO Item (name, price, cuisine) VALUES 
    ('Rendang', 4.0, 'Indonesian'),
    ('Ayam Balado', 4.0, 'Indonesian'),
    ('Gudeg', 3.0, 'Indonesian'),
    ('Rinderrouladen', 3.5, 'German'),
    ('Sauerbraten', 4.0, 'German'),
    ('Bun Cha', 3.0, 'Vietnamese'),
    ('Pho', 5.0, 'Vietnamese'),
    ('Palak Paneer', 7.0, 'Indian'),
    ('Thunder Tea Rice', 2.5, 'Singaporean')
ON CONFLICT (name) DO NOTHING;

INSERT INTO Staff (id, name) VALUES 
    ('STAFF-01', 'Staff 01'), ('STAFF-02', 'Staff 02'), ('STAFF-03', 'Staff 03'),
    ('STAFF-04', 'Staff 04'), ('STAFF-05', 'Staff 05'), ('STAFF-06', 'Staff 06'),
    ('STAFF-07', 'Staff 07'), ('STAFF-08', 'Staff 08'), ('STAFF-09', 'Staff 09'),
    ('STAFF-10', 'Staff 10'), ('STAFF-11', 'Staff 11'), ('STAFF-12', 'Staff 12')
ON CONFLICT (id) DO NOTHING;

INSERT INTO Cook (staff, cuisine) VALUES
    ('STAFF-01', 'Indonesian'), ('STAFF-01', 'German'),
    ('STAFF-02', 'German'), ('STAFF-02', 'Indonesian'),
    ('STAFF-03', 'Indonesian'), ('STAFF-03', 'Vietnamese'),
    ('STAFF-04', 'Indonesian'), ('STAFF-04', 'German'),
    ('STAFF-05', 'Indonesian'), ('STAFF-05', 'Vietnamese'),
    ('STAFF-06', 'Indonesian'), ('STAFF-06', 'Singaporean'),
    ('STAFF-07', 'Indonesian'), ('STAFF-07', 'Vietnamese'),
    ('STAFF-08', 'Indonesian'), ('STAFF-08', 'Singaporean'),
    ('STAFF-09', 'Indonesian'), ('STAFF-09', 'German'),
    ('STAFF-10', 'Indonesian'), ('STAFF-10', 'Vietnamese'),
    ('STAFF-11', 'German'), ('STAFF-11', 'Vietnamese'),
    ('STAFF-12', 'German'), ('STAFF-12', 'Indian')
ON CONFLICT (staff, cuisine) DO NOTHING;

INSERT INTO Member (phone, firstname, lastname, reg_date, reg_time) VALUES
    (93627414, 'Ignazio', 'Abrahmer', '2024-02-28', '10:00:00'),
    (89007281, 'Bernard', 'Cowlard', '2024-02-25', '09:30:00'),
    (81059611, 'Laurette', 'Birney', '2024-02-20', '14:15:00'),
    (93342383, 'Corby', 'Crinage', '2024-02-22', '16:45:00'),
    (85625766, 'Mal', 'Bavister', '2024-02-18', '11:20:00'),
    (95672712, 'Terese', 'Chetwind', '2024-02-15', '13:10:00'),
    (94385675, 'Kipp', 'Pettifer', '2024-02-28', '08:45:00'),
    (97416639, 'Ernestine', 'Loughney', '2024-02-26', '12:30:00'),
    (87113774, 'Estell', 'Barwell', '2024-02-24', '15:20:00'),
    (95961010, 'Othello', 'Reymers', '2024-02-19', '10:40:00'),
    (96537349, 'Grissel', 'Howels', '2024-02-23', '17:15:00'),
    (93603800, 'Maddie', 'Izkoveski', '2024-02-27', '09:00:00'),
    (87433248, 'Nolan', 'Capelin', '2024-02-21', '14:50:00'),
    (98216900, 'Alyce', 'Brenard', '2024-02-16', '11:35:00'),
    (95624750, 'Jacenta', 'Buxsy', '2024-02-29', '13:25:00'),
    (85205752, 'Kiah', 'Cotter', '2024-02-17', '16:10:00'),
    (93344468, 'Gage', 'Whaymand', '2024-02-14', '12:05:00'),
    (83187835, 'Rickey', 'Hector', '2024-02-13', '15:55:00'),
    (87547836, 'Flynn', 'Massot', '2024-02-12', '10:25:00')
ON CONFLICT (phone) DO NOTHING;


CALL insert_order_item('20240301002', '2024-03-01', '12:19:23', 'card', '5108-7574-2920-6803', 'mastercard', 93627414, 'Ayam Balado', 'STAFF-03');

CALL insert_order_item('20240301002', '2024-03-01', '12:19:23', 'card', '5108-7574-2920-6803', 'mastercard', 93627414, 'Ayam Balado', 'STAFF-04');

CALL insert_order_item('20240301005', '2024-03-01', '15:39:48', 'card', '3742-8382-6101-0570', 'americanexpress', 89007281, 'Rinderrouladen', 'STAFF-02');

CALL insert_order_item('20240301006', '2024-03-01', '16:19:03', 'card', '5002-3594-5319-1014', 'mastercard', 81059611, 'Ayam Balado', 'STAFF-07');

CALL insert_order_item('20240301007', '2024-03-01', '18:39:04', 'card', '3438-5506-5448-2790', 'americanexpress', 93342383, 'Rinderrouladen', 'STAFF-09');

CALL insert_order_item('20240301008', '2024-03-01', '19:22:02', 'card', '5122-4098-9757-8766', 'mastercard', 85625766, 'Rinderrouladen', 'STAFF-12');

CALL insert_order_item('20240301008', '2024-03-01', '19:22:02', 'card', '5122-4098-9757-8766', 'mastercard', 85625766, 'Sauerbraten', 'STAFF-11');

CALL insert_order_item('20240302003', '2024-03-02', '10:41:41', 'card', '3742-8862-9783-4150', 'americanexpress', 95672712, 'Rinderrouladen', 'STAFF-02');

CALL insert_order_item('20240302005', '2024-03-02', '14:38:36', 'card', '5108-7546-4908-7766', 'mastercard', 94385675, 'Gudeg', 'STAFF-03');

CALL insert_order_item('20240302007', '2024-03-02', '17:34:55', 'card', '3379-4110-3466-1310', 'americanexpress', 87113774, 'Gudeg', 'STAFF-06');

CALL insert_order_item('20240303002', '2024-03-03', '10:27:19', 'card', '3723-0139-1287-8790', 'americanexpress', 95961010, 'Rendang', 'STAFF-08');

CALL insert_order_item('20240303006', '2024-03-03', '17:06:40', 'card', '5100-1730-4728-0832', 'mastercard', 96537349, 'Sauerbraten', 'STAFF-12');

CALL insert_order_item('20240304001', '2024-03-04', '10:03:52', 'card', '3742-8375-6443-8590', 'americanexpress', 93603800, 'Rendang', 'STAFF-05');

CALL insert_order_item('20240304002', '2024-03-04', '10:54:51', 'card', '5100-1431-0442-7071', 'mastercard', 87433248, 'Rendang', 'STAFF-06');

CALL insert_order_item('20240304004', '2024-03-04', '14:04:38', 'card', '3481-6980-7796-5230', 'americanexpress', 98216900, 'Thunder Tea Rice', 'STAFF-08');

CALL insert_order_item('20240305001', '2024-03-05', '09:59:53', 'card', '3742-8375-6443-8590', 'americanexpress', 93603800, 'Rendang', 'STAFF-09');

CALL insert_order_item('20240305002', '2024-03-05', '14:34:56', 'card', '3742-8889-7783-4510', 'americanexpress', 95624750, 'Rendang', 'STAFF-10');

CALL insert_order_item('20240306003', '2024-03-06', '14:52:02', 'card', '5580-9476-7037-6028', 'mastercard', 93344468, 'Palak Paneer', 'STAFF-12');

CALL insert_order_item('20240307006', '2024-03-07', '15:41:29', 'card', '4041-5976-8082-0030', 'visa', 83187835, 'Rinderrouladen', 'STAFF-02');