CREATE DATABASE IF NOT EXISTS film;

USE film;

-- Tabella Attore
CREATE TABLE Attore (
    idA INT PRIMARY KEY,  -- Identificativo univoco per ogni attore
    nominativo VARCHAR(255) NOT NULL -- Nome dell'attore
);

-- Tabella Film
CREATE TABLE Film (
    codF INT PRIMARY KEY,  -- Codice univoco del film
    titolo VARCHAR(255) NOT NULL, -- Titolo del film
    anno INT -- Anno di uscita del film
);

-- Tabella Recita (relazione tra Attore e Film)
CREATE TABLE Recita (
    idA INT,  -- Chiave esterna che fa riferimento alla tabella Attore
    codF INT, -- Chiave esterna che fa riferimento alla tabella Film
    PRIMARY KEY (idA, codF),  -- Chiave primaria composta
    FOREIGN KEY (idA) REFERENCES Attore(idA) ON DELETE CASCADE,  -- Vincolo di integrità referenziale
    FOREIGN KEY (codF) REFERENCES Film(codF) ON DELETE CASCADE  -- Vincolo di integrità referenziale
);

-- Tabella Utente
CREATE TABLE Utente (
    email VARCHAR(255) PRIMARY KEY,  -- Indirizzo email univoco per l'utente
    password VARCHAR(255) NOT NULL,  -- Password dell'utente
    nominativo VARCHAR(255),  -- Nome completo dell'utente
    dataN DATE -- Data di nascita dell'utente
);

-- Tabella Giudica (relazione tra Utente e Film)
CREATE TABLE Giudica (
    email VARCHAR(255),  -- Chiave esterna che fa riferimento alla tabella Utente
    codF INT,  -- Chiave esterna che fa riferimento alla tabella Film
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Data e ora del giudizio
    giudizio INT CHECK (giudizio IN (0, 1, 2, 3, 4, 5)),  -- Vincolo sul dominio del giudizio
    PRIMARY KEY (email, codF),  -- Chiave primaria composta
    FOREIGN KEY (email) REFERENCES Utente(email) ON DELETE CASCADE,  -- Vincolo di integrità referenziale
    FOREIGN KEY (codF) REFERENCES Film(codF) ON DELETE CASCADE  -- Vincolo di integrità referenziale
);

-- Inserimento dati nella tabella Attore
INSERT INTO Attore (idA, nominativo) VALUES
(1, 'Leonardo DiCaprio'),
(2, 'Kate Winslet'),
(3, 'Brad Pitt'),
(4, 'Morgan Freeman'),
(5, 'Angelina Jolie');

-- Inserimento dati nella tabella Film
INSERT INTO Film (codF, titolo, anno) VALUES
(1, 'Titanic', 1997),
(2, 'Inception', 2010),
(3, 'Fight Club', 1999),
(4, 'The Shawshank Redemption', 1994),
(5, 'Mr. & Mrs. Smith', 2005);

-- Inserimento dati nella tabella Recita (relazione tra Attore e Film)
INSERT INTO Recita (idA, codF) VALUES
(1, 1),  -- Leonardo DiCaprio ha recitato in Titanic
(2, 1),  -- Kate Winslet ha recitato in Titanic
(1, 2),  -- Leonardo DiCaprio ha recitato in Inception
(3, 3),  -- Brad Pitt ha recitato in Fight Club
(4, 4),  -- Morgan Freeman ha recitato in The Shawshank Redemption
(5, 5),  -- Angelina Jolie ha recitato in Mr. & Mrs. Smith
(3, 5);  -- Brad Pitt ha recitato in Mr. & Mrs. Smith

-- Inserimento dati nella tabella Utente
INSERT INTO Utente (email, password, nominativo, dataN) VALUES
('utente1@example.com', 'password123', 'Mario Rossi', '1990-05-15'),
('utente2@example.com', 'password456', 'Luigi Bianchi', '1985-10-22'),
('utente3@example.com', 'password789', 'Giulia Verdi', '1992-07-08'),
('utente4@example.com', 'password789', 'Giuseppe Bianchi', '1994-07-08');

-- Inserimento dati nella tabella Giudica (relazione tra Utente e Film)
-- Inserimento dati aggiuntivi nella tabella Giudica
-- Mario Rossi (utente1@example.com) giudica tutti i film
INSERT INTO Giudica (email, codF, timestamp, giudizio) VALUES
('utente1@example.com', 1, '2023-10-01 14:23:45', 5),  -- Titanic
('utente1@example.com', 2, '2023-10-02 09:17:30', 4),  -- Inception
('utente1@example.com', 3, '2023-10-03 10:00:00', 3),  -- Fight Club
('utente1@example.com', 4, '2023-10-03 11:00:00', 5),  -- The Shawshank Redemption
('utente1@example.com', 5, '2023-10-04 12:00:00', 2);  -- Mr. & Mrs. Smith

-- Luigi Bianchi (utente2@example.com) giudica tutti i film
INSERT INTO Giudica (email, codF, timestamp, giudizio) VALUES
('utente2@example.com', 1, '2023-10-02 15:30:00', 4),  -- Titanic
('utente2@example.com', 2, '2023-10-02 16:00:00', 5),  -- Inception
('utente2@example.com', 3, '2023-10-03 11:45:00', 5),  -- Fight Club
('utente2@example.com', 4, '2023-10-03 12:30:25', 4),  -- The Shawshank Redemption
('utente2@example.com', 5, '2023-10-04 13:15:45', 3);  -- Mr. & Mrs. Smith

-- Giulia Verdi (utente3@example.com) giudica tutti i film
INSERT INTO Giudica (email, codF, timestamp, giudizio) VALUES
('utente3@example.com', 1, '2023-10-03 10:15:00', 3),  -- Titanic
('utente3@example.com', 2, '2023-10-03 10:45:00', 4),  -- Inception
('utente3@example.com', 3, '2023-10-03 11:00:00', 2),  -- Fight Club
('utente3@example.com', 4, '2023-10-03 11:15:00', 5),  -- The Shawshank Redemption
('utente3@example.com', 5, '2023-10-04 16:10:15', 3);  -- Mr. & Mrs. Smith

SELECT * 
FROM Film
WHERE anno > 1999;

SELECT f.titolo
FROM Film f
JOIN Recita r ON f.codF = r.codF
JOIN Attore a ON r.idA = a.idA
WHERE a.nominativo = 'Brad Pitt';

SELECT u.email, u.nominativo
FROM Utente u
LEFT JOIN Giudica g ON u.email = g.email
WHERE g.email IS NULL;

CREATE VIEW giudizio_medio AS
SELECT u.nominativo, AVG(g.giudizio) AS giudizio_medio
FROM Utente u
JOIN Giudica g ON u.email = g.email
GROUP BY u.nominativo;

SELECT nominativo, giudizio_medio
FROM giudizio_medio
ORDER BY giudizio_medio DESC
LIMIT 1;




