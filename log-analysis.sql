-- Query to get the top 3 articles based on views
-- Created view > top_articles
select a.title, count(*) as article_views
    from log l, articles a
    where l.path like '%' || a.slug || '%' 
    group by a.title
    order by article_views desc;
    limit 3;


-- Query to get the top 3 authors based on views
-- Created view > top_authors
select au.name, count(*) as article_views
    from log l, articles a, authors au
    where l.path like '%' || a.slug || '%'
        and a.author = au.id
    group by au.name
    order by article_views desc;
    limit 3;

-- Query to get the average views that succeeded versus the ones that returned an error per day
-- Created view > view_percentage_log

select l1.log_date, 
        l1.status, 
        (round(cast (l1.status_count as numeric) / cast (l2.status_count as numeric) * 100,2)) as add -- Gets the percentage of a specific status
    from (select time::timestamp::date as log_date, status, count(status) as status_count -- Query that returns the number of views 
    from log                                                                              -- grouped by respective status.  
    group by log_date, status) l1,
    (select time::timestamp::date as log_date, count(status) as status_count -- Query that returns total number of requests per day
    from log
    group by log_date) l2
    where to_char(l1.log_date, 'YYYY-MM-DD') = to_char(l2.log_date, 'YYYY-MM-DD')
    limit 4;

select time::timestamp::date as log_date, count(status) as status_count
    from log
    group by log_date

select time::timestamp::date as log_date, status, count(status) as status_count
    from log
    group by log_date

-- Query to get number of views for a given article
select count(*) as article_views
    from log l, (select slug from articles) as a
    where l.path like '%' || a.slug || '%' limit 3 order by article_views;

-- Query to get the views of every article published by an author
select a.title, au.name, count(*) as article_views
    from log l, articles a, authors au
    where l.path like '%' || a.slug || '%'
        and a.author = au.id
        and au.name = 'Rudolf von Treppenwitz'
    group by a.title, au.name
    order by article_views desc;

-- Query to get the author's name for an article
select au.name, a.title 
    from authors au, articles a
    where au.id = a.author
        --and a.title = 'Candidate is jerk, alleges rival';
        and au.name ='Rudolf von Treppenwitz';

-- Query to get all the statuses stored in log table
select distinct status from log