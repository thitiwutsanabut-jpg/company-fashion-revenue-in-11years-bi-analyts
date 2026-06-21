------all revenue for fashion company 11 year ----------------

select 
  "company_name",
  SUM("revenue") as "total_revenue"
 from fashion_company_data_set fcds 
 group by "company_name"
 having SUM("revenue") >1
 order by "total_revenue" desc
 
 ---------The company with the highest revenue each year.-------
 
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
 
   ---------------- The most popular fashion trend in the last 11 years.-----------------------
  
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

------------------------Which company has grown the fastest in the last 11 years?-------------------------
select 
  "company_name",
  min("revenue") as first_revenue,
  max("revenue") as last_revnenue,
  Round(
  ((max("revenue")-min("revenue"))::numeric/min("revenue"))* 100,2) as Growth_percentas
 from fashion_company_data_set fcds 
 group by "company_name"
 order by growth_percentas  desc
 
 --------------How has COVID-19 affected the fashion market?---------------------
 select 
   "company_name",
   max(case when years= 'company_revenue_2019' then "revenue" end) as rev_2019,
   max(case when years= 'company_revenue_2020' then "revenue" end ) as rev_2020
   from fashion_company_data_set fcds 
   group by "company_name"
   
 --------------Does the company's age relate to income?-----------------------
 select 
   "company_name",
   2023-"founding_year" as company_age,
   SUM("revenue") as all_rev
  from fashion_company_data_set fcds 
  group by "company_name",company_age
  having SUM("revenue") >0
  
 ----------------Is there a correlation between the number of branches and revenue?--------
 
 select
   distinct "company_name",
   "company_operated_retail_stores",
   SUM("revenue")
  from fashion_company_data_set fcds
  group by "company_name" , "company_operated_retail_stores"
  having SUM("revenue") > 1
  
------------------Number of branches and sales figures-------------------------------------
 SELECT
  "company_name",
  ROUND(CAST(MAX("company_operated_retail_stores") AS NUMERIC), 0) AS max_stores,
  ROUND(SUM("revenue") / NULLIF(CAST(MAX("company_operated_retail_stores") AS NUMERIC), 0), 2) AS revenue_per_store
FROM "fashion_company_data_set"
GROUP BY "company_name"
HAVING SUM("revenue") > 0
ORDER BY revenue_per_store DESC;
  
  
  
   
    
    
  

  
   
 



