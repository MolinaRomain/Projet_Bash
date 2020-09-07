#AJOUT DES PARAMETRES POUR TEST LES REPERTOIRES ET REMOVE LES FICHIERS

cpFichier(){
    #prend en paramètre le fichier d'entrée et concatène tous élements identiques et renvoie en sortie le nombre de fichiers différents
    choixtype=$1 # 'f':file / 'd':directory
    nomfichier=$2
    dir1=$3
    dir2=$4
    cpfichier="CP_"$nomfichier


    while read ligne
    do
    ligne=`echo $ligne | cut -d' ' -f1` #on cut au 1er espace pour voir caractère de césure
    if [ "$ligne" != "-" ] #si la ligne est différente du tiret de séparation
    then
            echo $ligne >> $cpfichier
    fi
    done < $nomfichier

    echo ""
    echo "$nomfichier :"
    cat $nomfichier

    if [ "$choixtype" = "d" ] #opération spéciale si dossier
    then
        temp=`mktemp temp_XXX`
    
        if [ "$dir2" != "" ]
        then
            #remplace les chaines dir1 et dir2 par "" et saute des lignes à chaque /
            cat $cpfichier | sed -e "s/$dir1//g" | sed -e "s/$dir2//g" | tr / '\n' >> $temp
        else
            #remplace uniquement dir1 si dir2 n'est pas spécifié
            cat $cpfichier | sed -e "s/$dir1//g" | tr / '\n' >> $temp
        fi
        #ajout des lignes contenant 1 seule fois le nom de chaque répertoire
        echo $dir1 >> $temp
        echo $dir2 >> $temp
        #enlève toutes lignes vides et trie le fichier avant la copie
        awk NF $temp | sort > $cpfichier
        rm $temp
    fi

    echo ""
    echo "$cpfichier"
    cat $cpfichier 

    
    #compte le nombre de fichier différents


    trifichier="Tri_"$nomfichier
    nbligne=`cat $cpfichier | wc -l`
    echo ""
    echo "Nbligne : $nbligne"
    debut=1
    occur=0

    while [ $debut -le $nbligne ] #tant qu'on a pas parcouru toutes les lignes du fichier
    do
        chaine=`cat $cpfichier | head -n $debut | tail -n 1` #prend une ligne à la fois
        echo $chaine >> $trifichier
        debut=$(($debut + `cat $cpfichier | grep -c -w "$chaine"`)) #modifie la valeur du début de lecture pour prendre nouveau md5
        echo $chaine $debut
    done

    echo ""
    echo "$trifichier :"
    cat $trifichier
    nbdiffer=`cat $trifichier | wc -l`
    echo "Il y a $nbdiffer fichiers/dossiers différents sur $nbligne au total"

    rm Tri_list_*
    rm CP_list_*
    rm list_*
}



listeFile(){
    choixtype=$1 # 'f':file / 'd':directory
    dir1=$2
    dir2=$3
    repTraversee="$dir1 $dir2"
    nomfichier="list_"$choixtype"_"$dir1"_"$dir2
    fichiertxt="$nomfichier".txt
    echo "$choixtype / $dir1 / $dir2 / $repTraversee / $fichiertxt"
    
    for dir in $repTraversee
    do
        if [ "$dir" = "$dir2" ] #ajoute un séparateur de champ entre arbo1 et arbo2
        then
            echo "- Le repertoire2 ($dir2) contient :" >> $fichiertxt
        fi
        if [ "$dir" = "$dir1" ]
        then
            echo "- Le repertoire1 ($dir1) contient :" >> $fichiertxt
        fi

        for pointeur in `find $dir -type $choixtype`
        do
            if [ $choixtype = "f" ]
            then
                #Si fichier injecte le md5 dans un autre fichier
                md5sum $pointeur >> $fichiertxt
            else
                #Sinon affiche la liste des dossiers
                echo $pointeur >> $fichiertxt
            fi
        done
    done

    #TO DO :
    # RAJOUTER UNE FONCTION QUAND arbo1 et 2 sont passés en paramètres afin de renvoyer
    # un fichier texte avec le répertoire complet


    echo "Avant sort :"
    cat $fichiertxt
    temp=`mktemp temp_XXX`
    sort $fichiertxt >> $temp
    echo "Après sort :"
    cat $temp > $fichiertxt
    rm $temp

}


sed -i 's/\r$//' listeFichier.sh
#listeFile f arbo1
#listeFile f arbo2
#listeFile f arbo1 arbo2
listeFile d arbo1
#listeFile d arbo2
#listeFile d arbo1 arbo2

#cpFichier f list_f_arbo1_arbo2.txt arbo1 arbo2

cpFichier d list_d_arbo1_.txt arbo1