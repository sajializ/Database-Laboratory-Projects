--- q14
insert into public.temp_company 
(
	company_name,
	profile_description ,
	business_stream_id ,
	establishment_date ,
	company_website_url 
) values 
(
	'Tapsi',
	'Tapsi is a company',
	'11820889-f9c9-4436-aabd-8867dffb76f3',
	'1/1/2021',
	'tapsi.com'
);


--- q15
alter table public.temp_company drop column "profile_description";

alter table public.temp_company add column "Desc" varchar(500);


--- q16
drop table public.temp_company;


--- q17, a
select exd.job_title as "Experience"
from "SeekerProfileBuilder".experience_detail exd
where exd.user_account_id = '0308c8a4-dfb4-4293-b0f5-da022ebc1096'
union 
select edd.major as "Experience"
from "SeekerProfileBuilder".education_datail edd
where edd.user_account_id = '0308c8a4-dfb4-4293-b0f5-da022ebc1096';


--- q17, b
select job_description 
from "JobPostManagement".job_post
where id not in (
	select job_post_id
	from "JobPostManagement".user_post_activity 
);


--- q17, c
select user_account_id, apply_date
from "JobPostManagement".user_post_activity
where job_post_id = '0834891e-82d4-4d5a-9555-b7240de27976'
order by apply_date desc;


--- q18, d
select id , job_description, count(user_account_id)
from "JobPostManagement".job_post jp left join "JobPostManagement".user_post_activity upa
	on jp.id = upa.job_post_id
where jp.company_id = 'f3808f21-219c-47e6-8239-0a4f95dc7509'
group by id;


--- q19, e
select id, job_description, count(user_account_id)
from "JobPostManagement".job_post jp left join "JobPostManagement".user_post_activity upa
	on jp.id = upa.job_post_id
where jp.company_id = 'f3808f21-219c-47e6-8239-0a4f95dc7509'
group by id
having count(user_account_id) = 0;


--- q19, f
select major, count(*) as c
from "JobPostManagement".user_post_activity upa 
	left join "SeekerProfileBuilder".education_datail ed 
	on upa.user_account_id = ed.user_account_id
group by major
order by c desc
limit 1;


--- q20, g
select ut.user_type_name 
from "UserManagement".user_type ut;


--- q20, h
select jp.job_description, jl.country
from "JobPostManagement".job_post jp left join "JobPostManagement".job_location jl 
	on jp.job_location_id = jl.id