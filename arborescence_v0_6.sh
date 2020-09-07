#!usr/bin/env bash

#   PROJET SYSTEME - MODULE M1101
#   Crée par MOLINA Romain, FOUGEROUSE Arsène, PLACIOS Mayeul et BELARBI Yassine
#   arborescence_v0_5.sh
#   prend en paramètres les deux arborescences à traverser
#   En cours : modifier la fonction TriFD
#              ajoutez des couleurs



checkParam(){
    #création d'un dossier log qui contient toutes les sorties de fichier du script
    logdir="logs"
    if [ ! -d "$logdir" ]
    then
        mkdir $logdir
    fi
    
    #analyse des répertoires à traverser

    if [ $# -ne 2 ]
    then
        printf "Voulez vous utiliser les arborescences par défaut (\e[34m\e[1marbo1 \e[0met \e[34m\e[1marbo2\e[0m) pour l'analyse ? \e[1m(\e[32mO\e[39m)\e[0mui / \e[1m(\e[31mN\e[39m)\e[0mon >\n"
        read choix
        while [ "$choix" != "O" ] && [ "$choix" != "N" ]
        do
            echo -e "\e[1m\e[31mVeuillez entrer une lettre valide : \e[39m(\e[32mO\e[39m)ui / (\e[31mN\e[39m)on \e[0m>"
            read choix
        done
        if [ $choix = "O" ]
        then
            rep1="arbo1"
            rep2="arbo2"
            clear
            echo -e "\e[1mDébut de l'opération dans \e[31m3\e[39m..."
            sleep 1
            clear
            echo -e "\e[1mDébut de l'opération dans \e[33m2\e[39m.."
            sleep 1
            clear
            echo -e "\e[1mDébut de l'opération dans \e[32m1\e[39m."
            sleep 1
            clear
            echo -e "\e[1mGO !!!"
            sleep 0.5
            clear
            echo " -- Début de l'opération -- "
        else
            checkRep 1
        fi

    else
        checkRep 0
    fi
    
}

checkRep(){
    #fonction qui test si les repertoires spécifiés existent
    existRep=$1
    
    for ((i=1 ; i<3 ; i++ ))
    do
        if [ $existRep -eq 1 ]  #Si les répertoires n'ont pas été rentrés en param on les read
        then
            echo -e "Entrez le nom du répertoire n°\e[93m\e[1m$i \e[0mà traverser >"
            read dir
        else
            if [ $i -eq 1 ]
            then
                dir=$rep1   #Sinon on test chacun à la suite
            else
                dir=$rep2
            fi
        fi
        check=1
        find $dir -type d || check=0

        while [ $check -eq 0 ]
        do
            echo -e "\e[31m\e[1mLe répertoire \e[34m$dir \e[31mque vous voulez traverser n'est pas accesible depuis le rep courant ou n'existe pas"
            printf "\e[1mVeuillez entrez un répertoire \e[4mexistant \e[24m> \e[0m\e[39m"
            read dir
            check=1
            find $dir -type d || check=0
        done

        printf "Le répertoire n°\e[93m\e[1m$i \e[0m(\e[34m\e[1m$dir\e[0m) \e[0mest \e[1m\e[32mvalide \e[0met prêt pour l'analyse !\n\n"
        if [ $i -eq 1 ]
        then
            rep1=$dir
        else
            rep2=$dir
        fi
        sleep 1
    done

}


listeFD(){
    #fonction qui renvoie la liste des MD5/dossiers dans un fichier et le sauve dans le log
    type=$1 # 'f':file / 'd':directory
    dir1=$2
    dir2=$3

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
    
    #enregistre le fichier avec la liste des md5/dossiers dans le dossier logs + horodatage
    #ce fichier sera supprimé plus tard si analyse des dossiers
    
    date=`date +%Y%m%d_%H%M%S_`
    nvfichier=$date"list_"$listetxt
    cp $listetxt ./$logdir/$nvfichier
    fichierBrut=./$logdir/$nvfichier
    
    #après la sauvegard on enlève les lignes informatives inutiles pour la suite et les répertoire
    sed -i '/- Le repertoire/d' $listetxt
    sed -i 's/\s.*$//' $listetxt #équivaut à un cut -d' ' -f1 mais modifie directement le fichier source
    TriFD $type $listetxt $fichierBrut $dir1 $dir2
}

TriFD(){
    #fonction qui concatène les md5/dossiers en double dans un autre fichier
    type=$1
    fichier=$2
    fichierBrut=$3
    dir1=$4
    dir2=$5
    
    temp=`mktemp TEMP_XXX`
    fichierTri=`mktemp TEMP_XXX`
    if [ -z "$dir2" ]
    then
        cmdDir="cat $fichier"
    else 
        cmdDir="sed -e s/$dir2//g" #si 2 repertoires on remplace les $dir2 par rien
    fi
    if [ $type = "d" ]
    then
        cat $fichier | $cmdDir | sed -e s/$dir1//g | tr / '\n' > $temp #sinon on remplace seulement les dir1 et on va à la ligne à chaque /
        #printf $dir1'\n'$dir2 >> $temp
        awk NF $temp | sort > $fichier #on remove les lignes vide et on trie
    fi
    nbFD=`cat $fichier | wc -l`
    #Si f arbo1 ou 2 on doit conserver sauvegarder le md5 du fichier trié
    sort -u $fichier > $fichierTri
    nbdiffFD=`cat $fichierTri | wc -l`
    
    #analyse du nombre de dossiers/fichiers différents au total
    if [ $type = "d" ]
    then
        mot="\e[34mdossiers"    #ajout des couleurs
    else
        mot="\e[32mfichiers"
    fi
    if [ -z "$dir2" ]
    then
        arborescence="\e[34m\e[1m$dir1"
    else
        arborescence="\e[34m\e[1m$dir1 \e[0met \e[34m\e[1m$dir2"
    fi
    
    printf "\n\nIl y a \e[93m\e[1m$nbdiffFD $mot \e[0mdifférents sur \e[93m\e[1m$nbFD \e[0mau total dans $arborescence\n\e[0mListe des \e[1m$mot \e[0mdifférents :\n"
    if [ "$type" = "d" ]
    then 
        cat $fichierTri
    fi
    
    if [ -z "$dir2" ] #si une seule arbo en entrée
    then
        if [ "$dir1" = "$rep1" ] #si le repertoire 1 correspond au 1er entré on sauvegarde dans variables ...1
        then
            if [ "$type" = "f" ]
            then
                md5file1=`md5sum $fichier | cut -d' ' -f1` #md5 du fichier contenant les empreintes des fichiers contenus
                mot="es empreintes md5"
                ftemp=$fichierBrut
                cheminCompletF $fichier $fichierTri $dir1
            else
                md5dir1=`md5sum $fichier | cut -d' ' -f1` #md5 du fichier contenant dossier dans l'arbo
                mot="s dossiers"
            fi
            
        else
            if [ "$type" = "f" ] #sinon c'est le rep 2 et les variables auraont un nom ...2
            then
                md5file2=`md5sum $fichier | cut -d' ' -f1`
                mot="es empreintes md5"
                ftemp=$fichierBrut
                cheminCompletF $fichier $fichierTri $dir1
            else
                md5dir2=`md5sum $fichier | cut -d' ' -f1`
                mot="s dossiers"
            fi
        fi
        #ecrit le md5 des fichiers et dossiers dans les fichierBruts
        if [ "$mot" = "es empreintes md5" ]
        then
            fsortie=$fichierBrut
        else
            fsortie=$ftemp
        fi
        echo "- Empreinte md5 du fichier ($fichier) contenant les différent$mot de $dir1 : `md5sum $fichier | cut -d' ' -f1` " >> $fsortie
    else
        cheminCompletF $fichier $fichierTri $dir1 $dir2
    fi
    removeFiles $type $dir1 $dir2
}


cheminCompletF(){

    #Fonction qui affiche le chemin complet des fichiers différents
    
    fichier=$1
    fichierTri=$2
    dir1=$3
    dir2=$4
    
    nvfichierCC=$date"CC_"$fichier
    
    fichierBrutCC=./$logdir/$nvfichierCC

    while read ligne
    do
        
        if [ -n "$dir2" ]
        then
            printf "\nLe fichier ayant pour empreinte md5 $ligne apparait dans :\n" >> $fichierBrutCC
            grep $ligne $fichierBrut | cut -d' ' -f3 >> $fichierBrutCC #si 2 arbo on garde le chemin complet    
        else
            printf "\nLe fichier ayant pour empreinte md5 \e[35m\e[1m$ligne \e[0mapparait dans :\n" >> $fichierBrutCC #ajout uniquement de couleurs pour affichage dans le terminal
            grep $ligne $fichierBrut | rev | cut -d/ -f1 | rev >> $fichierBrutCC #sinon on garde que le nom du fichier (inversion avec rev puis cur du 1er et envoie réinversion)
        fi
    done < $fichierTri
    
    #affiche si les répertoires sont identiques ou différents
    
    #Si le md5 du fichier contenant les md5 des fichiers dans les 2 arbo est identique et celui contenant les dossiers
    echo -e $phrase
    cat $fichierBrutCC
    if [ -n "$dir2" ]
    then
        #echo "MD51F : $md5file1"
        #echo "MD52F : $md5file2"
        #echo "MD51D : $md5dir1"
        #echo "MD52D : $md5dir2"
        if [ "$md5file1" = "$md5file2" ] && [ "$md5dir1" = "$md5dir2" ]
        then
            printf "\nLes deux arborescences \e[34m\e[1m$dir1 \e[0met \e[34m\e[1m$dir2 \e[0sont \e[1m\e[32mIDENTIQUES\e[0m\n" #on considère que les arbo sont pareils
        else
            printf "\nLes deux arborescences \e[34m\e[1m$dir1 \e[0met \e[34m\e[1m$dir2 \e[0sont \e[1m\e[31mDIFFERENTES\e[0m\n"
        fi
        rm $fichierBrut
        printf "\n\e[1mLes md5 des fichiers \e[0mdans \e[34m\e[1m$dir1 \e[0met \e[34m\e[1m$dir2 \e[0met \e[1mla liste des fichiers différents \e[0mdans les 2 arborescences ont été \e[32m\e[1msauvegardés \e[0mdans le dossier \e[34m\e[1m./$logdir \e[0m!\n"
    else
        rm $fichierBrutCC
   fi
}


removeFiles(){
    type=$1
    rm $fichier TEMP_???
    if [ "$type" = "d" ]
    then
        rm $fichierBrut
    fi
}


rep1=$1
rep2=$2
checkParam $rep1 $rep2

listeFD f $rep1
listeFD d $rep1
listeFD f $rep2
listeFD d $rep2
listeFD f $rep1 $rep2
