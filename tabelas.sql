create table super_mercado(
id_super_mercado serial primary key,
nome varchar(45) not null,
cnpj char(18) not null,
email varchar(45) not null
);

create table endereco(
id_endereco serial primary key,
rua varchar(45) not null,
numero int not null,
cep char(9) not null,
cidade varchar(45) not null,
uf varchar(45) not null,
fk_id_super_mercado int not null,
fk_id_fornecedor int,
constraint fk_id_super_mercado 
foreign key(fk_id_super_mercado)
references super_mercado (id_super_mercado),
constraint fk_id_fornecedor 
foreign key (fk_id_fornecedor) 
references fornecedor (id_fornecedor)
);

create table funcionario(
id_funcionario serial primary key,
nome varchar(45) not null,
cpf char(11) not null,
fk_id_super_mercado int not null,
constraint fk_id_super_mercado
foreign key(fk_id_super_mercado)
references super_mercado (id_super_mercado)
);

create table caixa(
id_caixa serial primary key,
status varchar(45) not null,
fk_id_super_mercado int not null,
constraint fk_id_super_mercado
foreign key(fk_id_super_mercado)
references super_mercado (id_super_mercado)
);

create table jornada(
id_jornada serial primary key,
data_hora_abertura_cx timestamp not null,
data_hora_fechamento_cx timestamp,
valor_abertura decimal not null,
valor_fechamento decimal ,
fk_id_caixa int not null,
fk_id_funcionario int not null,
constraint caixa_id_caixa
foreign key(fk_id_caixa)
references caixa (id_caixa),
constraint fk_id_funcionario
foreign key(fk_id_funcionario)
references funcionario (id_funcionario)
);

create table cliente(
id_cliente serial primary key,
nome varchar(45),
cpf char(11) not null,
email varchar(45)
);

create table venda(
id_venda serial primary key,
forma_pagamento varchar(45) not null,
valor_total decimal not null,
fk_id_caixa int not null,
fk_id_cliente int not null,
fk_id_jornada int not null,
fk_id_cupom_fiscal int not null,
constraint fk_id_caixa foreign key (fk_id_caixa) references caixa (id_caixa),
constraint fk_id_cliente foreign key (fk_id_cliente) references cliente (id_cliente),
constraint fk_id_jornada foreign key (fk_id_jornada) references jornada (id_jornada),
constraint fk_id_cupom_fiscal foreign key (fk_id_cupom_fiscal) references cupom_fiscal (id_cupom_fiscal)    
);

create table cupom_fiscal(
id_cupom_fiscal serial primary key,
cod_nota varchar(45) not null 
);

create table estoque(
id_estoque serial primary key,
reposicao date not null,
fk_id_super_mercado int not null,
constraint fk_id_super_mercado foreign key (fk_id_super_mercado) references super_mercado (id_super_mercado)
);

create table quantidade_estoque(
id_quantidade_estoque serial primary key,
nome_produto varchar(45) not null,
unidade int not null,
fardo int not null,
fk_id_estoque int not null,
constraint fk_id_estoque
foreign key(fk_id_estoque)
references estoque (id_estoque)
);

create table item_venda(
id_item_venda serial primary key,
quantidade int not null,
fk_id_venda int not null,
fk_id_estoque int not null,
constraint fk_id_venda 
foreign key (fk_id_venda) 
references venda (id_venda),
constraint fk_id_estoque
foreign key (fk_id_estoque) 
references estoque (id_estoque)
);

create table produto(
id_produto serial primary key,
tipo varchar(45) not null,
marca varchar(45) not null,
codigo_barra varchar(45) not null,
valor decimal not null,
validade date not null,
fk_id_estoque int not null,
constraint fk_id_estoque
foreign key (fk_id_estoque) 
references estoque (id_estoque)
);

create table fornecedor(
id_fornecedor serial primary key,
nome varchar(45) not null,
email varchar(45) not null,
telefone char(14) not null,
cnpj char(18) not null,
fk_id_estoque int not null,
constraint fk_id_estoque
foreign key (fk_id_estoque) 
references estoque (id_estoque)
);