--  Banco Lamar Auto-Peças
create database if not exists lamar;
use lamar;

CREATE TABLE categoria (
id INT NOT NULL AUTO_INCREMENT,
nome VARCHAR(100) NOT NULL,
ativo BOOLEAN NOT NULL DEFAULT TRUE,
desativado_por BIGINT,
PRIMARY KEY (id)
);

-- DADOS OBRIGATORIOS PARA APLICACAO
CREATE TABLE permissao (
id INT NOT NULL AUTO_INCREMENT,
nome VARCHAR(45) NOT NULL,
PRIMARY KEY (id),
CONSTRAINT uk_permissao_nome UNIQUE (nome)
);

CREATE TABLE status (
id INT NOT NULL AUTO_INCREMENT,
nome VARCHAR(45) NOT NULL,
PRIMARY KEY (id),
CONSTRAINT uk_status_nome UNIQUE (nome)
);

CREATE TABLE tipo (
id INT NOT NULL AUTO_INCREMENT,
nome VARCHAR(45) NOT NULL,
PRIMARY KEY (id),
CONSTRAINT uk_tipo_nome UNIQUE (nome)
);

INSERT INTO permissao (id, nome) VALUES
(1, 'ROLE_ADMIN'),
(2, 'ROLE_USER');

INSERT INTO tipo (id, nome) VALUES
(1, 'ENTRADA'),
(2, 'SAIDA'),
(3, 'AJUSTE'),
(4, 'COTACAO');

INSERT INTO status (id, nome) VALUES
(1, 'PENDENTE'),
(2, 'CONCLUIDO'),
(3, 'CONCLUIDO PARCIAL'),
(4, 'CANCELADO');

CREATE TABLE endereco (
id INT NOT NULL AUTO_INCREMENT,
cep VARCHAR(10),
logradouro VARCHAR(150),
numero VARCHAR(20),
complemento VARCHAR(100),
bairro VARCHAR(100),
cidade VARCHAR(100),
uf VARCHAR(2),
ativo BOOLEAN NOT NULL DEFAULT TRUE,
desativado_por BIGINT,
PRIMARY KEY (id)
);

CREATE TABLE marca (
id INT NOT NULL AUTO_INCREMENT,
nome_empresa VARCHAR(45),
ativo BOOLEAN NOT NULL DEFAULT TRUE,
desativado_por BIGINT,
PRIMARY KEY (id)
);


CREATE TABLE periodo (
id INT NOT NULL AUTO_INCREMENT,
data_criacao DATETIME,
anotacao VARCHAR(180),
qtd_pecas INT,
fechado BOOLEAN NOT NULL DEFAULT FALSE,
data_fechamento DATETIME,
PRIMARY KEY (id)
);


CREATE TABLE usuario (
id BIGINT NOT NULL AUTO_INCREMENT,
nome VARCHAR(150) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
senha VARCHAR(255) NOT NULL,
data_cadastro DATETIME,
permissao_id INT,
ativo BOOLEAN NOT NULL DEFAULT TRUE,
desativado_por BIGINT,
PRIMARY KEY (id),
CONSTRAINT fk_usuario_permissao FOREIGN KEY (permissao_id) REFERENCES permissao (id),
CONSTRAINT fk_usuario_desativado_por FOREIGN KEY (desativado_por) REFERENCES usuario (id)
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
ativo BOOLEAN NOT NULL DEFAULT TRUE,
desativado_por BIGINT,
PRIMARY KEY (id),
CONSTRAINT fk_cliente_endereco FOREIGN KEY (endereco_id) REFERENCES endereco (id)
);

CREATE TABLE fornecedor (
id INT NOT NULL AUTO_INCREMENT,
razao_social VARCHAR(150),
cnpj VARCHAR(18) UNIQUE,
nome_contato VARCHAR(100),
nome_empresa VARCHAR(100),
telefone VARCHAR(20),
email VARCHAR(100),
observacoes TEXT,
data_cadastro DATETIME,
endereco_id INT,
ativo BOOLEAN NOT NULL DEFAULT TRUE,
desativado_por BIGINT,
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
codigo_interno VARCHAR(50) NOT NULL,
marca VARCHAR(50),
ano INT,
descricao TEXT,
localizacao VARCHAR(100),
data_cadastro DATETIME,
ativo BOOLEAN NOT NULL DEFAULT TRUE,
desativado_por BIGINT,
PRIMARY KEY (id)
);

CREATE TABLE codigo_associado (
id INT NOT NULL AUTO_INCREMENT,
codigo VARCHAR(255) NOT NULL,
fk_fornecedor INT,
fk_cliente INT,
ativo BOOLEAN NOT NULL DEFAULT TRUE,
desativado_por BIGINT,
PRIMARY KEY (id),
CONSTRAINT fk_codigo_fornecedor FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor (id),
CONSTRAINT fk_codigo_cliente FOREIGN KEY (fk_cliente) REFERENCES cliente (id)
);

