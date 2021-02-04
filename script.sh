#!/bin/bash

#create a new file
DIR=mooqita_task; mkdir $DIR
FILE=$(mktemp ./"$DIR"/file1.XXXXX)  # create a random file 
SIZE=$(du -b $FILE | cut -f 1) # calc size of file

# write a random string to a file
while [ "$SIZE" -lt 1048576 ]; do #
	# generate a random string less or equal 15 only with letter and num
	sed "s/[^a-zA-Z0-9]//g" <<< $(openssl rand -base64 15) >> $FILE & 
	printf "\r"											# to rewrite size
	SIZE=$(du -b $FILE | cut -f 1)						# calc size of file	
	printf "File size:$SIZE byte" 						# print size to stdout
done
printf "\n\rFile is complied\n\r"
sort -o $FILE $FILE 				#sort file and rewrite the file
FILE2=$(mktemp ./"$DIR"/file2.XXXXX) # create a second random file
sed '/^[aA]/d' $FILE > $FILE2 # delete lines started by 'a' or 'A' 
DL=$(($(wc -l $FILE |  awk '{ print $1 }') - $(wc -l $FILE2 |  awk '{ print $1 }'))) # count delete lines
echo "$DL lines were removed" 			# print delete lines
echo "Do you want to deleate garbage?"
read ANS

case $ANS in
		n | N | NO | no) echo "Files will saved in path ./$DIR/";;
		y | Y | YES | yes) rm -rf ./"$DIR"/
							echo "File's were deleted";;
esac

exit 0
