#!/usr/bin/awk -f  
BEGIN { 

highlight = ""
drop = ""

    print "AWK Script Starting" 

    for (i = 0; i <= ARGC; i++)
    {
        if (i == 0)
        {
            delete ARGV[i]
            continue
        }

        if (ARGV[i] == "--hl")
        {
            delete ARGV[i]
            i++
            for (inc_count = i; inc_count <= ARGC; inc_count++)
            {
                if (ARGV[inc_count] == "--dr")
                {
                    break
                }
                highlight = highlight ","ARGV[inc_count]                

            }
        }

        if (ARGV[i] == "--dr")
        {
            delete ARGV[i]
            i++
            for (inc_count = i; inc_count <= ARGC; inc_count++)
            {
                if (ARGV[inc_count] == "--hl")
                {
                    break
                }
                drop = drop","ARGV[inc_count]                

            }
        }
        delete ARGV[i]
    }

    split(drop,drop_terms,",")
    split(highlight,highlight_terms,",")

    for (i = 0; i <= length(highlight_terms); i++)
    {
        if (highlight_terms[i] == "")
            delete highlight_terms[i]
    }

    for (i = 0; i <= length(drop_terms); i++)
    {
        if (drop_terms[i] == "")
            delete drop_terms[i]
    }



}# end BEGIN
{
    $0 = substr($0, index($0,$4))
    for (i = 0; i < length(drop_terms); i++)
    {
        if ($0~drop_terms[i] && length(drop_terms[i]) >= 2)
        {
            next #skip this line 
        }
    }

    for (i = 0; i < length(highlight_terms); i++)
    {
        if ($0~highlight_terms[i] && length(highlight_terms[i]) >= 2)
        {
            $0 = target($0,search1)
            break
        }
    }

    if ($3~(/!!!/)) 
    {
        $0 = red($0)
        #RED=True
    }

    else if ($3~(/\(ERROR\)/)) 
    {
        $0 = red($0)
        #RED=True
    }

    else if ($3~(/\(NOTICE\)/))
    {
        $0 = blue($0)
        #BLUE=True
    }

    else
    {
        $0 = normal($0)
    }

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
    s = "\033[97;1m" s "\033[0m"
    return s
}
