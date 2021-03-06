-- Query to get the top articles based on views
create view top_articles as
select a.title, count(*) as article_views
    from log l, articles a
    where l.path = ('/article/' || a.slug)
    group by a.title
    order by article_views desc;

-- Query to get the top authors based on views
create view top_authors as
select au.name, count(*) as article_views
    from log l, articles a, authors au
    where l.path = ('/article/' || a.slug)
        and a.author = au.id
    group by au.name
    order by article_views desc;

-- Query to get the average views that returned an error per day
create view error_perc_log as
select l1.log_date, 
        (round(cast (l1.status_count as numeric) / cast (l2.status_count as numeric) * 100,2)) as perc 
    from (select time::timestamp::date as log_date, count(status) as status_count 
    from log             
    where status = '404 NOT FOUND'                                                            
    group by log_date, status) l1,
    (select time::timestamp::date as log_date, count(status) as status_count 
    from log
    group by log_date) l2
    where to_char(l1.log_date, 'YYYY-MM-DD') = to_char(l2.log_date, 'YYYY-MM-DD');