-- section 1 : Database and table creation 
-- create the database for the Starbucks Project 

CREATE Database StarbucksDB ; 

USE StarbucksDB; 

-- verity the selected database. 
SELECT Database () AS SelectedDatabase; 

-- Create the Customer table. 
CREATE TABLE Customer ( 
       CustomerID INT PRIMARY KEY,
       CustomerName VARCHAR(100) NOT NULL, 
       PhoneNumber VARCHAR(20) NOT NULL,
       Email VARCHAR(100) UNIQUE
       ); 
       
-- verify the customer table structure. 
describe Customer ; 

-- Create the employee table. 
CREATE TABLE Employee ( 
       EmployeeID INT PRIMARY KEY, 
       EmployeeName VARCHAR(100) NOT NULL,
       JobPosition VARCHAR(50) NOT NULL, 
       PhoneNumber VARCHAR(20) NOT NULL, 
       Salary DECIMAL(10,2) NOT NULL,
       CONSTRAINT chk_employee_salary CHECK ( Salary > 0 )
       ); 
       
-- verify the employee table structure.
describe Employee ; 

-- display the full defination, including the CHECK constraint. 
SHOW CREATE TABLE Employee; 

-- Create the MenuItem table.
CREATE TABLE MenuItem (
       MenuItemID INT PRIMARY KEY,
       ItemName VARCHAR(100) NOT NULL UNIQUE,
       Category VARCHAR(30) NOT NULL,
       Price DECIMAL(10,2) NOT NULL,
       AvailabilityStatus VARCHAR(20) NOT NULL DEFAULT 'Available',
       
       CONSTRAINT chk_menu_category
		   CHECK (Category IN ('Coffee', 'Tea', 'Other Beverage', 'Food')),
		
	   CONSTRAINT chk_menu_price
          CHECK (Price > 0 ),
		
        CONSTRAINT chk_menu_availability
		  CHECK (AvailabilityStatus IN ('Available', 'Unvailable'))
          ); 
          
describe MenuItem ; 

ALTER TABLE MenuItem
RENAME COLUMN MenuItem TO MenuItemID ; 

SHOW CREATE TABLE MenuItem; 

-- create the Customerorder table.
CREATE TABLE CustomerOrder ( 
       OrderID INT PRIMARY KEY,
       CustomerID INT NOT NULL, 
       EmployeeID INT NOT NULL, 
       OrderDate DATETIME NOT NULL,
       OrderStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',
       
       CONSTRAINT chk_order_status
           CHECK (OrderStatus IN ('Pending', 'completed', 'cancelled')),
		
	   CONSTRAINT fk_order_customer
           FOREIGN KEY (CustomerID)
           REFERENCES Customer(CustomerID)
           ON DELETE RESTRICT,
           
	   CONSTRAINT fk_order_employee
           FOREIGN KEY (EmployeeID)
           REFERENCES EMployee(EmployeeID)
           ON DELETE RESTRICT
	);
    
describe CustomerOrder ; 

SHOW CREATE TABLE CustomerOrder; 
		
-- create the table OrderItem table. 
CREATE TABLE OrderItem ( 
     OrderItemID INT PRIMARY KEY,
     OrderID INT NOT NULL,
     MenuItemID INT NOT NULL, 
     Quantity INT NOT NULL,
     UnitPrice DECIMAL(10,2) NOT NULL, 
     
     CONSTRAINT uq_order_menu
        UNIQUE (OrderID, MenuItemID),
        
	CONSTRAINT chk_orderitem_quantity
	    CHECK (Quantity > 0 ),
        
	CONSTRAINT chk_orderitem_price
	    CHECK (UnitPrice > 0 ),
	
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (OrderID)
        REFERENCES CustomerOrder(OrderID)
        ON DELETE RESTRICT, 
	
    CONSTRAINT fk_orderitem_menu
	    FOREIGN KEY (MenuItemID)
        REFERENCES MenuItem(MenuItemID)
        ON DELETE RESTRICT
	);
    
    describe OrderItem ; 
    
    SHOW CREATE TABLE OrderItem; 
	   
       
-- create payment table.
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    OrderID INT NOT NULL UNIQUE,
    PaymentDate DATETIME NOT NULL,
    PaymentMethod VARCHAR(20) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    
    CONSTRAINT chk_payment_method
       CHECK (PaymentMethod IN ('Cash', 'Cash', 'E-Wallet')),
       
	CONSTRAINT chk_payment_amount
       CHECK (Amount > 0 ),
       
	CONSTRAINT fk_paymet_order
       FOREIGN KEY (OrderID)
       REFERENCES CustomerOrder(OrderID)
       ON DELETE RESTRICT
	);
    
