/*
===============================================================================
Problem: Users' Average Session Time
Platform: StrataScratch

Difficulty: Medium

Problem Summary:
Calculate each user's average session duration.
A session is defined as the time between a page_load and a page_exit event.

Rules:
- Assume one session per user per day.
- If multiple page_load events exist, use the latest page_load.
- If multiple page_exit events exist, use the earliest page_exit.
- Only include sessions where page_load occurs before page_exit on the same day.

Concepts Used:
- Common Table Expressions (CTEs)
- Aggregate Functions (MAX, MIN, AVG)
- INNER JOIN
- Date & Time Functions
- Filtering

Approach:
1. Find the latest page_load for each user on each day.
2. Find the earliest page_exit for each user on each day.
3. Join both datasets on user_id and date.
4. Keep only valid sessions where page_load < page_exit.
5. Calculate the average session duration for each user.

===============================================================================
*/

WITH load_cte AS (
    SELECT
        user_id,
        timestamp::date AS session_date,
        MAX(timestamp::time) AS load_time
    FROM facebook_web_log
    WHERE action = 'page_load'
    GROUP BY user_id, timestamp::date
),

exit_cte AS (
    SELECT
        user_id,
        timestamp::date AS session_date,
        MIN(timestamp::time) AS exit_time
    FROM facebook_web_log
    WHERE action = 'page_exit'
    GROUP BY user_id, timestamp::date
)

SELECT
    l.user_id,
    AVG(e.exit_time - l.load_time) AS average_session_time
FROM load_cte l
JOIN exit_cte e
    ON l.user_id = e.user_id
   AND l.session_date = e.session_date
WHERE e.exit_time > l.load_time
GROUP BY l.user_id;
