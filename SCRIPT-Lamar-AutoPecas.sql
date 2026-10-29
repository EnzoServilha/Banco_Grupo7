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
(3, 'CONCLUIDO PARCIALMENTE'),
(4, 'CANCELADO'),
(5, 'CONCLUIDO COM ATRASO'),
(6, 'CONCLUIDO COMPLETAMENTE');

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

-- =====================================================================
-- DADOS DE TESTE / DEMONSTRACAO
-- Substitui TODO o bloco antigo (a partir de "-- DADOS DE TESTE / DEMONSTRACAO"
-- até o fim do script). Os dados obrigatórios (permissao, tipo, status) continuam
-- como estão no topo do script. Rode em um banco recém-criado.
--
-- Gráfico: Jan a Out/2026 (ENTRADA/SAIDA concluídas, agrupadas por data_entrega)
-- Período 10 (aberto, "último"): 1 entrada, 1 saída e 1 cotação por status válido
-- =====================================================================

use lamar;

-- ---------------------------------------------------------------------
-- USUARIOS (todos com a mesma senha do admin)
-- ---------------------------------------------------------------------
INSERT INTO usuario (id, nome, email, senha, data_cadastro, permissao_id, ativo, desativado_por) VALUES
(1, 'Admin',          'admin@teste.com',           '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', '2025-12-15 09:00:00', 1, TRUE, NULL),
(2, 'Carla Mendes',   'carla.mendes@teste.com',    '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', '2026-01-02 08:30:00', 2, TRUE, NULL),
(3, 'Rafael Souza',   'rafael.souza@teste.com',    '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', '2026-01-02 08:45:00', 2, TRUE, NULL),
(4, 'Beatriz Lima',   'beatriz.lima@teste.com',    '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', '2026-01-05 10:00:00', 1, TRUE, NULL),
(5, 'Lucas Pereira',  'lucas.pereira@teste.com',   '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', '2026-02-10 09:15:00', 2, TRUE, NULL);

