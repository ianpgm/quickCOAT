function get_faa_files(input_folder)
    return readdir(input_folder)[map(filename->endswith(filename,".faa"),readdir(input_folder))]
end

function get_genome_name(filename)
    firstline = readline(open(filename))
    return replace(strip(match(r"\[.*\]",firstline).match,['[',']'])," ","_")
end

function main(input_folder)
    for filename in get_faa_files(input_folder)
        new_name = get_genome_name(filename)*".faa"
        mv(filename,new_name)
    end
end

main(ARGS[1])