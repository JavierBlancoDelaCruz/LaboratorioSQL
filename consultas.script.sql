-- ***********************
-- *** LABORATORIO SQL *** (Base de datos utilizada: " LemonMusic.bak ")
-- ***********************

USE LemonMusic;

-- CONSULTAS:

-- Listar las pistas (tabla Track) con precio mayor o igual a 1€.  *[Solución: 213 pistas]*

	SELECT t.TrackId, t.Name, t.UnitPrice
	FROM dbo.Track t
	WHERE t.UnitPrice >= 1.00;


-- Listar las pistas de más de 4 minutos de duración.  *[Solución: 2041 pistas]*

	SELECT t.TrackId, t.Name, t.Milliseconds, CAST(ROUND(t.Milliseconds/60000.0 , 2) AS DECIMAL(20,2)) "Minutos" 
	FROM dbo.Track t
	WHERE t.Milliseconds >= 240000;


-- Listar las pistas que tengan entre 2 y 3 minutos de duración.  *[Solución: 387 pistas]*

	SELECT t.TrackId, t.Name, CAST(ROUND(t.Milliseconds/60000.0 , 2) AS FLOAT(2)) "Minutos" 
	FROM dbo.Track t
	WHERE t.Milliseconds BETWEEN 120000 AND 180000;


-- Listar las pistas que uno de sus compositores (columna Composer) sea Mercury.  *[Solución: 16 pistas]*

	SELECT t.TrackId, t.Name, t.Composer
	FROM dbo.Track t
	WHERE t.Composer LIKE '%Mercury%';


-- Calcular la media de duración de las pistas (Track) de la plataforma.  *[Solución:  393599 milisegundos o 6,56 minutos]*

	SELECT 'Milisegundos' "Formato",AVG(t.Milliseconds) "Duración media de pistas"
	FROM dbo.Track t

	UNION

	SELECT 'Minutos',CAST(ROUND(AVG(t.Milliseconds)/60000.0 , 2) AS FLOAT(2))
	FROM dbo.Track t;


-- Listar los clientes (tabla Customer) de USA, Canada y Brazil.  *[Solución: 26 clientes]*

	SELECT c.CustomerId, c.FirstName, c.LastName, c.Country
	FROM dbo.Customer c
	WHERE c.Country IN ('USA', 'Canada', 'Brazil');


-- Listar todas las pistas del artista 'Queen' (Artist.Name = 'Queen').  *[Solución: 9 pistas +1 con David Bowie]*

	SELECT t.TrackId, t.Name, t.Composer
	FROM dbo.Track t
	WHERE t.Composer = 'Queen';
	-- WHERE t.Composer LIKE '%Queen%'; -- Con este WHERE Saldría 1 pista más de Queen & David Bowie (pero no solo de Artist.Name = 'Queen')


	-- En este caso no haría falta relacionar las tablas de Track con Artist para obtener el mismo resultado, pero solución más segura relacionando las tablas sería:
	SELECT t.TrackId, t.Name, t.Composer
	FROM dbo.Track t
	INNER JOIN  dbo.Artist a ON t.Composer = a.Name
	WHERE a.Name = 'Queen'; -- O también se podría hacer con WHERE t.Composer = 'Queen';


-- Listar las pistas del artista 'Queen' en las que haya participado como compositor David Bowie.  *[Solución: 1 pista]*

	SELECT t.TrackId, t.Name, t.Composer
	FROM dbo.Track t
	-- WHERE t.Composer LIKE '%Queen%David Bowie%'; -- Esto NO SERÍA LA MEJOR SOLUCIÓN porque en caso de no saber el orden de los nombres, si se hiciera un LIKE '%David Bowie%Queen%' saldrían 0 columnas.
	WHERE t.Composer LIKE '%David Bowie%' AND t.Composer LIKE '%Queen%'; -- MEJOR SOLUCIÓN porque no importaría no saber el orden en el que aparecen los nombres


