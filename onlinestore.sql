
show databases ;
use company ;
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(15)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    contact_phone VARCHAR(15)
);

INSERT INTO Products (product_id, product_name, category, price, stock_quantity)
VALUES 
(1, 'Laptop', 'Electronics', 1200.00, 10),
(2, 'Smartphone', 'Electronics', 800.00, 15),
(3, 'Tablet', 'Electronics', 500.00, 20),
(4, 'Headphones', 'Accessories', 100.00, 50),
(5, 'Keyboard', 'Accessories', 50.00, 30);

INSERT INTO Customers (customer_id, first_name, last_name, email, address, phone_number)
VALUES 
(1, 'John', 'Doe', 'john.doe@example.com', '123 Main St', '555-1234'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '456 Oak St', '555-5678'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', '789 Pine St', '555-8765');

INSERT INTO Orders (order_id, customer_id, order_date, total_amount)
VALUES 
(1, 1, '2024-08-01', 1300.00),
(2, 2, '2024-08-02', 800.00),
(3, 3, '2024-08-03', 600.00);
INSERT INTO Order_Details (order_detail_id, order_id, product_id, quantity, price)
VALUES 
(1, 1, 1, 1, 1200.00),
(2, 1, 4, 1, 100.00),
(3, 2, 2, 1, 800.00),
(4, 3, 3, 1, 500.00),
(5, 3, 4, 1, 100.00);
 
SELECT p.product_name, SUM(od.quantity * od.price) AS total_sales
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_name;

SELECT c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

SELECT product_name, stock_quantity
FROM Products
WHERE stock_quantity < 10;

SELECT o.order_id, c.first_name, c.last_name, p.product_name, od.quantity, od.price
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
JOIN Customers c ON o.customer_id = c.customer_id;

SELECT AVG(total_amount) AS average_order_value
FROM Orders;

ALTER TABLE Products ADD supplier_id INT;
ALTER TABLE Products ADD FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id);

DELIMITER $$

CREATE TRIGGER update_stock
AFTER INSERT ON Order_Details
FOR EACH ROW
BEGIN
    UPDATE Products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END$$

