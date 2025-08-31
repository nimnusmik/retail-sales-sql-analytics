# 📊 Retail Sales Data Analysis - SQL Project

A comprehensive SQL project analyzing retail sales data to uncover business insights, customer patterns, and sales performance metrics. This project demonstrates advanced SQL techniques including data cleaning, exploratory analysis, and complex business problem solving.

## 🎯 Project Objectives

- Perform comprehensive data cleaning and quality checks
- Analyze sales trends and customer behavior patterns
- Calculate key business metrics and KPIs
- Demonstrate proficiency in advanced SQL concepts

## 🗃️ Database Schema

The project uses a single table `retail_sales` with the following structure:

```sql
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
```

## 📋 Key Features

### Data Quality Management
- ✅ Comprehensive NULL value detection and cleaning
- ✅ Data type validation and schema corrections
- ✅ Data integrity checks

### Business Analytics
- 📈 Sales performance analysis by category, time period, and demographics
- 👥 Customer segmentation and behavior analysis
- ⏰ Time-based sales pattern identification
- 💰 Revenue and profitability metrics

## 🔍 Business Questions Answered

### 1. **Daily Sales Analysis**
```sql
-- Retrieve all sales for a specific date
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
```

### 2. **Product Category Performance**
```sql
-- Calculate total sales and orders by category
SELECT category, SUM(total_sale) AS total_revenue, COUNT(*) AS total_orders
FROM retail_sales GROUP BY category;
```

### 3. **Customer Demographics**
```sql
-- Average age of customers by category
SELECT AVG(age) AS average_age FROM retail_sales WHERE category = 'Beauty';
```

### 4. **High-Value Transactions**
```sql
-- Find transactions above $1000
SELECT * FROM retail_sales WHERE total_sale > 1000;
```

### 5. **Customer Segmentation**
```sql
-- Top 5 customers by total sales
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales GROUP BY customer_id
ORDER BY total_sales DESC LIMIT 5;
```

### 6. **Cross-Category Analysis**
```sql
-- Customers who purchased from all 3 categories
SELECT customer_id FROM retail_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT category) = 3;
```

### 7. **Time-Based Analysis**
```sql
-- Sales distribution by time of day (Morning/Afternoon/Evening)
WITH hourly_sales AS (
    SELECT *, 
        CASE 
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sales GROUP BY shift;
```

## 🛠️ SQL Techniques Demonstrated

### Core Concepts
- `SELECT`, `WHERE`, `GROUP BY`, `HAVING`
- `ORDER BY`, `LIMIT`
- Aggregate functions: `SUM()`, `COUNT()`, `AVG()`
- `DISTINCT` for unique value analysis

### Advanced Techniques
- **Common Table Expressions (CTEs)** for complex queries
- **Subqueries** for nested analysis
- **Window Functions** with `RANK()` and `PARTITION BY`
- **CASE statements** for conditional logic
- **Date/Time functions** with `EXTRACT()`

### Data Quality
- **NULL value handling** and data cleaning
- **Data type validation** and schema modifications
- **Comprehensive data auditing**

## 📊 Key Insights

- **Sales Performance**: Analysis of revenue distribution across different product categories
- **Customer Behavior**: Identification of high-value customers and purchasing patterns
- **Temporal Patterns**: Understanding of peak sales hours and seasonal trends
- **Cross-Category Engagement**: Analysis of customers shopping across multiple categories

## 🚀 Getting Started

### Prerequisites
- PostgreSQL (or any SQL-compatible database)
- Basic understanding of SQL concepts

### Setup Instructions

1. **Create Database**
   ```sql
   CREATE DATABASE sql_project;
   ```

2. **Create Table Structure**
   ```sql
   -- Run the CREATE TABLE statement from the main SQL file
   ```

3. **Load Data**
   ```sql
   -- Import your retail sales data
   ```

4. **Execute Analysis**
   ```sql
   -- Run the analysis queries step by step
   ```

## 📁 Project Structure

```
retail-sales-sql-analysis/
│
├── README.md                 # Project documentation
├── retail_sales_analysis.sql # Main SQL analysis file
└── sample_data/              # Sample dataset (if applicable)
```

## 🎓 Learning Outcomes

Through this project, you will gain expertise in:

- **Data Cleaning**: Systematic approach to identifying and handling data quality issues
- **Business Analytics**: Translating business questions into SQL queries
- **Advanced SQL**: Complex joins, subqueries, window functions, and CTEs
- **Performance Optimization**: Writing efficient queries for large datasets
- **Data Storytelling**: Deriving meaningful insights from raw data
