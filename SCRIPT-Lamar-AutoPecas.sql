--  Banco Lamar Auto-Peças
create database if not exists lamar;
use lamar;

CREATE TABLE categoria (
id INT NOT NULL AUTO_INCREMENT,
nome VARCHAR(100) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE permissao (
id INT NOT NULL AUTO_INCREMENT,
nome VARCHAR(45) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE status (
id INT NOT NULL AUTO_INCREMENT,
nome VARCHAR(45) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE tipo (
id INT NOT NULL AUTO_INCREMENT,
nome VARCHAR(45) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE endereco (
id INT NOT NULL AUTO_INCREMENT,
cep VARCHAR(10),
logradouro VARCHAR(150),
numero VARCHAR(20),
complemento VARCHAR(100),
bairro VARCHAR(100),
cidade VARCHAR(100),
uf VARCHAR(2),
PRIMARY KEY (id)
);

CREATE TABLE marca (
id INT NOT NULL AUTO_INCREMENT,
nome_empresa VARCHAR(45),
PRIMARY KEY (id)
);


CREATE TABLE periodo (
id INT NOT NULL AUTO_INCREMENT,
data_criacao DATETIME,
anotacao VARCHAR(180),
qtd_pecas INT,
PRIMARY KEY (id)
);


CREATE TABLE usuario (
id BIGINT NOT NULL AUTO_INCREMENT,
nome VARCHAR(150) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
senha VARCHAR(255) NOT NULL,
data_cadastro DATETIME,
permissao_id INT,
PRIMARY KEY (id),
CONSTRAINT fk_usuario_permissao FOREIGN KEY (permissao_id) REFERENCES permissao (id)
);

CREATE TABLE cliente (
id INT NOT NULL AUTO_INCREMENT,
cpf_cnpj VARCHAR(18) UNIQUE,
nome_empresa VARCHAR(100) NOT NULL,
nome_contato VARCHAR(150),
telefone VARCHAR(20),
email VARCHAR(100),
observacoes TEXT,
data_cadastro DATETIME,
endereco_id INT,
PRIMARY KEY (id),
CONSTRAINT fk_cliente_endereco FOREIGN KEY (endereco_id) REFERENCES endereco (id)
);

CREATE TABLE fornecedor (
id INT NOT NULL AUTO_INCREMENT,
razao_social VARCHAR(150) NOT NULL,
cnpj VARCHAR(18) UNIQUE,
nome_contato VARCHAR(100),
nome_empresa VARCHAR(100),
telefone VARCHAR(20),
email VARCHAR(100),
observacoes TEXT,
data_cadastro DATETIME,
endereco_id INT,
PRIMARY KEY (id),
CONSTRAINT fk_fornecedor_endereco FOREIGN KEY (endereco_id) REFERENCES endereco (id)
);


CREATE TABLE fornecedor_categoria (
fornecedor_id INT NOT NULL,
categoria_id INT NOT NULL,
PRIMARY KEY (fornecedor_id, categoria_id),
CONSTRAINT fk_fc_fornecedor FOREIGN KEY (fornecedor_id) REFERENCES fornecedor (id),
CONSTRAINT fk_fc_categoria FOREIGN KEY (categoria_id) REFERENCES categoria (id)
);


CREATE TABLE fornecedor_marca (
fornecedor_id INT NOT NULL,
marca_id INT NOT NULL,
PRIMARY KEY (fornecedor_id, marca_id),
CONSTRAINT fk_fm_fornecedor FOREIGN KEY (fornecedor_id) REFERENCES fornecedor (id),
CONSTRAINT fk_fm_marca FOREIGN KEY (marca_id) REFERENCES marca (id)
);


CREATE TABLE item (
id INT NOT NULL AUTO_INCREMENT,
codigo_interno VARCHAR(50),
marca VARCHAR(50),
ano INT,
descricao TEXT,
localizacao VARCHAR(100),
data_cadastro DATETIME,
PRIMARY KEY (id)
);

CREATE TABLE codigo_associado (
id INT NOT NULL AUTO_INCREMENT,
codigo VARCHAR(255) NOT NULL,
fk_fornecedor INT,
fk_cliente INT,
PRIMARY KEY (id),
CONSTRAINT fk_codigo_fornecedor FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor (id),
CONSTRAINT fk_codigo_cliente FOREIGN KEY (fk_cliente) REFERENCES cliente (id)
);

CREATE TABLE item_codigo_associado (
fk_item INT NOT NULL,
fk_codigo_associado INT NOT NULL,
PRIMARY KEY (fk_item, fk_codigo_associado),
CONSTRAINT fk_ica_item FOREIGN KEY (fk_item) REFERENCES item (id),
CONSTRAINT fk_ica_codigo FOREIGN KEY (fk_codigo_associado) REFERENCES codigo_associado (id)
);

CREATE TABLE item_similar (
fk_item INT NOT NULL,
fk_item_similar INT NOT NULL,
PRIMARY KEY (fk_item, fk_item_similar),
CONSTRAINT fk_is_item FOREIGN KEY (fk_item) REFERENCES item (id),
CONSTRAINT fk_is_item_similar FOREIGN KEY (fk_item_similar) REFERENCES item (id)
);


CREATE TABLE movimentacao_estoque (
id INT NOT NULL AUTO_INCREMENT,
fk_usuario BIGINT NOT NULL,
total_gasto_impostos DECIMAL(10,2),
preco_frete DECIMAL(10,2),
data_movimentacao DATETIME,
data_entrega_prevista DATE,
data_entrega DATE,
observacoes TEXT,
tipo_id INT,
status_id INT,
cliente_id INT,
fornecedor_id INT,
movimentacao_original INT,
numero_nota_fiscal VARCHAR(45),
periodo_id INT,
PRIMARY KEY (id),
CONSTRAINT fk_mov_usuario FOREIGN KEY (fk_usuario) REFERENCES usuario (id),
CONSTRAINT fk_mov_tipo FOREIGN KEY (tipo_id) REFERENCES tipo (id),
CONSTRAINT fk_mov_status FOREIGN KEY (status_id) REFERENCES status (id),
CONSTRAINT fk_mov_cliente FOREIGN KEY (cliente_id) REFERENCES cliente (id),
CONSTRAINT fk_mov_fornecedor FOREIGN KEY (fornecedor_id) REFERENCES fornecedor (id),
CONSTRAINT fk_mov_original FOREIGN KEY (movimentacao_original) REFERENCES movimentacao_estoque (id),
CONSTRAINT fk_mov_periodo FOREIGN KEY (periodo_id) REFERENCES periodo (id)
);


CREATE TABLE itens_na_movimentacao (
id INT NOT NULL AUTO_INCREMENT,
movimentacao_estoque_id INT NOT NULL,
item_id INT NOT NULL,
qtd INT,
preco_unitario DECIMAL(10,2),
PRIMARY KEY (id),
UNIQUE KEY uq_mov_item (movimentacao_estoque_id, item_id),
CONSTRAINT fk_inm_movimentacao FOREIGN KEY (movimentacao_estoque_id) REFERENCES movimentacao_estoque (id),
CONSTRAINT fk_inm_item FOREIGN KEY (item_id) REFERENCES item (id)
);





