function make_name_short(long_name)
    short_name = long_name[1:3]*join(matchall(r"_{1}.{1}",long_name),"")
    if length(short_name) <= 10
        extra_space = join(fill(" ",10-length(short_name)))
        return short_name*extra_space
    else
        return short_name[1:10]
    end
end

function process_phy_file(filename)
    output_file = join(split(filename,'.')[1:end-1],'.')*".shortnames.phy"

    output = open(output_file,"w")

    for line in readlines(open(filename))
        if startswith(line, " ")
            write(output,line)
            continue
        else
            long_name, sequence = split(line,'\t')
            short_name = make_name_short(long_name)
            println(long_name*" = "*short_name)
            write(output,join([short_name, sequence],'\t'))
        end
    end
end

process_phy_file(ARGS[1])

