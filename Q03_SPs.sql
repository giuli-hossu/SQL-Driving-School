-- Q03_SPs.sql
use Scoala_de_soferi
-- Creare proceduri stocate


-- Procedura pentru inserarea datelor in tabela ELEV
IF OBJECT_ID('dbo.InserareElev', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.InserareElev;
END


CREATE PROCEDURE dbo.InserareElev
    @Nume varchar(50),
    @Prenume varchar(50),
    @DataNasterii date,
    @DataInscrierii date,
    @Adresa varchar(50) = NULL,
    @Categorie varchar(1)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TransactionCount int = @@TRANCOUNT;

    BEGIN TRY
        IF @TransactionCount = 0
            BEGIN TRANSACTION;

        -- Validare Categorie
        IF NOT EXISTS (SELECT 1 FROM ELEV WHERE Categorie = @Categorie)
        BEGIN
            THROW 50000, 'Categorie invalida.', 1;
            RETURN;
        END;

        -- Validare si inserare Adresa
        IF @Adresa IS NULL
            SET @Adresa = dbo.StabilireValoareImplicitaAdresa();

        -- Validare DataNasterii
        IF dbo.ValidareDataNasterii(@DataNasterii) = 0
        BEGIN
            THROW 50000, 'Data de nastere invalida.', 1;
            RETURN;
        END;

        -- Inserare in tabela ELEV
        INSERT INTO ELEV (Nume, Prenume, Data_nasterii, Data_inscrierii, Adresa, Categorie)
        VALUES (@Nume, @Prenume, @DataNasterii, @DataInscrierii, @Adresa, @Categorie);

        IF @TransactionCount = 0
            COMMIT;
    END TRY
    BEGIN CATCH
        IF @TransactionCount = 0 AND XACT_STATE() <> -1
            ROLLBACK;

        THROW;
    END CATCH;
END;

-- Procedura pentru actualizarea datelor in tabela ELEV
IF OBJECT_ID('dbo.ActualizareElev', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.ActualizareElev;
END

CREATE PROCEDURE dbo.ActualizareElev
    @ID_elev int,
    @Nume varchar(50),
    @Prenume varchar(50),
    @DataNasterii date,
    @DataInscrierii date,
    @Adresa varchar(50) = NULL,
    @Categorie varchar(1)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TransactionCount int = @@TRANCOUNT;

    BEGIN TRY
        IF @TransactionCount = 0
            BEGIN TRANSACTION;

        -- Validare existenta ID_elev
        IF NOT EXISTS (SELECT 1 FROM ELEV WHERE ID_elev = @ID_elev)
        BEGIN
            THROW 50000, 'ID_elev inexistent.', 1;
            RETURN;
        END;

        -- Validare Categorie
        IF NOT EXISTS (SELECT 1 FROM ELEV WHERE Categorie = @Categorie)
        BEGIN
            THROW 50000, 'Categorie invalida.', 1;
            RETURN;
        END;

        -- Validare si actualizare Adresa
        IF @Adresa IS NULL
            SET @Adresa = dbo.StabilireValoareImplicitaAdresa();

        -- Validare DataNasterii
        IF dbo.ValidareDataNasterii(@DataNasterii) = 0
        BEGIN
            THROW 50000, 'Data de nastere invalida.', 1;
            RETURN;
        END;

        -- Actualizare in tabela ELEV
        UPDATE ELEV
        SET 
            Nume = @Nume,
            Prenume = @Prenume,
            Data_nasterii = @DataNasterii,
            Data_inscrierii = @DataInscrierii,
            Adresa = @Adresa,
            Categorie = @Categorie
        WHERE ID_elev = @ID_elev;

        IF @TransactionCount = 0
            COMMIT;
    END TRY
    BEGIN CATCH
        IF @TransactionCount = 0 AND XACT_STATE() <> -1
            ROLLBACK;

        THROW;
    END CATCH;
END;


