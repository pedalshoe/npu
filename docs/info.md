# Custom NPU Command-Driven AI Matrix Multiplier

## How it works
This chip acts as a command-driven Neural Processing Unit element containing an 8-bit signed math processing block coupled directly to a hardware ReLU activation gate logic layout. It parses user-directed input bytes to load matrices, trigger execution cycles, and stream truncated 16-bit tensor solutions back to physical output pins.

## How to test
Initialize system lines with a low pulse on rst_n. Toggle high command triggers on uio_in[0] while driving ui_in data sequences to test positive calculations and verified ReLU zeroing constraints.

## External hardware inputs/outputs
- ui_in: 8-bit calculation data bus input channel
- uio_in[0]: System cmd_valid operation execution pulse wire
- uo_out: Lower 8-bit computation results path 
- uio_out: Upper 8-bit computation results path
