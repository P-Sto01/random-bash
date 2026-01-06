#!/bin/bash
copy=
repeat=0
target_lenght=$(( $(tput cols) / 2 ))
pick=""
empty=

menu() {
    counter=0
    values=(${list[@]})
    point=0
    input=""
    escape_char=$'\x1b'
    tput smcup

    while true; do
	    clear
	    i=0
	    for d in ${values[@]}; do
		    if [[ $point == $i ]];then
	    		printf "[*] "
		    else
			    printf "[.] "
		    fi
	    	printf '%s' "$d"
            printf "\n"
		    (( i++ ))
	    done
	    read -rsn1 input
	    if [[ $input == $escape_char ]]; then
    	    read -rsn2 input
	    fi
	    if [[ $input == '[B' ]]; then
    		(( point++ ))
    	elif [[ $input == '[A' ]];then
		    (( point-- ))
	    elif [[ $input == "" ]]; then
            clear
            printf "Are you sure you want to pick ${values[$point]}? The path (for now) will be ./$name$pick/${values[$point]}. [Y/n]"
            read -sn1 jest
            printf "\n"
            if [[ "$jest" == "n" || "$jest" == "N" ]]; then
                clear
            else
                pick="$pick/${values[$point]}"
                (( counter++ ))
            fi
            if [[ $counter == $num ]]; then
                return
            fi
	    fi
	    input=""
	    if [[ $point -lt 0 ]]; then
	    	point=0
    	elif [[ $point -ge ${#values[@]} ]];then
		    point=$(( ${#values[@]} - 1 ))
	    fi
    done
}

mazes() {
    local depth=$1
    local base=$2

    (( depth == num )) && return

    for f in "${list[@]}"; do
        local dir="$base/$f"
        mkdir -p "$dir"
        (( repeat++ ))
        current_num=$(( (repeat * 100) / full ))
        bar_lenght=$(( (current_num * target_lenght ) / 100 ))
        bar=""
        for ((i = 0 ; i < bar_lenght ; i++)); do
            bar="${bar}="
        done
        spaces=$(( $target_lenght - $bar_lenght ))
        for ((i = 0 ; i < spaces ; i++)); do
            bar="${bar}."
        done
        printf "$bar (${current_num}%%) $repeat/$full directories created.\r"
        mazes $((depth + 1)) "$dir"
    done
}

place() {
    local depth=$1
    local pathing=$2

    if (( depth == num )); then
        touch $pathing/$file 2>/dev/null
        (( repeat++ ))
        current_num=$(( (repeat * 100) / all_files ))
        bar_lenght=$(( (current_num * target_lenght ) / 100 ))
        bar=""
        for ((i = 0 ; i < bar_lenght ; i++)); do
            bar="${bar}="
        done
        spaces=$(( $target_lenght - $bar_lenght ))
        for ((i = 0 ; i < spaces ; i++)); do
            bar="${bar}."
        done
        printf "$bar (${current_num}%%) $repeat/$all_files files created.\r"
        return
    fi

    for i in "$pathing"/*; do
        place  "$depth+1" "$i"
    done
}

total_dirs() {
    local N=$1
    local D=$2
    local total=0

    for ((k=1; k<=D; k++)); do
        total=$(( total + N**k ))
    done

    printf "$total"
}

while getopts "hpn:f:i:c:e" opt; do
  case $opt in
    h)
        printf "Arguments:\n-n [maze name]\n-f [file to hide]\n-i [input file]\n-c [number of layers]\n-e: creates empty files with the same name as the file to hide\n-p: copy instead of move\n-h: this menu\n"
        exit
        ;;
    p)
        copy=TRUE
        ;;
    n)
        name="$OPTARG"
        ;;
    f)
        file="$OPTARG"
        ;;
    i)
        input="$OPTARG"
        ;;
    c)
        num="$OPTARG"
        ;;
    e)
        empty="TRUE"
        ;;
  esac
done

if [ ! -f "$file" ]; then
    printf "Invalid file to hide!\n"
    exit
fi
if [ ! -f "$input" ]; then
    printf "Invalid input file!\n"
    exit
fi

inputs=($(cat "$input"))
if [[ -z "$inputs" ]]; then
    printf "Input file empty!\n"
    exit
fi
list=($(tr ' ' '\n' <<<"${inputs[@]}" | awk '!u[$0]++' | tr '\n' ' '))

full=$(total_dirs "${#list[@]}" "$num")
printf "$full directories will be created.\n"

all_files=$(( ${#list[@]} ** $num ))

if [ -d $name ];then
    printf "Directory $name already exists, do you wish to proceed anyway? ALL the files in that directory will be DELETED! "
    read -s -n 1 -p "[y/N]" reading
    printf "\n"
    if [[ "$reading" == "y" || "$reading" == "Y" ]]; then
        printf "Removing all files... "
        rm -rf $name/*
        printf "Done!\n"
    else
        printf "Quiting...\n"
        exit
    fi
else
    mkdir "$name"
fi

cd $name

mazes 0 .
printf "\n"

cd ..

printf "Do you wish for the file to be RANDOMLY hidden (or you would like to hide it like you want)? [y/N]"
read -s -n 1 reading
printf "\n"
if [[ "$reading" == "y" || "$reading" == "Y" ]]; then
    path="./$name"
    for ((i = 0 ; i < num ; i++)); do
        rand_char=${list[$(( $RANDOM % ${#list[@]} ))]}
        path="$path/$rand_char"
    done
    printf "Hidden in "$path". Please write down this path or you might lose access to the file!\n"
else
    path="./$name"
    menu
    tput rmcup
    path="$path$pick"
    printf "Hidden in "$path". Please write down this path or you might lose access to the file!\n"
fi

if [[ $copy ]]; then
    cp $file $path/$file
else
    mv $file $path/$file
fi

if [[ $empty ]]; then
    repeat=0
    place "0" "./$name"
    printf "\n"
fi

printf "Thanks for using! For more (or reporting bugs) visit https://github.com/p-sto01!\n"