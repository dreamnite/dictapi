INPUT=$1
echo \{ 
while read i; do 
       #echo $i
	WORD=`echo $i |cut -d " " -f 1`
	DEF=`echo $i | cut -d \[ -f 1 | cut -d " " -f 2-`
	PRT=`echo $i |cut -d \[ -f 2|cut -d " " -f 1|cut -d \] -f 1`
#echo $WORD $PRT $DEF
case $PRT in 
	n)
	  PART="Noun"
	  ;;
	 v) 
	  PART="Verb"
	  ;;
	 adj) 
	  PART="Adjective"
	  ;;
  adv) 
	  PART="Adverb"
	  ;;
  interj)
	  PART="Interjection"
	  ;;
  pron)
	  PART="Pronoun"
	  ;;
  prep)
	  PART="Preposition"
	  ;;
  *)
	  PART=$PRT
	  ;;
esac


echo "\"$WORD\": { \"definition\": \"$DEF\", \"speech_part\": \"$PART\"},"
done <$INPUT
echo "}"



