use strict;
my $psql = "psql -a -h localhost -d bank -U postgres";
open(PSQL, "| $psql");
print PSQL<<END;
set client_encoding=UTF-8;
create table application_market_layer.card_all 
as
(select b.address 地区,count(*) 总数,card_start_dt,card_end_dt
from common_processing_layer.card c
left join common_processing_layer.agreement_address b
on substr(c.branch_code,1,2)=b.address_code
group by b.address,card_start_dt,card_end_dt
order by 总数);

create table application_market_layer.card_valid 
as
(select b.address 地区,count(*) 总数,card_start_dt,card_end_dt
from common_processing_layer.card c
left join common_processing_layer.agreement_address b
on substr(c.branch_code,1,2)=b.address_code
where c.card_status_code not in ('1','2')
and c.maturity_date>'2009-08-31'
and (c.active_date-c.open_card_date)<=365/2
and c.lock_stat_code not in ('R','L','S','D','T')
group by b.address,card_start_dt,card_end_dt
order by 总数);

create table application_market_layer.card_inc_month
as
(select b.address 地区,count(*) 总数,card_start_dt,card_end_dt
from common_processing_layer.card c
left join common_processing_layer.agreement_address b
on substr(c.branch_code,1,2)=b.address_code
where c.open_card_date>'2009-07-31' 
and c.open_card_date<'2009-08-31'
group by b.address,card_start_dt,card_end_dt
order by 总数);

create table application_market_layer.card_new_cust
as
(select b.address 地区,count(card_no) 新客户发卡,card_start_dt,card_end_dt
from common_processing_layer.card c
left join common_processing_layer.agreement_address b
on substr(c.branch_code,1,2)=b.address_code
where c.card_status_code not in ('1','2')
and c.maturity_date<'2017-01-12'
and (c.active_date-c.open_card_date)<=365/2
and c.lock_stat_code not in ('R','L','S','D','T')
and c.open_card_date>'2009-08-01'
and c.active_date>'2009-08-01'
group by b.address,card_start_dt,card_end_dt
order by 新客户发卡);

create table application_market_layer.card_old_cust
as
(select b.address 地区,count(*) 老客户发卡,card_start_dt,card_end_dt
from common_processing_layer.card c
left join common_processing_layer.agreement_address b
on substr(c.branch_code,1,2)=b.address_code
where c.card_status_code not in ('1','2')
and c.maturity_date<'2017-01-12'
and (c.active_date-c.open_card_date)<=365/2
and c.lock_stat_code not in ('R','L','S','D','T')
and c.open_card_date<'2009-08-31'
group by b.address,card_start_dt,card_end_dt
order by 老客户发卡);

create table application_market_layer.card_inc_maturity
as
(select b.address 地区,c.card_no 卡号,card_start_dt,card_end_dt
from common_processing_layer.card c
left join common_processing_layer.agreement_address b
on substr(c.branch_code,1,2)=b.address_code
where c.card_invalid_date<'2009-08-31' 
and c.card_invalid_date>'2009-07-31'
group by b.address,卡号,card_start_dt,card_end_dt
order by b.address);

create table application_market_layer.card_year_inc_cancel
as
(select b.address 地区,count(*) 总数,card_start_dt,card_end_dt
from common_processing_layer.card c
left join common_processing_layer.agreement_address b
on substr(c.branch_code,1,2)=b.address_code
where c.cancel_card_date<'2009-08-31'
group by b.address,card_start_dt,card_end_dt
order by 总数);

create table application_market_layer.cust_all
as
(select b.address 地区,p.gender_code 性别,count(*) 总数,agreement_start_dt,agreement_end_dt
from common_processing_layer.cust p
left join common_processing_layer.agreement_address b
on substr(p.branch_code,1,2)=b.address_code
group by b.address,p.gender_code,agreement_start_dt,agreement_end_dt
order by agreement_start_dt);

create table application_market_layer.cust_valid
as
(select b.address 地区,p.gender_code 性别,count(p.cust_id) 有效客户量,agreement_start_dt,agreement_end_dt
from common_processing_layer.cust p
left join common_processing_layer.agreement_address b
on substr(p.branch_code,1,2)=b.address_code
left join common_processing_layer.card c using(party_id)
where c.card_status_code not in ('1','2')
and c.maturity_date>'2009-08-31'
and (c.active_date-c.open_card_date)<=365/2
and c.lock_stat_code not in ('R','L','S','D','T')
group by b.address,p.gender_code,agreement_start_dt,agreement_end_dt
having count(c.card_no)>0
order by 有效客户量);