ALTER TABLE categoria ADD CONSTRAINT fk_categoria_desativado_por
FOREIGN KEY (desativado_por) REFERENCES usuario (id);
ALTER TABLE endereco ADD CONSTRAINT fk_endereco_desativado_por
FOREIGN KEY (desativado_por) REFERENCES usuario (id);
ALTER TABLE marca ADD CONSTRAINT fk_marca_desativado_por
FOREIGN KEY (desativado_por) REFERENCES usuario (id);
ALTER TABLE cliente ADD CONSTRAINT fk_cliente_desativado_por
FOREIGN KEY (desativado_por) REFERENCES usuario (id);
ALTER TABLE fornecedor ADD CONSTRAINT fk_fornecedor_desativado_por
FOREIGN KEY (desativado_por) REFERENCES usuario (id);
ALTER TABLE item ADD CONSTRAINT fk_item_desativado_por
FOREIGN KEY (desativado_por) REFERENCES usuario (id);
ALTER TABLE codigo_associado ADD CONSTRAINT fk_codigo_associado_desativado_por
FOREIGN KEY (desativado_por) REFERENCES usuario (id);

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
total_gasto_impostos DECIMAL(10,2) CHECK (total_gasto_impostos >= 0),
preco_frete DECIMAL(10,2) CHECK (preco_frete >= 0),
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
periodo_id INT NOT NULL,
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
qtd INT NOT NULL CHECK (qtd > 0),
preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
PRIMARY KEY (id),
UNIQUE KEY uq_mov_item (movimentacao_estoque_id, item_id),
CONSTRAINT fk_inm_movimentacao FOREIGN KEY (movimentacao_estoque_id) REFERENCES movimentacao_estoque (id),
CONSTRAINT fk_inm_item FOREIGN KEY (item_id) REFERENCES item (id)
);

-- DADOS DE TESTE / DEMONSTRACAO
INSERT INTO usuario (nome, email, senha, data_cadastro, permissao_id)
VALUES ('Admin', 'admin@teste.com', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', NOW(), 1);

INSERT INTO categoria (nome) VALUES
('Pecas Automotivas'),
('Ferramentas'),
('Eletronicos');

INSERT INTO periodo (data_criacao, anotacao, qtd_pecas, fechado, data_fechamento)
VALUES
(NOW(), 'Fechamento do primeiro trimestre de estoque', 150, TRUE, NOW()),
(NOW(), 'Inventario mensal - Setor de Amortecedores', 42, TRUE, NOW()),
(NOW(), 'Reposicao de estoque emergencial', 0, FALSE, NULL);

INSERT INTO endereco (cep, logradouro, numero, bairro, cidade, uf)
VALUES
('01001-000', 'Praca da Se', '100', 'Centro', 'Sao Paulo', 'SP'),
('80010-000', 'Rua XV de Novembro', '500', 'Centro', 'Curitiba', 'PR');

INSERT INTO cliente (nome_empresa, nome_contato, cpf_cnpj, telefone, email, data_cadastro, endereco_id)
VALUES ('Oficina do Jhow', 'Jhow Silva', '12.345.678/0001-99', '(11) 9999-8888', 'contato@jhow.com', NOW(), 1);

INSERT INTO fornecedor (razao_social, cnpj, nome_contato, nome_empresa, telefone, email, observacoes, data_cadastro, endereco_id)
VALUES
('Distribuidora de Pecas Brasil LTDA', '12.345.678/0001-90', 'Marcos Oliveira', 'Pecas & Cia', '(11) 4002-8922', 'contato@pecascia.com', 'Fornecedor principal de amortecedores', NOW(), 1),
('Importadora Global S.A.', '98.765.432/0001-11', 'Ana Costa', 'Global Imports', '(21) 3344-5566', 'vendas@global.com', 'Importado de pecas asiaticas', NOW(), 2);

INSERT INTO item (codigo_interno, marca, ano, descricao, localizacao)
VALUES
('AMOR-001', 'Cofap', 2022, 'Amortecedor Dianteiro Direito', 'Prateleira A1'),
('AMOR-002', 'Monroe', 2022, 'Amortecedor Dianteiro Esquerdo', 'Prateleira A1'),
('FILT-099', 'Fram', 2023, 'Filtro de Oleo - Modelo X', 'Corredor B');

INSERT INTO item_similar (fk_item, fk_item_similar) VALUES (1, 2), (2, 1);

INSERT INTO movimentacao_estoque (fk_usuario, tipo_id, status_id, periodo_id, numero_nota_fiscal)
VALUES
(1, 1, 2, 1, 'NF-2026-P1'),
(1, 1, 2, 2, 'NF-2026-P2'),
(1, 1, 2, 3, 'NF-2026-P3');

INSERT INTO itens_na_movimentacao (movimentacao_estoque_id, item_id, qtd, preco_unitario)
VALUES
(1, 1, 150, 150.00),
(2, 1, 42, 150.00),
(3, 1, 10, 150.00);





