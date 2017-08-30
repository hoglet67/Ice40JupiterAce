#!/bin/bash

TOP=jupiter_ace
NAME=jupiter_ace
PACKAGE=tq144:4k
SRCS="../src/fpga_ace.v ../src/relojes.v ../src/jace_logic.v ../src/jupiter_ace.v ../src/keyboard_for_ace.v ../src/memorias.v ../src/ps2_port.v ../src/tv80_alu.v ../src/tv80_core.v ../src/tv80_mcode.v ../src/tv80n.v ../src/tv80_reg.v ../src/vga_scandoubler.v"

yosys -q -f "verilog -Duse_sb_io" -l ${NAME}.log -p "synth_ice40 -top ${TOP} -abc2 -blif ${NAME}.blif" ${SRCS}
arachne-pnr -d 8k -P ${PACKAGE} -p blackice.pcf ${NAME}.blif -o ${NAME}.txt
icepack ${NAME}.txt ${NAME}.bin
icetime -d hx8k -P ${PACKAGE} ${NAME}.txt
