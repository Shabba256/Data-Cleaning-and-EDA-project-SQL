/* DATA CLEANING 
	1 - Remove Duplicates
    2 - Standardize the data
    3 - Null values or Blanks
    4 - Remove any columns or rows
*/


-- Removing Duplicates

SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs 
;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
;

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

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
;


SELECT *
FROM layoffs_staging2
WHERE row_num > 2
;

DELETE
FROM layoffs_staging2
WHERE row_num > 2
;

-- Standardizing Data

SELECT DISTINCT company, TRIM(company)
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET company = TRIM(company)     
; 

UPDATE layoffs_staging2
SET location = TRIM(location)     
; 

UPDATE layoffs_staging2
SET industry = TRIM(industry)     
; 

UPDATE layoffs_staging2
SET stage = TRIM(stage)     
; 

UPDATE layoffs_staging2
SET country = TRIM(country)     
; 

SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry LIKE 'crypto%'
;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%' 
;

SELECT DISTINCT country
FROM layoffs_staging2
WHERE country LIKE 'United States%'
;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%'
;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE
;

-- Removing NULL VALUES AND BLANKS

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR industry = '' 
;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''
; 

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL
;

SELECT *
FROM layoffs_staging2
WHERE (total_laid_off IS NULL OR total_laid_off = '')
AND (percentage_laid_off is null OR percentage_laid_off = '')
;

DELETE
FROM layoffs_staging2
WHERE (total_laid_off IS NULL OR total_laid_off = '')
AND (percentage_laid_off is null OR percentage_laid_off = '')
;


-- Removing unnecessary Columns 

ALTER TABLE layoffs_staging2
ADD COLUMN rank_num INT
;

ALTER TABLE layoffs_staging2
DROP COLUMN rank_num
;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num
;




SELECT *
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging;







































































































































































































