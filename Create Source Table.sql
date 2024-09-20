CREATE TABLE Customer (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(30),
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

CREATE TABLE Package (
    PackageID SERIAL PRIMARY KEY,
    PackageName VARCHAR(30),
    Destination VARCHAR(20),
    DurationDays INT,
    Price DECIMAL(10, 2)
);

CREATE TABLE Driver (
    DriverID SERIAL PRIMARY KEY,
    DriverName VARCHAR(50),
    LicenseNumber VARCHAR(20),
    ExperienceYears INT,
    Phone VARCHAR(15)
);

CREATE TABLE Brand (
    BrandID SERIAL PRIMARY KEY,
    BrandName VARCHAR(50)
);

CREATE TABLE Bus (
    BusID SERIAL PRIMARY KEY,
    BusNumber VARCHAR(20),
    Capacity INT,
    Model VARCHAR(50),
    BrandID INT
);


CREATE TABLE TravelOrders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT,
    OrderDate TIMESTAMP,
    OrderStatus VARCHAR(20),
    TotalAmount DECIMAL(10, 2)
);

CREATE TABLE OrderItem (
    OrderItemID SERIAL PRIMARY KEY,
    OrderID INT,
    PackageID INT,
    DriverID INT,
    BusID INT,
    QuantityPassenger INT,
    TravelDuration INT
);
