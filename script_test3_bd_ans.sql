/*
BANCO DE DADOS CRIADO PARA REALIZAÇÃO DE UM DESAFIO DE ESTÁGIO
BY KAIQUE OLIVEIRA
*/

#CRIAR DB
CREATE DATABASE DB_ANS_IC;

#USAR DB
USE DB_ANS_IC;

/*
- Baixar os arquivos dos últimos 2 anos no repositório público : http://ftp.dadosabertos.ans.gov.br/FTP/PDA/demonstracoes_contabeis/
- Baixar csv do link: http://www.ans.gov.br/externo/site_novo/informacoes_avaliacoes_oper/lista_cadop.asp
Tarefas de código:
*/

#CRIAR TABELA COM A RELAÇÃO DAS OPERADORAS ATIVAS
CREATE TABLE OPERADORAS_ATIVAS_CADOP(
	REGISTRO_ANS INT UNSIGNED PRIMARY KEY,
	CNPJ VARCHAR(20),
	RAZAO_SOCIAL VARCHAR(200),
	NOME_FANTASIA VARCHAR(200),
	MODALIDADE VARCHAR(200),
	LOGRADOURO VARCHAR(200),
	NUMERO VARCHAR(50),
	COMPLEMENTO VARCHAR(200),
	BAIRRO VARCHAR(100),
	CIDADE VARCHAR(50),
	UF VARCHAR(2),
	CEP VARCHAR(20),
	DDD VARCHAR(10),
	TELEFONE VARCHAR(25),
	FAX VARCHAR(25),
	ENDERECO_ELETRONICO VARCHAR(100),
	REPRESENTANTE VARCHAR(100),
	CARGO_REPRESENTANTE VARCHAR(100),
	DATA_REGISTRO_ANS DATE
);

/*POR CONTA DA GRANDE QUANTIDADE DE DADOS, E VISANDO A PERFORMANCE NA HORA DAS CONSULTAS, 
SEPAREI AS DEMONSTRACOES CONTABEIS POR ANO
*/

#CRIAR TABELA QUE ARMAZENARA OS DADOS DAS DEMONSTRACOES CONTABEIS DE 2019
CREATE TABLE DEMONSTRACOES_CONTABEIS_2019(
	DATA DATE,
	REG_ANS INT UNSIGNED,
	CD_CONTA_CONTABIL VARCHAR(50),
	DESCRICAO VARCHAR(200),
	VL_SALDO_FINAL DEC(15, 2)
);

#CRIAR TABELA QUE ARMAZENARA OS DADOS DAS DEMONSTRACOES CONTABEIS DE 2020
CREATE TABLE DEMONSTRACOES_CONTABEIS_2020(
	DATA DATE,
	REG_ANS INT UNSIGNED,
	CD_CONTA_CONTABIL VARCHAR(50),
	DESCRICAO VARCHAR(200),
	VL_SALDO_FINAL DEC(15, 2)
);

#CRIAR INDICES NA TABELA DEMONSTRACOES_CONTABEIS_2019 PARA MELHORAR A PERFORMANCE DAS CONSULTAS
CREATE INDEX idx_reg_ans ON DEMONSTRACOES_CONTABEIS_2019(REG_ANS);
CREATE INDEX idx_descricao ON DEMONSTRACOES_CONTABEIS_2019(DESCRICAO);
CREATE INDEX idx_saldo_final ON DEMONSTRACOES_CONTABEIS_2019(VL_SALDO_FINAL);
SHOW INDEX FROM DEMONSTRACOES_CONTABEIS_2019; #VISUALIZAR OS INDEXS CRIADOS

#CRIAR INDICES NA TABELA DEMONSTRACOES_CONTABEIS_2020 PARA MELHORAR A PERFORMANCE DAS CONSULTAS
CREATE INDEX idx_reg_ans ON DEMONSTRACOES_CONTABEIS_2020(REG_ANS);
CREATE INDEX idx_descricao ON DEMONSTRACOES_CONTABEIS_2020(DESCRICAO);
CREATE INDEX idx_saldo_final ON DEMONSTRACOES_CONTABEIS_2020(VL_SALDO_FINAL);
SHOW INDEX FROM DEMONSTRACOES_CONTABEIS_2020; #VISUALIZAR OS INDEXS CRIADOS

/*
- Queries de load: criar as queries para carregar o conteúdo dos arquivos obtidos nas tarefas de preparação num banco MySQL ou Postgres
*/
#VERIFICAR QUAL PASTA OS ARQUIVOS.CSV PODEM SER COLOCADOS PARA REALIZAR A LOAD (CASO O SECURE_FILE_PRIV ESTEJA ATIVO)
SHOW VARIABLES LIKE "secure_file_priv";
#C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\

#IMPORTAR DADOS DAS OPERADORAS ATIVAS PARA A TABELA OPERADORAS_ATIVAS_CADOP
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/relatorio-cadop/Relatorio_cadop.csv'
INTO TABLE OPERADORAS_ATIVAS_CADOP
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 3 LINES
(REGISTRO_ANS, CNPJ, RAZAO_SOCIAL, NOME_FANTASIA, MODALIDADE, LOGRADOURO, NUMERO, COMPLEMENTO, BAIRRO, CIDADE, UF, CEP, DDD, TELEFONE, FAX, ENDERECO_ELETRONICO, REPRESENTANTE, CARGO_REPRESENTANTE, @DATA_REGISTRO_ANS)
SET DATA_REGISTRO_ANS = DATE_FORMAT(STR_TO_DATE(@DATA_REGISTRO_ANS, '%d/%m/%Y'), '%Y-%m-%d');


