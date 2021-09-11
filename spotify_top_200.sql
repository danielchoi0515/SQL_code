
#SQL queries used to clean and aggregate data
#Syntax Used: UPDATE, ALTER, DELETE, GROUP BY, JOIN, UPDATE with JOIN, CTE


------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Drop unused column 

ALTER TABLE 
	spotify_dataset_cleaned
DROP 
	COLUMN SONG_ID;

------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Check for duplicates

WITH temp_table AS(
	SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY Song, Artist) AS duplicate_check
	FROM
		spotify_dataset_cleaned
)

SELECT 
	*
FROM
	temp_table
WHERE
	duplicate_check = 2;


#Remove the duplicate row

DELETE FROM 
	spotify_dataset_cleaned
WHERE
	Song="Goodbyes (Feat. Young Thug)" AND Highest_Charting_Position = 54 AND Number_of_Times_Charted = 22;
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Populate Genres that are missing

UPDATE 
	spotify_dataset_cleaned a
JOIN spotify_dataset_cleaned b ON a.Artist = b.Artist
SET 
	a.Genre = b.Genre
WHERE 
	a.Genre="[]" AND a.Genre != b.Genre;

------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Manually input Genre

UPDATE
	spotify_dataset_cleaned
SET
	Genre = "pop"
WHERE
	Artist = "The Beach Boys";
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Make genres consistent

WITH temp_table AS(
	SELECT
		Genre,
		CASE
			WHEN Genre LIKE "%pop%" THEN "pop"
			WHEN Genre LIKE "%hip hop%" THEN "hip hop"
			WHEN Genre LIKE "%rap%" THEN "rap"
			WHEN Genre LIKE "%trap%" THEN "trap"
			WHEN Genre LIKE "%dance%" THEN "dance"
			WHEN Genre LIKE "%brooklyn drill%" THEN "trap"
			WHEN Genre LIKE "%Reggaeton%" THEN "trap"
			WHEN Genre LIKE "%funk%" THEN "funk"
            		WHEN Genre LIKE "%rock%" THEN "rock"
		        WHEN Genre LIKE "%vision%" THEN "vision"
	            	WHEN Genre LIKE "%forro%" THEN "forro"
            		WHEN Genre LIKE "%country%" THEN "country"
            		WHEN Genre LIKE "%r&b%" THEN "r&b"
            		WHEN Genre LIKE "%jazz%" THEN "jazz"
            		WHEN Genre LIKE "%comic%" THEN "comic"
            		WHEN Genre LIKE "%house%" THEN "house"
            		WHEN Genre LIKE "%urbano%" THEN "dance"
            		WHEN Genre LIKE "%aus%" THEN "dance"
            		WHEN Genre LIKE "%adult%" THEN "jazz"
            		WHEN Genre LIKE "%dream%" THEN "dance"
            		WHEN Genre LIKE "%soundtrack%" THEN "soundrack"
            		WHEN Genre LIKE "%sertanejo%" THEN "dance"
            		WHEN Genre LIKE "%piseiro%" THEN "dance"
            		WHEN Genre LIKE "%francoton%" THEN "dance"
            		WHEN Genre LIKE "%regional%" THEN "dance"
            		WHEN Genre LIKE "%soul%" THEN "r&b"
            		WHEN Genre LIKE "%folk%" THEN "dance"
            		WHEN Genre LIKE "%weirdcor%" THEN "dance"
            		WHEN Genre LIKE "%show%" THEN "dance"
            		WHEN Genre LIKE "%awaii%" THEN "dance"
            		WHEN Genre LIKE "%cap%" THEN "dance"
            		WHEN Genre LIKE "%musical%" THEN "other"
		END AS Grouped_genre
	FROM
		spotify_dataset_cleaned
)

------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Update table with new Genres

UPDATE
	spotify_dataset_cleaned a
JOIN
	temp_table t ON a.Genre=t.Genre
SET 
	a.Genre=t.Grouped_genre
WHERE
	a.Genre != t.Grouped_genre;
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------	

#Average number of streams for highest chart rated

SELECT
	Highest_Charting_Position, ROUND(AVG(Streams),0) AS number_of_streams
FROM
	spotify_dataset_cleaned
GROUP BY
	Highest_Charting_Position 
ORDER BY
	Highest_Charting_Position;
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------	

#Genres and avg popularity

SELECT
	Genre, ROUND(AVG(Popularity),0)
FROM
	spotify_dataset_cleaned
GROUP BY
	Genre;
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
#Week that had the most streams for each genre

WITH temp_table AS(
	SELECT 
		Genre, Week_of_Highest_Charting, MAX(Streams) AS streams,
        	ROW_NUMBER() OVER(PARTITION BY Genre ORDER BY MAX(Streams) DESC) AS ranking
	FROM
		spotify_dataset_cleaned
	GROUP BY
		Genre, Week_of_Highest_Charting
 )
 
SELECT
	Genre, Week_of_Highest_Charting, streams
FROM
	temp_table
WHERE
	ranking = 1
ORDER BY
	Week_of_Highest_Charting

------------------------------------------------------------------------------------------------------------------------------------------------------------------
