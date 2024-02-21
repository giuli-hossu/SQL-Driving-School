--				Q01_Tables.sql
--un script pentru crearea bazei de date si a tabelelor 
--(cel putin 2 constrangeri de verificare si 2 constrangeri de valoare implicita), 
-- a constrangerilor la nivel de tabele (chei straine) si pentru popularea initiala cu date 
--(date suficiente pentru ca interogarile finale sa produca rezultate)


-- Creare baza de date
CREATE DATABASE Scoala_de_soferi

-- Selectie baza de date de lucru
USE Scoala_de_soferi

-- Creare tabela ELEV
CREATE TABLE ELEV (
    ID_elev int PRIMARY KEY IDENTITY,
    Nume varchar(50) NOT NULL,
    Prenume varchar(50) NOT NULL,
    Data_nasterii date,
    Data_inscrierii date,
    Adresa varchar(50) DEFAULT 'Necunoscuta',
    Categorie varchar(1) NOT NULL,
    CONSTRAINT CHK_Categorie CHECK (Categorie IN ('A', 'B', 'C', 'D')),
    CONSTRAINT CHK_DataNasterii CHECK (Data_nasterii <= GETDATE() AND DATEDIFF(YEAR, Data_nasterii, GETDATE()) >= 18),

);

CREATE TABLE INSTRUCTOR (
        ID_instructor int PRIMARY KEY IDENTITY,
        Nume varchar(50) NOT NULL,
		Prenume varchar(50) NOT NULL,
		ID_vehicul int NOT NULL,
		Categorie varchar(1) DEFAULT 'B',
		CONSTRAINT CHK_CategorieInstructor CHECK (Categorie IN ('A', 'B', 'C','D')),
)

CREATE TABLE VEHICUL(
		ID_vehicul int PRIMARY KEY IDENTITY,
		Nr_inmatriculare char(7),
)

CREATE TABLE PLATA(
		ID_plata int PRIMARY KEY IDENTITY,
		ID_elev  int NOT NULL,
		Suma int CHECK (Suma >= 0)
)
ALTER TABLE PLATA
ADD Data_plata DATE;

CREATE TABLE SEDINTA_PRACTICA(
		ID_sedinta int PRIMARY KEY IDENTITY,
		ID_elev  int NOT NULL,
		ID_instructor  int NOT NULL,
		Data_sedinta  date,
		Durata int NOT NULL
)

CREATE TABLE EVALUARE(
		ID_evaluare int PRIMARY KEY IDENTITY,
		ID_elev  int NOT NULL,
		Data_teorie date,
		Rezultat_teorie int CHECK (Rezultat_teorie > 0 AND Rezultat_teorie <= 26),
		Data_practica date,
		Rezultat_practica int CHECK (Rezultat_practica > 0),
		Rezultat_final AS CASE 
                        WHEN Rezultat_teorie IS NULL OR Rezultat_practica IS NULL THEN 'In desfasurare...'
                        WHEN (Rezultat_teorie > 22) AND (Rezultat_practica < 21) THEN 'Admis'
                        ELSE 'Respins'
                    END
)


-- Adaugare FOREIGN KEY 

ALTER TABLE PLATA
ADD CONSTRAINT FK_Plata_Elev FOREIGN KEY (ID_elev) REFERENCES ELEV(ID_elev);

ALTER TABLE SEDINTA_PRACTICA
ADD CONSTRAINT FK_SedintaPractica_Elev FOREIGN KEY (ID_elev) REFERENCES ELEV(ID_elev);

ALTER TABLE SEDINTA_PRACTICA
ADD CONSTRAINT FK_SedintaPractica_Instructor FOREIGN KEY (ID_instructor) REFERENCES INSTRUCTOR(ID_instructor);

ALTER TABLE INSTRUCTOR
ADD CONSTRAINT FK_Instructor_Vehicul FOREIGN KEY (ID_vehicul) REFERENCES VEHICUL(ID_vehicul);

ALTER TABLE EVALUARE
ADD CONSTRAINT FK_Evaluare_Elev FOREIGN KEY (ID_elev) REFERENCES ELEV(ID_elev);

-- Populare initiala cu date

