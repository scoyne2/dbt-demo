
-- Welcome to your first dbt model!
-- Did you know that you can also configure models directly within
-- the SQL file? This will override configurations stated in dbt_project.yml

-- Try changing 'view' to 'table', then re-running dbt
{{ config(materialized='view') }}


SELECT
  epmeta_user_geo_country_name,
  epmeta_camera_sn_hash,
  epmeta_camera_sn,
  epmeta_user_geo_country_code,
  epmeta_user_geo_continent_name,
  epmeta_analytics_opt_in,
  count(epmeta_user_geo_country_name) AS concount,
  sum(connect_count) AS connect_count,
  sum(event_count) AS event_count
FROM teamanalytics.camera_connection_category
WHERE epmeta_user_geo_country_name IS NOT NULL
AND epmeta_camera_sn_hash IS NOT NULL    
GROUP BY 1,2,3,4,5,6
