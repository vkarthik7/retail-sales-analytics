/* =============================================================================
   02_DATA_CLEANING.SQL
   Retail Sales Analytics Project
   -----------------------------------------------------------------------------
   Purpose : Profile and validate the staged sales data before analysis -
             checking row counts, missing values, negative sales, duplicates,
             and value ranges.
   ============================================================================= */


/* -----------------------------------------------------------------------------
   1. QUICK LOOK + ROW COUNT
   ----------------------------------------------------------------------------- */
SELECT * FROM staging_train LIMIT 10;

SELECT COUNT(*) AS total_rows FROM staging_train;


/* -----------------------------------------------------------------------------
   2. MISSING AND NEGATIVE SALES
   Negative weekly sales are legitimate net-return weeks (returns exceeded
   sales), concentrated in certain departments - kept as valid data.
   ----------------------------------------------------------------------------- */
SELECT
    COUNT(*)                                              AS total,
    SUM(CASE WHEN weekly_sales IS NULL THEN 1 ELSE 0 END) AS missing_sales,
    SUM(CASE WHEN weekly_sales < 0    THEN 1 ELSE 0 END)  AS negative_sales
FROM staging_train;

-- Inspect the most negative rows to confirm they are realistic (net returns)
SELECT store, dept, sales_date, weekly_sales
FROM staging_train
WHERE weekly_sales < 0
ORDER BY weekly_sales
LIMIT 10;


/* -----------------------------------------------------------------------------
   3. DUPLICATE CHECK
   Each store + department + week combination should be unique.
   No rows returned = no duplicates.
   ----------------------------------------------------------------------------- */
SELECT store, dept, sales_date, COUNT(*) AS cnt
FROM staging_train
GROUP BY store, dept, sales_date
HAVING COUNT(*) > 1;


/* -----------------------------------------------------------------------------
   4. VALUE / RANGE VALIDATION
   ----------------------------------------------------------------------------- */
-- Holiday flag should contain only TRUE / FALSE
SELECT is_holiday, COUNT(*) AS cnt
FROM staging_train
GROUP BY is_holiday;

-- Date range should be sensible
SELECT MIN(sales_date) AS earliest, MAX(sales_date) AS latest
FROM staging_train;

-- Store and department IDs should fall in expected ranges
SELECT
    MIN(store) AS min_store, MAX(store) AS max_store,
    MIN(dept)  AS min_dept,  MAX(dept)  AS max_dept
FROM staging_train;