-- Tabela ELEV
INSERT INTO ELEV (Nume, Prenume, Data_nasterii, Data_inscrierii, Adresa, Categorie)
VALUES 
    ('Popescu', 'Ion', '2000-01-01', '2022-01-01', 'Strada A', 'B'),
    ('Ionescu', 'Ana', '1998-05-15', '2022-02-01', 'Strada B', 'A'),
    ('Dumitru', 'Mihai', '2002-09-10', '2022-03-15', 'Strada C', 'C'),
	('Vasilescu', 'Elena', '2001-06-12', '2022-04-01', 'Strada D', 'B'),
    ('Radu', 'Alexandru', '1999-08-25', '2022-05-15', 'Strada E', 'A'),
    ('Constantin', 'Andreea', '2003-03-05', '2022-06-20', 'Strada F', 'C'),
    ('Gheorghe', 'Cristina', '2002-11-18', '2022-07-10', 'Strada G', 'B'),
    ('Iancu', 'Gabriel', '2000-04-08', '2022-08-15', 'Strada H', 'A'),
    ('Florescu', 'Ana-Maria', '1998-12-30', '2022-09-01', 'Strada I', 'D'),
    ('Muresan', 'Adrian', '2004-02-22', '2022-10-05', 'Strada J', 'C'),
    ('Ivanescu', 'Raluca', '2003-07-18', '2022-11-01', 'Strada K', 'B'),
    ('Stanciu', 'Daniel', '2001-10-30', '2022-12-15', 'Strada L', 'B'),
    ('Preda', 'Andrei', '1999-04-05', '2023-01-01', 'Strada M', 'B'),
    ('Diaconu', 'Diana', '2000-09-12', '2023-02-15', 'Strada N', 'D'),
    ('Nistor', 'Bogdan', '2004-05-28', '2023-03-01', 'Strada O', 'C'),
    ('Marin', 'Gabriela', '2002-03-20', '2023-04-15', 'Strada P', 'B'),
    ('Cristea', 'Marius', '1998-08-10', '2023-05-01', 'Strada Q', 'A'),
    ('Gavril', 'Eva', '2003-12-03', '2023-06-15', 'Strada R', 'C'),
    ('Petrescu', 'Robert', '2001-02-17', '2023-07-01', 'Strada S', 'A'),
    ('Stoica', 'Andreea', '1999-11-22', '2023-08-15', 'Strada T', 'B');


-- Tabela VEHICUL
INSERT INTO VEHICUL (Nr_inmatriculare)
VALUES 
    ('SM12AEI'),
    ('SM23AEI'),
    ('SM34AEI'),
	('SM45AEI');

-- Tabela INSTRUCTOR
INSERT INTO INSTRUCTOR (Nume, Prenume, ID_vehicul, Categorie)
VALUES 
    ('Popa', 'Maria', 1, 'B'),
    ('Georgescu', 'Adrian', 2, 'A'),
    ('Andrei', 'Ioana', 3, 'C'),
	('Moga', 'Simona', 4, 'D');
  
INSERT INTO INSTRUCTOR (Nume, Prenume, ID_vehicul, Categorie)
VALUES 
    ('Ionescu', 'Cristina', 1, 'B'),
    ('Marinescu', 'Dan', 2, 'A'),
    ('Dumitrache', 'Andrei', 3, 'C'),
    ('Stoica', 'Alexandru', 4, 'D');


-- Tabela PLATA
INSERT INTO PLATA (ID_elev, Suma, Data_plata)
VALUES 
    (1, 50, GETDATE()),
    (2, 75, GETDATE()),
    (3, 60, GETDATE()),
	(4, 1000,GETDATE()),
	(5, 350, GETDATE()),
	(6, 500, GETDATE()),
    (7, 750, GETDATE()),
    (8, 650, GETDATE()),
	(9, 500, GETDATE()),
	(1, 600,'2023-02-22' ),
	(10, 450, '2023-11-10'),
    (11, 300, '2023-11-11'),
    (12, 200, '2023-11-12'),
    (13, 900, '2023-11-13'),
    (14, 150, '2023-11-14'),
    (15, 800, '2023-11-15'),
    (16, 400, '2023-10-16'),
    (17, 550, '2023-12-17'),
    (18, 700, '2023-12-18'),
    (19, 250, '2023-12-19');




-- Tabela SEDINTA_PRACTICA
INSERT INTO SEDINTA_PRACTICA (ID_elev, ID_instructor, Data_sedinta, Durata)
VALUES 
    (1, 1, '2023-01-05', 2),
    (2, 2, '2023-02-10', 1),
    (3, 3, '2022-03-20', 3),
	(6, 3, '2022-06-25', 3),
    (7, 5, '2023-07-15', 2),
    (8, 2, '2023-08-20', 1),
    (9, 4, '2023-09-05', 3),
    (10, 7, '2023-10-10', 2),
	(7, 5, '2023-07-20', 2),
    (8, 2, '2023-08-22', 2),
    (9, 4, '2023-09-07', 2),
    (10, 7, '2023-10-12', 2),
	(1, 5, '2023-01-06', 1),
	(1, 1, '2023-01-05', 3),
	(2, 6, '2023-02-12', 2),
    (3, 7, '2022-03-25', 1),
    (4, 1, '2023-04-01', 2),
    (5, 6, '2023-05-10', 1),
    (6, 3, '2023-06-30', 3),
    (11, 5, '2023-11-05', 2),
    (12, 1, '2023-12-10', 2),
    (13, 1, '2024-01-15', 1),
    (14, 4, '2024-02-20', 3),
    (15, 3, '2024-03-25', 1);

--Verificare pentru asocierea buna a elevului cu instructorul
--	SELECT 
--    e.ID_elev, 
--    e.Categorie AS Categorie_Elev, 
--    i.Categorie AS Categorie_Instructor
--FROM 
--    SEDINTA_PRACTICA sp
--JOIN 
--    ELEV e ON sp.ID_elev = e.ID_elev
--JOIN 
--    INSTRUCTOR i ON sp.ID_instructor = i.ID_instructor;



-- Tabela EVALUARE
INSERT INTO EVALUARE (ID_elev, Data_teorie, Rezultat_teorie, Data_practica, Rezultat_practica)
VALUES 
    (1, '2023-01-15', 23, '2023-02-20', 18),
    (2, '2023-02-20', 25, '2023-03-25', 22),
    (3, '2023-03-30', 20, '2023-04-05', 15);
