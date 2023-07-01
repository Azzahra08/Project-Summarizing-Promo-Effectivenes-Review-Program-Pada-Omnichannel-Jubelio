select * from buyer_table
select * from marketplace_table
select * from promo_code
select * from q3_q4_review
select * from sales_table
select * from seller_table
select * from shipping_table

--Query No.1 - No.3----

--Membuat Table (CREATE) dengan nama promo_code dan Melakukan Importing PROMO CODE--
create table promo_code(
	promo_id int,
	promo_name varchar,
	price_deduction int,
	description varchar,
	duration int
)

--Membuat Table (CREATE) baru dengan nama Q3_Q4_Review---
create table q3_q4_review(
	purchase_date date,
	quantity int,
	price int,
	total_price int,
	promo_code int,
	price_deduction int,
	price_after_promo int
)

--mengisikan table Q3_Q4_Review (INSERT) ---
insert into q3_q4_review(purchase_date, quantity, price, total_price, 
promo_code, price_deduction, price_after_promo)
select s.purchase_date, s.quantity, m.price, 
quantity*price as ac, p.promo_id, p.price_deduction, (quantity*price)-price_deduction
as ab from marketplace_table m left join sales_table s on m.item_id = s.item_id
left join promo_code p on s.promo_id = p.promo_id where purchase_date 
between '2022-07-01' and '2022-12-31'

-- Trend Aktivitas total penjualan Bulanan setelah terpotong promo --
select extract(month from purchase_date) as Month, sum(quantity) 
as Quantity, sum(price) as price, sum(price_deduction) as price_deduction, 
sum(price_after_promo) as price_after_promo from 
q3_q4_review group by Month order by price_after_promo desc

select extract(month from purchase_date) as Month, 
sum(price_after_promo) as price_after_promo from 
q3_q4_review group by Month order by price_after_promo desc

-- Trend Bulanan perbandingan Jumlah Rasio penggunaan promo dan yang tidak menggunakan promo----
select Month, Use_Promo, Not_Use_Promo,
Abs(Use_Promo - Not_Use_Promo) as Ratio from(
select extract(month from purchase_date) as Monthh, 
count(*) as Use_Promo
from q3_q4_review where promo_code is not null 
group by Monthh order by Use_Promo desc) as subquery1
Join 
(select extract(month from purchase_date) as Month, 
count(*) as Not_Use_Promo
from q3_q4_review where promo_code is null 
group by Month order by Not_Use_Promo desc) as subquery2 on
subquery1.Monthh = subquery2.Month

select Month, Abs(Use_Promo - Not_Use_Promo) as Ratio_ from(
select extract(month from purchase_date) as Monthh, 
count(*) as Use_Promo
from q3_q4_review where promo_code is not null 
group by Monthh order by Use_Promo desc) as subquery1
Join 
(select extract(month from purchase_date) as Month, 
count(*) as Not_Use_Promo
from q3_q4_review where promo_code is null 
group by Month order by Not_Use_Promo desc) as subquery2 on
subquery1.Monthh = subquery2.Month

--Query No.4-----

-- Membuat Table (CREATE) shipping_summary --
create table shipping_summary(
	shipping_date date,
	seller_name varchar,
	buyer_name varchar,
	buyer_address varchar,
	buyer_city varchar,
	buyer_zipcode int,
	resi_kode text
)

create table shipping_summary_desember(
	shipping_date_des date,
	seller_name_des varchar,
	buyer_name_des varchar,
	buyer_address_des varchar,
	buyer_city_des varchar,
	buyer_zipcode_des int,
	resi_kode_des text
)

-- . Buatlah QUERY untuk mengisikan table (INSERT) --
-- all --
insert into shipping_summary (shipping_date, seller_name, buyer_name,
buyer_address, buyer_city, buyer_zipcode, resi_kode)
select sht.shipping_date, selt.seller_name, bt.buyer_name, bt.address,
bt.city, bt.zipcode, concat(shipping_id, to_char(purchase_date, 'YYYYMMDD'),
to_char(shipping_date, 'YYYYMMDD'), sht.buyer_id, sht.seller_id)
from buyer_table as bt
left join shipping_table as sht on bt.buyer_id = sht.buyer_id 
left join seller_table as selt on sht.seller_id = selt.seller_id

-- December--
insert into shipping_summary_desember (shipping_date_des, seller_name_des, buyer_name_des,
buyer_address_des, buyer_city_des, buyer_zipcode_des, resi_kode_des)
select sht.shipping_date, selt.seller_name, bt.buyer_name, bt.address,
bt.city, bt.zipcode, concat(shipping_id, to_char(purchase_date, 'YYYYMMDD'),
to_char(shipping_date, 'YYYYMMDD'), sht.buyer_id, sht.seller_id)
from buyer_table as bt
left join shipping_table as sht on bt.buyer_id = sht.buyer_id 
left join seller_table as selt on sht.seller_id = selt.seller_id
where shipping_date between '2022-12-01' and '2022-12-31' and purchase_date
between '2022-12-01' and '2022-12-31'

select * from shipping_summary 
select * from shipping_summary_desember