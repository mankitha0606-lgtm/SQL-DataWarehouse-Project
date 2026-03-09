/*
===============================================================================
Quality Checks
===============================================================================

Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schemas. It includes checks for:

    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.

===============================================================================
*/

-- =============================================
-- Checking ' silver_crm_cust_info '
-- =============================================

-- Check for NULLS OR DUPLICATES in Primary key
-- Expectation: No result

SELECT 
cst_id,
count(*)
FROM bronze_crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null

-- check for unwanted space
--expectation: no result

SELECT
cst_firstname
FROM bronze_crm_cust_info
where cst_firstname!= trim(cst_firstname)


SELECT
cst_lastname
FROM bronze_crm_cust_info
where cst_lastname!= trim(cst_lastname)


SELECT
cst_gndr
FROM bronze_crm_cust_info
where cst_gndr!= trim(cst_gndr)


SELECT
cst_marital_status
FROM bronze_crm_cust_info
where cst_marital_status!= trim(cst_marital_status)

-- data standardization and consistency

SELECT DISTINCT cst_gndr
from bronze_crm_cust_info

SELECT DISTINCT cst_marital_status
from bronze_crm_cust_info

-- quality check for silver


-- Check for NULLS OR DUPLICATES in Primary key
-- Expectation: No result

SELECT 
	cst_id,
	count(*)
FROM dbo.silver_crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null

-- check for unwanted space
--expectation: no result

SELECT
cst_firstname
FROM dbo.silver_crm_cust_info
where cst_firstname!= trim(cst_firstname)


SELECT
cst_lastname
FROM silver_crm_cust_info
where cst_lastname!= trim(cst_lastname)


SELECT
cst_gndr
FROM silver_crm_cust_info
where cst_gndr!= trim(cst_gndr)


SELECT
cst_marital_status
FROM silver_crm_cust_info
where cst_marital_status!= trim(cst_marital_status)

-- data standardization and consistency

SELECT DISTINCT cst_gndr
from silver_crm_cust_info

SELECT DISTINCT cst_marital_status
from silver_crm_cust_info


select 
count(*)
from silver_crm_cust_info

DROP TABLE silver_crm_cust_info

-- =============================================
-- Checking ' silver_crm_prd_info '
-- =============================================

-- Check for NULLS OR DUPLICATES in Primary key
-- Expectation: No result

SELECT 
prd_id,
count(*)
FROM silver_crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null

-- check for unwanted space
--expectation: no result

SELECT
prd_nm
FROM silver_crm_prd_info
where prd_nm!= trim(prd_nm)

--check for null or negative numbers
-- expectation: no result

select prd_cost
from silver_crm_prd_info
where prd_cost < 0 or prd_cost is null

-- data standardization and consistency

SELECT DISTINCT prd_line
from silver_crm_prd_info


--check for invalid date order
select
*
from silver_crm_prd_info
where prd_end_dt < prd_start_dt

-- =============================================
-- Checking ' silver_crm_sale_details '
-- =============================================

-- check invalid dates
select 
nullif(sls_order_dt,0) as sls_order_dt
from bronze_crm_sale_details
where sls_order_dt <= 0 or len(sls_order_dt) != 8 or sls_order_dt > 20500101 or sls_order_dt < 19000101

--check for invalid date order
select
*
from silver_crm_sale_details
where sls_order_dt > sls_ship_dt or sls_order_dt>sls_due_dt

-- check data consistency: between sales,quality,price
-- sales= quantity*price
-- no -ve, 0 or null

select distinct
sls_sales,
sls_quantity,
sls_price
from bronze_crm_sale_details
where sls_sales!=sls_quantity*sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0


-- =============================================
-- Checking ' silver_erp_cust_az12 '
-- =============================================

--identify out-of-range dates
select distinct
bdate
from bronze_erp_cust_az12
where bdate < '1924-01-01' or bdate > getdate()

-- data standardization & consistency
select distinct
gen
from bronze_erp_cust_az12

-- =============================================
-- Checking ' silver_erp_loc_a101 '
-- =============================================

-- data standardization & consistency
select distinct
cntry as old_cntry,
case when trim(cntry) = 'DE' THEN 'Germany'
     when trim(cntry) in ('US', 'USA') THEN 'UNITED STATES'
	 when trim(cntry) = '' OR cntry is null then 'n/a'
	 else trim(cntry)
end as cntry
from bronze_erp_loc_a101
order by cntry

-- =============================================
-- Checking ' silver_erp_px_cat_g1v2 '
-- =============================================

--check for unwanted spaces
select *
from bronze_erp_px_cat_g1v2
where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance)

-- data standardization & consistency
select distinct
cat
from bronze_erp_px_cat_g1v2
