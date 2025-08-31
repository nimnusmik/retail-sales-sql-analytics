-- Retail Sales Analysis SQL Project

-- Database Setup
SELECT datname FROM pg_database WHERE datistemplate = false;
CREATE DATABASE sql_project;

SELECT current_database();
SELECT current_user;

-- Create Table
DROP TABLE IF EXISTS retail_sales; 

CREATE TABLE retail_sales(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15), 
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- Initial Data Exploration
SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

-- Fix Column Name Typo
ALTER TABLE retail_sales 
RENAME COLUMN quantiy TO quantity;

-- Data Quality Check - Check for NULL values

-- Check individual columns for NULL values
SELECT * FROM retail_sales WHERE transactions_id IS NULL;
SELECT * FROM retail_sales WHERE sale_date IS NULL;
SELECT * FROM retail_sales WHERE sale_time IS NULL;

-- Check all columns for NULL values
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL 
    OR sale_time IS NULL 
    OR customer_id IS NULL
    OR gender IS NULL
    OR category IS NULL 
    OR quantity IS NULL 
    OR price_per_unit IS NULL 
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Data Cleaning - Remove rows with NULL values
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL 
    OR sale_time IS NULL 
    OR customer_id IS NULL
    OR gender IS NULL
    OR category IS NULL 
    OR quantity IS NULL 
    OR price_per_unit IS NULL 
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Verify data count after cleaning
SELECT COUNT(*) FROM retail_sales;

-- Data Exploration

-- Total number of sales
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- Number of unique categories
SELECT COUNT(DISTINCT category) AS unique_categories FROM retail_sales;

-- List all categories
SELECT DISTINCT category FROM retail_sales;

-- ===========================================
-- Data Analysis & Business Key Problems & Solutions
-- ===========================================

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category
SELECT
    category,
    SUM(total_sale) AS total_revenue,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT
    AVG(age) AS average_age,
    COUNT(*) AS total_customers
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        COUNT(total_sale) AS total_sales,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
    ORDER BY year, avg_sale DESC
) AS ranked_months
WHERE rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

-- Incorrect approach (returns individual transactions, not customer totals)
SELECT customer_id, total_sale
FROM retail_sales 
ORDER BY total_sale DESC
LIMIT 5;

-- Correct approach (aggregates sales by customer)
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales 
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales 
GROUP BY category;

-- Q.9-1 Write a SQL query to find customers who have purchased items from exactly 3 different categories

-- Complex approach using subquery
SELECT DISTINCT customer_id
FROM (
    SELECT DISTINCT customer_id, category, COUNT(category)
    FROM retail_sales
    GROUP BY customer_id, category
    ORDER BY customer_id
) AS temp
GROUP BY customer_id
HAVING COUNT(DISTINCT category) = 3;

-- Simplified approach (recommended)
SELECT customer_id
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT category) = 3;

-- Q.10 Write a SQL query to create each shift and number of orders 
-- (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Using CTE (Common Table Expression)
WITH hourly_sales AS (
    SELECT *, 
        CASE 
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift, 
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;

-- Using Subquery (alternative approach)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
) AS hourly_sales
GROUP BY shift;