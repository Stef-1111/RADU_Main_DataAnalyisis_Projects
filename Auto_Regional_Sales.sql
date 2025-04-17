/*
1.	Marca e Colore delle Auto di che costano più di 10.000 € 
*/

SELECT m.Marca, 
    c.Nome AS Colore
FROM auto a
JOIN modello m 
ON a.IDModello = m.IDModello
JOIN colore c
ON a.IDColore = c.IDColore
WHERE a.PrezzoListino > 10000;

/*
2.	Tutti i proprietari di un’auto di colore ROSSO 
*/

SELECT *
FROM vendita v
JOIN auto a 
ON v.IDAuto=a.IDAuto
JOIN colore c
ON a.IDColore=c.IDColore
JOIN anagraficaclienti ac
ON v.IDCliente = ac.IDCliente
WHERE c.Nome='Rosso';


/*
3.	Costo totale di tutte le auto con Cilindrata superiore a 1600
*/
-- USO IL CAST
SELECT SUM(a.PrezzoListino) AS COSTO_TOTALE
FROM auto a
JOIN modello m 
ON a.IDModello = m.IDModello
WHERE CAST(m.Cinlindrata AS UNSIGNED) > 1600;
-- USO CONVERT
SELECT  SUM(a.PrezzoListino) AS COSTO_TOTALE
FROM auto a
JOIN modello m 
ON a.IDModello = m.IDModello
WHERE  CONVERT(m.Cinlindrata, UNSIGNED) > 1600;

/*
4.	Targa e Nome del proprietario delle Auto in una concessionaria della Città di Roma 
*/

SELECT 
a.Targa AS TARGA,
ac.Nome as NOME,
ac.Cognome AS COGNOME,
con.Nome AS NOME_CONCESSIONARIA,
c.Nome AS COMUNE
FROM vendita v
JOIN anagraficaclienti ac
ON v.IDCliente = ac.IDCliente
JOIN auto a
ON v.IDAuto = a.IDAuto
JOIN concessionaria con 
ON a.IDConcessionaria = con.IDConcessionaria
JOIN comune c
ON con.IDComune = c.IDComune
WHERE c.Nome = 'Roma';



/*
5.	Per ogni Concessionaria, il numero di Auto 
*/


SELECT con.Nome AS NomeConcessionaria,
COUNT(a.IDAuto) AS NumeroAuto
FROM auto a
JOIN concessionaria con 
ON a.IDConcessionaria = con.IDConcessionaria
GROUP BY con.Nome;


/*
6.	Il Responsabile di Concessionaria di tutte le auto con Cambio Automatico e Anno Acquisto 2010
*/
SELECT r.Nome as RESPONSABILE,
a.Targa as TARGA
FROM concessionaria c
JOIN vendita v 
ON c.IDConcessionaria = v.IDConcessionaria
JOIN responsabile r
on c.IDResponsabile = r.IDResponsabile
JOIN auto a
ON v.IDAuto = a.IDAuto
WHERE a.Cambio = 'Automatico' AND YEAR(v.DataAcquisto) = 2010;


/*
7.	Per ciascuna TARGA il colore, il prezzo e la città in cui si trova il veicolo 
*/

SELECT a.Targa as TARGA,
col.Nome as COLORE,
a.PrezzoListino as Prezzo,
com.Nome as Comune
FROM auto a
JOIN vendita v
ON a.IDAuto = v.IDAuto
JOIN concessionaria c
ON a.IDConcessionaria = c.IDConcessionaria
JOIN colore col
ON a.IDColore = col.IDColore
JOIN comune as com
ON c.IDComune = com.IDComune
WHERE a.IDAuto NOT IN ( SELECT IDAuto
							FROM vendita);


-- secondo modo con null
SELECT *
FROM auto a
JOIN concessionaria c
ON a.IDConcessionaria = c.IDConcessionaria 
LEFT JOIN vendita v
ON a.IDAuto = v.IDAuto
WHERE v.IDAuto is null;




