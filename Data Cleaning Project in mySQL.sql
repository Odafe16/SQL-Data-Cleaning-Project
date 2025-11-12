SELECT *
FROM layoffs ;

CREATE TABLE layoffs_staging
LIKE layoffs ; 

SELECT *
FROM layoffs_staging ;

INSERT layoffs_staging
SELECT *
FROM layoffs ;

SELECT *
FROM layoffs_staging ;

# step of DAta cleaning
# REMOVING DUPLICATES
# STANDARDISE THE DATA
#NULL VALUES OR BLANK VALUES
#REMOVE UNNECESARY COLUMNS


#removing duplicates

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, total_laid_off, `date`, percentage_laid_off, industry, `source`, funds_raised, country, date_added  ) AS row_num
FROM layoffs_staging ;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, total_laid_off, `date`, percentage_laid_off, industry, `source`, funds_raised, country, date_added ) AS row_num
FROM layoffs_staging 
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1 ;

# My data set seems to be without any duplicates so moving on to standardizing data

# Standardizing Data
SELECT company, TRIM(company)
FROM layoffs_staging ;

UPDATE layoffs_staging
SET company = TRIM(company) ;

SELECT DISTINCT(industry)
FROM layoffs_staging 
ORDER BY 1;

SELECT DISTINCT(location), TRIM(TRAILING ',Non-U.S.' FROM location)
FROM layoffs_staging 
ORDER BY 1;
UPDATE layoffs_staging
SET location = TRIM(TRAILING ',Non-U.S.' FROM location);

SELECT DISTINCT(location)
FROM layoffs_staging 
ORDER BY 1;

SELECT DISTINCT(country)
FROM layoffs_staging 
ORDER BY 1;

UPDATE layoffs_staging
SET country = 'UAE'
WHERE country LIKE 'United Arab Emirates%' ;

SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y' )
FROM layoffs_staging ;


#NULL VALUES OR BLANK VALUES

UPDATE layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y' ) ;


ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE ;

SELECT * 
FROM layoffs_staging ;

SELECT * 
FROM layoffs_staging
WHERE percentage_laid_off IS NULL 
OR percentage_laid_off = '' ;

SELECT * 
FROM layoffs_staging
WHERE industry IS NULL 
OR industry = '' ;

SELECT * 
FROM layoffs_staging
WHERE company = 'Appsmith' ;


# deleting data
DELETE  
FROM layoffs_staging
WHERE percentage_laid_off IS NULL OR percentage_laid_off = '' ;

DELETE
FROM layoffs_staging
WHERE industry IS NULL 
OR industry = '' ;

SELECT *
FROM layoffs_staging ;









