import static javax.swing.JOptionPane.*; //<>//

// Varibales globales

String titre;
final int taillecase = 10;
int nbLignes;
int nbColonnes;
int nbcasesinitiales;
int longueurTableau;
int largeurTableau;
int[][] nbVoisins;
boolean[][] isAlive;
final color BLANC = color(255);
final color NOIR = color(0);
boolean pause = true;

menu BoutonStart = new menu (10, 150, 180, 30, "Start");
menu BoutonSimulerEtape = new menu (10, 250, 180, 30, "Simuler étape / Stop");
menu BoutonReDemarre = new menu (10, 350, 180, 30, "ReDemarre");
menu BoutonQuitter = new menu (10, 450, 180, 30, "Quitter");
menu BoutonFichier = new menu (10, 50, 180, 30, "Modifier Grille");
menu BoutonSave = new menu (10, 550, 180, 30, "Sauvegarder");

// On vérifie si on se trouve dans une position valide dans le tableau 
boolean positionValide(int ligne, int colonne) {
  return 0 <= ligne
    && ligne <nbLignes
    && 0<=colonne
    && colonne <nbColonnes;
}

void chargerFichier(String nomFichier) {

  String[] lines = loadStrings(nomFichier); // tableau de lignes qui recueille les données du fichier texte

  // récupère la ligne 0 --> titre du fichier
  titre = lines[0];
  println(titre);
  // récupère la ligne 1 --> taille du tableau du fichier texte
  String string1 = lines[1];
  String[] parts1 = string1.trim().split(" ");
  nbColonnes = parseInt(parts1[0]);
  nbLignes = parseInt(parts1[1]);
  println(nbColonnes);
  println(nbLignes);

  // récupère la ligne 2 --> nombre de case valide du fichier texte
  nbcasesinitiales = parseInt(lines[2]);
  println(nbcasesinitiales);

  isAlive = new boolean[nbLignes][nbColonnes];

  longueurTableau = (taillecase * nbColonnes);
  largeurTableau = (taillecase * nbLignes);

  size(longueurTableau, largeurTableau);

  // récupère les lignes --> coordonnées cases valides du fichier texte
  for (int i = 3; i < lines.length; i++) {
    String string = lines[i];
    String[] parts = string.trim().split(" ");
    int c = parseInt(parts[0]);
    int l = parseInt(parts[1]); 
    print(l);
    print(" " + c);
    println();
    isAlive[l][c] = true;
  }
}

void settings() {
  chargerFichier("settings.txt");
}

void setup() {
  frameRate(10);
}

void draw() {
  creationTableau();
  InitialiseVoisins();
  SimulerEtape();
  AffichageMenu();
}

void creationTableau() {
  // création des lignes et des colonnes via les lignes récupérées et initialisation des cases
  for (int l = 0; l < nbLignes; l++) {
    float y = map(l, 0, nbLignes, 0, largeurTableau);
    for (int c = 0; c < nbColonnes; c++) {
      float x = map(c, 0, nbColonnes, 200, longueurTableau);
      fill(isAlive[l][c] ? BLANC : NOIR);
      rect(x, y, taillecase, taillecase);
    }
  }
}

void SimulerEtape() { // permet de décomposer étape par étape 
   if(!pause) {
    noLoop();
    pause = true;
  }
  
}
void InitialiseVoisins() {
  // création tableau pour positions des voisins
  int[] dc = { -1, -1, -1, 0, 1, 1, 1, 0 };
  int[] dl = { -1, 0, 1, 1, 1, 0, -1, -1 };

  nbVoisins = new int[nbLignes][nbColonnes];
  // parcourir le tableau 
  for (int ligne = 0; ligne < nbLignes; ligne++) {
    for (int colonne = 0; colonne < nbColonnes; colonne++) {
      // parcourir les positions des voisins
      for (int v = 0; v < 8; v++) {
        nbVoisins[ligne][colonne] += voisinage(ligne + dl[v], colonne + dc[v]);
      }
    }
  }

  for (int ligne = 0; ligne < nbLignes; ligne++) {
    for (int colonne = 0; colonne < nbColonnes; colonne++) {
      // initialise les voisins si vrai, sinon tue voisins    
      if (nbVoisins[ligne][colonne] == 3 || (isAlive[ligne][colonne] && nbVoisins[ligne][colonne] == 2 )) {
        isAlive[ligne][colonne] = true;
      } else {
        isAlive[ligne][colonne] = false;
      }
    }
  }
}

int voisinage(int x, int y) {
  // vérifie si positionValide et si case est bien initialisée; compte plus 1 si oui, sinon 0
  if (positionValide(x, y) && isAlive[x][y] == true) {
    return 1;
  }
  return 0;
}

void AffichageMenu () {
  BoutonStart.DessinerBouttons();
  BoutonSimulerEtape.DessinerBouttons();
  BoutonReDemarre.DessinerBouttons();
  BoutonQuitter.DessinerBouttons();
  BoutonFichier.DessinerBouttons();
  BoutonSave.DessinerBouttons();
}

void mousePressed() {
  Boutons();
}


void Boutons () {
  if (BoutonStart.dansCases()) {// Démarre le draw
    loop();
  }
  if (BoutonSimulerEtape.dansCases()) {// Stop le draw ou décompose 1 draw par draw
    loop();
    pause =!pause;
 
  }
  if (BoutonQuitter.dansCases()) { // quitter le draw
    exit();
  }
  if (BoutonFichier.dansCases()) { // ouvre une boite de dialogue pour rechercher le fichier grille (patienter quelques secondes pour l'ouverture du fichier)
    selectInput("Sélectionner le fichier setting.txt dans TP1 Game Of Life", "fileSelected");
  }

  if (BoutonReDemarre.dansCases()) { // redemarrer le draw ( à faire après modification de la grille)
    chargerFichier("settings.txt");
    loop();
  }

  if (BoutonSave.dansCases()) { // Sauvegarder le dernier frame du draw 
    Sauvegarder();
  }
}

void fileSelected(File selection) { // méthode pour ouverture et le chargement du fichier settings.txt

  println("selection du fichier : " + selection.getAbsolutePath());
  launch(selection.getAbsolutePath());
}



void Sauvegarder () {
  
  
 int nbCellules=0;
 ArrayList<Cellule> celluleArrayList = new ArrayList<Cellule>();
    
  for (int i = 0; i < isAlive.length; i++) {
    for(int j=0; j < isAlive[0].length; j++){
      if(isAlive[i][j]){
        nbCellules++;
        celluleArrayList.add(new Cellule(i, j ));
             
      }
           
    }
       
  }
  
  String[] fichierFinal = new String[3+nbCellules];
  String information = showInputDialog("Description du fichier");
  
  fichierFinal[0] = information;
  fichierFinal[1]= nbColonnes +" "+nbLignes;
  fichierFinal[2]=nbCellules+"";
  
  int compteur = 0;
  
  
  for (Cellule c : celluleArrayList) {
    fichierFinal[3+compteur] = c.posY +" " +c.posX;
    compteur++;
  }
  
  saveStrings(information,fichierFinal);
  println("Le fichier a bien été sauvegardé");
  
  
}
