# CREATE database pizza_db;
SELECT * FROM pizza_sales;
# DROP table pizza_sales1;
# Total revenue. The sum of total price of all pizza order
SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales;

# Average Revenue
SELECT CAST(SUM(total_price)/COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS avg_Order_value FROM pizza_sales;

#  Total Quantity sold
SELECT SUM(quantity) AS Total_Quantity FROM pizza_sales;

# Total Number of Orders
SELECT COUNT(DISTINCT order_id) AS total_Orders FROM pizza_sales;

SELECT order_date AS order_day, COUNT(DISTINCT order_id) AS Total_Orders
 FROM pizza_sales
GROUP BY order_day;

UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

ALTER TABLE pizza_sales
MODIFY COLUMN order_date varchar(20);

ALTER TABLE pizza_sales
MODIFY COLUMN order_date date;


# Daily Trend
SELECT dayname(order_date) AS week_day, COUNT(DISTINCT order_id) AS Orders FROM pizza_sales
GROUP BY week_day
ORDER BY Orders DESC;

# Monthly trend
SELECT monthname(order_date) AS Months, COUNT(DISTINCT order_id) AS Orders 
FROM pizza_sales
GROUP BY Months
ORDER BY Orders DESC;

# percentage of sales by pizza category
SELECT pizza_category, 
	   SUM(total_price) AS Total_Price, 
	   SUM(total_price)*100/(SELECT SUM(total_price) FROM pizza_sales)   AS percentage_of_total_per_month 
FROM pizza_sales
GROUP BY pizza_category;

SELECT pizza_category, 
       MONTHNAME(order_date) AS Months, 
	   SUM(total_price) AS Total_Price, 
	   SUM(total_price)*100/
       (SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date)=1)  
        AS percentage_of_total_per_month 
FROM pizza_sales
WHERE MONTH(order_date)=1
GROUP BY pizza_category, Months;

# percentage of sales by pizza size
SELECT pizza_size,
    CAST(SUM(total_price)*100 /(SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS percentage
FROM pizza_sales
GROUP BY pizza_size
ORDER BY percentage DESC;
 
# Top 5 pizzas by quantity.
SELECT pizza_name,
       SUM(total_price) AS total_revenue, 
	   SUM(quantity) AS total_quantity,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC LIMIT 5;




