drop table if exists php_arrays;
create temp table  php_arrays (id int, str text );
insert into php_arrays values
        (1,'a:1:{s:3:"foo";s:3:"bar"}  '),
        (2,'a:2:{s:3:"foo";a:1:{s:3:"foo";s:3:"bar"}}'),
        (3,'a2:{s:3:"foo";a:2:{s:3:"foo";s:3:"bar";s:3:"bar";s:3:"foo";}}'),
        (4,'a3:{s:3:"foo";a:2:{s:3:"foo";s:3:"bar";s:3:"bar";s:3:"foo";};s:3:"bar";s:3:"foo"}'),
        (5,'a:2:{s:3:"foo";i:3;s:3:"bar";b:1;}'),
        (5,'a:3:{s:3:"foo";i:3;s:3:"bar";b:1;s:6:"foobar";N;}'),
        (7,'a:3:{s:5:"fooN;";i:3;s:3:"bar";b:1;s:6:"foobar";N;}'),
        (8,'a:2:{s:14:"event_partners";a:0:{}s:15:"selective_color";s:7:"#0f68be";}'),
        (9,'a:30:{s:16:"template_version";s:8:"20190920";s:9:"templates";a:1:{s:15:"EventController";a:1:{s:5:"index";s:12:"event_page_3";}}s:17:"seatcheck_version";i:1;s:7:"mapAddr";s:37:"+55.837319738620074,+37.6241507694992";s:14:"event_partners";a:0:{}s:15:"selective_color";s:7:"#0f68be";s:14:"to_description";N;}'),
        (10,'a:1:{s:3:"foo";s:31:"<p><strong>Информация"}'),
        (11,'a:1:{s:3:"foo";s:82:"<p><strong>Информация о событии</strong><br />
Название:"}'),
        (12,'a:1:{s:3:"foo";s:0:""}  '),
        (13,'a:1:{s:11:"hoverFactor";d:2.2;}'),
        (14,'a:2:{s:12:"hover\Factor";d:2.2;s:3:"foo";s:4:"b\ar";}'),
        (15,'a:1:{s:1:"x";d:-138.7060546875;}'),
        (16 , NULL),
        (17 , '  '),
        (18 , ''),
        (19, 'a:1:{s:12:"new_date_end";O:10:"TPDateTime":3:{
                s:4:"date";s:26:"2023-02-15 12:30:00.000000";
                s:13:"timezone_type";i:3;
                s:8:"timezone";s:13:"Europe/Moscow";
                }}')

;

select
   php_deserialize(str)
    , php_deserialize(str) ->'foo'
    , php_deserialize(str) ->'hover\Factor'
from php_arrays
order by
    id
;
