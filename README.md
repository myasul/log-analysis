# log-analysis
Udacity's Full Stack Developer Nanodegree Project - Log Analysis

Description:
This is a reporting tool for a newspaper site. The tool prints out reports (in plain text) based on the data extracted from the database. The reporting tool is a Python program using psycopg2 module to connect to the database. It also uses the built-in modules to create and write the fetched data into the plain text file.

The extract from the reporting tool answers the following questions:
- What are the most popular three articles of all time?
- Who are the most popular article authors of all time? 
- On which days did more than 1% of requests lead to errors? 

Requirements:
Here are pre-requisites for you to able to run the reporting tool.

* Install Python 3.
http://docs.python-guide.org/en/latest/starting/installation/

* Install PostgreSQL.
http://postgresguide.com/setup/install.html

* Install psycopg2.
Via Windows:
http://www.stickpeople.com/projects/python/win-psycopg/

Mac:
https://medium.com/pixel-heart/os-x-sierra-postgresql-and-psycopg2-42c0c95acb23

Linux:
https://www.fullstackpython.com/blog/postgresql-python-3-psycopg2-ubuntu-1604.html

* Download and import news database in PostgreSQL.
    - You can download the news database in the link below.
    https://d17h27t6h515a5.cloudfront.net/topher/2016/August/57b5f748_newsdata/newsdata.zip
    - Unzip the file.
    - Run this command in your terminal/console 'psql -d news -f newsdata.sql' in the same directory where newsdata.sql is located.

* Import the views in your news database.
Run the command 'psql -d news -f create_views.sql' in the same directory where create_views.sql is located.

Execution:
Follow the link below for the steps to run a Python script.
https://www.pythoncentral.io/execute-python-script-file-shell/

The file to be run is log_analyzer.py. After you have run log_analyzer.py, it should generate the text file named analysis.txt.

** Views/Queries used **

-- View to get the top articles based on views

create view top_articles as
select a.title, count(*) as article_views
    from log l, articles a
    where l.path = ('/article/' || a.slug)
    group by a.title
    order by article_views desc;

-- View to get the top authors based on views

create view top_authors as
select au.name, count(*) as article_views
    from log l, articles a, authors au
    where l.path = ('/article/' || a.slug)
        and a.author = au.id
    group by au.name
    order by article_views desc;

-- View to get the average views that returned an error per day

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