#IMPORTAR DADOS DAS DEMONSTRACOES CONTABEIS DO 1º TRIMESTRE DE 2019
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/demos-contabeis/2019/1T2019.csv'
INTO TABLE DEMONSTRACOES_CONTABEIS_2019
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET DATA = DATE_FORMAT(STR_TO_DATE(@DATA, '%d/%m/%Y'), '%Y-%m-%d'),
VL_SALDO_FINAL = REPLACE(@VL_SALDO_FINAL, ',', '.');

#IMPORTAR DADOS DAS DEMONSTRACOES CONTABEIS DO 2º TRIMESTRE DE 2019
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/demos-contabeis/2019/2T2019.csv'
INTO TABLE DEMONSTRACOES_CONTABEIS_2019
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET DATA = DATE_FORMAT(STR_TO_DATE(@DATA, '%d/%m/%Y'), '%Y-%m-%d'),
VL_SALDO_FINAL = REPLACE(@VL_SALDO_FINAL, ',', '.');

#IMPORTAR DADOS DAS DEMONSTRACOES CONTABEIS DO 3º TRIMESTRE DE 2019
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/demos-contabeis/2019/3T2019.csv'
INTO TABLE DEMONSTRACOES_CONTABEIS_2019
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET DATA = DATE_FORMAT(STR_TO_DATE(@DATA, '%d/%m/%Y'), '%Y-%m-%d'),
VL_SALDO_FINAL = REPLACE(@VL_SALDO_FINAL, ',', '.');

#IMPORTAR DADOS DAS DEMONSTRACOES CONTABEIS DO 4º TRIMESTRE DE 2019
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/demos-contabeis/2019/4T2019.csv'
INTO TABLE DEMONSTRACOES_CONTABEIS_2019
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET DATA = DATE_FORMAT(STR_TO_DATE(@DATA, '%d/%m/%Y'), '%Y-%m-%d'),
VL_SALDO_FINAL = REPLACE(@VL_SALDO_FINAL, ',', '.');

#IMPORTAR DADOS DAS DEMONSTRACOES CONTABEIS DO 1º TRIMESTRE DE 2020
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/demos-contabeis/2020/1T2020.csv'
INTO TABLE DEMONSTRACOES_CONTABEIS_2020
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET DATA = DATE_FORMAT(STR_TO_DATE(@DATA, '%d/%m/%Y'), '%Y-%m-%d'),
VL_SALDO_FINAL = REPLACE(@VL_SALDO_FINAL, ',', '.');

#IMPORTAR DADOS DAS DEMONSTRACOES CONTABEIS DO 2º TRIMESTRE DE 2020
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/demos-contabeis/2020/2T2020.csv'
INTO TABLE DEMONSTRACOES_CONTABEIS_2020
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET DATA = DATE_FORMAT(STR_TO_DATE(@DATA, '%d/%m/%Y'), '%Y-%m-%d'),
VL_SALDO_FINAL = REPLACE(@VL_SALDO_FINAL, ',', '.');

#IMPORTAR DADOS DAS DEMONSTRACOES CONTABEIS DO 3º TRIMESTRE DE 2020
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/demos-contabeis/2020/3T2020.csv'
INTO TABLE DEMONSTRACOES_CONTABEIS_2020
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET DATA = DATE_FORMAT(STR_TO_DATE(@DATA, '%d/%m/%Y'), '%Y-%m-%d'),
VL_SALDO_FINAL = REPLACE(@VL_SALDO_FINAL, ',', '.');

#IMPORTAR DADOS DAS DEMONSTRACOES CONTABEIS DO 4º TRIMESTRE DE 2020
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/demos-contabeis/2020/4T2020.csv'
INTO TABLE DEMONSTRACOES_CONTABEIS_2020
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET DATA = DATE_FORMAT(STR_TO_DATE(@DATA, '%d/%m/%Y'), '%Y-%m-%d'),
VL_SALDO_FINAL = REPLACE(@VL_SALDO_FINAL, ',', '.');

/*Quais as 10 operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" 
no último trimestre?*/
SELECT 
	opacadop.REGISTRO_ANS, 
	opacadop.RAZAO_SOCIAL,
  dc.DESCRICAO,
  dc.TOTAL
FROM OPERADORAS_ATIVAS_CADOP AS opacadop
INNER JOIN 
	(SELECT REG_ANS, DESCRICAO, sum(VL_SALDO_FINAL) as TOTAL
	FROM DEMONSTRACOES_CONTABEIS_2020
	WHERE DESCRICAO = "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR "
	AND VL_SALDO_FINAL > 0
	AND DATA BETWEEN '2020-10-01' AND '2020-12-31'
	GROUP BY REG_ANS
	ORDER BY TOTAL DESC
	LIMIT 10) AS dc
ON opacadop.REGISTRO_ANS = dc.REG_ANS;


/*Quais as 10 operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" 
no último ano?*/
SELECT 
	opacadop.REGISTRO_ANS, 
	opacadop.RAZAO_SOCIAL,
  dc.DESCRICAO,
  dc.TOTAL
FROM OPERADORAS_ATIVAS_CADOP AS opacadop
INNER JOIN 
	(SELECT REG_ANS, DESCRICAO, sum(VL_SALDO_FINAL) as TOTAL
	FROM DEMONSTRACOES_CONTABEIS_2020
	WHERE DESCRICAO = "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR "
	AND VL_SALDO_FINAL > 0
	AND DATA BETWEEN '2020-01-01' AND '2020-12-31'
	GROUP BY REG_ANS
	ORDER BY TOTAL DESC
	LIMIT 10) AS dc
ON opacadop.REGISTRO_ANS = dc.REG_ANS;