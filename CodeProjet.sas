/************************************* DATA PREPROCESSING *************************************/

/* Create a library */

LIBNAME projet "/home/u62232366/Projet";

/* HTTP Request to download Data from the website (UCI Machine Learning) */
FILENAME donnees TEMP;
PROC HTTP URL = "https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"
	METHOD = "GET"
	OUT = donnees;
RUN;


/* Import Data */
PROC IMPORT FILE = donnees 
	DBMS = CSV 
	OUT = projet.donnees REPLACE;
	GUESSINGROWS=MAX;
	GETNAMES = NO;
RUN;



/* Delete missing Data*/

DATA projet.donnees;
SET projet.donnees;
IF VAR12 = "?" OR VARA13 = "?" THEN DELETE;


/* recoding categorical variables */

DATA projet.donnees;
SET projet.donnees;
LENGTH sexe $6. Angine $32. Glycemie $32. ECG $32. AngineApresSport $3. PenteECG $16. Fluoroscopie $32. Thalassemie $32. Maladie $3.;
IF VAR2 = 1 THEN sexe = "Homme";
IF VAR2 = 0 THEN sexe = "Femme";
IF VAR3 = 1 THEN Angine = "Angine stable";
IF VAR3 = 2 THEN Angine = "Angine instable";
IF VAR3 = 3 THEN Angine = "Douleur Non Angineuse";
IF VAR3 = 4 THEN Angine = "Asymptomatique";
IF VAR6 = 1 THEN Glycemie = "Glycémie > 120mg/dl";
IF VAR6 = 0 THEN Glycemie = "Glycémie < 120mg/dl";
IF VAR7 = 0 THEN ECG = "Normal";
IF VAR7 = 1 THEN ECG = "Anomalies";
IF VAR7 = 2 THEN ECG = "Hypertrophie";
IF VAR9 = 0 THEN AngineApresSport = "Non";
IF VAR9 = 1 THEN AngineApresSport = "Oui";
IF VAR11 = 1 THEN PenteECG = "En hausse";
IF VAR11 = 2 THEN PenteECG = "Stable";
IF VAR11 = 3 THEN PenteECG = "En baisse";
IF VAR12 = 0 THEN Fluoroscopie = "Absence d'anomalie";
IF VAR12 = 1 THEN Fluoroscopie = "Faible";
IF VAR12 = 2 THEN Fluoroscopie = "Moyen";
IF VAR12 = 3 THEN Fluoroscopie = "Élevé";
IF VAR13 = 3 THEN Thalassemie = "Absence d'anomalie";
IF VAR13 = 6 THEN Thalassemie = "Thalassémie sous contrôle";
IF VAR13 = 7 THEN Thalassemie = "Thalassémie instable";
IF VAR14 = 0 THEN Maladie = "Non";
IF VAR14 = 1 THEN Maladie = "Oui";
IF VAR14 = 2 THEN Maladie = "Oui";
IF VAR14 = 3 THEN Maladie = "Oui";
IF VAR14 = 4 THEN Maladie = "Oui";
IF VAR6 = 1 THEN Glycemie = "Glycémie > 120mg/dl";
IF VAR6 = 0 THEN Glycemie = "Glycémie < 120mg/dl";
IF VAR7 = 0 THEN ECG = "Normal";
IF VAR7 = 1 THEN ECG = "Anomalies";
IF VAR7 = 2 THEN ECG = "Hypertrophie";
IF VAR9 = 0 THEN AngineApresSport = "Non";
IF VAR9 = 1 THEN AngineApresSport = "Oui";
IF VAR11 = 1 THEN PenteECG = "En hausse";
IF VAR11 = 2 THEN PenteECG = "Stable";
IF VAR11 = 3 THEN PenteECG = "En baisse";
IF VAR12 = 0 THEN Fluoroscopie = "Absence d'anomalie";
IF VAR12 = 1 THEN Fluoroscopie = "Faible";
IF VAR12 = 2 THEN Fluoroscopie = "Moyen";
IF VAR12 = 3 THEN Fluoroscopie = "Élevé";
IF VAR13 = 3 THEN Thalassemie = "Absence d'anomalie";
IF VAR13 = 6 THEN Thalassemie = "Thalassémie sous contrôle";
IF VAR13 = 7 THEN Thalassemie = "Thalassémie instable";
IF VAR14 = 0 THEN Maladie = "Non";
IF VAR14 = 1 THEN Maladie = "Oui";
IF VAR14 = 2 THEN Maladie = "Oui";
IF VAR14 = 3 THEN Maladie = "Oui";
IF VAR14 = 4 THEN Maladie = "Oui";
DROP VAR2 VAR3 VAR6 VAR7 VAR9 VAR11 VAR12 VAR13 VAR14;

