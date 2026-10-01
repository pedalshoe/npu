SIM ?= icarus
FST ?= -fst
TOPLEVEL_LANG ?= verilog

ifneq ($(GATES),yes)
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(abspath ../src/project.v)
else
SIM_BUILD = sim_build/gl
COMPILE_ARGS += -DGL_TEST -DFUNCTIONAL -DUSE_POWER_PINS -DSIM -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v
VERILOG_SOURCES += $(abspath gate_level_netlist.v)
endif

VERILOG_SOURCES += $(abspath ../src/tb.v)
TOPLEVEL = tb
COCOTB_TEST_MODULES = test_npu

include $(shell cocotb-config --makefiles)/Makefile.sim
