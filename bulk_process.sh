#!/bin/bash +x
# crontab -l > mycron
# 0 7 * * * ./bulk_process.sh >> mycron 
# crontab mycron
if [ $# -ne 3 ]
then 
	echo "./bulk_process.sh <username@hostname> <filepath> <localpath>"
	exit 1
else
	
	n=0
	l=0
	index=0
	while read line
	do
		if [ $index -gt 33 ]
		then 
			for((i=1;i<8;i++))
			do
				temp[$i]=`echo $line|cut -d ":" -f$i`
			done

			parray[$n]=${temp[1]}:${temp[5]}:${temp[4]} #account from local
			let index++
			let n++
		else
			let index++
		fi
	done < /etc/passwd

	ind=0

	while read LINE
	do
		if [ $ind -gt 33 ]
		then 
			for((i=1;i<8;i++))
			do
				Temp[$i]=`echo $LINE|cut -d ":" -f$i`
			done
			
			#parray[$m]="${parray[$m]}:${Temp[2]}"
			
			let ind++
		else
			let ind++
		fi
	done < /etc/shadow
	
	scp $1:$2 $3 > b.txt

	if [ -s b.txt ]
	then
		cat b.txt
		rm b.txt
		exit 1
	else
		tmp=$(basename "$2" ".txt")

		File=$tmp.txt

		while read Line
		do
			for((i=1;i<8;i++))
			do
				TemP[$i]=`echo $Line|cut -d ":" -f$i`
			done
			narray[$l]="${TemP[1]}:${TemP[2]}:${TemP[3]}" #account from server
			pass[$l]=${TemP[4]}
			let l++
		done < $File

		rm b.txt
	fi
	
	for((i=0;i<n;i++))
	do
		for((j=0;j<l;j++))
		do
			if [ "${parray[$i]}" == "${narray[$j]}" ] #clean the same account
			then
				parray[$i]=""
				narray[$j]=""
			fi
		done
	done

	if [ ! -d /usr/local/archives ]
	then
		mkdir /usr/local/archives
	fi

	for((i=0;i<n;i++))   
	do
		if [ ! -z "${parray[$i]}" ]
		then
			for((j=1;j<5;j++))
			do
				temP[$j]=`echo ${parray[$i]}|cut -d ":" -f$j`
			done

			location=`find /home -name ${temP[1]}`	
			tar -cvf ${temP[1]}.tar $location	
			mv ${temP[1]}.tar /usr/local/archives
			rm -rf $location
			userdel -r ${temP[1]}
			echo "User ${temP[1]} deleted !!!"
		fi
	done 

	#delete old user
	
	for((i=0;i<l;i++))  
	do
		if [ ! -z "${narray[$i]}" ]
		then
			for((j=1;j<4;j++))
				do
					temp[$j]=`echo ${narray[$i]}|cut -d ":" -f$j`
				done
			comment=${temp[2]%",,,"}
			useradd ${temp[1]} -c "$comment" -g ${temp[3]} -m
			echo "#!/bin/bash" > tmp.sh
			echo "sudo passwd ${temp[1]} <<EOF" >> tmp.sh
			echo "${pass[$i]}" >> tmp.sh
			echo "${pass[$i]}" >> tmp.sh
			echo "EOF" >> tmp.sh
			chmod 700 tmp.sh
			./tmp.sh 2>/dev/null
			rm tmp.sh
			echo "${temp[1]} created sucessfully!!!"
		fi		
	done

	#add new user
fi

