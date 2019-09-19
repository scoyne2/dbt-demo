
-- Welcome to your first dbt model!
-- Did you know that you can also configure models directly within
-- the SQL file? This will override configurations stated in dbt_project.yml

-- Try changing 'view' to 'table', then re-running dbt
{{ config(materialized='ephemeral') }}


SELECT
    epmeta_camera_sn_hash,
    epmeta_camera_sn,
    epmeta_user_geo_country_name,
    concount AS connection_count,
    epmeta_analytics_opt_in,
    epmeta_user_geo_country_code,
    epmeta_user_geo_continent_name,
    CASE WHEN count(CASE WHEN pos_ties = 1 THEN epmeta_user_geo_country_name ELSE null END ) OVER (PARTITION BY epmeta_camera_sn_hash ) > 1 
      THEN "true" 
      ELSE "false" 
    END AS multiple_home_connect_loc,
    TO_DATE(NOW()) AS snapshot_date,
    pos
  FROM
  (
    SELECT
      *,
      rank() OVER (PARTITION BY epmeta_camera_sn_hash ORDER BY concount DESC) AS pos_ties,
      row_number() OVER (PARTITION BY epmeta_camera_sn_hash ORDER BY concount DESC, connect_count DESC, event_count DESC ) AS pos
    FROM
      (
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
        FROM {{ ref('camera_connect_category_dbt') }}  
        WHERE epmeta_user_geo_country_name IS NOT NULL    
        GROUP BY 1,2,3,4,5,6
       )
  );

