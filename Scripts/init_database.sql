/*
=============================================
Create Database and Schemas
=============================================
Script Purpose:
  This script creates a new database named 'Datawarehouse' after checking if if already existx. 
  If the database exixts, it is droped and recreated. Additionally, the script sets up three schemas within the database:
  'Bronze', 'Silver', 'Gold'.

WARNING:
  Running this script will drop the entire 'Datawarehouse' database if it exists.
  All data in the database will be permanently deleted. Proceed with caution and 
  ensure you have proper backups before running this script.
*/


USE master;
GO

-- Drop and recreate the 'Datawarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN 
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Datawarehouse;
END;
GO

-- Create database 'Datawarehouse'
CREATE DATABASE Datawarehouse;
GO

USE Datawarehouse;

-- Create Schemas
CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO
