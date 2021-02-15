CREATE DATABASE IF NOT EXISTS Foody;
USE Foody;

CREATE TABLE CLIENT (
  codeCli VARCHAR(10),
  societe VARCHAR(40),
  contact VARCHAR(40),
  fonction VARCHAR(40),
  adresse VARCHAR(100),
  ville VARCHAR(20),
  region VARCHAR(20),
  codepostal VARCHAR(15),
  pays VARCHAR(20),
  tel VARCHAR(20),
  fax VARCHAR(20),
  PRIMARY KEY (codeCli)
);

CREATE TABLE COMMANDE (
  noCom INT NOT NULL AUTO_INCREMENT,
  codeCli VARCHAR(10),
  noEmp INT,
  dateCom DATETIME,
  alivAvant DATETIME,
  dateEnv DATETIME,
  noMess INT,
  portt FLOAT,
  destinataire VARCHAR(40),
  adrliv VARCHAR(100),
  villeliv VARCHAR(20),
  regionliv VARCHAR(20),
  codepostalliv VARCHAR(20),
  paysliv VARCHAR(20),
  PRIMARY KEY (noCom)
);

CREATE TABLE DETAILCOMMANDE (
  noCom INT NOT NULL AUTO_INCREMENT,
  refPro INT,
  prixUnit FLOAT,
  qte INT,
  remise FLOAT,
  PRIMARY KEY (Nocom, refpro)
);

CREATE TABLE PRODUIT (
  refPro INT NOT NULL AUTO_INCREMENT,
  nomProd VARCHAR(40),
  noFour INT,
  codeCateg INT,
  qteparunit VARCHAR(40),
  prixUnit FLOAT,
  unitesstock INT,
  unitescom INT,
  niveaureap INT,
  indisponible INT,
  PRIMARY KEY (refPro)
);

CREATE TABLE FOURNISSEUR (
  noFour INT NOT NULL AUTO_INCREMENT,
  societe VARCHAR(40),
  contact VARCHAR(40),
  fonction VARCHAR(40),
  adresse VARCHAR(100),
  ville VARCHAR(20),
  region VARCHAR(20),
  codepostal VARCHAR(20),
  pays VARCHAR(20),
  tel VARCHAR(20),
  fax VARCHAR(20),
  pageaccueil VARCHAR(100),
  PRIMARY KEY (noFour)
);

CREATE TABLE MESSAGER (
  noMess INT NOT NULL AUTO_INCREMENT,
  nomMess VARCHAR(40),
  tel VARCHAR(20),
  PRIMARY KEY (noMess)
);

CREATE TABLE EMPLOYE (
  noEmp INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(25),
  prenom VARCHAR(25),
  fonction VARCHAR(40),
  titrecourtoisie VARCHAR(10),
  datenaissance DATETIME,
  dateembauche DATETIME,
  adresse VARCHAR(40),
  ville VARCHAR(20),
  region VARCHAR(20),
  codepostal VARCHAR(20),
  pays VARCHAR(20),
  teldom VARCHAR(20),
  extension INT,
  rendCompteA INT,
  PRIMARY KEY (noEmp)
);

CREATE TABLE CATEGORIE (
  codeCateg INT NOT NULL AUTO_INCREMENT,
  nomCateg VARCHAR(40),
  description VARCHAR(100),
  PRIMARY KEY (codeCateg)
);

ALTER TABLE COMMANDE ADD FOREIGN KEY (codeCli) REFERENCES CLIENT (codeCli);
ALTER TABLE COMMANDE ADD FOREIGN KEY (noEmp) REFERENCES EMPLOYE (noEmp);
ALTER TABLE COMMANDE ADD FOREIGN KEY (noMess) REFERENCES MESSAGER (noMess);

ALTER TABLE DETAILCOMMANDE ADD FOREIGN KEY (refPro) REFERENCES PRODUIT (refPro);
ALTER TABLE DETAILCOMMANDE ADD FOREIGN KEY (noCom) REFERENCES COMMANDE (noCom);

ALTER TABLE PRODUIT ADD FOREIGN KEY (codeCateg) REFERENCES CATEGORIE (codeCateg);
ALTER TABLE PRODUIT ADD FOREIGN KEY (noFour) REFERENCES FOURNISSEUR (noFour);

ALTER TABLE EMPLOYE ADD FOREIGN KEY (rendCompteA) REFERENCES EMPLOYE (noEmp);