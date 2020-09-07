#!usr/bin/env bash

#   PROJET SYSTEME - MODULE M1101
#   Crée par MOLINA Romain, FOUGEROUSE Arsène, PLACIOS Mayeul et BELARBI Yassine
#   Version : v10
#   Paramètres : aucun
#   supprime les fichiers logs

logdir="logs"

Choix(){
    read choix
    while [ $choix != "O" ] && [ $choix != "N" ] && [ $choix != "o" ] && [ $choix != "n" ]
    do
        echo "Veuillez choisir une lettre valide (O/N) >"
        read choix
    done
}

delDate(){
    echo "Supprimer par (h)eure / (j)our / (m)ois / (a)nnee | (q)uitter >"
    read choix
    while [ $choix != "h" ] && [ $choix != "j" ] && [ $choix != "m" ] && [ $choix != "a" ] && [ $choix != "q" ]
    do
        echo "Veuillez choisir une lettre valide (h/j/m/a/q) >"
        read choix
    done

    case $choix in
    "h")
        echo "Entrez l'heure au format 24h >"
        read heure
        while [ $heure -lt 0 ] || [ $heure -gt 23 ]
        do
            echo "Veuillez choisir une heure valide [0-23] >"
            read heure
        done
        echo "Supprimer les fichiers crée à $heure h (O)ui / (N)on ? >"
        Choix
        if [ $choix = "O" ] || [ $choix = "o" ]
        then
            rm ./$logdir/*_$heure*
        fi
    ;;

    "j")
    echo "Entrez le jour >"
        read jour
        while [ $jour -lt 0 ] || [ $jour -gt 31 ]
        do
            echo "Veuillez choisir un jour valide [0-31] >"
            read jour
        done
        echo "Supprimer les fichiers crée tout les $jour du mois (O)ui / (N)on ? >"
        Choix
        if [ $choix = "O" ] || [ $choix = "o" ]
        then
            rm ./$logdir/??????$jour?*
        fi
    ;;

    "m")
    echo "Entrez le numéro du mois >"
        read mois
        while [ $mois -lt 0 ] || [ $mois -gt 12 ]
        do
            echo "Veuillez choisir un mois valide [0-12] >"
            read mois
        done
        echo "Supprimer les fichiers crée le $mois eme mois (O)ui / (N)on ? >"
        read choix
        Choix
        if [ $choix = "O" ] || [ $choix = "o" ]
        then
            rm ./$logdir/????$mois??_*
        fi
    ;;

    "m")
    echo "Entrez l'annee en 4 chiffres >"
        read annee
        while [ $annee -lt 0 ]
        do
            echo "Veuillez choisir un annee valide [aaaa] >"
            read annee
        done
        echo "Supprimer les fichiers crée en $annee (O)ui / (N)on ? >"
        Choix
        if [ $choix = "O" ] || [ $choix = "o" ]
        then
            rm ./$logdir/$annee????_*
        fi
    ;;
    
    "q")
        menu
    ;;
    esac
}

delExt(){
    echo "Entrez l'extension des fichiers à supprimer >"
    read ext
    echo "Supprimer les fichiers crée avec l'extension .$ext (O)ui / (N)on ? >"
    Choix
    if [ $choix = "O" ] || [ $choix = "o" ]
    then
        rm ./$logdir/*.$ext
    fi
}

delArbo(){
    echo "Entrez le nom de l'arborescence dont le nom apparait dans les fichiers à supprimer >"
    read arbo
    echo "Supprimer les fichiers (O)ui / (N)on ? >"
    Choix
    if [ $choix = "O" ] || [ $choix = "o" ]
    then
        rm ./$logdir/*$arbo*
    fi
}

delTous(){
    echo "Supprimer tous les fichiers dans le dossier logs (O)ui / (N)on ? >"
    Choix
    if [ $choix = "O" ] || [ $choix = "o" ]
    then
        rm ./$logdir/*
    fi
}

listeFichiers(){
    echo "Voir les fichiers dans le dossier logs (O)ui / (N)on ? >"
    Choix
    if [ $choix = "O" ] || [ $choix = "o" ]
    then
        nbFichiers=`ls -s ./$logdir | head -n 1 | cut -d' ' -f2`
        echo "Liste des $nbFichiers fichiers dans le $logdir :"
        ls ./$logdir
        echo ""
    fi
}

menu(){
    listeFichiers
    echo "Supprimer les fichiers logs par (d)ate / (e)xtension / (a)rborescence / (t)ous | (q)uitter >"
    read choix
    while [ $choix != "d" ] && [ $choix != "e" ] && [ $choix != "a" ] && [ $choix != "q" ] && [ $choix != "t" ]
    do
        echo "Veuillez choisir une lettre valide (d/e/a) >"
        read choix
    done
    case $choix in
        "d")   
            delDate
        ;;

        "e")
            delExt
        ;;

        "a")
            delArbo
        ;;
        "t")
            delTous
        ;;  
        "q")
            exit 1
        ;;
    esac
}

menu
