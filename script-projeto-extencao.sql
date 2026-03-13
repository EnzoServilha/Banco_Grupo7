create database projeto_extenção;
use projeto_extenção;

CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE veiculo (
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
    tipo_pessoa ENUM('FISICA', 'JURIDICA') NOT NULL DEFAULT 'FISICA',
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

-- PRODUTO

CREATE TABLE produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
	marca VARCHAR(50),
    caracteristica_1 VARCHAR(50),
    caracteristica_2 VARCHAR(50),
    descricao VARCHAR(255),
    preco_custo DECIMAL(10,2) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
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
    descricao VARCHAR(255)
);

CREATE TABLE produto_codigo_associado (
    fk_produto INT,
    fk_codigo_associado INT,
    PRIMARY KEY (fk_produto, fk_codigo_associado),
    FOREIGN KEY (fk_produto) REFERENCES produto(id),
    FOREIGN KEY (fk_codigo_associado) REFERENCES codigo_associado(id)
);

CREATE TABLE produto_veiculo (
    fk_produto INT,
    fk_veiculo INT,
    PRIMARY KEY (fk_produto, fk_veiculo),
    FOREIGN KEY (fk_produto) REFERENCES produto(id),
    FOREIGN KEY (fk_veiculo) REFERENCES veiculo(id)
);
/*
-- Peças similares / equivalentes
CREATE TABLE produto_similar (
    fk_produto INT NOT NULL,
    fk_produto_similar INT NOT NULL,
    observacao VARCHAR(255),
    PRIMARY KEY (fk_produto, fk_produto_similar),
    FOREIGN KEY (fk_produto) REFERENCES produto(id),
    FOREIGN KEY (fk_produto_similar) REFERENCES produto(id),
    CHECK (fk_produto <> fk_produto_similar)
);
*/
-- Relaciona produto com fornecedor
-- Usar para comparar os preços entre fornecedores
CREATE TABLE produto_fornecedor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_produto INT NOT NULL,
    fk_fornecedor INT NOT NULL,
    codigo_no_fornecedor VARCHAR(100),
    preco_custo DECIMAL(10,2),
    prazo_entrega_dias INT,
    data_ultima_compra DATE,
    observacoes TEXT,
    UNIQUE KEY uk_produto_fornecedor (fk_produto, fk_fornecedor),
    FOREIGN KEY (fk_produto) REFERENCES produto(id),
    FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor(id)
);

-- COMPRA (ENTRADA)

CREATE TABLE compra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_fornecedor INT,
    data_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2),
    numero_nota_fiscal VARCHAR(50),
    prazo_entrega DATE,
    data_entrega DATE,
    status ENUM('PENDENTE', 'RECEBIDA', 'CANCELADA') DEFAULT 'PENDENTE',
    fk_cotacao_compra INT NULL,
    observacoes TEXT,
    FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor(id)
);

CREATE TABLE item_compra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_compra INT NOT NULL,
    fk_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_custo DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (fk_compra) REFERENCES compra(id),
    FOREIGN KEY (fk_produto) REFERENCES produto(id)
);

-- COTAÇÃO (ORÇAMENTO PARA CLIENTE)

CREATE TABLE cotacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_cliente INT,
    data_cotacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2),
    status ENUM('ABERTA', 'APROVADA', 'RECUSADA', 'CONVERTIDA', 'CANCELADA') DEFAULT 'ABERTA',
    observacoes TEXT,
    FOREIGN KEY (fk_cliente) REFERENCES cliente(id)
);

CREATE TABLE item_cotacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_cotacao INT NOT NULL,
    fk_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (fk_cotacao) REFERENCES cotacao(id),
    FOREIGN KEY (fk_produto) REFERENCES produto(id)
);

-- VENDA (SAÍDA)

CREATE TABLE venda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_cliente INT,
    fk_cotacao INT NULL,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2),
    status ENUM('PENDENTE', 'CONCLUIDA', 'CANCELADA') DEFAULT 'PENDENTE',
    observacoes TEXT,
    FOREIGN KEY (fk_cliente) REFERENCES cliente(id),
    FOREIGN KEY (fk_cotacao) REFERENCES cotacao(id)
);

CREATE TABLE item_venda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_venda INT NOT NULL,
    fk_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (fk_venda) REFERENCES venda(id),
    FOREIGN KEY (fk_produto) REFERENCES produto(id)
);

-- MOVIMENTAÇÃO DE ESTOQUE

CREATE TABLE movimentacao_estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_produto INT NOT NULL,
    tipo ENUM('ENTRADA', 'SAIDA', 'AJUSTE') NOT NULL,
    quantidade INT NOT NULL,
    data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    detalhes VARCHAR(255),
    fk_compra INT NULL,
    fk_venda INT NULL,
    FOREIGN KEY (fk_produto) REFERENCES produto(id),
    FOREIGN KEY (fk_compra) REFERENCES compra(id),
    FOREIGN KEY (fk_venda) REFERENCES venda(id)
);

-- COTAÇÃO DE COMPRA (comparação entre fornecedores)

CREATE TABLE cotacao_compra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255),
    data_cotacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ABERTA', 'FINALIZADA', 'CANCELADA') DEFAULT 'ABERTA',
    observacoes TEXT
);

CREATE TABLE item_cotacao_compra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_cotacao_compra INT NOT NULL,
    fk_produto INT NOT NULL,
    fk_fornecedor INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2),
    FOREIGN KEY (fk_cotacao_compra) REFERENCES cotacao_compra(id),
    FOREIGN KEY (fk_produto) REFERENCES produto(id),
    FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor(id)
);


ALTER TABLE compra
    ADD CONSTRAINT fk_compra_cotacao_compra
    FOREIGN KEY (fk_cotacao_compra) REFERENCES cotacao_compra(id);
