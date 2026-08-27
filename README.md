# ras-fantasy-analytics-
My project to connect Relative Athletic Score data to performance in Fantasy Football 

# Does Athleticism Predict Fantasy Production?

Building Relative Athletic Score from scratch in Snowflake and dbt, then testing whether it correlates with fantasy football output.

## The Question

I play in a dynasty fantasy league, and I wanted to know whether a player's athletic testing actually tells you anything about how they'll produce. Size and speed obviously matter for finding good athletes — but is that the tell-all for fantasy?

Relative Athletic Score (RAS), created by Kent Lee Platte, grades a prospect's combine measurements on a 0–10 scale against every player at their position. The plan was to pull RAS scores, join them to fantasy production, and see whether the two move together.

That plan changed. The RAS site's tables were down when I went to get the data, so instead of importing the metric, **I rebuilt it from raw combine measurements.**

## Data

- **Combine and pro day measurements** — 8,647 players, 2007–2026, from the [array-carpenter/nfl-draft-data](https://github.com/array-carpenter/nfl-draft-data) repository. Uses the coalesced dataset, which fills in pro day numbers where official combine results are missing.
- **Fantasy production** — 2024 season PPR totals and games played, from Pro-Football-Reference.

## Pipeline

Raw CSVs load into Snowflake. dbt handles everything after that, in three layers:


Staging models are the only layer that touches raw sources. Marts reference other models via `ref()`, so dbt resolves build order automatically. Tests (`not_null`, `accepted_values`) run on every build.

## How the Score Is Built

**Ten measurements** feed the composite: height, weight, arm length, hand size, 40-yard dash, vertical jump, broad jump, three-cone, shuttle, and bench press.

**Each is ranked within position group.** A 4.55 forty means something different for a lineman than a corner, so every measurement is percentile-ranked against players at the same position — not against the whole pool.

**Direction matters per measurement.** Three drills are lower-is-better (40, three-cone, shuttle); the other seven are higher-is-better. Getting this backwards produces a score that quietly rewards slow players, so each column sorts accordingly.

**Missing measurements are excluded, not penalized.** Plenty of players skip drills. A null measurement produces a null percentile, which drops out of the average rather than counting as a zero. Non-testers are also partitioned out of the ranking entirely, so they don't consume rank positions and push real testers off the top.

**Coverage rule.** A player needs at least 6 of the 10 measurements, and height, weight, 40, and shuttle are all mandatory — my reasoning being that size, straight-line speed, and lateral movement are the foundation. Anything less and no score is assigned. That rule keeps 6,507 of 8,647 players (~75%).

The final score averages whatever percentiles a player has and scales to 0–10. Range check: min 0, max 9.04, mean 4.78.

## Findings

Joining derived scores to 2024 fantasy production gives 386 offensive skill players (QB/RB/WR/TE, minimum 4 games). Bucketed by athletic tier:

**Running back** — the clearest relationship, and the only position where it runs the right way at every step.

| Tier | Players | Avg PPG |
|------|---------|---------|
| Poor | 4 | 4.29 |
| Average | 27 | 7.86 |
| Good | 13 | 8.81 |

**Wide receiver** — weak. Good athletes outproduce the field, but average and poor are effectively tied, which isn't what you'd expect if athleticism mattered consistently.

| Tier | Players | Avg PPG |
|------|---------|---------|
| Poor | 19 | 6.24 |
| Average | 56 | 6.32 |
| Good | 28 | 8.49 |

**Tight end** — runs backwards. Poor athletes outproduced good ones.

| Tier | Players | Avg PPG |
|------|---------|---------|
| Poor | 8 | 6.73 |
| Average | 34 | 3.52 |
| Good | 16 | 6.12 |

**Quarterback** — too small to read, and no QB in the sample scored above 8. Poor (8 players) averaged 14.71, good (9) averaged 13.31, average (11) averaged 9.11.

Elite-tier buckets are omitted above because each contained one or two players — a single season from one guy isn't a finding.

**All in all** — one position points the right way, one is weak, one runs backwards, one is unreadable. On a single season of data, athletic testing is not a reliable predictor of fantasy production. That's a real answer, and not the one I expected going in.

## Limitations

- **Joins match on player name only.** Two players sharing a name get stapled together. I filtered out non-offensive positions after seeing cornerbacks and linebackers appear in fantasy stats — a symptom of exactly this. The filter mitigates it; it doesn't fix it.
- **One season of fantasy data.** 2024 only.
- **Survivorship confound.** Production is measured in 2024 across draft classes going back to 2007. A player drafted in 2010 who was still producing in 2024 survived fourteen years, which selects for being good independent of how he tested. Rookies and proven veterans are being compared directly, and that could be driving the running back result rather than athleticism.
- **My RAS is an approximation.** Platte's actual formula has weighting nuances that aren't public. This is a percentile composite built on the same principle, not a reproduction.

## What I Want to Do Next

- Expand fantasy data to multiple seasons and measure production in a player's first three years, which would remove the survivorship problem
- Improve name matching using draft year or a player ID
- Add IDP scoring, since my league uses it and defensive positions were dropped here for lack of a data source

## Tools

Snowflake (warehouse), dbt (transformation, testing, version control), SQL.
