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
        if [ $choixtype = "d" ] && [ "$ligne" != "$dir2" ] #On ne récupére pas le nom de l'arborescence primaire
        then
            #faut cut pour avoir que le dernier repertoire
            expr $ligne : '.*\(/.*$\)' >> $cpfichier
        else
            #sinon on cut pour récup que le md5 du fichier
            echo $ligne >> $cpfichier
        fi
    fi
    done < $nomfichier

    echo ""
    echo "$nomfichier :"
    cat $nomfichier

    echo ""
    echo "$cpfichier"
    cat $cpfichier

    #compte le nombre de fichier différents


    trifichier=$"Tri_"$nomfichier
    nbligne=`cat $cpfichier | wc -l`

    debut=1
    occur=0

    while [ $debut -le $nbligne ]
    do
        chaine=`cat $cpfichier | head -n $debut | tail -n 1` #prend une ligne à la fois
        echo $chaine >> $trifichier
        debut=$(($debut + `cat $cpfichier | grep -c "$chaine"`)) #modifie la valeur du début de lecture pour prendre nouveau md5
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

    echo "Avant sort :"
    cat $fichiertxt
    temp=`mktemp temp_XXX`
    sort $fichiertxt >> $temp
    echo "Après sort :"
    cat $temp > $fichiertxt
    rm $temp

}

rm Tri_list_*
rm CP_list_*
rm list_*

sed -i 's/\r$//' listeFichier.sh
#listeFile f arbo1
#listeFile f arbo2
#listeFile f arbo1 arbo2
listeFile d arbo1
#listeFile d arbo2
#listeFile d arbo1 arbo2

#cpFichier f list_f_arbo1_arbo2.txt arbo1 arbo2

cpFichier d list_d_arbo1_.txt arbo1