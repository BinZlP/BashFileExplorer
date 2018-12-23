#!/bin/bash
cd $HOME

# Colors
RED='[31m[1m'
GREEN='[32m[1m'
PURPLE='[34m[1m'
YELLOW='[33m[1m'
RED_B='[41m[1m'
GREEN_B='[42m[1m'
PURPLE_B='[44m[1m'
GRAY_B='[40m[1m'
YELLOW_B='[43m[1m'
NC='[0m'

# Arrow keys
declare UP=[A
declare DOWN=[B

# List of files and PWD
declare templs

# Initialize list of files
function initLs() {
	templs=". .. "
	if [[ $PWD = $HOME ]]
	then
		mkdir -p 2017203044-TrashBin
	fi
	#file_only_list=`ls -l|grep ^-|rev|cut -d ' ' -f 1|rev`
	#dir_only_list=`ls -l|grep ^d|rev|cut -d ' ' -f 1|rev`
	#templs+="$dir_only_list "
	#templs+="$file_only_list "
	templs+=`ls`
}

declare file_each_total
declare file_only_total

declare gz_only
declare zip_only
declare tar_only
declare sh_only
declare -i sfile_only_total
declare -i nfile_only_total

declare dir_only_total
declare max_file_idv

# Initialize total
function initTotal() {
	file_each_total=`ls -l|wc -l`
	#file_each_total=`expr $file_each_total`
	file_only_total=`ls -l|grep ^-|rev|cut -d ' ' -f 1|rev|wc -l`

	gz_only=`find *.gz -type f 2>/dev/null|wc -l`
	zip_only=`find *.zip -type f 2>/dev/null|wc -l`
	tar_only=`find *.tar -type f 2>/dev/null|wc -l`
	sh_only=`find *.sh -type f 2>/dev/null|wc -l`
	sfile_only_total=`expr $gz_only + $zip_only + $tar_only + $sh_only`
	nfile_only_total=`expr $file_only_total - $sfile_only_total`

	dir_only_total=`expr $file_each_total - $file_only_total - 1`
	if [[ $PWD = $HOME ]]
	then
		file_each_total=`expr $file_each_total - 1`
		dir_only_total=`expr $dir_only_total - 1`
	fi
	max_file_idv=`expr $file_each_total + 1`
}

declare QUIT=`echo 'q'`
declare NEWLINE=`echo -e "\n"`
declare TREEOPT=`echo 't'`
declare DELETEOPT=`echo 'd'`
declare -i current_page=0
declare -i is_content_empty=1

# Print same character $1 times
function printEq() {
	for (( i=0; i<$1; i++ ))
	do
		printf "%c" $2
	done
}

# Print whitespace character $1 times
function printSpace() {
	for (( i=0; i<$1; i++ ))
	do
		printf "%c" ' '
	done
}

# Print frame of this script
function printFrame() {
printEq 47 '='
printf "%s" " 2017203044 HyungSeok Han "
printEq 47 '='
echo ""

#Print Frame
printEq 57 '='
printf "%s" " List "
printEq 57 '='
echo ""

for (( j=0; j<28; j++ ))
do
	printf "%c" '|'
	printSpace 26
	printf "%c" '|'
	printSpace 45
	printf "%c" '|'
	printSpace 45
	printf "%c" '|'
	echo ""
done

printEq 53 '='
printf "%s" " Information  "
printEq 53 '='
echo ""
for (( j=0; j<6; j++ ))
do
	printf "%c" '|'
	printSpace 118
	printf "%c" '|'
	echo ""
done

printEq 56 '='
printf "%s" " Total  "
printEq 56 '='
echo ""
printf "%c" '|'
printSpace 118
printf "%c" '|'
echo ""

printEq 57 '='
printf "%s" " END  "
printEq 57 '='
}

function clearList() {
	tput cup 2 0

	for (( j=0; j<28; j++ ))
	do
		printf "%c" '|'
		printSpace 26
		printf "%c" '|'
		printSpace 45
		printf "%c" '|'
		printSpace 45
		printf "%c" '|'
		echo ""
	done
}

# Print name of files which are located in current directory.
function printList() {
	# $1=y axis cursor
	declare -i cur_cursor=$1
	let cur_page=($1-2)/28
	if [ $cur_page -ne $current_page ]
	then
		current_page=$cur_page
		clearList
	fi

	# Set initial list cursor
	tput cup 2 0
	for (( i=2; i<30; i++ ))
	do
	tput cup $i 1
	let cur_i=$cur_page*28+$i
	file_name=`echo $templs|cut -d ' ' -f $cur_i`

	# Print file's name with color
	if [ -d $file_name ]
	then
		if [ $cur_i = $cur_cursor ]
		then
			if [ "$PWD/$file_name" = "$HOME/2017203044-TrashBin" ]
			then
				echo "${YELLOW_B}${file_name:0:26}${NC}"
			else
			echo "${PURPLE_B}${file_name:0:26}${NC}"
			#printInfo $cur_cursor "dir"
			fi
			cur_file_type="dir"

		else
			if [ "$PWD/$file_name" = "$HOME/2017203044-TrashBin" ]
			then
				echo "${YELLOW}${file_name:0:26}${NC}"
			else
				echo "${PURPLE}${file_name:0:26}${NC}"
			fi
		fi
	else
		file_t=`echo $file_name|cut -d '.' -f 2`
		if [ $cur_i = $cur_cursor ]
		then
			case "${file_t}" in
				"sh"|"out") echo "${GREEN_B}${file_name:0:26}${NC}";;
				"zip"|"tar"|"gz") echo "${RED_B}${file_name:0:26}${NC}";;
				*) echo "${GRAY_B}${file_name:0:26}${NC}";;
			esac
			#printInfo $cur_cursor "${file_t}"
			cur_file_type=${file_t}
		else
			case "${file_t}" in
				"sh"|"out") echo "${GREEN}${file_name:0:26}${NC}";;
				"zip"|"tar"|"gz") echo "${RED}${file_name:0:26}${NC}";;
				*) echo "${file_name:0:26}";;
			esac
		fi
	fi
	done
}

