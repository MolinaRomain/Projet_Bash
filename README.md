#   PROJET SYSTEME - MODULE M1101
##   Crée par MOLINA Romain, FOUGEROUSE Arsène, PLACIOS Mayeul et BELARBI Yassine


### Comment lancer le script ?

Pour lancer le script il faut se trouver dans le répertoire où il est stocké puis lancer la commande
`bash ./comparaison.sh`
Le script peut prendre en paramètres les 2 arborescences à comparer. Si aucun paramètres n'est fournit, le programme les demande à l'utilisateur. Un test sur les dossiers existant est ensuite fait pour vérifier si :
* les arborescences existent dans le répertoire courant
* l'utilisateur à les droits en lecture
* l'utilsateur n'a pas entré un nom de fichier



### Explications des bonus

**1. Horodate et logs**

   Un effort à été fait pour avoir des noms de fichier facilement triable :
* Les fichiers sont horodatés au format `aaaammjj_hhmmss_`
* Les fichiers *.txt* sont au format `horodatage_<operation>_<type>_<arborescence>.txt`
* Les fichiers *.html* sont au format `horodatage_resulat.html`

Tous les fichiers sont enregistrés dans un dossier logs afin de ne pas surcharger l'arborescence principale.                      
De plus le fichier `REMOVELOGS.sh` permet de les supprimer facilement en spécifiant un critère de suppression.

**2. Page web**

Une page web est générée à chaque fin de programme.
Pour celà un template à été crée et à chaque exécution est copié puis renommé dans le dossier logs.
Si ce dernier ne s'ouvre pas en fin de programme, vous pouvez modifier la commande ligne 371 par une en commentaire.
La page web à été réalisée à l'aide du framework *Bootstrap* pour avoir un design responsive. De plus un choix esthétique à été fait sur les couleurs : le fond des card des fichiers est en bleu/violet et celui des dossiers est en mauve/orange afin de faire visuellement la différence entre les deux. Des modal ont également été utilisés afin d'afficher la liste des fichiers/dossiers.



### Comment sont décrétés les arborescences identiques ou différentes ?

Plusieurs opérations sont effectués sur les fichiers contenant les md5 avant de pouvoir différencier les arborescences.

**Description des fichiers crées lors du script**

* `fichierBrut` contient la liste des md5 de chaque fichier dans l'arbo passée en paramètre au format EEEE FFFF+ lignes informatives commençant par des `-` pour dire quelle arbo contient quel fichier et afficher les md5 des fichiers et des dossiers (voir paragraphe suivant)
* `fichier`  idem que fichierBrut mais avec seulement les md5 EEEE
* `fichierTri` la liste des md5 uniques

Ces 3 fichiers suffisent pour pouvoir comparer les 2 arborescences à l'aide d'opérations .
La comparaison des fichiers entre les arbos permet finalement de stocker les valeurs des différents md5 dans un tableau afin de povoir affirmer si les arbos sont identiques/différentes.

**Différenciation des dossiers**

Pour différencier les dossiers, le script procède de la manière suivante :

Imaginons 2 arborescences comme suit : 
```
arbo1/
    rep1/
        fichier1
    rep2/
        fichier2

arbo2/
    rep3/
        fichier1
    rep4/
        fichier2  
```

Pour chaque dossier le script crée un fichier temporaire comportant le nom des sous dossiers et les md5 des fichiers qu'il contient. Pour rep1 on aura écrit sur une ligne `md5fichier1`.
Ensuite chaque fichier temporaire est rassemblé dans un autre fichier et trié par ordre alphabétique puis on effectue un `md5sum` sur ce fichier, celà représente donc le md5 des dossiers d'un arborescence.
Dans notre exemple les 2 arborescences seraient identiques car seul le nom des sous-dossiers compte. 

Ainsi deux arborescences sont différentes si:
* Le nombre de fichiers est différent
* Le nombre de dossiers est différent
* Les fichiers sont différents (md5 différent)
* Les dossiers ne contiennent pas la même chose
  * Les fichiers sont différents dans un même dossier existant dans les 2 arbo
  * Les sous-dossiers ont des noms différents
  * Les sous dossiers ne contiennent pas la même chose...
