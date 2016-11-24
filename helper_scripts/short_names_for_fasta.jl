function add_number_to_name(name)
    
    if in(strip(name)[end], map(string,collect([0:9])))
        last_number = parse(Int,strip(name)[end])
        new_number = last_number+1
        new_name = strip(name)[1:end-1]*string(new_number)
    else
        new_name = strip(name)[1:end-1]*"0"
    end

    return new_name
end

function make_name_short(long_name, existing_names)
    short_name = long_name[1:3]*join(matchall(r"_{1}.{1}",long_name),"")
    
    if in(short_name,map(strip,existing_names))
        short_name = add_number_to_name(short_name)
    end

    if length(short_name) <= 10
        extra_space = join(fill(" ",10-length(short_name)))
        return short_name*extra_space
    else
        return short_name[1:9]*short_name[end]
    end
end

function process_fasta_file(filename)
    output_file = join(split(filename,'.')[1:end-1],'.')*".shortnames.faa"

    existing_names = []

    output = open(output_file,"w")

    for line in readlines(open(filename))
        if startswith(line, ">")
            long_name = lstrip(split(chomp(line))[1],'>')
            short_name = make_name_short(long_name, existing_names)
            push!(existing_names, short_name)
            write(output,">"*short_name*"\n")
        else
            write(output, line)
        end
    end
end

process_fasta_file(ARGS[1])

