SELECT *
FROM layoffs;

-- CREATE A Staging table (so we do not mess with Raw Data)

CREATE TABLE layoff2
LIKE layoffs;

INSERT layoff2
SELECT*
FROM layoffs;

-- DATA CLEANING

-- 1. Remove Duplicate
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoff2;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, total_laid_off, percentage_laid_off, industry,stage, funds_raised, country, `date`) AS row_num 
FROM layoff2
)

DELETE
FROM duplicate_cte
WHERE row_num >1;

CREATE TABLE `layoff3`(
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` int DEFAULT NULL,
  `country` text,
  `date_added` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoff3
SELECT*,
ROW_NUMBER() OVER(
PARTITION BY company, location, total_laid_off, percentage_laid_off, industry,stage, funds_raised, country, `date`) AS row_num 
FROM layoff2;

SET SQL_SAFE_UPDATES = 0;

DELETE 
FROM layoff3
WHERE row_num >1;



SELECT *
FROM layoff3;

-- 2. Standardize the Data

SELECT DISTINCT(TRIM(company)),company
FROM layoff3;

UPDATE layoff3
SET company = (TRIM(company));

SELECT `date`,
       STR_TO_DATE(`date`, '%m/%d/%Y') AS converted_date
FROM layoff3;

UPDATE layoff3
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT date
FROM layoff3;

ALTER TABLE layoff3
MODIFY COLUMN  `date` DATE;

-- 3. Null Values or Blank Values
UPDATE layoff3
SET industry = NULL
WHERE industry  ='';

SELECT *
FROM layoff3
WHERE industry IS NULL ;


SELECT *
FROM layoff3
WHERE company = 'Appsmith';



UPDATE layoff3
SET total_laid_off = NULL
WHERE total_laid_off ='';

UPDATE layoff3
SET percentage_laid_off = NULL
WHERE percentage_laid_off ='';




SELECT *
FROM layoff3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoff3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 4. Remove any Coloumns

ALTER TABLE layoff3
DROP COLUMN row_num;

SELECT*
FROM layoff3;