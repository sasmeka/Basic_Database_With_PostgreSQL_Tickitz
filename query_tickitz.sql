--=============== Menampilkan data Movie ===================
select tm.*, a.movie_cast,b.movie_genre from movie tm 
left join (select tmc.id_movie,ARRAY_AGG(tc.id_cast) as movie_cast from movie_cast tmc
left join casts tc on tmc.id_cast = tc.id_cast
group by tmc.id_movie) as a on a.id_movie = tm.id_movie
left join (select tmg.id_movie, ARRAY_AGG(tg.id_genre) as movie_genre from movie_genre tmg
left join genre tg on tmg.id_genre = tg.id_genre
group by tmg.id_movie) as b on b.id_movie = tm.id_movie;

--=============== Menampilkan data Schedule ===================
select ts.id_schedule,ts.price, ts.date_start, ts.date_end, tm_new.title, tpre.name_premier, tl.building, concat(tl.street,', ',tv.name_village,', ',tsu.name_subdistrict,', ',tr.name_regency,', ',tp.name_province) as location_movie, a.movie_time_schedule from schedule ts
left join (select tm.*,td.*, a.movie_cast,b.movie_genre from movie tm 
left join (select tmc.id_movie,STRING_AGG(tc.name_cast , ',') as movie_cast from movie_cast tmc
left join casts tc on tmc.id_cast = tc.id_cast
group by tmc.id_movie) as a on a.id_movie = tm.id_movie
left join (select tmg.id_movie, STRING_AGG(tg.name_genre , ',') as movie_genre from movie_genre tmg
left join genre tg on tmg.id_genre = tg.id_genre
group by tmg.id_movie) as b on b.id_movie = tm.id_movie 
left join director td on td.id_director = tm.id_director) as tm_new on tm_new.id_movie = ts.id_movie
left join location tl on tl.id_location = ts.id_location
left join village tv on tv.id_village =tl.id_village
left join subdistrict tsu on tsu.id_subdistrict = tv.id_subdistrict
left join regency tr on tr.id_regency = tsu.id_regency 
left join province tp on tp.id_province = tr.id_province
left join premier tpre on ts.id_premier = tpre.id_premier 
left join (select tts.id_schedule ,STRING_AGG(cast(tts.time_schedule as text),',') as movie_time_schedule from time_schedule tts group by tts.id_schedule) as a on ts.id_schedule = a.id_schedule;

--=============== Menampilkan data booking menurut Schedule & user ===================
select *, array_length(seats,1) as count_seat, (a.price * array_length(seats,1)) as total_payment from user tu 
right join booking tb on tb.id_user =tu.id_user 
left join time_schedule tts on tts.id_time_schedule = tb.id_time_schedule 
left join (select ts.id_schedule,ts.price, tm.title, tpre.name_premier, tl.building, concat(tl.street,', ',tv.name_village,', ',tsu.name_subdistrict,', ',tr.name_regency,', ',tp.name_province) as location_movie from schedule ts
left join movie tm on  tm.id_movie = ts.id_movie
left join location tl on tl.id_location = ts.id_location
left join village tv on tv.id_village =tl.id_village
left join subdistrict tsu on tsu.id_subdistrict = tv.id_subdistrict
left join regency tr on tr.id_regency = tsu.id_regency 
left join province tp on tp.id_province = tr.id_province
left join premier tpre on ts.id_premier = tpre.id_premier) as a on a.id_schedule = tts.id_schedule;