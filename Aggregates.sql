-- Active: 1661453407611@@127.0.0.1@3306@parchposey
USE parchposey;

SELECT *
FROM accounts
WHERE primary_poc IS NULL;

SELECT COUNT(*)
FROM orders;

SELECT COUNT(a.id)
FROM accounts a;

SELECT SUM(standard_qty) AS 'standard',
       SUM(gloss_qty) AS gloss,
       SUM(poster_qty) AS poster
FROM orders;

SELECT SUM(standard_amt_usd) / SUM(standard_qty) AS per_unit
FROM orders; 

SELECT MAX(standard_amt_usd) AS standard_max,
       MAX(total) AS total_max,
       MIN(poster_amt_usd) AS poster_min
FROM orders;

--AVG DOES NOT account for null values
SELECT AVG(standard_qty) AS standard_avg,
       AVG(total) AS total_avg
FROM orders;

--When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at) AS earliest_date
FROM orders;

--Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

--When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at) AS latest_web_event
FROM web_events;

--Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

--Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount 
--of each paper type purchased per order. Your final answer should have 6 values - one for each
--paper type for the average number of sales, as well as the average amount.
SELECT AVG(standard_qty) AS standard_avg,
       AVG(gloss_qty) AS gloss_avg,
       AVG(poster_qty) AS poster_avg,
       AVG(standard_amt_usd) AS standard_amt_usd_avg,
       AVG(gloss_amt_usd) AS gloss_amt_usd_avg,
       AVG(poster_amt_usd) AS poster_amg_usd_avg
FROM orders;

--what is the MEDIAN total_usd spent on all orders?
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;
--This is the hard coded way, not a general purpose method

------------------------------------------------------------------------------------------

--The following query will give the sum of all quantities based on their account id
SELECT account_id, 
       SUM(standard_qty) AS standard_sum,
       SUM(gloss_qty) AS gloss_sum,
       SUM(poster_qty) AS poster_sum
FROM orders
GROUP BY account_id
ORDER BY account_id;

--Which account (by name) placed the earliest order? Your solution should have the account
--name and the date of the order.
SELECT o.occurred_at, a.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
ORDER BY occurred_at
LIMIT 1;

--Via what channel did the most recent (latest) web_event occur, which account was associated 
--with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

--Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

--What was the smallest order placed by each account in terms of total usd. 
--Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT MIN(o.total_amt_usd) AS smallest_usd, a.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY smallest_usd;

--Find the number of sales reps in each region. Your final table should have two columns - 
--the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT COUNT(s.name) AS num_sales_reps, r.name
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER BY num_sales_reps;

--For each account, determine the average amount of each type of paper they purchased across their orders. 
--Your result should have four columns - one for the account name and one for the average quantity 
--purchased for each of the paper types for each account.
SELECT  a.name, 
        AVG(o.standard_qty) AS standard_avg,
        AVG(o.gloss_qty) AS gloss_avg,
        AVG(o.poster_qty) AS poster_avg
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

--For each account, determine the average amount spent per order on each paper type. 
--Your result should have four columns - one for the account name and one for the average 
--amount spent on each paper type.
SELECT  a.name,
        AVG(o.standard_amt_usd) AS standard_avg,
        AVG(o.gloss_amt_usd) AS gloss_avg,
        AVG(o.poster_amt_usd) AS poster_avg
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

--Determine the number of times a particular channel was used in the web_events table for each sales rep. 
--Your final table should have three columns - the name of the sales rep, the channel, and the number 
--of occurrences. Order your table with the highest number of occurrences first.
SELECT  s.name,
        w.channel,
        COUNT(w.channel) AS num_channels
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY s.name, w.channel
ORDER BY num_channels DESC;

--Determine the number of times a particular channel was used in the web_events table for each region. 
--Your final table should have three columns - the region name, the channel, and the number of occurrences. 
--Order your table with the highest number of occurrences first.
SELECT  r.name,
        w.channel,
        COUNT(w.channel) AS num_channel
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY r.name, w.channel
ORDER BY num_channel DESC;

--Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT DISTINCT id, a.name
FROM accounts a;

--Have any sales reps worked on more the on account?
SELECT DISTINCT id, s.name
FROM sales_reps s;

--You can use WHERE clause with aggregate functions, so we use HAVING
SELECT account_id,
       SUM(total_amt_usd) AS sum_total_amt_usd
FROM orders
GROUP BY account_id
HAVING sum_total_amt_usd >= 250000;

--How many of the sales reps have more than 5 accounts that they manage?
SELECT COUNT(a.name) AS num_accounts, s.name
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
GROUP BY s.name
HAVING num_accounts > 5
ORDER BY num_accounts;

--Which accounts spent more than 30,000 usd total across all orders?
SELECT a.name, SUM(o.total_amt_usd) AS sum_total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING sum_total_amt_usd > 30000
ORDER BY sum_total_amt_usd;

--Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.name, w.channel, COUNT(w.channel) AS count_channels
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING count_channels > 6 AND w.channel = 'facebook'
ORDER BY count_channels;

