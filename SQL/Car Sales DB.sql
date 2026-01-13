CREATE DATABASE car_sales_db;
SELECT * FROM car_sales;
UPDATE car_sales
SET DATE = str_to_date(Date, '%d/%m/%Y');


# SALES OVERVIEW
# Year-to-Date(YTD) Total Sales---------------------------------------------
WITH YEARSORT AS(
SELECT YEAR(Date) AS  years FROM car_sales
)
 SELECT sum(price) AS total_sales,(SELECT MAX(years) FROM YEARSORT) AS present_year FROM car_sales
 WHERE year(Date)= (SELECT MAX(years) FROM YEARSORT);
# Alternative Method---
 SELECT SUM(price) AS YTD_Total_Sales FROM car_sales
 WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales);
 
# Year-to-Date(PYTD) Total Sales -----------------------------------------
WITH YEARSORT AS(
SELECT YEAR(Date) AS  years1 FROM car_sales
),
SECOND_LARGE AS( SELECT MAX(years1) AS second_large_year FROM YEARSORT
 WHERE years1<(SELECT MAX(years1) FROM YEARSORT)
)
SELECT SUM(price) AS price, (SELECT second_large_year FROM SECOND_LARGE) AS previous_year  FROM car_sales 
WHERE YEAR(Date) = (SELECT second_large_year FROM SECOND_LARGE);

# Difference between YTD Sales and Previous Year-to-Date (PYTD) Sales---------------------------
WITH YEARSORT AS(
SELECT YEAR(Date) AS  years FROM car_sales
), 
SECOND_LARGE AS( SELECT MAX(years) AS second_large_year FROM YEARSORT
 WHERE years<(SELECT MAX(years) FROM YEARSORT)
)
 SELECT (sum(price)-  (SELECT SUM(price) AS price  FROM car_sales 
                       WHERE YEAR(Date) = 
					  (SELECT second_large_year 
					  FROM SECOND_LARGE)))
 AS YOY_percentage_Total_Sales
 FROM car_sales
 WHERE year(Date)= (SELECT MAX(years) FROM YEARSORT);

# Year-Over-Year(YOY) Total Sales----------------------------------------
WITH YEARSORT AS(
SELECT YEAR(Date) AS  years FROM car_sales
), 
SECOND_LARGE AS( SELECT MAX(years) AS second_large_year FROM YEARSORT
 WHERE years<(SELECT MAX(years) FROM YEARSORT)
)
 SELECT (sum(price)-  (SELECT SUM(price) AS price  FROM car_sales 
                       WHERE YEAR(Date) = 
					  (SELECT second_large_year 
					  FROM SECOND_LARGE)))*100/
                      
                      (SELECT SUM(price) AS price  FROM car_sales 
                       WHERE YEAR(Date) = 
					  (SELECT second_large_year 
					  FROM SECOND_LARGE))
                      
 AS YOY_percentage_Total_Sales
 FROM car_sales
 WHERE year(Date)= (SELECT MAX(years) FROM YEARSORT);

# Month-to-Date(MTD) Total Sales------------------------------------------------
WITH YEARMONTH AS (
SELECT MONTH(Date) AS months, YEAR(Date) AS years FROM car_sales 
)
SELECT SUM(price) AS MTD_Total_Sales FROM car_sales 
WHERE MONTH(Date)=(SELECT MAX(months) FROM YEARMONTH) AND 
YEAR(Date) = (SELECT MAX(years) FROM YEARMONTH);


# Previous-Month-to-Date(PMTD) Total Sales----------------------------------------
WITH YEARMONTHS AS(
SELECT MONTH(Date) AS current_months, YEAR(Date) AS current_year  FROM car_sales
), previous_month AS (
   SELECT MAX(current_months) AS previous_month1 FROM YEARMONTHS 
   WHERE current_months < (SELECT MAX(current_months) FROM YEARMONTHS)
)
SELECT SUM(price) FROM car_sales 
WHERE YEAR(Date) = (SELECT MAX(current_year) FROM YEARMONTHS)
AND 
MONTH(Date) =(SELECT previous_month1 FROM previous_month);

# Month-OVER-Month(MoM) Total Sales-----------------------------------------------
WITH YEARMONTHS AS(
SELECT MONTH(Date) AS current_months, YEAR(Date) AS current_year  FROM car_sales
), previous_month AS (
   SELECT MAX(current_months) AS previous_month1 FROM YEARMONTHS 
   WHERE current_months < (SELECT MAX(current_months) FROM YEARMONTHS)
)
SELECT (SUM(price)-(SELECT SUM(price) FROM car_sales 
				  WHERE MONTH(Date)=(SELECT previous_month1 FROM previous_month) AND 
                  YEAR(Date)=(SELECT MAX(current_year) FROM YEARMONTHS WHERE current_year<(SELECT MAX(current_year) FROM YEARMONTHS))))*100/
                  
                  (SELECT SUM(price) FROM car_sales 
				  WHERE MONTH(Date)=(SELECT previous_month1 FROM previous_month) AND 
                  YEAR(Date)=(SELECT MAX(current_year) FROM YEARMONTHS WHERE current_year<(SELECT MAX(current_year) FROM YEARMONTHS)))
AS MoM_Percentage_Total_Sales
FROM car_sales 
WHERE MONTH(Date)=(SELECT MAX(current_months) FROM YEARMONTHS) AND
      YEAR(Date)=(SELECT MAX(current_year) FROM YEARMONTHS);

# YTD Average Price----------------------------------------------------------
SELECT AVG(price) AS YTD_Average_price  FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales);

