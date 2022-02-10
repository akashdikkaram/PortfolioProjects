-- first select min page view id and url because it is the first landing page of a session 
DROP TEMPORARY TABLE IF EXISTS first_page_view_table;
DROP TEMPORARY TABLE IF EXISTS bounced_session_only;

create temporary table first_page_view_table
select
	website_pageviews.website_session_id,
	min(website_pageview_id),
    pageview_url
from website_pageviews
where created_at between '2014-01-01' and '2014-02-01'
group by website_pageviews.website_session_id;

-- then calculate bounce sessions    
create temporary table bounced_session_only
select
	first_page_view_table.website_session_id,
    first_page_view_table.pageview_url,
    count(website_pageviews.website_pageview_id)
from first_page_view_table
left join website_pageviews
on website_pageviews.website_session_id = first_page_view_table.website_session_id

group by 
    first_page_view_table.website_session_id,
    first_page_view_table.pageview_url
    
having 
	count(website_pageviews.website_pageview_id) = 1;
    
-- now compare landing page sessions to bounce page sessions

select 
	first_page_view_table.pageview_url,
	count( distinct first_page_view_table.website_session_id) as 'Landed Sessions',
    count(distinct bounced_session_only.website_session_id) as 'Bounced Sessions'
from first_page_view_table
left join bounced_session_only
on first_page_view_table.website_session_id = bounced_session_only.website_session_id
group by first_page_view_table.pageview_url
order by first_page_view_table.website_session_id desc

    
    

    
    
	
