select
    max(IS_UNCLASSIFIED_STATE_ID) as max_unclassified_state_id
from {{ ref('stg_electricity_sales') }}
having max_unclassified_state_id != 0
