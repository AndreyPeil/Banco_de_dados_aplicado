create function adicionar(integer, integer)
returns integer as '

	select $1 + $2;

'

language 'sql';

select adicionar(1,2);



create table funcionarios_teste(
	nome varchar(255),
	id int8 primary key not null);
	
insert into funcionarios_teste(nome, id) values ('andrey', 1);
insert into funcionarios_teste(nome, id) values ('ricardo', 2);
insert into funcionarios_teste(nome, id) values ('lucca', 3);
insert into funcionarios_teste(nome, id) values ('peil', 4);


create function nconta(integer) 
returns int8 as '
	select count(*) from funcionarios_teste
			where id > $1'

language 'sql';
 

select nconta(1);

CREATE FUNCTION cliente_contadesc(VARCHAR(30))
RETURNS INT8 AS '
    INSERT INTO funcionarios_teste(nome) VALUES($1);
    SELECT CURRVAL(''funcionarios_id_seq'');
'
LANGUAGE 'sql';

SELECT cliente_contadesc('andrey'); 



create table clientes(
	nome varchar(255),
	email varchar(255));

insert into clientes(nome, email) values(
	('andrey', 'andreypeil@aaaa.com'),
	('ricardo', 'ricardo@bbbb.com'));

CREATE FUNCTION adicionar_cliente(nome VARCHAR(255), email VARCHAR(255))
RETURNS VOID AS $$
BEGIN
    INSERT INTO clientes (nome, email) VALUES (nome, email);
END;
$$ LANGUAGE plpgsql;

select adicionar_cliente('lucca', 'lucca@cccp.com');

--drop function adicionar_cliente(varchar(255), varchar(255));
drop table clientes;

select * from clientes;



create or replace procedure criar_cliente (nome varchar(255), email varchar(255))
as $$
begin 
	insert into clientes(nome, email) values (nome, email);
end;
$$ language plpgsql;

call criar_cliente('peil', 'peil@pppp.com');

select * from clientes;


create function safe_dividir(a integer, b integer)
returns integer as 
'
begin 
 return a / b;
exception
	when division_by_zero then
		return null;
end;
' 
language plpgsql;

select safe_dividir(10,0);








