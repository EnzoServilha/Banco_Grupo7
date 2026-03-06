create database projeto_extenção;
use projeto_extenção;

CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE veiculo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marca VARCHAR(100) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    ano_inicio INT,
    ano_fim INT
);

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
    fk_categoria INT,
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
    codigo_associado VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255)
);

CREATE TABLE produto_codigo_associado (
    fk_codigo_associado INT,
    fk_produto INT,
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

CREATE TABLE compra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2),
    numero_nota_fiscal VARCHAR(50),
    nome_fornecedor VARCHAR(50)
);

CREATE TABLE item_compra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_compra INT,
    fk_produto INT,
    quantidade INT NOT NULL,
    preco_custo DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (fk_compra) REFERENCES compra(id),
    FOREIGN KEY (fkk_produto) REFERENCES produto(id)
);

CREATE TABLE venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2),
    nome_cliente VARCHAR(50)
);

CREATE TABLE item_venda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_venda INT,
    fk_produto INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (fk_venda) REFERENCES venda(id),
    FOREIGN KEY (fk_produto) REFERENCES produto(id)
);

CREATE TABLE movimentacao_estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fk_produto INT,
    tipo ENUM(
		'ENTRADA', 
        'SAIDA', 
        'AJUSTE'
	) NOT NULL,
    quantidade INT NOT NULL,
    data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    detalhes VARCHAR(255),
    FOREIGN KEY (fk_produto) REFERENCES produto(id)
);