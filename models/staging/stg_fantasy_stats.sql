select
    name,
    POS,
    RAS
from {{ source('raw', 'RAS_scores2024') }}
