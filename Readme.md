#quickCOAT: quick Concatenated Ortholog Alignment Tree

quickCOAT produces a concatenated protein alignment based on input protein sequences from several genomes. It starts out by defining single-copy orthologs amongst the set of genomes you specify and uses those to build the alignment. A set of closely related organisms will therefore have a long alignment to compensate for limited divergence, while distantly related genome phylogenies will be based on fewer orthologs. In this way, quickCOAT is a fast, automated way to define the best possible set of orthologs for your concatenated protein phylogeny.

##Installation
###Prerequisites
The following programs must be installed and executable from your $PATH:
* [Julia](http://www.julialang.org/) version 0.5 or higher
  * Julia packages DataFrames, DataStructures, and Bio must also be installed. The following command will install the necessary packages: `julia -e "Pkg.add(\"DataFrames\");Pkg.add(\"DataStructures\");Pkg.add(\"Bio\")"`
* [BLAST+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
* [muscle](http://www.drive5.com/muscle/manual/install.html)

Alignments generated using quickCOAT may benefit from trimming using Gblocks.
* [Gblocks](http://molevol.cmima.csic.es/castresana/Gblocks.html)

You will also need some way of building a phylogenetic tree using the multiple sequence alignment that quickCOAT generates. Here are some options:
* [PhyML](http://www.atgc-montpellier.fr/phyml/binaries.php)
* [FastTree](http://www.microbesonline.org/fasttree/)
* [MrBayes](http://mrbayes.sourceforge.net/)

###Installation
Download the [newest release](https://github.com/ianpgm/quickCOAT/releases/), make the files `quickcoat`,`quickcoat.fasta_to_phylip`,`quickcoat.run_test` executable and add them to your $PATH. For example, on Linux or MacOS, if `~/bin` is in your $PATH:
```
wget https://github.com/ianpgm/quickCOAT/archive/v0.2.0.tar.gz
tar zxvf quickCOAT-0.2.0.tar.gz
chmod +x quickCOAT-0.2.0/quickcoat
chmod +x quickCOAT-0.2.0/quickcoat.fasta_to_phylip
chmod +x quickCOAT-0.2.0/quickcoat.fasta_to_nexus
chmod +x quickCOAT-0.2.0/quickcoat.run_test
ln -s /path/to/quickCOAT-0.2.0/quickcoat ~/bin/quickcoat
ln -s /path/to/quickCOAT-0.2.0/quickcoat.fasta_to_phylip ~/bin/quickcoat.fasta_to_phylip
ln -s /path/to/quickCOAT-0.2.0/quickcoat.fasta_to_nexus ~/bin/quickcoat.fasta_to_phylip
ln -s /path/to/quickCOAT-0.2.0/quickcoat.run_test ~/bin/quickcoat.run_test
```
You can run the test to see whether quickCOAT is working correctly by typing `quickcoat.run_test`.

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
  * `-t` or `--threads`: The number of blastp and muscle instances that will be run in parallel.
4. An example command: `quickcoat -r genome_of_interest.faa -q input_sequence_folder -e 0.00001 -i 35 -t 8 -o output_folder`
5. Some tree-building software requires a phylip- or nexus-formatted file for input (e.g. PhyML, MrBayes). Programs for this are included. Use the following commands: `quickcoat.fasta_to_phylip input_sequence_folder/concatenated_alignment.faa` and `quickcoat.fasta_to_nexus input_sequence_folder/concatenated_alignment.faa`. The files `concatenated_alignment.phy` or `concatenated_alignment.nex` respectively will appear in your output folder.

##Output
The output will appear in the folder that you specify. The following files will be generated:
* The reference BLAST database. You shouldn't have to look at this.
* `ortholog_table.tsv`: This is a tab-separated-value table containing the identifiers all of the orthologs in your genome set.
* `single_copy_ortholog_table.tsv`: This is a subset of the `ortholog_table.tsv` containing just those orthologs appearing exactly once in every genome. This is what the concatenated alignment is built on.
* `concatenated_alignment.faa`: This is the concatenated protein alignment in FASTA format, suitable for building phylogenetic trees.
* `report.txt`: This report stores the input files and parameters for the run, as well as the annotations of the proteins used for the alignment.
* `blast_output`: The folder containing BLAST output for each blastp run (with bitscore ratio included by quickCOAT).

##How it works
![quickCOAT overview chart](https://github.com/ianpgm/quickCOAT/blob/master/overview_chart.png)

##Getting help
If something isn't working, please post an [issue on Github](https://github.com/ianpgm/quickCOAT/issues) or send an email to the author, ianpgm at bios dot au dot dk.
