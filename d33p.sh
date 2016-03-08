#!/bin/bash
#
#  Author [73mp74710n]
#  Email [<73mp74710n@sagint.com>]
#  Team: [Nigeria Cyber Army ]
# 
#  
#[LICENSE]
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#########################VARIABLES#######################################

declare -i limit
[ ! -o xpg_echo ] && shopt -s xpg_echo
[ ! -o expand_aliases ] && shopt -s expand_aliases
open="\e["
close="\e[0m"
bold="1;"
red="31m"
green="32m"

alias c="reset"
usage() {
    cat <<EOF
usage:- ${0##*/} [option] [site]

b      Use Bing to make the Search

g      Use Google to make the search

l      How d33p should i go, if not set , it defaults to 10

example:

//Crawl a website, through any of the option
${0##*/} [any option(-b|-g)] site:nameofwebsite

//To Check for a particular filetype
${0##*/} -g filetype:typeoffile

//Any Other google or bing dork is acceptable

EOF

}
bing(){
    
    exec 5>outfile.log
    c
    echo "\n\n${open}${bold}${green}\t\t\tDON'T FORGET TO CHECK THE LOGS${close}"

    local burl="$*"
    local ip;

    [ -z "$burl" ] && ${burl?An Arguement needs to be parsed to bing } && exit $RANDOM

    [ "${limit}" == "0" ] && limit=10

    declare bString="www.bing.com/search?q=$burl"
    
    for getBing in $(seq 1 ${limit} )
    do
	
	if  { curl -s ${bString}'&'first=${getBing} | grep "No results found" >/dev/null 2>&1; }
	then

	    echo "${open}${bold}${red}No result was found${close}" && exit $RANDOM
	    
	fi

	for _bing in $( curl -s ${bString}'&'first=${getBing} | sed 's/<cite>/\n<cite>/g;s/<\/cite>/<\/cite>\n/g;s/<strong>//g;s/<\/strong>//g'\
			      | grep --color "<cite>" | sed 's/<cite>//g;s/<\/cite>//g' )
	do

	    #_b=$( echo $_bing | sed 's,https://,,' )
	    local _b="${_bing//https:\/\//}"
	    local _cut=${_b%%/*}
	    
	    { >/dev/tcp/"$_cut"/80 ;}>/dev/null 2>&1
	    (( $? != 0 )) && continue
	    
		
	    echo "${open}${bold}${green}\t\tWebsite:- ${close}${open}${bold}${red}$_bing${close}" | tee -a /proc/self/fd/5
	    
	 
	    if $( : $_cut )
	    then
		_bing=${_cut}
  	 
	    else
		:
	    fi
	    
	    
	    ip=( $(nslookup  "${_bing}" | grep "Address: " | sed 's/Address: //g;s/ /, /g' ) )
	    #ip=$( echo "${ip[@]}" | sed 's/ /, /g' )
	    ip="${ip[@]// /,}"
	    
	    echo "${open}${bold}${green}\t\tIpAddress: ${close}${open}${bold}${red}${ip}${close}\n\n"  | tee -a /proc/self/fd/5
	    sleep 2

	    
	    
	done
	
	
    done
    exec 5>&-
	
}
google(){
    
    exec 5>outfile.log
    c

    echo "\n\n${open}${bold}${green}\t\t\tDON'T FORGET TO CHECK THE LOGS${close}\n\n"
    
    local gurl="$*"
    local ip;
    [ -z "$gurl" ] && ${gurl?An Arguement needs to be parsed to google } && exit $RANDOM

    [ "${limit}" == "0" ] && limit=10

    declare -x gString="https://www.google.com/search?q=$gurl"

    for getGoogle in $(seq 1 ${limit})
    do
	for _google in $( curl -s $gString'&'start=${getGoogle} \
			       --user-agent \
			       "Surf/0.4.1 (X11; U; Unix; en-US) AppleWebKit/531.2+ Compatible (Safari; MSIE 9.0)" | \
				sed 's/<cite>/\n<cite>/g;s/<b>//g;s/<\/b>//g;s/<\/cite>/\n<\/cite>/g' | grep "<cite>" | sed 's/<cite>//g' )
	do
	    #_b=$( echo $_google | sed 's,https://,,' )
	    local _b="${_google//https:\/\//}"
	    local _cut="${_b%%/*}"
	  
	    
	    { >/dev/tcp/"${_cut}"/80 ;}>/dev/null 2>&1
	    (( $? != 0 )) && continue

	    echo "${open}${bold}${green}\t\tWebsite:- ${close}${open}${bold}${red}$_google${close}" | tee -a /proc/self/fd/5

	    if $( : $_cut )
	    then
		_google=${_cut}
  		
	    else
		:
	    fi
	    

	    
	    ip=( $(nslookup  "${_google}" | grep "Address: " | sed 's/Address: //g;s/ /, /g' ) )
	    ip="${ip[@]// /,}"
	    
	    echo "${open}${bold}${green}\t\tIpAddress: ${close}${open}${bold}${red}${ip}${close}\n\n"  | tee -a /proc/self/fd/5
	    sleep 2
	    
	done

	
    done
    exec 5>&-
}
OPTERR=0
(( ${#@} < 1 )) && usage && exit 1;
[[ ${1} == @(-g|-b|-h|-l) ]] ||  { usage && exit 1 ;}
while getopts "g:b:l:h" opt
do
    
    case $opt in
	g)
	    limit=${limit}
	    echo $OPTARG
	    echo $limit
	    google ${OPTARG}
	    ;;
	
	b)
	    limit=${limit}
	    #echo $limit
	    bing ${OPTARG}
	    ;;
	
	a) limit=${limit}
	   
	   google ${OPTARG}
	   echo ""
	   bing ${OPTARG}
	   ;;
	l) limit=${OPTARG}
	   ;;
	h) usage
	   ;;
	
	*) usage
	   ;;
	
	\?) usage
	    ;;
	
    esac
done
