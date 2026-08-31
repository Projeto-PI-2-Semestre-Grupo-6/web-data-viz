	CREATE DATABASE monitoramento24h;
    USE monitoramento24h;
    
    CREATE TABLE empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razao_social VARCHAR(50) NOT NULL,
    cnpj CHAR(14) NOT NULL,
    dtHr DATETIME DEFAULT current_timestamp NOT NULL,
    nome_fantasia VARCHAR(50) NOT NULL
    );

    insert into empresa (razao_social, cnpj, nome_fantasia) values
    ('Sptech Educacao Executiva e Servicos Ltda','26217610000135','São Paulo Tech School');
    
    CREATE TABLE usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    senha VARCHAR(50) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    fk_empresa INT NOT NULL, 
	CONSTRAINT empresa_usuario FOREIGN KEY (fk_empresa) REFERENCES empresa(idEmpresa)
    );
    
    CREATE TABLE maquina (
    idMaquina INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    dtHr DATETIME DEFAULT current_timestamp NOT NULL,
    fk_empresa INT NOT NULL,
    CONSTRAINT empresa_maquina FOREIGN KEY maquina(fk_empresa) REFERENCES empresa(idEmpresa)
    );
    
    CREATE TABLE componentes (
    idComponente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL, 
	dtHr DATETIME DEFAULT current_timestamp NOT NULL,
    fk_maquina INT NOT NULL,
    CONSTRAINT maquina_componente FOREIGN KEY componentes(fk_maquina) REFERENCES maquina(idMaquina)
    );
    
    CREATE TABLE captura(
	id int PRIMARY KEY AUTO_INCREMENT,
	porcentagem_de_uso_cpu DOUBLE,
	qtd_nucleos INT,
	frequencia Float,
    porcentagem_de_uso_ram DOUBLE,
	memoria_utilizada DOUBLE,
	memoria_disponivel DOUBLE,
	memoria_total DOUBLE,
	espaco_total DOUBLE,
	espaco_utilizado DOUBLE,
	espaco_livre DOUBLE,
	dtHr DATETIME DEFAULT current_timestamp,
	fk_maquina INT,
    CONSTRAINT maquina_captura FOREIGN KEY medicao(fk_maquina) REFERENCES maquina(idMaquina)
    );

create view ViewGeral as select id as ID, concat((porcentagem_de_uso_cpu), '%') as 'Porcentagem do uso da CPU', concat((porcentagem_de_uso_ram), '%') as 'Porcentagem do uso da RAM', concat((espaco_utilizado), ' bytes') as 'Total usado do disco em bytes', dtHr as DataHora from captura;

create View ViewMedias as select concat((truncate(avg(porcentagem_de_uso_cpu), 1)), '%') as 'Média da CPU neste dia', concat((truncate(avg(porcentagem_de_uso_ram), 1)), '%') as 'Média da RAM neste dia' from captura where date(dtHr) = curdate();

create view ViewMaxCPU as select concat((truncate(max(porcentagem_de_uso_cpu), 1)), '%') as 'Maior uso da CPU neste dia' from captura where date(dtHr) = curdate();

create view ViewMaxRAM as select concat((truncate(max(porcentagem_de_uso_ram), 1)), '%') as 'Maior uso da RAM neste dia' from captura where date(dtHr) = curdate();

create view ViewMinCPU as select concat((truncate(min(porcentagem_de_uso_cpu), 1)), '%') as 'Menor uso da CPU neste dia' from captura where date(dtHr) = curdate();

create view ViewMinRAM as select concat((truncate(min(porcentagem_de_uso_ram), 1)), '%') as 'Menor uso da RAM neste dia' from captura where date(dtHr) = curdate();

create view ViewDashboard as select * from ViewMedias, ViewMinCPU, viewMaxCPU, ViewMinRAM, ViewMaxRAM;

select * from ViewGeral;
select * from ViewDashboard;

select * from captura order by id desc limit 3;
update captura join (select id from captura order by id desc limit 3) as limite on captura.id = limite.id set captura.dtHr = current_timestamp;
delete from captura order by id desc limit 5 ;
    
    