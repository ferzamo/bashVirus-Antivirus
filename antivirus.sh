#!/bin/bash


for name in *
do

	echo -n "Localizado fichero: " $name

	if [ ! -x $name ];then

		echo -e "\t[NO EJECUTABLE]"
		continue

	fi

	echo -e "\t[EJECUTABLE]"

	if [ "infectador.sh" = $name ]; then

		echo "Esquivando el propio virus"
		continue
	
	fi

	if [ "antivirus.sh" = $name ]; then

		echo "Esquivando el propio antivirus"
		continue
	
	fi

	
	dd if=$name of=/tmp/posibleVirus bs=1 count=855 >/dev/null 2>&1

	DIFF=$( diff /tmp/posibleVirus infectador.sh )

	if [ "$DIFF" = "" ]; then

		echo "Tiene el virus"
		dd if=$name of=/tmp/copiaFile bs=1 skip=855 >/dev/null 2>&1
		mv /tmp/copiaFile $name
		chmod +x $name
		echo "Archivo reparado"

	fi

done

exit