SELECT a.name, w.channel, COUNT(w.channel) AS count_channels
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING w.channel = 'facebook'
ORDER BY count_channels DESC
LIMIT 1;

SELECT a.name, w.channel, COUNT(w.channel) AS count_channels
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.name, w.channel
ORDER BY count_channels DESC;

-- DATE
-- Getting sum of standard quantity of each day from 2013 to 2017
SELECT DATE_FORMAT(occurred_at, '%Y-%m-%d') AS day,
       SUM(standard_qty) AS standard_qty_sum
FROM orders
GROUP BY day
ORDER BY day;

-- Getting sum of total sales based on day of week
SELECT DATE_FORMAT(occurred_at, '%a') AS day_of_week,
       SUM(total) AS total_qty
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
--Do you notice any trends in the yearly sales totals?
SELECT DATE_FORMAT(occurred_at, '%Y') AS yearly,
       SUM(total_amt_usd) as total_usd_sum
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--Which month did Parch & Posey have the greatest sales in terms of total dollars? 
--Are all months evenly represented by the dataset?
SELECT DATE_FORMAT(occurred_at, '%M') as monthly,
       SUM(total_amt_usd) AS total_usd_sum
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
--Are all years evenly represented by the dataset?
SELECT DATE_FORMAT(occurred_at, '%Y') as yearly,
       SUM(total) AS total_qty_sum
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_FORMAT(occurred_at, '%Y-%m') as monthly,
       SUM(gloss_amt_usd) as gloss_usd_sum
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC;

--CASE statements
SELECT id,
       account_id,
       occurred_at,
       channel,
       CASE WHEN channel = 'facebook' THEN 'yes' ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at;    

SELECT account_id,
       occurred_at,
       total,
       CASE WHEN total > 500 THEN 'Over 500'
            WHEN total > 300 AND total <= 500 THEN '301 - 500'
            WHEN total > 100 AND total <= 300 THEN '101 - 300'
            ELSE '100 or under' END AS total_group
FROM orders;

--Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard 
--paper for each order. Limit the results to the first 10 orders, and include the id and account_id fields. 
SELECT account_id
       standard_amt_usd,
       standard_qty,
       CASE WHEN standard_qty = 0 OR standard_qty is NULL THEN 0
            ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

--We use CASE statements for when we want to process multiple sets of data, the WHERE clause only works with one
--set of data so multiple queries are needed to replicate this
SELECT CASE WHEN total > 500 THEN 'Over 500'
            ELSE '500 or under' END AS total_group,
            COUNT(*) AS order_count
FROM orders
GROUP BY total_group;

--Write a query to display for each order, the account ID, total amount of the order, 
--and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, 
--or smaller than $3000.
SELECT account_id,
       total_amt_usd,
       CASE WHEN total_amt_usd >= 3000 THEN 'Large'
            WHEN total_amt_usd < 3000 THEN 'Small' END AS level_of_order 
FROM orders;

--We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
--The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
--The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. 
--Provide a table that includes the level associated with each account. You should provide the account name, 
--the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
SELECT a.name,
       SUM(o.total_amt_usd) AS total_for_customer,
       CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Highest'
            WHEN SUM(o.total_amt_usd) <= 200000 AND SUM(o.total_amt_usd) >= 100000 THEN 'Medium'
            WHEN SUM(o.total_amt_usd) < 100000 THEN 'Lowest' END AS level_of_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

--We would now like to perform a similar calculation to the previous, but we want to obtain the total 
--amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. 
--Order with the top spending customers listed first.
SELECT a.name,
       SUM(o.total_amt_usd) AS total_for_customer,
       CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Highest'
            WHEN SUM(o.total_amt_usd) <= 200000 AND SUM(o.total_amt_usd) >= 100000 THEN 'Medium'
            WHEN SUM(o.total_amt_usd) < 100000 THEN 'Lowest' END AS level_of_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE DATE_FORMAT(occurred_at, '%Y') = 2016 OR DATE_FORMAT(occurred_at, '%Y') = 2017
GROUP BY 1
ORDER BY 2 DESC;

--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
--Create a table with the sales rep name, the total number of orders, and a column with top or not depending
--on if they have more than 200 orders. Place the top sales people first in your final table.
SELECT s.name,
       COUNT(o.id) AS total_sale_rep_orders,
       CASE WHEN COUNT(o.id) > 200 THEN 'Top'
            ELSE 'Not' END AS top_sales_people
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

--The previous didn't account for the middle, nor the dollar amount associated with the sales. 
--Management decides they want to see these characteristics represented as well. We would like to 
--identify top performing sales reps, which are sales reps associated with more than 200 orders or more 
--than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. 
--Create a table with the sales rep name, the total number of orders, total sales across all orders, 
--and a column with top, middle, or low depending on this criteria. Place the top sales people based 
--on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!
SELECT s.name,
       COUNT(o.id) AS total_orders,
       SUM(o.total_amt_usd) AS total_amt_orders,
       CASE WHEN COUNT(o.id) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'Top'
            WHEN COUNT(o.id) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'Middle'
            ELSE 'Low' END AS top_sales_people
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;