describe Payment ; 

SHOW CREATE TABLE Payment; 



SHOW TABLES ; 

-- section 2 : schema modification.
-- Allow customer names of up to 150 characters.
ALTER TABLE Customer
MODIFY COLUMN CustomerName VARCHAR(150) NOT NULL; 

describe Customer ; 

-- use a default quantity of 1 when quantity is omitted.
ALTER TABLE OrderItem
ALTER COLUMN Quantity SET DEFAULT 1;

describe OrderItem ; 

-- reject employee names that are empty or contain only space. 
ALTER TABLE Employee
ADD CONSTRAINT chk_employee_name
CHECK (CHAR_LENGTH(TRIM(EmployeeName)) > 0); 

SHOW CREATE TABLE Employee; 

-- section 3 : Sample data
-- Insert 15 Fictional customers. 
INSERT INTO Customer
      ( CustomerID, CustomerName, PhoneNumber, Email) 
VALUE 
     (1, 'Nur Aina', '0100000001', 'aina@example.com'),
    (2, 'Adam Hakimi', '0100000002', 'adam@example.com'),
    (3, 'Siti Balqis', '0100000003', 'balqis@example.com'),
    (4, 'Daniel Tan', '0100000004', 'daniel@example.com'),
    (5, 'Priya Nair', '0100000005', 'priya@example.com'),
    (6, 'Amir Danish', '0100000006', 'amir@example.com'),
    (7, 'Chloe Lim', '0100000007', 'chloe@example.com'),
    (8, 'Nur Iman', '0100000008', 'iman@example.com'),
    (9, 'Ravi Kumar', '0100000009', 'ravi@example.com'),
    (10, 'Farah Nadia', '0100000010', 'farah@example.com'),
    (11, 'Jason Lee', '0100000011', 'jason@example.com'),
    (12, 'Hana Sofea', '0100000012', 'hana@example.com'),
    (13, 'Muhammad Irfan', '0100000013', 'irfan@example.com'),
    (14, 'Mei Ling', '0100000014', 'meiling@example.com'),
    (15, 'Sara Yasmin', '0100000015', NULL);
    
-- Display the inserted customers. 
SELECT *
FROM Customer
ORDER BY CustomerID ; 

INSERT INTO Employee
       ( EmployeeID, EmployeeName, JobPosition, PhoneNumber, Salary)
VALUE 
	(1, 'Ahmad Faiz', 'Branch Manager', '0110000001', 4500.00),
    (2, 'Melissa Tan', 'Assistant Manager', '0110000002', 3500.00),
    (3, 'Nur Syafiqah', 'Shift Supervisor', '0110000003', 2800.00),
    (4, 'Kevin Lim', 'Shift Supervisor', '0110000004', 2800.00),
    (5, 'Aisyah Humaira', 'Barista', '0110000005', 2200.00),
    (6, 'Arjun Kumar', 'Barista', '0110000006', 2300.00),
    (7, 'Muhammad Haziq', 'Barista', '0110000007', 2100.00),
    (8, 'Rachel Lee', 'Barista', '0110000008', 2200.00),
    (9, 'Nur Amira', 'Barista', '0110000009', 2100.00),
    (10, 'Darren Wong', 'Barista', '0110000010', 2300.00),
    (11, 'Siti Maisarah', 'Cashier', '0110000011', 2000.00),
    (12, 'Adam Zikri', 'Cashier', '0110000012', 2000.00),
    (13, 'Kavitha Raj', 'Cashier', '0110000013', 2100.00),
    (14, 'Sofia Hana', 'Service Crew', '0110000014', 1900.00),
    (15, 'Benjamin Goh', 'Service Crew', '0110000015', 1900.00);

SELECT * 
FROM Employee
ORDER BY EmployeeID ; 

INSERT INTO MenuItem
     ( MenuItemID, ItemName, Category, Price, AvailabilityStatus)
