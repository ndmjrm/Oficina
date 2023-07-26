-- criação do BD Oficina
create database oficina;

-- ------------------------------------------------------------------------------------------------------------
-- usando o banco
use oficina;

-- ------------------------------------------------------------------------------------------------------------

-- criação da tabela Ordem de Serviços show tables;
create table ordemServ 
(
	id_ordem_Serv		int auto_increment not null primary key,
    tipo_serv			varchar(25),
    data_emissao		date,
    data_entrega		date,
    valor_os			double,
    Status_os			enum('Em orçamento', 'Em Conserto', 'Revisando', 'Autorizado', 'Serviço Pronto'), 
	revisao				enum('SIM', 'Não') default 'Sim',
    conserto			enum('SIM', 'Não') default 'Sim'
);



-- inserindo dados tabela ordemServ
insert into ordemServ (tipo_serv, data_emissao, data_entrega, valor_os, Status_os, revisao, conserto)
values ('Limpeza de Motor', '2023-07-24', '2023-07-20', 150.00, 'Autorizado', 'Não', 'Não'),
	   ('Troca do para brisa', '2023-06-24', '2023-07-01', 450.00, 'Em Conserto', 'Não', 'Sim'),
	   ('Revisão', '2023-05-24', '2023-06-28', 400.00, 'Autorizado', 'Sim', 'Não'),
       ('Troca Correia dentada', '2023-05-20', '2023-06-02', 855.00, 'Em Conserto', 'Sim', 'Sim'),
       ('Regulagem do Freio', '2023-07-24', '2023-07-27', 50.00, 'Autorizado', 'Não', 'Sim');
       
 -- verificando os dados tabela ordemServ     
select * from ordemServ;
select o.tipo_serv, o.data_entrega, c.nomeCliente, c.cpf from ordemServ as o, cliente as c;
select id_ordem_Serv, tipo_serv  from ordemServ where id_ordem_Serv = 2;
select tipo_serv from ordemServ where tipo_serv like'%corr%';
select tipo_serv, valor_os from ordemServ where (valor_os between 300 and 900);


-- ------------------------------------------------------------------------------------------------------------

-- criação da tabela clientes show tables

create table cliente
(
	id_cliente		int auto_increment not null primary key,
    nomeCliente		varchar(15),
    sobrenome		varchar(25),
    cpf				char(11) unique,
    cnpj			char(17) unique,
    telefone		char(11),
    endereco		varchar(100),
    os_cliente		int,
    constraint fk_os_cliente foreign key (os_cliente) references ordemServ(idordemServ)
);

select distinct o.tipo_serv, o.data_entrega, o.valor_os, concat(c.nomeCliente, ' ', c.sobrenome) as NomeCompleto 
from ordemServ as o, cliente as c
group by NomeCompleto;

-- inserindo dados tabela ordemServ

insert into cliente (nomeCliente, sobrenome, cpf, cnpj, telefone, os_cliente)
values ('Paulo', 'Da Silva', '00022211133', null, 31722554477, 1),
	   ('Simone', 'Arantes', '00022211224', null, 31722554444, 2),
	   ('Thiago', 'Almeida Aleixo', null, 001144779966332255, 31722558877, 3),
       ('Solange', 'Almeida', null, 001144779966332240, 31722547477, 4),
       ('João', 'Bosco Campos', '00022211489', null, 31789254477, 5);
-- verificando a persistência
select * from cliente;

-- ------------------------------------------------------------------------------------------------------------

-- criação da tabela veiculos
drop table veiculos;
create table veiculos
(
	id_veiculos			int auto_increment not null primary key,
    fabricante			varchar(17),
    modeloDoCarro		varchar(15),
    placa				char(7) unique,
    chassi				char(7),
    idcliente_veic		int,
    constraint fk_IDcliente_veiculo foreign key (idcliente_veic) references cliente(idcliente)
);
desc veiculos;
drop table veiculos;
-- inserindo dados tabela veiculos
insert into veiculos (fabricante, modeloDoCarro, placa, chassi, idcliente_veic)
values('Fiat', 'Toro', 'BRA2E19', 'BR13698', 5),
	  ('Volksvagem', 'Golf', 'BRA3L19', 'BR13688', 3),
      ('Chevrolet', 'Onix', 'BRC4E19', 'BR13098', 1),
      ('Citroen', 'C4', 'BRA2R79', 'BR13688', 2),
      ('Peugeot', 'Peugeot 208', 'BRA2E19', 'BR13698', 4);

-- verificando a persistência
select * from veiculos;
delete from veiculos where id_veiculos = 12;
-- ------------------------------------------------------------------------------------------------------------

