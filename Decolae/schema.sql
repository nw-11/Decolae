CREATE TABLE usuario (
    nome VARCHAR(50) NOT NULL,
    senha VARCHAR(50) NOT NULL,
    email VARCHAR(50) PRIMARY KEY,
    tipo_usuario VARCHAR(50) NOT NULL
);

CREATE TABLE cliente (
    cpf VARCHAR(11) PRIMARY KEY,
    telefone varchar(11),
    status_cliente BOOLEAN NOT NULL, --cliente ativo ou nao ativo--
    data_de_cadastro DATE NOT NULL,
    email VARCHAR(50) NOT NULL,
    FOREIGN KEY (email) REFERENCES usuario(email)
);

CREATE TABLE funcionario (
    cpf VARCHAR(11) PRIMARY KEY,
    cargo VARCHAR(30) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    salario NUMERIC(8,2) NOT NULL,
    email VARCHAR(50),
    FOREIGN KEY (email) REFERENCES usuario(email)
);

CREATE TABLE tripulacao(
    id_tripulacao INT PRIMARY KEY
);

CREATE TABLE tripulacao_funcionario ( --relacao de funcionario com tripulacao N:M criamos uma nova tabela(tabela associativa)--
    id_tripulacao INT,
    funcao_na_tripulacao VARCHAR(30) NOT NULL, 
    cpf_funcionario VARCHAR(11), 
    PRIMARY KEY (id_tripulacao, cpf_funcionario), --chave primaria composta-- 
    FOREIGN KEY (id_tripulacao) REFERENCES tripulacao(id_tripulacao),
    FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf)
);

CREATE TABLE aeronave (
    id_aeronave INT PRIMARY KEY,
    modelo VARCHAR(15) NOT NULL,
    numero_assentos INT NOT NULL
);

CREATE TABLE trajeto (
    id_trajeto INT PRIMARY KEY,
    local_embarque VARCHAR(50) NOT NULL,
    local_chegada VARCHAR(50) NOT NULL,
    horario_embarque TIMESTAMP NOT NULL,
    horario_chegada TIMESTAMP NOT NULL
);

CREATE TABLE passageiro(
    cpf VARCHAR(11) PRIMARY KEY,
    data_nascimento DATE NOT NULL,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE voo (
    id_voo INT PRIMARY KEY,
    data_voo DATE NOT NULL,
    status_voo VARCHAR(20) NOT NULL,
    id_trajeto INT NOT NULL,
    id_aeronave INT NOT NULL,
    id_tripulacao INT NOT NULL,
    FOREIGN KEY (id_trajeto) REFERENCES trajeto(id_trajeto),
    FOREIGN KEY (id_aeronave) REFERENCES aeronave(id_aeronave),
    FOREIGN KEY (id_tripulacao) REFERENCES tripulacao(id_tripulacao)
);

CREATE TABLE compra (
    codigo_compra INT PRIMARY KEY,
    data_hora_compra TIMESTAMP NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    status_compra VARCHAR(20) NOT NULL,
    valor_total NUMERIC(8,2) NOT NULL,
    cpf_cliente VARCHAR(11) NOT NULL,
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf)
);

CREATE TABLE passagem (
    status_passagem VARCHAR(10) NOT NULL,
    codigo_bilhete INT NOT NULL PRIMARY KEY,
    preco NUMERIC(8,2) NOT NULL,
    numero_assento INT NOT NULL,
    codigo_compra INT NOT NULL,
    id_voo INT NOT NULL,
    cpf_passageiro VARCHAR(11) NOT NULL,
    FOREIGN KEY(codigo_compra) REFERENCES compra(codigo_compra),
    FOREIGN KEY(id_voo) REFERENCES voo(id_voo),
    FOREIGN KEY(cpf_passageiro) REFERENCES passageiro(cpf)
);