VALUE 
	(1, 'Caffe Latte', 'Coffee', 15.00, 'Available'),
    (2, 'Cappuccino', 'Coffee', 15.00, 'Available'),
    (3, 'Caffe Americano', 'Coffee', 11.00, 'Available'),
    (4, 'Caramel Macchiato', 'Coffee', 17.00, 'Available'),
    (5, 'Caffe Mocha', 'Coffee', 17.00, 'Available'),
    (6, 'Espresso', 'Coffee', 9.00, 'Available'),
    (7, 'Green Tea Latte', 'Tea', 16.00, 'Available'),
    (8, 'Chai Tea Latte', 'Tea', 16.00, 'Available'),
    (9, 'English Breakfast Tea', 'Tea', 10.00, 'Available'),
    (10, 'Chocolate Cream Frappuccino', 'Other Beverage',
        18.00, 'Available'),
    (11, 'Vanilla Cream Frappuccino', 'Other Beverage',
        18.00, 'Available'),
    (12, 'Hot Chocolate', 'Other Beverage', 14.00, 'Available'),
    (13, 'Butter Croissant', 'Food', 8.00, 'Available'),
    (14, 'Blueberry Muffin', 'Food', 9.00, 'Available'),
    (15, 'Chocolate Cake', 'Food', 13.00, 'Unavailable');
    
SELECT * 
FROM MenuItem
ORDER BY MenuItemID ; 
    
-- repair the availability constraint.
ALTER TABLE MenuItem
DROP CHECK chk_menu_availability, 
ADD CONSTRAINT chk_menu_availability
    CHECK (AvailabilityStatus IN ('Available', 'Unavailable')); 
    
    
INSERT INTO CustomerOrder
    (OrderID, CustomerID, EmployeeID, OrderDate, OrderStatus)
VALUE 
	(1, 1, 11, '2026-09-21 09:00:00', 'Pending'),
    (2, 2, 12, '2026-09-21 09:30:00', 'Pending'),
    (3, 3, 13, '2026-09-21 10:15:00', 'Pending'),
    (4, 4, 11, '2026-09-22 08:45:00', 'Pending'),
    (5, 5, 12, '2026-09-22 11:00:00', 'Pending'),
    (6, 1, 13, '2026-09-22 14:20:00', 'Pending'),
    (7, 6, 11, '2026-09-23 09:10:00', 'Pending'),
    (8, 7, 12, '2026-09-23 12:30:00', 'Pending'),
    (9, 8, 13, '2026-09-23 15:00:00', 'Pending'),
    (10, 2, 11, '2026-09-24 08:30:00', 'Pending'),
    (11, 9, 12, '2026-09-24 10:45:00', 'Pending'),
    (12, 10, 13, '2026-09-24 13:15:00', 'Pending'),
    (13, 3, 11, '2026-09-25 09:20:00', 'Pending'),
    (14, 11, 12, '2026-09-25 11:40:00', 'Pending'),
    (15, 12, 13, '2026-09-25 16:00:00', 'Pending');
    
SELECT *
FROM CustomerOrder
ORDER BY OrderID ; 

INSERT INTO OrderItem
    (OrderItemID, OrderID, MenuItemID, Quantity, UnitPrice) 
VALUE
	(1, 1, 1, 2, 15.00),
    (2, 2, 4, 1, 17.00),
    (3, 3, 7, 2, 16.00),
    (4, 4, 3, 1, 11.00),
    (5, 5, 10, 2, 18.00),
    (6, 6, 1, 1, 15.00),
    (7, 7, 2, 2, 15.00),
    (8, 8, 8, 1, 16.00),
    (9, 9, 13, 3, 8.00),
    (10, 10, 4, 2, 17.00),
    (11, 11, 5, 1, 17.00),
    (12, 12, 12, 2, 14.00),
    (13, 13, 7, 1, 16.00),
    (14, 14, 14, 2, 9.00),
    (15, 15, 11, 1, 18.00);
    
SELECT * 
FROM OrderItem
ORDER BY OrderItemID ; 

SELECT OrderID, 
      SUM(Quantity * UnitPrice) AS OrderTotal
FROM OrderItem
GROUP BY OrderID
ORDER BY OrderID ; 

INSERT INTO Payment 
    (PaymentID, OrderID, PaymentDate, PaymentMethod, Amount) 
VALUE
	(1, 1, '2026-09-21 09:02:00', 'Card', 30.00),
    (2, 2, '2026-09-21 09:32:00', 'Cash', 17.00),
    (3, 3, '2026-09-21 10:17:00', 'E-Wallet', 32.00),
    (4, 4, '2026-09-22 08:47:00', 'Cash', 11.00),
    (5, 5, '2026-09-22 11:02:00', 'Card', 36.00),
    (6, 6, '2026-09-22 14:22:00', 'E-Wallet', 15.00),
    (7, 7, '2026-09-23 09:12:00', 'Card', 30.00),
    (8, 8, '2026-09-23 12:32:00', 'Cash', 16.00),
    (9, 9, '2026-09-23 15:02:00', 'E-Wallet', 24.00),
    (10, 10, '2026-09-24 08:32:00', 'Card', 34.00),
    (11, 11, '2026-09-24 10:47:00', 'Cash', 17.00),
    (12, 12, '2026-09-24 13:17:00', 'E-Wallet', 28.00),
    (13, 13, '2026-09-25 09:22:00', 'Card', 16.00),
    (14, 14, '2026-09-25 11:42:00', 'Cash', 18.00),
    (15, 15, '2026-09-25 16:02:00', 'E-Wallet', 18.00); 
    
    
