
with staging as (
    select * from {{ ref('stg_electricity_sales') }}
)


, final as (
    select
        ELECTRICITY_SALES_KEY,
        STATE_REGION_ID,
        STATE_REGION,
        SALES_MONTH,
        ELECTRICITY_SALES,
        SALES_UNIT_DESCRIPTION
    from staging
    where IS_US_STATE_SALES = 1
)

select * from final
