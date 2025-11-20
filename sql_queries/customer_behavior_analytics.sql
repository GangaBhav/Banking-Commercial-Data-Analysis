-- Customer Behavior Analytics
-- Analyzes customer patterns, segmentation, and engagement metrics

-- Customer Segmentation by Transaction Behavior
SELECT 
    customer_id,
    customer_name,
    COUNT(transaction_id) AS total_transactions,
    SUM(transaction_amount) AS total_value,
    AVG(transaction_amount) AS avg_transaction_value,
    MAX(transaction_date) AS last_transaction_date,
    CASE 
        WHEN COUNT(transaction_id) >= 50 AND AVG(transaction_amount) > 1000 THEN 'VIP'
        WHEN COUNT(transaction_id) >= 25 THEN 'Frequent'
        WHEN COUNT(transaction_id) >= 10 THEN 'Regular'
        ELSE 'Occasional'
    END AS customer_segment
FROM customer_transactions
WHERE transaction_date >= DATEADD(MONTH, -6, GETDATE())
GROUP BY customer_id, customer_name
ORDER BY total_value DESC;

-- Product Adoption Analysis
SELECT 
    product_type,
    COUNT(DISTINCT customer_id) AS customers_using,
    COUNT(*) AS total_usage,
    AVG(usage_duration_days) AS avg_usage_duration
FROM product_usage
GROUP BY product_type
ORDER BY customers_using DESC;

-- Cross-Selling Opportunities
SELECT 
    c.customer_id,
    c.customer_name,
    STRING_AGG(p.product_type, ', ') AS current_products,
    COUNT(DISTINCT p.product_type) AS products_held,
    CASE 
        WHEN COUNT(DISTINCT p.product_type) = 1 THEN 'High Potential'
        WHEN COUNT(DISTINCT p.product_type) = 2 THEN 'Medium Potential'
        ELSE 'Low Potential'
    END AS cross_sell_opportunity
FROM customers c
JOIN product_usage p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.product_type) < 3
ORDER BY products_held;

-- Churn Risk Analysis
SELECT 
    customer_id,
    customer_name,
    DATEDIFF(DAY, last_login_date, GETDATE()) AS days_since_login,
    DATEDIFF(DAY, last_transaction_date, GETDATE()) AS days_since_transaction,
    account_balance,
    CASE 
        WHEN DATEDIFF(DAY, last_transaction_date, GETDATE()) > 90 THEN 'High Risk'
        WHEN DATEDIFF(DAY, last_transaction_date, GETDATE()) > 60 THEN 'Medium Risk'
        WHEN DATEDIFF(DAY, last_transaction_date, GETDATE()) > 30 THEN 'Low Risk'
        ELSE 'Active'
    END AS churn_risk
FROM customer_activity
WHERE account_status = 'Active'
ORDER BY days_since_transaction DESC;

-- Digital vs Branch Banking Preferences
SELECT 
    customer_id,
    SUM(CASE WHEN channel = 'Digital' THEN 1 ELSE 0 END) AS digital_transactions,
    SUM(CASE WHEN channel = 'Branch' THEN 1 ELSE 0 END) AS branch_transactions,
    CAST(SUM(CASE WHEN channel = 'Digital' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS digital_adoption_rate,
    CASE 
        WHEN CAST(SUM(CASE WHEN channel = 'Digital' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) > 80 THEN 'Digital Native'
        WHEN CAST(SUM(CASE WHEN channel = 'Digital' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) > 50 THEN 'Hybrid User'
        ELSE 'Branch Preferred'
    END AS banking_preference
FROM customer_transactions
GROUP BY customer_id
ORDER BY digital_adoption_rate DESC;

-- Customer Lifetime Value
SELECT 
    customer_id,
    customer_name,
    DATEDIFF(MONTH, account_open_date, GETDATE()) AS customer_tenure_months,
    SUM(transaction_amount) AS total_revenue,
    SUM(transaction_amount) / NULLIF(DATEDIFF(MONTH, account_open_date, GETDATE()), 0) AS avg_monthly_value,
    COUNT(DISTINCT product_type) AS products_held
FROM customer_value_analysis
GROUP BY customer_id, customer_name, account_open_date
ORDER BY avg_monthly_value DESC;
