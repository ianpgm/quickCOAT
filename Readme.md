#quickCOAT: quick Concatenated Ortholog Alignment Tree

quickCOAT produces a concatenated protein alignment based on input protein sequences from several genomes.

##Installation
###Prerequisites
The following programs must be installed and executable from your $PATH:
* [Julia](http://www.julialang.com/) version 0.5 or higher
  * Julia packages DataFrames, DataStructures, and Bio must also be installed. The following command will install the necessary packages: `julia -e "Pkg.add(\"DataFrames\");Pkg.add(\"DataStructures\");Pkg.add(\"Bio\")"`
* [BLAST+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
* [muscle](http://www.drive5.com/muscle/manual/install.html)

###Installation
Download the [newest release](https://github.com/ianpgm/quickCOAT/releases/), make the file `quickcoat` executable and add it to your $PATH. For example, on Linux or MacOS:
    wget https://github.com/ianpgm/quickCOAT/archive/v0.1-alpha.tar.gz
    tar zxvf quickCOAT-0.1-alpha.tar.gz
    ln -s quickCOAT-0.1-alpha/quickcoat ~/bin/quickcoat

##Usage
1. Make a new folder.
2. Copy all of the genomes you want to analyse into that new folder. Each genome should be a single fasta amino acid file containing that genome's protein sequences. The filename must end with `.faa` for quickCOAT to recognise it as an input file.
3. Run quickCOAT. Type `quickcoat` followed by the following parameters:
  * `-r` or `--reference`: The filename of your reference genome. Orthologs will be defined based on BLAST results relative to this genome.
  * `-q` or `--query_folder`: The name of the folder you created in step 1.
  * `-e` or `--evalue_threshold`: The maximum e-value from the BLAST results to have a pair of sequences count as an ortholog. For example, `0.00001`. The default is infinite (no threshold).
  * `-i` or `--identity_threshold`: The minimum percentage identity from the BLAST results to have a pair of sequences count as an ortholog. For example, `35`. The default is 0 (no threshold.)
  * `-o` or `--output_folder`: The name of the folder quickCOAT will create with your output files. This folder cannot already exist, otherwise it will produce an error.
  * `-b` or `--bitscore_threshold`: The bitscore ratio threshold to have a pair of sequences count as an ortholog. For example, `0.9`. The default is 0 (no threshold).
  * `-t` or `--threads`: The `num_threads` parameter that is passed to BLAST+.
4. An example command: `quickcoat -r genome_of_interest.faa -q input_sequence_folder -e 0.00001 -i 35 -t 8 -o output_folder`

##Output
The output will appear in the folder that you specify. The following files will be generated:
* A lot of BLAST output files and a reference BLAST database. These should hopefully be pretty self explanatory, but you shouldn't have to look at these.
* `ortholog_table.tsv`: This is a tab-separated-value table containing the identifiers all of the orthologs in your genome set.
* `single_copy_ortholog_table.tsv`: This is a subset of the `ortholog_table.tsv` containing just those orthologs appearing exactly once in every genome. This is what the concatenated alignment is built on.
* `concatenated_alignment.faa`: This is the concatenated protein alignment in FASTA format, suitable for building phylogenetic trees.

##How it works
