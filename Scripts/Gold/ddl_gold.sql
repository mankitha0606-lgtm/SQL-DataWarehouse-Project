/*
====================================================================
DDL Script: Create Gold Views
====================================================================

Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
====================================================================
*/

-- ==================================================================
-- Create Dimension: gold.dim_customer
-- ==================================================================
IF OBJECT_ID ( 'gold.dim_customer','V' ) IS NOT NULL
   DROP VIEW gold.dim_customer;
GO 

CREATE VIEW gold.dim_customer AS
SELECT
ROW_NUMBER() OVER ( ORDER BY cst_id ) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- data integration ( CRM is the master )
	     ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ci.cst_marital_status AS marital_status,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date	
FROM silver_crm_cust_info ci
LEFT JOIN silver_erp_cust_az12 ca
ON        ci.cst_key = ca.cid
LEFT JOIN silver_erp_loc_a101 la
ON        ci.cst_key = la.cid
GO

-- ==================================================================
-- Create Dimension: gold.dim_product
-- ==================================================================
IF OBJECT_ID ( 'gold.dim_product','V' ) IS NOT NULL
   DROP VIEW gold.dim_product;
GO 

CREATE VIEW gold.dim_product AS 
SELECT  
    ROW_NUMBER() OVER ( ORDER BY pd.prd_start_dt , pd.prd_key ) AS product_key,
	pd.prd_id AS product_id,
	pd.prd_key AS product_number,
	pd.prd_nm AS product_name,
	pd.cat_id AS category_id,
	px.cat AS category,
	px.subcat AS subcategory,
	px.maintenance,
	pd.prd_cost AS product_cost,
	pd.prd_line AS product_line,
	pd.prd_start_dt AS start_date
FROM silver_crm_prd_info pd
LEFT JOIN silver_erp_px_cat_g1v2 px
ON pd.cat_id = px.id
WHERE prd_end_dt IS NULL -- filter out all historical data
GO

-- ==================================================================
-- Create Dimension: gold.fact_sales
-- ==================================================================
IF OBJECT_ID ( 'gold.fact_sales','V' ) IS NOT NULL
   DROP VIEW gold.fact_sales;
GO 

CREATE VIEW gold.fact_sales AS 
SELECT
	sl.sls_ord_num AS order_number,
	pr.product_key ,
	cs.customer_key,
	sl.sls_order_dt AS order_date,
	sl.sls_ship_dt AS shipping_date,
	sl.sls_due_dt AS due_date,
	sl.sls_sales AS sales_amount,
	sl.sls_quantity AS quantity,
	sl.sls_price AS price
FROM silver_crm_sale_details sl
LEFT JOIN gold.dim_product pr
ON sl.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customer cs
ON sl.sls_cust_iD = cs.customer_id
GO