RUN;


/* Rename columns*/

DATA projet.donnees;
SET projet.donnees(rename = (
VAR1 = Age 
VAR4 = Tension 
VAR5 = Cholesterol 
VAR8 = FreqCardiaque 
VAR10 = AngineECG));
RUN;


/* Modify column order */
DATA projet.donnees;
RETAIN Age Sexe Angine Tension Cholesterol Glycemie ECG FreqCardiaque AngineApresSport AngineECG PenteECG Fluoroscopie Thalassemie Maladie;
SET projet.donnees;
RUN;

/* Display data set*/

PROC PRINT DATA = projet.donnees;
RUN;


/************************************* STATISTIC *************************************/


/* calcul des effectifs et des pourcentages */

PROC FREQ DATA = projet.donnees;
TITLE "Number and pourcentages of Sexe variable";
TABLE Sexe/NOCUM;
FOOTNOTE "Data : Clinique medicale de cleveland (US)";
RUN;


%MACRO effectifs_pourcentages(variable);
PROC FREQ DATA = projet.donnees;
TITLE "Number and percentages of &variable Variable";
TABLE &variable/NOCUM;
FRONTNOTE "Data : Clinique medicale de cleveland (US)";
RUN;
%MEND;

/* Appply Macro*/


%effectifs_pourcentages(Sexe);
%effectifs_pourcentages(Maladie);
%effectifs_pourcentages(Angine);

/* Descriptive Statistic for quntitatiive variables*/

%MACRO Stat_var_quantitat(var_quantitative);
PROC MEANS DATA = projet.donnees N MEAN STD MIN Q1 MEDIAN Q3 MAX MAXDEC= 2;
TITLE "Description of the statistic of variable &var_quantitative";
VAR &var_quantitative;
FOOTNOTE "Data : Clinique medicale de cleveland (US)";
RUN;
%MEND;

%Stat_var_quantitat(Age);
%Stat_var_quantitat(Tension);
%Stat_var_quantitat(Cholesterol);



/************************************* Representation graphique *************************************/

/********** Diadram a bar (Qualitative)***********/

%MACRO Diagram_Bar(var, color);
PROC SGPLOT DATA = projet.donnees;
VBAR &var / DATALABEL FILLATTRS = (COLOR = &color) OUTLINEATTRS = (COLOR = "green") CATEGORYORDER=respasc;
TITLE "Repartition de la population selon la variable &var";
FOOTNOTE "Data : Clinique medicale de cleveland (US)";
YAXIS LABEL = "Effectif";
RUN;
%MEND;


%Diagram_Bar(Thalassemie, "bigb");

%Diagram_Bar(Sexe, "pink");

%Diagram_Bar(Maladie, "bigb");

%Diagram_Bar(Angine, "VIPK");


/********** Histogram (Quantitative)***********/

/* Macro pour creer un histogramme pour une variable quantitative */

%MACRO Histogram(var, valeur_bimstar, valeur_bimwidth, color);
PROC SGPLOT DATA = projet.donnees;
HISTOGRAM &var / SCALE=count DATALABEL= count BINSTART= &valeur_bimstar Binwidth= &valeur_bimwidth SHOWBINS FILLATTRS = (COLOR = &color);
/*DENSITY &var; /* Densite de la loi normale*/
/*DENSITY &var /TYPE= kernel; /* Densite lissee */
/*KEYLEGEND / LOCATION = inside POSITION = topright ACROSS = 1 NOBORDER LINELENGTH = 20;*/
TITLE "Repartition de la population selon la variable &var";
FOOTNOTE "Data : Clinique medicale de cleveland (US)";
YAXIS LABEL = "Effectif";
RUN;
%MEND;

