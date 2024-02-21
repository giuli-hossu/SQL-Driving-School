--  Q02_UDFs.sql
-- script pentru crearea functiilor utilizator
use Scoala_de_soferi
-- Creare functii utilizator

--*********************************************************************************************
--  Verifică dacă există deja o funcție cu numele respectiv
IF OBJECT_ID('dbo.ValidareDataNasterii', 'FN') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.ValidareDataNasterii;
END

-- cod SQL de creare a functiiei de validare a datei de nastere
CREATE FUNCTION dbo.ValidareDataNasterii (@DataNasterii date)
RETURNS bit
AS
BEGIN
    DECLARE @IsValid bit

    IF (@DataNasterii <= GETDATE() AND DATEDIFF(YEAR, @DataNasterii, GETDATE()) >= 18)
        SET @IsValid = 1; -- Data este valida
    ELSE
        SET @IsValid = 0; -- Data nu este valida

    RETURN @IsValid;
END;
--*********************************************************************************************
--  Verifică dacă există deja o funcție cu numele respectiv
IF OBJECT_ID('dbo.StabilireValoareImplicitaAdresa', 'FN') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.StabilireValoareImplicitaAdresa;
END

-- cod SQL de creare a functiiei de setare implicita a adresei
CREATE FUNCTION dbo.StabilireValoareImplicitaAdresa ()
RETURNS varchar(50)
AS
BEGIN
    DECLARE @Adresa varchar(50)
    
    SET @Adresa = 'Necunoscuta'

    RETURN @Adresa;
END;

--*********************************************************************************************
--  Verifică dacă există deja o funcție cu numele respectiv
IF OBJECT_ID('dbo.ObtineDetaliiElevInstructor', 'FN') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.ObtineDetaliiElevInstructor;
END

-- Functie in-line pentru obtinerea datelor necesare interogarii
CREATE FUNCTION dbo.ObtineDetaliiElevInstructor (@ID_Elev int, @ID_Instructor int)
RETURNS TABLE
AS
RETURN (
    SELECT E.Nume AS NumeElev, E.Prenume AS PrenumeElev, I.Nume AS NumeInstructor, I.Prenume AS PrenumeInstructor
    FROM ELEV E
    INNER JOIN SEDINTA_PRACTICA SP ON E.ID_elev = SP.ID_elev
    INNER JOIN INSTRUCTOR I ON SP.ID_instructor = I.ID_instructor
    WHERE E.ID_elev = @ID_Elev AND I.ID_instructor = @ID_Instructor
);

--*********************************************************************************************
--  Verifică dacă există deja o funcție cu numele respectiv
IF OBJECT_ID('dbo.CalculeazaOreRamaseInline', 'FN') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.CalculeazaOreRamaseInline;
END
-- Functie 
CREATE FUNCTION dbo.CalculeazaOreRamaseInline
(
    @IdElev INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        E.Nume,
        E.Prenume,
        IIF(SUM(SP.Durata) < 30, 30 - SUM(SP.Durata), 0) AS OreRamase
    FROM
        dbo.ELEV E
        JOIN dbo.SEDINTA_PRACTICA SP ON E.ID_elev = SP.ID_elev
    WHERE
        E.ID_elev = @IdElev
    GROUP BY
        E.Nume, E.Prenume
);


--*********************************************************************************************
--  Verifică dacă există deja o funcție cu numele respectiv
IF OBJECT_ID('dbo.ObtineInfoSedintePractica', 'FN') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.ObtineInfoSedintePractica;
END

-- Functie in-line
CREATE FUNCTION dbo.ObtineInfoSedintePractica
(
    @IdElev INT,
    @IdInstructor INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        SP.ID_sedinta,
        SP.Data_sedinta,
        SP.Durata,
        I.Nume AS NumeInstructor,
        I.Prenume AS PrenumeInstructor,
        V.Nr_inmatriculare
    FROM
        dbo.SEDINTA_PRACTICA SP
        JOIN dbo.INSTRUCTOR I ON SP.ID_instructor = I.ID_instructor
        JOIN dbo.VEHICUL V ON I.ID_vehicul = V.ID_vehicul
    WHERE
        SP.ID_elev = @IdElev
        AND SP.ID_instructor = @IdInstructor
);
--*********************************************************************************************
--  Verifică dacă există deja o funcție cu numele respectiv
IF OBJECT_ID('dbo.ObtineInfoPlatiElev', 'FN') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.ObtineInfoPlatiElev;
END

-- Functie in-line
CREATE FUNCTION dbo.ObtineInfoPlatiElev
(
    @IdElev INT,
    @SumaMinima INT,
    @DataInceput DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.ID_plata,
        P.Suma,
        P.Data_plata,
        E.Nume AS NumeElev,
        E.Prenume AS PrenumeElev
    FROM
        dbo.PLATA P
        JOIN dbo.ELEV E ON P.ID_elev = E.ID_elev
    WHERE
        E.ID_elev = @IdElev
        AND P.Suma >= @SumaMinima
        AND E.Data_inscrierii <= @DataInceput
);

--*********************************************************************************************
--  Verifică dacă există deja o funcție cu numele respectiv
IF OBJECT_ID('dbo.CalculateAgeInline', 'FN') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.CalculateAgeInline;
END

CREATE FUNCTION dbo.CalculateAgeInline (@DataNasterii date)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @DataNasterii, GETDATE());
END;

--*********************************************************************************************
-- Testare functii

-- Exemplu de validare a campului Data_nasterii
DECLARE @DataNasteriiExemplu date = '2000-01-01';
IF dbo.ValidareDataNasterii(@DataNasteriiExemplu) = 1
    PRINT 'Data de nastere este valida.';
ELSE
    PRINT 'Data de nastere NU este valida.';

-- Exemplu de stabilire a valorii implicite pentru Adresa
DECLARE @AdresaExemplu varchar(50);
SET @AdresaExemplu = dbo.StabilireValoareImplicitaAdresa();
PRINT 'Valoare implicita pentru Adresa: ' + @AdresaExemplu;

-- Exemplu de utilizare a functiei in-line pentru obtinerea datelor necesare interogarii
DECLARE @ID_ElevExemplu int = 1;
DECLARE @ID_InstructorExemplu int = 1;
SELECT * FROM dbo.ObtineDetaliiElevInstructor(@ID_ElevExemplu, @ID_InstructorExemplu);

--Exemplu pentru calculul orelor
SELECT * FROM dbo.CalculeazaOreRamaseInline(1);

-- Apelul functiei pentru a obtine informatii despre sedintele de practica
SELECT *
FROM dbo.ObtineInfoSedintePractica(1, 1);

--Apelul functiei
-- Declarați variabilele necesare pentru parametri
DECLARE @IdElev INT = 1;
DECLARE @SumaMinima INT = 50;
DECLARE @DataInceput DATE = '2022-01-01';

-- Afișați rezultatele funcției direct într-o interogare SELECT
SELECT *
FROM dbo.ObtineInfoPlatiElev(@IdElev, @SumaMinima, @DataInceput);
