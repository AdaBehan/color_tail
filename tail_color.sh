#!/bin/bash

FILE_PATH=$1
EXTRA1=$2
EXTRA2=$3
EXTRA3=$4


tail -f $FILE_PATH | awk -v extra1=$EXTRA1 -v extra2=$EXTRA2 -v extra3=$EXTRA3 \
      '
        {$1=$2=$3=""} 
        {
        if (length(extra1) > 1 && $0~extra1) 
            target($0,extra1) 
        else if (length(extra2) > 1 && $0~extra2) 
            target($0,extra2) 
        else if (length(extra3) > 1 && $0~extra3) 
            target($0,extra3) 
        else if ($6 == "Raemis(ERROR)") 
           red($0) 
        else if ($6 == "Raemis(!!! ERROR)") 
           red($0) 
        else if ($6 == "Raemis(NOTICE)") 
           blue($0)
        else
           normal($0)
        }

function normal(s){
    #print "\033[38;5;250m" s "\033[0m"
    print s
}

function red(s) {
    print "\033[31;1m" s "\033[0m"
}

function blue(s) {
    print "\033[34;1m" s "\033[0m"
}

function target(s,t) {
    sub(t, "\033[38;5;9m" t "\033[0m", s)
    print s

}'
    #print  "\033[0;1m"s"\033[0;1m" 
