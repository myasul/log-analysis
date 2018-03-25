# log-analysis
Udacity's Full Stack Developer Nanodegree Project - Log Analysis

How to run the log analyzer.
- Download/clone the git repository
- Run 'python3 log_analyzer.py'

Note: Make sure that you are running the python file using Python 3.


** Views/Queries used **

-- View to get the top articles based on views

create view top_articles as
select a.title, count(*) as article_views
    from log l, articles a
    where l.path like '%' || a.slug || '%' 
    group by a.title
    order by article_views desc;

-- View to get the top authors based on views

create view top_authors as
select au.name, count(*) as article_views
    from log l, articles a, authors au
    where l.path like '%' || a.slug || '%'
        and a.author = au.id
    group by au.name
    order by article_views desc;

-- View to get the average views that succeeded versus the ones that returned an error per day

create view view_perc_log as
select l1.log_date, 
        l1.status, 
        (round(cast (l1.status_count as numeric) / cast (l2.status_count as numeric) * 100,2)) as perc 
    from (select time::timestamp::date as log_date, statnus, count(status) as status_count 
    from log                                                                              
    group by log_date, status) l1,
    (select time::timestamp::date as log_date, count(status) as status_count 
    from log
    group by log_date) l2
    where to_char(l1.log_date, 'YYYY-MM-DD') = to_char(l2.log_date, 'YYYY-MM-DD');