/*** Application de la macro ***/

%Histogram(Age, 20, 5, "bigb");
%Histogram(Tension, 20, 5, "pink");
%Histogram(Cholesterol, 110, 25, "lioy");



/********** Diadram a bar bi variee (Qualitative:  categorical variables)***********/

%MACRO Diagram_Bar_bivarie(var_interet, variable_explicative);
PROC SGPLOT DATA = projet.donnees;
VBAR &variable_explicative / GROUP= &var_interet DATALABEL GROUPDISPLAY=cluster;
TITLE "Repartition de la population selon la variable &variable_explicative et la variable &var_interet";
FOOTNOTE "Data : Clinique medicale de cleveland (US)";
YAXIS LABEL = "Effectif";
RUN;
%MEND;


%Diagram_Bar_bivarie(maladie, Sexe);




/* Macro pour creer /*une boite a moustache (Var quantitative et Var categorielle)*/

%MACRO boxplot(var_interet, variable_explicative);
PROC SGPLOT DATA = projet.donnees;
VBOX &variable_explicative / CATEGORY= &var_interet GROUP = &variable_explicative;
XAXIS DISCRETEORDER= data;
TITLE "Boite a moustache des patients selon la variable &variable_explicative et la variable &var_interet";
FOOTNOTE "Data : Clinique medicale de cleveland (US)";
/*KEYLEGEND / LOCATION = inside POSITION = topright ACROSS = 1 NOBORDER LINELENGTH = 20;*/
RUN;
%MEND;

/* Macro test*/

%boxplot(Maladie, Age);
%boxplot(Maladie, Tension);
%boxplot(Maladie, Cholesterol);



/************************************* Bivariate Analysis *************************************/

/*Macro pour creer un tableau croisé pour deux variables categorielles*/

%MACRO tableaux_croises(variable_interet, variable_explicative);
PROC TABULATE DATA = projet.donnees;
TITLE "Tableau croisé des variables &variable_interet et &variable_explicative (effectif et pourcentages)";
FOOTNOTE "Data : Clinique medicale de cleveland (US)";
CLASS &variable_explicative &variable_interet;
TABLE &variable_explicative, &variable_interet*(N ROWPCTN);
RUN;
%MEND;


/*Application de la Macro*/


%tableaux_croises(Maladie, Sexe);
%tableaux_croises(Maladie, Angine);
%tableaux_croises(Maladie, Glycemie);




/* Macro pour calculer les moyennes conditionnelles*/

%MACRO Moyennes_conditionnelles(var_interet, variable_explicative);
PROC MEANS DATA = projet.donnees MEAN MIN MEDIAN MAX MAXDEC= 2;
TITLE "Moyenne conditionnelle de la varialble &var_interet selon la variable &variable_explicative";
CLASS &var_interet;
VAR &variable_explicative;
FOOTNOTE "Data : Clinique medicale de cleveland (US)";
RUN;
%MEND;


/*Application de la Macro*/
%Moyennes_conditionnelles(Maladie, Age);
%Moyennes_conditionnelles(Maladie, Tension);
%Moyennes_conditionnelles(Maladie, Cholesterol);


/*Appliquer le test du Khi-deux

/* Hypothèse du test du khi-Deux:
H0 : Les deux variables sont independantes (si p-value > 0.05) 
H1 : Les deux variables sont dependantes (si p-value < 0.05) 
*/

%MACRO ki_deux(var_interet, variable_explicative);
PROC FREQ DATA = projet.donnees;
TABLES Sexe * Maladie / CHISQ;
TITLE "Test du Khi-Deux d'indépance entre la variable &variable_explicative et la variable &var_interet"
FOOTNOTE "Données : Clinique medicale de cleveland (US)";
RUN;



