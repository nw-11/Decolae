SET NAMES utf8mb4 COLLATE utf8mb4_0900_as_cs;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET SESSION time_zone = '-03:00';

CREATE DATABASE decolae CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs;
USE decolae;

CREATE TABLE USUARIO (
  email VARCHAR(254) COLLATE utf8mb4_0900_ai_ci NOT NULL,
  nome VARCHAR(120) NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  tipo_usuario VARCHAR(20) NOT NULL,
  PRIMARY KEY (email),
  CONSTRAINT ck_usuario_1 CHECK (tipo_usuario IN ('Cliente','Gerente','Administrador')),
  CONSTRAINT ck_usuario_2 CHECK (CHAR_LENGTH(TRIM(nome)) > 0),
  CONSTRAINT ck_usuario_3 CHECK (CHAR_LENGTH(senha_hash) >= 20),
  CONSTRAINT ck_usuario_4 CHECK (email LIKE '%_@_%._%'),
  CONSTRAINT ck_usuario_5 CHECK (CHAR_LENGTH(email)=CHAR_LENGTH(TRIM(email)))
) ENGINE=InnoDB;

CREATE TABLE PASSAGEIRO (
  cpf CHAR(11) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  nome VARCHAR(120) NOT NULL,
  data_nascimento DATE NOT NULL,
  PRIMARY KEY (cpf),
  CONSTRAINT ck_passageiro_1 CHECK (cpf REGEXP '^[0-9]{11}$'),
  CONSTRAINT ck_passageiro_2 CHECK (CHAR_LENGTH(TRIM(nome)) > 0)
) ENGINE=InnoDB;

CREATE TABLE TRAJETO (
  codigo_trajeto INT NOT NULL AUTO_INCREMENT,
  local_embarque VARCHAR(100) NOT NULL,
  local_chegada VARCHAR(100) NOT NULL,
  horario_partida TIME NOT NULL,
  horario_chegada TIME NOT NULL,
  PRIMARY KEY (codigo_trajeto),
  CONSTRAINT ck_trajeto_1 CHECK (CHAR_LENGTH(TRIM(local_embarque)) > 0),
  CONSTRAINT ck_trajeto_2 CHECK (CHAR_LENGTH(TRIM(local_chegada)) > 0),
  CONSTRAINT ck_trajeto_3 CHECK (horario_partida >= '00:00:00' AND horario_partida < '24:00:00'),
  CONSTRAINT ck_trajeto_4 CHECK (horario_chegada >= '00:00:00' AND horario_chegada < '24:00:00')
) ENGINE=InnoDB;

CREATE TABLE AERONAVE (
  identificacao VARCHAR(20) NOT NULL,
  modelo VARCHAR(60) NOT NULL,
  numero_assentos INT NOT NULL,
  PRIMARY KEY (identificacao),
  CONSTRAINT ck_aeronave_1 CHECK (numero_assentos > 0),
  CONSTRAINT ck_aeronave_2 CHECK (CHAR_LENGTH(TRIM(identificacao)) > 0),
  CONSTRAINT ck_aeronave_3 CHECK (CHAR_LENGTH(TRIM(modelo)) > 0)
) ENGINE=InnoDB;

CREATE TABLE TRIPULACAO (
  id_tripulacao INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id_tripulacao)
) ENGINE=InnoDB;

CREATE TABLE CLIENTE (
  cpf CHAR(11) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  email_usuario VARCHAR(254) COLLATE utf8mb4_0900_ai_ci NOT NULL,
  telefone VARCHAR(20) NOT NULL,
  data_de_cadastro DATE NOT NULL,
  status_cliente VARCHAR(15) NOT NULL,
  PRIMARY KEY (cpf),
  CONSTRAINT uq_cliente_email_usuario UNIQUE (email_usuario),
  CONSTRAINT fk_cliente_email_usuario FOREIGN KEY (email_usuario) REFERENCES USUARIO (email),
  CONSTRAINT ck_cliente_1 CHECK (cpf REGEXP '^[0-9]{11}$'),
  CONSTRAINT ck_cliente_2 CHECK (status_cliente IN ('Ativo','Suspenso','Bloqueado')),
  CONSTRAINT ck_cliente_3 CHECK (CHAR_LENGTH(TRIM(telefone)) > 0)
) ENGINE=InnoDB;

