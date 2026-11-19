
######################################################################################
## EXPERIMENT TEMPLATE                                                              ##
##                                                                                  ##
## This executable creates a new directory with most of the machinery required      ##
## to run ATEAMS experiments locally or on remote machines. Currently, this file    ##
## configures experiments to run on GMU's HOPPER high-performance compute cluster   ##
## or on the Pangolin networked desktop workstation. Please edit this file to       ##
## meet your needs.                                                                 ##
######################################################################################

TEMPLATE="./.templates"

################################################################################
## When executed, prompts the user to input information about the experiment. ##
################################################################################

DIM="$(tput dim)"
BOLD="$(tput bold)"
STOP="$(tput sgr0)"

dimface() {
	printf "%s%s%s" "$(tput dim)" "$*" "$(tput sgr0)"
}

boldface() {
	printf "%s%s%s" "$(tput bold)" "$*" "$(tput sgr0)"
}


width=15


printf "%s\n%s\n\n" "$(boldface 'Creating a new workflow++ experiment.')" "$(dimface 'control + c to quit, enter to use default value')"

# Experiment name.
experiment="test"
printf "%-${width}s ${DIM}%s${STOP}${BOLD}\r" "name" $experiment
tput hpa $(( width + 1 ))
read -r userinput
experiment="${userinput:-$experiment}"
printf "${STOP}"

# Experiment model.
MODEL="Bernoulli"
printf "%-${width}s ${DIM}%s${STOP}${BOLD}\r" "model" $MODEL
tput hpa $(( width + 1 ))
read -r userinput
MODEL="${userinput:-$MODEL}"
MODEL=$(echo $MODEL | tr "[:upper:]" "[:lower:]")
printf "${STOP}"

# Experiment destination.
directory="./experiments++/${experiment}"
printf "%-${width}s ${DIM}%s${STOP}${BOLD}\r" "destination" $directory
tput hpa $(( width + 1 ))
read -r userinput
directory="${userinput:-$directory}"
printf "${STOP}"

directory="./experiments++/$experiment"
mkdir -p $directory


########################################################################
## Load arguments from the outer config file to get the user's email. ##
########################################################################
# source $TEMPLATE/.pangolin && export $(grep --regexp ^[A-Z] $TEMPLATE/.pangolin | cut -d= -f1)


##############################################
## Copies default directories into place.   ##
##############################################
mkdir -p $directory/output
mkdir -p $directory/output/figures
mkdir -p $directory/output/statistics
mkdir -p $directory/output/tape
# mkdir -p complexes



##############################################################################
## Each individual run (using the `Chain` and `Recorder` classes of ATEAMS) ##
## ingests templated JSON and stores data about the computation after it's  ##
## completed. The `simulation.py` file contains more information.             ##
##############################################################################

cp $TEMPLATE/metadata.h $directory/metadata.h
cp $TEMPLATE/Makefile $directory/Makefile


##################################################################################
## Because HOPPER (and many large HPCs) use the SLURM workload manager, the     ##
## next few sets of instructions create .slurm job configuration files specific ##
## to typical computation tasks.                                                ##
##################################################################################

######################
## Lattice (HOPPER) ##
######################

# # Edit header.
# header="$(cat $TEMPLATE/.default-slurm-header.txt)"
# header="${header}\n#SBATCH --job-name=${experiment}"
# header="${header}\n#SBATCH --output=./output/lattice.output.out"
# header="${header}\n#SBATCH --error=./output/lattice.error.out"
# header="${header}\n#SBATCH --mail-user=${USEREMAIL}"

# # Edit footer.
# footer="$(cat $TEMPLATE/.default-slurm-footer.txt)"
# execution="$(cat $TEMPLATE/.lattice.hopper.slurm)"
# footer="${footer}\n\n${execution}"
# zsheader="#!/bin/zsh\nexperiment=${experiment}\n\n"

# slurm="${header}\n\n${footer}"

# echo "$slurm" >> $directory/lattice.hopper.slurm


#########################
## Simulation (HOPPER) ##
#########################

# # Edit header.
# header="$(cat $TEMPLATE/.default-slurm-header.txt)"
# header="${header}\n#SBATCH --job-name=${experiment}"
# header="${header}\n#SBATCH --output=./output/simulation.output.out"
# header="${header}\n#SBATCH --error=./output/simulation.error.out"
# header="${header}\n#SBATCH --mail-user=${USEREMAIL}"

# # Edit footer.
# footer="$(cat $TEMPLATE/.default-slurm-footer.txt)"
# execution="$(cat $TEMPLATE/.simulation.hopper.slurm)"
# footer="${footer}\n\n${execution}"

# # Stitch files together and write.
# hopper="$(cat $TEMPLATE/.simulation.hopper.txt)"
# slurm="${header}\n\n${footer}"

# echo "$slurm" >> $directory/simulation.hopper.slurm
# echo "$hopper" >> $directory/simulation.hopper.sh
# chmod +x $directory/simulation.hopper.sh

zsheader="#!/bin/zsh\nexperiment=${experiment}\n\n"

###########################
## Simulation (Pangolin) ##
###########################
pangolin="$(cat $TEMPLATE/.simulation.pangolin.txt)"
pangolin="${zsheader}${pangolin}"
echo "$pangolin" >> $directory/simulation.pangolin.sh
chmod +x $directory/simulation.pangolin.sh

