%sql
--- LOAD THE CSV FILES INTO THE TABLES 
--- MAKE STORE PROCEDURE FOR THE FILES.
CREATE OR REPLACE PROCEDURE workspace.project_schema.load_bronze()
LANGUAGE SQL
SQL SECURITY INVOKER
AS BEGIN
DECLARE VARIABLE starttime TIMESTAMP;
DECLARE VARIABLE endtime TIMESTAMP;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  DECLARE err_msg STRING;
  GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
  SELECT CONCAT('Error loading bronze layer: ', err_msg);
END;
SET starttime = current_timestamp();
TRUNCATE TABLE workspace.project_schema.bronze_crm_cust_info;
INSERT INTO workspace.project_schema.bronze_crm_cust_info
SELECT 
    cst_id, cst_key, cst_firstname, cst_lastname,
    cst_marital_status, cst_gndr, cst_create_date
FROM read_files(
    '/Volumes/workspace/project_schema/sources_system/source_crm/cust_info.csv',
    format => 'csv',
    header => true
);
SET endtime = current_timestamp();
SELECT timestampdiff(SECOND, starttime, endtime);

SET starttime = current_timestamp();
TRUNCATE TABLE workspace.project_schema.bronze_crm_prd_info;
INSERT INTO workspace.project_schema.bronze_crm_prd_info
SELECT 
    prd_id, prd_key, prd_nm, prd_cost,
    prd_line, prd_start_dt, prd_end_dt
FROM read_files(
    '/Volumes/workspace/project_schema/sources_system/source_crm/prd_info.csv',
    format => 'csv',
    header => true
);
SET endtime = current_timestamp();
SELECT timestampdiff(SECOND, starttime, endtime);

SET starttime = current_timestamp();
TRUNCATE TABLE workspace.project_schema.bronze_crm_sales_details;
INSERT INTO workspace.project_schema.bronze_crm_sales_details
SELECT 
    sls_ord_num, sls_prd_key, sls_cust_id,
    sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales,
    sls_quantity, sls_price
FROM read_files(
    '/Volumes/workspace/project_schema/sources_system/source_crm/sales_details.csv',
    format => 'csv',
    header => true
);
SET endtime = current_timestamp();
SELECT timestampdiff(SECOND, starttime, endtime);

SET starttime = current_timestamp();
TRUNCATE TABLE workspace.project_schema.bronze_erp_loc_a101;
INSERT INTO workspace.project_schema.bronze_erp_loc_a101
SELECT 
    cid, cntry
FROM read_files(
    '/Volumes/workspace/project_schema/sources_system/source_erp/LOC_A101.csv',
    format => 'csv',
    header => true
);
SET endtime = current_timestamp();
SELECT timestampdiff(SECOND, starttime, endtime);


CREATE OR REPLACE TABLE workspace.project_schema.bronze_erp_cust_az12 (
    cid    VARCHAR(50),
    bdate  DATE,
    gen    VARCHAR(50)
);


SET starttime = current_timestamp();
TRUNCATE TABLE workspace.project_schema.bronze_erp_cust_az12;
INSERT INTO workspace.project_schema.bronze_erp_cust_az12
SELECT 
    cid, bdate, gen
FROM read_files(
    '/Volumes/workspace/project_schema/sources_system/source_erp/CUST_AZ12.csv',
    format => 'csv',
    header => true
);


SET endtime = current_timestamp();
SELECT timestampdiff(SECOND, starttime, endtime);

SET starttime = current_timestamp();
TRUNCATE TABLE workspace.project_schema.bronze_erp_px_cat_g1v2;
INSERT INTO workspace.project_schema.bronze_erp_px_cat_g1v2
SELECT 
    id, cat, subcat, maintenance
FROM read_files(
    '/Volumes/workspace/project_schema/sources_system/source_erp/PX_CAT_G1V2.csv',
    format => 'csv',
    header => true
); 
SET endtime = current_timestamp();
SELECT timestampdiff(SECOND, starttime, endtime);
END;

