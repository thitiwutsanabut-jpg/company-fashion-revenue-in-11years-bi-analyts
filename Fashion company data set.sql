------all revenue for fashion company 12 year ----------------

WITH yearly_revenue AS (
    SELECT
        "company_name",
        RIGHT("years", 4)::INTEGER AS year,
        "revenue"
    FROM fashion_company_data_set
),
ranked_revenue AS (
    SELECT
        "company_name",
        year,
        revenue,
        RANK() OVER (
            PARTITION BY year
            ORDER BY revenue DESC
        ) AS revenue_rank
    FROM yearly_revenue
)
SELECT
    year,
    "company_name",
    revenue
FROM ranked_revenue
WHERE revenue_rank = 1
ORDER BY year;
 
 --------Company with the Highest Revenue Each Year (2012–2023)-------
 
 with ranked as (
 select 
 "company_name",
 SUM("revenue") as "total_rev",
 "years",
 rank()over(partition by "years" order by SUM("revenue") desc) as "rank"
 from fashion_company_data_set fcds 
 group by "company_name","years"
 )
 select 
   "company_name",
   "total_rev",
   "years"
 from ranked 
 where "rank" = 1
 order by "years" 
 
   ---------------- The most popular fashion trend in the last 12 years.-----------------------
  
   select 
    "company_name",
    "fashion_style",
    "country_of_origin",
     sum("revenue")
   from fashion_company_data_set fcds
   group by 
     "company_name",
     "fashion_style",
     "country_of_origin"
   having sum("revenue") > 40000000
   order by sum("revenue") desc

------------------------Which company has grown the fastest in the last 12 years?-------------------------
with revenue_by_year as ( 
   select 
    "company_name",
     CAST(RIGHT("years",4) AS INTEGER) AS Year,
     "revenue",   
  ROW_NUMBER() OVER (
      PARTITION by "company_name"
      ORDER BY CAST(RIGHT("years",4) AS INTEGER)
      ) AS rn_first,
  ROW_NUMBER() OVER (
       PARTITION BY "company_name"
       ORDER BY CAST(RIGHT("years",4) AS INTEGER) DESC 
       ) AS rn_last 
FROM fashion_company_data_set fcds
),
company_revenue as (
select 
    "company_name",
    MAX(
    case 
    	when rn_first = 1 then "revenue"
    end
    ) as first_revenue,
    max(
    case 
    	when rn_last = 1 then "revenue"
    end
    ) as last_revenue
 from  revenue_by_year
group by "company_name"
)
select 
    "company_name",
    "first_revenue",
    "last_revenue",
   Round((("last_revenue" - "first_revenue")::numeric
   /nullif(first_revenue,0) 
  ) * 100, 
  2) as growth_percent
from company_revenue
order by "growth_percent" desc;
 
 --------------How has COVID-19 affected the fashion market?---------------------
WITH covid_revenue AS (
    SELECT 
        "company_name",
        MAX(CASE 
            WHEN "years" = 'company_revenue_2019' 
            THEN "revenue" 
        END) AS rev_2019,
        MAX(CASE 
            WHEN "years" = 'company_revenue_2020' 
            THEN "revenue" 
        END) AS rev_2020
    FROM fashion_company_data_set
    GROUP BY "company_name"
)
SELECT
    "company_name",
    rev_2019,
    rev_2020,
    ROUND(
        ((rev_2020 - rev_2019)::numeric / NULLIF(rev_2019, 0)) * 100,
        2
    ) AS revenue_change_percent
FROM covid_revenue
ORDER BY revenue_change_percent DESC;
   

  ---------------Is there a correlation between the number of branches and revenue?--------
 
 SELECT
    CORR(
        "company_operated_retail_stores",
        "revenue"
    ) AS revenue_store_correlation
FROM fashion_company_data_set;
  

  
  
   
    
    
  

  
   
 



