#!usr/bin/env bash

#FUSION DES FONCTIONS CPFILES ET LISTEFILES ET AJOUT FONCTION CHEMINCOMPLET
#POUR RENVOYER LE CC DES REP ET FICHIERS DIFFERENTS DES 2 REP

checkParam(){
#création d'un dossier log qui contient toutes les sorties de fichier du script
logdir="logs"
    if [ ! -d "$logdir" ]
    then
        mkdir $logdir
    fi
}
listeFD(){
    #ajout d'une fonction d'horodatage des fichiers
    type=$1 # 'f':file / 'd':directory
    dir1=$2
    dir2=$3

    #if [ $type = "f" ] #On horodate les fichiers à conserver
    #then
        date=`date +%Y%m%e_%H%M%S_`
    #fi
    listetxt=$type"_"$dir1"_"$dir2.txt

    repTraversee="$dir1 $dir2"

    for dir in $repTraversee
    do
        if [ "$dir" = "$dir2" ] #ajoute un séparateur de champ entre arbo1 et arbo2
        then
            echo "- Le repertoire2 ($dir2) contient :" >> $listetxt
        fi
        if [ "$dir" = "$dir1" ]
        then
            echo "- Le repertoire1 ($dir1) contient :" >> $listetxt
        fi

        for pointeur in `find $dir -type $type`
        do
            if [ $type = "f" ]
            then
                #Si fichier injecte le md5 dans un autre fichier
                md5sum $pointeur >> $listetxt
            else
                #Sinon affiche la liste des dossiers
                echo $pointeur >> $listetxt
            fi
        done
    done
    echo "$listetxt :"
    cat $listetxt
    #enregistre le fichier avec la liste des md5/dossiers dans le dossier logs
    #ce fichier sera supprimer plus tard si analyse des dossiers
    nvfichier=$date"list_"$listetxt
    cp $listetxt ./$logdir/$nvfichier
    fichierBrut=./$logdir/$nvfichier

    TriFD $type $listetxt $fichierBrut $dir1 $dir2
}

TriFD(){
    type=$1 # 'f':file / 'd':directory
    fichier=$2
    fichierBrut=$3
    dir1=$4
    dir2=$5
    temp=`mktemp temp_XXX`
    
    sort $fichier | cut -d' '  -f1 >> $temp 
    cat $temp > $fichier

    if [ -z "$dir2" ]
    then
        startF=2
        cmdDir="cat $fichier"
    else 
        startF=3
        cmdDir="sed -e s/$dir2//g"
    fi
    cat $temp | tail -n +$startF > $fichier
    if [ $type = "d" ]
        then
        cat $fichier | $cmdDir | sed -e s/$dir1//g | tr / '\n' > $temp
        printf $dir1'\n'$dir2 >> $temp
        awk NF $temp | sort > $fichier 
    fi

    > $temp #on clear le fichier temporaire


    
    #fonction CP qui affiche le nombre de fichiers/dossiers différents
    echo "$fichier :"
    cat $fichier
    nbligne=`cat $fichier | wc -l`
    debut=1
    while [ $debut -le $nbligne ] #tant qu'on a pas parcouru toutes les lignes du fichier
    do
        chaine=`cat $fichier | head -n $debut | tail -n 1` #prend une ligne à la fois
        echo $chaine >> $temp
        debut=$(($debut + `cat $fichier | grep -c -w "$chaine"`)) #modifie la valeur du début de lecture pour prendre nouveau md5
    done

    cat $temp > $fichier
    echo "$fichier :"
    cat $fichier
    nbdiffer=`cat $fichier | wc -l`
    #AJOUT CONDITION POUR TEST F OU D ET SI NBDIFFER=1 ALORS 0 FICHIERS DIFFERENTS

    if [ $type = "d" ]
    then
        mot="dossiers"
    else
        mot="fichiers"
    fi
    if [ -n "$dir2" ]
    then
        arborescence="$dir1 et $dir2"
    else
        arborescence="$dir1"
    fi

    printf "Il y a $nbdiffer $mot différents sur $nbligne au total dans $arborescence\n" 

    rm $temp

    if [ $type = "f" ] #on appelle la fonction pour afficher le chemin complet des 2 arbo pour les fichiers
    then
        if [ -n "$dir2" ]
        then
            cheminCompletF $fichier $fichierBrut $temp $dir1 $dir2
        else
            rm $fichier #on supprime le fichier modifier dans le rep courant et on garde celui dans le log
        fi
    elif [ $type = "d" ] # si on analyse les dossiers on supprime les fichiers (CF consigne)
    then
        rm $fichier $fichierBrut #on supprime tous les fichiers
    fi
}

cheminCompletF(){
    #fonction qui affiche le chemin complet pour chaque fichiers en commun dans les deux arbo

    fichierCC=$1
    fichierBrut=$2
    dir1=$3
    dir2=$4

    nvfichierCC=$date"CC_"$fichierCC
    fichierBrutCC=./$logdir/$nvfichierCC

    while read ligne
    do
        echo "Le fichier ayant pour empreinte md5 $ligne apparait dans :" >> $fichierBrutCC
        grep $ligne $fichierBrut | cut -d' ' -f3 >> $fichierBrutCC
    done < $fichierCC

    cat $fichierBrutCC
    rm $fichierCC
}

checkParam
listeFD f arbo1
listeFD d arbo1
#listeFD f arbo2
#listeFD d arbo2
#listeFD f arbo1 arbo2