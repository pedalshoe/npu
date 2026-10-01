SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES = $(abspath ../src/project.v)
TOPLEVEL = tt_um_custom_npu
COCOTB_TEST_MODULES = test_npu

include $(shell cocotb-config --makefiles)/Makefile.sim
