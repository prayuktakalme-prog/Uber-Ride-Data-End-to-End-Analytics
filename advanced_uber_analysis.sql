/*
Project: End-to-End Uber Ride Analytics
Author: [Your Name]
Tool: MySQL
Description: Advanced EDA covering Traffic Patterns, Customer Segmentation (RFM), and Revenue Intelligence.
*/

-- ==============================================================
-- SECTION 1: DATABASE SETUP & DATA SANITIZATION
-- ==============================================================
CREATE DATABASE IF NOT EXISTS uber_pro_analysis;
USE uber_pro_analysis;

-- 1.1 Data Structure Check
SELECT * FROM uber_data LIMIT 10;

-- 1.2 Identifying "Ghost" Records (Data Cleaning)
-- Records with no specific status or weird values need to be flagged.
SELECT COUNT(*) AS Invalid_Records 
FROM uber_data 
WHERE `Booking Status` IS NULL OR `Date` IS NULL;


-- ==============================================================
-- SECTION 2: TIME INTELLIGENCE (Seasonality & Trends)
-- ==============================================================

-- 2.1 Month-over-Month (MoM) Growth
-- Are we growing or shrinking? This is a key metric for investors.
SELECT 
    DATE_FORMAT(`Date`, '%Y-%m') AS Month,
    COUNT(`Booking ID`) AS Total_Rides,
    SUM(`Booking Value`) AS Total_Revenue,
    LAG(SUM(`Booking Value`)) OVER (ORDER BY DATE_FORMAT(`Date`, '%Y-%m')) AS Previous_Month_Revenue,
    (SUM(`Booking Value`) - LAG(SUM(`Booking Value`)) OVER (ORDER BY DATE_FORMAT(`Date`, '%Y-%m'))) / 
    LAG(SUM(`Booking Value`)) OVER (ORDER BY DATE_FORMAT(`Date`, '%Y-%m')) * 100 AS MoM_Growth_Pct
FROM uber_data
WHERE `Booking Status` = 'Completed'
GROUP BY Month;

-- 2.2 Time-of-Day Buckets (Morning Rush, Afternoon Lull, Night Party)
-- Instead of just hours, let's group them into logical business shifts.
SELECT 
    CASE 
        WHEN HOUR(`Time`) BETWEEN 6 AND 10 THEN 'Morning Rush'
        WHEN HOUR(`Time`) BETWEEN 11 AND 16 THEN 'Afternoon Hours'
        WHEN HOUR(`Time`) BETWEEN 17 AND 21 THEN 'Evening Peak'
        ELSE 'Night Shift'
    END AS Time_Slot,
    COUNT(`Booking ID`) AS Total_Rides,
    AVG(`Driver Ratings`) AS Avg_Rating
FROM uber_data
GROUP BY Time_Slot
ORDER BY Total_Rides DESC;


-- ==============================================================
-- SECTION 3: CUSTOMER INTELLIGENCE (RFM & Retention)
-- ==============================================================

-- 3.1 New vs. Repeat Customers
-- Are we getting loyal customers or just one-time users?
WITH CustomerFrequency AS (
    SELECT 
        `Customer ID`, 
        COUNT(`Booking ID`) AS Ride_Count
    FROM uber_data
    GROUP BY `Customer ID`
)
SELECT 
    CASE 
        WHEN Ride_Count = 1 THEN 'One-Time User'
        WHEN Ride_Count BETWEEN 2 AND 5 THEN 'Regular User'
        ELSE 'Loyal Power User'
    END AS Customer_Segment,
    COUNT(`Customer ID`) AS Total_Customers
FROM CustomerFrequency
GROUP BY Customer_Segment;

-- 3.2 Top 5 High-Value Customers (The "Whales")
-- These guys spend the most. Marketing should target them with offers.
SELECT 
    `Customer ID`,
    SUM(`Booking Value`) AS Lifetime_Value (LTV),
    AVG(`Customer Rating`) AS Avg_Feedback
FROM uber_data
WHERE `Booking Status` = 'Completed'
GROUP BY `Customer ID`
ORDER BY LTV DESC
LIMIT 5;


-- ==============================================================
-- SECTION 4: REVENUE ENGINEERING (Distance & Pricing)
-- ==============================================================

-- 4.1 Revenue by Distance Buckets (Short vs Long Haul)
-- Do we make more money from short trips or long trips?
SELECT 
    CASE 
        WHEN `Ride Distance` <= 10 THEN 'Short Trip (0-10km)'
        WHEN `Ride Distance` BETWEEN 10 AND 30 THEN 'Medium Trip (10-30km)'
        ELSE 'Long Trip (>30km)'
    END AS Trip_Category,
    COUNT(`Booking ID`) AS Total_Rides,
    SUM(`Booking Value`) AS Total_Revenue,
    AVG(`Booking Value`) AS Avg_Fare
FROM uber_data
WHERE `Booking Status` = 'Completed'
GROUP BY Trip_Category
ORDER BY Total_Revenue DESC;

-- 4.2 Average Revenue Per Kilometer (ARPK) by Vehicle
-- Which vehicle is the most efficient money-maker per km?
SELECT 
    `Vehicle Type`,
    SUM(`Booking Value`) / SUM(`Ride Distance`) AS Revenue_Per_Km
FROM uber_data
WHERE `Booking Status` = 'Completed'
GROUP BY `Vehicle Type`
ORDER BY Revenue_Per_Km DESC;


-- ==============================================================
-- SECTION 5: OPERATIONAL HEALTH (Cancellations & Ratings)
-- ==============================================================

-- 5.1 The "Cancellation Gap"
-- Comparing Customer vs Driver cancellations. Who cancels more?
SELECT 
    'Customer Cancelled' AS Cancellation_Type, COUNT(*) AS Count FROM uber_data WHERE `Booking Status` = 'Cancelled by Customer'
UNION
SELECT 
    'Driver Cancelled' AS Cancellation_Type, COUNT(*) AS Count FROM uber_data WHERE `Booking Status` = 'Cancelled by Driver';

-- 5.2 Ratings Correlation
-- Do lower-rated drivers have higher cancellation rates?
-- (This is a complex check requiring a subquery or CTE)
SELECT 
    ROUND(`Driver Ratings`, 0) AS Rating_Bucket,
    COUNT(*) AS Total_Rides,
    SUM(CASE WHEN `Booking Status` LIKE 'Cancelled%' THEN 1 ELSE 0 END) AS Cancelled_Rides,
    (SUM(CASE WHEN `Booking Status` LIKE 'Cancelled%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Cancellation_Rate
FROM uber_data
WHERE `Driver Ratings` IS NOT NULL
GROUP BY Rating_Bucket
ORDER BY Rating_Bucket DESC;

-- ==============================================================
-- END OF ANALYSIS
-- ==============================================================