-- usuário desativado (para testar a tela de usuários)
INSERT INTO usuario (id, nome, email, senha, data_cadastro, permissao_id, ativo, desativado_por) VALUES
(6, 'Marcos Teixeira', 'marcos.teixeira@teste.com', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', '2026-03-01 11:00:00', 2, FALSE, 1);

-- ---------------------------------------------------------------------
-- PERIODOS (1 por mês; 1 a 9 fechados, 10 aberto = último período)
-- qtd_pecas = saldo (entradas concluídas - saídas concluídas) ao fechar
-- ---------------------------------------------------------------------
INSERT INTO periodo (id, data_criacao, anotacao, qtd_pecas, fechado, data_fechamento) VALUES
(1,  '2026-01-01 08:00:00', 'Fechamento de Janeiro - reposição inicial do ano',        140, TRUE,  '2026-01-31 18:00:00'),
(2,  '2026-02-01 08:00:00', 'Fechamento de Fevereiro - freios e velas',                 20, TRUE,  '2026-02-28 18:00:00'),
(3,  '2026-03-01 08:00:00', 'Fechamento de Março - baterias e embreagens',               9, TRUE,  '2026-03-31 18:00:00'),
(4,  '2026-04-01 08:00:00', 'Fechamento de Abril - amortecedores e pivôs',              25, TRUE,  '2026-04-30 18:00:00'),
(5,  '2026-05-01 08:00:00', 'Fechamento de Maio - freios e embreagens',                 12, TRUE,  '2026-05-31 18:00:00'),
(6,  '2026-06-01 08:00:00', 'Fechamento de Junho - baterias, correias e filtros',       22, TRUE,  '2026-06-30 18:00:00'),
(7,  '2026-07-01 08:00:00', 'Fechamento de Julho - suspensão e discos',                 26, TRUE,  '2026-07-31 18:00:00'),
(8,  '2026-08-01 08:00:00', 'Fechamento de Agosto - mês de maior volume',               19, TRUE,  '2026-08-31 18:00:00'),
(9,  '2026-09-01 08:00:00', 'Fechamento de Setembro - freios e embreagens',              7, TRUE,  '2026-09-30 18:00:00'),
(10, '2026-10-01 08:00:00', 'Período atual - Outubro',                                   0, FALSE, NULL);

-- ---------------------------------------------------------------------
-- ENDEREÇOS (1 a 7 clientes/fornecedores antigos e novos)
-- ---------------------------------------------------------------------
INSERT INTO endereco (id, cep, logradouro, numero, complemento, bairro, cidade, uf, ativo) VALUES
(1,  '01001-000', 'Praça da Sé',             '100',  NULL,        'Centro',            'São Paulo',        'SP', TRUE),
(2,  '80010-000', 'Rua XV de Novembro',      '500',  NULL,        'Centro',            'Curitiba',         'PR', TRUE),
(3,  '13010-110', 'Rua Barão de Jaguara',    '1200', NULL,        'Centro',            'Campinas',         'SP', TRUE),
(4,  '30130-010', 'Avenida Afonso Pena',     '1500', 'Sala 12',   'Centro',            'Belo Horizonte',   'MG', TRUE),
(5,  '20040-020', 'Avenida Rio Branco',      '156',  NULL,        'Centro',            'Rio de Janeiro',   'RJ', TRUE),
(6,  '90010-150', 'Rua dos Andradas',        '1234', NULL,        'Centro Histórico',  'Porto Alegre',     'RS', TRUE),
(7,  '89201-000', 'Rua do Príncipe',         '800',  NULL,        'Centro',            'Joinville',        'SC', TRUE),
(8,  '74003-010', 'Avenida Goiás',           '600',  'Galpão 2',  'Setor Central',     'Goiânia',          'GO', TRUE),
(9,  '07011-000', 'Avenida Salgado Filho',   '900',  NULL,        'Centro',            'Guarulhos',        'SP', TRUE),
(10, '40020-000', 'Avenida Estados Unidos',  '50',   NULL,        'Comércio',          'Salvador',         'BA', TRUE),
(11, '18035-000', 'Rua Padre Luiz',          '300',  NULL,        'Centro',            'Sorocaba',         'SP', TRUE),
(12, '14015-000', 'Avenida Presidente Vargas','700', 'Bloco B',   'Jardim Sumaré',     'Ribeirão Preto',   'SP', TRUE);

-- ---------------------------------------------------------------------
-- CLIENTES
-- ---------------------------------------------------------------------
INSERT INTO cliente (id, nome_empresa, nome_contato, cpf_cnpj, telefone, email, observacoes, data_cadastro, endereco_id, ativo) VALUES
(1, 'Oficina do Jhow',          'Jhow Silva',       '12.345.678/0001-99', '(11) 9999-8888', 'contato@jhow.com',          NULL,                              '2025-12-20 10:00:00', 1, TRUE),
(2, 'Auto Center Silva',        'Roberto Silva',    '23.456.789/0001-10', '(19) 3232-1010', 'compras@autocentersilva.com','Paga sempre à vista',             '2026-01-08 09:00:00', 3, TRUE),
(3, 'Mecânica Mineira',         'Fernanda Alves',   '34.567.890/0001-21', '(31) 3333-2020', 'fernanda@mecanicamineira.com','Prefere entrega em horário comercial', '2026-01-15 14:30:00', 4, TRUE),
(4, 'Frota Rápida Transportes', 'Paulo Ribeiro',    '45.678.901/0001-32', '(21) 2525-3030', 'frota@frotarapida.com',     'Compra em grandes volumes',       '2026-02-03 11:00:00', 5, TRUE),
(5, 'Oficina Gaúcha',           'Tiago Becker',     '56.789.012/0001-43', '(51) 3030-4040', 'tiago@oficinagaucha.com',   NULL,                              '2026-02-20 16:00:00', 6, TRUE),
(6, 'Retífica Joinville',       'Marta Schmidt',    '67.890.123/0001-54', '(47) 3434-5050', 'marta@retificajoinville.com','Cliente desde 2026',              '2026-03-05 10:30:00', 7, TRUE);

-- ---------------------------------------------------------------------
-- FORNECEDORES
-- ---------------------------------------------------------------------
INSERT INTO fornecedor (id, razao_social, cnpj, nome_contato, nome_empresa, telefone, email, observacoes, data_cadastro, endereco_id, ativo) VALUES
(1, 'Distribuidora de Pecas Brasil LTDA',  '12.345.678/0001-90', 'Marcos Oliveira', 'Pecas & Cia',      '(11) 4002-8922', 'contato@pecascia.com',       'Fornecedor principal de amortecedores',     '2025-12-18 10:00:00', 1,  TRUE),
(2, 'Importadora Global S.A.',             '98.765.432/0001-11', 'Ana Costa',       'Global Imports',   '(21) 3344-5566', 'vendas@global.com',          'Importado de pecas asiaticas',              '2025-12-18 10:30:00', 2,  TRUE),
(3, 'Auto Peças Goiás Distribuidora LTDA', '78.901.234/0001-65', 'Juliana Rocha',   'Goiás Auto Parts', '(62) 3344-7788', 'vendas@goiasautoparts.com',  'Especializada em freios e embreagens',      '2026-01-10 09:00:00', 8,  TRUE),
(4, 'Paulista Filtros e Lubrificantes LTDA','89.012.345/0001-76','Carlos Menezes',  'Paulista Filtros', '(11) 2468-1357', 'comercial@paulistafiltros.com','Filtros de óleo, ar e combustível',        '2026-01-12 15:00:00', 9,  TRUE),
(5, 'Nordeste Auto Distribuidora LTDA',    '90.123.456/0001-87', 'Patrícia Gomes',  'Nordeste Auto',    '(71) 3355-9900', 'patricia@nordesteauto.com',  'Baterias e correias, entrega em até 7 dias', '2026-01-20 11:30:00', 10, TRUE),
(6, 'Interior Peças e Componentes LTDA',   '01.234.567/0001-98', 'Eduardo Martins', 'Interior Peças',   '(15) 3232-4545', 'eduardo@interiorpecas.com',  'Suspensão e transmissão',                   '2026-02-02 10:15:00', 11, TRUE),
(7, 'Ribeirão Eletro Automotiva LTDA',     '11.222.333/0001-44', 'Renata Faria',    'Ribeirão Eletro',  '(16) 3636-7878', 'renata@ribeiraoeletro.com',  'Peças elétricas e iluminação',              '2026-02-15 14:00:00', 12, TRUE);

-- ---------------------------------------------------------------------
-- CATEGORIAS E MARCAS
-- ---------------------------------------------------------------------
INSERT INTO categoria (id, nome, ativo) VALUES
(1, 'Peças Automotivas',      TRUE),
(2, 'Ferramentas',            TRUE),
(3, 'Eletrônicos',            TRUE),
(4, 'Suspensão',              TRUE),
(5, 'Freios',                 TRUE),
(6, 'Filtros e Lubrificantes',TRUE),
(7, 'Motor e Transmissão',    TRUE),
(8, 'Elétrica e Iluminação',  TRUE);

INSERT INTO marca (id, nome_empresa, ativo) VALUES
(1,  'Cofap',   TRUE),
(2,  'Monroe',  TRUE),
(3,  'Fram',    TRUE),
(4,  'Bosch',   TRUE),
(5,  'NGK',     TRUE),
(6,  'TRW',     TRUE),
(7,  'Cobreq',  TRUE),
(8,  'Mahle',   TRUE),
(9,  'Sachs',   TRUE),
(10, 'Nakata',  TRUE),
(11, 'Gates',   TRUE);

INSERT INTO fornecedor_categoria (fornecedor_id, categoria_id) VALUES
(1,1),(1,4),
(2,1),(2,3),(2,8),
(3,1),(3,5),(3,7),
(4,6),
(5,1),(5,7),
(6,1),(6,4),
(7,3),(7,8);

INSERT INTO fornecedor_marca (fornecedor_id, marca_id) VALUES
(1,1),(1,2),(1,10),
(2,4),(2,5),(2,8),
(3,6),(3,7),(3,9),
(4,3),(4,8),
(5,4),(5,11),
(6,1),(6,10),
(7,4),(7,5);

-- ---------------------------------------------------------------------
-- ITENS (peças)
-- ---------------------------------------------------------------------
INSERT INTO item (id, codigo_interno, marca, ano, descricao, localizacao, data_cadastro, ativo) VALUES
(1,  'AMOR-001', 'Cofap',  2022, 'Amortecedor Dianteiro Direito',        'Prateleira A1', '2025-12-20 09:00:00', TRUE),
(2,  'AMOR-002', 'Monroe', 2022, 'Amortecedor Dianteiro Esquerdo',       'Prateleira A1', '2025-12-20 09:05:00', TRUE),
(3,  'FILT-099', 'Fram',   2023, 'Filtro de Óleo - Modelo X',            'Corredor B',    '2025-12-20 09:10:00', TRUE),
(4,  'PAST-001', 'Cobreq', 2023, 'Pastilha de Freio Dianteira',          'Prateleira C2', '2025-12-22 10:00:00', TRUE),
(5,  'PAST-002', 'TRW',    2022, 'Pastilha de Freio Traseira',           'Prateleira C2', '2025-12-22 10:05:00', TRUE),
(6,  'DISC-001', 'TRW',    2023, 'Disco de Freio Ventilado Dianteiro',   'Prateleira C3', '2025-12-22 10:10:00', TRUE),
(7,  'VELA-001', 'NGK',    2024, 'Vela de Ignição Iridium',              'Gaveta D1',     '2025-12-23 08:30:00', TRUE),
(8,  'BAT-001',  'Bosch',  2023, 'Bateria 60Ah',                         'Depósito E1',   '2025-12-23 08:40:00', TRUE),
(9,  'CORR-001', 'Gates',  2022, 'Kit Correia Dentada',                  'Prateleira F2', '2025-12-23 08:50:00', TRUE),
(10, 'FILT-100', 'Mahle',  2023, 'Filtro de Ar do Motor',                'Corredor B',    '2025-12-26 11:00:00', TRUE),
(11, 'EMBR-001', 'Sachs',  2022, 'Kit de Embreagem',                     'Depósito E2',   '2025-12-26 11:10:00', TRUE),
(12, 'PIVO-001', 'Nakata', 2023, 'Pivô de Suspensão',                    'Prateleira A3', '2025-12-26 11:20:00', TRUE),
(13, 'FILT-101', 'Fram',   2024, 'Filtro de Combustível',                'Corredor B',    '2026-01-05 09:00:00', TRUE),
(14, 'LAMP-001', 'Bosch',  2024, 'Lâmpada de Farol H7',                  'Gaveta D3',     '2026-01-05 09:10:00', TRUE);

INSERT INTO item_similar (fk_item, fk_item_similar) VALUES
(1, 2), (2, 1),
(4, 5), (5, 4);

-- Códigos associados (códigos de fornecedor/cliente para as peças)
INSERT INTO codigo_associado (id, codigo, fk_fornecedor, fk_cliente, ativo) VALUES
(1, 'COF-AMR-9001',   1,    NULL, TRUE),
(2, 'MON-AMR-4402',   1,    NULL, TRUE),
(3, 'FRA-PH-5555',    4,    NULL, TRUE),
(4, 'TRW-GDB-1190',   3,    NULL, TRUE),
(5, 'NGK-BKR6E',      7,    NULL, TRUE),
(6, 'CLI-SILVA-0031', NULL, 2,    TRUE);

INSERT INTO item_codigo_associado (fk_item, fk_codigo_associado) VALUES
(1, 1), (2, 2), (3, 3), (5, 4), (7, 5), (1, 6);

-- ---------------------------------------------------------------------
-- MOVIMENTACOES
-- tipo:   1 ENTRADA | 2 SAIDA | 4 COTACAO
-- status: 1 PENDENTE | 2 CONCLUIDO | 4 CANCELADO | 5 CONCLUIDO COM ATRASO
--         3 CONCLUIDO PARCIALMENTE | 6 CONCLUIDO COMPLETAMENTE (só cotação)
-- Cada mês fechado tem: cotação (id N) -> entrada (N+1) -> saída (N+2, original = cotação)
-- ---------------------------------------------------------------------
INSERT INTO movimentacao_estoque
(id, fk_usuario, total_gasto_impostos, preco_frete, data_movimentacao, data_entrega_prevista, data_entrega, observacoes, tipo_id, status_id, cliente_id, fornecedor_id, movimentacao_original, numero_nota_fiscal, periodo_id)
VALUES
-- JANEIRO (período 1)
(1,  2, NULL,    NULL,   '2026-01-05 09:30:00', NULL,         NULL,         'Cotação de amortecedores e pastilhas',          4, 6, 1,    NULL, NULL, NULL,           1),
(2,  1, 1100.00, 350.00, '2026-01-06 10:00:00', '2026-01-14', '2026-01-13', 'Reposição inicial de estoque do ano',            1, 2, NULL, 1,    NULL, 'NF-2026-0001', 1),
(3,  2, 620.00,  0.00,   '2026-01-12 14:20:00', '2026-01-20', '2026-01-20', 'Venda gerada pela cotação 1',                    2, 2, 1,    NULL, 1,    'NF-2026-0002', 1),
-- FEVEREIRO (período 2)
(4,  3, NULL,    NULL,   '2026-02-03 09:15:00', NULL,         NULL,         'Cotação de freios e velas',                     4, 6, 2,    NULL, NULL, NULL,           2),
(5,  1, 800.00,  280.00, '2026-02-04 10:30:00', '2026-02-12', '2026-02-12', 'Compra de freios e velas',                       1, 2, NULL, 3,    NULL, 'NF-2026-0003', 2),
(6,  3, 1050.00, 150.00, '2026-02-10 15:00:00', '2026-02-18', '2026-02-20', 'Entrega atrasada por falta de transportadora',   2, 5, 2,    NULL, 4,    'NF-2026-0004', 2),
-- MARÇO (período 3)
(7,  2, NULL,    NULL,   '2026-03-02 11:00:00', NULL,         NULL,         'Cotação de baterias, correias e embreagens',    4, 3, 3,    NULL, NULL, NULL,           3),
(8,  4, 950.00,  0.00,   '2026-03-03 09:40:00', '2026-03-10', '2026-03-10', 'Compra de baterias e embreagens',                1, 2, NULL, 5,    NULL, 'NF-2026-0005', 3),
(9,  2, 1180.00, 200.00, '2026-03-09 16:10:00', '2026-03-17', '2026-03-16', 'Venda parcial: correias ficaram de fora',        2, 2, 3,    NULL, 7,    'NF-2026-0006', 3),
-- ABRIL (período 4)
(10, 5, NULL,    NULL,   '2026-04-06 10:20:00', NULL,         NULL,         'Cotação de suspensão para frota',               4, 6, 4,    NULL, NULL, NULL,           4),
(11, 1, 900.00,  300.00, '2026-04-07 09:00:00', '2026-04-15', '2026-04-14', 'Compra de amortecedores e pivôs',                1, 2, NULL, 1,    NULL, 'NF-2026-0007', 4),
(12, 5, 1260.00, 0.00,   '2026-04-13 13:45:00', '2026-04-22', '2026-04-22', 'Venda gerada pela cotação 10',                   2, 2, 4,    NULL, 10,   'NF-2026-0008', 4),
-- MAIO (período 5)
(13, 3, NULL,    NULL,   '2026-05-04 10:00:00', NULL,         NULL,         'Cotação de embreagens e freios',                4, 3, 5,    NULL, NULL, NULL,           5),
(14, 4, 780.00,  220.00, '2026-05-05 08:50:00', '2026-05-13', '2026-05-12', 'Compra de embreagens e freios',                  1, 2, NULL, 3,    NULL, 'NF-2026-0009', 5),
(15, 3, 1050.00, 180.00, '2026-05-11 14:30:00', '2026-05-19', '2026-05-19', 'Venda parcial: sem filtros de combustível',      2, 2, 5,    NULL, 13,   'NF-2026-0010', 5),
-- JUNHO (período 6)
(16, 2, NULL,    NULL,   '2026-06-02 09:20:00', NULL,         NULL,         'Cotação de baterias, correias e filtros',       4, 6, 6,    NULL, NULL, NULL,           6),
(17, 1, 1050.00, 400.00, '2026-06-03 11:15:00', '2026-06-11', '2026-06-10', 'Compra de importados',                           1, 2, NULL, 2,    NULL, 'NF-2026-0011', 6),
(18, 2, 1420.00, 0.00,   '2026-06-10 15:40:00', '2026-06-18', '2026-06-22', 'Atraso na separação do pedido',                  2, 5, 6,    NULL, 16,   'NF-2026-0012', 6),
-- JULHO (período 7)
(19, 5, NULL,    NULL,   '2026-07-01 10:10:00', NULL,         NULL,         'Cotação de discos e amortecedores',             4, 3, 1,    NULL, NULL, NULL,           7),
(20, 4, 1000.00, 350.00, '2026-07-02 09:30:00', '2026-07-10', '2026-07-14', 'Fornecedor atrasou a entrega',                   1, 5, NULL, 6,    NULL, 'NF-2026-0013', 7),
(21, 5, 1300.00, 160.00, '2026-07-09 14:00:00', '2026-07-17', '2026-07-16', 'Venda parcial: sem pivôs',                       2, 2, 1,    NULL, 19,   'NF-2026-0014', 7),
-- AGOSTO (período 8)
(22, 3, NULL,    NULL,   '2026-08-03 09:45:00', NULL,         NULL,         'Cotação grande de motor e elétrica',            4, 6, 3,    NULL, NULL, NULL,           8),
(23, 1, 1450.00, 450.00, '2026-08-04 10:00:00', '2026-08-12', '2026-08-11', 'Compra de maior volume do ano',                  1, 2, NULL, 5,    NULL, 'NF-2026-0015', 8),
(24, 3, 2100.00, 0.00,   '2026-08-12 13:20:00', '2026-08-20', '2026-08-19', 'Venda gerada pela cotação 22',                   2, 2, 3,    NULL, 22,   'NF-2026-0016', 8),
-- SETEMBRO (período 9)
(25, 2, NULL,    NULL,   '2026-09-02 10:30:00', NULL,         NULL,         'Cotação de freios e embreagem',                 4, 3, 2,    NULL, NULL, NULL,           9),
(26, 4, 1380.00, 330.00, '2026-09-03 09:10:00', '2026-09-11', '2026-09-10', 'Compra de freios e embreagens',                  1, 2, NULL, 3,    NULL, 'NF-2026-0017', 9),
(27, 2, 2050.00, 250.00, '2026-09-10 15:15:00', '2026-09-18', '2026-09-17', 'Venda parcial: sem filtros de óleo',             2, 2, 2,    NULL, 25,   'NF-2026-0018', 9),
-- OUTUBRO (período 10, aberto): um de cada tipo para cada status possível
-- COTACAO: PENDENTE, CONCLUIDO PARCIALMENTE, CONCLUIDO COMPLETAMENTE, CANCELADO
(28, 2, NULL,    NULL,   '2026-10-26 10:00:00', NULL,         NULL,         'Cotação aguardando resposta do cliente',        4, 1, 4,    NULL, NULL, NULL,           10),
(29, 3, NULL,    NULL,   '2026-10-05 09:30:00', NULL,         NULL,         'Cotação de suspensão (fechada parcialmente)',   4, 3, 5,    NULL, NULL, NULL,           10),
(30, 2, NULL,    NULL,   '2026-10-03 11:00:00', NULL,         NULL,         'Cotação de correias e velas (fechada completa)',4, 6, 6,    NULL, NULL, NULL,           10),
(31, 3, NULL,    NULL,   '2026-10-14 16:00:00', NULL,         NULL,         'Cliente desistiu da cotação',                   4, 4, 1,    NULL, NULL, NULL,           10),
-- ENTRADA: PENDENTE, CONCLUIDO, CONCLUIDO COM ATRASO, CANCELADO
(32, 1, 600.00,  280.00, '2026-10-22 09:00:00', '2026-11-05', NULL,         'Compra aguardando chegada',                     1, 1, NULL, 6,    NULL, NULL,           10),
(33, 4, 1180.00, 300.00, '2026-10-02 10:00:00', '2026-10-10', '2026-10-09', 'Compra de amortecedores entregue no prazo',      1, 2, NULL, 1,    NULL, 'NF-2026-0020', 10),
(34, 1, 950.00,  0.00,   '2026-10-04 09:40:00', '2026-10-12', '2026-10-16', 'Compra de filtros e velas com atraso',            1, 5, NULL, 4,    NULL, 'NF-2026-0021', 10),
(35, 4, NULL,    NULL,   '2026-10-08 10:20:00', '2026-10-20', NULL,         'Compra cancelada por falta de estoque no fornecedor', 1, 4, NULL, 7, NULL, NULL,        10),
-- SAIDA: PENDENTE, CONCLUIDO, CONCLUIDO COM ATRASO, CANCELADO
-- (só duas cotações do mês foram fechadas; as saídas pendente e cancelada ficam sem cotação original)
(36, 2, 480.00,  90.00,  '2026-10-27 14:00:00', '2026-11-04', NULL,         'Venda de balcão aguardando retirada',           2, 1, 3,    NULL, NULL, NULL,           10),
(37, 2, 1250.00, 0.00,   '2026-10-12 10:30:00', '2026-10-20', '2026-10-19', 'Venda gerada pela cotação 30',                   2, 2, 6,    NULL, 30,   'NF-2026-0022', 10),
(38, 3, 1030.00, 140.00, '2026-10-13 15:00:00', '2026-10-21', '2026-10-26', 'Venda parcial gerada pela cotação 29 (atrasada)',2, 5, 5,    NULL, 29,   'NF-2026-0023', 10),
(39, 5, NULL,    NULL,   '2026-10-15 11:30:00', '2026-10-23', NULL,         'Venda cancelada a pedido do cliente',           2, 4, 2,    NULL, NULL, NULL,           10);

-- ---------------------------------------------------------------------
-- ITENS NAS MOVIMENTACOES
-- Compras usam preço de custo; vendas e cotações usam preço de venda.
-- Cotação "completa" = saída com os mesmos itens/quantidades; "parcial" = menos.
-- ---------------------------------------------------------------------
INSERT INTO itens_na_movimentacao (movimentacao_estoque_id, item_id, qtd, preco_unitario) VALUES
-- Jan
(1, 1, 20, 210.00), (1, 4, 30, 135.00),
(2, 1, 60, 150.00), (2, 4, 50, 85.00), (2, 3, 80, 18.00),
(3, 1, 20, 210.00), (3, 4, 30, 135.00),
-- Fev
(4, 6, 25, 295.00), (4, 5, 40, 115.00), (4, 7, 40, 65.00),
(5, 6, 30, 190.00), (5, 5, 45, 70.00),  (5, 7, 50, 38.00),
(6, 6, 25, 295.00), (6, 5, 40, 115.00), (6, 7, 40, 65.00),
-- Mar
(7, 8, 20, 520.00), (7, 9, 15, 390.00), (7, 11, 8, 720.00),
(8, 8, 22, 340.00), (8, 11, 9, 480.00), (8, 9, 6, 260.00),
(9, 8, 20, 520.00), (9, 11, 8, 720.00),
-- Abr
(10, 1, 30, 210.00), (10, 2, 30, 215.00), (10, 3, 60, 32.00), (10, 12, 40, 78.00),
(11, 1, 35, 150.00), (11, 2, 35, 155.00), (11, 3, 70, 18.00), (11, 12, 45, 45.00),
(12, 1, 30, 210.00), (12, 2, 30, 215.00), (12, 3, 60, 32.00), (12, 12, 40, 78.00),
-- Mai
(13, 11, 10, 720.00), (13, 4, 40, 135.00), (13, 5, 40, 115.00), (13, 13, 50, 40.00),
(14, 11, 12, 480.00), (14, 4, 45, 85.00),  (14, 5, 30, 70.00),
(15, 11, 10, 720.00), (15, 4, 40, 135.00), (15, 5, 25, 115.00),
-- Jun
(16, 8, 20, 520.00), (16, 9, 15, 390.00), (16, 10, 50, 42.00), (16, 14, 40, 50.00),
(17, 8, 24, 340.00), (17, 9, 18, 260.00), (17, 10, 60, 24.00), (17, 14, 45, 28.00),
(18, 8, 20, 520.00), (18, 9, 15, 390.00), (18, 10, 50, 42.00), (18, 14, 40, 50.00),
-- Jul
(19, 6, 30, 295.00), (19, 1, 30, 210.00), (19, 2, 30, 215.00), (19, 12, 40, 78.00),
(20, 6, 32, 190.00), (20, 1, 32, 150.00), (20, 2, 22, 155.00), (20, 12, 20, 45.00),
(21, 6, 30, 295.00), (21, 1, 30, 210.00), (21, 2, 20, 215.00),
-- Ago
(22, 11, 12, 720.00), (22, 8, 18, 520.00), (22, 9, 14, 390.00), (22, 7, 80, 65.00), (22, 14, 50, 50.00),
(23, 11, 13, 480.00), (23, 8, 20, 340.00), (23, 9, 15, 260.00), (23, 7, 90, 38.00), (23, 14, 55, 28.00),
(24, 11, 12, 720.00), (24, 8, 18, 520.00), (24, 9, 14, 390.00), (24, 7, 80, 65.00), (24, 14, 50, 50.00),
-- Set
(25, 6, 30, 295.00), (25, 5, 50, 115.00), (25, 4, 50, 135.00), (25, 11, 15, 720.00), (25, 3, 100, 32.00),
(26, 6, 32, 190.00), (26, 5, 52, 70.00),  (26, 4, 42, 85.00),  (26, 11, 16, 480.00),
(27, 6, 30, 295.00), (27, 5, 50, 115.00), (27, 4, 40, 135.00), (27, 11, 15, 720.00),
-- Out: cotações
(28, 8, 5, 520.00),  (28, 6, 8, 295.00),
(29, 1, 35, 210.00), (29, 2, 35, 215.00), (29, 12, 45, 78.00),
(30, 9, 18, 390.00), (30, 10, 50, 42.00), (30, 7, 80, 65.00),
(31, 14, 30, 50.00), (31, 13, 30, 40.00),
-- Out: entradas
(32, 11, 10, 480.00), (32, 8, 12, 340.00),
(33, 1, 38, 150.00),  (33, 2, 38, 155.00),
(34, 9, 19, 260.00),  (34, 10, 52, 24.00), (34, 7, 82, 38.00),
(35, 14, 40, 28.00),  (35, 13, 40, 22.00),
-- Out: saídas
(36, 4, 15, 135.00),  (36, 5, 15, 115.00),
(37, 9, 18, 390.00),  (37, 10, 50, 42.00), (37, 7, 80, 65.00),
(38, 1, 35, 210.00),  (38, 2, 20, 215.00),
(39, 6, 5, 295.00),   (39, 3, 20, 32.00);

-- =====================================================================
-- Conferência do gráfico (soma de qtd * preco_unitario por mês de data_entrega):
-- Mês   Compras    Vendas     Lucro
-- Jan   14.690     8.250      -6.440
-- Fev   10.750     14.575     3.825
-- Mar   13.360     16.160     2.800
-- Abr   13.960     17.790     3.830
-- Mai   11.685     15.475     3.790
-- Jun   15.540     20.350     4.810
-- Jul   15.190     19.450     4.260
-- Ago   21.900     31.160     9.260
-- Set   20.970     30.800     9.830
-- Out   20.894     25.970     5.076
-- KPIs de cotações (período 10): 4 cotações; 2 viraram pedidos (50%),
-- 1 completa (25%), 1 parcial (25%).
-- =====================================================================