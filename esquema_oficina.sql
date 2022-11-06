-- Criação do cenário Oficida Mecânica
-- drop database oficina;
create database oficina;
use oficina;

-- Criar tabela Cliente Pessoa Física
create table client_PF(
     idClientPF int auto_increment primary key,
     PFname varchar (45) not null,
     CPF char (11) not null,
     Birthdate date not null,
     Address varchar (45),
     Telephone char (11),
     Email varchar (45) not null
);

alter table client_PF auto_increment=1;

-- Criar tabela Pessoa Juridica
create table client_PJ(
     idClientPJ int auto_increment primary key,
     Corporatename varchar (45) not null,
     PJname varchar (45),
     CNPJ char (14) not null,
     Telephone char (11) not null,
     Email varchar (45),
     Address varchar (45)
);

alter table client_PJ auto_increment=1;

-- Criar Tabela Cliente 
create table client(
     idClient int auto_increment primary key,
     idCClientPF int,
     idCClientPJ int,
     constraint fk_client_pf foreign key (idCClientPF) references client_PF (idClientPF),
     constraint fk_client_pj foreign key (idCClientPJ) references client_PJ (idClientPJ)
);

alter table client auto_increment=1;

-- Criar Tabela Veículos
create table  vehicle(
	idVehicle int auto_increment primary key,
	idVClient int,
	Type_vehicle enum('Moto', 'Carro', 'Triciclo', 'Van', 'Caminhão') not null,
	Board char(7) not null,
	constraint unique_board_vehicle unique(Board),
	Brand varchar(45) not null,
    Model varchar(45) not null,
	Yearmanufacturing char(4) not null,
	constraint fk_vehicle_client foreign key (idVClient) references client (idClient)
);

-- Criar tabela Equipes
create table teams(
    idTeams int primary key,
    Specialty varchar (45) not null,
    Responsible varchar (45) not null
);

-- Criar Tabelas Funcionários
create table employees(
    idEmployees int auto_increment primary key,
    idETeams int,
    Emcode char(6),
    Emname varchar (45),
    CPF char (11) not null,
	Birthdate date not null,
	Address varchar (45),
    Office varchar (45),
    Specialty varchar (45),
	Telephone char (11),
    Datehiring  date not null,
    constraint fk_employees_teams foreign key (idETeams) references teams(idTeams)
);

-- Criar Tabela Tabela de Preços
create table tablePrices(
		idTablePrices int auto_increment primary key,
		Typeservice enum('Conserto','Revisão') not null,
        Specialty enum('Motor', 'Suspensão', 'Eletrica', 'Carroceria') not null, 
		Partsneeded varchar(45),
		Quantitiesparts float,
		Priceparts float,
		Laborvalue float not null,
		Valuetotal float not null
);

-- Criar Tabela Estoque de Peças
create table stookparts(
		idStookparts int auto_increment primary key,
        Nameparts varchar(45) not null,
        Quantitiesavaliable int not null,
        Valueunitary float not null
);



-- Criar tabela Orçamento
create table budget(
		idBudget int auto_increment primary key,
        idBClient int,
        Budgetnumber char(8) not null,
        Approved enum('Sim','Não') not null,
        Datebudget date not null, 
        Valuebudget float not null,
        Validitydate date not null,
        constraint fk_budget_client foreign key (idBClient) references client(idClient)
);

-- Criar tabela Preços Orçamento
create table budgetprice(
	idBPBudget int,
	idBPTablePrices int,
	constraint fk_price_budget foreign key (idBPBudget) references budget (idBudget),
	constraint fk_price_table foreign key (idBPTablePrices) references tablePrices (idTablePrices)
);


-- Ordem de Serviço 
create table serviceOrigin(
		idServiceOrigin int auto_increment primary key,
        idSOVehicle int,
        idSOTeams int,
        idSOBudget int,
        ServNumber char(8) not null,
        Dateissue date not null,
		NecessaryParts varchar(45), 
        ValueService float,
        Statusorder enum('Em execução', 'Concluida', 'Em analise pela equipe','Cancelada'),
        Dateconclusion date,
        constraint fk_order_vehicle foreign key (idSOVehicle) references vehicle (idVehicle),
        constraint fk_order_teams foreign key (idSOTeams) references teams(idTeams),
        constraint fk_order_budget foreign key (idSOBudget) references budget(idBudget)
);

-- Criar tabela Pecas para ordem de serviço
create table parts_SO(
        idpartsStookparts int,
        idpartsServiceOrigin int,
        idpartsBudget int,
        constraint fk_parts_Stookparts foreign key (idpartsStookparts) references stookparts(idStookparts),
        constraint fk_parts_ServiceOrigin foreign key (idpartsServiceOrigin) references serviceOrigin(idServiceOrigin),
        constraint fk_parts_Budget foreign key (idpartsBudget) references budget(idBudget)
);

-- Nome do cliente com veiculo e marca
select PFname, Board, Model  from client_PF
		inner join client on idClientPF = idCClientPF
        inner join vehicle on idclient = idVClient
        order by PFname;
        
-- Quais clientes twm motos?
select PFname, Type_vehicle, Board, Model  from client_PF
		inner join client on idClientPF = idCClientPF
        inner join vehicle on idclient = idVClient
        having Type_vehicle = "Moto"
        order by Board;
        
-- Quais clientes twm carro?
select PFname, Type_vehicle, Board, Model  from client_PF
		inner join client on idClientPF = idCClientPF
        inner join vehicle on idclient = idVClient
        having Type_vehicle = "Carro"
        order by Board;
        
-- Quais clientes twm caminhão?
        select PFname, Type_vehicle, Board, Model  from client_PF
		inner join client on idClientPF = idCClientPF
        inner join vehicle on idclient = idVClient
        having Type_vehicle = "Caminhão"
        order by Board;
        
-- Quantas OS foram Concluidas?
select count(*) from serviceOrigin where Statusorder = 'Concluida'; 