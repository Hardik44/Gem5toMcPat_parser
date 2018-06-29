# Gem5toMcPat_parser
Gem5 to McPat parser for non-homogeneous multi-core processors

This parser basically work for Non-homogeneous multi-core processors. We also have L2 cache in each core.
If you have homogeneous cores than you have make changes in the parser.
parser will use json, stats and mcpat-template files as a input and it will generate xml file as a output.
parser will find mcpat-template parameters in the json and stat files then write that values into xml file.


### Setup McPat:
McPat can be downloaded from this [link](https://code.google.com/archive/p/mcpat/). After downloading the McPat.tar.gz file you can extract the file by following command.
```
$ tar xvzf McPat.tar.gz
```
After extracting the mcpat tar file if you are using 64-bit machine, make following changes in the mcpat.mk file.
```
gxx -m32         //here remove the -m32
gcc -m32         //here remove the -m32
```
```
$ make
```

### Run Gem5toMcpat parser:
```
$ python Program.py <statFileName.txt>  <configFile.json>  <mcpat-template.xml>
```

This script will generate configFileName.xml in the same directory. This file will be used to run McPat.

### Run McPat :
```
$ ./mcpat -infile <configFileName.xml> -print_level 5 -opt_for_clk 1 > mcpatoutput
```
So here we have output from McPat in mcpatoutput file. 

### Run multiple Gem5 output files through McPat:

Here Program.py, auto.sh, ARM_A9_2GHz.xml and Xeon.xml should be in same directory.

```
$ chmod +x auto.sh
$ ./auto.sh <gem5_outputfileDirectory_path>  <current_Directory_path> <mcpat_Directory_path>
```

This will create the mcpat output and corresponding .csv file in the gem5_outputfile directory.
mcpatOutput.csv contains Runtime Dynamic power value in front of configFileName. 

### Run multiple Gem5 output directory through McPat:
If we have directory tree for Gem5 output like belove for that we have created master bash main.sh script that will run through all the sub directory.

```
InputFiles
        ├── Matmul
        │   ├── matmul100
        │   ├── matmul100_AMD
        │   ├── matmul100_ARM
        ├── Montecarlo
        │   ├── montecarlocalcpi100000
        │   ├── montecarlocalcpi1000000
        │   ├── montecarlocalcpi1000000_AMD
        └── Qsort
            ├── qsort1000
            ├── qsort1000_AMD
            ├── qsort1000_ARM
```
Here each of the subdirectory contains .json and .txt files. Directory should not be empty. If we run this script it will generate mcpat output into each of subdirectory. Let’s say directory matmul100 will have mcpatOutput.csv and mcpat_configFileName for each of the input files in matmul100 directory. Same for that other subdirectory.

This script call above listed auto.sh in the background so It takes lots of cpu power. so don’t run on the desktop machine. If you need to run make changes in main.sh and run in foreground.

```
$ chmod +x main.sh
$ ./main.sh <InputFiles_Directory_path>  <current_Directory_path> <mcpat_Directory_path>
```

Basically it will go through each of the subdirectory and will call auto.sh script in the background.
It will wait for one parent directory to complete and then it will run another directory. For example from above tree first, it will run Matmul directory and wait for all the subdirectory to complete then it will run Montecarlo directory.
Each of the subdirectory will have mcpat output files. 





