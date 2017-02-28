use DBI;
my $constr = "dbi:Pg:dbname=bank;port=5432;host=localhost";
my $user = "postgres";
my $pwd = "445475";
my $dbh=DBI->connect($constr,$user,$pwd);

$dbh->do("set client_encoding=GBK");
$dbh->do("
create table common_processing_layer.acct(
	acct_no VARCHAR(50),
	agreement_id VARCHAR(50),
	cancel_acct_date DATE,
	acct_status_code VARCHAR(50),
	branch_code VARCHAR(50),
	agreement_start_dt DATE,
	agreement_end_dt DATE
);

create table common_processing_layer.cust(
	cust_id VARCHAR(50),
	party_id VARCHAR(50),
	card_no VARCHAR(50),
	agreement_id VARCHAR(50),
	open_card_date DATE,
	cancel_card_date DATE,
	maturity_date DATE,
	active_date DATE,
	branch_code VARCHAR(50),
	gender_code VARCHAR(50),
	agreement_start_dt DATE,
	agreement_end_dt DATE
);

create table common_processing_layer.card(
	card_no VARCHAR(50),
	agreement_id VARCHAR(50),
	open_card_date date,
	active_date DATE,
	cancel_card_date DATE,
	maturity_date DATE,
	cust_id VARCHAR(50),
	party_id VARCHAR(50),
	branch_code VARCHAR(50),
	acct_no VARCHAR(50),
	lock_stat_code VARCHAR(50),
	card_status_code VARCHAR(50),
	card_invalid_date date,
	card_start_dt DATE,
	card_end_dt DATE
);
create table common_processing_layer.AGREEMENT_ADDRESS as (select ADDRESS_CODE, ADDRESS from intergration.AGREEMENT_ADDRESS);


create table common_processing_layer.agree as select * from (intergration.agreement 
			left join intergration.account  using(agreement_id)
			left join intergration.AGREEMENT_STATUS_HISTORY  using(agreement_id));


insert into common_processing_layer.acct(acct_no,agreement_id,cancel_acct_date,acct_status_code,branch_code,agreement_start_dt,agreement_end_dt
)
select agree.acct_no,agree.agreement_id,agree.cancel_acct_date,agree.acct_status_code,agree.branch_code,agree.agreement_start_dt,agree.agreement_end_dt
from intergration.PARTY_AGREEMENT_RELATION_HISTORY pa 
left join common_processing_layer.agree using(agreement_id);


drop table common_processing_layer.agree;


create table common_processing_layer.agree2 as select * from (intergration.agreement 
			left join intergration.card  using(agreement_id)); 		

create table common_processing_layer.agree3 as select * from (intergration.party
			left join intergration.cust using(party_id,cust_name,birthday,public_private_code)); 

insert into common_processing_layer.cust(cust_id,party_id,card_no,agreement_id,open_card_date,cancel_card_date,maturity_date,active_date,
branch_code,gender_code,agreement_start_dt,agreement_end_dt)
select agree3.cust_id,agree3.party_id,agree2.card_no,agree2.agreement_id,agree2.open_card_date,agree2.cancel_card_date,
agree2.maturity_date,agree2.active_date,agree2.branch_code,agree3.gender_code,agree2.agreement_start_dt,agree2.agreement_end_dt
from common_processing_layer.agree3
left join intergration.PARTY_AGREEMENT_RELATION_HISTORY pa using(party_id)
left join common_processing_layer.agree2 using(agreement_id);



drop table common_processing_layer.agree2;
drop table common_processing_layer.agree3;




create table common_processing_layer.agree4 as select * from (intergration.agreement 
			left join intergration.account  using(agreement_id) 
			left join intergration.card  using(agreement_id,cust_id)
			left join intergration.AGREEMENT_STATUS_HISTORY  using(agreement_id));

create table common_processing_layer.agree3 as select * from (intergration.cust 
			left join intergration.party  using(party_id,cust_name,birthday,public_private_code)); 


insert into common_processing_layer.card(card_no,agreement_id,open_card_date,active_date,cancel_card_date,maturity_date,cust_id,party_id,
branch_code,acct_no,lock_stat_code,card_status_code,card_invalid_date,card_start_dt,card_end_dt)
select  agree4.card_no,agree4.agreement_id,agree4.open_card_date,agree4.active_date,agree4.cancel_card_date,
agree4.maturity_date,agree3.cust_id,agree3.party_id,agree4.branch_code,agree4.acct_no,agree4.lock_stat_code,
agree4.card_status_code,agree4.card_invalid_date,agree4.card_start_dt,agree4.card_end_dt
from   intergration.PARTY_AGREEMENT_RELATION_HISTORY pa
left join common_processing_layer.agree4 using(agreement_id)
left join common_processing_layer.agree3 using(party_id);


drop table common_processing_layer.agree3;
drop table common_processing_layer.agree4;

");

$dbh->disconnect();