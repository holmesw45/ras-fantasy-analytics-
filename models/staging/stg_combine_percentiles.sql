SELECT 
year, 
player, 
POS, 
CASE WHEN "3Cone" IS NULL THEN NULL
     ELSE PERCENT_RANK() OVER (
         PARTITION BY POS, ("3Cone" IS NULL)
         ORDER BY "3Cone" DESC
     )
END AS three_cone_pct, 
CASE WHEN "40 Yard" IS NULL THEN NULL
     ELSE PERCENT_RANK() OVER (
         PARTITION BY POS, ("40 Yard" IS NULL)
         ORDER BY "40 Yard" DESC
     )
END AS forty_pct, 
CASE WHEN shuttle IS NULL THEN NULL
     ELSE PERCENT_RANK() OVER (
         PARTITION BY POS, (shuttle IS NULL)
         ORDER BY shuttle DESC
     )
END AS shuttle_pct,
CASE WHEN "Vert Leap (in)" IS NULL THEN NULL
     ELSE PERCENT_RANK() OVER (
         PARTITION BY POS, ("Vert Leap (in)" IS NULL)
         ORDER BY "Vert Leap (in)" ASC
     )
END AS vert_leap_pct, 
CASE WHEN "Broad Jump (in)" IS NULL THEN NULL
     ELSE PERCENT_RANK() OVER (
         PARTITION BY POS, ("Broad Jump (in)" IS NULL)
         ORDER BY "Broad Jump (in)" ASC
     )
END AS broad_jump_pct, 
CASE WHEN "Arm Length (in)" IS NULL THEN NULL
     ELSE PERCENT_RANK() OVER (
         PARTITION BY POS, ("Arm Length (in)" IS NULL)
         ORDER BY "Arm Length (in)" ASC
     )
END AS arm_length_pct, 
CASE WHEN BENCH_PRESS IS NULL THEN NULL
     ELSE PERCENT_RANK() OVER (
         PARTITION BY POS, (BENCH_PRESS IS NULL)
         ORDER BY BENCH_PRESS ASC
     )
END AS bench_press_pct, 
CASE WHEN "Hand Size (in)" IS NULL THEN NULL
     ELSE PERCENT_RANK() OVER (
         PARTITION BY POS, ("Hand Size (in)" IS NULL)
         ORDER BY "Hand Size (in)" ASC
     )
END AS hand_size_pct, 
CASE WHEN "Weight (lbs)" IS NULL THEN NULL
     ELSE PERCENT_RANK() OVER (
         PARTITION BY POS, ("Weight (lbs)" IS NULL)
         ORDER BY "Weight (lbs)" ASC
     )
END AS weight_pct, 
CASE WHEN "Height (in)" IS NULL THEN NULL
     ELSE PERCENT_RANK() OVER (
         PARTITION BY POS, ("Height (in)" IS NULL)
         ORDER BY "Height (in)" ASC
     )
END AS height_pct 
from {{ source('raw', 'combine_results')}}
