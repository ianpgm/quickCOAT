function get_faa_files(input_folder)
    return readdir(input_folder)[map(filename->endswith(filename,".faa"),readdir(input_folder))]
end

function get_genome_name(filename)
    for line in readlines(filename)
        if contains(line, "MULTISPECIES") || startswith(line, ">") == false
            println("Multispecies")
            continue
        else
            print(line)
            return replace(strip(match(r"\[.*\]",line).match,['[',']'])," ","_")
        end
    end
end

function main(input_folder)
    for filename in get_faa_files(input_folder)
        new_name = joinpath(input_folder,get_genome_name(joinpath(input_folder,filename))*".faa")
        if joinpath(input_folder,filename) != new_name
            mv(joinpath(input_folder,filename),new_name)
        end
    end
end

main(ARGS[1])