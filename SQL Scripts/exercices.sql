#1.Afficher les 10 premiers éléments de la table Produit triés par leur prix unitaire
SELECT * FROM produit ORDER BY prixUnit LIMIT 10;

#2.Afficher les trois produits les plus chers
SELECT * FROM produit ORDER BY prixUnit DESC LIMIT 3;


-------------------------------------------------- I.2- Restriction
#1.Lister les clients français installés à Paris dont le numéro de fax n'est pas renseigné
SELECT * FROM client WHERE (fax IS NULL) and (ville='Paris');

#2.Lister les clients français, allemands et canadiens
SELECT * FROM client WHERE pays IN ('France','Germany','Canada');

#3.Lister les clients dont le nom contient "restaurant" (nom présent dans la colonne Societe/CompanyName)
SELECT * FROM client WHERE societe LIKE '%restaurant%';


-------------------------------------------------- I.3- Projection
#1.Lister uniquement la description des catégories de produits (table Categorie)
SELECT description FROM categorie;

#2.Lister les différents pays des clients
SELECT DISTINCT pays FROM client WHERE pays IS NOT NULL;

#3.Idem en ajoutant les villes, le tout trié par ordre alphabétique du pays et de la ville
SELECT DISTINCT pays, ville FROM client WHERE pays IS NOT NULL ORDER BY pays,ville;

#4.Lister tous les produits vendus en bouteilles (bottle) ou en canettes(can)
SELECT * FROM produit WHERE (qteparunit LIKE '%can%') OR (qteparunit LIKE '%bottle%');

#5.Lister les fournisseurs français, en affichant uniquement le nom, le contact et la ville, triés par ville
SELECT societe, contact, ville FROM fournisseur WHERE pays ='FRANCE' ORDER BY ville;

#6.Lister les produits (nom en majuscule et référence) du fournisseur n° 8 
-- dont le prix unitaire est entre 10 et 100 euros, en renommant les attributs pour que ça soit explicite
SELECT refPro, UPPER(nomProd) 
FROM produit
WHERE (noFour=8) AND (prixUnit BETWEEN 10 AND 100) ;

#7.Lister les numéros d'employés ayant réalisé une commande (cf table Commande) 
-- à livrer en France, à Lille, Lyon ou Nantes
SELECT noEmp FROM commande WHERE villeliv IN ('Lille','Lyon','Nantes');

#8.Lister les produits dont le nom contient le terme "tofu" ou le terme "choco", 
-- dont le prix est inférieur à 100 euros (attention à la condition à écrire)
SELECT * FROM produit WHERE (nomProd LIKE '%tofu%' OR nomProd LIKE '%choco%') AND (prixUnit <100);


-------------------------------------- II.1- Calculs arithmétiques
/* La table DetailsCommande contient l'ensemble des lignes d'achat de chaque commande. 
Calculer, pour la commande numéro 10251, pour chaque produit acheté dans celle-ci, le montant de la ligne d'achat
en incluant la remise (stockée en proportion dans la table). Afficher donc (dans une même requête) :
- le prix unitaire,
- la remise,
- la quantité,
- le montant de la remise,
- le montant à payer pour ce produit */
SELECT refPro, prixUnit, remise, qte, ROUND((remise*(prixUnit*qte)),2) AS 'Montant_Remise', 
ROUND((prixUnit*qte) - (remise*(prixUnit*qte)), 2) AS 'Prix à Payer'
FROM detailcommande
WHERE noCom = 10251;

-------------------------------------------------------------- II.2- Traitement conditionnel
# 1. A partir de la table Produit, afficher "Produit non disponible" 
-- lorsque l'attribut Indisponible vaut 1, et "Produit disponible" sinon.

SELECT refPro, nomProd,
	CASE indisponible 
		WHEN 1 THEN "Produit non disponible"
        ELSE "Produit disponible"
	END AS Disponibilité
FROM produit;


