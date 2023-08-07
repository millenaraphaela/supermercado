--- View ---

-- Mostrar o valor total das compras de determinado cliente.

CREATE OR REPLACE VIEW soma_compras_cliente AS
SELECT c.nome AS nome_cliente, c.cpf, SUM(v.valor_total) AS soma_compras
FROM venda v
JOIN cliente c ON v.fk_id_cliente = c.id_cliente
GROUP BY c.nome, c.cpf;

SELECT * FROM soma_compras_cliente
WHERE cpf = '09479772019';


--- Procedure ---

CREATE OR REPLACE PROCEDURE cadastrar_cliente(
    IN nome_cliente VARCHAR(45),
    IN cpf_cliente CHAR(11),
    IN email_cliente VARCHAR(45)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verificar se o CPF já está cadastrado
    IF EXISTS (SELECT 1 FROM cliente WHERE cpf = cpf_cliente) THEN
        -- Caso o CPF já esteja cadastrado, levantar a exceção
        RAISE EXCEPTION 'Este CPF já está cadastrado no sistema.';
    ELSE
        -- Caso o CPF não esteja cadastrado, inserir o novo cliente na tabela
        INSERT INTO cliente (nome, cpf, email) 
        VALUES (nome_cliente, cpf_cliente, email_cliente);
    END IF;
END;
$$;

-- Chamada da procedure com dados válidos
CALL cadastrar_cliente('João da Silva', '12345678901', 'joao.silva@gmail.com');

-- Chamada da procedure com CPF já cadastrado
CALL cadastrar_cliente('Patrícia Jardim Vogas', '48069802006', 'patricia.vogas@gmail.com');

select * from cliente;


--- Function 1 ---

CREATE OR REPLACE FUNCTION abrir_caixa(funcionario_id INTEGER, caixa_id INTEGER, valor_abertura DECIMAL)
RETURNS VOID AS    
$$
BEGIN
 INSERT INTO jornada (data_hora_abertura_cx, valor_abertura, fk_id_caixa, fk_id_funcionario)
 VALUES (current_timestamp, valor_abertura, caixa_id , funcionario_id);
  

END;
$$
LANGUAGE plpgsql;

SELECT * FROM abrir_caixa(3,1,320);


--- Function 2 ---

CREATE OR REPLACE FUNCTION fechar_caixa(
    IN caixa_id INTEGER,
    IN funcionario_id INTEGER,
    IN valor_fechamento DECIMAL
)
RETURNS VOID AS
$$
BEGIN
    UPDATE jornada
    SET data_hora_fechamento_cx = current_timestamp,
        valor_fechamento = fechar_caixa.valor_fechamento 
    WHERE fk_id_caixa = caixa_id AND fk_id_funcionario = funcionario_id
        AND data_hora_fechamento_cx IS NULL;
END;
$$
LANGUAGE plpgsql;

SELECT fechar_caixa(1, 3, 1200);

select * from jornada;


--- Índices ---

 -- índice 1 

 -Consultar clientes com base no CPF. 

  
   CREATE INDEX id_cliente_cpf ON cliente (cpf);

select * from cliente  where cpf = '65046654008';


-- índice 2 

 -Consultar produtos com base na marca.

   
   CREATE INDEX id_produto_marca ON produto (marca);
   
 select * from produto where marca = 'OMO';