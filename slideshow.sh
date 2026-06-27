files=("${(@f)$(find . -type f | grep -E -i "\.(mp4$|jpg$)")}");printf "Loaded files\n";for i in "${files[@]}"; do read -k1 -s;open $i;printf "Opened $i\n";done
