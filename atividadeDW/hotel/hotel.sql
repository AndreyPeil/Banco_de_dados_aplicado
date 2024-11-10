
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    data_nascimento DATE,
    endereco VARCHAR(255),
    categoria_fidelidade VARCHAR(20),
    data_ultima_alteracao DATE
);

CREATE TABLE hotel (
    id_hotel SERIAL PRIMARY KEY,
    nome_hotel VARCHAR(100),
    cidade VARCHAR(100),
    pais VARCHAR(100),
    data_inauguracao DATE
);

CREATE TABLE quarto (
    id_quarto SERIAL PRIMARY KEY,
    id_hotel INT REFERENCES hotel(id_hotel),
    tipo_quarto VARCHAR(50),
    status_manutencao VARCHAR(50),
    data_ultima_reforma DATE
);

CREATE TABLE reserva (
    id_reserva SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES cliente(id_cliente),
    id_hotel INT REFERENCES hotel(id_hotel),
    id_quarto INT REFERENCES quarto(id_quarto),
    data_checkin DATE,
    data_checkout DATE,
    valor_total_reserva DECIMAL(10, 2)
);

CREATE TABLE receitas (
    id_hotel INT REFERENCES hotel(id_hotel),
    data DATE,
    receita_total_diaria DECIMAL(10, 2),
    despesas_operacionais_diarias DECIMAL(10, 2)
);

CREATE TABLE dim_cliente (
    id_cliente_sk SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    nome VARCHAR(100),
    data_nascimento DATE,
    endereco VARCHAR(255),
    categoria_fidelidade VARCHAR(20),
    data_inicio DATE,
    data_fim DATE,
    status_atual CHAR(1) DEFAULT 'A'
);

CREATE TABLE dim_hotel (
    id_hotel_sk SERIAL PRIMARY KEY,
    id_hotel INT NOT NULL,
    nome_hotel VARCHAR(100),
    cidade VARCHAR(100),
    pais VARCHAR(100),
    data_inauguracao DATE
);

CREATE TABLE dim_quarto (
    id_quarto_sk SERIAL PRIMARY KEY,
    id_quarto INT NOT NULL,
    id_hotel INT NOT NULL,
    tipo_quarto VARCHAR(50),
    status_manutencao VARCHAR(50),
    data_ultima_reforma DATE,
    data_inicio DATE,
    data_fim DATE,
    status_atual CHAR(1) DEFAULT 'A'
);

CREATE TABLE dim_tempo (
    id_tempo SERIAL PRIMARY KEY,
    data DATE,
    dia INT,
    mes INT,
    ano INT,
    trimestre INT
);

CREATE TABLE fato_reservas (
    id_reserva INT PRIMARY KEY,
    id_cliente_sk INT REFERENCES dim_cliente(id_cliente_sk),
    id_hotel_sk INT REFERENCES dim_hotel(id_hotel_sk),
    id_quarto_sk INT REFERENCES dim_quarto(id_quarto_sk),
    id_tempo INT REFERENCES dim_tempo(id_tempo),
    valor_total_reserva DECIMAL(10, 2),
    duracao_estada INT
);


INSERT INTO cliente (nome, data_nascimento, endereco, categoria_fidelidade, data_ultima_alteracao)
VALUES
('João Silva', '1985-06-15', 'Rua A, 123', 'Bronze', '2024-01-01'),
('Maria Oliveira', '1990-02-25', 'Av. B, 456', 'Ouro', '2024-02-01'),
('Pedro Costa', '1980-11-30', 'Rua C, 789', 'Prata', '2024-03-01'),
('Ana Santos', '1995-05-10', 'Rua D, 101', 'Platina', '2024-04-01');

-- Hotéis
INSERT INTO hotel (nome_hotel, cidade, pais, data_inauguracao)
VALUES
('Hotel Plus Rio', 'Rio de Janeiro', 'Brasil', '2000-12-15'),
('Hotel Plus São Paulo', 'São Paulo', 'Brasil', '2005-07-22'),
('Hotel Plus Paris', 'Paris', 'França', '2010-03-10'),
('Hotel Plus Nova York', 'Nova York', 'EUA', '2015-06-25');

INSERT INTO quarto (id_hotel, tipo_quarto, status_manutencao, data_ultima_reforma)
VALUES
(1, 'Standard', 'Disponível', '2023-05-15'),
(1, 'Luxo', 'Em manutenção', '2023-06-20'),
(2, 'Suíte', 'Disponível', '2023-07-10'),
(2, 'Standard', 'Disponível', '2023-08-01'),
(3, 'Suíte', 'Disponível', '2022-12-12'),
(4, 'Luxo', 'Em manutenção', '2023-09-05');

INSERT INTO reserva (id_cliente, id_hotel, id_quarto, data_checkin, data_checkout, valor_total_reserva)
VALUES
(1, 1, 1, '2024-06-10', '2024-06-15', 1500.00),
(2, 2, 3, '2024-07-01', '2024-07-05', 2000.00),
(3, 3, 5, '2024-08-20', '2024-08-25', 2500.00),
(4, 4, 6, '2024-09-10', '2024-09-15', 3000.00);