function printInfo() {
	# Initialize info tab..
	# $1=y axis cursor, $2=Filename extension
	tput cup 31 0
	for (( k=0; k<6; k++ ))
	do
		printf "%c" '|'
		printSpace 118
		printf "%c" '|'
	done

	# Print info. of files
	# file_info will be saved as form of: [Name] [Size] [Permission] [Type] [Access_time]
	declare -i cur_cursor_info=$1
	cur_file=`echo $templs|cut -d ' ' -f $cur_cursor_info`
	declare file_info=`stat -c "%n %s %a %F %x" $cur_file`

	tput cup 31 1
	file_name=`echo $file_info|cut -d ' ' -f 1`
	cur_file_name=$file_name
	echo "File Name: ${file_name:0:107}"


	tput cup 32 1
	if [ "$PWD/$file_name" = "$HOME/2017203044-TrashBin" ]
	then
		echo "${YELLOW}File Type: TrashBin${NC}"
	else
	case $2 in
		"dir") echo "${PURPLE}File Type: directory${NC}";;
		"gz"|"zip"|"tar") echo "${RED}File Type: compressed file${NC}";;
		"sh"|"out") echo "${GREEN}File Type: execute file${NC}";;
		*) echo "File Type: regular file";;
	esac
	fi

	tput cup 33 1
	#file_size=`echo $file_info|cut -d ' ' -f 2`
	file_size=`du -sh $file_name`
	file_size=`echo $file_size|cut -d ' ' -f 1`
	echo "File Size: $file_size"

	tput cup 34 1
	cr_time=`echo $file_info|cut -d ' ' -f 5-`
	cr_time_new=""
	cr_time_m=`echo $cr_time|cut -d '-' -f 2`
	case ${cr_time_m} in
		"01") cr_time_new+="January ";;
		"02") cr_time_new+="Febuary ";;
		"03") cr_time_new+="March ";;
		"04") cr_time_new+="April ";;
		"05") cr_time_new+="May ";;
		"06") cr_time_new+="June ";;
		"07") cr_time_new+="July ";;
		"08") cr_time_new+="August ";;
		"09") cr_time_new+="September ";;
		"10") cr_time_new+="October ";;
		"11") cr_time_new+="November ";;
		"12") cr_time_new+="December ";;
	esac
	cr_time_day=`echo $cr_time|cut -d '-' -f 3|cut -d ' ' -f 1`
	cr_time_yr=`echo $cr_time|cut -d '-' -f 1`
	cr_time_t=`echo $cr_time|cut -d ' ' -f 2|cut -d '.' -f 1`
	cr_time_new+="$cr_time_day $cr_time_t $cr_time_yr"
	echo "Access Time: $cr_time_new"

	tput cup 35 1
	file_pms=`echo $file_info|cut -d ' ' -f 3`
	echo "Permission: $file_pms"

	tput cup 36 1
	file_path="$PWD/"
	file_path+=$file_name
	echo "Absolute Path: ${file_path:0:103}"
}

