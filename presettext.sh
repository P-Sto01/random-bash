msg="Hello World" ; for (( i = 1; i <= ${#msg}; i++ )); do; read -k 1 -s;printf "$msg[i]";done
