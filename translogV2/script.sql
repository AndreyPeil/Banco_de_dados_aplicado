CREATE TABLE cliente_origem (
    id_cliente INT PRIMARY KEY,
    nome_cliente TEXT NOT NULL,
    cidade_cliente TEXT,
    pais_cliente TEXT
);

CREATE TABLE veiculo_origem (
    id_veiculo INT PRIMARY KEY,
    modelo_veiculo TEXT NOT NULL,
    preco_veiculo INT
);

CREATE TABLE loja_origem (
    id_loja INT PRIMARY KEY,
    endereco_loja TEXT NOT NULL
);

CREATE TABLE venda_origem (
    id_venda SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_veiculo INT NOT NULL,
    id_loja INT NOT NULL,
    data_venda DATE NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente_origem(id_cliente),
    FOREIGN KEY (id_veiculo) REFERENCES veiculo_origem(id_veiculo),
    FOREIGN KEY (id_loja) REFERENCES loja_origem(id_loja)
);

INSERT INTO cliente_origem (id_cliente, nome_cliente, cidade_cliente, pais_cliente)
VALUES
(1, 'João Silva', 'São Paulo', 'Brasil'),
(2, 'Maria Oliveira', 'Rio de Janeiro', 'Brasil'),
(3, 'Carlos Pereira', 'Lisboa', 'Portugal');

INSERT INTO veiculo_origem (id_veiculo, modelo_veiculo, preco_veiculo)
VALUES
(1, 'Fiat Uno', 25000),
(2, 'Volkswagen Gol', 35000),
(3, 'Chevrolet Onix', 50000);

INSERT INTO loja_origem (id_loja, endereco_loja)
VALUES
(1, 'Avenida Paulista, 1000, São Paulo, SP'),
(2, 'Rua das Flores, 300, Rio de Janeiro, RJ'),
(3, 'Alameda Santos, 500, São Paulo, SP');

INSERT INTO venda_origem (id_cliente, id_veiculo, id_loja, data_venda, quantidade)
VALUES
(1, 1, 1, '2024-01-01', 2),
(2, 2, 2, '2024-02-01', 1),
(3, 3, 3, '2024-03-01', 3);

CREATE TABLE dim_cliente (
    id_cliente INT PRIMARY KEY,
    nome_cliente TEXT NOT NULL,
    cliente_cidade TEXT,
    cliente_pais TEXT
);

CREATE TABLE dim_veiculo (
    id_veiculo INT PRIMARY KEY,
    modelo_veiculo TEXT NOT NULL,
    preco_carro INT
);

CREATE TABLE dim_loja (
    id_loja INT PRIMARY KEY,
    endereco TEXT
);

CREATE TABLE dim_tempo (
    id_data DATE PRIMARY KEY,
    ano INT,
    mes INT
);

CREATE TABLE fat_venda (
    id_fato_venda SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_veiculo INT NOT NULL,
    id_loja INT NOT NULL,
    id_data DATE NOT NULL,
    quantidade INT NOT NULL,
    total_venda INT,
    FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
    FOREIGN KEY (id_veiculo) REFERENCES dim_veiculo(id_veiculo),
    FOREIGN KEY (id_loja) REFERENCES dim_loja(id_loja),
    FOREIGN KEY (id_data) REFERENCES dim_tempo(id_data)
);

INSERT INTO dim_cliente (id_cliente, nome_cliente, cliente_cidade, cliente_pais)
SELECT id_cliente, nome_cliente, cidade_cliente, pais_cliente
FROM cliente_origem;

INSERT INTO dim_veiculo (id_veiculo, modelo_veiculo, preco_carro)
SELECT id_veiculo, modelo_veiculo, preco_veiculo
FROM veiculo_origem;

INSERT INTO dim_loja (id_loja, endereco)
SELECT id_loja, endereco_loja
FROM loja_origem;

INSERT INTO dim_tempo (id_data, ano, mes)
SELECT DISTINCT 
    data_venda,
    EXTRACT(YEAR FROM data_venda) AS ano,
    EXTRACT(MONTH FROM data_venda) AS mes
FROM venda_origem;

INSERT INTO fat_venda (id_cliente, id_veiculo, id_loja, id_data, quantidade, total_venda)
SELECT 
    v.id_cliente,
    v.id_veiculo,
    v.id_loja,
    v.data_venda,
    v.quantidade,
    v.quantidade * ve.preco_veiculo AS total_venda
FROM 
    venda_origem v
JOIN 
    veiculo_origem ve ON v.id_veiculo = ve.id_veiculo;

SELECT 
    l.id_loja,
    l.endereco,
    SUM(fv.total_venda) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
GROUP BY 
    l.id_loja, l.endereco;

SELECT 
    c.id_cliente,
    c.nome_cliente,
    SUM(fv.total_venda) AS total_gasto
FROM 
    fat_venda fv
JOIN 
    dim_cliente c ON fv.id_cliente = c.id_cliente
GROUP BY 
    c.id_cliente, c.nome_cliente
ORDER BY 
    total_gasto DESC;

SELECT 
    v.id_veiculo,
    v.modelo_veiculo,
    SUM(fv.quantidade) AS total_quantidade
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
GROUP BY 
    v.id_veiculo, v.modelo_veiculo
ORDER BY 
    total_quantidade DESC;

SELECT 
    l.id_loja,
    l.endereco,
    SUM(fv.total_venda) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
GROUP BY 
    l.id_loja, l.endereco
ORDER BY 
    total_vendas DESC
LIMIT 5;

SELECT 
    l.id_loja,
    l.endereco,
    SUM(fv.total_venda) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
GROUP BY 
    l.id_loja, l.endereco
ORDER BY 
    total_vendas ASC
LIMIT 5;
