/* =============================================================================
   03_EXPLORATORY_ANALYSIS.SQL
   Retail Sales Analytics Project
   -----------------------------------------------------------------------------
   Purpose : Answer the core business questions - store performance, department
             performance, seasonality, and per-store leaders - using joins,
             aggregations, and window functions.
   ============================================================================= */


/* -----------------------------------------------------------------------------
   1. SALES BY STORE TYPE
   How do the store formats (A / B / C) compare on store count and total sales?
   ----------------------------------------------------------------------------- */
SELECT
    s.type,
    COUNT(DISTINCT s.store)   AS num_stores,
    SUM(t.weekly_sales)       AS total_sales
FROM staging_train t
JOIN staging_stores s ON t.store = s.store
GROUP BY s.type
ORDER BY total_sales DESC;


/* -----------------------------------------------------------------------------
   2. TOP AND BOTTOM STORES BY TOTAL SALES
   ----------------------------------------------------------------------------- */
-- Top 5 stores
SELECT
    store,
    SUM(weekly_sales) AS total_sales
FROM staging_train
GROUP BY store
ORDER BY total_sales DESC
LIMIT 5;

-- Bottom 5 stores
SELECT
    store,
    SUM(weekly_sales) AS total_sales
FROM staging_train
GROUP BY store
ORDER BY total_sales ASC
LIMIT 5;

-- Top / bottom stores WITH their store type (to see if format explains rank)
SELECT
    s.store,
    s.type,
    SUM(t.weekly_sales) AS total_sales
FROM staging_train t
JOIN staging_stores s ON t.store = s.store
GROUP BY s.store, s.type
ORDER BY total_sales DESC
LIMIT 5;

SELECT
    s.store,
    s.type,
    SUM(t.weekly_sales) AS total_sales
FROM staging_train t
JOIN staging_stores s ON t.store = s.store
GROUP BY s.store, s.type
ORDER BY total_sales ASC
LIMIT 5;


/* -----------------------------------------------------------------------------
   3. ROOT-CAUSE: WHY ARE TWO LARGE-FORMAT (TYPE A) STORES UNDERPERFORMING?
   Stores 33 and 36 are Type A yet rank low. Investigate size, department
   count, per-department sales, and year-over-year trend.
   ----------------------------------------------------------------------------- */
-- 3a. Are 33 and 36 the smallest Type A stores by size?
SELECT store, type, size
FROM staging_stores
WHERE type = 'A'
ORDER BY size ASC;

-- 3b. Department count and per-department sales vs a top store (20)
SELECT
    store,
    COUNT(DISTINCT dept)         AS num_departments,
    ROUND(SUM(weekly_sales), 0)  AS total_sales,
    ROUND(AVG(weekly_sales), 0)  AS avg_per_dept_week
FROM staging_train
WHERE store IN (20, 33, 36)
GROUP BY store;

-- 3c. Year-over-year trend (is the store stable or declining?)
SELECT
    store,
    YEAR(sales_date)             AS yr,
    ROUND(SUM(weekly_sales), 0)  AS yearly_sales
FROM staging_train
WHERE store IN (33, 36)
GROUP BY store, YEAR(sales_date)
ORDER BY store, yr;


/* -----------------------------------------------------------------------------
   4. TOP AND BOTTOM DEPARTMENTS BY TOTAL SALES
   ----------------------------------------------------------------------------- */
-- Top 5 departments
SELECT
    dept,
    SUM(weekly_sales) AS total_sales
FROM staging_train
GROUP BY dept
ORDER BY total_sales DESC
LIMIT 5;

-- Bottom 5 departments (flags the net-negative department)
SELECT
    dept,
    SUM(weekly_sales) AS total_sales
FROM staging_train
GROUP BY dept
ORDER BY total_sales ASC
LIMIT 5;


/* -----------------------------------------------------------------------------
   5. MONTHLY SALES TREND (seasonality)
   ----------------------------------------------------------------------------- */
SELECT
    YEAR(sales_date)             AS yr,
    MONTH(sales_date)            AS mon,
    ROUND(SUM(weekly_sales), 0)  AS total_sales
FROM staging_train
GROUP BY yr, mon
ORDER BY yr, mon;


/* -----------------------------------------------------------------------------
   6. TOP-SELLING DEPARTMENT WITHIN EACH STORE  (window function)
   RANK() partitioned by store finds each store's #1 department.
   ----------------------------------------------------------------------------- */
WITH ranked AS (
    SELECT
        store,
        dept,
        SUM(weekly_sales) AS total_sales,
        RANK() OVER (PARTITION BY store ORDER BY SUM(weekly_sales) DESC) AS rnk
    FROM staging_train
    GROUP BY store, dept
)
SELECT store, dept, total_sales, rnk
FROM ranked
WHERE rnk = 1
ORDER BY store;
