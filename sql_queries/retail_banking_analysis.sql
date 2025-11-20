-- Retail Banking Operations Analysis
-- Analyzes transaction patterns and customer behavior in retail banking

-- Transaction Volume by Hour
SELECT 
    DATEPART(HOUR, transaction_time) AS hour,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM retail_transactions
WHERE transaction_date >= DATEADD(MONTH, -3, GETDATE())
GROUP BY DATEPART(HOUR, transaction_time)
ORDER BY hour;

-- Customer Segmentation
SELECT 
    customer_id,
    COUNT(transaction_id) AS total_transactions,
    SUM(amount) AS total_spent,
    CASE 
        WHEN SUM(amount) > 50000 THEN 'Premium'
        WHEN SUM(amount) > 20000 THEN 'Gold'
        ELSE 'Standard'
    END AS customer_tier
FROM retail_transactions
GROUP BY customer_id
ORDER BY total_spent DESC;

-- Channel Performance
SELECT 
    transaction_channel,
    COUNT(*) AS count,
    AVG(amount) AS avg_amount
FROM retail_transactions
GROUP BY transaction_channel;
