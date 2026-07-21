/*
===============================================================================
Problem: Highest Salary Job Title
Platform: StrataScratch

Difficulty: Easy

Problem Summary:
Find the job title(s) of the worker(s) who earn the highest salary,
considering only workers who have an official job title in the title table.

If multiple workers share the highest salary, return all corresponding job titles.

Concepts Used:
- INNER JOIN
- Common Table Expressions (CTEs)
- Aggregate Functions (MAX)
- Subqueries

Approach:
1. Join the worker and title tables using the worker ID to include only
   employees with an official job title.
2. Group the data by job title and calculate the maximum salary for each title.
3. Find the overall highest salary among all job titles.
4. Return the job title(s) whose maximum salary matches the overall highest salary.

===============================================================================
*/

WITH join_cte AS (
    SELECT
        MAX(salary) AS max_salary,
        worker_title
    FROM worker w
    JOIN title t
        ON w.worker_id = t.worker_ref_id
    GROUP BY worker_title
)

SELECT
    worker_title
FROM join_cte
WHERE max_salary = (
    SELECT MAX(max_salary)
    FROM join_cte
);
