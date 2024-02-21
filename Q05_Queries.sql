-- Q05_Queries.sql
use Scoala_de_soferi


--*********************************************************************************************
--o in 2 (doua) interogari se vor folosi functiile inline

--Pentru funcția dbo.ObtineInfoSedintePractica:

--Interogarea 1: Afișați detaliile ședințelor practice ale elevului cu ID-ul 1, care au fost conduse de instructorul cu ID-ul 1. 
SELECT *
FROM dbo.ObtineInfoSedintePractica(1, 1);

--Pentru funcția dbo.ObtineInfoPlati:

--Interogarea 2: Afișați detaliile plăților efectuate de către elevul cu ID-ul 1, unde suma plătită este mai mare sau egală cu 0 pornind de la o data anume.
SELECT *
FROM dbo.ObtineInfoPlatiElev(1, 0, '2022/01/05');


--*********************************************************************************************
--o in 2 (doua) interogari se vor folosi vederile 
-- Interogarea 3: Afișați rezultatele evaluărilor pentru fiecare elev.
SELECT *
FROM VedereRezultateEvaluari;

-- Interogarea 4: Obțineți informații consolidate despre elevi, ședințele practice și instructori.
SELECT *
FROM VW_InterogareFinala1;

--*********************************************************************************************
--o 4 (patru) dintre interogari vor implica cel putin 3 (trei) tabele fiecare si vor folosi obligatoriu functii de 
--agregare si gruparea datelor

-- Interogarea 5: Afișați numărul total de ore efectuate de fiecare elev în ședințele practice, suma plătită de fiecare elev și numărul de instructori cu care a lucrat fiecare elev
SELECT
    E.Nume AS NumeElev,
    E.Prenume AS PrenumeElev,
    SUM(SP.Durata) AS TotalOreEfectuate,
    SUM(PL.Suma) AS TotalPlati,
    COUNT(DISTINCT SP.ID_instructor) AS NumarInstructori
FROM
    ELEV E
    LEFT JOIN SEDINTA_PRACTICA SP ON E.ID_elev = SP.ID_elev
    LEFT JOIN PLATA PL ON E.ID_elev = PL.ID_elev
GROUP BY
    E.ID_elev, E.Nume, E.Prenume;

-- Interogarea 6: Afișați categoria de vehicul, numărul total de ore efectuate și media rezultatelor teoretice pentru fiecare categorie de vehicul
SELECT
    I.Categorie AS CategorieVehicul,
    SUM(SP.Durata) AS TotalOreEfectuate,
    AVG(EV.Rezultat_teorie) AS MedieTeorie
FROM
    INSTRUCTOR I
    LEFT JOIN SEDINTA_PRACTICA SP ON I.ID_instructor = SP.ID_instructor
    LEFT JOIN EVALUARE EV ON SP.ID_elev = EV.ID_elev
GROUP BY
    I.Categorie;

-- Interogarea 7: Afișați media de ore efectuate la ședințele practice pentru fiecare instructor, pentru cei care au avut ședințe practice.
SELECT
    I.Nume AS NumeInstructor,
    I.Prenume AS PrenumeInstructor,
    AVG(SP.Durata) AS MedieOreSedinta
FROM
    INSTRUCTOR I
    INNER JOIN SEDINTA_PRACTICA SP ON I.ID_instructor = SP.ID_instructor
GROUP BY
    I.ID_instructor, I.Nume, I.Prenume;

-- Interogarea 8: Obțineți numărul total de ore efectuate de fiecare elev, suma plătită de fiecare elev și data celei mai recente ședințe practice pentru fiecare elev.
WITH TotalOre AS (
    SELECT
        E.ID_elev,
        E.Nume AS NumeElev,
        E.Prenume AS PrenumeElev,
        SUM(SP.Durata) AS TotalOreEfectuate,
        MAX(SP.Data_sedinta) AS UltimaSedintaPractica
    FROM
        ELEV E
        LEFT JOIN SEDINTA_PRACTICA SP ON E.ID_elev = SP.ID_elev
    GROUP BY
        E.ID_elev, E.Nume, E.Prenume
)
SELECT
    TOA.ID_elev,
    TOA.NumeElev,
    TOA.PrenumeElev,
    TOA.TotalOreEfectuate,
    SUM(PL.Suma) AS TotalPlati,
    TOA.UltimaSedintaPractica
FROM
    TotalOre TOA
LEFT JOIN
    PLATA PL ON TOA.ID_elev = PL.ID_elev
GROUP BY
    TOA.ID_elev, TOA.NumeElev, TOA.PrenumeElev, TOA.TotalOreEfectuate, TOA.UltimaSedintaPractica;


--*********************************************************************************************
-- Alte interogari

-- Interogare 9: Selectează toate datele pentru un student specific.
SELECT *
FROM ELEV
WHERE Nume = 'Popescu' AND Prenume = 'Ion';

-- Interogare 10: Listează durata totală a sesiunilor practice pentru fiecare elev.
SELECT
    E.ID_elev,
    E.Nume,
    E.Prenume,
    SUM(SP.Durata) AS DurataTotala
FROM ELEV E
JOIN SEDINTA_PRACTICA SP ON E.ID_elev = SP.ID_elev
GROUP BY E.ID_elev, E.Nume, E.Prenume;

-- Interogare 11: Obține vârsta fiecărui elev.
SELECT
    Nume,
    Prenume,
    dbo.CalculateAgeInline(Data_nasterii) AS Varsta
FROM ELEV;


-- Interogare 12: Afiseaza cel mai mare rezultat la teorie pentru fiecare categorie
SELECT
    E.Categorie,
    MAX(EV.Rezultat_teorie) AS MaxTeorie
FROM ELEV E
JOIN EVALUARE EV ON E.ID_elev = EV.ID_elev
GROUP BY E.Categorie;

-- Interogare 13: Numărul de elevi în fiecare categorie
SELECT
    Categorie,
    COUNT(ID_elev) AS Numar_Elevi
FROM ELEV
GROUP BY
    Categorie;

