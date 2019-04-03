# get clients with at least on bill in March
with MarchClients as (
SELECT 
  distinct(customerId)
FROM `propane-highway-202915.arise.BillPayments` 
where extract(month from billDate) = 3 and payment_status like 'SUCCESS'),

# get the March that have a loan
MarchClientsWithLoan as (
SELECT 
  distinct(customerId)
FROM `propane-highway-202915.arise.BillPayments` 
where extract(month from billDate) = 3 and
      payment_status like 'SUCCESS' and
      customerId in (select distinct(clientId) from `propane-highway-202915.arise.Loans`))
      
# show client retention by month for bill payments for the clients that had a bill payment in March
select
  Month,
  sum(hasLoan) as clientsWithLoan,
  sum(noLoan) as clientsWithoutLoan,
  count(*) as totalClients
from(
# check for the clients that are in March, whether they are in the MarchClientsWithLoan table
select 
  distinct(bp.customerId),
  extract(month from bp.billDate) as Month,
  case when bp.customerId in (select customerId from MarchClientsWithLoan) then 1 else 0 end as hasLoan,
  case when bp.customerId not in (select customerId from MarchClientsWithLoan) then 1 else 0 end as noLoan 
FROM `propane-highway-202915.arise.BillPayments` bp
where bp.customerId in (select customerId  from  MarchClients) and extract(month from billDate) >= 3)
group by Month
order by Month