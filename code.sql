-- CREATE SCHEMA reatilshop;
-- USE retailshop ;

-- Defining a new colunm and its meta data
ALTER TABLE online_retail
ADD COLUMN manufacturers VARCHAR(50) NOT NULL ;

-- distribution of order values across all customers in the dataset
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalOrderValue
FROM online_retail
GROUP BY CustomerID;





# How many unique products has each customer purchased?
SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueProductsPurchased
FROM online_retail
GROUP BY CustomerID;



# Which customers have only made a single purchase from the company?
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS NumberOfPurchases, SUM(Quantity) AS totalquantitypurchased
FROM online_retail
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) = 1;




# Which products are most commonly purchased together by customers in the dataset?
SELECT GROUP_CONCAT(DISTINCT Description) AS Products,
       COUNT(*) AS Count_Products
FROM online_retail
GROUP BY InvoiceNo
HAVING COUNT(*) > 1
LIMIT 25;



# Subqueries
# Query 6: Customer Segmentation by Purchase Frequency
# identify your most loyal customers and those who need more attention.
SELECT CustomerID,
       CASE
           WHEN COUNT(DISTINCT InvoiceNo) >= 10 THEN 'High'
           WHEN COUNT(DISTINCT InvoiceNo) >= 5 THEN 'Medium'
           ELSE 'Low'
       END AS Purchase_Segment
FROM online_retail
GROUP BY CustomerID;

# Query 7: Average Order Value by Country
SELECT Country,
AVG(Order_Values) AS Avg_Order_Values
FROM (
    SELECT Country, InvoiceNo, SUM(Quantity * UnitPrice) AS Order_Values
    FROM online_retail
    GROUP BY Country, InvoiceNo
) AS total_Orders
GROUP BY Country
ORDER BY Avg_Order_Values DESC;

# Query 8: Customer analysis
SELECT CustomerID
FROM online_retail
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
HAVING MAX(InvoiceDate) < DATE_SUB(NOW(), INTERVAL 6 MONTH);

# Query 9: Product Affinity Analysis
# Determine which products are often purchased together by calculating the correlation between product purchases.
SELECT p1.Description AS Product1,p2.Description AS Product2, 
COUNT(DISTINCT o1.InvoiceNo) AS Correlation
FROM online_retial_data o1
JOIN online_retial_data o2 ON o1.InvoiceNo = o2.InvoiceNo AND o1.Description < o2.Description
JOIN online_retial_data p1 ON o1.InvoiceNo = p1.InvoiceNo AND p1.Description = o1.Description
JOIN online_retial_data p2 ON o2.InvoiceNo = p2.InvoiceNo AND p2.Description = o2.Description
GROUP BY Product1, Product2
ORDER BY Correlation DESC;

# Query 8: Time-based Analysis
# Explore trends in customer behavior over time, such as monthly or quarterly sales patterns.
SELECT YEAR(InvoiceDate) AS SalesYear,
       MONTH(InvoiceDate) AS SalesMonth,
       SUM(T_Price) AS TotalSales
FROM (
    SELECT InvoiceDate, SUM(Quantity * UnitPrice) AS T_Price
    FROM online_retial_data
    GROUP BY InvoiceDate
) AS T_Invoice
GROUP BY SalesYear, SalesMonth
ORDER BY SalesYear, SalesMonth;





