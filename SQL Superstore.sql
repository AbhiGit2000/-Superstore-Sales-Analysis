CREATE TABLE sales(Row_ID SERIAL,Order_ID VARCHAR(20),Order_Date DATE,Ship_Date DATE,
Ship_Mode VARCHAR(50),Customer_ID VARCHAR(20),Country VARCHAR(50),City VARCHAR(50),State VARCHAR(50),Postal_Code INT,
Product_ID VARCHAR(20),Sub_Category VARCHAR(50),Sales NUMERIC(10,2),Quantity INT,Discount NUMERIC(10,2),Profit NUMERIC(10,2));
 
COPY
sales(Row_ID,Order_ID,Order_Date,Ship_Date,Ship_Mode,Customer_ID,Country,City,State,Postal_Code,Product_ID,Sub_Category,Sales,Quantity,Discount,Profit)
FROM 'C:\Users\DELL\Downloads\Sales Table Superstore.csv'
DELIMITER','
CSV HEADER;

SELECT * FROM sales;


CREATE TABLE products(Product_ID VARCHAR(20),Product_Name VARCHAR(500),Category VARCHAR(50));

COPY
products(Product_ID,Product_Name,Category)
FROM 'C:\Users\DELL\Downloads\Products Table Superstore.csv'
DELIMITER','
CSV HEADER;

SELECT * FROM products;


CREATE TABLE customers(Customer_ID VARCHAR(20),Customer_Name VARCHAR(30),Segment VARCHAR(20),Region VARCHAR(10));

COPY
customers(Customer_ID, Customer_Name, Segment,Region)
FROM 'C:\Users\DELL\Downloads\Customers Table Superstore.csv'
DELIMITER','
CSV HEADER;

SELECT * FROM customers;

--Count of Orders
SELECT COUNT(DISTINCT(order_ID)) AS Total_orders
FROM sales ;

-- Number of Segments
SELECT DISTINCT segment 
FROM customers
LIMIT 10;

-- Total Sales Per State
SELECT State, SUM(sales)
FROM sales
GROUP BY State;

--Total Profit Per Category
SELECT p.category,SUM(s.profit) As Total_Profit
FROM sales s
JOIN products p ON s.product_ID=p.product_ID
GROUP BY p.category
Having SUM(s.profit)>0;

--Customerwise Total sales
SELECT c.customer_name,SUM(s.sales) AS Total_sales
FROM sales s
JOIN customers c ON s.customer_ID=c.customer_ID
GROUP BY c.customer_name;

--Top 5 Products Ranked by sales
SELECT p.product_name,
RANK() OVER(ORDER BY s.sales DESC) AS Sales_Rank
FROM sales s
JOIN products p ON s.product_ID=p.product_ID
LIMIT 5;

--Monthly Running Total sales
SELECT order_date,sales,
SUM(sales) OVER(ORDER BY order_date) AS Running_total_sales
FROM sales;

--Customer with Highest Total Purchase
SELECT c.customer_name,SUM(s.sales) AS Total_sales
FROM sales s 
JOIN customers c ON s.customer_ID=c.customer_ID
GROUP BY c.customer_name
HAVING SUM(s.sales)=(SELECT MAX(Total_sales)
FROM (SELECT c.customer_name,SUM(s.sales) AS Total_sales
FROM sales s 
JOIN customers c ON s.customer_ID=c.customer_ID
GROUP BY c.customer_name) 
);

--Total sales,Total orders,Average order price
SELECT COUNT(DISTINCT order_ID) AS Total_orders,SUM(sales) AS Total_sales,
ROUND(SUM(sales)/COUNT(DISTINCT order_ID),2) AS Average_order_value
FROM sales;

--Total Sales By Year
SELECT EXTRACT(YEAR FROM order_date) AS order_Year,SUM(sales) AS Total_sales
FROM sales
GROUP BY order_Year;

--Top 5 most profitable customers
SELECT c.customer_name,SUM(s.profit) AS Total_profit
FROM sales s
JOIN customers c ON s.customer_ID=c.customer_ID
GROUP BY c.customer_name
ORDER BY Total_profit DESC
LIMIT 5;




