#!/bin/bash +x

usage()
{
	echo "./useradd.sh -P <Passwd file> -S <Shadow file> -G <Group file> OR"
	echo "./useradd.sh -P <Passwd file> -S <Shadow file> -G <Group file> -p <Passwd info> -s <Shadow info>"
	exit 1
}
#=========================main script=========================
if [ $# -eq 6 ]
then
	if [ ! -f $2 ] 
	then 
		echo "$2 is not a file !!!"
		usage
	fi

	if [ ! -f $4 ] 
	then 
		echo "$4 is not a file !!!"
		usage
	fi

	if [ ! -f $6 ] 
	then 
		echo "$6 is not a file !!!"
		usage
	fi

	set -- `getopt -q PSG "$@"`  

	while [ -n "$1" ]  
	do  
		case "$1" in  
		-P) 	
			len=`expr length $5` #remove single quotes
			psf=${5:1:$len-2}		
		;;  
		-S)   
			le=`expr length $5`
			sf=${5:1:$le-2}
		;;  
		-G) 
			leng=`expr length $5`
			gf=${5:1:$leng-2}	
		;;  
		--) shift  
		break;;  
		*)  usage		
		esac  
		shift  
	done

	echo "Enter username: "
	read username
	if [ `expr length $username` -lt 3 -o `expr length $username` -gt 31 ]
	then
		echo "The username is too long or to short !!!"
		exit 1
	fi

	echo "Enter Password: "
	read password
	if [ `expr length $password` -lt 5 -o `expr length $password` -gt 8 ]
	then
		echo "The password is too long or to short !!!"
		exit 1
	fi

	encrypt=$(perl -e 'print crypt("$password","salt")') #using crypt(3)

	echo "Enter Userid: "
	read userid
	expr $userid + 0 &>/dev/null
	if [ $? -ne 0 ] 
	then
		echo "Userid must be integer!"
		exit 1
	fi
	if [ $userid -lt 1000 -o $userid -gt 60000 ]
	then
		echo "The userid must between 1000 and 60000!!!"
		exit 1
	fi
	for uid in `awk -F: '$0=$3' $psf`
	do
		if [ $uid -eq $userid ]
		then
			echo "The userid $userid has already exist!!!"
			exit 1
		fi
	done

	echo "Enter Primary Groupid: "
	read groupid
	expr $groupid + 0 &>/dev/null
	if [ $? -ne 0 ] 
	then
		echo "Groupid must be integer!"
		exit 1
	fi
	if [ $groupid -lt 0 -o $groupid -gt 60000 ]
	then
		echo "The groupid must between 0 and 60000!!!"
		exit 1
	fi
	for gid in `awk -F: '$0=$3' $gf`
	do
		if [ $gid -eq $groupid ]
		then
			Find=true
			break
		fi
	done
	if [ ! $Find ]
	then 
		echo "The Primary Groupid $groupid is not found !!!"
		exit 1
	fi

	echo "Enter User Info: "
	read userinfo

	echo "Enter User home directory: " 
	read hd

	echo "Enter Login shell: "
	read logshell

	echo "#!/bin/bash" > temp.sh
	echo "sudo useradd $username -u $userid -g $groupid -c $userinfo -d $hd -s $logshell -m -p $encrypt" >> temp.sh
	chmod 700 temp.sh
	./temp.sh 2>a.txt
	rm temp.sh
	#useradd will give a warning if the home directory is already existed and delete the created user
	if [ -s "a.txt" ]
	then
		cat a.txt
		sudo userdel $username
		echo "$username created failed !!!"
		rm a.txt
		exit 1
	else
		echo "#!/bin/bash" > tmp.sh
		echo "sudo passwd $username <<EOF" >> tmp.sh
		echo "$password" >> tmp.sh
		echo "$password" >> tmp.sh
		echo "EOF" >> tmp.sh
		chmod 700 tmp.sh
		./tmp.sh 2>/dev/null
		rm tmp.sh
		echo "$username created sucessfully!!!"
	fi

	rm a.txt
elif [ $# -eq 10 ]
then
	if [ ! -f $2 ] 
	then 
		echo "$2 is not a file !!!"
		usage
	fi

	if [ ! -f $4 ] 
	then 
		echo "$4 is not a file !!!"
		usage
	fi

	if [ ! -f $6 ] 
	then 
		echo "$6 is not a file !!!"
		usage
	fi

	set -- `getopt -q PSGps "$@"`  

	while [ -n "$1" ]  
	do  
		case "$1" in  
		-P) 			
			Len=`expr length $7` #remove single quotes
			Psf=${7:1:$Len-2}		
		;;  
		-S)   
			Le=`expr length $7`
			Sf=${7:1:$Le-2}
		;;  
		-G) 
			Leng=`expr length $7`
			Gf=${7:1:$Leng-2}	
		;;
		-p)    	
			length=`expr length $7`
			passinfo=${7:1:$length-2}
		;;
		-s)	
			chang=`expr length $7`
			shadowinfo=${7:1:$chang-2}
		;;
		--) shift  
		break;;  
		*)  usage		
		esac  
		shift  
	done

	for((i=1;i<8;i++))
	do
		information[$i]=`echo $passinfo|cut -d ":" -f$i`
	done

	if [ `expr length ${information[1]}` -lt 3 -o `expr length ${information[1]}` -gt 31 ]
	then
		echo "The username is too long or to short !!!"
		exit 1
	fi

	expr ${information[3]} + 0 &>/dev/null
	if [ $? -ne 0 ] 
	then
		echo "Userid must be integer!"
		exit 1
	fi
	if [ ${information[3]} -lt 1000 -o ${information[3]} -gt 60000 ]
	then
		echo "The userid must between 1000 and 60000!!!"
		exit 1
	fi
	for uid in `awk -F: '$0=$3' $Psf`
	do
		if [ $uid -eq ${information[3]} ]
		then
			echo "The userid ${information[3]} has already exist!!!"
			exit 1
		fi
	done

	expr ${information[4]} + 0 &>/dev/null
	if [ $? -ne 0 ] 
	then
		echo "Groupid must be integer!"
		exit 1
	fi
	if [ ${information[4]} -lt 0 -o ${information[4]} -gt 60000 ]
	then
		echo "The groupid must between 0 and 60000!!!"
		exit 1
	fi
	for gid in `awk -F: '$0=$3' $Gf`
	do
		if [ $gid -eq ${information[4]} ]
		then
			Find=true
			break
		fi
	done
	if [ ! $Find ]
	then 
		echo "The Primary Groupid ${information[4]} is not found !!!"
		exit 1
	fi

	if test -d ${information[6]} 
	then
		echo "${information[6]} is already existed !!!"
		exit 1
	fi

	if [ ! -f ${information[7]} ] 
	then
		echo "${information[7]} is not found !!!"
		exit 1
	fi
                              
	flock -x $Psf -c "sudo echo $passinfo >> $Psf" 
	
	flock -x $Sf -c "sudo echo $shadowinfo >> $Sf"
	#file lock for updated file

	sudo mkdir -p ${information[6]}
	sudo chown ${information[1]}:${information[4]} ${information[6]}
	echo "${information[1]} created sucessfully !!!"
else
	usage
fi