# Print total status tab.
function printTotal {
	tput cup 38 20
	echo '                                                                        '

	totalsize_t=`du -hs $PWD`
	totalsize=`echo $totalsize_t|cut -d ' ' -f 1`
	total_file_prt=`expr $file_each_total - 1`

	tput cup 38 20
	printf "%s" "Total: $total_file_prt, Directory: $dir_only_total, SFile: $sfile_only_total, NFile: $nfile_only_total Size: ${totalsize}B"

}


# Clear content tab
function clearFileContent() {
	for (( j=0; j<28; j++ ))
	do
		line=`expr $j + 2`
		tput cup $line 28
		printSpace 45
	done
}


# Print file's content on content tab.
function printFileContent() {
	declare pfc_file_name=$1
	for (( j=1; j<29; j++ ))
	do
		content=`cat -n $pfc_file_name|sed -n ${j}p`
		line=`expr $j + 1`
		tput cup $line 28
		#jline=`echo $content|cut -d '$' -f $j`
		echo ${content:0:45}
	done
	is_content_empty=0
}

declare -i printTreeNumber
declare -a printTreeList
declare -a printTreeOpenList={""}
declare -i treeCursor
declare -i treeLineNumber
declare -i openCounter=0
declare treeCurFile

function printOpenList() {
	for (( ol=2; ol<29; ol++ ))
	do
		tput cup $ol 28
		olCur=`expr $ol - 1`
		echo ${printTreeList[$olCur]}
	done

}

function printTree() {
	# $1 = File Path, $2 = Depth of file, $3 = Line
	inputiter=`expr $3 - 1`
	printTreeNumber=`expr $printTreeNumber + 1`
	printTreeList[$inputiter]=${1}
	ptCurFileName=`echo $1`

	if [ $3 -gt 29 ]
	then
		return
	fi

	tput cup $3 75

	tPrintFileName=""
	declare -i pj
	declare -i pk

	for (( pj=1; pj<$2; pj++ ))
	do
		tPrintFileName+="····"
	done

	local file_name=`echo $1|rev|cut -d '/' -f 1|rev`

	if [ -d $1 ]
		then
		for (( pk=0; pk<=$openCounter; pk++ ))
		do
			checkiter=`expr $pk + 1`
			if [[ $1 = ${printTreeOpenList[$checkiter]} ]]
			then
				tPrintFileName+="-"
				break
			elif [ $pk = $openCounter ]
			then
				tPrintFileName+="+"
			fi
		done

		file_name_t="${tPrintFileName}"
		file_name_t+="${file_name}"
		file_name=$file_name_t

		if [[ $ptCurFileName = $treeCurFile ]]
		then
			echo "${PURPLE_B}${file_name:0:44}${NC}"
		else
			echo "${PURPLE}${file_name:0:44}${NC}"
		fi
	else
		tPrintFileName+=" "
		file_name_t="${tPrintFileName}"
		file_name_t+="${file_name}"
		file_name=$file_name_t

		file_t=`echo $file_name|cut -d '.' -f 2`
		if [[ $ptCurFileName = $treeCurFile ]]
		then
			case "${file_t}" in
				"sh"|"out") echo "${GREEN_B}${file_name:0:44}${NC}";;
				"zip"|"tar"|"gz") echo "${RED_B}${file_name:0:44}${NC}";;
				*) echo "${GRAY_B}${file_name:0:44}${NC}";;
			esac
		else
			case "${file_t}" in
				"sh"|"out") echo "${GREEN}${file_name:0:44}${NC}";;
				"zip"|"tar"|"gz") echo "${RED}${file_name:0:44}${NC}";;
				*) echo "${file_name:0:44}";;
			esac
		fi
	fi

}


function saveTreeContent() {
# $1 = Current Dir, $2 = Depth
	declare tcurdir=$1
	declare tcurlist=`ls $tcurdir`

	declare -i tdepth=$2
	declare -i curfilen=`ls -l $1|wc -l`

	declare -i kk
	declare -i jj

	for (( kk=1; kk<$curfilen; kk++ ))
	do
	tcurfilename=`echo $tcurlist|cut -d ' ' -f $kk`
	tcurfilepathname=$tcurdir/$tcurfilename

	printTree ${tcurfilepathname} $tdepth $treeLineNumber
	treeLineNumber=`expr $treeLineNumber + 1`

	for (( jj=1; jj<=$openCounter; jj++ ))
	do
	if [[ ${tcurfilepathname} = ${printTreeOpenList[$jj]} ]];
	then
		nextdepth=`expr $tdepth + 1`
		saveTreeContent $tcurfilepathname $nextdepth
	fi

	done

	done
}