DELIMITER ;

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    discount_percentage DECIMAL(5, 2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('customer', 'admin'),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Shipping (
    shipping_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    shipping_date DATE,
    carrier VARCHAR(100),
    status ENUM('pending', 'shipped', 'delivered', 'returned'),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Suppliers (supplier_id, supplier_name, contact_name, contact_phone)
VALUES 
(1, 'TechWorld', 'Mark Spencer', '555-1234'),
(2, 'GadgetsHub', 'Sarah Lee', '555-5678'),
(3, 'Accessory Pro', 'Tom Allen', '555-8765');

INSERT INTO Reviews (product_id, customer_id, rating, review_text, review_date)
VALUES 
(1, 1, 5, 'Great laptop, very fast and reliable!', '2024-08-10'),
(2, 2, 4, 'Good smartphone, but battery life could be better.', '2024-08-12'),
(4, 3, 3, 'Average quality, but works well for the price.', '2024-08-15');

INSERT INTO Promotions (product_id, discount_percentage, start_date, end_date)
VALUES 
(1, 10.00, '2024-08-01', '2024-08-15'),
(2, 5.00, '2024-08-05', '2024-08-20'),
(4, 20.00, '2024-08-10', '2024-08-25');

INSERT INTO Shipping (order_id, shipping_date, carrier, status)
VALUES 
(1, '2024-08-02', 'UPS', 'shipped'),
(2, '2024-08-03', 'FedEx', 'delivered'),
(3, '2024-08-04', 'DHL', 'pending');

INSERT INTO Payments (order_id, payment_method, payment_date, amount_paid)
VALUES 
(1, 'credit_card', '2024-08-01', 1300.00),
(2, 'paypal', '2024-08-02', 800.00),
(3, 'bank_transfer', '2024-08-03', 600.00);


SHOW TABLES;
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_method ENUM('credit_card', 'paypal', 'bank_transfer', 'cash'),
    payment_date DATE,
    amount_paid DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Payments (order_id, payment_method, payment_date, amount_paid)
VALUES 
(1, 'credit_card', '2024-08-01', 1300.00),
(2, 'paypal', '2024-08-02', 800.00),
(3, 'bank_transfer', '2024-08-03', 600.00);

show tables;
DROP TABLE Departments, dept1, Employeees, Projects;

show tables;



DROP TABLE  Employees , mobile;
show tables;

USE company;
SHOW TABLES;

select * from 'Customers'
'Order_Details'
'Orders'
'Payments'
'Products'
'Promotions'
'Reviews'
'Shipping'
'Suppliers'
'Users'
 ;
SELECT * FROM Customers;
SELECT * FROM Order_Details;
SELECT * FROM Orders;
SELECT * FROM Payments;
SELECT * FROM Products;
SELECT * FROM Promotions;
SELECT * FROM Reviews;
SELECT * FROM Shipping;
SELECT * FROM Suppliers;
SELECT * FROM Users;

SELECT * FROM Products;
SELECT * FROM Order_Details;


INSERT INTO Users (customer_id, username, password_hash, role)
VALUES 
(1, 'john_doe', 'hashed_password1', 'customer'),
(2, 'jane_smith', 'hashed_password2', 'customer'),
(3, 'alice_johnson', 'hashed_password3', 'admin');

-- Query to find the most sold product
SELECT p.product_name, SUM(od.quantity) AS total_quantity_sold
FROM Order_Details od
-- Join with Products table to get product details
JOIN Products p ON od.product_id = p.product_id
-- Group by product name to calculate total quantity sold for each product
GROUP BY p.product_name
-- Order by total quantity sold in descending order
ORDER BY total_quantity_sold DESC
-- Limit the result to the top 1 item
LIMIT 1;

-- Query to calculate total spending by each customer
SELECT c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM Orders o
-- Join with Customers table to get customer details
JOIN Customers c ON o.customer_id = c.customer_id
-- Group by customer to calculate total spending
GROUP BY c.customer_id, c.first_name, c.last_name
-- Order by total spending in descending order
ORDER BY total_spent DESC;

-- Query to calculate total revenue for each product
SELECT p.product_name, SUM(od.quantity * od.price) AS total_revenue
FROM Order_Details od
-- Join with Products table to get product details
JOIN Products p ON od.product_id = p.product_id
-- Group by product name to calculate total revenue
GROUP BY p.product_name
-- Order by total revenue in descending order
ORDER BY total_revenue DESC;


-- Query to calculate average order value
SELECT AVG(total_amount) AS average_order_value
FROM Orders;

-- Query to list products with low stock (less than 10 units)
SELECT product_name, stock_quantity
FROM Products
-- Filter for products with stock less than 10
WHERE stock_quantity < 25;

-- Query to find customers who placed the most orders
SELECT c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM Orders o
-- Join with Customers table to get customer details
JOIN Customers c ON o.customer_id = c.customer_id
-- Group by customer to count the number of orders
GROUP BY c.customer_id
-- Order by total number of orders in descending order
ORDER BY total_orders DESC;

-- Query to find top-rated products based on average ratings
SELECT p.product_name, AVG(r.rating) AS average_rating
FROM Reviews r
-- Join with Products table to get product details
JOIN Products p ON r.product_id = p.product_id
-- Group by product name to calculate the average rating
GROUP BY p.product_name
-- Order by average rating in descending order
ORDER BY average_rating DESC;

-- Query to calculate sales during promotion periods
SELECT p.product_name, SUM(od.quantity * od.price) AS total_sales_during_promotion
FROM Order_Details od
-- Join with Products table to get product details
JOIN Products p ON od.product_id = p.product_id
-- Join with Promotions table to check for active promotions
JOIN Promotions promo ON promo.product_id = p.product_id
-- Filter for sales that happened during the promotion period
WHERE od.order_date BETWEEN promo.start_date AND promo.end_date
-- Group by product name to calculate sales
GROUP BY p.product_name;

-- Query to track shipping status of orders
SELECT o.order_id, c.first_name, c.last_name, s.status, s.shipping_date
FROM Shipping s
-- Join with Orders table to get order details
JOIN Orders o ON s.order_id = o.order_id
-- Join with Customers table to get customer details
JOIN Customers c ON o.customer_id = c.customer_id
-- Order by the shipping date in descending order
ORDER BY s.shipping_date DESC;

-- Query to calculate total revenue by payment method
SELECT p.payment_method, SUM(p.amount_paid) AS total_revenue
FROM Payments p
-- Group by payment method to calculate total revenue
GROUP BY p.payment_method
-- Order by total revenue in descending order
ORDER BY total_revenue DESC;

-- Query to calculate total sales by supplier
SELECT s.supplier_name, SUM(od.quantity * od.price) AS total_sales
FROM Order_Details od
-- Join with Products table to get product details
JOIN Products p ON od.product_id = p.product_id
-- Join with Suppliers table to get supplier details
JOIN Suppliers s ON p.supplier_id = s.supplier_id
-- Group by supplier name to calculate total sales
GROUP BY s.supplier_name
-- Order by total sales in descending order
ORDER BY total_sales DESC;

-- Query to find the most used payment method
SELECT payment_method, COUNT(*) AS total_payments
FROM Payments
-- Group by payment method to count the number of payments
GROUP BY payment_method
-- Order by total payments in descending order
ORDER BY total_payments DESC
-- Limit the result to the most popular payment method
LIMIT 1;
