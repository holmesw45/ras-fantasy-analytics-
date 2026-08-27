SELECT r.player, r.year, POS, ras_score, G, PPR, PPR / G AS ppg 
FROM {{ ref('ras_scores') }} AS r 
JOIN {{ ref('stg_fantasy_stats') }} AS f 
ON r.player = f.name
WHERE POS IN ('QB', 'RB', 'WR', 'TE')
