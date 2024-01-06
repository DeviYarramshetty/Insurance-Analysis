create database Excelr;
use excelr;
show tables;

select * from brokerage;
select * from invoice;
select * from fees;
select brokerage.income_class ,
round(sum(brokerage.amount) + sum(fees.amount),2) as Achived,
sum(invoice.amount) as Invoice,
case brokerage.income_class
when "New" then (select sum(New) as Target from budgets)
when "Renewal" then (select  sum(Renewal) as Target from budgets)
else (select  sum(Crosssell) as Target from budgets)
End as Target
 from brokerage
join fees using (income_class)
join invoice on invoice.policy_number = brokerage.policy_number
group by 1
;

select * from brokerage;
select income_class ,
round(sum(brokerage.amount) + sum(fees.amount),2) as Acheived,
sum(invoice.amount) as Invoice,
case income_class
when "New" then (select sum(New) as Target from budgets)
when "Renewal" then (select  sum(Renewal) as Target from budgets)
else (select  sum(Crosssell) as Target from budgets)
End as Target
 from brokerage
join fees using (income_class)
join invoice using(INCOME_CLASS)
group by 1
;

select  sum(New) as Target from budgets
union
select  sum(crosssell) as Target from budgets
union
select  sum(renewal) as Target from budgets;

select sum(amount) from invoice;

update brokerage 
set income_class = "N/A" 
where income_class =  '';

delete from brokerage
where income_class = "N/A";


-- Cross sell , new and renewal stats

with invoice as (
select income_class , sum(amount)as Amount from invoice
where income_class <> ''
group by income_class
), Achevied1 as
(select income_class , round(sum(amount),2) as Amount from brokerage
where income_class <> ''
group by income_class
), Achevied2 as ( 
select income_class , sum(amount) as Amount from fees
where income_class <> ''
group by income_class
)
select Income_class,
case 
when income_class = "New" then (select sum(New) as Target from budgets)
when income_class = "Renewal" then (select  sum(Renewal) as Target from budgets)
else (select  sum(Crosssell) as Target from budgets)
End as Target
,
invoice.amount as Invoice,round(Achevied1.Amount + Achevied2.Amount) as Achevied from 
invoice 
join 
Achevied1 using(income_class)
join 
Achevied2 using(income_class)
group by 1;

select * from budgets;

-- No of invoices by AE

select Account_Executive,count(*) from meeting
group by 1;

update invoice
set income_class = 'N/A'
where income_class = ''; 

-- No of meetings by Account Excectives

select Account_Executive,count(invoice_number), group_concat(distinct income_class,',') from invoice
group by 1;

-- Yearwise meetings

select year(meeting_date),count(*) from meeting
group by 1;

select * from meeting;


-- top 4 oppt

select opportunity_name,sum(revenue_amount)as amount from 
 (select *,case stage when 'Negotiate' then 'Closed' else 'Open' end as Result from opportunity) X 
 where result = 'Open'
group by 1
order by amount desc
limit 4;


select * from opportunity;
select distinct income_class from invoice;

select * from orderdetails;