create table application_market_layer.cust_inc_month
as
(select b.address 地区,p.gender_code 性别,count(*) 总数,agreement_start_dt,agreement_end_dt
from common_processing_layer.cust p
left join common_processing_layer.agreement_address b
on substr(p.branch_code,1,2)=b.address_code
left join common_processing_layer.card c using(agreement_id)
where c.open_card_date>'2009-07-31' 
and c.open_card_date<'2009-08-31'
group by b.address,p.gender_code,agreement_start_dt,agreement_end_dt
order by b.address,总数);

create table application_market_layer.cust_cancel_month
as
(select b.address 地区,p.gender_code 性别,count(*) 总数,agreement_start_dt,agreement_end_dt
from common_processing_layer.cust p
left join common_processing_layer.agreement_address b
on substr(p.branch_code,1,2)=b.address_code
left join common_processing_layer.card c using(agreement_id)
where c.cancel_card_date<'2009-08-31'
and c.cancel_card_date>'2009-07-31'
group by b.address,p.gender_code,agreement_start_dt,agreement_end_dt
order by b.address,总数);

create table application_market_layer.cust_cancel_all
as
(select b.address 地区,p.gender_code 性别,count(*) 总数,agreement_start_dt,agreement_end_dt
from common_processing_layer.cust p
left join common_processing_layer.agreement_address b
on substr(p.branch_code,1,2)=b.address_code
left join common_processing_layer.card c using(agreement_id)
where c.cancel_card_date>'2009-08-31'
group by b.address,p.gender_code,agreement_start_dt,agreement_end_dt
order by b.address,总数);

create table application_market_layer.cust_maturity
as
(select b.address 地区,p.gender_code 性别,count(*) 总数,agreement_start_dt,agreement_end_dt
from common_processing_layer.cust p
left join common_processing_layer.agreement_address b
on substr(p.branch_code,1,2)=b.address_code
left join common_processing_layer.card c using(agreement_id)
where c.cancel_card_date>'2009-08-31'
and c.maturity_date<'2009-08-31'
group by b.address,p.gender_code,agreement_start_dt,agreement_end_dt
order by b.address,总数);

create table application_market_layer.acct_all
as
(select b.address 地区,count(*) 总数,agreement_start_dt,agreement_end_dt
from common_processing_layer.acct a
left join common_processing_layer.agreement_address b 
on substr(a.branch_code,1,2)=b.address_code
group by b.address,agreement_start_dt,agreement_end_dt
order by 总数);

create table application_market_layer.acct_valid
as
(select b.address 地区,count(a.acct_no) 有效账户数,agreement_start_dt,agreement_end_dt
from common_processing_layer.acct a
left join common_processing_layer.agreement_address b 
on substr(a.branch_code,1,2)=b.address_code
where a.cancel_acct_date='3000-12-31'
and a.acct_status_code <>'C'
group by b.address,agreement_start_dt,agreement_end_dt
order by 有效账户数);

create table application_market_layer.acct_inc_month
as
(select b.address 地区,count(a.acct_no) 当月新增账户,agreement_start_dt,agreement_end_dt
from common_processing_layer.acct a
left join common_processing_layer.agreement_address b 
on substr(a.branch_code,1,2)=b.address_code
left join common_processing_layer.card c using(agreement_id)
where a.cancel_acct_date='3000-12-31'
and a.acct_status_code <>'C'
and c.open_card_date between '2009-08-01' and '2009-08-31'
group by b.address,agreement_start_dt,agreement_end_dt
order by 当月新增账户);

create table application_market_layer.acct_cancel_month
as
(select b.address 地区,count(a.acct_no) 当月注销账户,agreement_start_dt,agreement_end_dt
from common_processing_layer.acct a
left join common_processing_layer.agreement_address b 
on substr(a.branch_code,1,2)=b.address_code
where a.cancel_acct_date between '2009-08-01' and '2009-08-31'
group by b.address,agreement_start_dt,agreement_end_dt
order by 当月注销账户);

END
close(PSQL);