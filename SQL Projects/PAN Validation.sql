-- SQL script for PAN validation and cleaning

-- Function to validate PAN
CREATE FUNCTION ValidatePAN(pan VARCHAR(10)) RETURNS BOOLEAN AS
BEGIN
    RETURN pan REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$';
END;

-- Procedure to clean and validate PANs
CREATE PROCEDURE CleanPANs(IN input_pan VARCHAR(10), OUT output_pan VARCHAR(10)) AS
BEGIN
    IF ValidatePAN(input_pan) THEN
        SET output_pan = input_pan;
    ELSE
        SET output_pan = NULL; -- or some default value
    END IF;
END;