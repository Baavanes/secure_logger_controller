# sim.makefile -- Included in dv Makefiles for simulation environments

SIM ?= iverilog
VERILOG_SOURCES ?=
TOPLEVEL ?=
MODULE ?=

all:
	$(SIM) -o sim.vvp $(VERILOG_SOURCES)
	cocotb-run

clean:
	rm -f sim.vvp *.vcd *.log

.PHONY: all clean