manager="$(cat $TEMPLATE/.simulation.manager.pangolin.txt)"
manager="${zsheader}${manager}"
echo "$manager" >> $directory/simulation.manager.pangolin.sh
chmod +x $directory/simulation.manager.pangolin.sh

############################
## Simulation (MEGLtower) ##
############################
megltower="$(cat $TEMPLATE/.simulation.megltower.txt)"
megltower="${zsheader}${megltower}"
echo "$megltower" >> $directory/simulation.megltower.sh
chmod +x $directory/simulation.megltower.sh

manager="$(cat $TEMPLATE/.simulation.manager.megltower.txt)"
manager="${zsheader}${manager}"
echo "$manager" >> $directory/simulation.manager.megltower.sh
chmod +x $directory/simulation.manager.megltower.sh

#####################
## Replay (HOPPER) ##
#####################
# header="$(cat $TEMPLATE/.default-slurm-header.txt)"
# header="${header}\n#SBATCH --job-name=${experiment}"
# header="${header}\n#SBATCH --output=./output/replay.output.out"
# header="${header}\n#SBATCH --error=./output/replay.error.out"

# footer="$(cat $TEMPLATE/.default-slurm-footer.txt)"
# execution="$(cat $TEMPLATE/.replay.hopper.slurm)"
# footer="${footer}\n\n${execution}"
# hopper="$(cat $TEMPLATE/.replay.hopper.txt)"

# slurm="${header}\n\n${footer}"




#######################
## Replay (Pangolin) ##
#######################
pangolin="$(cat $TEMPLATE/.replay.pangolin.txt)"
pangolin="${zsheader}${pangolin}"
echo "$pangolin" >> $directory/replay.pangolin.sh
chmod +x $directory/replay.pangolin.sh


manager="$(cat $TEMPLATE/.replay.manager.pangolin.txt)"
manager="${zsheader}${manager}"
echo "$manager" >> $directory/replay.manager.pangolin.sh
chmod +x $directory/replay.manager.pangolin.sh


########################
## Replay (MEGLtower) ##
########################
megltower="$(cat $TEMPLATE/.replay.megltower.txt)"
megltower="${zsheader}${megltower}"
echo "$megltower" >> $directory/replay.megltower.sh
chmod +x $directory/replay.megltower.sh


manager="$(cat $TEMPLATE/.replay.manager.megltower.txt)"
manager="${zsheader}${manager}"
echo "$manager" >> $directory/replay.manager.megltower.sh
chmod +x $directory/replay.manager.megltower.sh




##############################################################################
## Copy template files for lattice creation, temperature distribution and   ##
## assignment, simulation, replays, and remote resource configuration.      ##
##############################################################################
cp -a $TEMPLATE/.models/$MODEL/. $directory/
# cp $TEMPLATE/.models/.$MODEL.py $directory/simulation.py
# cp $TEMPLATE/.replays/.replay.statistics.$MODEL.py $directory/replay.statistics.py
# cp $TEMPLATE/.replays/.replay.autocorrelation.$MODEL.py $directory/replay.autocorrelation.py

# cp $TEMPLATE/.construction.py $directory/construction.py
cp -r $TEMPLATE/.scripts $directory/scripts
cp $TEMPLATE/.summary.md $directory/summary.md
# cp .hopper $directory/.hopper
# cp .hopper.ignore $directory/.hopper.ignore
cp .pangolin $directory/.pangolin
cp .pangolin.ignore $directory/.pangolin.ignore
cp .megltower $directory/.megltower
cp .megltower.ignore $directory/.megltower.ignore
cp $TEMPLATE/.template.gitignore $directory/.gitignore

# Title the experiment file.
echo "## \`$experiment\`" >> $directory/summary.md


##################################################################################
## Create `push.sh` and `pull.sh` files for pushing/pulling files to/from ##
## *only this experiment's directory* on the remote machine. The files included ##
## and ignored are configured in hidden .hopper, .hopper.ignore and .pangolin,  ##
## .pangolin.ignore files. Please ensure you've traded SSH keys with your       ##
## remote machines, as these files expect to find SSH keys attached.            ##
##################################################################################
footer="$(cat $TEMPLATE/.push.sh)"
footer="${footer}\n\nrsync \$OPTIONS \$IGNORE ./ \$REMOTEUSER@\$REMOTELOCATION:\$REMOTEROOT/${experiment}"
echo "$footer" >> $directory/push.sh
chmod +x $directory/push.sh

footer="$(cat $TEMPLATE/.pull.sh)"
footer="${footer}\nrsync \$OPTIONS \$REMOTEUSER@\$REMOTELOCATION:\$REMOTEROOT/${experiment}/output/statistics/ ./output/statistics/"
footer="${footer}\nrsync \$OPTIONS \$REMOTEUSER@\$REMOTELOCATION:\$REMOTEROOT/${experiment}/jobs.done.txt ./jobs.done.txt"
echo "$footer" >> $directory/pull.sh
chmod +x $directory/pull.sh


printf "\ncreated experiment ${BOLD}%s${STOP} with model ${BOLD}%s${STOP} at ${BOLD}%s${STOP}\n" "${experiment}" "${MODEL}" "${directory}"


##################################################################################
## Initialize a git repository in the new experiment's folder (in the event) we ##
## want to create a submodule out of it for publication.                        ##
##################################################################################
# cd $directory
# git init

