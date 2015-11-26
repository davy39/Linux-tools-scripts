#!/bin/bash
#
# impression-livret.sh

#
# Imprime les feuilles recto d'un livret, puis les verso.
# A placer dans :
#    ~/.local/share/nemo/scripts

# Imprimante à utiliser (telle que définie dans le gestionaire 
# d'imprimantes ou le fichier /etc/cups/printers.conf).
printer=default
#printer=Samsung-M2020
 
echo "$NEMO_SCRIPT_SELECTED_FILE_PATHS" | while read file
    do
    extension="${file##*.}"
    filename=`basename "$file"`
    filename="${filename%.*}"
    filedir=`dirname "$file"`
    pdfbook --short-edge --suffix "tmp" "$file" 
    # Demande de confirmation recto   
    if zenity --question  --text="Êtes-vous pret à lancer l'impression Recto de $filename ?"; then
        #Impression recto
	lpr -P "$printer" -o landscape -o page-set=odd "$filename-tmp.pdf"

        #Demande de confirmation verso
        if zenity --question --text="Impression des rectos en cours...\n\nReplacer vos feuilles dans le bac avant de continuer" --ok-label="Imprimer le verso" --cancel-label="Annuler" ; then
		# Impression verso
 		lpr -P "$printer" -o outputorder=reverse -o landscape -o page-set=even "$filename-tmp.pdf"
		rm "$filename-tmp.pdf"
        else
                exit 0
        fi
        exit 0
    else
        exit 0
    fi
    done
exit 0
