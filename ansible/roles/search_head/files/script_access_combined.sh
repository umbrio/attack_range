#! /bin/bash


 

#date -d yesterday


 

day=$(date -v -1d +%d) 

month=$(date -v -1d +%b | perl -pe 's/([a-z])/\u$1/')

year=$(date -v -1d +%Y)


 

#echo $day

#echo $month

#echo $year


 

perl -pi -e "s/\[\d{2}\/\w+\/\d{4}/[$day\/$month\/$year/g" /tmp/bots/access_combined.txt