/* 2.Dans la table DetailsCommande, indiquer les infos suivantes en fonction de la remise
 - si elle vaut 0 : "aucune remise"
 - si elle vaut entre 1 et 5% (inclus) : "petite remise"
 - si elle vaut entre 6 et 15% (inclus) : "remise modérée"
 - sinon :"remise importante" */
 
 SELECT *,
	CASE 
		WHEN remise = 0 THEN "Aucune remise"
        WHEN remise < 0.050001 THEN "Petite remise"
        WHEN remise < 0.150001 THEN "Remise modérée"
        ELSE "Remise importante"
	END AS Solde
FROM detailcommande;
 
 
# 3.Indiquer pour les commandes envoyées si elles ont été envoyées en retard 
-- (date d'envoi DateEnv supérieure (ou égale) à la date butoir ALivAvant) ou à temps
SELECT noCom, codeCli, alivAvant,dateEnv,
	CASE
		WHEN dateEnv >= alivAvant THEN 'En retard'
        ELSE 'Dans les temps'
	END AS Info_Livraison
FROM commande;


----------------------------------------- II.3- Fonctions sur chaînes de caractères
/* Dans une même requête, sur la table Client :
1.Concaténer les champs Adresse, Ville, CodePostal et Pays dans un nouveau
champ nommé Adresse complète, pour avoir :
Adresse, CodePostal Ville, Pays
2.Extraire les deux derniers caractères des codes clients
3.Mettre en minuscule le nom des sociétés
4.Remplacer le terme "Owner" par "Freelance" dans ContactTitle
5.Indiquer la présence du terme "Manager" dans ContactTitle */

 SELECT RIGHT(codeCli,2) AS 'CodeClient', LOWER(societe) AS 'Nom Sociétés',
 REPLACE (fonction, 'Owner','Freelance') AS ContactTitle,
	CASE
		WHEN INSTR(fonction, "Manager") THEN 'Oui'
        ELSE 'Non'
	END Manager,
 CONCAT(adresse,", ",codepostal," ",ville,", ",UPPER(pays)) AS 'Adresse complète'
 FROM client;


-------------------------------------------- II.4- Fonctions sur les dates
# 1.Afficher le jour de la semaine en lettre pour toutes les dates de commande, 
-- afficher "week-end" pour les samedi et dimanche.
SELECT noCom,codeCli,dateCom,
	CASE
		WHEN (DAYNAME(dateCom) = 'Sunday') OR (DAYNAME(dateCom) = 'Saturday') THEN 'Week-end'
        ELSE DAYNAME(dateCom)
	END AS Jour_Commande
FROM commande;


# 2.Calculer le nombre de jours entre la date de la commande (DateCom) et la date butoir de livraison (ALivAvant), 
-- pour chaque commande, On souhaite aussi contacter les clients 1 mois après leur commande. 
-- ajouter la date correspondante pour chaque commande
SELECT noCom,codeCli,dateCom,alivAvant, DATEDIFF(AlivAvant,dateCom) AS 'Temps Max pour la livraison',
DATE_ADD(dateCom, INTERVAL 1 MONTH) AS 'dateContactClient'
FROM commande;

#Bonus :
#1.Récupérer l'année de naissance et l'année d'embauche des employés
SELECT noEmp, nom, prenom, fonction, YEAR(datenaissance),YEAR(dateembauche) FROM employe;

#2.Calculer à l'aide de la requête précédente l'âge d'embauche et le nombre d'années dans l'entreprise
SELECT noEmp, nom, prenom, fonction, TIMESTAMPDIFF(YEAR, datenaissance,dateembauche) AS 'Age When Hired' ,
TIMESTAMPDIFF (YEAR, dateembauche, CURDATE()) AS 'Years in Company'
FROM employe;

#3.Afficher le prix unitaire original, la remise en pourcentage, le montant de la remise et le prix unitaire avec
-- remise (tous deux arrondis aux centimes), pour les lignes de commande dont la remise est strictement supérieure a 10%
SELECT noCom, refPro, prixUnit,qte, ROUND(remise*100) AS 'Remise en %', 
ROUND((remise*(prixUnit*qte)),2) AS 'Montant Remise',
ROUND(prixUnit-(prixUnit*remise),2) AS 'Prix unitaire aprés remise'
FROM detailcommande
WHERE remise > 0.1 ;

#4.Calculer le délai d'envoi (en jours) pour les commandes dont l'envoi est après la date butoir, 
-- ainsi que le nombre de jours de retard
SELECT noCom, codeCli, dateCom, alivAvant, dateEnv, DATEDIFF(dateEnv,dateCom) AS "Délai d'envoi", DATEDIFF(dateEnv,alivAvant) AS "Jours de retard"
FROM commande
WHERE dateEnv > alivAvant;

#5.Rechercher les sociétés clientes, dont le nom de la société contient le nom du contact de celle-ci
SELECT * FROM client WHERE INSTR(societe, contact);


----------------------------------------------- III- Aggrégats
#1.Calculer le nombre d'employés qui sont "Sales Manager"
SELECT COUNT(fonction) AS 'Nb employé "Sales Manager"' FROM employe WHERE fonction = 'Sales Manager';

#2.Calculer le nombre de produits de moins de 50 euros
SELECT COUNT(prixUnit) AS 'Nb produits -50e' FROM produit WHERE prixUnit<50;

#3.Calculer le nombre de produits de catégorie 2 et avec plus de 10 unités en stocks
SELECT COUNT(codeCateg) 'Nb Produits' FROM produit 
WHERE (codeCateg = 2) AND (unitesstock > 10);

#4.Calculer le nombre de produits de catégorie 1, des fournisseurs 1 et 18
SELECT COUNT(codeCateg) 'Nb Produits' FROM produit 
WHERE (codeCateg = 1) AND (noFour = 1 OR noFour=18);

#5.Calculer le nombre de pays différents de livraison
SELECT COUNT(DISTINCT paysliv) FROM commande;

#6.Calculer le nombre de commandes réalisées en Aout 2006.
SELECT COUNT(dateCom) AS 'Nb Commandes Aout 2006' FROM commande 
WHERE MONTH(dateCom)='08' AND YEAR(dateCom)='2006';


----------------------------------------------------- III.2- Calculs statistiques simples
# 1.Calculer le coût du port minimum et maximum des commandes , 
-- ainsi que le coût moyen du port pour les commandes du client dont le code est "QUICK" (attribut CodeCli)
SELECT min(portt) AS ' Frais de Port Minimum', max(portt) AS 'Frais de Port Maximum', 
	(SELECT ROUND(AVG(portt),2) FROM commande WHERE codeCli='QUICK') AS'Moyenne Frais de port pour "Quick"'
FROM commande;

# 2.Pour chaque messager (par leur numéro : 1, 2 et 3), 
-- donner le montant total des frais de port leur correspondant
SELECT noMess, ROUND(SUM(portt)) AS 'Frais de port Tot' FROM commande GROUP BY noMess;



----------------------------------------------- III.3- Agrégats selon attribut(s)
#1.Donner le nombre d'employés par fonction
SELECT count(noEmp) AS 'NB Employé', fonction FROM employe GROUP BY fonction;

#2.Donner le montant moyen du port par messager(shipper)
SELECT noMess, ROUND(AVG(portt),1) As 'Frais de port moyen' FROM commande GROUP BY noMess;

#3.Donner le nombre de catégories de produits fournis par chaque fournisseur
SELECT noFour, COUNT(refPro) AS 'Nb produits/fournisseur' FROM produit GROUP BY noFour;

#4.Donner le prix moyen des produits pour chaque fournisseur et 
-- chaque catégorie de produits fournis par celui-ci
SELECT noFour, codeCateg, ROUND(AVG(prixUnit),2) AS 'Prix Moyen produits' 
FROM produit GROUP BY noFour, codeCateg;

-------------------------------------------- III.4- Restriction sur agrégats
# 1.Lister les fournisseurs ne fournissant qu'un seul produit
SELECT noFour FROM produit GROUP BY noFour HAVING COUNT(noFour)=1;

# 2.Lister les catégories dont les prix sont en moyenne supérieurs strictement à 50 euros
SELECT codeCateg FROM produit GROUP BY codeCateg HAVING AVG(prixUnit) >50;

# 3.Lister les fournisseurs ne fournissant qu'une seule catégorie de produits
SELECT noFour FROM produit GROUP BY noFour HAVING COUNT(DISTINCT codeCateg)=1;

# 4.Lister le Products le plus cher pour chaque fournisseur, pour les Products de plus de 50 euro
SELECT noFour, refPro, nomProd, MAX(prixUnit) AS 'Most Expensive'
FROM produit
GROUP BY noFour
HAVING MAX(prixUnit)>50;


----------- Bonus :
# 1.Donner la quantité totale commandée par les clients, pour chaque produit
SELECT refPro, SUM(qte) as "Quantité totale commandée"
FROM detailcommande
GROUP BY refPro;

# 2.Donner les cinq clients avec le plus de commandes, triés par ordre décroissant
SELECT codeCli, COUNT(codeCli) AS 'Cinq Clients + Commandes'
FROM commande
GROUP BY codeCli
ORDER BY 2 DESC
LIMIT 5;

# 3.Calculer le montant total des lignes d'achats de chaque commande, sans et avec remise sur les produits
SELECT noCom, remise, ROUND(prixUnit*qte,2) AS 'Montant total sans remise', 
ROUND((prixUnit*qte) * (1 - remise),2) AS 'Montant total avec remise'
FROM detailcommande; 

# 4.Pour chaque catégorie avec au moins 10 produits, calculer le montant moyen des prix
SELECT codeCateg, COUNT(codeCateg) AS 'Nb Produits/Cat' ,ROUND(AVG(prixUnit),2) AS "Prix Moyen/Cat"
FROM produit
GROUP BY codeCateg
HAVING COUNT(codeCateg)>=10;

# 5.Donner le numéro de l'employé ayant fait le moins de commandes
SELECT noEmp, COUNT(noEmp) AS 'Nb Commandes'
FROM commande
GROUP BY noEmp
ORDER BY 2
LIMIT 1;


-------------------------------------- IV- Jointures
#1.Récupérer les informations des fournisseurs pour chaque produit
SELECT * FROM produit NATURAL JOIN fournisseur;

#2.Afficher les informations des commandes du client "Lazy K Kountry Store"
SELECT * FROM commande NATURAL JOIN client WHERE societe = 'Lazy K Kountry Store';

#3.Afficher le nombre de commande pour chaque messager (en indiquant son nom)
SELECT noMess, nomMess, COUNT(noCom) AS 'Nb commandes'
FROM commande NATURAL JOIN messager
GROUP BY noMess;


----------------------------------------- IV.2- Jointures internes
# 1.Récupérer les informations des fournisseurs pour chaque produit, avec une jointure interne
SELECT *
FROM produit INNER JOIN fournisseur USING (noFour);

# 2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec une jointure interne
SELECT * 
FROM commande INNER JOIN client USING (codeCli)
WHERE client.societe = 'Lazy K Kountry Store';

# 3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec une jointure interne
SELECT noMess, nomMess, COUNT(noCom) AS 'Nb commandes'
FROM commande INNER JOIN messager USING (noMess)
GROUP BY noMess;


----------------------------------------- IV.3- Jointures externes
# 1.Compter pour chaque produit, le nombre de commandes où il apparaît, même pour ceux dans aucune commande
SELECT nomProd, COUNT(DISTINCT noCom) AS 'Nb_Commandes'
FROM produit LEFT OUTER JOIN detailcommande USING (refPro)
GROUP BY nomProd;

# 2.Lister les produits n'apparaissant dans aucune commande
SELECT P.*
FROM produit P LEFT OUTER JOIN detailcommande DC USING (refPro)
GROUP BY refPro
HAVING COUNT(noCom) = 0 ;

# 3.Existe-t'il un employé n'ayant enregistré aucune commande ?
SELECT noEmp, nom, prenom
FROM employe LEFT OUTER JOIN commande USING (noEmp)
GROUP BY noEmp
HAVING COUNT(noCom) = 0;


-------------------------------------------- IV.4- Jointures à la main
#1.Récupérer les informations des fournisseurs pour chaque produit, avec jointure à la main
SELECT P.*, F.*
FROM fournisseur F, produit P
WHERE F.noFour=P.noFour;

#2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec jointure à la main
SELECT *
FROM commande, client
WHERE commande.codeCli = client.codeCli 
AND client.societe = "Lazy K Kountry Store";

#3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec jointure à la main
 SELECT M.noMess, nomMess, COUNT(noCom) AS 'Nb Commandes'
 FROM messager M, commande C
 WHERE M.noMess = C.noMess
 GROUP BY M.noMess;


-------------------------------------- Bonus
#1.Compter le nombre de produits par fournisseur
SELECT F.noFour, F.societe, COUNT(refPro) AS 'Nb_Produits'
FROM fournisseur F, produit P
WHERE F.noFour = P.noFour
GROUP BY F.noFour;

#2.Compter le nombre de produits par pays d'origine des fournisseurs
SELECT pays, COUNT(refPro) AS 'Nb Produits'
FROM fournisseur NATURAL JOIN produit
GROUP BY pays;

#3.Compter pour chaque employé le nombre de commandes gérées, même pour ceux n'en ayant fait aucune
SELECT noEmp,nom, prenom, COUNT(noCom) AS "Nb Commandes Gérées"
FROM employe LEFT OUTER JOIN commande USING (noEmp)
GROUP BY noEmp;

#4.Afficher le nombre de pays différents des clients pour chaque employe (en indiquant son nom et son prénom)
SELECT E.noEmp, E.nom, E.prenom, COUNT(DISTINCT client.pays) AS 'Nb pays différents'
FROM employe E, commande C, client
WHERE E.noEmp = C.noEmp AND C.codeCli = client.codeCli
GROUP BY noEmp;

#5.Compter le nombre de produits commandés pour chaque client pour chaque catégorie
SELECT client.codeCli, client.societe, P.codeCateg, CA.nomCateg, COUNT(DC.refPro) AS 'Nb produits commandés'
FROM client, commande C, detailcommande DC,  produit P, categorie CA
WHERE client.codeCli = C.codeCli 
AND C.noCom=DC.noCom 
AND DC.refPro = P.refPro
AND P.codeCateg = CA.codeCateg
GROUP BY P.codeCateg, client.CodeCli
ORDER BY client.codeCli, P.codeCateg;


----------------------------------------------------- V- Sous-requêtes
#1.Lister les employés n'ayant jamais effectué une commande, via une sous-requête
SELECT noEmp, nom, prenom
FROM employe
WHERE noEmp NOT IN (SELECT noEmp FROM commande);

#2.Nombre de produits proposés par la société fournisseur "Ma Maison", via une sous-requête
SELECT count(noFour) AS 'Nb produits proposés'
FROM produit
WHERE noFour IN (SELECT noFour FROM fournisseur WHERE societe ='Ma Maison');

#3.Nombre de commandes passées par des employés sous la responsabilité de "Buchanan Steven"
SELECT COUNT(noEmp) AS 'Nb commandes passées'
FROM commande
WHERE noEmp IN (SELECT noEmp FROM employe WHERE rendCompteA = 
(SELECT noEmp FROM Employe WHERE nom = "Buchanan" AND prenom= "Steven"));


-------------------------------------------------------------- V.2- Opérateur EXISTS

#1.Lister les produits n'ayant jamais été commandés, à l'aide de l'opérateur EXISTS
SELECT refPro, nomProd
FROM produit
WHERE NOT EXISTS (
	SELECT * 
    FROM detailcommande 
    WHERE produit.refPro = detailcommande.refPro);

#2.Lister les fournisseurs dont au moins un produit a été livré en France
SELECT noFour, societe
FROM fournisseur F
WHERE EXISTS(
	SELECT *
    FROM produit P, commande C, detailcommande DC
    WHERE P.noFour = F.noFour AND P.refPro = DC.refPro 
    AND C.noCom = DC.noCom
    AND C.paysliv = 'France');

#3.Liste des fournisseurs qui ne proposent que des boissons (drinks)
SELECT noFour, societe
FROM fournisseur F
WHERE EXISTS (
	SELECT *
    FROM produit P, categorie CA
    WHERE F.noFour = P.noFour AND P.codeCateg=CA.codeCateg 
    AND CA.nomCateg = 'drinks')
AND NOT EXISTS (
	SELECT *
    FROM produit P, categorie CA
    WHERE F.noFour = P.noFour AND P.codeCateg=CA.codeCateg 
    AND CA.nomCateg != 'drinks');
    

----------------------------------------------- Bonus :
#1.Lister les clients qui ont commandé du "Camembert Pierrot" (sans aucune jointure)
SELECT * FROM client WHERE codeCli IN (
	SELECT codeCli FROM commande WHERE noCom IN (
		SELECT noCom FROM detailcommande WHERE refPro IN (
			SELECT refPro FROM produit WHERE nomProd = 'Camembert Pierrot' )));

#2.Lister les fournisseurs dont aucun produit n'a été commandé par un client français
SELECT * 
FROM fournisseur F
WHERE NOT EXISTS (
	SELECT *
    FROM client Cl, produit P, commande C, detailcommande DC
    WHERE F.noFour = P.noFour AND P.refPro = DC.refPro AND DC.noCom=C.noCom AND C.codeCli = Cl.codeCli
    AND Cl.pays = 'France');

#3.Lister les clients qui ont commande tous les produits du fournisseur "Exotic liquids"
SELECT Cl.*
FROM client Cl, produit P, commande C, detailcommande DC, fournisseur F
WHERE F.noFour = P.noFour AND P.refPro = DC.refPro AND DC.noCom=C.noCom AND C.codeCli = Cl.codeCli
AND F.societe = "Exotic liquids"
GROUP BY Cl.codeCli
HAVING COUNT(DISTINCT P.refPro) = (
	SELECT COUNT(*)
	FROM produit P, fournisseur F
	WHERE F.noFour = P.noFour
    AND societe = "Exotic liquids");

#4.Quel est le nombre de fournisseurs n’ayant pas de commandes livrées au Canada ?
SELECT COUNT(F.noFour) AS 'Nb fournisseurs'
FROM fournisseur F
WHERE NOT EXISTS (
	SELECT * 
    FROM produit P, detailcommande DC,commande C
    WHERE F.noFour = P.noFour AND P.refPro = DC.refPro AND DC.noCom=C.noCom 
    AND C.paysliv = 'Canada');

#5.Lister les employés ayant une clientèle sur tous les pays
SELECT E.noEmp, E.nom, E.prenom
FROM employe E, client Cl, commande C 
WHERE E.noEmp = C.noEmp AND Cl.codeCli = C.codeCli
GROUP BY noEmp
HAVING COUNT(DISTINCT paysliv) = (
	SELECT COUNT(DISTINCT pays) FROM client WHERE pays IS NOT NULL);
    

-------------------------------------------------- VI- Opérations Ensemblistes
#1.Lister les employés (nom et prénom) étant "Representative" ou étant basé au Royaume-Uni (UK)
SELECT nom, prenom FROM employe WHERE fonction LIKE ('%Representative%')
UNION
SELECT nom,prenom FROM employe WHERE pays='UK';

#2.Lister les clients (société et pays) ayant commandés via un employé situé
-- à Londres ("London" pour rappel) ou ayant été livré par "Speedy Express"
SELECT Cl.societe, Cl.pays 
FROM client Cl, commande C, employe E
WHERE Cl.codeCli = C.codeCli AND E.noEmp = C.noEmp
AND E.ville = 'London'
UNION
SELECT Cl.societe, Cl.pays 
FROM client Cl, commande C, messager M
WHERE Cl.codeCli = C.codeCli AND M.noMess = C.noMess
AND M.nomMess = "Speedy Express";


----------------------------------------------------- VI.2- Intersection
#1.Lister les employés (nom et prénom) étant "Representative" et étant basé au Royaume-Uni (UK)
SELECT nom, prenom 
FROM employe 
WHERE fonction LIKE ('%Representative%')
AND (nom, prenom) IN (SELECT nom,prenom FROM employe WHERE pays='UK');

#2.Lister les clients (société et pays) ayant commandés via un employé basé à "Seattle" 
-- et ayant commandé des "Desserts"
SELECT Cl.societe, Cl.pays  
FROM client Cl, commande C, employe E
WHERE Cl.codeCli = C.codeCli AND E.noEmp = C.noEmp
AND E.ville = 'Seattle'
AND (Cl.societe, Cl.pays) IN (
	SELECT Cl.societe, Cl.pays
	FROM Client Cl, Commande Co, DetailCommande DC,
	Produit P, Categorie Ca
    WHERE Co.NoCom = DC.NoCom AND Cl.CodeCli = Co.CodeCli AND P.CodeCateg = Ca.CodeCateg AND DC.refPro = P.refPro
    AND NomCateg = "Desserts")
GROUP BY societe;
    

----------------------------------------------------- VI.3- Différence
#.Lister les employés (nom et prénom) étant "Representative" mais n'étant pas basé au Royaume-Uni (UK)
SELECT nom, prenom 
FROM employe 
WHERE fonction LIKE ('%Representative%')
AND (nom, prenom) NOT IN (SELECT nom,prenom FROM employe WHERE pays='UK');

#2.Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel) 
-- et n'ayant jamais été livré par "United Package"
SELECT Cl.societe, Cl.pays  
FROM client Cl, commande C, employe E
WHERE Cl.codeCli = C.codeCli AND E.noEmp = C.noEmp
AND E.ville = 'London'
AND (Cl.societe, Cl.pays) NOT IN (
	SELECT Cl.societe, Cl.pays 
	FROM client Cl, commande C, messager M
	WHERE Cl.codeCli = C.codeCli AND M.noMess = C.noMess
	AND M.nomMess = "United Package");

----------------------------------------- Bonus
#1.Lister les employés ayant déjà pris des commandes de "Boissons" ou ayant envoyés 
-- une commande via "Federal Shipping"
SELECT E.noEmp, E.nom, E.prenom 
FROM employe E, commande C, detailcommande DC, produit P, categorie CA
WHERE E.noEmp = C.noEmp AND C.noCom=DC.noCom AND DC.refPro=P.refPro AND P.codeCateg=CA.codeCateg
AND CA.nomCateg='drinks'
	UNION
SELECT E.noEmp, E.nom, E.prenom 
FROM employe E, commande C, messager M
WHERE E.noEmp = C.noEmp AND M.noMess = C.noMess
AND M.nomMess = "Federal Shipping"
ORDER BY noEmp;

#2.Lister les produits de fournisseurs canadiens et ayant été commandé par des clients du "Canada"
SELECT P.nomProd
FROM fournisseur F, produit P
WHERE F.noFour=P.noFour
AND F.pays='Canada' AND P.nomProd IN(
	SELECT P.nomProd
    FROM produit P, client Cl, detailcommande DC, commande C
    WHERE F.noFour=P.noFour AND P.refPro=DC.refPro AND DC.noCom=C.noCom AND C.codeCli = Cl.codeCli
    AND Cl.pays = 'Canada');


#3.Lister les clients (Société) qui ont commandé du "Konbu" mais pas du "Tofu"
SELECT DISTINCT Cl.codeCli, Cl.societe
FROM Client Cl, Commande C, DetailCommande DC, Produit P
WHERE Cl.CodeCli = C.CodeCli AND C.noCom = DC.noCom AND DC.refPro = P.refPro 
AND NomProd = "Konbu"
AND (Cl.codeCli, Cl.societe) NOT IN(
	SELECT Cl.codeCli, Cl.societe
	FROM Client Cl, Commande C, DetailCommande DC, Produit P
	WHERE Cl.CodeCli = C.CodeCli AND C.noCom = DC.noCom AND DC.refPro = P.refPro 
	AND NomProd = "Tofu");

    
    
----------------- DONE