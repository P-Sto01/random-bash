x=1;y=0;out=0;while true; do; out=$(echo $x+$y | bc);x=$out; echo "$out";out=$(echo $x+$y | bc);y=$out;echo "$out";done
