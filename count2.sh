#!/bin/bash

# Made By P_Sto


while true ; do
	read num1
	if [[ "$num1" =~ ^[0-9]+$ ]]; then
		break
	fi
done
echo --
while true ; do
	read num1m
	if [[ "$num1m" =~ ^[0-9]+$ ]]; then
		if [[ ! "$num1m" =~ ^[0]+$  ]]; then
			break
		fi
	fi
done
echo
echo
while true ; do
	read num2
	if [[ "$num2" =~ ^[0-9]+$ ]]; then
		break
	fi
done
echo --
while true ; do
	read num2m
	if [[ "$num2m" =~ ^[0-9]+$ ]]; then
		if [[ ! "$num2m" =~ ^[0]+$  ]]; then
			break
		fi
	fi
done
echo
echo


while true ; do
	read -p "Enter operation: " operation
	if [[ "$operation" =~ ^[-+*/]$ ]] ; then
		break
	fi
done


nwd() {
	a=$1
	b=$2
	while [[ b -ne 0 ]] ; do
		c=$(( $a%$b ))
		a=$b
		b=$c
	done
	echo $a
}

findden() {
	a=$1
	b=$2
	finddenresult=$(( $a*$b / $(nwd "$a" "$b" )))
	echo $finddenresult
}


case "$operation" in
	+)
		mianownik=$(findden "$num1m" "$num2m")
		num1o=$(( $num1*( $mianownik/$num1m ) ))
		num2o=$(( $num2*( $mianownik/$num2m ) ))

		output=$(( $num1o+$num2o ))
		;;
	-)
		mianownik=$(findden "$num1m" "$num2m")
		num1o=$(( $num1*( $mianownik/$num1m ) ))
		num2o=$(( $num2*( $mianownik/$num2m ) ))

		output=$(( $num1o-$num2o ))
		;;
	/)
		mianownik=$(( num1m*num2 ))
		output=$(( $num1*$num2m ))
		;;
	*)
		mianownik=$(( num1m*num2m ))
		output=$(( $num1*$num2 ))
		;;
esac


echo
echo
echo "Result:"
echo $output
echo --
echo $mianownik


while [[ $output -ge $mianownik ]] ; do
	output=$(( $output-$mianownik ))
	cale=$(( $cale+1 ))
done


nwdsaved=$(nwd "$output" "$mianownik")
while [[ $nwdsaved -gt 1 ]] ; do
	nwdsaved=$(nwd "$output" "$mianownik")
	output=$(( $output/$nwdsaved ))
	mianownik=$(( $mianownik/$nwdsaved ))
done


echo
echo
echo "Shortened:"
echo $cale
echo $output
echo --
echo $mianownik
