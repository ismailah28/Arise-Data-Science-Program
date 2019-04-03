# get only clients that had their first loan in January
with JanFristTimeClients as (
SELECT 
  distinct(clientId)
FROM `propane-highway-202915.arise.Loans`
where  loanNumber =1 and extract(month from DisbDate) = 1 and extract(year from DisbDate) = 2018)

# get client rentention for those clients in the reamining months of 2018
select 
  extract(month from DisbDate) as Month, 
  count(distinct(clientId)) as numberOfClients
FROM `propane-highway-202915.arise.Loans`
where clientId in (select * from  JanFristTimeClients)
group by Month
order by month