#Le fichier doit se trouver dans le répertoire où seront placés les deux arborescences
# Projet crée par Arsène, Mayeul, Yassine et Romain

nom_Rep=`ls -I arborescence.sh`
echo $nom_Rep
liste_fichier=`mktemp tempXXX`

#Rep1=${nom_Rep%*\ }
Rep1=`echo $nom_Rep | cut -d' ' -f 1`
Rep2=`echo $nom_Rep | cut -d' ' -f 2`
echo "Répertoire 1 : $Rep1, Répertoire 2 : $Rep2"

repCourant=`pwd`
echo $repCourant

#Traversée répertoire1 :
chemin1="./"$Rep1
echo $chemin1
cd $chemin1
ls 



#test si y a des fichiers dans la liste et les ajout à la liste
chaine=`ls`
doc="" 
for doc in $chaine
do
	if [ -d $doc ]
	then
		echo "$doc est un dossier"
	else
		echo "$doc est un fichier"
		echo $doc >> $liste_fichier
	fi
done

#comptageFichier(){}

#listeFichier(){}

#listeMD5(){}

#traversee(){}
#Là on va faire une boucle pour que ça traverse les rep
#tant qu'il y en a en récuperant le tout dans un fichier puis 
#appeler la fonction md5 pour vérifier si c'est ok

}

