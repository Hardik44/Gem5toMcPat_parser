inputFilePath=$1	
currentPath=$2
mcpatPath=$3


#xml='mcpatInput.xml'
(cd ..) > $inputFilePath/mcpatOutput.csv
xeon='Xeon.xml'
arm='ARM_A9_2GHz.xml'

(cd $inputFilePath && ls *.json > config )
(cd $inputFilePath && ls *.txt > txt )

i=1
count=$(wc $inputFilePath/config -l | cut -d' ' -f1)
count2=$count

echo "Running mcpat for $count2 files..."

while [ $i -le $count2 ]; do

	echo "###############################     Processing file no: $i     ################################"
	
	conf=$(head -$i $inputFilePath/config | tail -1)
	stat=$(head -$i $inputFilePath/txt | tail -1)
	mcpat=${conf/config_/mcpat_}
	mcpat=${mcpat:0:-5}
	xml=${conf/.json/.xml}

	if [[ $conf = *"Intel"* ]]; then
		inputTemplete=$currentPath/$xeon
	else
		inputTemplete=$currentPath/$arm
	fi

	python $2/Program.py $inputFilePath/$stat $inputFilePath/$conf $inputTemplete 
	
	echo "Parsing is Done..."
	echo "Running mcpat for $conf"

	(cd $mcpatPath && ./mcpat -infile $currentPath/$xml -print_level 5 -opt_for_clk 1 > $inputFilePath/$mcpat && rm $currentPath/$xml)
	
	while IFS='' read -r line || [[ -n "$line" ]]; do
		if [[ $line = *"Runtime Dynamic"* ]]; then
	
			POWER="$(echo "$line" | awk -F "=" '{print $2}')"
			echo "$mcpat,${POWER}" >> $inputFilePath/mcpatOutput.csv
			break
		fi
	done < "$inputFilePath/$mcpat"
  	
  	i=$[$i + 1]
done
