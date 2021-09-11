#Populate Genre
UPDATE spotify_dataset_cleaned a
JOIN spotify_dataset_cleaned b ON a.Artist = b.Artist
SET a.Genre = b.Genre
WHERE a.Genre="[]" AND a.Genre != b.Genre;

#Manually input Genre
UPDATE
	spotify_dataset_cleaned
SET
	Genre = "pop"
WHERE
	Artist = "The Beach Boys";
    
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

#Update table with new Genres
UPDATE
	spotify_dataset_cleaned a
JOIN
	temp_table t ON a.Genre=t.Genre
SET 
	a.Genre=t.Grouped_genre
WHERE
	a.Genre != t.Grouped_genre;
    
SELECT 
	*
FROM spotify_dataset_cleaned