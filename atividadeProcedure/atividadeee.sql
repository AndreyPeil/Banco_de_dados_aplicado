--1

create table pessoas(
	nome varchar(20),
	sobrenome varchar(40),
	idade smallint
);

create procedure pessoas_add (in nome_pessoa varchar(20), in sobrenome_pessoa varchar(40), in idade_pessoa smallint)
as $$
	begin
	insert into pessoas(nome, sobrenome, idade)
	values(nome_pessoa, sobrenome_pessoa, idade_pessoa);
	end;
$$
language plpgsql;

CALL pessoas_add('andrey'::varchar, 'peil'::varchar, 19::smallint);

SELECT * FROM pessoas;

--2
Create TABLE produto (
p_cod_produto INT,
p_nome_produto VARCHAR(30),
p_descricao TEXT,
p_preco NUMERIC,
p_qtde_estoque SMALLINT
)

create procedure add_produto(in p_codigo int, in p_nome varchar(30), p_descricao1 text, p_precopro numeric, p_estoque smallint)
as $$
	begin
		insert into produto(p_cod_produto, p_nome_produto, p_descricao, p_preco, p_qtde_estoque)
		values(p_codigo,p_nome,p_descricao1,p_precopro, p_estoque );
	end;
$$ language plpgsql;
	
call add_produto(1::int, 'celta'::varchar, 'brumbrum'::text, 16000::numeric, 1::smallint );

select * from produto;


--3
create procedure trocar_preco(in p_codigo int, novo_preco numeric )
as $$
	begin
		update produto
		set p_preco = novo_preco
		where p_cod_produto = p_codigo;
		
	end;
$$ language plpgsql;

call trocar_preco(1::int, 15999::numeric);

select * from produto;
	
--4

CREATE OR REPLACE PROCEDURE buscar_produtoo(IN valor_quantidade INT)
LANGUAGE plpgsql AS $$
DECLARE
    nome_produto VARCHAR(30);
BEGIN
    FOR nome_produto IN
        SELECT p_nome_produto 
        FROM produto 
        WHERE p_qtde_estoque < valor_quantidade
    LOOP
        RAISE NOTICE 'Produto: %', nome_produto;
    END LOOP;
END;
$$;

CALL buscar_produtoo(10::int);

--5

create procedure AdcionaEatualizarDesconto(in p_cod_produto int, in p_nome_produto varchar(30), in p_desc decimal(5,2))
as $$
begin
	insert into produto (p_cod_produto, p_nome_produto, p_preco, p_qtde_estoque)
	values (p_cod_produto, p_nome_produto,0,0)
	on conflict (p_cod_produto) do update 
	set p_preco = produto.p_preco - (produto.p_preco * (p_desc / 100));

	update produto 
	set p_preco = p_preco - (p_preco - (p_desc / 100))
	where p_cod_produto  = p_cod_produto ;
end;
$$ language plpgsql;

drop procedure AdcionaEatualizarDesconto;
CALL AdcionaEatualizarDesconto(1, 'celta', 10.00);

-- 6 7
create table compania(
	id serial,
	nome text,
	idade int,
	endereco text,
	salario numeric);

INSERT INTO compania (id, nome, idade, endereco, salario) 
VALUES (1, 'Paul', 32, 'California', 20000);

INSERT INTO compania (id, nome, idade, endereco, salario) 
VALUES (2, 'Allen', 25, 'Texas', 15000);

INSERT INTO compania (id, nome, idade, endereco, salario) 
VALUES (3, 'Teddy', 23, 'Norway', 20000);

INSERT INTO compania (id, nome, idade, endereco, salario) 
VALUES (4, 'Mark', 25, 'Rich-Mond', 65000);

INSERT INTO compania (id, nome, idade, endereco, salario) 
VALUES (5, 'David', 27, 'Texas', 85000);

INSERT INTO compania (id, nome, idade, endereco, salario) 
VALUES (6, 'Kim', 22, 'South-Hall', 45000);

INSERT INTO compania (id, nome, idade, endereco, salario) 
VALUES (7, 'James', 24, 'Houston', 10000);

CREATE OR REPLACE FUNCTION totalRegistro()
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*) INTO total FROM compania;
    
    RETURN total;
END;
$$;

SELECT totalRegistro();

--8
--é possível usar a propria variavel, passando ela e o tipo CREATE FUNCTION exemplo(in parametro INT)
--usando o OUT (nao precisa usar o return nesse) CREATE FUNCTION exemplo_out(OUT resultado INT)
--RECORD para vários parametros em apenas um unico parametro CREATE FUNCTION exemplo_record(p RECORD) 
--Arrays: Para passar listas de valores do mesmo tipo.
--Tipos Compostos: Para criar um tipo personalizado e passá-lo como um único parâmetro.

--9

CREATE TABLE colaboradores(
codigo serial,
nome_emp text,
salario int,
area_cod int,
PRIMARY KEY (area_cod),
FOREIGN KEY (area_cod) REFERENCES area (id));

CREATE TABLE area (id serial primary key, descricao varchar);

insert into area(id, descricao) values(1, 'Suporte');
insert into area(id, descricao) values(2, 'dev');
insert into area(id, descricao) values(3, 'rh');


insert into colaboradores(codigo, nome_emp,salario, area_cod) values(1, 'moinho', 3001, 1);
insert into colaboradores(codigo, nome_emp,salario, area_cod) values(2, 'moinho', 2, 2);
insert into colaboradores(codigo, nome_emp,salario, area_cod) values(3, 'moinho', 50000, 3);



CREATE OR REPLACE FUNCTION buscar_empregado( )
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    emp RECORD;  
BEGIN
    FOR emp IN
        SELECT codigo, nome_emp, salario 
        FROM colaboradores 
        WHERE salario > 3000
    LOOP
        RAISE NOTICE 'Colaborador: Código: %, Nome: %, Salário: %', emp.codigo, emp.nome_emp, emp.salario;
    END LOOP;
END;
$$;

drop function buscar_empregado;
select * from colaboradores c;
SELECT buscar_empregado();

