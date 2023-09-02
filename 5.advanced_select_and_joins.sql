1731. The Number of Employees Which Report to Each Employee

Table: Employees

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| reports_to  | int      |
| age         | int      |
+-------------+----------+
employee_id is the primary key for this table.
This table contains information about the employees and the id of the manager they report to. Some employees do not
report to anyone (reports_to is null).

For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.

Write an SQL query to report the ids and the names of all managers, the number of employees who report directly
to them, and the average age of the reports rounded to the nearest integer.

Return the result table ordered by employee_id.

Solution:

1.
select e1.employee_id,
        e1.name,
        count(e2.employee_id) as reports_count,
        round(avg(e2.age)) as average_age
from Employees e1, Employees e2
where e1.employee_id = e2.reports_to
group by 1
having reports_count>0
order by 1

2.
select e1.employee_id,
        e1.name,
        count(e2.name) as reports_count,
        round(sum(e2.age) / count(e2.age))  as average_age
from Employees e1
join Employees e2
on e2.reports_to = e1.employee_id
group by e1.employee_id
order by e1.employee_id
########################################################################################################################

1789. Primary Department for Each Employee

Table: Employee

+---------------+---------+
| Column Name   |  Type   |
+---------------+---------+
| employee_id   | int     |
| department_id | int     |
| primary_flag  | varchar |
+---------------+---------+
(employee_id, department_id) is the primary key (combination of columns with unique values) for this table.
employee_id is the id of the employee.
department_id is the id of the department to which the employee belongs.
primary_flag is an ENUM (category) of type ('Y', 'N'). If the flag is 'Y', the department is the primary department
for the employee. If the flag is 'N', the department is not the primary.

Employees can belong to multiple departments. When the employee joins other departments, they need to decide which
department is their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.

Write a solution to report all the employees with their primary department. For employees who belong to one department,
report their only department.

Return the result table in any order.

Solution:

SELECT employee_id,
        department_id
FROM Employee
WHERE primary_flag = 'Y'
UNION
SELECT employee_id,
        department_id
FROM Employee
WHERE employee_id IN
(SELECT employee_id
FROM Employee
GROUP BY employee_id
HAVING COUNT(employee_id) = 1)
########################################################################################################################

610. Triangle Judgement

Table: Triangle

+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
| z           | int  |
+-------------+------+
In SQL, (x, y, z) is the primary key column for this table.
Each row of this table contains the lengths of three line segments.

Report for every three line segments whether they can form a triangle.

Return the result table in any order.

Solution:

select x, y, z,
        case when (x + y) <= z or (x + z) <= y or (y+ z) <= x then 'No'
                else 'Yes' END as triangle
        from Triangle;
########################################################################################################################

180. Consecutive Numbers

Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
In SQL, id is the primary key for this table.
id is an autoincrement column.

Find all numbers that appear at least three times consecutively.

Return the result table in any order.

Solution:

with CTE as
(
select id,
        num,
        lag(num) over (order by id) as lg,
        lead(num) over (order by id) as ld
from Logs
)
select distinct num as ConsecutiveNums
from CTE
where num = lg and num = ld;
########################################################################################################################

1164. Product Price at a Given Date

Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.

Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before
any change is 10.

Return the result table in any order.

Solution:

select
        distinct a.product_id,
        coalesce(b.new_price, 10) as price
from Products as a
left join
(select
        product_id,
        rank() over(partition by product_id order by change_date DESC) as xrank,
        new_price
from Products
where change_date <= '2019-08-16') as b
on a.product_id = b.product_id and b.xrank = 1;
########################################################################################################################

1204. Last Person to Fit in the Bus
Medium
442
24
Companies
SQL Schema
Table: Queue

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id column contains unique values.
This table has the information about all people waiting for a bus.
The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
turn determines the order of which the people will board the bus, where turn=1 denotes the first person to board and
turn=n denotes the last person to board.
weight is the weight of the person in kilograms.


There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may
be some people who cannot board.

Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit.
The test cases are generated such that the first person does not exceed the weight limit.

Solution:

with CTE as
(
select person_id,
        person_name,
        weight,
        turn,
        sum(weight) over (order by turn) as cumulative_sum
from Queue
)
select person_name
from CTE
where cumulative_sum <= 1000
order by cumulative_sum desc
limit 1;
########################################################################################################################

1907. Count Salary Categories
Medium
221
52
Companies
SQL Schema
Pandas Schema
Table: Accounts

+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
account_id is the primary key (column with unique values) for this table.
Each row contains information about the monthly income for one bank account.

Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:

"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, return 0.

Return the result table in any order.

Solution:

select "Low Salary" as category,
        count(*) as accounts_count from accounts
where income<20000
union
select "Average Salary" as category,
        count(*) as accounts_count from accounts
where income>=20000 and income<=50000
union
select "High Salary" as category,
        count(*) as accounts_count from accounts
where income>50000;
########################################################################################################################
