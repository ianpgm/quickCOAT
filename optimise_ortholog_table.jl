using DataFrames

function get_singles_and_zeros(ortholog_table)
    output_df = DataFrame()

    for ortholog in eachrow(ortholog_table)
        use_row = true
        for genome in names(ortholog)[3:end]
            if isna(ortholog[genome]) || length(matchall(r",",ortholog[genome]))+1 == 1
                continue
            else
                use_row = false
            end
        end

        if use_row
            if size(output_df,1) == 0
                output_df = ortholog.df[ortholog.row,:]
            else
                append!(output_df,ortholog.df[ortholog.row,:])
            end
        end
    end
    return output_df
end

function sort_singles_and_zeros_table(singles_and_zeros_table)
    available_genomes = Int64[]
    for ortholog in eachrow(singles_and_zeros_table)
        number_of_genomes = count(genome_ortholog->isna(genome_ortholog)==false,DataArray(ortholog.df[ortholog.row,3:end]))
        push!(available_genomes, number_of_genomes)
    end

    singles_and_zeros_table = singles_and_zeros_table[sortperm(available_genomes,rev=true),:]
    return singles_and_zeros_table
end

function find_bad_genomes(sorted_singles_and_zeros_table)
    genomes = []
    orthologs=[]

    for genome in names(sorted_singles_and_zeros_table)
        temporary_table = sorted_singles_and_zeros_table[setdiff(names(sorted_singles_and_zeros_table), [genome])]
        ortholog_count = 0
        for ortholog in eachrow(temporary_table)
            if any(isna,DataArray(ortholog.df[ortholog.row,:])) == false
                ortholog_count = ortholog_count +1
            end
        end
    push!(genomes, genome)
    push!(orthologs,ortholog_count)
    end

    genome_table = DataFrame(genome=genomes,ortholog_count=orthologs)

    print(genome_table[sortperm(genome_table[:ortholog_count],rev=true),:])
end





singles_and_zeros_table = get_singles_and_zeros(readtable(ARGS[1]))



sorted_singles_and_zeros_table = sort_singles_and_zeros_table(singles_and_zeros_table)

find_bad_genomes(sorted_singles_and_zeros_table)
