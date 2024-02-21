-- Q04_Views.sql
use Scoala_de_soferi
-- Creare vederi

-- Vederea 1: Pregatirea datelor pentru interogarea finala

CREATE VIEW VW_InterogareFinala1
AS
SELECT
    E.ID_elev,
    E.Nume AS NumeElev,
    E.Prenume AS PrenumeElev,
    I.Nume AS NumeInstructor,
    I.Prenume AS PrenumeInstructor,
    SP.Data_sedinta,
    SP.Durata
FROM
    ELEV E
    INNER JOIN SEDINTA_PRACTICA SP ON E.ID_elev = SP.ID_elev
    INNER JOIN INSTRUCTOR I ON SP.ID_instructor = I.ID_instructor;

-- Vederea 2: Pregatirea datelor pentru alta interogare finala

CREATE VIEW VW_InterogareFinala2
AS
SELECT
    E.ID_elev,
    E.Nume AS NumeElev,
    E.Prenume AS PrenumeElev,
    V.Nr_inmatriculare,
    P.Suma
FROM
    ELEV E
    INNER JOIN PLATA P ON E.ID_elev = P.ID_elev
    INNER JOIN VEHICUL V ON E.ID_elev = V.ID_vehicul;


-- Creare vedere pentru rezultatele evaluărilor pentru fiecare elev
CREATE VIEW VedereRezultateEvaluari AS
SELECT
    E.Nume AS Nume_Elev,
    E.Prenume AS Prenume_Elev,
    EV.Data_teorie,
    EV.Rezultat_teorie,
    EV.Data_practica,
    EV.Rezultat_practica,
    EV.Rezultat_final
FROM
    ELEV E
JOIN
    EVALUARE EV ON E.ID_elev = EV.ID_elev;

-- Exemplu de utilizare al vederilor create

-- Selectarea datelor din Vederea 1
SELECT * FROM VW_InterogareFinala1;

-- Selectarea datelor din Vederea 2
SELECT * FROM VW_InterogareFinala2;

-- Selectarea datelor din Vederea 3
SELECT * FROM VedereRezultateEvaluari;
