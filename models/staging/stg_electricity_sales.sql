
--TODO:
    -- 1. CREATE LOOKUP TABLE OF REGIONAL/STATE MAPPINGS stg_state_region_lookup

with source as (
    select * from {{ source('dept_of_energy', 'raw_sales') }}
)

, final as (
    select
        {{ dbt_utils.generate_surrogate_key(['stateId', 'period']) }} as ELECTRICITY_SALES_KEY,
        trim(upper(stateId)) as STATE_REGION_ID,
        trim(upper(stateDescription)) as STATE_REGION,
        cast(concat(period, '-01') as date) as SALES_MONTH,
        sales as ELECTRICITY_SALES,

        case
            when salesUnits = 'million kilowatt hours' then 'mkWh'
            else salesUnits
            end as SALES_UNIT,

        trim(upper(salesUnits)) as SALES_UNIT_DESCRIPTION,

        case
            when trim(upper(stateId)) in 
                ( 'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE'
                , 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS'
                , 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS'
                , 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY'
                , 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC'
                , 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV'
                , 'WI', 'WY', 'DC') then 1 --this dataset includes DC in US total
            else 0
            end as IS_US_STATE_SALES,

        case
            when trim(upper(stateId)) in
                ('ENC', 'ESC', 'MAT', 'MTN', 'NEW', 'PACC'
                , 'PACN', 'SAT', 'WNC', 'WSC') then 1
            else 0
            end as IS_REGIONAL_SALES,

        case
            when stateId = 'US' then 1
            else 0
            end as IS_US_SALES,

        case
            when trim(upper(stateId)) not in
                ('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE'
                , 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS'
                , 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS'
                , 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY'
                , 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC'
                , 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV'
                , 'WI', 'WY', 'DC' --states
                , 'ENC', 'ESC', 'MAT', 'MTN', 'NEW', 'PACC'
                , 'PACN', 'SAT', 'WNC', 'WSC' --regions
                , 'US') then 1 --nation wide
            else 0
            end as IS_UNCLASSIFIED_STATE_ID,

        loaded_at as RECORD_LAST_UPDATED
    from source
)


select * from final