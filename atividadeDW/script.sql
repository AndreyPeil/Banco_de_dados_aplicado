CREATE TABLE dim_cliente (
    id_cliente INT UNIQUE NOT NULL,
    nome_cliente TEXT NOT NULL,
    cliente_cidade TEXT,
    cliente_pais TEXT,
    PRIMARY KEY(id_cliente)
);

CREATE TABLE dim_veiculo (
    id_veiculo INT NOT NULL UNIQUE,
    modelo_veiculo TEXT NOT NULL,
    quantidade_venda INT,
    preco_carro int,
    PRIMARY KEY(id_veiculo)
);

CREATE TABLE dim_loja (
    id_loja INT UNIQUE NOT NULL,
    endereco TEXT,
    PRIMARY KEY(id_loja)
);

CREATE TABLE dim_tempo (
    id_data DATE PRIMARY KEY,
    ano INT,
    mes INT
);

CREATE TABLE fat_venda (
    id_fato_venda SERIAL PRIMARY KEY,          
    id_loja INT NOT NULL,                      
    id_cliente INT NOT NULL,                   
    id_veiculo INT NOT NULL,                   
    id_data DATE NOT NULL,                     
    
     

    FOREIGN KEY (id_loja) REFERENCES dim_loja(id_loja),
    FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
    FOREIGN KEY (id_veiculo) REFERENCES dim_veiculo(id_veiculo),
    FOREIGN KEY (id_data) REFERENCES dim_tempo(id_data)
);


INSERT INTO dim_cliente (id_cliente, nome_cliente, cliente_cidade, cliente_pais)
VALUES
(1, 'João Silva', 'São Paulo', 'Brasil'),
(2, 'Maria Oliveira', 'Rio de Janeiro', 'Brasil'),
(3, 'Carlos Pereira', 'Lisboa', 'Portugal');

-- Inserir dados na tabela dim_veiculo
INSERT INTO dim_veiculo (id_veiculo, modelo_veiculo, quantidade_venda, preco_carro)
VALUES
(1, 'Fiat Uno', 100, 25000),
(2, 'Volkswagen Gol', 150, 35000),
(3, 'Chevrolet Onix', 200, 50000);

-- Inserir dados na tabela dim_loja
INSERT INTO dim_loja (id_loja, endereco)
VALUES
(1, 'Avenida Paulista, 1000, São Paulo, SP'),
(2, 'Rua das Flores, 300, Rio de Janeiro, RJ'),
(3, 'Alameda Santos, 500, São Paulo, SP');

-- Inserir dados na tabela dim_tempo
INSERT INTO dim_tempo (id_data, ano, mes)
VALUES
('2024-01-01', 2024, 1),
('2024-02-01', 2024, 2),
('2024-03-01', 2024, 3);

-- Inserir dados na tabela fat_venda
INSERT INTO fat_venda (id_loja, id_cliente, id_veiculo, id_data)
VALUES
(1, 1, 1, '2024-01-01'),
(2, 2, 2, '2024-02-01'),
(3, 3, 3, '2024-03-01');


SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  
GROUP BY 
    l.id_loja, l.endereco;
   
 
   
 --mais
  SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  -- Período de exemplo
GROUP BY 
    l.id_loja, l.endereco
ORDER BY 
    total_vendas DESC
 
   --menos
SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  -- Período de exemplo
GROUP BY 
    l.id_loja, l.endereco
ORDER BY 
    total_vendas asc
    
    
 

SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  -- Período de exemplo
GROUP BY 
    l.id_loja, l.endereco;

SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  -- Período de exemplo
GROUP BY 
    l.id_loja, l.endereco
ORDER BY 
    total_vendas DESC
LIMIT 5;  -- Lojas com as maiores vendas

SELECT 
    l.id_loja,
    l.endereco,
    SUM(v.preco_carro * fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_loja l ON fv.id_loja = l.id_loja
WHERE 
    fv.id_data BETWEEN '2024-01-01' AND '2024-03-31'  -- Período de exemplo
GROUP BY 
    l.id_loja, l.endereco
ORDER BY 
    total_vendas ASC
LIMIT 5;  -- Lojas com as menores vendas
4. Perfil de clientes que devem-se investir:
Para identificar o perfil de clientes que devem ser priorizados, podemos observar aqueles com maior valor de compras e/ou frequência de compra. Podemos realizar uma consulta agrupando por id_cliente e somando as vendas.


SELECT 
    c.id_cliente,
    c.nome_cliente,
    c.cliente_cidade,
    c.cliente_pais,
    SUM(v.preco_carro * fv.id_veiculo) AS total_gasto
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_cliente c ON fv.id_cliente = c.id_cliente
GROUP BY 
    c.id_cliente, c.nome_cliente, c.cliente_cidade, c.cliente_pais
ORDER BY 
    total_gasto DESC

    
 SELECT 
    v.id_veiculo,
    v.modelo_veiculo,
    SUM(fv.id_veiculo) AS total_vendas
FROM 
    fat_venda fv
JOIN 
    dim_veiculo v ON fv.id_veiculo = v.id_veiculo
JOIN 
    dim_cliente c ON fv.id_cliente = c.id_cliente
WHERE 
    c.cliente_cidade = 'São Paulo'  
GROUP BY 
    v.id_veiculo, v.modelo_veiculo
ORDER BY 
    total_vendas DESC
