-- Commercial Lending Assessment
-- Analyzes loan portfolios, risk factors, and lending performance

-- Loan Approval Rate Analysis
SELECT 
    industry_sector,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) AS approved_count,
    CAST(SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS approval_rate
FROM commercial_loan_applications
WHERE application_date >= DATEADD(YEAR, -1, GETDATE())
GROUP BY industry_sector
ORDER BY approval_rate DESC;

-- Credit Score Distribution
SELECT 
    CASE 
        WHEN credit_score >= 750 THEN 'Excellent (750+)'
        WHEN credit_score >= 700 THEN 'Good (700-749)'
        WHEN credit_score >= 650 THEN 'Fair (650-699)'
        ELSE 'Poor (<650)'
    END AS credit_category,
    COUNT(*) AS borrower_count,
    AVG(loan_amount) AS avg_loan_amount,
    AVG(interest_rate) AS avg_interest_rate
FROM commercial_loans
GROUP BY 
    CASE 
        WHEN credit_score >= 750 THEN 'Excellent (750+)'
        WHEN credit_score >= 700 THEN 'Good (700-749)'
        WHEN credit_score >= 650 THEN 'Fair (650-699)'
        ELSE 'Poor (<650)'
    END
ORDER BY avg_interest_rate;

-- Default Risk Analysis
SELECT 
    loan_id,
    borrower_name,
    industry_sector,
    loan_amount,
    DATEDIFF(DAY, due_date, GETDATE()) AS days_overdue,
    CASE 
        WHEN DATEDIFF(DAY, due_date, GETDATE()) > 90 THEN 'High Risk'
        WHEN DATEDIFF(DAY, due_date, GETDATE()) > 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level
FROM commercial_loans
WHERE payment_status = 'Overdue'
ORDER BY days_overdue DESC;

-- Industry Lending Trends
SELECT 
    industry_sector,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_lending,
    AVG(loan_amount) AS avg_loan_size,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS default_count
FROM commercial_loans
GROUP BY industry_sector
ORDER BY total_lending DESC;

-- Portfolio Risk Assessment
SELECT 
    risk_category,
    COUNT(*) AS loan_count,
    SUM(outstanding_balance) AS total_exposure,
    AVG(debt_to_income_ratio) AS avg_dti_ratio
FROM commercial_loans
GROUP BY risk_category
ORDER BY total_exposure DESC;
