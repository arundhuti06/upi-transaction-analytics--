DROP TABLE IF EXISTS upi_monthly_statistics;
-- CREATE TABLE
CREATE TABLE upi_monthly_statistics (
    year INT,
    month INT,
    date DATE,

    volume_millions NUMERIC,
    volume_billions NUMERIC,

    value_crores NUMERIC,
    value_billion_inr NUMERIC,
    value_billion_usd NUMERIC,

    banks_live INT,
    avg_transaction_value_inr NUMERIC,

    fiscal_year VARCHAR(20),
    quarter VARCHAR(10),

    yoy_volume_growth_pct NUMERIC,
    yoy_value_growth_pct NUMERIC,

    mom_volume_growth_pct NUMERIC,
    mom_value_growth_pct NUMERIC
);

SELECT * FROM upi_monthly_statistics;
SELECT COUNT(*) FROM upi_monthly_statistics;

-- 1. How has UPI transaction volume changed year by year?
SELECT
    year,
    SUM(volume_millions) AS total_transactions_millions
FROM upi_monthly_statistics
GROUP BY year
ORDER BY year;

-- 2. How has the total transaction value changed year by year?
SELECT
    year,
    SUM(value_crores) AS total_transaction_value_crores
FROM upi_monthly_statistics
GROUP BY year
ORDER BY year;

-- 3. Which 10 months recorded the highest transaction volume?
SELECT
    date,
    volume_millions,
    value_crores,
    banks_live
FROM upi_monthly_statistics
ORDER BY volume_millions DESC
LIMIT 10;

-- 4. Which 10 months recorded the highest transaction value?
SELECT
    date,
    value_crores,
    volume_millions,
    avg_transaction_value_inr
FROM upi_monthly_statistics
ORDER BY value_crores DESC
LIMIT 10;

-- 5. Which months had the highest YoY transaction-volume growth?
SELECT
    date,
    yoy_volume_growth_pct
FROM upi_monthly_statistics
WHERE yoy_volume_growth_pct IS NOT NULL
ORDER BY yoy_volume_growth_pct DESC
LIMIT 10;

-- 6. How has YoY transaction growth changed over time?
SELECT
    date,
    yoy_volume_growth_pct,
    yoy_value_growth_pct
FROM upi_monthly_statistics
WHERE yoy_volume_growth_pct IS NOT NULL
ORDER BY date;

-- 7. Are transaction volume and transaction value growing at the same rate?
SELECT
    date,
    yoy_volume_growth_pct,
    yoy_value_growth_pct,
    ROUND(
        (yoy_value_growth_pct - yoy_volume_growth_pct)::NUMERIC,
        2
    ) AS growth_rate_difference
FROM upi_monthly_statistics
WHERE yoy_volume_growth_pct IS NOT NULL
ORDER BY date;

-- 8. How has the average transaction value changed over time?
SELECT
    date,
    avg_transaction_value_inr
FROM upi_monthly_statistics
ORDER BY date;

-- 9. Which months had the highest average transaction value?
SELECT
    date,
    avg_transaction_value_inr,
    volume_millions,
    value_crores
FROM upi_monthly_statistics
ORDER BY avg_transaction_value_inr DESC
LIMIT 10;

-- 10. Does higher transaction volume correspond to higher average transaction value?
SELECT
    date,
    volume_millions,
    avg_transaction_value_inr
FROM upi_monthly_statistics
ORDER BY date;

-- 11. How has the number of live banks grown?
SELECT
    date,
    banks_live
FROM upi_monthly_statistics
ORDER BY date;

-- 12. Is bank expansion associated with transaction growth?
SELECT
    date,
    banks_live,
    volume_millions,
    value_crores
FROM upi_monthly_statistics
ORDER BY date;

-- 13. Which months of the year typically have the highest transaction volume?
SELECT
    month,
    ROUND(AVG(volume_millions), 2) AS avg_monthly_transactions_millions
FROM upi_monthly_statistics
GROUP BY month
ORDER BY avg_monthly_transactions_millions DESC;

-- 14. Which quarter generates the highest transaction volume and value?
SELECT
    fiscal_year,
    quarter,
    SUM(volume_millions) AS total_transactions_millions,
    SUM(value_crores) AS total_value_crores
FROM upi_monthly_statistics
GROUP BY fiscal_year, quarter
ORDER BY total_transactions_millions DESC;

-- 15. Which months experienced the largest month-over-month changes?
SELECT
    date,
    mom_volume_growth_pct,
    mom_value_growth_pct
FROM upi_monthly_statistics
WHERE mom_volume_growth_pct IS NOT NULL
ORDER BY ABS(mom_volume_growth_pct) DESC
LIMIT 10;