SELECT * 
FROM Payment
ORDER BY PaymentID ; 

ALTER TABLE Payment 
RENAME COLUMN PayemntID TO PaymentID ; 

ALTER TABLE Payment
DROP CHECK chk_payment_method,
ADD CONSTRAINT chk_payment_method
    CHECK (PaymentMethod IN ('Cash', 'Card', 'E-Wallet')); 
    
    
-- section 4 : Update and Delete 
-- Display sample orders before updating.
SELECT OrderID, OrderStatus
FROM CustomerOrder
WHERE OrderID BETWEEN 1 AND 15 
ORDER BY OrderID ; 


-- Mark the fulfilled and paid sample orders as completed. 
UPDATE CustomerOrder
SET OrderStatus = 'Completed'
WHERE OrderID BETWEEN 1 AND 15 
   AND OrderStatus = 'Pending'
   AND EXISTS (
	   SELECT 1 
       FROM Payment p 
       WHERE p.OrderID = CustomerOrder.OrderID
         AND p.Amount = (
              SELECT SUM(oi.Quantity * oi.UnitPrice)
              FROM OrderItem oi
              WHERE oi.OrderID = CustomerOrder.OrderID
              )
			);
            
            
-- add a temporary customer for the delete demostration. 
INSERT INTO Customer
   (CustomerID, CustomerName, PhoneNumber, Email)
VALUE 
   (16, 'Temporary Customer', '0100000016', 'temp@example.com');

SELECT * 
FROM Customer
WHERE CustomerID = 16; 

-- delete temporary customer who has no orders. 
DELETE FROM Customer
WHERE CustomerID = 16; 

SELECT *
FROM Customer
WHERE CustomerID = 16;

SELECT COUNT(*) AS TotalCustomers
FROM Customer ; 

-- section 5 : Views
-- Simplify access to order summeries.
CREATE VIEW OrderSummary AS
SELECT
    co.OrderID,
    co.OrderDate,
    c.CustomerName,
    e.EmployeeName,
    co.OrderStatus,
    SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
FROM CustomerOrder co
JOIN Customer c
    ON co.CustomerID = c.CustomerID
JOIN Employee e
    ON co.EmployeeID = e.EmployeeID
JOIN OrderItem oi
    ON co.OrderID = oi.OrderID
GROUP BY
    co.OrderID,
    co.OrderDate,
    c.CustomerName,
    e.EmployeeName,
    co.OrderStatus;

SELECT *
FROM OrderSummary 
ORDER BY OrderID ; 

-- Provide selected employee columns for a theoretical staff role.
CREATE VIEW EmployeePublicInfo AS
SELECT
    EmployeeID,
    EmployeeName,
    JobPosition
FROM Employee;

SELECT *
FROM EmployeePublicInfo
ORDER BY EmployeeID;

-- Section 6: DQL queries
-- Basic Query 1:
-- Which available coffee items have the lowest prices?
SELECT MenuItemID, ItemName, Category, Price
FROM MenuItem
WHERE Category = 'Coffee'
  AND AvailabilityStatus = 'Available'
ORDER BY Price ASC, ItemName ASC;

-- Basic Query 2:
-- Which payments are RM30 or more, ranked by amount?
SELECT PaymentID, OrderID, PaymentMethod, Amount
FROM Payment
WHERE Amount >= 30.00
ORDER BY Amount DESC, PaymentID ASC;

-- Basic Query 3:
-- Which employees are baristas, listed alphabetically?
SELECT EmployeeID, EmployeeName, JobPosition
FROM Employee
WHERE JobPosition = 'Barista'
ORDER BY EmployeeName ASC, EmployeeID ASC;

-- Basic Query 4:
-- Which completed orders were placed on 24 September 2026?
SELECT OrderID, CustomerID, EmployeeID, OrderDate, OrderStatus
FROM CustomerOrder
WHERE OrderStatus = 'Completed'
  AND OrderDate >= '2026-09-24 00:00:00'
  AND OrderDate < '2026-09-25 00:00:00'
ORDER BY OrderDate ASC, OrderID ASC;

-- Basic Query 5:
-- Which customers have provided an email address?
SELECT CustomerID, CustomerName, Email
FROM Customer
WHERE Email IS NOT NULL
ORDER BY CustomerName ASC, CustomerID ASC;

