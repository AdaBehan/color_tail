#!/bin/awk -f  
BEGIN { 
print "AWK Script Starting" 

highlight_terms[ARGC]
drop_terms[ARGC]

drop_flag      = 0
highlight_flag = 0

d_count  = 0
h_count = 0

for (i = 1; i < ARGC + 1; i++)
{
    
    if (drop_flag == 1){
        drop_terms[d_count] = ARGV[i]
        d_count ++
    }
    
    else if (highlight_flag == 1){
        highlight_terms[h_count] = ARGV[i]
        h_count ++
    }

    if (ARGV[i] == "--exc"){
        drop_flag = 1
        highlight_flag = 0
    }
    
    else if (ARGV[i] == "--inc"){
        highlight_flag = 1
        drop_flag = 0
    }

    ARGV[i] = ""
}


}# end BEGIN
{


    $0 = substr($0, index($0,$4))

    for (i = 0; i < length(drop_terms); i++)
    {
        if (length(drop_terms[i]) > 2 && $0 ~ drop_terms[i])
            next #skip this line 
    }

    for (i = 0; i < length(highlight_terms); i++)
    {
        if (length(highlight_terms[i]) > 2 && $0 ~ highlight_terms[i])
            $0 = target($0,search1)
    }

    if ($3~(/!!!/)) 
        $0 = red($0)
        #RED=True

    else if ($3~(/\(ERROR\)/)) 
        $0 = red($0)
        #RED=True

    else if ($3~(/\(NOTICE\)/))
        $0 = blue($0)
        #BLUE=True

    else
        $0 = normal($0)

    print $0 
}#end  


function normal(s)
{
    s = "\033[38;5;250m" s 
    return s  
}

function red(s) 
{
    s = "\033[31;1m" s "\033[0m"
    return s
}

function blue(s) 
{
    s = "\033[34;1m" s "\033[0m"
    return s
}

function target(s,t) 
{
    gsub(t, "\033[33;1m" t "\033[0m\033[97;1m" ,s)
    #s = "\033[97;1m" s "\033[0m"
    return s
}
