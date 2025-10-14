#!/bin/bash

line_1=("0" "0" "0" "0" "0" "0" "0" "0")
line_2=("0" "0" "0" "0" "0" "0" "0" "0")
line_3=("0" "0" "0" "0" "0" "0" "0" "0")
line_4=("0" "0" "0" "0" "0" "0" "0" "0")
line_5=("0" "0" "0" "0" "0" "0" "0" "0")
line_6=("0" "0" "0" "0" "0" "0" "0" "0")
line_7=("0" "0" "0" "0" "0" "0" "0" "0")
line_8=("0" "0" "0" "0" "0" "0" "0" "0")
line_clear=("0" "0" "0" "0" "0" "0" "0" "0")
point_x=1
point_y=1
goal=0
points=0

exiting() {
clear
tput rmcup
exit 0
}

trap exiting INT TERM

tput smcup

while true; do
	read -s -n 1 input
	case $input in
		"w") ((point_y--)) ;;
		"s") ((point_y++)) ;;
		"a") ((point_x--)) ;;
		"d") ((point_x++)) ;;
		"q") exiting ;;
	esac

	if [[ point_x -lt 0 ]]; then
		point_x=0
	fi
        if [[ point_x -gt 7 ]]; then
                point_x=7
        fi
        if [[ point_y -lt 1 ]]; then
                point_y=1
        fi
        if [[ point_y -gt 8 ]]; then
                point_y=8
        fi

	if [[ goal -eq 0 ]]; then
		goal_y=$((1+($RANDOM % 8)))
		goal_x=$(($RANDOM % 8))
		goal=1
	fi

	if [[ goal_y -eq point_y && goal_x -eq point_x ]]; then
		((points++))
		goal=0
	fi

	clear

	line_1=("${line_clear[@]}")
	line_2=("${line_clear[@]}")
        line_3=("${line_clear[@]}")
        line_4=("${line_clear[@]}")
        line_5=("${line_clear[@]}")
        line_6=("${line_clear[@]}")
        line_7=("${line_clear[@]}")
        line_8=("${line_clear[@]}")

	case $point_y in
		1)
			line_1[$point_x]="1" ;;
		2)
			line_2[$point_x]="1" ;;
		3)
                        line_3[$point_x]="1" ;;
		4)
                        line_4[$point_x]="1" ;;
		5)
                        line_5[$point_x]="1" ;;
		6)
                        line_6[$point_x]="1" ;;
		7)
                        line_7[$point_x]="1" ;;
		8)
                        line_8[$point_x]="1" ;;
	esac
	if [[ goal -eq 1 ]]; then
		case $goal_y in
                	1)
                        	line_1[$goal_x]="A" ;;
                	2)
                        	line_2[$goal_x]="A" ;;
                	3)
                        	line_3[$goal_x]="A" ;;
                	4)
                        	line_4[$goal_x]="A" ;;
                	5)
                        	line_5[$goal_x]="A" ;;
                	6)
                        	line_6[$goal_x]="A" ;;
                	7)
                        	line_7[$goal_x]="A" ;;
                	8)
                	        line_8[$goal_x]="A" ;;
        	esac
	fi

	echo Your points: $points

    	for line in "${line_1[*]}" "${line_2[*]}" "${line_3[*]}" "${line_4[*]}" \
                "${line_5[*]}" "${line_6[*]}" "${line_7[*]}" "${line_8[*]}"; do
        	echo "$line"
    done
done

#Made by P_Sto