-- criação da tabela pecas
drop table pecas;
create table pecas
(
	id_pecas			int auto_increment not null primary key,
    nome_pecas			varchar(25) unique,
    vr_pecas			double,
    quantidade_esto		int,
    pecas_os			int,
    constraint fk_pecas_os foreign key (pecas_os) references ordemServ(id_ordem_Serv)
);
desc pecas;
-- inserindo dados tabela veiculos 
insert into pecas (nome_pecas, vr_pecas, quantidade_esto, pecas_os)
values ('Para Brisa', 250.00, 10, 1), 
	   ('Correia dentada', 50.00, 05, 4),
	   ('Bozina', 35.00, 08, 3),
       ('Para choque', 250.00, 1, null),
       ('Velas', 250.00, 11, null);
       
       
-- verificando a persistência
select * from pecas;
-- ------------------------------------------------------------------------------------------------------------


-- criação tabela gerado de n:m entre ordemServ e pecas
drop table os_pecas;

create table os_pecas
(
	id_os_pecas				int primary key auto_increment,
	ordemServ_pecas			int,
    pecas_idPecas			int,
    constraint fk_os_pecas foreign key (ordemServ_pecas) references ordemServ(idordemServ),
    constraint fk_pecas foreign key (pecas_idPecas) references pecas(idpecas)
);
-- inserindo dados tabela veiculos os_pecas

insert into os_pecas (ordemServ_pecas, pecas_idPecas)
values (3, 1),
	   (5, 2),
	   (null, null),
       (null, null),
       (null, null);

-- verificando a persistência
select * from os_pecas;
-- ------------------------------------------------------------------------------------------------------------

-- criação da tabela serviços
drop table servicos;
create table servicos
(
	id_servicos			int auto_increment not null primary key,
    cod_servicos		int not null unique,
    tipo_servicos		varchar(25),
    pecas				int,
    vr_pecas			double,
    vr_mao_obra			double,
    servicos_cliente	int,
    constraint fk_os_servicos foreign key (servicos_cliente) references ordemServ(idordemServ),
    constraint fk_vr_pecas foreign key (vr_pecas) references pecas(pecas)
);

-- inserindo dados tabela veiculos servicos (3,'Colocar Para Brisa', 1, 250.00, 450.00, 1),
insert into servicos (cod_servicos, tipo_servicos, pecas, vr_pecas,  vr_mao_obra, servicos_cliente)
values (5,'Limpeza do Motor', null, null, 450.00, 2),
	   (4,'Revisao', null, null, 400.00, 3),
       (2,'Troca da Correia Dentada', null, null, 855.00, 4),
       (1,'Regulagem do Freio', null, null, 50.00, 2);


-- verificando a persistência
select * from servicos;

desc os_servicos;
-- ------------------------------------------------------------------------------------------------------------
-- criação tabela gerado de n:m entre ordemServ e servicos
create table os_servicos
(
	id_os_servicos			int auto_increment not null primary key,
    servicos_id_servicos	int,
    constraint fk_id_os_servicos foreign key (id_os_servicos) references ordemServ(idordemServ),
    constraint fk_id_servicos foreign key (servicos_id_servicos) references servicos(idservicos)
);


-- criação da tabela equipe
drop table equipe;
desc equipe;
create table equipe

(
	idEquipe			int auto_increment not null primary key,
    nomeTecnico			varchar(15),
    especializacao		ENUM('Mecanico de Motor', 'Lanterneiro', 'Eletricista') default 'Mecanico de Motor',
    endereco			varchar(100),
    os					int,
    constraint fk_os foreign key(os) references ordemServ(idordemServ)
);
insert into equipe(nomeTecnico, especializacao, endereco, os)
values  ('Paulo', 'Eletricista', 'Rua Mar aberto, 23 - Eldorado - Contagem', 004),
		('Santos', 'Lanterneiro', 'Rua Flor, 23 - Serra - BH', 001),
        ('Santos', 'Lanterneiro', 'Rua Flor, 23 - Serra - BH', 001);

-- verificando as tabelas
show tables;


-- consultas

-- alterando tabela equipe
alter table equipe add column salario double;

delete from equipe where idequipe = 6;
select * from equipe;


UPDATE equipe SET salario = 4500 WHERE idEquipe=1;
UPDATE equipe SET salario = 4500 WHERE idEquipe=2;
UPDATE equipe SET salario = 4500 WHERE idEquipe=3;

select o.tipo_serv, o.data_entrega, c.nomeCliente, c.cpf from ordemServ as o, cliente as c;