function clearTree() {
	for (( j=1; j<29; j++ ))
	do
		line=`expr $j + 1`
		tput cup $line 75
		echo "                                            "
	done

}

function enterTree() {
	curTreePath=$PWD/$1
	treeList=`ls $curTreePath`
	treeCurFile=`echo $treeList|cut -d ' ' -f 1`
	treeCurFilet=$curTreePath/$treeCurFile
	treeCurFile=$treeCurFilet


	declare topt

	treeCursor=1
	while [ TRUE ]
	do
		treeLineNumber=2
		printTreeNumber=0
		saveTreeContent $curTreePath 1
		tput cup 1 1
		read -s -n 1 topt
		if [[ $topt = $TREEOPT ]]
		then
			clearTree
			break
		elif [[ $topt = '' ]]
		then
			declare add_topt
			read -n 2 add_topt
			topt+=$add_topt
			if [ $topt = $UP ]
			then
				if [ $treeCursor -gt 1 ]
				then
					treeCursor=`expr $treeCursor - 1`
					treeCurFile=${printTreeList[$treeCursor]}
				fi
			elif [ $topt = $DOWN ]
			then
				if [ $treeCursor -lt $printTreeNumber ]
				then
					treeCursor=`expr $treeCursor + 1`
					treeCurFile=${printTreeList[$treeCursor]}
				fi
			fi
		elif [[ $topt = "" ]];
		then
			clearTree
			for (( pt=0; pt<=$openCounter; pt++ ))
			do
				tpt=`expr $pt + 1`
				if [[ $treeCurFile = ${printTreeOpenList[$tpt]} ]]
				then
					printTreeOpenList[$tpt]=""
					break
				elif [ $pt = $openCounter ]
				then
					if [ -d $treeCurFile ]
					then
						openCounter=`expr $openCounter + 1`
						printTreeOpenList[$openCounter]=${printTreeList[$treeCursor]}
						break
					fi
				fi
			done
		elif [[ $topt = $QUIT ]]
		then
			clearTree
			break
		fi
	#clearFileContent
	#printOpenList
	done
}

function delete() {
# $1 = cur_file_name
	if [ "$PWD" = "$HOME/2017203044-TrashBin" ]
	then
		rm -rf $cur_file_name
	else
		rsync -avpq $cur_file_name "$HOME/2017203044-TrashBin"
		rm -rf $cur_file_name
	fi

}


declare opt
x=1
y=2
declare cur_file_type="dir"
declare cur_file_name=".."

printFrame
initLs
initTotal

while [ TRUE ]
do
	printList $y
	printInfo $y $cur_file_type
	printTotal
	tput cup 1 1

	stty -echo
	read -s -n 1 opt
	if [[ $opt = "" ]];
	then
		checkText=`file $cur_file_name|grep text`
		if [ $cur_file_type = "dir" ]
		then
			dest="./"
			dest+="$cur_file_name/"
			cd $dest
			initLs
			initTotal
			cur_file_name=".."
			x=1
			y=2
			clearList
		elif [[ -z $checkText ]]
		then
			sleep 0
		else
			tput cup 2 29
			printFileContent $cur_file_name
			tput cup 1 0
		fi
	elif [ $opt = '' ]
	then
		if [ $is_content_empty -eq 0 ]
		then
			clearFileContent
			is_content_empty=1
		fi
		declare add_opt
		read -n 2 add_opt
		opt+=$add_opt

		if [ $opt = $UP ]
		then
			if [ $y -gt 2 ]
			then
				y=`expr $y - 1`
			fi
		elif [ $opt = $DOWN ]
		then
			if [ $y -lt $max_file_idv ]
			then
				y=`expr $y + 1`
			fi
		fi
	elif [ $opt = $TREEOPT ]
	then
		if [[ $cur_file_type = "dir" ]]
		then
			enterTree $cur_file_name
		fi
	elif [ $opt = $QUIT ]
	then
		stty echo
		clear
		tput cup 0 0
		break
	elif [ $opt = $DELETEOPT ]
	then
		delete $cur_file_name
		cur_file_name=".."
		x=1
		y=2
		initLs
		initTotal
		clearList
	fi
done

