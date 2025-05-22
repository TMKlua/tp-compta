-- a. Je récupère toutes les infos des articles
SELECT * FROM ARTICLE;

-- b. Je veux juste les références et les noms des articles à plus de 2€
SELECT REF, DESIGNATION FROM ARTICLE
WHERE PRIX > 2;

-- c. Je cherche les articles entre 2€ et 6.25€ (version avec >= et <=)
SELECT * FROM ARTICLE
WHERE PRIX >= 2 AND PRIX <= 6.25;

-- d. Même requête qu’au-dessus mais avec BETWEEN (c’est plus opti)
SELECT * FROM ARTICLE
WHERE PRIX BETWEEN 2 AND 6.25;

-- e. Je veux les articles qui NE sont PAS entre 2 et 6.25€ ET qui viennent de Française d’Imports, triés du + cher au - cher
SELECT * FROM ARTICLE
WHERE (PRIX < 2 OR PRIX > 6.25)
AND ID_FOU = (
  SELECT ID FROM FOURNISSEUR WHERE NOM = 'Française d’Imports'
)
ORDER BY PRIX DESC;

-- f. Je liste les articles dont le fournisseur est Française d’Imports OU Dubois & Fils (version avec OR)
SELECT * FROM ARTICLE
WHERE ID_FOU = (SELECT ID FROM FOURNISSEUR WHERE NOM = 'Française d’Imports')
   OR ID_FOU = (SELECT ID FROM FOURNISSEUR WHERE NOM = 'Dubois & Fils');

-- g. Même chose mais cette fois avec IN (plus pratique)
SELECT * FROM ARTICLE
WHERE ID_FOU IN (
  SELECT ID FROM FOURNISSEUR
  WHERE NOM IN ('Française d’Imports', 'Dubois & Fils')
);

-- h. Là je veux l’inverse : les articles dont le fournisseur N’EST PAS Française d’Imports NI Dubois & Fils
SELECT * FROM ARTICLE
WHERE ID_FOU NOT IN (
  SELECT ID FROM FOURNISSEUR
  WHERE NOM IN ('Française d’Imports', 'Dubois & Fils')
);

-- i. Je récupère les bons de commande passés entre le 1er février et le 30 avril 2019
SELECT * FROM BON
WHERE DATE_CMDE BETWEEN '2019-02-01' AND '2019-04-30';
