DROP TEMPORARY TABLE IF EXISTS firstpage_view;

create temporary table firstpage_view
select
	min(website_pageview_id),
    website_session_id,
    pageview_url
from website_pageviews
where created_at < '2012-06-12'
group by website_session_id;

select
	pageview_url,
    count(distinct website_session_id)
from firstpage_view
group by pageview_url
