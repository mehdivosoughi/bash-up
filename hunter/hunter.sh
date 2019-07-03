#!/bin/bash

if [[ "$#" -ne 1 ]]; then
  echo "Usage: hunter {process name}"
  exit 1
fi

green=$'\e[92m'
red=$'\e[91m'
end=$'\e[0m'
delimiter="%%%"

mapfile -t arr < <(pgrep $1)

len=${#arr[@]}

if [[ ${len} == 0 ]] ; then
  echo "No such process" \"$1\";
  exit 1
fi

for i in "${!arr[@]}"
do
  path=`ps -o cmd fp ${arr[$i]} | sed 1d`
  output+="${green}$(($i + 1))${end} ${delimiter} "${arr[$i]}" ${delimiter} "${path}" ${delimiter} $1\n"
done

echo -e ${output} | column -t -s${delimiter} -o '  '

printf "Enter process number to ${red}kill${end}: (or 'a' to kill all)"
read index

printf "Enter kill signal [default/15]: "
read kill_signal

if ! [[ ${kill_signal} =~ $re ]]
then
  echo Error: not a valid input
  exit 1
elif [[ -z ${kill_signal} ]]
then
  kill_signal=15
fi

re='^[0-9]+$'
if [[ "$index" = "a" ]]
then
    for i in "${!arr[@]}"
    do
      kill -${kill_signal} "${arr[$i]}"
      echo "Hasta la vista, baby" " ${red}${arr[$i]}${end}"
    done
  exit 1
elif ! [[ ${index} =~ $re ]] || [[ ${index} -gt ${len} ]]
then
  echo "Error: not a valid input";
  exit 1
fi

kill -${kill_signal} "${arr[$(($index - 1))]}"
echo "Hasta la vista, baby" "${red}${arr[$(($index - 1))]}${end}"
