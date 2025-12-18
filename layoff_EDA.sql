SELECT * 
FROM layoff3;

-- ======================================================
-- EXPLORATORY DATA ANALYSIS (EDA)
-- Dataset: Global Layoffs (2020–2025)
-- ======================================================

-- Convert total_laid_off to INT to avoid incorrect aggregation results
ALTER TABLE layoff3
MODIFY COLUMN total_laid_off INT;

-- ------------------------------------------------------
-- Maximum Layoff Metrics
-- ------------------------------------------------------

-- Maximum single layoff event & maximum layoff percentage
SELECT 
    MAX(total_laid_off) AS max_laid_off,
    MAX(percentage_laid_off) AS max_layoff_percentage
FROM layoff3;

-- ------------------------------------------------------
-- Companies with 100% Workforce Layoffs
-- ------------------------------------------------------

SELECT 
    company,
    percentage_laid_off
FROM layoff3
WHERE percentage_laid_off = 1;

-- ------------------------------------------------------
-- Companies with the Highest Total Layoffs
-- ------------------------------------------------------

SELECT 
    company,
    SUM(total_laid_off) AS total_laid_off
FROM layoff3
GROUP BY company
ORDER BY total_laid_off DESC;

-- ------------------------------------------------------
-- Time Period Covered in Dataset
-- ------------------------------------------------------

SELECT 
    MIN(date) AS start_date,
    MAX(date) AS end_date
FROM layoff3;

-- ------------------------------------------------------
-- Industries Most Affected by Layoffs
-- ------------------------------------------------------

SELECT 
    industry,
    SUM(total_laid_off) AS total_laid_off
FROM layoff3
GROUP BY industry
ORDER BY total_laid_off DESC;

-- ------------------------------------------------------
-- Countries Most Impacted by Layoffs
-- ------------------------------------------------------

SELECT 
    country,
    SUM(total_laid_off) AS total_laid_off
FROM layoff3
GROUP BY country
ORDER BY total_laid_off DESC;

-- ------------------------------------------------------
-- Layoffs by Year
-- ------------------------------------------------------

SELECT 
    YEAR(date) AS year,
    SUM(total_laid_off) AS total_laid_off
FROM layoff3
GROUP BY YEAR(date)
ORDER BY total_laid_off DESC;

-- ------------------------------------------------------
-- Layoffs by Month
-- ------------------------------------------------------

SELECT 
    SUBSTRING(date, 1, 7) AS month,
    SUM(total_laid_off) AS total_layoffs
FROM layoff3
GROUP BY month
ORDER BY month ASC;

-- ------------------------------------------------------
-- Rolling Cumulative Layoffs by Month
-- ------------------------------------------------------

WITH rolling_total AS (
    SELECT 
        SUBSTRING(date, 1, 7) AS month,
        SUM(total_laid_off) AS total_layoffs
    FROM layoff3
    GROUP BY month
)
SELECT 
    month,
    total_layoffs,
    SUM(total_layoffs) OVER (ORDER BY month) AS rolling_total
FROM rolling_total;

-- ------------------------------------------------------
-- Company-wise Layoffs per Year
-- ------------------------------------------------------

SELECT 
    company,
    YEAR(date) AS year,
    SUM(total_laid_off) AS total_laid_off
FROM layoff3
GROUP BY company, YEAR(date)
ORDER BY year ASC;

-- ------------------------------------------------------
-- Top 5 Companies by Layoffs Per Year
-- ------------------------------------------------------

WITH company_year AS (
    SELECT 
        company,
        YEAR(date) AS year,
        SUM(total_laid_off) AS total_laid_off
    FROM layoff3
    GROUP BY company, YEAR(date)
),
company_year_rank AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY year 
               ORDER BY total_laid_off DESC
           ) AS ranking
    FROM company_year
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;


-- =====================================================
-- 1️⃣ LAYOFF INTENSITY & PATTERNS
-- =====================================================


