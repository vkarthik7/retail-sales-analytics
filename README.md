# Retail Sales Analytics & Demand Forecasting

An end-to-end retail analytics project on real store sales data — from SQL data
pipeline through statistical forecasting to an interactive Tableau dashboard.
The project follows the full analyst workflow: **load → clean → analyze →
forecast → visualize**.

**Live dashboard:** [View on Tableau Public](https://public.tableau.com/app/profile/karthik.vajja/viz/Reatail_analysis/RetailAnalysis)

---

## Overview

The dataset contains ~421,000 weekly sales records across 45 stores and 81
departments. Using SQL, Python, and Tableau, this project analyzes sales
performance, investigates underperforming stores, and forecasts future demand.

---

## Tools & Skills

- **SQL (MySQL):** staging tables, data loading, data-quality validation, joins,
  aggregations, CTEs, window functions
- **Python (pandas, statsmodels, scikit-learn):** time-series forecasting and
  model evaluation
- **Tableau Public:** interactive KPI + performance dashboard

---

## Project Structure

```
retail-project/
├── sql/
│   ├── 01_data_loading.sql        # database, staging tables, data loading
│   ├── 02_data_cleaning.sql       # data-quality profiling & validation
│   └── 03_exploratory_analysis.sql# business-question analysis
├── python/
│   └── retail_forecasting.ipynb   # time-series forecasting notebook
├── data/
│   ├── weekly_sales.csv           # weekly sales (time series)
│   ├── stores_summary.csv         # sales by store
│   ├── dept_summary.csv           # sales by department
│   └── forecast.csv               # forecast output
├── dashboard/
│   └── Retail_analysis.twbx       # packaged Tableau dashboard
└── README.md
```

---

## Workflow

### 1. Data Loading (SQL)
Created a `retail_db` database and loaded three raw source files (sales,
external features, store attributes) into staging tables. Handled real-world
loading issues including inconsistent line endings and enabling local file
import.

### 2. Data Cleaning & Validation (SQL)
Profiled the data for missing values, duplicates, and out-of-range values.
Investigated ~1,300 negative-sales rows and confirmed they were legitimate
net-return weeks (returns exceeding sales) rather than errors, so they were
retained.

### 3. Exploratory Analysis (SQL)
Answered core business questions:
- **Store type performance** — the largest store format drives the majority of
  total sales and outperforms the smallest format ~3x per store.
- **Top / bottom stores** — identified the highest and lowest performers, and
  surfaced two large-format stores ranking unexpectedly low.
- **Root-cause analysis** — investigated the two underperforming large stores by
  size, department count, per-department sales, and year-over-year trend;
  distinguished a structurally small-but-stable store from a genuinely declining
  one.
- **Department performance** — found heavy sales concentration in a few
  departments and flagged one net-negative department.
- **Seasonality** — monthly trend shows a strong, repeating holiday-season peak.
- **Per-store leaders** — used a `RANK()` window function to find each store's
  top-selling department.

### 4. Forecasting (Python)
Built and compared multiple time-series forecasting methods (naive, seasonal
naive, moving average, Holt-Winters, ARIMA, SARIMA) using a chronological
train/test split and Mean Absolute Error (MAE) for evaluation. The simplest
seasonal method outperformed several complex models, and an **ensemble** of two
methods beat every individual model — reinforcing that model choice must match
the data and be validated empirically.

### 5. Dashboard (Tableau)
An interactive dashboard presenting KPIs (total sales, average sales, store and
department counts), monthly sales trend, store and department performance
(color-coded above/below average), and the demand forecast.

---

## Key Findings

- Sales are highly concentrated in the largest store format and a handful of
  departments.
- Two large-format stores underperform: one is structurally small but stable,
  the other is genuinely declining and warrants investigation.
- Sales show strong, predictable holiday seasonality.
- For this dataset, a simple seasonal method (and an ensemble) forecast most
  accurately — complexity did not automatically improve results.

---

## Notes

Data is public, anonymized retail sales data. Store and department identifiers
are numeric codes.
