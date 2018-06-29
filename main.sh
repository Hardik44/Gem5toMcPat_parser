InputFilesDirectory=$1
CurrentPath=$2
mcpatPath=$3

j=1
(cd $InputFilesDirectory && ls -d */  > $CurrentPath/main_folders)

count2=$(wc main_folders -l | cut -d' ' -f1)

while [ $j -le $count2 ]; do
	main_folder=$(head -$j main_folders | tail -1)
	
	#if [ -z "$(ls -A ${main_folder:0:-1})" ]; then	
   	#	echo "$main_folder is Empty"
	#else
   	#	echo "Not Empty"
	#fi
	
	i=1
	(cd $InputFilesDirectory/$main_folder && ls > $CurrentPath/folders)
	count=$(wc folders -l | cut -d' ' -f1)
	while [ $i -le $count ]; do
		folder=$(head -$i folders | tail -1)
		
		./auto.sh $InputFilesDirectory/$main_folder/$folder $CurrentPath $mcpatPath &
		i=$[$i+1]
	done
	wait
	j=$[$j+1]
done