-- 🔹 Average layoffs per event (severity of a typical layoff)
SELECT 
    AVG(total_laid_off) AS avg_layoffs_per_event
FROM layoff3;


-- =====================================================
-- 2️⃣ COMPANY BEHAVIOR ANALYSIS
-- =====================================================

-- 🔹 Companies with repeated layoffs (instability indicator)
SELECT 
    company, 
    COUNT(*) AS layoff_events
FROM layoff3
GROUP BY company
HAVING COUNT(*) > 1
ORDER BY layoff_events DESC;

-- 🔹 Companies with highest average layoff size
SELECT 
    company, 
    AVG(total_laid_off) AS avg_layoff_size
FROM layoff3
GROUP BY company
ORDER BY avg_layoff_size DESC;


-- =====================================================
-- 3️⃣ INDUSTRY-LEVEL INSIGHTS
-- =====================================================

-- 🔹 Layoff frequency by industry
SELECT 
    industry, 
    COUNT(*) AS layoff_events
FROM layoff3
GROUP BY industry
ORDER BY layoff_events DESC;

-- 🔹 Industries with highest average layoff size
SELECT 
    industry, 
    AVG(total_laid_off) AS avg_layoffs
FROM layoff3
GROUP BY industry
ORDER BY avg_layoffs DESC;


-- =====================================================
-- 4️⃣ COUNTRY & GEOGRAPHY TRENDS
-- =====================================================

-- 🔹 Average layoff size per country
SELECT 
    country, 
    AVG(total_laid_off) AS avg_layoffs
FROM layoff3
GROUP BY country
ORDER BY avg_layoffs DESC;

-- 🔹 Countries with most 100% workforce layoffs
SELECT 
    country, 
    COUNT(*) AS full_layoffs
FROM layoff3
WHERE percentage_laid_off = 1
GROUP BY country
ORDER BY full_layoffs DESC;


-- =====================================================
-- 5️⃣ TIME-BASED DEEP DIVE
-- =====================================================

-- 🔹 Year-over-year growth / decline in layoffs
WITH yearly AS (
    SELECT 
        YEAR(date) AS year, 
        SUM(total_laid_off) AS layoffs
    FROM layoff3
    GROUP BY YEAR(date)
)
SELECT 
    year, 
    layoffs,
    layoffs - LAG(layoffs) OVER (ORDER BY year) AS yoy_change
FROM yearly;

-- 🔹 Worst month in history (highest layoffs)
SELECT 
    SUBSTRING(date, 1, 7) AS month, 
    SUM(total_laid_off) AS layoffs
FROM layoff3
GROUP BY month
ORDER BY layoffs DESC
LIMIT 1;


-- =====================================================
-- 6️⃣ STAGE & FUNDING ANALYSIS
-- =====================================================

-- 🔹 Total layoffs by company stage
SELECT 
    stage, 
    SUM(total_laid_off) AS layoffs
FROM layoff3
GROUP BY stage
ORDER BY layoffs DESC;

-- 🔹 Early-stage vs late-stage companies impact
SELECT 
    CASE 
        WHEN stage IN ('Seed','Series A','Series B') 
             THEN 'Early Stage'
        ELSE 'Late Stage'
    END AS company_stage,
    SUM(total_laid_off) AS layoffs
FROM layoff3
GROUP BY company_stage;


-- =====================================================
-- 7️⃣ RISK SIGNALS & RED FLAGS
-- =====================================================

-- 🔹 High-risk events: large volume + high percentage layoffs
SELECT 
    company, 
    total_laid_off, 
    percentage_laid_off
FROM layoff3
WHERE percentage_laid_off >= 0.5
  AND total_laid_off >= 500
ORDER BY total_laid_off DESC;

-- 🔹 Industries with frequent full shutdowns (100% layoffs)
SELECT 
    industry, 
    COUNT(*) AS full_shutdowns
FROM layoff3
WHERE percentage_laid_off = 1
GROUP BY industry
ORDER BY full_shutdowns DESC;
