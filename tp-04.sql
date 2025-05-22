-- TP 04 – Requêtes avancées

-- a. Je liste les articles en triant par ordre alphabétique de la désignation
SELECT * FROM ARTICLE
ORDER BY DESIGNATION ASC;

-- b. Là je trie tous les articles du plus cher au moins cher
SELECT * FROM ARTICLE
ORDER BY PRIX DESC;

-- c. Je récupère tous les articles qui sont des boulons, triés par prix croissant
SELECT * FROM ARTICLE
WHERE DESIGNATION LIKE '%boulon%'
ORDER BY PRIX ASC;

-- d. Tous les articles qui contiennent le mot "sachet" dans la désignation (sensible à la casse)
SELECT * FROM ARTICLE
WHERE DESIGNATION LIKE '%sachet%';

-- e. Même chose mais cette fois peu importe la casse (je passe tout en minuscule pour comparer)
SELECT * FROM ARTICLE
WHERE LOWER(DESIGNATION) LIKE '%sachet%';

-- f. Je joins les articles avec leurs fournisseurs, triés par nom de fournisseur (A-Z) puis par prix décroissant
SELECT A.*, F.NOM AS NOM_FOURNISSEUR
FROM ARTICLE A
JOIN FOURNISSEUR F ON A.ID_FOU = F.ID
ORDER BY F.NOM ASC, A.PRIX DESC;

-- g. Les articles du fournisseur "Dubois & Fils"
SELECT * FROM ARTICLE
WHERE ID_FOU = (
  SELECT ID FROM FOURNISSEUR WHERE NOM = 'Dubois & Fils'
);

-- h. Moyenne des prix des articles de "Dubois & Fils"
SELECT AVG(PRIX) AS MOYENNE_PRIX
FROM ARTICLE
WHERE ID_FOU = (
  SELECT ID FROM FOURNISSEUR WHERE NOM = 'Dubois & Fils'
);

-- i. Moyenne des prix par fournisseur
SELECT ID_FOU, AVG(PRIX) AS MOYENNE_PRIX
FROM ARTICLE
GROUP BY ID_FOU;

-- j. Les bons de commande entre le 1er mars et le 5 avril 2019 à midi
SELECT * FROM BON
WHERE DATE_CMDE BETWEEN '2019-03-01 00:00:00' AND '2019-04-05 12:00:00';

-- k. Les bons de commande contenant des boulons
SELECT DISTINCT B.NO_CMDE
FROM BON B
JOIN LIGNE_BON LB ON B.NO_CMDE = LB.NO_CMDE
JOIN ARTICLE A ON LB.REF_ART = A.REF
WHERE A.DESIGNATION LIKE '%boulon%';

-- l. Même chose mais je veux aussi le nom du fournisseur
SELECT DISTINCT B.NO_CMDE, F.NOM AS NOM_FOURNISSEUR
FROM BON B
JOIN LIGNE_BON LB ON B.NO_CMDE = LB.NO_CMDE
JOIN ARTICLE A ON LB.REF_ART = A.REF
JOIN FOURNISSEUR F ON A.ID_FOU = F.ID
WHERE A.DESIGNATION LIKE '%boulon%';

-- m. Prix total de chaque bon de commande (quantité x prix)
SELECT LB.NO_CMDE, SUM(LB.QUANTITE * A.PRIX) AS TOTAL
FROM LIGNE_BON LB
JOIN ARTICLE A ON LB.REF_ART = A.REF
GROUP BY LB.NO_CMDE;

-- n. Nombre d’articles par bon de commande
SELECT NO_CMDE, SUM(QUANTITE) AS NB_ARTICLES
FROM LIGNE_BON
GROUP BY NO_CMDE;

-- o. Les bons avec plus de 25 articles
SELECT NO_CMDE, SUM(QUANTITE) AS NB_ARTICLES
FROM LIGNE_BON
GROUP BY NO_CMDE
HAVING SUM(QUANTITE) > 25;

-- p. Coût total des commandes en avril
SELECT SUM(LB.QUANTITE * A.PRIX) AS TOTAL_AVRIL
FROM LIGNE_BON LB
JOIN ARTICLE A ON LB.REF_ART = A.REF
JOIN BON B ON B.NO_CMDE = LB.NO_CMDE
WHERE MONTH(B.DATE_CMDE) = 4 AND YEAR(B.DATE_CMDE) = 2019;

-- ------------ REQUÊTES FACULTATIVES ----------------

-- 3.a. Articles avec désignation identique mais fournisseurs différents
SELECT A1.REF, A1.DESIGNATION, A1.ID_FOU, A2.ID_FOU
FROM ARTICLE A1
JOIN ARTICLE A2 ON A1.DESIGNATION = A2.DESIGNATION AND A1.ID_FOU <> A2.ID_FOU;

-- 3.b. Dépenses par mois
SELECT MONTH(B.DATE_CMDE) AS MOIS, YEAR(B.DATE_CMDE) AS ANNEE, SUM(LB.QUANTITE * A.PRIX) AS TOTAL_MOIS
FROM LIGNE_BON LB
JOIN ARTICLE A ON LB.REF_ART = A.REF
JOIN BON B ON B.NO_CMDE = LB.NO_CMDE
GROUP BY YEAR(B.DATE_CMDE), MONTH(B.DATE_CMDE)
ORDER BY ANNEE, MOIS;

-- 3.c. Bons de commande sans article
SELECT * FROM BON B
WHERE NOT EXISTS (
  SELECT * FROM LIGNE_BON LB WHERE LB.NO_CMDE = B.NO_CMDE
);

-- 3.d. Prix moyen des bons de commande par fournisseur
SELECT F.ID, F.NOM, AVG(LB.QUANTITE * A.PRIX) AS MOYENNE_COMMANDE
FROM FOURNISSEUR F
JOIN ARTICLE A ON A.ID_FOU = F.ID
JOIN LIGNE_BON LB ON LB.REF_ART = A.REF
JOIN BON B ON B.NO_CMDE = LB.NO_CMDE
GROUP BY F.ID, F.NOM;

