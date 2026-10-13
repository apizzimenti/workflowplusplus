
# Check whether we need tbb.
OS := $(shell uname)
tbb =
etc =

host = pangolin

# Suppress make "helpful" messages.
MAKEFLAGS += --no-print-directory

ifeq ($(OS),Linux)
	tbb = -ltbb
else ifeq ($(OS),Darwin)
	etc = (e.g. macOS)
endif

.PHONY: clean build

reset-simulations: clean
	@$(RM) jobs.running.txt
	@$(RM) -rf output/tape/*
	@$(RM) jobs.done.txt

clean:
	@$(RM) simulate *.o

build: clean
	@$(CXX) simulate.cpp `pkg-config --libs --cflags ATEAMS++` $(tbb) -o simulate

test: reset-simulations
	@printf "cleaning and building on %s %s..." "$(OS)" "$(etc)"
	@make build
	@printf "\rcleaning and building on %s %s... done. testing simulation...\n\n" "$(OS)" "$(etc)"
	@./simulate 4 4 2 TEST
	@printf "\n\n... done.\n"


simulate: reset-simulations build
	@./simulation.manager.$(host).sh

