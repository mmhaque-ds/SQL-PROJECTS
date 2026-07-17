# SQL Data Cleaning Project — Layoffs Dataset

## 📌 Project Overview

This project demonstrates a complete data-cleaning workflow using **MySQL**. The dataset contains information about layoffs from companies around the world, including company names, locations, industries, number of employees laid off, layoff percentages, dates, company stages, countries, and funds raised.

The goal of this project was to transform raw, inconsistent data into a clean and structured dataset that can be used for further analysis and decision-making.

---

## 🎯 Project Objectives

The main objectives of this project were to:

* Remove duplicate records
* Standardize inconsistent data
* Clean unnecessary spaces and formatting issues
* Handle NULL and blank values
* Convert data types appropriately
* Fill missing industry values where possible
* Remove rows that could not provide meaningful information
* Remove unnecessary columns
* Preserve the original raw data
* Create a final clean dataset ready for analysis

---

## 🛠️ Tools & Technologies

* **MySQL**
* **SQL**
* **Window Functions**
* **Common Table Expressions (CTEs)**
* **Self-JOIN**
* **TRIM()**
* **STR_TO_DATE()**
* **ALTER TABLE**
* **DELETE**
* **UPDATE**
* **CREATE TABLE**
* **Kaggle Dataset**

---

## 📂 Dataset

The dataset used in this project is the **Layoffs 2022 dataset**.

The original dataset contains information such as:

| Column                  | Description                          |
| ----------------------- | ------------------------------------ |
| `company`               | Name of the company                  |
| `location`              | Location of the company              |
| `industry`              | Industry of the company              |
| `total_laid_off`        | Total number of employees laid off   |
| `percentage_laid_off`   | Percentage of employees laid off     |
| `date`                  | Date of the layoff                   |
| `stage`                 | Company funding stage                |
| `country`               | Country where the company is located |
| `funds_raised_millions` | Total funds raised in millions       |

---

## 🔄 Data Cleaning Process

### 1. Preserve the Original Data

A staging table was created from the original table before performing any modifications.

```sql
CREATE TABLE layoffs_staging
LIKE layoffs;
```

The original data was then copied into the staging table.

This approach protects the original data and allows the cleaning process to be performed safely.

---

### 2. Identify and Remove Duplicate Records

Duplicate records were identified using the `ROW_NUMBER()` window function.

```sql
ROW_NUMBER() OVER(
    PARTITION BY company,
                 location,
                 industry,
                 total_laid_off,
                 percentage_laid_off,
                 date,
                 stage,
                 country,
                 funds_raised_millions
)
```

A duplicate staging table was created to identify duplicate rows and remove records where:

```sql
row_num > 1
```

This ensures that duplicate records do not affect future analysis.

---

### 3. Standardize Company Names

Unnecessary spaces were removed from company names using the `TRIM()` function.

```sql
UPDATE layoffs_staging2
SET company = TRIM(company);
```

This helps ensure that company names are consistently formatted.

---

### 4. Standardize Industry Values

Similar industry values were standardized.

For example, different values beginning with `Crypto` were combined into one consistent category:

```sql
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```

This prevents the same industry from being treated as multiple separate categories.

---

### 5. Clean Country Names

Unnecessary punctuation was removed from country values.

```sql
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);
```

This helps standardize country names for future analysis.

---

### 6. Convert Date Data Types

The original date values were stored as text. They were converted into a proper date format using `STR_TO_DATE()`.

```sql
UPDATE layoffs_staging2
SET date = STR_TO_DATE(date, '%m/%d/%Y');
```

The column was then changed to the `DATE` data type:

```sql
ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;
```

This makes the date column suitable for date-based analysis.

---

### 7. Handle NULL and Blank Values

Blank industry values were converted to `NULL`.

```sql
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';
```

Missing industry values were then filled where the same company had a known industry value by using a self-join.

```sql
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
```

---

### 8. Remove Rows Without Useful Layoff Information

Rows where both `total_laid_off` and `percentage_laid_off` were missing were removed.

```sql
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```

These rows did not contain meaningful layoff information for analysis.

---

### 9. Remove Temporary Columns

After duplicate removal was completed, the temporary `row_num` column was removed.

```sql
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
```

The resulting table represents the final cleaned dataset.

---

### 10. Create a Backup of the Cleaned Data

A backup table was created to preserve the final cleaned dataset.

```sql
CREATE TABLE layoffs_staging2_backup AS
SELECT *
FROM layoffs_staging2;
```

This provides an additional backup before performing future analysis.

---

## 🗂️ Project Structure

```text
SQL_Projects/
│
├── Data cleaning on SQL full project.sql
│
├── Data cleaning on SQL full project.csv
│
└── README.md
```

### Files

#### `Data cleaning on SQL full project.sql`

Contains the complete SQL data-cleaning process, including:

* Duplicate detection and removal
* Data standardization
* NULL value handling
* Data type conversion
* Self-joins
* Window functions
* Table creation and modification

#### `Data cleaning on SQL full project.csv`

Contains the cleaned dataset exported from MySQL and ready for further analysis.

#### `README.md`

Documentation explaining the project, cleaning process, SQL techniques, and results.

---

## 🧠 Key SQL Concepts Demonstrated

This project demonstrates practical experience with:

* `CREATE TABLE`
* `INSERT INTO`
* `SELECT`
* `UPDATE`
* `DELETE`
* `ALTER TABLE`
* `DROP COLUMN`
* `CREATE TABLE AS SELECT`
* `ROW_NUMBER()`
* Window Functions
* Common Table Expressions (CTEs)
* Self-JOIN
* `TRIM()`
* `STR_TO_DATE()`
* `LIKE`
* `IS NULL`
* Data type conversion

---

## 📊 Project Outcome

After completing the cleaning process, the raw layoffs dataset was transformed into a more reliable and analysis-ready dataset.

The final dataset:

* Contains fewer duplicate records
* Has standardized company, industry, and country values
* Uses a proper date data type
* Has unnecessary temporary columns removed
* Contains improved handling of missing values
* Is ready for exploratory data analysis and visualization

---

## 🚀 Future Analysis

The cleaned dataset can be used for additional analysis, such as:

* Which companies had the highest number of layoffs?
* Which industries experienced the most layoffs?
* Which countries were most affected?
* How did layoffs change over time?
* Which company stages had the most layoffs?
* What relationship exists between funding and layoffs?
* Which companies had the highest layoff percentages?

---

## 📚 Data Source

The original dataset was obtained from Kaggle's Layoffs 2022 dataset.

Dataset source: **Kaggle — Layoffs 2022**

---

## 👤 Author

**Data Analyst**

This project was created as part of a SQL data analytics portfolio to demonstrate practical data-cleaning and database skills using MySQL.
