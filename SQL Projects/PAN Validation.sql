/*
CREATE DATABASE pan_validation;

DROP TABLE IF EXISTS pan_dataset;
CREATE TABLE pan_dataset(
id INT PRIMARY KEY,
name VARCHAR (20),
pan_number VARCHAR (200),
email VARCHAR (150),
age INT,
city VARCHAR (50),
income FLOAT
);
*/
SELECT pan_number FROM pan_dataset
LIMIT 50;

-- Identify and Handle missing data
SELECT pan_number
FROM pan_dataset
WHERE pan_number = '';

-- Check for duplicates
SELECT pan_number, COUNT(*) AS Duplicate_records
FROM pan_dataset
GROUP BY pan_number
HAVING COUNT(*) >1;

-- Handle leading/trailing spaces
SELECT pan_number
FROM pan_dataset
WHERE pan_number <> TRIM(pan_number);

-- Correct letter case
SELECT UPPER(pan_number)
FROM pan_dataset;

-- Cleaned PAN numbers
SELECT DISTINCT UPPER(TRIM(pan_number)) AS cleaned_pan
FROM pan_dataset
WHERE pan_number != ''
AND TRIM(pan_number) != '';

-- Function to check if adjacent characters are the same
DROP FUNCTION IF EXISTS fn_chk_adj_characters;

DELIMITER //

CREATE FUNCTION fn_chk_adj_characters(p_str TEXT)
RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE len INT;

    IF p_str IS NULL OR p_str = '' THEN
        RETURN 0;
    END IF;

    SET len = CHAR_LENGTH(p_str);

    WHILE i < len DO
        IF SUBSTRING(p_str, i, 1) = SUBSTRING(p_str, i + 1, 1) THEN
            RETURN 1; -- adjacent identical characters found
        END IF;
        SET i = i + 1;
    END WHILE;

    RETURN FALSE; -- none found
END;
//

DELIMITER ;

SELECT fn_chk_adj_characters('ATKSS');

-- Function to check sequential character
DROP FUNCTION IF EXISTS fn_chk_sequence_alpha;

DELIMITER //

CREATE FUNCTION fn_chk_sequence_alpha(p_str TEXT)
RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE len INT;

    IF p_str IS NULL OR p_str = '' THEN
        RETURN 0;
    END IF;

    SET len = CHAR_LENGTH(p_str);

    WHILE i < len DO
        -- Get ASCII value of current and next character
        IF ASCII(SUBSTRING(p_str, i + 1, 1)) = ASCII(SUBSTRING(p_str, i, 1)) + 1 THEN
            -- Continue checking until end of string
            SET i = i + 1;
        ELSE
            RETURN 0; -- Sequence broke
        END IF;
    END WHILE;

    RETURN 1; -- Entire string is sequential
END;
//

DELIMITER ;

SELECT fn_chk_sequence_alpha('AKCDE');

-- Regular Expression to validate the pattern of PAN no. (AAAAA1234A)
SELECT pan_number
FROM pan_dataset
WHERE pan_number REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$';

-- Valid and Invalid PAN categorization 
CREATE VIEW vw_valid_invalid AS 
	(WITH CTE_Cleaned AS(
		SELECT DISTINCT UPPER(TRIM(pan_number)) AS pan_number
		FROM pan_dataset
		WHERE pan_number != ''
		AND TRIM(pan_number) != ''),
	CTE_valid_pan AS(
		SELECT * 
		FROM CTE_Cleaned
		WHERE fn_chk_adj_characters(pan_number) = 0
		AND fn_chk_sequence_alpha(SUBSTRING(pan_number,1,5)) = 0
		AND fn_chk_sequence_alpha(SUBSTRING(pan_number,6,4)) = 0
		AND pan_number REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$')
	SELECT cln.pan_number,
	CASE 
		WHEN vld.pan_number != '' THEN 'Valid PAN' 
		ELSE 'Invalid PAN' 
	END AS `Status`
	FROM CTE_Cleaned cln
	LEFT JOIN CTE_valid_pan vld
	ON vld.pan_number = cln.pan_number);

-- Create an overall summary based on the above results
SELECT 'Total Processed' AS Metric, COUNT(*) AS Count
FROM pan_dataset
UNION ALL
SELECT 'Total Valid PANs', COUNT(*)
FROM vw_valid_invalid
WHERE Status = 'Valid PAN'
UNION ALL
SELECT 'Total Invalid PANs', COUNT(*)
FROM vw_valid_invalid
WHERE Status = 'Invalid PAN'
UNION ALL
SELECT 'Total Missing Records', COUNT(*)
FROM pan_dataset
WHERE pan_number = '';