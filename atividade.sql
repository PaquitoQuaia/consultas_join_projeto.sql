CREATE DATABASE IF NOT EXISTS DB_truck_prts;
USE DB_truck_prts;

CREATE TABLE IF NOT EXISTS ENDERECO (
    id_endereco INT AUTO_INCREMENT,
    cep VARCHAR(8) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    PRIMARY KEY (id_endereco)
);

CREATE TABLE IF NOT EXISTS USUARIO (
    id_usuario INT AUTO_INCREMENT,
    id_endereco INT,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo_cadastro VARCHAR(20) NOT NULL,
    interesses VARCHAR(255),
    PRIMARY KEY (id_usuario),
    FOREIGN KEY (id_endereco) REFERENCES ENDERECO(id_endereco)
);

CREATE TABLE IF NOT EXISTS PRODUTO (
    id_produto INT AUTO_INCREMENT,
    descricao_prod VARCHAR(500) NOT NULL,
    preco_prod DECIMAL(10,2) NOT NULL,
    marca_produto VARCHAR(50),
    categoria VARCHAR(50) NOT NULL,
    imagem VARCHAR(255),
    estoque INT NOT NULL DEFAULT 0,
    modelo_scania VARCHAR(50),
    PRIMARY KEY (id_produto)
);

CREATE TABLE IF NOT EXISTS CATALOGO (
    id_catalogo INT AUTO_INCREMENT,
    id_produto INT NOT NULL,
    secoes VARCHAR(50),
    PRIMARY KEY (id_catalogo),
    FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CARRINHO (
    id_carrinho INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    sub DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    s_carrinho VARCHAR(50),
    PRIMARY KEY (id_carrinho),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ITEM_CARRINHO (
    id_carrinho INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_carrinho, id_produto),
    CONSTRAINT fk_item_carrinho_carrinho FOREIGN KEY (id_carrinho) REFERENCES CARRINHO(id_carrinho) ON DELETE CASCADE,
    CONSTRAINT fk_item_carrinho_produto FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto) ON DELETE CASCADE,
    CONSTRAINT chk_item_carrinho_quantidade CHECK (quantidade > 0),
    CONSTRAINT chk_item_carrinho_preco CHECK (preco_unitario >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS SUPORTE (
    id_suporte INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    numero_wts VARCHAR(20),
    PRIMARY KEY (id_suporte),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS FORMA_PAG (
    id_pag INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    tipo_pagamento VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_pag),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS FINAL_PAG (
    id_final_pag INT AUTO_INCREMENT,
    id_pag INT,
    id_carrinho INT,
    id_endereco INT,
    id_usuario INT NOT NULL,
    frete DECIMAL(10,2) DEFAULT 0.00,
    forma_de_envio VARCHAR(20),
    PRIMARY KEY (id_final_pag),
    FOREIGN KEY (id_pag) REFERENCES FORMA_PAG(id_pag),
    FOREIGN KEY (id_carrinho) REFERENCES CARRINHO(id_carrinho),
    FOREIGN KEY (id_endereco) REFERENCES ENDERECO(id_endereco),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- POPULAÇÃO APENAS DA TABELA PRODUTO
INSERT INTO PRODUTO (
    descricao_prod,
    preco_prod,
    marca_produto,
    categoria,
    imagem,
    estoque,
    modelo_scania
)
WITH RECURSIVE numeros AS (
    SELECT 1 AS numero
    UNION ALL
    SELECT numero + 1 FROM numeros WHERE numero < 500
),
produtos_base AS (
    SELECT 1 AS base_id, 'Bomba D''Água' AS nome, 389.90 AS preco, 'Bomba d''água' AS categoria, 'imagens/bomba_dagua.png' AS imagem
    UNION ALL SELECT 2, 'Bomba de Óleo', 459.90, 'Motor', 'imagens/bomba_oleo.png'
    UNION ALL SELECT 3, 'Junta do Cabeçote', 289.90, 'Motor', 'imagens/junta_cabecote.png'
    UNION ALL SELECT 4, 'Bomba de Combustível', 529.90, 'Combustível', 'imagens/bomba_combustivel.png'
    UNION ALL SELECT 5, 'Radiador', 1299.90, 'Arrefecimento', 'imagens/radiador.png'
    UNION ALL SELECT 6, 'Intercooler', 1099.90, 'Arrefecimento', 'imagens/intercooler.png'
    UNION ALL SELECT 7, 'Ventoinha do Radiador', 449.90, 'Arrefecimento', 'imagens/ventoinha.png'
    UNION ALL SELECT 8, 'Reservatório de Expansão', 259.90, 'Arrefecimento', 'imagens/reservatorio.png'
    UNION ALL SELECT 9, 'Válvula Termostática', 189.90, 'Arrefecimento', 'imagens/valvula_termostatica.png'
    UNION ALL SELECT 10, 'Filtro de Óleo', 89.90, 'Filtros', 'imagens/filtro_oleo.png'
    UNION ALL SELECT 11, 'Filtro de Ar', 139.90, 'Filtros', 'imagens/filtro_ar.png'
    UNION ALL SELECT 12, 'Kit de Embreagem', 1499.90, 'Embreagem', 'imagens/kit_embreagem.png'
    UNION ALL SELECT 13, 'Pastilha de Freio', 249.90, 'Freios', 'imagens/pastilha_freio.png'
    UNION ALL SELECT 14, 'Amortecedor Dianteiro', 649.90, 'Suspensão', 'imagens/amortecedor_dianteiro.png'
    UNION ALL SELECT 15, 'Cruzeta do Cardan', 289.90, 'Transmissão', 'imagens/cruzeta_cardan.png'
    UNION ALL SELECT 16, 'Alternador', 1099.90, 'Elétrica', 'imagens/alternador.png'
    UNION ALL SELECT 17, 'Farol Principal', 499.90, 'Iluminação', 'imagens/farol.png'
    UNION ALL SELECT 18, 'Retrovisor Externo', 349.90, 'Cabine', 'imagens/retrovisor.png'
    UNION ALL SELECT 19, 'Maçaneta da Porta', 129.90, 'Cabine', 'imagens/macaneta.png'
    UNION ALL SELECT 20, 'Para-choque Dianteiro', 1299.90, 'Cabine', 'imagens/parachoque.png'
    UNION ALL SELECT 21, 'Bomba Hidráulica', 739.90, 'Hidráulica', 'imagens/bomba_hidraulica.png'
    UNION ALL SELECT 22, 'Compressor de Ar', 899.90, 'Motor', 'imagens/compressor_ar.png'
    UNION ALL SELECT 23, 'Disco de Freio', 589.90, 'Freios', 'imagens/disco_freio.png'
    UNION ALL SELECT 24, 'Mola Traseira', 479.90, 'Suspensão', 'imagens/mola_traseira.png'
),
modelos AS (
    SELECT 1 AS id, 'R 450' AS modelo UNION ALL SELECT 2, 'R 500' UNION ALL SELECT 3, 'R 540'
    UNION ALL SELECT 4, 'R 620' UNION ALL SELECT 5, 'R 660' UNION ALL SELECT 6, 'R 730'
    UNION ALL SELECT 7, 'G 360' UNION ALL SELECT 8, 'G 410' UNION ALL SELECT 9, 'G 450'
    UNION ALL SELECT 10, 'G 500' UNION ALL SELECT 11, 'P 250' UNION ALL SELECT 12, 'P 280'
    UNION ALL SELECT 13, 'P 310' UNION ALL SELECT 14, 'P 320' UNION ALL SELECT 15, 'P 360'
    UNION ALL SELECT 16, 'P 410' UNION ALL SELECT 17, 'S 450' UNION ALL SELECT 18, 'S 500'
    UNION ALL SELECT 19, 'S 540' UNION ALL SELECT 20, 'S 730'
)
SELECT
    CONCAT(pb.nome, ' ', LPAD(1000000000 + (((n.numero - 1) * 24) + pb.base_id), 10, '0')) AS descricao_prod,
    ROUND(pb.preco + (((n.numero * pb.base_id) % 17) * 13.50), 2) AS preco_prod,
    'Scania' AS marca_produto,
    pb.categoria,
    pb.imagem,
    5 + ((n.numero * pb.base_id) % 26) AS estoque,
    m.modelo AS modelo_scania
FROM numeros n
CROSS JOIN produtos_base pb
JOIN modelos m ON m.id = (((n.numero + pb.base_id - 2) % 20) + 1)
WHERE ((n.numero - 1) * 24 + pb.base_id) <= 500
ORDER BY n.numero, pb.base_id;

-- POPULAÇÃO DA TABELA CATALOGO
INSERT INTO CATALOGO (id_produto, secoes)
SELECT id_produto, categoria FROM PRODUTO;

-- RELATÓRIOS E CONSULTAS DA ATIVIDADE
SELECT COUNT(id_usuario) AS total_usuarios_cadastrados FROM USUARIO;

SELECT SUM(preco_prod) AS valor_total_produtos_reais FROM PRODUTO;

SELECT AVG(preco_prod) AS preco_medio_produto_reais FROM PRODUTO;

SELECT 
    categoria,
    COUNT(id_produto) AS quantidade_produtos,
    AVG(preco_prod) AS preco_medio_reais
FROM PRODUTO
GROUP BY categoria;

SELECT 
    U.nome AS nome_usuario,
    U.email AS email_usuario,
    E.cep AS cep_entrega,
    E.numero AS numero_residencia,
    E.complemento
FROM USUARIO U
INNER JOIN ENDERECO E ON U.id_endereco = E.id_endereco;

SELECT 
    U.tipo_cadastro,
    COUNT(C.id_carrinho) AS total_carrinhos_ativos,
    SUM(C.quantidade) AS total_itens_no_carrinho,
    SUM(C.sub) AS valor_total_carrinho_reais
FROM USUARIO U
INNER JOIN CARRINHO C ON U.id_usuario = C.id_usuario
GROUP BY U.tipo_cadastro;

SELECT
    u.id_usuario,
    u.nome,
    c.id_carrinho,
    c.quantidade,
    c.sub,
    c.s_carrinho
FROM USUARIO AS u
INNER JOIN CARRINHO AS c ON c.id_usuario = u.id_usuario
ORDER BY u.id_usuario, c.id_carrinho;

SELECT
    u.id_usuario,
    u.nome,
    c.id_carrinho,
    c.quantidade,
    c.sub,
    c.s_carrinho
FROM USUARIO AS u
LEFT JOIN CARRINHO AS c ON c.id_usuario = u.id_usuario
ORDER BY u.id_usuario, c.id_carrinho;

SELECT
    u.id_usuario,
    u.nome,
    c.id_carrinho,
    c.quantidade,
    c.sub,
    c.s_carrinho
FROM CARRINHO AS c
RIGHT JOIN USUARIO AS u ON c.id_usuario = u.id_usuario
ORDER BY u.id_usuario, c.id_carrinho;

SELECT
    u.id_usuario,
    u.nome,
    c.id_carrinho,
    c.quantidade,
    c.sub,
    c.s_carrinho
FROM USUARIO AS u
LEFT JOIN CARRINHO AS c ON c.id_usuario = u.id_usuario
WHERE c.id_carrinho IS NULL
ORDER BY u.id_usuario;

SELECT * FROM CARRINHO;
SELECT * FROM USUARIO;
