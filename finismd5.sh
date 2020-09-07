

    # MD5arbo1=$1
    # MD5arbo2=$2

    # sfind arbo1 -type f -exec md5sum {} \; > /tmp/md5 && md5sum /tmp/md5 && rm /tmp/md5 # Calcul empreinte md5 de arbo1
    # find arbo2 -type f -exec md5sum {} \; > /tmp/md5_2 && md5sum /tmp/md5_2 && rm /tmp/md5_2 #Calcule empreinte md5 de arbo2

    # # if [[  -eq  ]]; then
    # #     #statements
    # # fi

    # md5arbo1=`find arbo1 -type f -exec md5sum {} \;`
    # $md5arbo1> /tmp/md5 && md5sum /tmp/md5  

    # md5arbo1=`find arbo1 -type f -exec md5sum {} \; > /tmp/md5`
    # $md5arbo1=`md5sum /tmp/md5`

    find arbo1 -type f -exec md5sum {} \; > /tmp/md5
    md5arbo1=`md5sum /tmp/md5 | cut -d' ' -f1`



    # md5arbo2=`find arbo2 -type f -exec md5sum {} \; > /tmp/md5_2 `
    # $md5arbo2=`md5sum /tmp/md5_2`

    find arbo2 -type f -exec md5sum {} \; > /tmp/md5_2
    md5arbo2=`md5sum /tmp/md5_2 | cut -d' ' -f1`


    if [[ "$md5arbo1" == "$md5arbo2" ]]
    then
        echo "Voila ça marche"
    else
        echo "Ca marche pas"
    fi
    echo $md5arbo1
    echo $md5arbo2

    

    # md5arbo1= find arbo1 -type f -exec md5sum {} \; > /tmp/md5 && md5sum /tmp/md5 && rm /tmp/md5
    # md5arbo2=

    # # if [ md5arbo1 -eq md5arbo2]; then
    # #     echo "Les deux arboresence ont la même empreinte md5 donc elles sont identiques"
    # # else 
    # #     echo " Elles ne le sont pas "

    # # fi