-- Listar las pistas de la playlist 'Heavy Metal Classic'.  *[Solución: 26 pistas]*

	SELECT t.TrackId, t.Name, p.Name "Playlist", t.Composer
	FROM dbo.Track t
	INNER JOIN dbo.PlaylistTrack pt ON t.TrackId = pt.TrackId
	INNER JOIN dbo.Playlist p ON p.PlaylistId = pt.PlaylistId
	WHERE p.Name = 'Heavy Metal Classic';


-- Listar las playlist junto con el número de pistas que contienen.  *[Solución:  18 playlists (4 de ellas vacías)]*

	SELECT p.PlaylistId, p.Name "Nombre Playlist", COUNT(t.TrackId) "Nº de pistas"
	FROM dbo.Playlist p
	LEFT JOIN dbo.PlaylistTrack pt ON pt.PlaylistId = p.PlaylistId
	LEFT JOIN dbo.Track t ON pt.TrackId = t.TrackId
	GROUP BY p.PlaylistId, p.Name
	ORDER BY p.PlaylistId ASC;


-- Listar las playlist (sin repetir ninguna) que tienen alguna canción de AC/DC.  *[Solución: 1 playlist (Music)]*

	SELECT DISTINCT(p.Name)
	FROM dbo.Playlist p
	JOIN dbo.PlaylistTrack pt ON pt.PlaylistId = p.PlaylistId
	JOIN dbo.Track t ON pt.TrackId = t.TrackId
	WHERE t.Composer = 'AC/DC';
	

-- Listar las playlist que tienen alguna canción del artista Queen, junto con la cantidad que tienen.  *[Solución: 2 playlists]*

	SELECT DISTINCT (p.Name) "Nombre Playlist", COUNT(t.TrackId) "Nº de pistas de Queen" -- Habrá canciones que se repitan entre playlists
	FROM dbo.Playlist p
	JOIN dbo.PlaylistTrack pt ON pt.PlaylistId = p.PlaylistId
	JOIN dbo.Track t ON pt.TrackId = t.TrackId
	GROUP BY p.PlaylistId, p.Name, t.Composer
	HAVING t.Composer = 'Queen';


-- Listar las pistas que no están en ninguna playlist.  *[Solución: 0 pistas]*

	SELECT Q.TrackId, Q.Name
	FROM
	(
		SELECT  DISTINCT (t.TrackId), t.Name
		FROM dbo.Track t
		JOIN dbo.PlaylistTrack pt ON t.TrackId = pt.TrackId
		JOIN dbo.Playlist p ON p.PlaylistId = pt.PlaylistId
	) as Q
	WHERE Q.TrackId IS NULL;

	-- Otra forma de hacerlo:

	SELECT t.TrackId, t.Name
	FROM dbo.Track t
	WHERE NOT EXISTS
	(
		SELECT  DISTINCT (t.TrackId), t.Name
		FROM dbo.Track t
		JOIN dbo.PlaylistTrack pt ON t.TrackId = pt.TrackId
		JOIN dbo.Playlist p ON p.PlaylistId = pt.PlaylistId
	);
	
	-- Otra forma de hacerlo:

	SELECT t.TrackId, t.Name
	FROM dbo.Track t
	WHERE t.TrackId NOT IN
	(
		SELECT  DISTINCT (t.TrackId)
		FROM dbo.Track t
		JOIN dbo.PlaylistTrack pt ON t.TrackId = pt.TrackId
		JOIN dbo.Playlist p ON p.PlaylistId = pt.PlaylistId
	);


-- Listar los artistas que no tienen album.  *[Solución: 71 artistas]*

	SELECT ar.ArtistId, ar.Name
	FROM dbo.Artist ar
	WHERE ar.ArtistId NOT IN
	(
		SELECT DISTINCT(ar.ArtistId)
		FROM dbo.Artist ar
		JOIN dbo.Album al ON al.ArtistId = ar.ArtistId
	); 


-- Listar los artistas con el número de albums que tienen.  *[Solución: 275 artistas (71 de ellos sin album)]*

	SELECT DISTINCT(ar.ArtistId), ar.Name , COUNT(al.AlbumId) "Nº de albums"
	FROM dbo.Artist ar
	LEFT JOIN dbo.Album al ON al.ArtistId = ar.ArtistId
	GROUP BY ar.ArtistId, ar.Name

