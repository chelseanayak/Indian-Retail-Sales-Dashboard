SELECT 
    COUNT(*) AS total_orders,
    ROUND(SUM(Net_Sales_INR), 2) AS total_net_sales,
    ROUND(SUM(Profit_INR), 2) AS total_profit,
    ROUND((SUM(Profit_INR) / SUM(Net_Sales_INR)) * 100, 2) AS profit_margin_pct
FROM sales_data;

SELECT 
    Region,
    ROUND(SUM(Net_Sales_INR), 2) AS regional_sales,
    ROUND(SUM(Profit_INR), 2) AS regional_profit,
    ROUND((SUM(Profit_INR) / SUM(Net_Sales_INR)) * 100, 2) AS margin_pct
FROM sales_data
GROUP BY Region
ORDER BY regional_sales DESC;

SELECT 
    Category,
    COUNT(*) AS order_count,
    ROUND(SUM(Net_Sales_INR), 2) AS category_sales,
    ROUND(SUM(Profit_INR), 2) AS category_profit
FROM sales_data
GROUP BY Category
ORDER BY category_sales DESC;

SELECT 
    Region,
    Category,
    ROUND(SUM(Net_Sales_INR), 2) AS sales,
    ROUND(SUM(Profit_INR), 2) AS profit
FROM sales_data
GROUP BY Region, Category
ORDER BY profit DESC
LIMIT 10;

SELECT 
    Region,
    Category,
    COUNT(*) AS order_count,
    ROUND(SUM(Net_Sales_INR), 2) AS total_sales,
    ROUND(SUM(Profit_INR), 2) AS total_profit,
    ROUND((SUM(Profit_INR) / SUM(Net_Sales_INR)) * 100, 2) AS profit_margin_pct
FROM sales_data
GROUP BY Region, Category
ORDER BY profit_margin_pct ASC
LIMIT 10;

PRAGMA table_info(sales_data);



WITH subcat_sales AS (
    SELECT 
        Category,
        Subcategory,
        ROUND(SUM(Net_Sales_INR), 2) AS total_sales,
        ROUND(SUM(Profit_INR), 2) AS total_profit,
        RANK() OVER (PARTITION BY Category ORDER BY SUM(Net_Sales_INR) DESC) AS sales_rank
    FROM sales_data
    GROUP BY Category, Subcategory
)
SELECT Category, Subcategory, total_sales, total_profit
FROM subcat_sales
WHERE sales_rank = 1
ORDER BY total_sales DESC;

SELECT 
    Segment,
    Channel,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Net_Sales_INR), 2) AS total_sales,
    ROUND(SUM(Profit_INR), 2) AS total_profit,
    ROUND((SUM(Profit_INR) / SUM(Net_Sales_INR)) * 100, 2) AS margin_pct
FROM sales_data
GROUP BY Segment, Channel
ORDER BY total_sales DESC;


SELECT 
    City,
    Region,
    COUNT(DISTINCT Customer_ID) AS unique_customers,
    ROUND(SUM(Net_Sales_INR), 2) AS city_sales,
    ROUND(SUM(Profit_INR), 2) AS city_profit
FROM sales_data
GROUP BY City, Region
ORDER BY city_sales DESC
LIMIT 10;