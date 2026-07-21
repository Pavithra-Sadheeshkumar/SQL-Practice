
/*
===============================================================================
Problem: Returning Active Users
Platform: StrataScratch

Difficulty: Medium

Problem Summary:
Identify users who made their second purchase within 1 to 7 days after
their first purchase. Ignore same-day purchases.

Concepts Used:
- CTEs
- Window Functions (ROW_NUMBER)
- Self Join
- Date Arithmetic

Approach:
1. Assign a sequence number to each purchase for every user.
2. Extract the first and second purchases.
3. Compare the purchase dates.
4. Return users whose second purchase occurred between 1 and 7 days later.

===============================================================================
*/

WITH ranked_purchases AS (
    SELECT
        user_id,
        created_at,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY created_at
        ) AS purchase_number
    FROM amazon_transactions
)

SELECT DISTINCT
    first_purchase.user_id
FROM ranked_purchases first_purchase
JOIN ranked_purchases second_purchase
    ON first_purchase.user_id = second_purchase.user_id
WHERE first_purchase.purchase_number = 1
  AND second_purchase.purchase_number = 2
  AND (second_purchase.created_at - first_purchase.created_at) BETWEEN 1 AND 7;
