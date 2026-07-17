-- Hello, this is a data cleaning project on SQL.
-- Data collected from Kaggle, took help from online learning platform for some additional task. 
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022
-- *** Following task done to get the final cleaned data to make decision or use for purposeful project. 
-- STEPS OF DATA CLEANING
-- 1. remove duplicates
-- 2. standardize the data
-- 3. null value or blank values
-- 4. remove any columns which is totally irrelevant 
--  Here we go........


SELECT * 
FROM layoffs;

-- selected all the raw data from database. 

CREATE TABLE layoffs_staging
LIKE layoffs;

-- made a secondary stage to work on raw data, keep the raw data so we never loose anything....
-- in case we made any data loss or mistake which impossible to undone.

SELECT *
FROM layoffs_staging;

-- selected staging database

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- inserted the data form original database to staging database.....

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- we selected all the column and make as row_num so we can use row_num  column for multiple necessary task. 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
 industry, total_laid_off, percentage_laid_off, `date`, stage,
 country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- here made a CTE as a duplicate_cte so we can see all the duplicate data and remove on next step where necessary . 

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- check if the duplicate cte works when select some specific data like the company name 'Casper or Airbnb and if there is any duplicate on these row.

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
 industry, total_laid_off, percentage_laid_off, `date`, stage,
 country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;

-- here we delete duplicate from the CTE.....

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- here created anothe database like  stage 2 so we can update any change or modification needed on our database to make it clean and arranged. 

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- select data from stage 2 databse. 

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
 industry, total_laid_off, percentage_laid_off, `date`, stage,
 country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- here inserted the date after remvoe the duplicate, the data got after delete duplicate from CTE, so we get a data to save in stage 2 databae.
-- no duplicate here, also we arranged necessary changed. 

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- delete the duplicate of row_num where have the row duplicate 

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- checking if it works , now there is now duplicates in row all distinct row 

SELECT *
FROM layoffs_staging2;

-- select the statge 2 databese 

-- now work on standardize the data with multiple task 


SELECT company, TRIM(company)
FROM layoffs_staging2;

-- trim the data, works on company column and trim if there have any unnecessary space left or right.

UPDATE layoffs_staging2
SET company = TRIM(company);

-- update the trimmed clean name on company column 

SELECT DISTINCT industry
FROM layoffs_staging2;

-- see the disctinct date on industy 

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- update on industrty if there is same industry but different make it distinct and unique for same industy group 

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;


-- works on country if there is any unnecesssary part on the country row, TRIM(TRAILING, '.'...(here put the unnecessary part to remove)..FROM )


UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'Untied States%';

-- update the cleaned country name here

SELECT `date`
FROM layoffs_staging2;

-- select the date here

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- update the date and changed the date from text(string to date) used date format '/%m/ %d/%Y'

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- since we are changing the full column to different data type string to date used Alter Table command and finally changed the type

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- see if there is nulll value on these columns

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- update the null value 

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- see how it look null value 

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- see if there is similary still this value which not working with null value 

SELECT  t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- join on itself so we can modify the null vlaue 

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- update the null value 

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- see null value on these columns

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- delete and update the null value where necessary

SELECT * 
FROM layoffs_staging2;

-- select the stage 2 to see the looks cleaned and arranged 

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- drop column row_num so we get the cleaned final database wihch clean and arranged and ready to works for any further task

CREATE TABLE layoffs_staging2_backup AS
SELECT * FROM layoffs_staging2;

-- here keep a also a backup database in case need to get back here,,, we can work on this clened files without worrying data loss or missing. 





