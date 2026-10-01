# Tiny Tapeout Verilog Simulation Makefile
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/src/project.v

TOPLEVEL = tt_um_custom_npu
MODULE = tb

include $(shell cocotb-config --makefiles)/Makefile.sim
