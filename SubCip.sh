#!/bin/bash +x
makedict() #make encryption dictionary
{
	for((i=0;i<$num+1;i++))
	do
		dictionary[$i]=${keywords[$i]}
	done

	mark=$num+1
	for((i=0;i<26;i++))
	do
		flag=0
		for((j=0;j<$num+1;j++))
		do
			if [ ${letter[$i]} == ${keywords[$j]} ]
			then 
				let flag++
			fi
		done
		
		if [ $flag -eq 0 ]
		then 
			dictionary[$mark]=${letter[$i]}
			let mark++
		fi

		let flag=0
	done 
}
format() #remove dupluicated letter in the key
{
	count=0
	num=0
	while [ $count -lt ${#key} ]
	do
		word[$count]=${key:$count:1}
		let count++
	done
	
	keywords[$num]=${word[0]}

	for  ((i=1;i<$count;i++))
	do
		flag=0
		for((j=0;j<$num+1;j++))
		do
			if [ ${keywords[$j]} == ${word[$i]} ]
			then
				let flag++
			fi
		done	

		if [ $flag -eq 0 ]
		then 
			let num++
			keywords[$num]=${word[$i]}
		fi

		let flag=0
	done	
}

encrypt()
{
	makedict ${keywords[*]} 

	cp $filename t_m_p.txt

	for((i=0;i<26;i++))
	do
		if [ ${letter[$i]} != ${dictionary[$i]} ]
		then
			sed 's/${letter[$i]}/${dictionary[$i]}/g' t_m_p.txt >temp.txt
			mv temp.txt t_m_p.txt
		fi
	done
	
	cat t_m_p.txt
	
	rm t_m_p.txt
}

decrypt()
{
	makedict ${keywords[*]} 

	cp $filename t_m_p.txt

	for((i=25;i>0;i--))
	do
		if [ ${letter[$i]} != ${dictionary[$i]} ]
		then
			sed "s/${dictionary[$i]}/${letter[$i]}/g" t_m_p.txt >temp.txt
			mv temp.txt t_m_p.txt
		fi
	done
	
	cat t_m_p.txt
	
	rm t_m_p.txt
}

letter[0]="a";letter[1]="b";letter[2]="c";letter[3]="d";letter[4]="e";letter[5]="f";letter[6]="g";letter[7]="h";letter[8]="i";letter[9]="j";letter[10]="k";letter[11]="l";letter[12]="m";letter[13]="n";letter[14]="o";letter[15]="p";letter[16]="q";letter[17]="r";letter[18]="s";letter[19]="t";letter[20]="u";letter[21]="v";letter[22]="w";letter[23]="x";letter[24]="y";letter[25]="z"

#==================================================main script==================================================
if [ $# -ne 3 ]
then 
	echo "SubCip.sh <mode> <keyword> <inputfile> > <outputfile>"
	exit 1
else
	
	if [ ! -f $3 ]
	then
		echo "Please give me a file!!!"
		exit 1
	fi

	key=$(echo $2| tr -d '[:upper:]')   #remove uppercase letter in the key
	
	format $key
	filename=$3

	case $1 in
		-e*)	encrypt $keywords $filename
			;;
		-d*)	decrypt $keywords $filename
			;;
	esac
fi