-- Receitas
INSERT INTO receitas (id_hotel, data, receita_total_diaria, despesas_operacionais_diarias)
VALUES
(1, '2024-06-10', 3000.00, 1000.00),
(1, '2024-06-11', 3200.00, 1100.00),
(2, '2024-07-01', 4000.00, 1500.00),
(2, '2024-07-02', 4500.00, 1600.00),
(3, '2024-08-20', 5000.00, 1800.00),
(4, '2024-09-10', 6000.00, 2000.00);

INSERT INTO dim_cliente (id_cliente, nome, data_nascimento, endereco, categoria_fidelidade, data_inicio, status_atual)
VALUES
(1, 'João Silva', '1985-06-15', 'Rua A, 123', 'Bronze', '2024-01-01', 'A'),
(2, 'Maria Oliveira', '1990-02-25', 'Av. B, 456', 'Ouro', '2024-02-01', 'A'),
(3, 'Pedro Costa', '1980-11-30', 'Rua C, 789', 'Prata', '2024-03-01', 'A'),
(4, 'Ana Santos', '1995-05-10', 'Rua D, 101', 'Platina', '2024-04-01', 'A');

-- Dim Hotel
INSERT INTO dim_hotel (id_hotel, nome_hotel, cidade, pais, data_inauguracao)
VALUES
(1, 'Hotel Plus Rio', 'Rio de Janeiro', 'Brasil', '2000-12-15'),
(2, 'Hotel Plus São Paulo', 'São Paulo', 'Brasil', '2005-07-22'),
(3, 'Hotel Plus Paris', 'Paris', 'França', '2010-03-10'),
(4, 'Hotel Plus Nova York', 'Nova York', 'EUA', '2015-06-25');

INSERT INTO dim_quarto (id_quarto, id_hotel, tipo_quarto, status_manutencao, data_ultima_reforma, data_inicio, status_atual)
VALUES
(1, 1, 'Standard', 'Disponível', '2023-05-15', '2023-05-15', 'A'),
(2, 1, 'Luxo', 'Em manutenção', '2023-06-20', '2023-06-20', 'A'),
(3, 2, 'Suíte', 'Disponível', '2023-07-10', '2023-07-10', 'A'),
(4, 2, 'Standard', 'Disponível', '2023-08-01', '2023-08-01', 'A'),
(5, 3, 'Suíte', 'Disponível', '2022-12-12', '2022-12-12', 'A'),
(6, 4, 'Luxo', 'Em manutenção', '2023-09-05', '2023-09-05', 'A');

INSERT INTO dim_tempo (data, dia, mes, ano, trimestre)
VALUES
('2024-06-10', 10, 6, 2024, 2),
('2024-06-11', 11, 6, 2024, 2),
('2024-07-01', 1, 7, 2024, 3),
('2024-07-02', 2, 7, 2024, 3),
('2024-08-20', 20, 8, 2024, 3),
('2024-09-10', 10, 9, 2024, 3);

INSERT INTO fato_reservas (id_reserva, id_cliente_sk, id_hotel_sk, id_quarto_sk, id_tempo, valor_total_reserva, duracao_estada)
VALUES
(1, 1, 1, 1, 1, 1500.00, 5),
(2, 2, 2, 3, 3, 2000.00, 4),
(3, 3, 3, 5, 5, 2500.00, 5),
(4, 4, 4, 6, 6, 3000.00, 5);


SELECT c.categoria_fidelidade, AVG(fr.valor_total_reserva) AS receita_media
FROM fato_reservas fr
JOIN dim_cliente c ON fr.id_cliente_sk = c.id_cliente_sk
GROUP BY c.categoria_fidelidade;

SELECT d.nome_hotel, 
       SUM(fr.duracao_estada) / (COUNT(DISTINCT q.id_quarto) * 100) AS taxa_ocupacao
FROM fato_reservas fr
JOIN dim_hotel d ON fr.id_hotel_sk = d.id_hotel_sk
JOIN dim_quarto q ON fr.id_quarto_sk = q.id_quarto_sk
JOIN dim_tempo t ON fr.id_tempo = t.id_tempo
WHERE t.ano = 2024 
GROUP BY d.nome_hotel
ORDER BY taxa_ocupacao DESC;

SELECT c.categoria_fidelidade, AVG(fr.duracao_estada) AS media_duracao
FROM fato_reservas fr
JOIN dim_cliente c ON fr.id_cliente_sk = c.id_cliente_sk
GROUP BY c.categoria_fidelidade;

SELECT q.id_quarto, q.tipo_quarto, COUNT(q.data_ultima_reforma) AS total_reformas
FROM dim_quarto q
WHERE q.status_atual = 'A'  
GROUP BY q.id_quarto, q.tipo_quarto
ORDER BY total_reformas DESC;

SELECT c.categoria_fidelidade, h.pais, SUM(fr.valor_total_reserva) AS gasto_total
FROM fato_reservas fr
JOIN dim_cliente c ON fr.id_cliente_sk = c.id_cliente_sk
JOIN dim_hotel h ON fr.id_hotel_sk = h.id_hotel_sk
GROUP BY c.categoria_fidelidade, h.pais
ORDER BY gasto_total DESC;

