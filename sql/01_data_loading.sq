/* =============================================================================
   01_DATA_LOADING.SQL
   Retail Sales Analytics Project
   -----------------------------------------------------------------------------
   Purpose : Create the database, build staging tables, and load the three raw
             source files (sales, features, stores) into them.
   Notes   : Data is loaded into all-VARCHAR-friendly staging tables first so a
             stray character never breaks the import. Cleaning/typing happens in
             02_data_cleaning.sql.
   ============================================================================= */


/* -----------------------------------------------------------------------------
   1. CREATE THE DATABASE
   ----------------------------------------------------------------------------- */
CREATE DATABASE retail_db;
USE retail_db;


/* -----------------------------------------------------------------------------
   2. STAGING TABLE: SALES (one row per store + department + week)
   ----------------------------------------------------------------------------- */
CREATE TABLE staging_train (
    store         INT,
    dept          INT,
    sales_date    DATE,
    weekly_sales  DECIMAL(12,2),
    is_holiday    VARCHAR(10)
);

-- Enable local file loading (required once per server session)
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'training.csv'          -- adjust path to your file location
INTO TABLE staging_train
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


/* -----------------------------------------------------------------------------
   3. STAGING TABLE: FEATURES (external factors per store + week)
   Markdown / CPI / unemployment kept as VARCHAR because the raw file contains
   the text value "NA"; these are converted to typed numbers during cleaning.
   ----------------------------------------------------------------------------- */
CREATE TABLE staging_features (
    store         INT,
    sales_date    DATE,
    temperature   DECIMAL(8,2),
    fuel_price    DECIMAL(8,3),
    markdown1     VARCHAR(20),
    markdown2     VARCHAR(20),
    markdown3     VARCHAR(20),
    markdown4     VARCHAR(20),
    markdown5     VARCHAR(20),
    cpi           VARCHAR(20),
    unemployment  VARCHAR(20),
    is_holiday    VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'feature.csv'           -- adjust path to your file location
INTO TABLE staging_features
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


/* -----------------------------------------------------------------------------
   4. STAGING TABLE: STORES (store attributes)
   NOTE: this source file uses carriage-return line endings ('\r'), so the
   LINES TERMINATED clause differs from the other two files.
   ----------------------------------------------------------------------------- */
CREATE TABLE staging_stores (
    store   INT,
    type    VARCHAR(5),
    size    INT
);

LOAD DATA LOCAL INFILE 'stores.csv'            -- adjust path to your file location
INTO TABLE staging_stores
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r'
IGNORE 1 LINES;


/* -----------------------------------------------------------------------------
   5. SANITY CHECK: confirm every file loaded the expected number of rows
   ----------------------------------------------------------------------------- */
SELECT 'train'    AS source, COUNT(*) AS row_count FROM staging_train
UNION ALL
SELECT 'features', COUNT(*)            FROM staging_features
UNION ALL
SELECT 'stores',   COUNT(*)            FROM staging_stores;
