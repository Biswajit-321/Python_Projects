#Create database to perform all the things under this dataset;
drop table sales_data;

create database if not exists salesdataamazone;
CREATE TABLE sales_data (
    invoice_id VARCHAR(30),
    branch VARCHAR(5),
    city VARCHAR(30),
    customer_type VARCHAR(30),
    gender VARCHAR(10),
    product_line VARCHAR(100),
    unit_price DECIMAL(10, 2),
    quantity INT,
    VAT FLOAT(6, 4),
    total DECIMAL(10, 2),
    date DATETIME not null,
    time TIME not null,
    payment_method VARCHAR(15) not null,
    cogs DECIMAL(10, 2),
    gross_margin_percentage FLOAT(11, 9),
    gross_income DECIMAL(10, 2),
    rating FLOAT(2, 1)
);
SELECT * FROM salesdataamazone.sales_data;
select * from sales_data;
#Perform feature engenering:
---Add the time_of_day column---
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales_data;
alter table sales_data add column time_of_day varchar(20);
UPDATE sales_data
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
#check the time_of_day column
select * from sales_data;
---Add a new column day_name column---
SELECT
	date,
	DAYNAME(date)
FROM sales_data;

ALTER TABLE sales_data ADD COLUMN day_name VARCHAR(10);

UPDATE sales_data
SET day_name = DAYNAME(date);
#check column(day_name)

--- Add month_name column ---
SELECT
	date,
	MONTHNAME(date)
FROM sales_data;

ALTER TABLE sales_data ADD COLUMN month_name VARCHAR(10);

UPDATE sales_data
SET month_name = MONTHNAME(date);

#Business Questions To Answer:
#1---What is the count of distinct cities in the dataset?---
SELECT 
	DISTINCT city
FROM sales_data;
#2---For each branch, what is the corresponding city?---
SELECT branch, city FROM sales_data GROUP BY branch, city;
#3--- What is the count of distinct product lines in the dataset? ---
SELECT COUNT(DISTINCT product_line) AS distinct_product_lines_count FROM sales_data;
#4---Which payment method occurs most frequently?---
SELECT payment_method, COUNT(payment_method) AS method_count 
FROM sales_data 
GROUP BY payment_method 
ORDER BY method_count DESC 
LIMIT 1;
#5---Which product line has the highest sales?---
SELECT product_line, SUM(total) AS total_sales 
FROM sales_data 
GROUP BY product_line 
ORDER BY total_sales DESC 
LIMIT 1;
#From above quries we analyze the Food and beverages product_line has max sales values:

#6---How much revenue is generated each month?---
SELECT  month_name, SUM(total) AS revenue 
FROM sales_data 
GROUP BY month_name;
#From above queries i analyze the month of january has max revenue:

#7---In which month did the cost of goods sold reach its peak?---

SELECT  month_name, SUM(cogs) AS total_cogs 
FROM sales_data 
GROUP BY month_name 
ORDER BY total_cogs DESC 
LIMIT 1;
#From above analyze i found the january month has max cost of goods sold:

#8---Which product line generated the highest revenue?---
SELECT product_line, SUM(total) AS total_revenue 
FROM sales_data 
GROUP BY product_line 
ORDER BY total_revenue DESC 
LIMIT 1;
#From above analyze FOOD AND BEVERAGES productline has max revenue:

#9---In which city was the highest revenue recorded?---
SELECT city, SUM(total) AS total_revenue 
FROM sales_data 
GROUP BY city 
ORDER BY total_revenue DESC 
LIMIT 1;
#from above analyze i found the naypyitaw city has max revenue:

#10---Which product line incurred the highest Value Added Tax?---
SELECT product_line, SUM(VAT) AS total_VAT 
FROM sales_data 
GROUP BY product_line 
ORDER BY total_VAT DESC 
LIMIT 1;
#From above analyze i found FOOD AND BEVERAGES incurred max VAAT:

#11---For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."---
SELECT 
      avg(total) as avg_sale
from sales_data;
select product_line,
       case
           when total > (select avg(total) from sales_data) then "GOOD"
           else "BAD"
		END AS sales_quality
FROM sales_data;

#12---Identify the branch that exceeded the average number of products sold.---
SELECT branch
FROM (
    SELECT branch, AVG(quantity) AS avg_quantity
    FROM sales_data
    GROUP BY branch
) AS branch_avg
WHERE avg_quantity > (SELECT AVG(quantity) FROM sales_data);
#we analyze by the using sub_queries:

#13---Which product line is most frequently associated with each gender?---
SELECT gender, product_line, COUNT(*) AS frequency
FROM sales_data
GROUP BY gender, product_line
ORDER BY frequency DESC;
#From above analyze i found that the "Health and Beuty" product has more frequency:

#14---Calculate the average rating for each product line.---
SELECT product_line, AVG(rating) AS avg_rating
FROM sales_data
GROUP BY product_line;
#From above analyze i found the max avg rating has health and beuty product:

#15---Count the sales occurrences for each time of day on every weekday.---
SELECT 
    DAYNAME(date) AS weekday, 
    HOUR(time) AS hour_of_day, 
    COUNT(*) AS sales_occurrences 
FROM sales_data 
GROUP BY weekday, hour_of_day 
ORDER BY weekday, hour_of_day;
#This query groups the sales occurrences by the day of the week and the hour of the day, allowing you to analyze the sales trends for each weekday and hour.

#16---Identify the customer type contributing the highest revenue.---
SELECT customer_type, SUM(total) AS total_revenue
FROM sales_data
GROUP BY customer_type
ORDER BY total_revenue DESC
LIMIT 1;
#From above analyze i found the member gave max revenue:

#17---Determine the city with the highest VAT percentage.---
SELECT city, MAX(VAT) AS max_VAT
FROM sales_data
GROUP BY City;
#from this query i found Yangon city has max_VAT:

#18---Identify the customer type with the highest VAT payments---
SELECT customer_type, SUM(VAT) AS total_VAT_payments
FROM sales_data
GROUP BY customer_type
ORDER BY total_VAT_payments DESC
LIMIT 1;
#From above queries i found member with max VAT---

#19---What is the count of distinct customer types in the dataset?---
SELECT COUNT(DISTINCT customer_type) AS distinct_customer_types_count
FROM sales_data;
# From above queries i found 2 types of customer:

#20---What is the count of distinct payment methods in the dataset?---
SELECT COUNT(DISTINCT payment_method) AS distinct_payment_methods_count
FROM sales_data;
#from above queries i found 3 payment methods:

#21---Which customer type occurs most frequently?---
SELECT customer_type, COUNT(*) AS frequency
FROM sales_data
GROUP BY customer_type
ORDER BY frequency DESC
LIMIT 1;
#here i found member has max frequency:

#22---Identify the customer type with the highest purchase frequency.---
SELECT customer_type, COUNT(*) AS purchase_frequency
FROM sales_data
GROUP BY customer_type
ORDER BY purchase_frequency DESC
LIMIT 1;
#From above queries i found the member has max purchase_frequency:

#23---Determine the predominant gender among customers.---
SELECT gender, COUNT(*) AS frequency
FROM sales_data
GROUP BY gender
ORDER BY frequency DESC
LIMIT 1;
# The male gender has more frequency:

#24---Examine the distribution of genders within each branch.---
SELECT branch, gender, COUNT(*) AS frequency
FROM sales_data
GROUP BY branch, gender
ORDER BY branch, frequency DESC;
#From above quer i found A branch and male gender has more frequency:

#25---Identify the time of day when customers provide the most ratings.---
SELECT time_of_day, COUNT(*) AS rating_occurrences
FROM sales_data
GROUP BY time_of_day
ORDER BY rating_occurrences DESC
LIMIT 1;
#From above analyzed i found the eveining time the customer rated more:

#26---Determine the time of day with the highest customer ratings for each branch.---
SELECT branch, time_of_day, AVG(rating) AS avg_rating
FROM sales_data
GROUP BY branch, time_of_day
ORDER BY branch, avg_rating DESC;
#from above query i found the branch A giving more rating at afternoon time:

#27---Identify the day of the week with the highest average ratings.---
SELECT day_name AS weekday, AVG(rating) AS avg_rating
FROM sales_data
GROUP BY weekday
ORDER BY avg_rating DESC
LIMIT 1;
#from above query i found the customer gave more rating in MONDAY:
#28---Determine the day of the week with the highest average ratings for each branch.---
SELECT branch, day_name AS weekday, AVG(rating) AS avg_rating
FROM sales_data
GROUP BY branch, weekday
ORDER BY branch, avg_rating DESC;
# From above query i found more AVG ratting incure in Friday in branch A:
----------------Conclusion: By conducting thorough analysis and addressing the key business questions, 
the project aims to provide actionable insights to optimize sales strategies, 
improve customer satisfaction, and enhance overall business performance for Amazon across its different branches.------------








