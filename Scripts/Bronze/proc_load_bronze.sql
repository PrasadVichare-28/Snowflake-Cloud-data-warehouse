CREATE OR REPLACE PROCEDURE bronze.load_bronze()
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
try {
    var startTime = Date.now();
    var stageBasePathCRM = '@WAREHOUSE_DB.WAREHOUSE_SCHEMA.CRM/';
    var stageBasePathERP = '@WAREHOUSE_DB.WAREHOUSE_SCHEMA.ERP/';
    var fileFormat = 'WAREHOUSE_DB.PUBLIC.CSV_FILEFORMAT';

    var stmt = snowflake.createStatement({sqlText: `TRUNCATE TABLE bronze.crm_cust_info`});
    stmt.execute();
    stmt = snowflake.createStatement({sqlText: `
        COPY INTO bronze.crm_cust_info 
        FROM '${stageBasePathCRM}' 
        FILES = ('cust_info.csv') 
        FILE_FORMAT = ${fileFormat}
    `});
    stmt.execute();

    stmt = snowflake.createStatement({sqlText: `TRUNCATE TABLE bronze.crm_prd_info`});
    stmt.execute();
    stmt = snowflake.createStatement({sqlText: `
        COPY INTO bronze.crm_prd_info 
        FROM '${stageBasePathCRM}' 
        FILES = ('prd_info.csv') 
        FILE_FORMAT = ${fileFormat}
    `});
    stmt.execute();

    stmt = snowflake.createStatement({sqlText: `TRUNCATE TABLE bronze.crm_sales_details`});
    stmt.execute();
    stmt = snowflake.createStatement({sqlText: `
        COPY INTO bronze.crm_sales_details 
        FROM '${stageBasePathCRM}' 
        FILES = ('sales_details.csv') 
        FILE_FORMAT = ${fileFormat}
    `});
    stmt.execute();

    stmt = snowflake.createStatement({sqlText: `TRUNCATE TABLE bronze.erp_loc_a101`});
    stmt.execute();
    stmt = snowflake.createStatement({sqlText: `
        COPY INTO bronze.erp_loc_a101 
        FROM '${stageBasePathERP}' 
        FILES = ('LOC_A101.csv') 
        FILE_FORMAT = ${fileFormat}
    `});
    stmt.execute();

    stmt = snowflake.createStatement({sqlText: `TRUNCATE TABLE bronze.erp_cust_az12`});
    stmt.execute();
    stmt = snowflake.createStatement({sqlText: `
        COPY INTO bronze.erp_cust_az12 
        FROM '${stageBasePathERP}' 
        FILES = ('CUST_AZ12.csv') 
        FILE_FORMAT = ${fileFormat}
    `});
    stmt.execute();

    stmt = snowflake.createStatement({sqlText: `TRUNCATE TABLE bronze.erp_px_cat_g1v2`});
    stmt.execute();
    stmt = snowflake.createStatement({sqlText: `
        COPY INTO bronze.erp_px_cat_g1v2 
        FROM '${stageBasePathERP}' 
        FILES = ('PX_CAT_G1V2.csv') 
        FILE_FORMAT = ${fileFormat}
    `});
    stmt.execute();

    var endTime = Date.now();
    var durationSeconds = Math.floor((endTime - startTime) / 1000);

    return `✅ Bronze Layer Load Completed. Total Duration: ${durationSeconds} seconds`;
} catch (err) {
    return `❌ ERROR during Bronze Layer Load: ${err.message}`;
}
$$;


CALL bronze.load_bronze();

SELECT * FROM WAREHOUSE_DB.BRONZE.ERP_CUST_AZ12;