/*
8.	Le auto con almeno tre Proprietari 
*/


SELECT v.IDAuto ,a.targa as Targa, Count(*) as Numero_vendite
FROM vendita v 
JOIN AUTO a
ON v.IDAuto = a.IDAuto
group by V.IDAuto, a.targa
having COUNT(*)>=3;


/*
9.  La targa delle auto vendute nel 2015 
*/

SELECT a.Targa
FROM vendita v
JOIN AUTO a
ON v.IDAuto = a.IDAuto
WHERE YEAR(v.DataVendita)=2015;


/*
10. La regione con più auto (trovare un modo per associare la Regione) 
*/

SELECT reg.Nome , COUNT(*) as Auto
FROM AUTO a
JOIN concessionaria c
ON a.IDConcessionaria = c.IDConcessionaria
JOIN comune com 
ON c.IDComune = com.IDComune
JOIN provincia prov
ON com.IDProvincia = prov.IDProvincia
JOIN regione reg 
ON prov.IDRegione = reg.IDRegione
GROUP BY reg.Nome
ORDER BY AUTO desc
LIMIT 1;


/*
11. La Targa delle auto che si trovano a Milano, con cambio automatico, colore rosso, di proprietari residenti a Milano
*/

SELECT a.Targa AS TARGA 
FROM auto a
JOIN concessionaria c
ON a.IDConcessionaria = c.IDConcessionaria
JOIN vendita v
ON a.IDAuto = v.IDAuto
JOIN anagraficaclienti anag 
ON v.IDCliente = anag.IDCliente 
JOIN Comune	com 
ON anag.IDComune = com.IDComune
join comune com2 
ON c.IDComune = com2.IDComune
JOIN colore col 
ON a.IDColore = col.IDColore
WHERE com.Nome = 'Milano'
AND com2.nome= 'Milano'
AND col.Nome='Rosso'
AND a.Cambio='Automatico';



/*
1.	Gestione fatturato per Concessionaria 
*/

CREATE VIEW TEAM4_VW_FATTURATO AS
SELECT c.Nome ,YEAR(v.DataAcquisto) AS ANNO, MONTH(v.DataAcquisto) AS MESE,SUM(v.PrezzoVendita) AS FATTURATO
FROM vendita v
JOIN concessionaria c
ON v.IDConcessionaria = c.IDConcessionaria
GROUP BY c.Nome, YEAR(v.DataAcquisto), MONTH(v.DataAcquisto)
ORDER BY c.Nome ASC, YEAR(v.DataAcquisto) DESC, MONTH(v.DataAcquisto) DESC;


/*
2.	Gestione Clienti per Concessionaria
*/
CREATE VIEW TEAM4_VW_ANAGRAFICACLIENTEPERCONCESSIONARIA AS
SELECT 
a.IDCliente AS IDCLIENTE,
a.Nome AS NOME,
a.Cognome AS COGNOME,
com.CAP AS CAP_CLIENTE,
com.Nome AS COMUNE_CLIENTE,
a.Indirizzo AS INDIRIZZO_CLIENTE,
a.Telefono AS TELEFONO_CLIENTE,
c.IDConcessionaria AS IDCONCESSIONARIA,
c.Nome AS NOME_CONCESSIONARIA,
c.Email AS EMAIL_CONCESSIONARIA,
com2.CAP AS CAP_CONCESSIONARIA,
com2.nome AS COMUNE_CONCESSIONARIA,
c.Indirizzo AS INDIRIZZO_CONCESSIONARIA
FROM anagraficaclienti a 
JOIN vendita v
ON a.IDCliente = v.IDCliente 
JOIN concessionaria c
ON  v.IDConcessionaria = c.IDConcessionaria 
JOIN comune com
ON a.IDComune = com.IDComune
JOIN comune  com2
ON c.IDComune = com2.IDComune;







