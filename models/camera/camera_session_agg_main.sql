/*
    The source function accepts two arguments:
      1. The name of the source
      2. The name of the table in that source
*/
{{ config(materialized='ephemeral') }}

with fake_source as (

  select *
  from {{ source('camera', 'camera_agg_capture_main_dse') }} 
);

with fake_source3 as (

  select *
  from {{ source('camera', 'camera_log_main_dse') }} 
);

SELECT 
session_id,
session_start_ts,
session_end_ts,
session_duration
FROM camera.camera_session_agg_main
WHERE epmeta_ep_dt BETWEEN date_sub(to_date(now()), 2) AND to_date(now())


-- this table feeds from camera_agg_capture_main_dse