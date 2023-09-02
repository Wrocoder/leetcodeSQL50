620. Not Boring Movies

Table: Cinema

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| id             | int      |
| movie          | varchar  |
| description    | varchar  |
| rating         | float    |
+----------------+----------+
id is the primary key (column with unique values) for this table.
Each row contains information about the name of a movie, its genre, and its rating.
rating is a 2 decimal places float in the range [0, 10]

Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".

Return the result table ordered by rating in descending order.

Solution:

select id, movie, description, rating
from Cinema
where id % 2 != 0 and
      description != 'boring'
order by rating desc;
########################################################################################################################

1251. Average Selling Price

Table: Prices

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
(product_id, start_date, end_date) is the primary key for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for
the same product_id.

Table: UnitsSold

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
There is no primary key for this table, it may contain duplicates.
Each row of this table indicates the date, units, and product_id of each product sold.

Write an SQL query to find the average selling price for each product. average_price should be rounded to 2 decimal
places.

Return the result table in any order.

Solution:

1.
with CTE as (
select p.product_id, p.start_date sd, p.end_date ed, p.price * u.units mmm, sum(u.units) over
        (PARTITION BY p.product_id) sss from Prices p
join UnitsSold u
on p.product_id = u.product_id
WHERE u.purchase_date BETWEEN p.start_date AND p.end_date )
select distinct product_id, ROUND(sum(mmm) over (partition by product_id) / sss, 2) average_price from CTE;

2.
select pr.product_id,
        ROUND(sum(pr.price * u.units) / sum(u.units), 2) as average_price
        from Prices pr
    join UnitsSold u
    on u.product_id = pr.product_id
    AND u.purchase_date >= pr.start_date
    AND u.purchase_date <= pr.end_date
    group by pr.product_id;
########################################################################################################################

1075. Project Employees I

Table: Project

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.
Each row of this table indicates that the employee with employee_id is working on the project with project_id.

Table: Employee

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key of this table. It's guaranteed that experience_years is not NULL.
Each row of this table contains information about one employee.

Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

Return the result table in any order.

Solution:

1.
select distinct p.project_id,
  ROUND((sum(e.experience_years) over (PARTITION by p.project_id) /
  count(*) over (PARTITION by p.project_id)), 2) as average_years
  from Project p
join Employee e
on p.employee_id = e.employee_id;

2.
select p.project_id,
        ROUND(sum(e.experience_years) / count(name), 2) as average_years
    from Project p
    join Employee e
    on p.employee_id = e.employee_id
    group by p.project_id;
########################################################################################################################

1633. Percentage of Users Attended a Contest

Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
user_id is the primary key (column with unique values) for this table.
Each row of this table contains the name and the id of a user.

Table: Register

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
(contest_id, user_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id of a user and the contest they registered into.

Write a solution to find the percentage of the users registered in each contest rounded to two decimals.

Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in
ascending order.

Solution:

with CTE as
(
select contest_id,
       count(*) cn
from Register
group by contest_id
)
select contest_id,
        round(cn/(select count(distinct user_id) from Users) * 100, 2) as percentage
from CTE
order by percentage desc, contest_id asc;
########################################################################################################################

1211. Queries Quality and Percentage

Table: Queries

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| query_name  | varchar |
| result      | varchar |
| position    | int     |
| rating      | int     |
+-------------+---------+
This table may have duplicate rows.
This table contains information collected from some queries on a database.
The position column has a value from 1 to 500.
The rating column has a value from 1 to 5. Query with rating less than 3 is a poor query.

We define query quality as:

The average of the ratio between query rating and its position.

We also define poor query percentage as:

The percentage of all queries with rating less than 3.

Write a solution to find each query_name, the quality and poor_query_percentage.

Both quality and poor_query_percentage should be rounded to 2 decimal places.

Return the result table in any order.

Solution:

SELECT query_name,
    ROUND((SUM(rating/position)/COUNT(query_name)),2) AS quality,
    ROUND(AVG(CASE WHEN rating < 3 THEN 1 ELSE 0 END)*100,2) AS poor_query_percentage
FROM Queries
GROUP BY query_name;
########################################################################################################################

1193. Monthly Transactions I

Table: Transactions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].

Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of
approved transactions and their total amount.

Return the result table in any order.

Solution:

1.
select DATE_FORMAT(trans_date, '%Y-%m') as month , country,
                                      count(*) trans_count,
                                      sum(case when state = 'approved' then 1 else 0 END) approved_count,
                                      sum(amount) trans_total_amount,
                                      sum(case when state = 'approved' then amount else 0 END) approved_total_amount
from Transactions
group by DATE_FORMAT(trans_date, '%Y-%m'), country;

2.
select substring(trans_date, 1, 7) as month,
        country,
        count(id) as trans_count,
        sum(case when state = 'approved' then 1 else 0 end) as approved_count,
        sum(amount) as trans_total_amount,
        sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
    from Transactions
    group by month(trans_date), year(trans_date), country;
########################################################################################################################

1174. Immediate Food Delivery II

Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the column of unique values of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred
delivery date (on the same order date or after it).

If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise,
it is called scheduled.

The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that
a customer has precisely one first order.

Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal
places.

Solution:

1.
with CTE as
(
select delivery_id, customer_id, order_date, customer_pref_delivery_date,
        row_number() over (partition by customer_id order by order_date) rn,
        CASE when order_date < customer_pref_delivery_date then 'scheduled' else 'immediate' end as sch
        from Delivery
)
select cast((select count(*) from CTE where rn = 1 and sch = 'immediate')/count(*) * 100 as Decimal(5,2))
        as immediate_percentage  from CTE where rn = 1;

2.
with CTE as
(
    select delivery_id,
            customer_id,
            order_date,
            customer_pref_delivery_date,
            row_number() over (partition by customer_id order by order_date ) as rn
            from Delivery
)

select ROUND(100 / count(*) * sum(case when order_date = customer_pref_delivery_date then 1 else 0 end), 2)
       as immediate_percentage
from CTE
where rn = 1;
########################################################################################################################

550. Game Play Analysis IV

Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday
using some device.

Write a solution to report the fraction of players that logged in again on the day after the day they first logged in,
rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two
consecutive days starting from their first login date, then divide that number by the total number of players.

Solution:

WITH CTE AS (
SELECT
        player_id, min(event_date) as event_start_date
from
        Activity
group by player_id )

SELECT
        round((count(distinct c.player_id) / (select count(distinct player_id) from activity)),2) as fraction
FROM
        CTE c
JOIN Activity a
on c.player_id = a.player_id
and datediff(c.event_start_date, a.event_date) = -1;
########################################################################################################################
