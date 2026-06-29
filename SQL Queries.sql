CREATE DATABASE RetailDW;
GO

USE RetailDW;
GO

/* Create FactSales Table from Sales 1997 Data */

SELECT *INTO FactSales FROM [Sales 1997];


/* Append Sales 1998 Records to FactSales */
INSERT INTO FactSales SELECT * FROM "Sales 1998";

/* Verify Total Number of Records in FactSales */
SELECT COUNT(*) FROM FactSales;


/* Create Primary Key for Customers Table */

ALTER TABLE Customers ADD CONSTRAINT PK_Customers PRIMARY KEY (customer_id);


/* Create Primary Key for Products Table */
ALTER TABLE Products ADD CONSTRAINT PK_Products PRIMARY KEY (product_id);

/* Create Primary Key for Stores Table */
ALTER TABLE Stores ADD CONSTRAINT PK_Stores PRIMARY KEY (store_id);

/* Create Primary Key for Region Table */
ALTER TABLE Region ADD CONSTRAINT PK_Region PRIMARY KEY (region_id);

/* Create Primary Key for Calendar Table */

ALTER TABLE Calendar ADD CONSTRAINT PK_Calendar PRIMARY KEY ([date]);

/* Verify Column Names in Calendar Table */

SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Calendar';

/* Create Foreign Key Relationship Between Stores and Region */

ALTER TABLE Stores ADD CONSTRAINT FK_Stores_Region FOREIGN KEY (region_id) REFERENCES Region(region_id);

/* Create Foreign Key Relationship Between FactSales and Products */

ALTER TABLE FactSales ADD CONSTRAINT FK_FactSales_Product FOREIGN KEY (product_id) REFERENCES Products(product_id);

/* Create Foreign Key Relationship Between FactSales and Customers */

ALTER TABLE FactSales ADD CONSTRAINT FK_FactSales_Customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);

/* Create Foreign Key Relationship Between FactSales and Stores */

ALTER TABLE FactSales ADD CONSTRAINT FK_FactSales_Store FOREIGN KEY (store_id) REFERENCES Stores(store_id);

/* Create Foreign Key Relationship Between Returns and Products */

ALTER TABLE Returns ADD CONSTRAINT FK_Returns_Product FOREIGN KEY (product_id) REFERENCES Products(product_id);

/* Create Foreign Key Relationship Between Returns and Stores */

ALTER TABLE Returns ADD CONSTRAINT FK_Returns_Store FOREIGN KEY (store_id) REFERENCES Stores(store_id);


/* convert coulmns to int to execute the queries right  */
ALTER TABLE FactSales
ALTER COLUMN quantity INT;

ALTER TABLE Returns
ALTER COLUMN quantity INT;

/* to ensure that convert right*/
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='FactSales'
AND COLUMN_NAME='quantity';

/*execution of quieres*/

/* Total Quantity Sold */

SELECT SUM(quantity) AS Total_Quantity_Sold
FROM FactSales;

/* Top 10 Products using join ,sum , order by,group by*/
SELECT TOP 10
       p.product_name,
       SUM(f.quantity) AS Total_Sold
FROM FactSales f
JOIN Products p
ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY Total_Sold DESC;


/*Top Stores*/

SELECT
       s.store_name,
       SUM(f.quantity) AS Total_Sales
FROM FactSales f
JOIN Stores s
ON f.store_id = s.store_id
GROUP BY s.store_name
ORDER BY Total_Sales DESC;

/*Sales by Region*/

SELECT
       r.sales_region,
       SUM(f.quantity) AS Total_Sales
FROM FactSales f
JOIN Stores s
ON f.store_id = s.store_id
JOIN Region r
ON s.region_id = r.region_id
GROUP BY r.sales_region
ORDER BY Total_Sales DESC;


/* Total Returned Quantity*/

SELECT SUM(quantity) AS Total_Returns
FROM Returns;

/*Most Returned Products*/

SELECT TOP 10
       p.product_name,
       SUM(r.quantity) AS Returned_Qty
FROM Returns r
JOIN Products p
ON r.product_id = p.product_id
GROUP BY p.product_name
ORDER BY Returned_Qty DESC;

/*sales by year*/

SELECT
       YEAR(transaction_date) AS Sales_Year,
       SUM(quantity) AS Total_Sales
FROM FactSales
GROUP BY YEAR(transaction_date)
ORDER BY Sales_Year;




/*View 1: Sales Details
تجمع FactSales مع Customers و Products و Stores
*/

CREATE VIEW vw_SalesDetails AS
SELECT
    f.transaction_date,
    f.product_id,
    p.product_name,
    p.product_brand,
    f.customer_id,
    c.first_name,
    c.last_name,
    f.store_id,
    s.store_name,
    f.quantity
FROM FactSales f
JOIN Products p
    ON f.product_id = p.product_id
JOIN Customers c
    ON f.customer_id = c.customer_id
JOIN Stores s
    ON f.store_id = s.store_id;
	Go

	/*Sales by Region*/

CREATE VIEW vw_SalesByRegion AS
SELECT
    r.sales_region,
    SUM(f.quantity) AS Total_Sales
FROM FactSales f
JOIN Stores s
    ON f.store_id = s.store_id
JOIN Region r
    ON s.region_id = r.region_id
GROUP BY r.sales_region;
GO

/*Product Performance*/
CREATE VIEW vw_ProductPerformance AS
SELECT
    p.product_name,
    p.product_brand,
    SUM(f.quantity) AS Total_Sold
FROM FactSales f
JOIN Products p
    ON f.product_id = p.product_id
GROUP BY
    p.product_name,
    p.product_brand;
GO

	/*Returns Analysis*/
	CREATE VIEW vw_ReturnsAnalysis AS
SELECT
    p.product_name,
    SUM(r.quantity) AS Returned_Qty
FROM Returns r
JOIN Products p
    ON r.product_id = p.product_id
GROUP BY p.product_name;

Go





