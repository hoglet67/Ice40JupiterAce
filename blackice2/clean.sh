#!/bin/bash

PROG=jupiter_ace

# Remove BlackIce files
rm -f $PROG.blif $PROG.txt $PROG.bin $PROG.log

# Remove Simulation files
rm -f a.out dump.vcd
