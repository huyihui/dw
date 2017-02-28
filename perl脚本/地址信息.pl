my $psql = "psql -a -h localhost -d bank -U postgres";
our ($a)=@ARGV;
$str = substr($a,5,5);
$cust = "cust-".$str;
$card = "card-".$str;
$acct = "acct-".$str;
#经过分析card表满足
open(PSQL,"| $psql");
print PSQL<<END;
set client_encoding=UTF-8;

INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('02', '黑龙江');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('03', '吉林');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('04', '辽宁');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('05', '河北');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('06', '河南');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('07', '山东');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('08', '江苏');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('09', '山西');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('10', '陕西');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('11', '甘肃');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('12', '四川');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('13', '青海');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('14', '湖南');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('15', '湖北');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('16', '江西');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('17', '安徽');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('18', '浙江');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('19', '福建');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('20', '广东');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('21', '广西');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('22', '贵州');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('23', '云南');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('24', '海南');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('25', '内蒙古');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('26', '新疆');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('27', '西藏');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('29', '宁夏回族自治区');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('30', '广西壮族自治区');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('31', '北京');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('34', '天津');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('35', '上海');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('36', '重庆');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('37', '香港');
INSERT INTO intergration.agreement_address(ADDRESS_CODE,ADDRESS) VALUES ('38', '澳门');


END
close(PSQL);