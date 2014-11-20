#!/bin/bash
#
# Snakes.sh 
#
# A game of snakes and ladders.
# Script syntax described below.

trap "" SIGINT SIGQUIT SIGTERM

# A function for 1.????????????.
invalid()
{
	echo "Invalid parameters!"
	echo -e "\nInitialise mode syntax: Snakes.sh N L S directory\n"
	echo "N for number of cells."
	echo "S for number of snakes."
	echo "L for number of ladders."	
	echo "directory should not exist."
	echo -e "\nPreset mode syntax: Snakes.sh directory\n"
	echo -e "directory must exist.\n"
}

initialise()
{
	# Initialisation Phase.
	echo "Entering Initialisation phase"
	N=$1;L=$2;S=$3
	DIR=$4
	
	# Check 2.????????????.
	
	if [ -d $DIR ]
	then
		echo -e "3.????????????\n"
		exit 1
	else
		echo -e "4.????????????\n"
	fi
	
	# Checks.
	
	if [ $N -lt 20 ]
	then
		N=20
		echo "5.????????????"
	fi
	MAX=`expr 15 \* $N / 100`
	MIN=`expr 5 \* $N / 100`
	if [ $L -gt $MAX ]
	then
		echo "6.????????????"
		L=$MAX
	fi
	if [ $L -lt $MIN ]
	then
		echo "7.????????????"
		L=$MIN
	fi
	if [ $S -gt $MAX ]
	then
		echo "8.????????????"
		S=$MAX
	fi
	if [ $S -lt $MIN ]
	then
		echo "Not enough snakes: increasing to $MIN"
		S=$MIN
	fi

	# Determine the position of the ladders and snakes now.
	# Define OBJECT to contain 0 for empty, 1 for snake head
	# 2 for snake tail, 3 for ladder foot and 4 for
	# ladder head.
        # POINT is where an object (1,3) point to, this is
	# necessary for the file generation.

	# Initialise OBJECT and POINT
	X=2
	while [ $X -lt $N ]
	do
	  OBJECT[$X]=0
	  POINT[$X]=0
	  let X=X+1
	done

	# Snakes first
	X=0
	while [ $X -lt $S ]
	do
	  ONE=`expr $RANDOM % \( $N - 2 \)  + 2`
	  if [ ${OBJECT[$ONE]} -eq 0 ]
	  then
	      TWO=`expr $RANDOM % \( $N - 2 \)  + 2`
	      if [ ${OBJECT[$TWO]} -eq 0 ] && [ $ONE -ne $TWO ]
	      then
		  if [ $ONE -gt $TWO ]
		  then
		      OBJECT[$ONE]=1
		      POINT[$ONE]=$TWO
		      OBJECT[$TWO]=2
		  else
		      OBJECT[$TWO]=1
		      POINT[$TWO]=$ONE
		      OBJECT[$ONE]=2
		  fi
		  echo "9.????????????"
		  let X=X+1
	      fi
	  fi
	done

	# Ladders next
	X=0
	while [ $X -lt $L ]
	do
	  ONE=`expr $RANDOM % \( $N - 2 \)  + 2`
	  if [ ${OBJECT[$ONE]} -eq 0 ]
	  then
	      TWO=`expr $RANDOM % \( $N - 2 \)  + 2`
	      if [ ${OBJECT[$TWO]} -eq 0 ] && [ $ONE -ne $TWO ]
	      then
		  if [ $ONE -gt $TWO ]
		  then
		      OBJECT[$ONE]=4
		      POINT[$TWO]=$ONE
		      OBJECT[$TWO]=3
		  else
		      OBJECT[$TWO]=4
		      POINT[$ONE]=$TWO
		      OBJECT[$ONE]=3
		  fi
		  echo "10.????????????"
		  let X=X+1
	      fi
	  fi
	done

	# Now generate the directories and object files.
	
	mkdir $DIR
	cd $DIR
	X=1
	while [ $X -le $N ]
	do
	  mkdir $X
	  echo $X ${OBJECT[$X]} ${POINT[$X]}
	  case ${OBJECT[$X]} in
	      1) echo ${POINT[$X]} >> $X/snake
                  ;;
	      3) echo ${POINT[$X]} >> $X/ladder
	      ;;
	      *) ;;
	      esac
	  let X=X+1
	done

	cd $SAVE
	echo -e "\nInitialisation Complete"
}

check()
{
	# Run a check on the directory to make sure the cells
	# are all there and to obtain the value for N.
	ls -1F | grep "^[0-9]*/$" | sort -n > temp.txt
	START=`grep -n "^1/$" temp.txt | cut -d":" -f 1`
	N=`tail -1 temp.txt | cut -d"/" -f 1`
	tail +$START temp.txt > temp2.txt
	X=`wc -l < temp2.txt`
	rm temp.txt
	rm temp2.txt
	
	if [ $X -eq $N ]
	then
		echo "Directory checks out: $N cells"
	else
		echo "Directory has missing cells."
		exit 1
	fi
}

game()
{
	DIR=$1
	echo "Entering game phase: $N cells"
	cd $1
	C=1;
	cd $C
	GO=1
	while [ $GO -eq 1 ]
	do
		echo "In cell $C: press return to continue"
		read $JUNK
		ROLL=`expr $RANDOM % 6 + 1`
		echo "You rolled a $ROLL"
		let D=ROLL+C
		if [ $D -gt $N ]
		then
			echo "That would 11.????????????"
		fi
		if [ $D -eq $N ]
		then
			echo "Moving into cell $N..."
			echo "You have 12.????????????"
			GO=0
			break
		fi
		if [ $D -lt $N ]
		then
			let C=D
			echo "Moving into cell 13.????????????"
			cd ../$C
			# Test for a snake or a ladder.
			# This uses the generation rule that no snake
			# or ladder points to a cell containing another
			# snake or ladder.
			if [ -f snake ]
			then
				DOWN=`cat snake`
				echo "Sliding down the snake to $DOWN :( "
				C=$DOWN
				cd ../$DOWN
			elif [ -f ladder ]
			then
				UP=`cat ladder`
				echo "Climbing up the ladder to $UP :) "
				C=$UP
				cd ../$UP
			fi
		fi
	done
}

# ----------------------------------------------------------------------------
# This is the "main" part of the script.

# Record the present working directory before moving around.
SAVE=`pwd`

if [ $# -eq 1 ]			# Test for preset mode.
then
	echo "Preset mode"
	if [ -d $1 ]
	then
		echo "14.????????????"
		cd $1
		check
		cd $SAVE
		game $1 $N
	else
		echo -e "Directory $1 does not exist!\n"
		exit 1
	fi
elif [ $# -eq 4 ]		# Test for new setup mode.
then
	echo "New setup mode"
	
	initialise $1 $2 $3 $4
	game $4 $N
else
	invalid;exit 1
fi

exit 0
