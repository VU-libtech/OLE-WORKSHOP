#!/bin/bash
clear

CIRC="localhost:8080/olefs/circulation"
DOCSTORE="localhost:8080/oledocstore/documentrest"

DAVID_LAMPLE="6010570002206107"
MARY_MAMPLE="6010570001520755"

OPERATOR="olequickstart"

declare -a LAMPLE_ITEMS=('39346004613057' '39346004688836' '39346004668465' '39346004730505' '39346004632123' '39346004703999' '39346004670669')

declare -a MAMPLE_ITEMS=('39346004634673' '39346004623247' '39346004724581' '39346004583201' '39346004613867' '39346004585073' '39346004659399')

printf "\n----------------------------------------\n"
printf "Checkout items to David Lample";
printf "\n----------------------------------------\n"

for item in ${LAMPLE_ITEMS[@]}
do
    curl -XPOST ${CIRC}"?service=checkOutItem&patronBarcode="${DAVID_LAMPLE}"&operatorId="${OPERATOR}"&itemBarcode="$item
    printf "\n----------------------------------------\n"
done

printf "\n----------------------------------------\n"
printf "Checkout items to MARY_MAMPLE"
printf "\n----------------------------------------\n"

for item in ${MAMPLE_ITEMS[@]}
do
    curl -XPOST ${CIRC}"?service=checkOutItem&patronBarcode="${MARY_MAMPLE}"&operatorId="${OPERATOR}"&itemBarcode="$item
    printf "\n----------------------------------------\n"
done

printf "\n----------------------------------------\n"
printf "Hold items for David Lample"
printf "\n----------------------------------------\n"

curl -XPOST ${CIRC}"?service=placeRequest&patronBarcode="${DAVID_LAMPLE}"&operatorId="${OPERATOR}"&itemBarcode="${MAMPLE_ITEMS[0]}"&requestType=Recall%2FHold%20Request"
curl -XPOST ${CIRC}"?service=placeRequest&patronBarcode="${DAVID_LAMPLE}"&operatorId="${OPERATOR}"&itemBarcode="${MAMPLE_ITEMS[1]}"&requestType=Hold%2FHold%20Request"

printf "\n----------------------------------------\n"
printf "Hold items for Mary Mample"
printf "\n----------------------------------------\n"

curl -XPOST ${CIRC}"?service=placeRequest&patronBarcode="${MARY_MAMPLE}"&operatorId="${OPERATOR}"&itemBarcode="${LAMPLE_ITEMS[0]}"&requestType=Recall%2FHold%20Request"
curl -XPOST ${CIRC}"?service=placeRequest&patronBarcode="${MARY_MAMPLE}"&operatorId="${OPERATOR}"&itemBarcode="${LAMPLE_ITEMS[1]}"&requestType=Hold%2FHold%20Request"


printf "\n----------------------------------------\n"
printf "David Lample's Checked Out Items"
printf "\n----------------------------------------\n"

curl -XGET ${CIRC}"?service=getCheckedOutItems&patronBarcode="${DAVID_LAMPLE}"&operatorId="${OPERATOR}

printf "\n----------------------------------------\n"
printf "Mary Mample's Checked Out Items"
printf "\n----------------------------------------\n"

curl -XGET ${CIRC}"?service=getCheckedOutItems&patronBarcode="${MARY_MAMPLE}"&operatorId="${OPERATOR}

printf "\n----------------------------------------\n"
printf "David Lample's Holds/Requests"
printf "\n----------------------------------------\n"

curl -XGET ${CIRC}"?service=holds&patronBarcode="${DAVID_LAMPLE}"&operatorId="${OPERATOR}

printf "\n----------------------------------------\n"
printf "Mary Mample's Holds/Requests"
printf "\n----------------------------------------\n"

curl -XGET ${CIRC}"?service=holds&patronBarcode="${MARY_MAMPLE}"&operatorId="${OPERATOR}

printf "\n----------------------------------------\n"
printf "David Lample's Account (lookup user)"
printf "\n----------------------------------------\n"

curl -XGET ${CIRC}"?service=lookupUser&patronBarcode="${DAVID_LAMPLE}"&operatorId="${OPERATOR}

printf "\n----------------------------------------\n"
printf "Mary Mample's Account (lookup user)"
printf "\n----------------------------------------\n"

curl -XGET ${CIRC}"?service=lookupUser&patronBarcode="${MARY_MAMPLE}"&operatorId="${OPERATOR}

printf "\n----------------------------------------\n"
printf "Cancel David Lample's 1st Request"
printf "\n----------------------------------------\n"

curl -XPOST ${CIRC}"?service=cancelRequest&operatorId="${OPERATOR}"&requestId=1"

printf "\n----------------------------------------\n"
printf "Cancel Mary Mample's 2nd Request"
printf "\n----------------------------------------\n"

curl -XPOST ${CIRC}"?service=cancelRequest&operatorId="${OPERATOR}"&requestId=4"

printf "\n----------------------------------------\n"
printf "Checkin / Return David Lample's 4th item";
printf "\n----------------------------------------\n"

curl -XPOST ${CIRC}"?service=checkInItem&patronBarcode="${DAVID_LAMPLE}"&operatorId="${OPERATOR}"&itemBarcode="${LAMPLE_ITEMS[3]}"&deleteIndicator=N"

printf "\n----------------------------------------\n"
printf "Checkin / Return Mary Mample's 4th item";
printf "\n----------------------------------------\n"

curl -XPOST ${CIRC}"?service=checkInItem&patronBarcode="${MARY_MAMPLE}"&operatorId="${OPERATOR}"&itemBarcode="${MAMPLE_ITEMS[3]}"&deleteIndicator=N"

printf "\n----------------------------------------\n"
printf "Renew David Lample's 5th item";
printf "\n----------------------------------------\n"

curl -XPOST ${CIRC}"?service=renewItem&patronBarcode="${DAVID_LAMPLE}"&operatorId="${OPERATOR}"&itemBarcode="${LAMPLE_ITEMS[4]}

printf "\n----------------------------------------\n"
printf "Renew Mary Mample's 5th item";
printf "\n----------------------------------------\n"

curl -XPOST ${CIRC}"?service=renewItem&patronBarcode="${MARY_MAMPLE}"&operatorId="${OPERATOR}"&itemBarcode="${MAMPLE_ITEMS[4]}

printf "\n----------------------------------------\n"
printf "Create Bib";
printf "\n----------------------------------------\n"

curl -XPOST ${DOCSTORE}"/bib/doc" -d @config/bibs_holdings_items/POST_bib.xml --header "Content-Type: application/xml"

printf "\n----------------------------------------\n"
printf "Update Bib";
printf "\n----------------------------------------\n"

curl -XPUT ${DOCSTORE}"/bib/doc" -d @config/bibs_holdings_items/PUT_bib.xml --header "Content-Type: application/xml"

#printf "\n----------------------------------------\n"
#printf "Delete Bib";
#printf "\n----------------------------------------\n"

#curl -XDELETE ${DOCSTORE}"/bib/doc?bibId=wbm-1111111"

printf "\n----------------------------------------\n"
printf "Create Holding";
printf "\n----------------------------------------\n"

curl -XPOST ${DOCSTORE}"/holdings/doc" -d @config/bibs_holdings_items/POST_holdings.xml --header "Content-Type: application/xml"

printf "\n----------------------------------------\n"
printf "Update Holding";
printf "\n----------------------------------------\n"

curl -XPUT ${DOCSTORE}"/holdings/doc" -d @config/bibs_holdings_items/PUT_holdings.xml --header "Content-Type: application/xml"

printf "\n----------------------------------------\n"
