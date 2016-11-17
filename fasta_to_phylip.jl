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

function write_phyml_format(sequence_array, fasta_file)
	output_file = open(join(split(fasta_file, '.')[1:end-1],'.')*".phy","w")
	number_of_sequences = length(sequence_array)
	alignment_length = length(sequence_array[1].seq)
	write(output_file, " "*string(number_of_sequences)*" "*string(alignment_length)*"\n")
	for sequence in sequence_array
		oneline_string = remove_newlines(string(sequence.seq))
		write(output_file, sequence.name*"\t"*oneline_string*"\n")
	end
end

write_phyml_format(import_fasta(ARGS[1]),ARGS[1])