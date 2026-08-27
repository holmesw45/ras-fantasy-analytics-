WITH counted AS (
    SELECT *,
        CASE WHEN forty_pct IS NULL THEN 0 ELSE 1 END
        + CASE WHEN three_cone_pct IS NULL THEN 0 ELSE 1 END
        + CASE WHEN shuttle_pct IS NULL THEN 0 ELSE 1 END
        + CASE WHEN vert_leap_pct IS NULL THEN 0 ELSE 1 END
        + CASE WHEN broad_jump_pct IS NULL THEN 0 ELSE 1 END
        + CASE WHEN arm_length_pct IS NULL THEN 0 ELSE 1 END
        + CASE WHEN bench_press_pct IS NULL THEN 0 ELSE 1 END
        + CASE WHEN hand_size_pct IS NULL THEN 0 ELSE 1 END
        + CASE WHEN weight_pct IS NULL THEN 0 ELSE 1 END
        + CASE WHEN height_pct IS NULL THEN 0 ELSE 1 END AS n_measures,

        COALESCE(forty_pct, 0) + COALESCE(three_cone_pct, 0) + COALESCE(shuttle_pct, 0)
        + COALESCE(vert_leap_pct, 0) + COALESCE(broad_jump_pct, 0) + COALESCE(arm_length_pct, 0)
        + COALESCE(bench_press_pct, 0) + COALESCE(hand_size_pct, 0) + COALESCE(weight_pct, 0)
        + COALESCE(height_pct, 0) AS sum_pct
    FROM {{ ref('stg_combine_percentiles') }}
)

SELECT
    year,
    player,
    POS,
    n_measures,
    CASE WHEN forty_pct IS NOT NULL AND shuttle_pct IS NOT NULL
              AND weight_pct IS NOT NULL AND height_pct IS NOT NULL
              AND n_measures >= 6
         THEN sum_pct / n_measures * 10
    END AS ras_score
FROM counted
