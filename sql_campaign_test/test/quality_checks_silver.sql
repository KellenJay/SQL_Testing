/*
===============================================================================
Quality Checks for Silver Layer: marketing_campaign
===============================================================================
Script Purpose:
    This script performs data quality checks on the 'silver.marketing_campaign' 
    table to validate consistency, completeness, and formatting.
    Checks include:
    - Nulls or duplicates in business keys
    - Negative or null numeric values
    - Unwanted leading/trailing spaces
    - CTR and date validations

Usage Notes:
    - Run after ETL load into Silver Layer.
    - Any failures should be logged and investigated before proceeding to Gold.
===============================================================================
*/

-- ============================================================
-- Check for duplicate records based on Campaign + Date + City
-- Expectation: No rows should be returned if data is uniquely defined.
SELECT 
    Campaign,
    Campaign_Date,
    City,
    COUNT(*) AS record_count
FROM silver.marketing_campaign
GROUP BY Campaign, Campaign_Date, City
HAVING COUNT(*) > 1;

-- ============================================================
-- Check for NULLs in essential fields
-- Expectation: No NULLs in key analysis fields
SELECT *
FROM silver.marketing_campaign
WHERE 
    Campaign IS NULL OR
    Date IS NULL OR
    City IS NULL OR
    Ad IS NULL OR
    Impressions IS NULL OR
    CTR IS NULL OR
    Clicks IS NULL OR
    Ad_Spend IS NULL OR
    Conversions IS NULL OR
    Revenue IS NULL;

-- ============================================================
-- Check for negative or invalid numeric values
-- Expectation: All values should be zero or positive
SELECT *
FROM silver.marketing_campaign
WHERE 
    Impressions < 0 OR
    Clicks < 0 OR
    Conversions < 0 OR
    Ad_Spend < 0 OR
    Revenue < 0;

-- ============================================================
-- Check for unwanted spaces in City or Channel fields
-- Expectation: No leading/trailing spaces
SELECT City, Channel
FROM silver.marketing_campaign
WHERE 
    City != LTRIM(RTRIM(City)) OR
    Channel != LTRIM(RTRIM(Channel));

-- ============================================================
-- Check for CTR values greater than 1 (should be in decimal)
-- Expectation: CTR <= 1.0 (e.g., 0.23 for 23%)
SELECT *
FROM silver.marketing_campaign
WHERE CTR > 1.0;

-- ============================================================
-- Check for Campaign_Date range (must not be in the future or too old)
-- Expectation: Dates between '2010-01-01' and GETDATE()
SELECT *
FROM silver.marketing_campaign
WHERE 
    Campaign_Date < '2010-01-01' OR
    Campaign_Date > GETDATE();

-- ============================================================
-- Check consistency: Revenue should not be lower than Ad Spend if Conversions > 0
-- Expectation: Revenue >= Ad Spend for converting campaigns
SELECT *
FROM silver.marketing_campaign
WHERE 
    Conversions > 0 AND
    Revenue < Ad_Spend;

-- Validate the Business Logic
SELECT 
    Campaign, 
    Date, 
    Channel, 
    Device,
    Ad_Spend,
    Revenue,
    Conversions,
    ROUND(Revenue - Ad_Spend, 2) AS Profit
FROM silver.marketing_campaign
WHERE 
    Conversions > 0 AND
    Revenue < Ad_Spend
ORDER BY Profit ASC;

-- Check for Zero or Low Revenue per Conversion
SELECT 
    Campaign, 
    Revenue, 
    Conversions, 
    ROUND(Revenue / NULLIF(Conversions, 0), 2) AS RPCon
FROM silver.marketing_campaign
WHERE 
    Conversions > 0 AND
    Revenue < Ad_Spend
ORDER BY RPCon ASC;

