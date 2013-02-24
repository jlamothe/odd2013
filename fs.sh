#!/bin/sh
string=$@
echo $string
#use a text based browser, to dump the website results from google maps
w3m -dump http://maps.google.com/?q="$string" > test 2>&1
#grep -B 2 "[0-9]*-[0-9]*-[0-9]*" test | sed -e 's/\[transparen\]//' | sd -e 's/().*$//' | sed -e 's/+1\ //'
grep "[0-9]*-[0-9]*-[0-9]*" test | sed -e 's/().*$//' | sed -e 's/+1\ //' | perl -pe 's/.*?-//' | perl -pe 's/\ .*$//' > test2
sed '$d' test2 > test3  #remove last line
sed '$d' test3 > test2  #remove last line, since last two are duplicate ads

cat test2 | while read line; do
    echo "----$line"
    echo "----`sqlite3 food.db  "select BUSINESS_NAME,ADDRESS from t where PHONE like '%$line%' limit 1"` "
    #use sqlite3
    sqlite3 food.db  "select INSPECTION_DATE,INFRACTION_DETAIL,INFRACTION from t where PHONE like '%$line%' order by substr(INSPECTION_DATE,7)||substr(INSPECTION_DATE,4,2)||substr(INSPECTION_DATE,1,2)";

    echo ""

done
