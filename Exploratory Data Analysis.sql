# Exploratory Data Analysis

SELECT company,
SUM(total_laid_off) AS overall_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC
LIMIT 10
;

SELECT country,
SUM(total_laid_off) AS overall_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY overall_laid_off DESC
;

SELECT country,
SUM(funds_raised_millions) AS total_funds
FROM layoffs_staging2
GROUP BY country
ORDER BY total_funds DESC
;

SELECT industry,
SUM(funds_raised_millions) AS total_funds,
SUM(total_laid_off) AS overall_laid_off
FROM layoffs_staging2 
GROUP BY industry
ORDER BY total_funds DESC
;

SELECT
YEAR(`date`) AS years,
SUM(total_laid_off) AS overall_laid_off
FROM layoffs_staging2
GROUP BY years
HAVING years IS NOT NULL
ORDER BY years 
;

SELECT company, 
MIN(`date`) AS start_date, 
MAX(`date`) AS latest_date,
TIMESTAMPDIFF(MONTH, MIN(`date`), MAX(`date`)) AS diff_month ,
SUM(total_laid_off) AS overall_laid_off
FROM layoffs_staging2
GROUP BY company
HAVING diff_month >= 1
;

SELECT 
months,
overall_laid_off,
SUM(overall_laid_off) OVER(ORDER BY overall_laid_off) AS rolling_total
FROM (
SELECT 
SUBSTRING(`date`, 1, 7) AS months,
SUM(total_laid_off) AS overall_laid_off
FROM layoffs_staging2
GROUP BY months
HAVING months IS NOT NULL
ORDER BY months
) t;


WITH company_year AS (
SELECT 
company, 
YEAR(`date`) AS years,
SUM(total_laid_off) AS overall_laid_off
FROM layoffs_staging2
GROUP BY company, years
ORDER BY overall_laid_off DESC
),
company_year_rank AS (
SELECT 
company,
years,
overall_laid_off,
DENSE_RANK() OVER(PARTITION BY years ORDER BY overall_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)

SELECT *
FROM company_year_rank
WHERE ranking <= 5
;



-- More EDA

CREATE TABLE layoffs_staging3
LIKE layoffs_staging2
;

INSERT INTO layoffs_staging3
SELECT *
FROM layoffs_staging2
;

DELETE
FROM layoffs_staging3
WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL
;

SELECT *,
CASE
	WHEN total_laid_off = 0 OR percentage_laid_off = 0 THEN 0
    ELSE ROUND((total_laid_off / percentage_laid_off), 0)
END AS total_workers
FROM layoffs_staging3
;


SELECT *
FROM layoffs_staging2
;