%ki_deux(Maladie, Sexe);
%ki_deux(Maladie, Aninge);
%ki_deux(Maladie, Glycemie);




/* Test de Shapiro-Wilk 
Hypothèse du test:
H0 : L'echantillon suit une distribution normale (si p-value > 0.05) 
H1 : L'echantillon ne suit pas une distribution normale (si p-value < 0.05) 
*/

%MACRO ShapiroWilk(Variable_a_tester);
PROC UNIVARIATE DATA = projet.donnees NORMAL;
TITLE "Test de Shapiro Wilk pour la variable &Variable_a_tester";
FOOTNOTE "Données : Clinique medicale de cleveland (US)";
VAR &Variable_a_tester;
RUN;
%MEND;

/* Appply Macro*/


%ShapiroWilk(Age);
%ShapiroWilk(Tension);
%ShapiroWilk(Cholesterol);




/************************************* MACHINE LEARNING *************************************/

/* Séparation du jeu de données en base d'apprentissage/entrainement et de test */
PROC SURVEYSELECT DATA = projet.donnees METHOD = SRS SEED = 2 OUTALL SAMPRATE = 0.8 OUT = projet.donnees2;
RUN;
PROC PRINT DATA = projet.donnees2;
RUN;

/* Création de la base d'apprentissage/entrainement */
DATA projet.train;
SET projet.donnees2;
IF selected = 1;
RUN;
PROC PRINT DATA = projet.train;
RUN;

/* Création de la base de test */
DATA projet.test;
SET projet.donnees2;
IF selected = 0;
RUN;
PROC PRINT DATA = projet.test;
RUN;

/* Modèle de régression logistique */
PROC LOGISTIC DATA = projet.train PLOTS = (oddsratio(cldisplay = serifarrow) roc);
TITLE "Modèle de régression logistique (Machine Learning)";
CLASS Sexe Angine Glycemie ECG AngineApresSport PenteECG Fluoroscopie Thalassemie / PARAM = glm;
MODEL Maladie(event = "Oui") = Sexe Angine Glycemie ECG AngineApresSport PenteECG Fluoroscopie Thalassemie Age Tension Cholesterol FreqCardiaque AngineECG / LINK = logit LACKFIT SELECTION = backward SLSTAY = 0.05 TECHNIQUE = fisher;
SCORE DATA = projet.test OUT = projet.predictions;
RUN;

/* Test de Hosmer et Lemeshow
Hypothèses :
H0 : L'ajustement du modèle aux données est bon (si p-value > 0,05)
H1 : L'ajustement du modèle aux données est mauvais (si p-value < 0,05)
Puisque la p-value est supérieure à 0.05, alors on choisit H0.
*/

/* Formatage du tableau contenant les prédictions */
DATA projet.predictions(DROP = Selected F_Maladie I_Maladie P_Non P_Oui);
SET projet.predictions;
LENGTH Prediction $5.;
IF P_Oui > 0.5 THEN Prediction = "Oui";
IF P_Oui < 0.5 THEN Prediction = "Non";
RUN;

/* Affichage de la matrice de confusion */
PROC TABULATE DATA = projet.predictions;
TITLE "Matrice de confusion";
CLASS Maladie Prediction;
TABLE (Maladie),(Prediction)*(N);
RUN;

/* Ajout d'une colonne interprétant les résultats */
DATA projet.predictions;
SET projet.predictions;
LENGTH Resultat $32.;
IF Maladie = "Oui" AND Prediction = "Oui" THEN Resultat = "Vrai positif";
IF Maladie = "Non" AND Prediction = "Non" THEN Resultat = "Vrai négatif";
IF Maladie = "Oui" AND Prediction = "Non" THEN Resultat = "Faux négatif";
IF Maladie = "Non" AND Prediction = "Oui" THEN Resultat = "Faux positif";
RUN;

/* Affichage des prédictions */
PROC PRINT DATA = projet.predictions;
RUN;




