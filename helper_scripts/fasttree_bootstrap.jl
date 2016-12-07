#!/usr/bin/env julia

using Bio.Seq

function import_fasta(fasta_file)
	output = []
	for record in open(FASTAReader,fasta_file)
		push!(output, record)
	end
	return output
end

function remove_newlines(input_string)
	return replace(input_string,"\n","")
end

function assign_numeric_identifier(numeric_id_dict,new_ID)
	if length(numeric_id_dict) == 0
		numeric_id_dict[new_ID] = join(fill("0",10))
	else
		new_numeric_id_int = maximum(map(numeric_id->parse(Int,numeric_id),values(numeric_id_dict)))+1
		new_numeric_id_string = join(fill("0",10-length(string(new_numeric_id_int))))*string(new_numeric_id_int)
		numeric_id_dict[new_ID] = new_numeric_id_string
	end
	return(numeric_id_dict)
end


function write_phyml_format(sequence_array, fasta_file)
	output_file = open("infile","w")
	output_fasta = open(join(split(fasta_file, '.')[1:end-1],'.')*".numeric_id.faa","w")
	number_of_sequences = length(sequence_array)
	alignment_length = length(sequence_array[1].seq)
	write(output_file, " "*string(number_of_sequences)*" "*string(alignment_length)*"\n")
	numeric_id_dict = Dict()
	for sequence in sequence_array
		numeric_id_dict = assign_numeric_identifier(numeric_id_dict,sequence.name)
		numeric_name = numeric_id_dict[sequence.name]
		oneline_string = remove_newlines(string(sequence.seq))
		write(output_file, numeric_name*oneline_string*"\n")
		write(output_fasta, ">"*numeric_name*"\n"*oneline_string*"\n")
	end
	close(output_file)
	close(output_fasta)
	return numeric_id_dict
end

numeric_id_dict = write_phyml_format(import_fasta(ARGS[1]),ARGS[1])

run(`seqboot`)

function run_FastTree(fasta_file)
	bootstrap_trees_output = join(split(fasta_file, '.')[1:end-1],'.')*".seqboot.fast.tree"
	master_tree_output = join(split(fasta_file, '.')[1:end-1],'.')*".numeric_id.fast.tree"
	renamed_fasta_file = join(split(fasta_file, '.')[1:end-1],'.')*".numeric_id.faa"
	bootstrap_number = ARGS[2]
	run(pipeline(`FastTree -n $bootstrap_number outfile`,bootstrap_trees_output))
	run(pipeline(`FastTree $renamed_fasta_file`,master_tree_output))
	FastTreeCompare_dir = joinpath(homedir(),"programs","FastTreeCompare")
	CompareToBootstrap_path = joinpath(FastTreeCompare_dir,"CompareToBootstrap.pl")

	bootstrapped_tree = readstring(`perl -I $FastTreeCompare_dir $CompareToBootstrap_path -tree $master_tree_output -boot $bootstrap_trees_output`)
	return bootstrapped_tree
end

function rename_tree(tree, numeric_id_dict, fasta_file)
	original_id_dict = Dict(zip(values(numeric_id_dict),keys(numeric_id_dict)))

	for numeric_id in values(numeric_id_dict)
		println("Replacing $numeric_id with "*original_id_dict[numeric_id])
		tree = replace(tree, numeric_id, string(original_id_dict[numeric_id]))
	end
	output_file = open(join(split(fasta_file, '.')[1:end-1],'.')*".bootstrapped.fast.tree","w")
	write(output_file, tree)
end

bootstrapped_tree = run_FastTree(ARGS[1])

rename_tree(bootstrapped_tree, numeric_id_dict, ARGS[1])


