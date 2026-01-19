                                    -- Задание 2

-- Вывод самого длинного по продолжительности трека
SELECT track_name, track_length
FROM track
ORDER BY track_length DESC
LIMIT 1;


-- Треки длительностью 3,5 минуты и больше
SELECT track_name
FROM track
WHERE track_length >= 210;


-- Сборники выходившие с 2018 по 2020 год включительно
SELECT collection_name
FROM collection
WHERE '2018-01-01' <= collection_release_year AND collection_release_year <= '2020.12.31';


-- Артисты, имена которых состоят из 1 слова
-- Предположительно, если имя состоит не из одного слова, то оно будет разделено пробелом
SELECT name
FROM performer
WHERE REGEXP_COUNT(name, ' ', 1) = 0;


-- Треки в названии которых употребляется "мой" или "my"
SELECT track_name
FROM track
WHERE track_name ILIKE('мой %')
OR track_name ~~* ('% мой')
OR track_name ILIKE('% мой %')
OR track_name ~~* ('мой')
OR track_name ILIKE('my %')
OR track_name ~~* ('% my')
OR track_name ILIKE('% my %')
OR track_name ~~* ('my');

       --И так тоже получается
--SELECT track_name
--FROM track
--WHERE string_to_array(lower(track_name), ' ') && ARRAY['мой','my'];

       --Или так
--SELECT track_name
--FROM track
--WHERE track_name ILIKE ANY(ARRAY['мой %',
--								 '% мой',
--								 '% мой %',
--								 'мой',
--								 'my %',
--								 '% my',
--								 '% my %',
--								 'my']);


                                    --Задание 3


-- Количество исполнителей в каждом из жанров
SELECT genre_name, COUNT(cag.genre_id ) AS number_of_performers
FROM genre AS g
LEFT JOIN con_artist_genre AS cag ON g.genre_id = cag.genre_id
GROUP BY g.genre_name, cag.genre_id
ORDER BY cag.genre_id;


-- Количество треков, которые вошли в альбомы 2019-2020 годов
SELECT album_name, COUNT(t.album_id) AS number_of_tracks
FROM track AS t
JOIN album AS a ON a.album_id = t.album_id
WHERE '2019-01-01' <= a.album_release_year AND a.album_release_year <= '2020.12.31'
GROUP BY a.album_name
ORDER BY number_of_tracks;


-- Средняя продолжительность треков в разных альбомах
SELECT album_name, ROUND(AVG(track_length),1) AS average_track_length
FROM album AS a
LEFT JOIN track AS t ON a.album_id = t.album_id
GROUP BY a.album_name
ORDER BY average_track_length DESC;


-- Артисты, которые не выпустили альбомы в 2020 году
SELECT DISTINCT CONCAT(name, ' ', surname) AS artist_who_was_on_vacation_in_2019
FROM performer p
JOIN album AS a ON a.album_id = p.performer_id
JOIN track AS t ON a.album_id = t.album_id
WHERE a.album_release_year::VARCHAR NOT LIKE('2020%');


-- Сборники в которых участвовал солист группы 7Б Иван Демьян
SELECT c.collection_name
FROM collection AS c
JOIN con_collection_track AS cct ON c.collection_id = cct.collection_id
JOIN track AS t  ON cct.track_id = t.track_id
JOIN con_artist_album AS caa ON  t.album_id = caa.album_id
JOIN performer AS p ON caa.performer_id = p.performer_id
WHERE CONCAT(p.name, ' ', p.surname) = 'Иван Демьян';


                                    -- Задание 4


-- Вывод альбомов, исполнители которых выступают в нескольких жанрах
SELECT album_name
FROM (
      SELECT  a.album_name, COUNT(g.genre_name) AS genres_of_the_performer
      FROM album AS a
      JOIN con_artist_album AS caa ON  a.album_id = caa.album_id
      JOIN performer AS p ON caa.performer_id = p.performer_id
      JOIN con_artist_genre AS cag ON cag.performer_id = p.performer_id
      JOIN genre AS g ON cag.genre_id = g.genre_id
      GROUP BY a.album_name
      )
WHERE genres_of_the_performer > 1;


-- Треки, которые не вошли ни в один сборник
SELECT t.track_name
FROM track AS t
LEFT JOIN con_collection_track AS cct ON cct.track_id = t.track_id
WHERE cct.coll_track_id IS NULL;


-- Исполнитель/и, написавшие самый короткий трек
SELECT CONCAT(name, ' ', surname) AS artist, MIN(t.track_length) AS duration
FROM performer AS p
JOIN con_artist_album AS caa ON caa.performer_id = p.performer_id
JOIN album AS a ON a.album_id = caa.album_id
JOIN track AS t ON t.album_id = a.album_id
WHERE t.track_length = (SELECT MIN(t.track_length) FROM track AS t )
GROUP BY p.name, p.surname
ORDER BY duration;


-- Альбомы в которых самое малое количество треков
SELECT *
FROM (
      SELECT album_name, COUNT(a.album_id) AS occurrence
      FROM album AS a
      JOIN track AS t ON t.album_id = a.album_id
      GROUP BY a.album_name
      ORDER BY occurrence
      )
WHERE occurrence = (
                    SELECT MIN(occurrence)
                    FROM (
                          SELECT album_name, COUNT(a.album_id) AS occurrence
                          FROM album AS a
                          JOIN track AS t ON t.album_id = a.album_id
                          GROUP BY a.album_name
                          ORDER BY occurrence
                          )
                   );