CREATE TABLE FUNCIONARIO (
  cpf CHAR(11) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  nome VARCHAR(120) NOT NULL,
  cargo VARCHAR(50) NOT NULL,
  salario DECIMAL(10,2) NOT NULL,
  email_usuario VARCHAR(254) COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (cpf),
  CONSTRAINT uq_funcionario_email_usuario UNIQUE (email_usuario),
  CONSTRAINT fk_funcionario_email_usuario FOREIGN KEY (email_usuario) REFERENCES USUARIO (email),
  CONSTRAINT ck_funcionario_1 CHECK (cpf REGEXP '^[0-9]{11}$'),
  CONSTRAINT ck_funcionario_2 CHECK (salario >= 0),
  CONSTRAINT ck_funcionario_3 CHECK (CHAR_LENGTH(TRIM(nome)) > 0),
  CONSTRAINT ck_funcionario_4 CHECK (CHAR_LENGTH(TRIM(cargo)) > 0)
) ENGINE=InnoDB;

CREATE TABLE TRIPULACAO_FUNCIONARIO (
  id_tripulacao INT NOT NULL,
  cpf_funcionario CHAR(11) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  funcao_na_tripulacao VARCHAR(15) NOT NULL,
  PRIMARY KEY (id_tripulacao, cpf_funcionario),
  CONSTRAINT fk_tripulacao_funcionario_id_tripulacao FOREIGN KEY (id_tripulacao) REFERENCES TRIPULACAO (id_tripulacao),
  CONSTRAINT fk_tripulacao_funcionario_cpf_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES FUNCIONARIO (cpf),
  CONSTRAINT ck_tripulacao_funcionario_1 CHECK (funcao_na_tripulacao IN ('Piloto','Copiloto','Comissário'))
) ENGINE=InnoDB;

CREATE TABLE VOO (
  id_voo INT NOT NULL AUTO_INCREMENT,
  codigo_trajeto INT NOT NULL,
  identificacao_aeronave VARCHAR(20) NOT NULL,
  id_tripulacao INT NOT NULL,
  data_hora_partida DATETIME NOT NULL,
  data_hora_chegada DATETIME NOT NULL,
  status_voo VARCHAR(15) NOT NULL,
  preco_base DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_voo),
  CONSTRAINT fk_voo_codigo_trajeto FOREIGN KEY (codigo_trajeto) REFERENCES TRAJETO (codigo_trajeto),
  CONSTRAINT fk_voo_identificacao_aeronave FOREIGN KEY (identificacao_aeronave) REFERENCES AERONAVE (identificacao),
  CONSTRAINT fk_voo_id_tripulacao FOREIGN KEY (id_tripulacao) REFERENCES TRIPULACAO (id_tripulacao),
  CONSTRAINT ck_voo_1 CHECK (data_hora_chegada > data_hora_partida),
  CONSTRAINT ck_voo_2 CHECK (preco_base >= 0),
  CONSTRAINT ck_voo_3 CHECK (status_voo IN ('Programado','Concluído','Cancelado'))
) ENGINE=InnoDB;

CREATE TABLE COMPRA (
  codigo_compra INT NOT NULL AUTO_INCREMENT,
  cpf_cliente CHAR(11) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  id_voo INT NOT NULL,
  data_hora_compra DATETIME NOT NULL,
  forma_de_pagamento VARCHAR(20) NOT NULL,
  status_compra VARCHAR(15) NOT NULL,
  PRIMARY KEY (codigo_compra),
  CONSTRAINT fk_compra_cpf_cliente FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE (cpf),
  CONSTRAINT fk_compra_id_voo FOREIGN KEY (id_voo) REFERENCES VOO (id_voo),
  CONSTRAINT ck_compra_1 CHECK (status_compra IN ('Pendente','Paga','Cancelada','Reembolsada')),
  CONSTRAINT ck_compra_2 CHECK (forma_de_pagamento IN ('Pix','Cartão','Boleto'))
) ENGINE=InnoDB;

CREATE TABLE PASSAGEM (
  codigo_bilhete VARCHAR(20) NOT NULL,
  codigo_compra INT NOT NULL,
  cpf_passageiro CHAR(11) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  numero_assento INT NOT NULL,
  preco DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (codigo_bilhete),
  CONSTRAINT fk_passagem_codigo_compra FOREIGN KEY (codigo_compra) REFERENCES COMPRA (codigo_compra),
  CONSTRAINT fk_passagem_cpf_passageiro FOREIGN KEY (cpf_passageiro) REFERENCES PASSAGEIRO (cpf),
  CONSTRAINT uq_passagem_compra_assento UNIQUE (codigo_compra, numero_assento),
  CONSTRAINT ck_passagem_1 CHECK (numero_assento > 0),
  CONSTRAINT ck_passagem_2 CHECK (preco >= 0)
) ENGINE=InnoDB;
