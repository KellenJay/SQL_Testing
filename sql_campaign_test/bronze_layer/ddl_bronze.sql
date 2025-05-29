/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID ('bronze.marketing_campaign', 'U') IS NOT NULL
  DROP TABLE bronze.marketing_campaign;

CREATE TABLE bronze.marketing_campaign (
	  Campaign NVARCHAR(255),
	  Date NVARCHAR(50),
	  [City/Location] NVARCHAR(255),
	  Latitude FLOAT,
	  Longitude FLOAT,
	  Channel NVARCHAR(100),
	  Device NVARCHAR(100),
	  Ad NVARCHAR(255),
	  Impressions FLOAT,
	  [CTR, %] NVARCHAR(50),
	  Clicks INT,
	  [Daily Avg. CPC] FLOAT,
	  [Spend (GBP)] FLOAT,
	  Conversions INT,
	  [Total Conversion Value (GBP)] FLOAT,
	  Likes INT,
	  Shares INT,
	  Comments INT,
	);
