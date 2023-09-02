1378. Replace Employee ID With The Unique Identifier

Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains the id and the name of an employee in a company.

Table: EmployeeUNI

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| unique_id     | int     |
+---------------+---------+
(id, unique_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id and the corresponding unique id of an employee in the company.

Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.

Return the result table in any order.

Solution:
select u.unique_id, e.name from Employees e
left join EmployeeUNI u on e.id=u.id;
########################################################################################################################

1068. Product Sales Analysis I

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

Write a solution to report the product_name, year, and price for each sale_id in the Sales table.

Return the resulting table in any order.

Solution:
select p.product_name, s.year, s.price from Sales s
inner join Product p
on p.product_id = s.product_id
########################################################################################################################

1581. Customer Who Visited but Did Not Make Any Transactions

Table: Visits

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| visit_id    | int     |
| customer_id | int     |
+-------------+---------+
visit_id is the column with unique values for this table.
This table contains information about the customers who visited the mall.

Table: Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| transaction_id | int     |
| visit_id       | int     |
| amount         | int     |
+----------------+---------+
transaction_id is column with unique values for this table.
This table contains information about the transactions made during the visit_id.

Write a solution to find the IDs of the users who visited without making any transactions and the number of times they
made these types of visits.

Return the result table sorted in any order.

Solution:
select
       customer_id,
       count(*) as count_no_trans
       from Visits
       where visit_id not in (select visit_id from  Transactions)
       group by customer_id;
########################################################################################################################

197. Rising Temperature

Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
In SQL, id is the primary key for this table.
This table contains information about the temperature on a certain day.

Find all dates' Id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

Solution:

select w1.id from Weather w1
join Weather w2
on w1.recordDate - INTERVAL 1 DAY = w2.recordDate
where w1.temperature > w2.temperature
order by w1.recordDate;
########################################################################################################################

1661. Average Time of Process per Machine

Table: Activity

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
The table shows the user activities for a factory website.
(machine_id, process_id, activity_type) is the primary key (combination of columns with unique values) of this table.
machine_id is the ID of a machine.
process_id is the ID of a process running on the machine with ID machine_id.
activity_type is an ENUM (category) of type ('start', 'end').
timestamp is a float representing the current time in seconds.
'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the
given timestamp.
The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.

There is a factory website that has several machines each running the same number of processes. Write a solution to
find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by
the total time to complete every process on the machine divided by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time, which should be rounded
to 3 decimal places.

Return the result table in any order.

Solution:

1.
select ttt.machine_id,
        ROUND(avg(ttt.x), 3) as processing_time
from
    (select machine_id,
            process_id,
            activity_type,
            timestamp,
            timestamp - LAG(timestamp) over (partition by machine_id, process_id
                        order by machine_id, process_id, timestamp) x
  from Activity ) ttt
  group by ttt.machine_id ;

2.
with CTE as
(
select machine_id,
        activity_type,
        sum(case when activity_type = 'start' then timestamp else 0 end) as start,
        sum(case when activity_type = 'end' then timestamp else 0 end) as endt,
        count(*)/2 cnt
    from Activity
    group by machine_id
)
select machine_id, ROUND((endt - start) / cnt, 3) as processing_time from CTE
########################################################################################################################

577. Employee Bonus

Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| empId       | int     |
| name        | varchar |
| supervisor  | int     |
| salary      | int     |
+-------------+---------+
empId is the primary key column for this table.
Each row of this table indicates the name and the ID of an employee in addition to their salary and the id of their
manager.

Table: Bonus

+-------------+------+
| Column Name | Type |
+-------------+------+
| empId       | int  |
| bonus       | int  |
+-------------+------+
empId is the primary key column for this table.
empId is a foreign key to empId from the Employee table.
Each row of this table contains the id of an employee and their respective bonus.

Write an SQL query to report the name and bonus amount of each employee with a bonus less than 1000.

Return the result table in any order.

Solution:

select e.name, b.bonus from Employee e
left join Bonus b
on e.empId = b.empId
where bonus < 1000
    or bonus is Null;
########################################################################################################################

1280. Students and Examinations

Table: Students

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the primary key (column with unique values) for this table.
Each row of this table contains the ID and the name of one student in the school.

Table: Subjects

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
subject_name is the primary key (column with unique values) for this table.
Each row of this table contains the name of one subject in the school.

Table: Examinations

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
There is no primary key (column with unique values) for this table. It may contain duplicates.
Each student from the Students table takes every course from the Subjects table.
Each row of this table indicates that a student with ID student_id attended the exam of subject_name.

Write a solution to find the number of times each student attended each exam.

Return the result table ordered by student_id and subject_name.

Solution:

select a.student_id,
        a.student_name,
        b.subject_name,
        count(c.subject_name) as attended_exams
  from Students as a
join Subjects as b
left join Examinations as c
      on a.student_id = c.student_id and b.subject_name = c.subject_name
group by a.student_id, b.subject_name
order by a.student_id, b.subject_name;
########################################################################################################################

570. Managers with at Least 5 Direct Reports

Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.

Write a solution to find managers with at least five direct reports.

Return the result table in any order.

Solution:

1.
select e.name
    from Employee e
join
(
    select a.managerId mid
    from Employee a
    group by managerId
    having count(*) >= 5
) b
on b.mid=e.id;

2.
select name from Employee
where id in
(
select managerId
        from Employee
    group by managerId
    having count(*) >= 5
);
########################################################################################################################

1934. Confirmation Rate

Table: Signups

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
user_id is the primary key for this table.
Each row contains information about the signup time for the user with ID user_id.

Table: Confirmations

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
| action         | ENUM     |
+----------------+----------+
(user_id, time_stamp) is the primary key for this table.
user_id is a foreign key with a reference to the Signups table.
action is an ENUM of the type ('confirmed', 'timeout')
Each row of this table indicates that the user with ID user_id requested a confirmation message at time_stamp and that
confirmation message was either confirmed ('confirmed') or expired without confirming ('timeout').

The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested
confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0.
Round the confirmation rate to two decimal places.

Write an SQL query to find the confirmation rate of each user.

Return the result table in any order.

Solution:

1.
select s.user_id, IFNULL(e.cn, 0) confirmation_rate
from Signups s
  left join
(select distinct c.user_id, CAST((c.cnt1 / c.cnt2) as DECIMAL(12,2))  as cn from
(select  user_id, time_stamp, action,
  count(*) over (partition by user_id, action) cnt1,
  count(*) over (partition by user_id) cnt2
from Confirmations) c
where c.action = 'confirmed') e
on e.user_id = s.user_id;

2.
select  distinct s.user_id,
        ROUND(sum(case when c.action = 'confirmed' then 1 else 0 end) over (partition by c.user_id)
                /
        count(*) over (partition by c.user_id), 2) as confirmation_rate
        from Confirmations c
right join Signups s
on c.user_id = s.user_id;
########################################################################################################################
