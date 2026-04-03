DROP DATABASE IF EXISTS projeto_extensao;
CREATE DATABASE projeto_extensao;
USE projeto_extensao;

CREATE TABLE tipo (
    id INT PRIMARY KEY,
    nome VARCHAR(45)
);

CREATE TABLE status (
    id INT PRIMARY KEY,
    nome VARCHAR(45)
);

CREATE TABLE permissao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45)
);

CREATE TABLE endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cep VARCHAR(10),
    logradouro VARCHAR(150),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2)
);

CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    permissao_id INT,
    FOREIGN KEY (permissao_id) REFERENCES permissao(id)
);

CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf_cnpj VARCHAR(18) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    observacoes TEXT,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    endereco_id INT,
    FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE fornecedor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    cnpj VARCHAR(18) UNIQUE,
    nome_contato VARCHAR(100),
    nome_empresa VARCHAR(100),
    telefone VARCHAR(20),
    email VARCHAR(100),
    observacoes TEXT,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    categoria_id INT,
    endereco_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id),
    FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);


CREATE TABLE item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_interno VARCHAR(50),
    marca VARCHAR(50),
    ano INT,
    descricao TEXT,
    localizacao VARCHAR(100),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE movimentacao_estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_usuario INT NOT NULL,
    total_gasto_impostos DECIMAL(10,2),
    preco_frete DECIMAL(10,2),
    data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_entrega_prevista DATE,
    data_entrega DATE,
    observacoes TEXT,
    tipo_id INT,
    status_id INT,
    cliente_id INT,
    fornecedor_id INT,
    movimentacao_original INT,
    FOREIGN KEY (fk_usuario) REFERENCES usuario(id),
    FOREIGN KEY (tipo_id) REFERENCES tipo(id),
    FOREIGN KEY (status_id) REFERENCES status(id),
    FOREIGN KEY (cliente_id) REFERENCES cliente(id),
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id),
    FOREIGN KEY (movimentacao_original) REFERENCES movimentacao_estoque(id)
);

CREATE TABLE itens_na_movimentacao (
    movimentacao_estoque_id INT,
    item_id INT,
    qtd INT,
    preco_unitario DECIMAL(10,2),
    PRIMARY KEY (movimentacao_estoque_id, item_id),
    FOREIGN KEY (movimentacao_estoque_id) REFERENCES movimentacao_estoque(id),
    FOREIGN KEY (item_id) REFERENCES item(id)
);

CREATE TABLE fechamento_mes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mes INT,
    ano INT,
    qtd INT,
    movimentacao_estoque_id INT,
    item_id INT,
    FOREIGN KEY (movimentacao_estoque_id, item_id)
        REFERENCES itens_na_movimentacao(movimentacao_estoque_id, item_id)
);

CREATE TABLE fabricante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_contato VARCHAR(45),
    email VARCHAR(45),
    telefone VARCHAR(45),
    cnpj VARCHAR(18),
    observacoes TEXT,
    data_cadastro DATETIME,
    endereco_id INT,
    FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE fabricante_fornecedor (
    fabricante_id INT,
    fornecedor_id INT,
    PRIMARY KEY (fabricante_id, fornecedor_id),
    FOREIGN KEY (fabricante_id) REFERENCES fabricante(id),
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id)
);

CREATE TABLE codigo_associado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(100) NOT NULL,
    fk_fornecedor INT,
    fk_cliente INT,
    FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor(id),
    FOREIGN KEY (fk_cliente) REFERENCES cliente(id)
);

CREATE TABLE item_codigo_associado (
    fk_item INT,
    fk_codigo_associado INT,
    PRIMARY KEY (fk_item, fk_codigo_associado),
    FOREIGN KEY (fk_item) REFERENCES item(id),
    FOREIGN KEY (fk_codigo_associado) REFERENCES codigo_associado(id)
);