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






