CREATE SCHEMA star_schema;

-- Create Dimension Tables in the star_schema

-- Create BrandDim table first
CREATE TABLE star_schema.BrandDim (
    BrandID SERIAL PRIMARY KEY,
    BrandName VARCHAR(50)
);

-- Create CustomerDim table
CREATE TABLE star_schema.CustomerDim (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

-- Create PackageDim table
CREATE TABLE star_schema.PackageDim (
    PackageID SERIAL PRIMARY KEY,
    PackageName VARCHAR(100),
    Destination VARCHAR(100),
    DurationDays INT,
    Price DECIMAL(10, 2)
);

-- Create DriverDim table
CREATE TABLE star_schema.DriverDim (
    DriverID SERIAL PRIMARY KEY,
    DriverName VARCHAR(50),
    LicenseNumber VARCHAR(20),
    ExperienceYears INT,
    Phone VARCHAR(15)
);

-- Create BusDim table, with reference to BrandDim
CREATE TABLE star_schema.BusDim (
    BusID SERIAL PRIMARY KEY,
    BusNumber VARCHAR(20),
    Capacity INT,
    Model VARCHAR(50),
    BrandID INT,
    FOREIGN KEY (BrandID) REFERENCES star_schema.BrandDim(BrandID)
);

-- Create DateDim table
CREATE TABLE star_schema.DateDim (
    DateKey INT PRIMARY KEY,
    Date DATE,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT,
    Week INT,
    DayOfWeek INT,
    IsHoliday BOOLEAN
);

-- Create TravelOrderFact table with references to dimension tables
CREATE TABLE star_schema.TravelOrderFact (
    OrderItemID SERIAL PRIMARY KEY,
    OrderID INT,
    CustomerID INT,
    OrderDateKey INT,
    OrderStatus VARCHAR(20),
    TotalAmount DECIMAL(10, 2),
    PackageID INT,
    DriverID INT,
    BusID INT,
    QuantityPassenger INT,
    TravelDuration INT,
    FOREIGN KEY (CustomerID) REFERENCES star_schema.CustomerDim(CustomerID),
    FOREIGN KEY (PackageID) REFERENCES star_schema.PackageDim(PackageID),
    FOREIGN KEY (DriverID) REFERENCES star_schema.DriverDim(DriverID),
    FOREIGN KEY (BusID) REFERENCES star_schema.BusDim(BusID),
    FOREIGN KEY (OrderDateKey) REFERENCES star_schema.DateDim(DateKey)
);

-- Populate the Date Dimension
INSERT INTO star_schema.DateDim (DateKey, Date, Year, Quarter, Month, Day, Week, DayOfWeek, IsHoliday)
SELECT 
    to_char(d, 'YYYYMMDD')::int AS DateKey,
    d::date AS Date,
    extract(year from d) AS Year,
    extract(quarter from d) AS Quarter,
    extract(month from d) AS Month,
    extract(day from d) AS Day,
    extract(week from d) AS Week,
    extract(isodow from d) AS DayOfWeek,
    CASE WHEN d = date '2024-01-01' THEN true ELSE false END AS IsHoliday
FROM 
    generate_series('2023-01-01'::date, '2024-12-31'::date, '1 day'::interval) d;

-- Populate the Dimension Tables

-- Populate BrandDim
INSERT INTO star_schema.BrandDim (BrandID, BrandName)
SELECT BrandID, BrandName FROM public.Brand;

-- Populate BusDim
INSERT INTO star_schema.BusDim (BusID, BusNumber, Capacity, Model, BrandID)
SELECT BusID, BusNumber, Capacity, Model, BrandID FROM public.Bus;

-- Populate CustomerDim
INSERT INTO star_schema.CustomerDim (CustomerID, FirstName, LastName, Email, Phone, Address)
SELECT CustomerID, FirstName, LastName, Email, Phone, Address FROM public.Customer;

-- Populate PackageDim
INSERT INTO star_schema.PackageDim (PackageID, PackageName, Destination, DurationDays, Price)
SELECT PackageID, PackageName, Destination, DurationDays, Price FROM public.Package;

-- Populate DriverDim
INSERT INTO star_schema.DriverDim (DriverID, DriverName, LicenseNumber, ExperienceYears, Phone)
SELECT DriverID, DriverName, LicenseNumber, ExperienceYears, Phone FROM public.Driver;

-- Populate the Fact Table
INSERT INTO star_schema.TravelOrderFact (
    OrderID, 
    CustomerID, 
    OrderDateKey, 
    OrderStatus, 
    TotalAmount, 
    PackageID, 
    DriverID, 
    BusID, 
    QuantityPassenger, 
    TravelDuration
)
SELECT 
    oi.OrderID,
    o.CustomerID,
    to_char(o.OrderDate, 'YYYYMMDD')::int AS OrderDateKey,
    o.OrderStatus,
    o.TotalAmount,
    oi.PackageID,
    oi.DriverID,
    oi.BusID,
    oi.QuantityPassenger,
    oi.TravelDuration
FROM 
    public.OrderItem oi
JOIN 
    public.TravelOrders o ON oi.OrderID = o.OrderID;
