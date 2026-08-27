select replace(replace(player, '*', ''), '+', '') as name, 
PPR, 
G 
from {{ source('raw', 'ppg_2024') }}