-- Aggregate Query 1:
-- How many completed orders and distinct ordering customers exist?
SELECT
    COUNT(*) AS CompletedOrders,
    COUNT(DISTINCT CustomerID) AS UniqueCustomers
FROM CustomerOrder
WHERE OrderStatus = 'Completed';

-- Aggregate Query 2:
-- What are the total, minimum, maximum and average payment amounts?
SELECT
    COUNT(*) AS TotalPayments,
    SUM(Amount) AS TotalPaymentAmount,
    MIN(Amount) AS MinimumPayment,
    MAX(Amount) AS MaximumPayment,
    ROUND(AVG(Amount), 2) AS AveragePayment
FROM Payment;

-- Grouping Query:
-- How many payments and how much money were received by each method?
SELECT
    PaymentMethod,
    COUNT(*) AS NumberOfPayments,
    SUM(Amount) AS TotalAmount
FROM Payment
GROUP BY PaymentMethod
ORDER BY TotalAmount DESC, PaymentMethod ASC;

-- HAVING Query:
-- Which customers have placed more than one completed order?
SELECT
    CustomerID,
    COUNT(*) AS NumberOfOrders
FROM CustomerOrder
WHERE OrderStatus = 'Completed'
GROUP BY CustomerID
HAVING COUNT(*) > 1
ORDER BY NumberOfOrders DESC, CustomerID ASC;

-- Subquery 1: Equality operator
-- Which menu items have the highest current price?
SELECT MenuItemID, ItemName, Price
FROM MenuItem
WHERE Price = (
    SELECT MAX(Price)
    FROM MenuItem
)
ORDER BY ItemName ASC;

-- Subquery 2: Nested IN
-- Which customers ordered coffee items in completed orders?
SELECT CustomerID, CustomerName
FROM Customer
WHERE CustomerID IN (
    SELECT CustomerID
    FROM CustomerOrder
    WHERE OrderStatus = 'Completed'
      AND OrderID IN (
          SELECT OrderID
          FROM OrderItem
          WHERE MenuItemID IN (
              SELECT MenuItemID
              FROM MenuItem
              WHERE Category = 'Coffee'
          )
      )
)
ORDER BY CustomerName ASC;

-- Subquery 3:
-- Which payments exceed the average payment amount?
SELECT PaymentID, OrderID, Amount
FROM Payment
WHERE Amount > (
    SELECT AVG(Amount)
    FROM Payment
)
ORDER BY Amount DESC, PaymentID ASC;

-- Join 1: Basic join with ORDER BY
-- Who placed each order, listed from most recent?
SELECT
    co.OrderID,
    c.CustomerName,
    co.OrderDate,
    co.OrderStatus
FROM CustomerOrder co
JOIN Customer c
    ON co.CustomerID = c.CustomerID
ORDER BY co.OrderDate DESC, co.OrderID DESC;

-- Join 2:
-- What payment details are recorded for each order?
SELECT
    co.OrderID,
    co.OrderDate,
    co.OrderStatus,
    p.PaymentMethod,
    p.Amount
FROM CustomerOrder co
JOIN Payment p
    ON co.OrderID = p.OrderID
ORDER BY co.OrderID ASC;

-- Join 3: Three-table join
-- How many units and how much revenue did each sold item generate?
SELECT
    m.MenuItemID,
    m.ItemName,
    SUM(oi.Quantity) AS UnitsSold,
    SUM(oi.Quantity * oi.UnitPrice) AS ItemRevenue
FROM MenuItem m
JOIN OrderItem oi
    ON m.MenuItemID = oi.MenuItemID
JOIN CustomerOrder co
    ON oi.OrderID = co.OrderID
WHERE co.OrderStatus = 'Completed'
GROUP BY m.MenuItemID, m.ItemName
ORDER BY ItemRevenue DESC, m.MenuItemID ASC;

-- Join 4: Complex four-table join
-- What menu items did each customer purchase in completed orders?
SELECT
    co.OrderID,
    co.OrderDate,
    c.CustomerName,
    m.ItemName,
    oi.Quantity,
    oi.UnitPrice,
    oi.Quantity * oi.UnitPrice AS LineTotal
FROM Customer c
JOIN CustomerOrder co
    ON c.CustomerID = co.CustomerID
JOIN OrderItem oi
    ON co.OrderID = oi.OrderID
JOIN MenuItem m
    ON oi.MenuItemID = m.MenuItemID
WHERE co.OrderStatus = 'Completed'
ORDER BY co.OrderDate ASC, co.OrderID ASC, oi.OrderItemID ASC;