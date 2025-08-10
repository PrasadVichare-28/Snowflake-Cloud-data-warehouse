--Creating DB and Schema
CREATE OR REPLACE DATABASE WAREHOUSE_DB;
CREATE OR REPLACE SCHEMA WAREHOUSE_SCHEMA;

-- Creating Integration Object 
CREATE OR REPLACE STORAGE INTEGRATION S3_INT
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER =S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN ='arn:aws:iam::051826700741:role/snowflake-access-role'
STORAGE_ALLOWED_LOCATIONS= ('s3://snowflake-datawarehouse-123/source_crm/', 's3://snowflake-datawarehouse-123/source_erp/');

DESC INTEGRATION S3_INT;

--creating file object
CREATE OR REPLACE FILE FORMAT csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE;

--Creating stage
CREATE OR REPLACE STAGE WAREHOUSE_DB.WAREHOUSE_SCHEMA.crm
url ='s3://snowflake-datawarehouse-123/source_crm/'
STORAGE_INTEGRATION = S3_INT
FILE_FORMAT = WAREHOUSE_DB.PUBLIC.CSV_FILEFORMAT;

CREATE OR REPLACE STAGE WAREHOUSE_DB.WAREHOUSE_SCHEMA.erp
url ='s3://snowflake-datawarehouse-123/source_erp/'
STORAGE_INTEGRATION = S3_INT
FILE_FORMAT = WAREHOUSE_DB.PUBLIC.CSV_FILEFORMAT;

LIST @WAREHOUSE_DB.WAREHOUSE_SCHEMA.crm;




