"""Pin-level tests for the command-driven multiply and ReLU core."""

import cocotb
from cocotb.triggers import Timer


async def tick(dut):
    dut.clk.value = 0
    await Timer(5, unit="ns")
    dut.clk.value = 1
    await Timer(5, unit="ns")


async def reset(dut):
    dut.clk.value = 0
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await tick(dut)
    dut.rst_n.value = 1
    await tick(dut)


async def command(dut, opcode, operand=0):
    dut.ui_in.value = opcode
    dut.uio_in.value = 1
    await tick(dut)
    dut.uio_in.value = 0
    dut.ui_in.value = operand & 0xFF
    await tick(dut)


async def compute(dut):
    await command(dut, 3)
    # The processing element sees pe_en on the cycle after COMPUTE.
    await tick(dut)


async def stream(dut):
    await command(dut, 4)
    return int(dut.uo_out.value) | (int(dut.uio_out.value) << 8)


@cocotb.test()
async def positive_product_and_accumulation(dut):
    await reset(dut)
    await command(dut, 1, 3)
    await command(dut, 2, 4)
    await compute(dut)
    assert await stream(dut) == 12

    await command(dut, 1, 2)
    await command(dut, 2, 5)
    await compute(dut)
    assert await stream(dut) == 22


@cocotb.test()
async def negative_product_is_zeroed_by_relu(dut):
    await reset(dut)
    await command(dut, 1, -3)
    await command(dut, 2, 4)
    await compute(dut)
    assert await stream(dut) == 0
