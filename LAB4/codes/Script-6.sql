--- q1
select r.region_description , t.territory_description 
from region r inner join territories t on r.region_id = t.region_id;


--- q2
select r.region_description , count(distinct et.employee_id)
from region r inner join territories t on r.region_id = t.region_id 
	inner join employee_territories et on et.territory_id = t.territory_id
group by r.region_id;


--- q3
select o.order_id , sum(od.quantity * od.unit_price * (1 - od.discount))
from orders o inner join order_details od on o.order_id = od.order_id
group by o.order_id;


--- q4
with order_count(product_id, quantity) as
	(
		select od.product_id , sum(od.quantity)
		from order_details od
		group by od.product_id 
	)
select p.product_name , oc.quantity
from order_count oc inner join products p on oc.product_id = p.product_id
order by oc.quantity desc 
limit 10;


--- q5
select p.product_name 
from products p left join order_details od on p.product_id = od.product_id
where od.order_id is null;


--- q6
select p.product_name , count(od.order_id)
from products p left join order_details od on p.product_id = od.product_id 
group by p.product_id;


--- q7
with order_price(order_id, employee_id, order_year , price) as
(
	select o.order_id , o.employee_id , extract (year from o.order_date)
		, sum(od.quantity * od.unit_price * (1 - od.discount))
	from orders o inner join order_details od on o.order_id = od.order_id
	group by o.order_id
), employees_sales(employee_id, last_name, total_sales) as
(
	select e.employee_id , e.last_name , sum(op.price) as total_sales
	from employees e left join order_price op on e.employee_id = op.employee_id
	where op.order_year = 1997
	group by e.employee_id
)
select last_name, total_sales
from employees_sales
order by total_sales desc
limit 1;


--- q8
select o.order_id ,
	case
		when o.shipped_date = o.order_date then 'Perfect'
		when o.shipped_date - o.order_date <= 3 then 'Good'
		when o.shipped_date - o.order_date > 3
			or o.shipped_date - o.order_date isnull then 'Bad'
	end order_label
from orders o;


--- q9
with recursive reports_to as 
(
	select e.employee_id , e.reports_to , e.last_name 
	from employees e
	where e.employee_id = 2
	union
		select e.employee_id, e.reports_to , e.last_name 
		from employees e inner join reports_to rt on e.reports_to = rt.employee_id
) 
select *
from reports_to;


--- q10
select extract(year from a.shipped_date) as year_, sum(b.Subtotal)
from orders a
inner join
(
	select distinct od.order_id , sum(od.unit_price * od.quantity) as Subtotal
	from order_details od
	group by od.order_id 
) b on a.order_id = b.order_id
where a.shipped_date is not null 
group by year_


--- q11
create or replace view low_products as
(
	select p
	from products p where p.units_in_stock < p.reorder_level
	order by p.units_in_stock asc
);
select * from low_products;


--- q12
with france_categories(category_name) as 
(
	select distinct c.category_name
	from orders o
		inner join order_details od on od.order_id = o.order_id
		inner join products p on p.product_id = od.product_id
		inner join categories c on c.category_id = p.category_id
	where o.ship_country = 'France'
)
select *
from categories
where category_name not in (select fc.category_name from france_categories fc)


--- q14
select *
from customers c 
where c.fax isnull;


--- q15
create or replace view employee_with_age as
(
	select *, age(e.birth_date) as "employee_age"
	from employees e
);

select r.region_description , avg(ewa.employee_age)
from region r inner join territories t on r.region_id = t.region_id 
	inner join employee_territories et on t.territory_id = et.territory_id 
	inner join employee_with_age ewa on et.employee_id = ewa.employee_id
group by r.region_description;
