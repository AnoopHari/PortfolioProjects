CREATE DATABASE pizza;

USE pizza;

SELECT * FROM
	pizza_sales
    LIMIT 100;

# 1) The sum of the total price of all pizza orders
SELECT 
	ROUND(SUM(total_price),2) AS total_revenue #817860.05
FROM
	pizza_sales;
    
# 2) The average amount spent per order
SELECT 
	ROUND((SUM(total_price) / COUNT(DISTINCT order_id)),2) AS Avg_order_value
FROM 
	pizza_sales;
# 3) The sum of the quantities of all pizzas sold.
SELECT
	SUM(quantity) AS quantities_sold
FROM
	pizza_sales;
    
# 4) The total number of orders placed.
SELECT 
	COUNT(DISTINCT order_id) AS Total_orders
FROM
	pizza_sales;
    
# 5) Average Pizzas Per Order
SELECT 
	ROUND(SUM(quantity) / COUNT(DISTINCT order_id),2) AS Avg_pizza_per_order
FROM
	pizza_sales;
    
# Looking on the daily trends in pizza orders
SELECT
  DAYNAME(STR_TO_DATE(order_date, '%Y-%m-%d')) AS order_day,
  COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
WHERE STR_TO_DATE(order_date, '%Y-%m-%d') IS NOT NULL
GROUP BY order_day;

# Hourly Trend
SELECT CAST(SUBSTRING(order_time, 1, 2) AS UNSIGNED) AS order_hours,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_hours
ORDER BY order_hours;

# Percentage of Sales by Pizza Category
SELECT
	pizza_category,
    ROUND(SUM(total_price),2) AS total_revenue,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales), 2) AS percentage
FROM
	pizza_sales
GROUP BY
	pizza_category;

# % of Sales by Pizza Size
SELECT
	pizza_size,
    ROUND(SUM(total_price),2) AS total_revenue,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales), 2) AS percentage
FROM
	pizza_sales
GROUP BY
	pizza_size
ORDER BY 
	percentage DESC;
# Total pizza sold by pizza category
SELECT 
    pizza_category,
    SUM(quantity) AS Total_Pizzas_Sold
FROM 
    pizza_sales
GROUP BY 
    pizza_category
ORDER BY
	Total_Pizzas_Sold DESC;

# Top 5 Best Sellers by Total Pizzas Sold
SELECT
	pizza_name,
    SUM(quantity) AS Total_Quantity_Sold
FROM
	pizza_sales
GROUP BY 
	pizza_name
ORDER BY 
	Total_Quantity_Sold DESC
LIMIT 5;

# Bottom 5 Best Sellers by Total Pizzas Sold
SELECT
	pizza_name,
    SUM(quantity) AS Total_Quantity_Sold
FROM
	pizza_sales
GROUP BY 
	pizza_name
ORDER BY 
	Total_Quantity_Sold ASC
LIMIT 5;