create database projeto_extensao;
use projeto_extensao;

CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE maquina (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marca VARCHAR(100) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    ano_inicio INT,
    ano_fim INT
);

-- FORNECEDOR

CREATE TABLE fornecedor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    cnpj VARCHAR(18) UNIQUE,
    nome_contato VARCHAR(100),
    telefone VARCHAR(20),
    email VARCHAR(100),

    cep VARCHAR(10),
    logradouro VARCHAR(150),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2),

    observacoes TEXT,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CLIENTE

CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf_cnpj VARCHAR(18) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),

    cep VARCHAR(10),
    logradouro VARCHAR(150),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2),

    observacoes TEXT,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- PEÇA

CREATE TABLE peca (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    marca VARCHAR(50),
    ano INT,
    descricao VARCHAR(255),
    quantidade INT NOT NULL DEFAULT 0,
    estoqueMinimo INT DEFAULT 5,
    localizacao VARCHAR(100),
    fk_categoria INT,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fk_categoria) REFERENCES categoria(id)
);

CREATE TABLE codigo_associado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_codigo ENUM(
        'INTERNO',
        'FABRICANTE',
        'DISTRIBUIDORA',
        'OUTRO'
    ) NOT NULL,
    codigo VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    fk_fornecedor INT NULL,
    fk_cliente INT NULL,
    FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor(id),
    FOREIGN KEY (fk_cliente) REFERENCES cliente(id),
    CONSTRAINT chk_codigo_associado_origem
        CHECK (fk_fornecedor IS NOT NULL OR fk_cliente IS NOT NULL)
);

CREATE TABLE peca_codigo_associado (
    fk_peca INT,
    fk_codigo_associado INT,
    PRIMARY KEY (fk_peca, fk_codigo_associado),
    FOREIGN KEY (fk_peca) REFERENCES peca(id),
    FOREIGN KEY (fk_codigo_associado) REFERENCES codigo_associado(id)
);

CREATE TABLE peca_maquina (
    fk_peca INT,
    fk_maquina INT,
    PRIMARY KEY (fk_peca, fk_maquina),
    FOREIGN KEY (fk_peca) REFERENCES peca(id),
    FOREIGN KEY (fk_maquina) REFERENCES maquina(id)
);

/*
-- Peças similares / equivalentes
CREATE TABLE peca_similar (
    fk_peca INT NOT NULL,
    fk_peca_similar INT NOT NULL,
    observacoes TEXT,
    PRIMARY KEY (fk_peca, fk_peca_similar),
    FOREIGN KEY (fk_peca) REFERENCES peca(id),
    FOREIGN KEY (fk_peca_similar) REFERENCES peca(id)
);
*/

-- ENTRADA

CREATE TABLE entrada (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_fornecedor INT,
    data_entrada DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2),
    numero_nota_fiscal VARCHAR(50),
    prazo_entrega DATE,
    data_entrega DATE,
    status ENUM('PENDENTE', 'RECEBIDA', 'CANCELADA') DEFAULT 'PENDENTE',
    observacoes TEXT,
    FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor(id)
);

-- SAÍDA

CREATE TABLE saida (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_cliente INT,
    data_saida DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2),
    status ENUM('PENDENTE', 'CONCLUIDA', 'CANCELADA') DEFAULT 'PENDENTE',
    observacoes TEXT,
    FOREIGN KEY (fk_cliente) REFERENCES cliente(id)
);

-- USUÁRIO

CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    permissao ENUM('ADMIN', 'USUARIO') NOT NULL DEFAULT 'USUARIO',
    senha VARCHAR(255) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- MOVIMENTAÇÃO DE ESTOQUE

CREATE TABLE movimentacao_estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_peca INT NOT NULL,
    fk_usuario INT NOT NULL,
    tipo ENUM('ENTRADA', 'SAIDA', 'AJUSTE') NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2),
    data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    observacoes TEXT,
    fk_entrada INT NULL,
    fk_saida INT NULL,
    FOREIGN KEY (fk_peca) REFERENCES peca(id),
    FOREIGN KEY (fk_usuario) REFERENCES usuario(id),
    FOREIGN KEY (fk_entrada) REFERENCES entrada(id),
    FOREIGN KEY (fk_saida) REFERENCES saida(id)
);
