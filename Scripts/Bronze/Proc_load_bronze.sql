/*
=====================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=====================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv files to bronze tables.
Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.
Usage Example:
    EXEC bronze.load_bronze;
=====================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
  
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY

	    SET @batch_start_time= GETDATE();
		PRINT '=========================================================';
		PRINT ' Loading bronze layer ';
		PRINT '=========================================================';

		PRINT '---------------------------------------------------------';
		PRINT ' Loading CRM Tables ';
		PRINT '---------------------------------------------------------';

		SET @start_time= GETDATE();
		PRINT '>> Truncating Table: bronze_crm_cust_info';

		TRUNCATE TABLE bronze_crm_cust_info;

		PRINT '>> Inserting data into bronze_crm_cust_info';

		BULK INSERT bronze_crm_cust_info
		FROM 'C:\Users\hp\AppData\Local\Temp\df17582b-daf6-440b-b91f-2a1ed4a4a7be_f78e076e5b83435d84c6b6af75d8a679.zip.7be\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT ' >> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds ';
		PRINT '------------------------------------';

		SET @start_time= GETDATE();
		PRINT '>> Truncating Table: bronze_crm_prd_info';

		TRUNCATE TABLE bronze_crm_prd_info;

		PRINT '>> Inserting data into bronze_crm_prd_info';

		BULK INSERT bronze_crm_prd_info
		FROM 'C:\Users\hp\OneDrive\Documents\SQL tuters\prd_info.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT ' >> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds ';
		PRINT '------------------------------------';


		SET @start_time= GETDATE();
		PRINT '>> Truncating Table: bronze_crm_sale_details';

		TRUNCATE TABLE bronze_crm_sale_details;

		PRINT '>> Inserting data into bronze_crm_sale_details';

		BULK INSERT bronze_crm_sale_details
		FROM 'C:\Users\hp\AppData\Local\Temp\ca39d959-035a-4a8b-b0f6-23c422593205_f78e076e5b83435d84c6b6af75d8a679.zip.205\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT ' >> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds ';
		PRINT '------------------------------------';

		PRINT '---------------------------------------------------------';
		PRINT ' Loading ERP Tables';
		PRINT '---------------------------------------------------------';


		SET @start_time= GETDATE();
		PRINT '>> Truncating Table: bronze_erp_cust_az12';

		TRUNCATE TABLE bronze_erp_cust_az12;

		PRINT '>> Inserting data into bronze_erp_cust_az12';

		BULK INSERT bronze_erp_cust_az12
		FROM 'C:\Users\hp\AppData\Local\Temp\eb025d83-f356-4a51-8074-1d9febb1d16f_f78e076e5b83435d84c6b6af75d8a679.zip.16f\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT ' >> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds ';
		PRINT '------------------------------------';



		SET @start_time= GETDATE();
		PRINT '>> Truncating Table: bronze_erp_loc_a101';

		TRUNCATE TABLE bronze_erp_loc_a101;

		PRINT '>> Inserting data into bronze_erp_loc_a101';

		BULK INSERT bronze_erp_loc_a101
		FROM 'C:\Users\hp\AppData\Local\Temp\8594a85f-5994-42f2-9a82-5ab063a18553_f78e076e5b83435d84c6b6af75d8a679.zip.553\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT ' >> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds ';
		PRINT '------------------------------------';



		SET @start_time= GETDATE();
		PRINT '>> Truncating Table: bronze_erp_px_cat_g1v2 ';

		TRUNCATE TABLE bronze_erp_px_cat_g1v2;

		PRINT '>> Inserting data into bronze_erp_px_cat_g1v2';

		BULK INSERT bronze_erp_px_cat_g1v2
		FROM 'C:\Users\hp\AppData\Local\Temp\e259691c-2dbc-4963-a39c-ec268f57d9bb_f78e076e5b83435d84c6b6af75d8a679.zip.9bb\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT ' >> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds ';
		PRINT '------------------------------------';

		SET @batch_end_time= GETDATE();
		PRINT '========================================================';
		PRINT ' Loading Bronze Layer Completed ';
		PRINT ' - Total load duration: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds ';
		PRINT '========================================================';

	END TRY
	BEGIN CATCH 
		PRINT '=========================================================';
		PRINT ' ERROR occured during loading bronze layer ';
		PRINT ' ERROR MESSAGE:' + ERROR_MESSAGE();
		PRINT ' ERROR MESSAGE:' + CAST( ERROR_NUMBER () AS NVARCHAR);
		PRINT ' ERROR MESSAGE:' + CAST( ERROR_STATE () AS NVARCHAR);
		PRINT '=========================================================';
	END CATCH
END
