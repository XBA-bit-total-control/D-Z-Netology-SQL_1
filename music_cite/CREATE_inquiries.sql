-- Создание таблицы артистов
REATE TABLE IF NOT EXISTS Performer (
performer_id SERIAL PRIMARY KEY,
name VARCHAR(105) NOT NULL
);


-- Создание таблицы жанров
CREATE TABLE IF NOT EXISTS Genre (
genre_id SERIAL PRIMARY KEY,
genre_name VARCHAR(105) NOT NULL
);


-- Создание таблицы альбомов
CREATE TABLE IF NOT EXISTS Album (
album_id SERIAL PRIMARY KEY,
album_name VARCHAR(105) NOT NULL,
album_release_year DATE
);


-- Создание связи многие-ко-многим [артисты-жанры]
CREATE TABLE IF NOT EXISTS Con_ArtistGenre (
artist_genre_id SERIAL PRIMARY KEY,
performer_id INTEGER NOT NULL REFERENCES Performer(performer_id),
genre_id INTEGER NOT NULL REFERENCES Genre(genre_id)
);


-- Создание связи многие-ко-многим [артисты-альбомы]
CREATE TABLE IF NOT EXISTS Con_ArtistAlbum (
album_id INTEGER REFERENCES Album(album_id),
performer_id INTEGER REFERENCES Performer(performer_id),
CONSTRAINT pk PRIMARY KEY (album_id, performer_id)
);


-- Создание таблицы треков
CREATE TABLE IF NOT EXISTS Track (
track_id SERIAL PRIMARY KEY,
track_name VARCHAR(105) NOT NULL,
track_length VARCHAR(8),
album_id INTEGER NOT NULL REFERENCES Album(album_id)
);


-- Создание таблицы коллекций
CREATE TABLE IF NOT EXISTS Collection (
collection_id SERIAL PRIMARY KEY,
collection_name VARCHAR(105) NOT NULL,
collection_release_year DATE
);


-- Создание связи многие-ко-многим [коллекции-треки]
CREATE TABLE IF NOT EXISTS Con_collectionTrack (
coll_track_id SERIAL PRIMARY KEY,
collection_id INTEGER NOT NULL REFERENCES Collection(collection_id),
track_id INTEGER NOT NULL REFERENCES Track(track_id)
);