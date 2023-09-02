2356. Number of Unique Subjects Taught by Each Teacher

Table: Teacher

+-------------+------+
| Column Name | Type |
+-------------+------+
| teacher_id  | int  |
| subject_id  | int  |
| dept_id     | int  |
+-------------+------+
(subject_id, dept_id) is the primary key (combinations of columns with unique values) of this table.
Each row in this table indicates that the teacher with teacher_id teaches the subject subject_id in the
department dept_id.

Write a solution to calculate the number of unique subjects each teacher teaches in the university.

Return the result table in any order.

Solution:

select
        teacher_id,
        count(distinct subject_id) as cnt
from Teacher
group by teacher_id;
########################################################################################################################

1141. User Activity for the Past 30 Days I

Table: Activity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
This table may have duplicate rows.
The activity_type column is an ENUM (category) of type ('open_session', 'end_session', 'scroll_down', 'send_message').
The table shows the user activities for a social media website.
Note that each session belongs to exactly one user.

Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was
active on someday if they made at least one activity on that day.

Return the result table in any order.

Solution:

1.
select distinct activity_date as day, count(distinct user_id) as active_users
from activity
where datediff('2019-07-27', activity_date) < 30 and activity_date <= '2019-07-27'
group by 1;

2.
select
        activity_date as day,
        count(distinct user_id) as active_users
    from Activity
    where activity_date < '2019-07-27' and
          activity_date > DATE_ADD('2019-07-27', INTERVAL -30 DAY)
    group by activity_date;
########################################################################################################################

1070. Product Sales Analysis III

Table: Sales

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the primary key (combination of columns with unique values) of this table.
product_id is a foreign key (reference column) to Product table.
Each row of this table shows a sale on the product product_id in a certain year.
Note that the price is per unit.

Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id is the primary key (column with unique values) of this table.
Each row of this table indicates the product name of each product.

Write a solution to select the product id, year, quantity, and price for the first year of every product sold.

Return the resulting table in any order.

Solution:

SELECT product_id,
        year as first_year,
        quantity,
        price
FROM Sales
WHERE (product_id,year) in
(
SELECT product_id,MIN(year)
FROM Sales
GROUP BY product_id
);
########################################################################################################################

596. Classes More Than 5 Students

Table: Courses

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student     | varchar |
| class       | varchar |
+-------------+---------+
(student, class) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the name of a student and the class in which they are enrolled.

Write a solution to find all the classes that have at least five students.

Return the result table in any order.

Solution:

select class from Courses group by class having count(student) >= 5;
########################################################################################################################

1729. Find Followers Count

Table: Followers

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| follower_id | int  |
+-------------+------+
(user_id, follower_id) is the primary key (combination of columns with unique values) for this table.
This table contains the IDs of a user and a follower in a social media app where the follower follows the user.

Write a solution that will, for each user, return the number of followers.

Return the result table ordered by user_id in ascending order.

Solution:

select user_id,
        count(user_id) as followers_count
        from Followers
        group by 1
        order by 1;
########################################################################################################################

619. Biggest Single Number

Table: MyNumbers

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
+-------------+------+
This table may contain duplicates (In other words, there is no primary key for this table in SQL).
Each row of this table contains an integer.

A single number is a number that appeared only once in the MyNumbers table.

Find the largest single number. If there is no single number, report null.

Solution:
with CTE as
(
select
        num,
        count(num) as cnt
from
        MyNumbers
group by
        num
having count(num) = 1
)
select max(num) as num from CTE;
########################################################################################################################

1045. Customers Who Bought All Products

Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
This table may contain duplicates rows.
customer_id is not NULL.
product_key is a foreign key (reference column) to Product table.

Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key (column with unique values) for this table.

Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.

Solution:
1.
with CTE as
(
select customer_id, count(distinct product_key) as c from Customer group by customer_id having c =
(select count(distinct product_key) from Product)
)
select customer_id from CTE;

2.
with CTE as
(
select customer_id,
        count(distinct product_key) as cn
from Customer
group by customer_id
)
select customer_id
from CTE
where cn = (select count(distinct product_key) from Product);

3.
select customer_id
from Customer
group by customer_id
having count(distinct product_key) = (select count(product_key) from Product);
########################################################################################################################
