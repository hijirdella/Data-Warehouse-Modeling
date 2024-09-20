-- Insert dummy data into Customer Table
INSERT INTO Customer (FirstName, LastName, Email, Phone, Address)
VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Elm St'),
('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', '456 Oak St'),
('Alice', 'Johnson', 'alice.johnson@example.com', '555-123-4567', '789 Pine St'),
('Bob', 'Brown', 'bob.brown@example.com', '555-987-6543', '101 Maple St'),
('Charlie', 'Davis', 'charlie.davis@example.com', '555-567-8901', '102 Birch St'),
('Eva', 'Wilson', 'eva.wilson@example.com', '555-890-1234', '103 Cedar St'),
('Frank', 'Garcia', 'frank.garcia@example.com', '555-456-7890', '104 Willow St'),
('Grace', 'Martinez', 'grace.martinez@example.com', '555-321-6549', '105 Ash St'),
('Hannah', 'Taylor', 'hannah.taylor@example.com', '555-654-3210', '106 Cherry St'),
('Ian', 'Anderson', 'ian.anderson@example.com', '555-789-0123', '107 Spruce St');
-- Insert dummy data into Brand Table
INSERT INTO Brand (BrandName)
VALUES
('Mercedes-Benz'),
('Volvo'),
('Scania'),
('MAN'),
('Iveco'),
('Renault'),
('DAF'),
('Setra'),
('Van Hool'),
('Neoplan');
-- Insert dummy data into Bus Table
INSERT INTO Bus (BusNumber, Capacity, Model, BrandID)
VALUES
('BUS123', 50, 'Model X', 1),
('BUS124', 60, 'Model Y', 2),
('BUS125', 55, 'Model Z', 3),
('BUS126', 45, 'Model A', 4),
('BUS127', 70, 'Model B', 5),
('BUS128', 65, 'Model C', 6),
('BUS129', 75, 'Model D', 7),
('BUS130', 40, 'Model E', 8),
('BUS131', 80, 'Model F', 9),
('BUS132', 90, 'Model G', 10);
-- Insert dummy data into Driver Table
INSERT INTO Driver (DriverName, LicenseNumber, ExperienceYears, Phone)
VALUES
('Jack Thompson', 'DL123456789', 10, '555-101-2020'),
('Lily Evans', 'DL987654321', 8, '555-202-3030'),
('Mia Adams', 'DL555555555', 12, '555-303-4040'),
('Noah Robinson', 'DL444444444', 15, '555-404-5050'),
('Olivia Martinez', 'DL333333333', 7, '555-505-6060'),
('Paul Walker', 'DL222222222', 9, '555-606-7070'),
('Quinn White', 'DL111111111', 11, '555-707-8080'),
('Rachel Green', 'DL666666666', 14, '555-808-9090'),
('Sam Harris', 'DL777777777', 6, '555-909-1010'),
('Tina Brooks', 'DL888888888', 13, '555-101-2021');
-- Insert dummy data into Package Table
INSERT INTO Package (PackageName, Destination, DurationDays, Price)
VALUES
('Holiday Package A', 'Paris', 7, 999.99),
('Holiday Package B', 'London', 5, 799.99),
('Holiday Package C', 'Rome', 6, 899.99),
('Holiday Package D', 'Berlin', 4, 699.99),
('Holiday Package E', 'Madrid', 8, 1099.99),
('Holiday Package F', 'Lisbon', 5, 749.99),
('Holiday Package G', 'Prague', 7, 949.99),
('Holiday Package H', 'Vienna', 6, 849.99),
('Holiday Package I', 'Budapest', 4, 649.99),
('Holiday Package J', 'Amsterdam', 5, 799.99);
-- Insert 100 dummy data into Travel Orders Table using random data
DO
$$
BEGIN
   FOR i IN 1..100 LOOP
       INSERT INTO TravelOrders (CustomerID, OrderDate, OrderStatus, TotalAmount)
       VALUES (
           (SELECT CustomerID FROM Customer ORDER BY RANDOM() LIMIT 1),
           NOW() - INTERVAL '1 day' * (RANDOM() * 365)::int,
           (ARRAY['confirmed', 'pending', 'canceled'])[floor(random() * 3 + 1)],
           round((RANDOM() * 1000)::numeric, 2)
       );
   END LOOP;
END
$$;
-- Insert at least 200 dummy data into Order Item Table using random data
DO
$$
BEGIN
   FOR i IN 1..200 LOOP
       INSERT INTO OrderItem (OrderID, PackageID, DriverID, BusID, QuantityPassenger, TravelDuration)
       VALUES (
           (SELECT OrderID FROM TravelOrders ORDER BY RANDOM() LIMIT 1),
           (SELECT PackageID FROM Package ORDER BY RANDOM() LIMIT 1),
           (SELECT DriverID FROM Driver ORDER BY RANDOM() LIMIT 1),
           (SELECT BusID FROM Bus ORDER BY RANDOM() LIMIT 1),
           floor(random() * 10 + 1),
           floor(random() * 24 + 1)
       );
   END LOOP;
END
$$;
