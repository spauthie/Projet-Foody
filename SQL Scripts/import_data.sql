set global local_infile=1;

LOAD DATA LOCAL INFILE  'C:/Users/Stanislas/Simplon/SQL/Projet_Foody/data/categorie.csv'
INTO TABLE categorie
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/Stanislas/Simplon/SQL/Projet_Foody/data/client.csv'
INTO TABLE client
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/Stanislas/Simplon/SQL/Projet_Foody/data/commande.csv'
INTO TABLE commande
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/Stanislas/Simplon/SQL/Projet_Foody/data/detailsCommande.csv'
INTO TABLE detailcommande
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE  'C:/Users/Stanislas/Simplon/SQL/Projet_Foody/data/employe.csv'
INTO TABLE employe
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/Stanislas/Simplon/SQL/Projet_Foody/data/fournisseur.csv'
INTO TABLE fournisseur
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/Stanislas/Simplon/SQL/Projet_Foody/data/messager.csv'
INTO TABLE messager
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/Stanislas/Simplon/SQL/Projet_Foody/data/produit.csv'
INTO TABLE produit	
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;