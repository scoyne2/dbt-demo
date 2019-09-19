-- Always use ephemeral else risk overwriting table
{{ config(materialized='ephemeral') }}

-- Generate relationships
with fake_source as (

  select *
  from {{ source('camera', 'camera_log_main_dse') }} 
);

-- Select * from table
SELECT
*
FROM camera.camera_connect_category