# PYTD Average Price-----------------------------------------------------------
SELECT AVG(price) AS PYTD_Average_Price FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) AS previous_year FROM car_sales
                    WHERE YEAR(Date)<(SELECT MAX(YEAR(Date)) FROM car_sales));

# Difference between YTD Average Price and PYTD Average price---------------------------
SELECT AVG(price)  - (SELECT AVG(price) AS PYTD_Average_Price FROM car_sales
                     WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales
                                         WHERE YEAR(Date)<(SELECT MAX(YEAR(Date)) 
														   FROM car_sales))) 
AS price_Average_difference
FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales);


# Year-OVER-Year(YOY) Average Sales---------------------------------------------
 
SELECT (AVG(price)  - (SELECT AVG(price) AS PYTD_Average_Price FROM car_sales
                     WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales
                                         WHERE YEAR(Date)<(SELECT MAX(YEAR(Date)) 
														   FROM car_sales))))*100/
 (SELECT AVG(price) AS PYTD_Average_Price FROM car_sales
 WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales
					WHERE YEAR(Date)<(SELECT MAX(YEAR(Date)) 
					FROM car_sales))) 
AS price_Average_percentage
FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales);

# YTD Cars Sold-----------------------------------------------------------
SELECT COUNT(Car_id) AS YTD_Cars_Sold FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales);

# PYTD Cars Sold----------------------------------------------------------------
SELECT COUNT(Car_id) FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales WHERE YEAR(Date) <(SELECT MAX(YEAR(Date)) FROM car_sales));

# Difference between YTD Cars sold and PYTD Cars sold (YTD-PYTD)------------------
SELECT COUNT(Car_id) - (SELECT COUNT(Car_id) FROM car_sales 
                       WHERE YEAR(Date)=(SELECT MAX(YEAR(Date)) FROM car_sales 
                                        WHERE YEAR(Date)<(SELECT MAX(YEAR(Date)) 
                                                          FROM car_sales)))
AS Percentage_YOY_Growth_in_car_sales
FROM car_sales WHERE YEAR(Date)=(SELECT MAX(YEAR(Date)) FROM car_sales);


# YOY Growth in Cars sold ((YTD-PYTD)*100)/PYTD-------------------------------------
SELECT (COUNT(Car_id) - (SELECT COUNT(Car_id) FROM car_sales 
                       WHERE YEAR(Date)=(SELECT MAX(YEAR(Date)) FROM car_sales 
                                        WHERE YEAR(Date)<(SELECT MAX(YEAR(Date)) 
                                                          FROM car_sales))))*100/
					   (SELECT COUNT(Car_id) FROM car_sales 
                       WHERE YEAR(Date)=(SELECT MAX(YEAR(Date)) FROM car_sales 
                                        WHERE YEAR(Date)<(SELECT MAX(YEAR(Date)) 
                                                          FROM car_sales)))
AS Percentage_YOY_Growth_in_car_sales
FROM car_sales WHERE YEAR(Date)=(SELECT MAX(YEAR(Date)) FROM car_sales);

# MTD Cars sold-------------------------------------------------------------------------
SELECT COUNT(Car_id) FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales) AND 
      MONTH(Date) = (SELECT MAX(MONTH(Date)) FROM car_sales);


# CHART REQUIREMENTS------------------------------------------------------------------------
# YTD Sales Weekly Trend Display a line chart illustrating the weekly trend of YTD sales.
# The X-axis should represent weeks, and the Y axis should show the total sales amount
SELECT SUM(price) AS Total_Sales, DAYNAME(Date) AS week_day, DAYOFWEEK(Date) AS Day_num FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales)
GROUP BY week_day, Day_num
ORDER BY Day_num ASC;


# YTD Total Sales by Body Style: --------------------------------------------------------------------
# Visualize the distribution of YTD total sales across different car body styles using a Pie Chart.
SELECT SUM(price) AS Total_Sales, Body_Style FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales)
GROUP BY Body_Style 
ORDER BY Total_Sales DESC;

# YTD Total Sales by Colour:---------------------------------------------------------------------- 
# Present the contribution of various car colours to the YTD total sales through a pie chart.
SELECT SUM(price) AS Total_Sales, Color FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales)
GROUP BY color
ORDER BY Total_Sales DESC;

#YTD Cars Sold by Dealer Region:------------------------------------------------------------------- 
#showcase the YTD sales data based on different dealer regions using a map chart to visualize the sales distribution geographically.
SELECT COUNT(Car_id) AS No_Of_Cars_Sold, Dealer_Region FROM car_sales
WHERE YEAR(Date) = (SELECT MAX(YEAR(Date)) FROM car_sales)
GROUP BY Dealer_Region
ORDER BY No_Of_Cars_Sold DESC;

# Company-Wise Sales Trend in Grid Form:--------------------------------------------------------- 
#Provide a  tabular grid that displays the sales trend for each company.
# The grid should showcase the company name along with their YTD sales figures.
SELECT Company, SUM(price) AS YTD_Total_Sales FROM car_sales
WHERE YEAR(Date)= (SELECT MAX(YEAR(Date)) FROM car_sales)
GROUP BY Company
ORDER BY YTD_Total_Sales DESC;

# Details Grid Showing All Car Sales Information:--------------------------------------------------
# Create a detailed grid that presents all relevant information for each car sale, 
# including car model, Body Style, Colour, Sales Amount, Dealer Region, Date etc. 
SELECT Model,Company, Body_Style, Color, price, Dealer_Region,Date FROM car_sales
ORDER BY price DESC;






