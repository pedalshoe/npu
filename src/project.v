module tt_um_custom_npu (
    input  wire [7:0] ui_in,    // Dedicated inputs: [7:0] data_in
    output wire [7:0] uo_out,   // Dedicated outputs: Lower 8-bits of result
    input  wire [7:0] uio_in,   // IOs: Input path (unused, set to 0)
    output wire [7:0] uio_out,  // IOs: Output path (Upper 8-bits of result)
    output wire [7:0] uio_oe,   // IOs: Enable path (set to 0xff to make them outputs)
    input  wire       ena,      // clock enable: connect to 1
    input  wire       clk,      // clock line
    input  wire       rst_n     // active low reset
);
    // Extract our specific command logic wires from the fixed hardware pins
    wire [7:0] data_in   = ui_in;
    wire       cmd_valid = uio_in[0]; // Let's use the first bidirectional pin as cmd_valid
    wire signed [15:0] data_out;

    // Direct assignment to tie our internal 16-bit answer back out to the physical pins
    assign uo_out  = data_out[7:0];   // Lower byte of calculation results
    assign uio_out = data_out[15:8];  // Upper byte of calculation results
    assign uio_oe  = 8'b11111111;    // Configure bidirectional pins as outputs

    // --------------------------------------------------------------------
    // Your exact working architecture logic goes here
    // --------------------------------------------------------------------
    reg [2:0] current_state;
    reg signed [7:0] reg_a, reg_b;
    reg signed [15:0] data_out_reg;
    wire signed [15:0] pe_accum;
    reg pe_en;

    // Math block (PE) instantiation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_a <= 0; reg_b <= 0; pe_en <= 0; data_out_reg <= 0; current_state <= 0;
        end else begin
            pe_en <= 0;
            case (current_state)
                3'd0: begin // IDLE
                    if (cmd_valid) begin
                        if (data_in == 8'h01) current_state <= 3'd1;
                        else if (data_in == 8'h02) current_state <= 3'd2;
                        else if (data_in == 8'h03) current_state <= 3'd3;
                        else if (data_in == 8'h04) current_state <= 3'd4;
                    end
                end
                3'd1: begin reg_a <= data_in; current_state <= 3'd0; end // LOAD_A
                3'd2: begin reg_b <= data_in; current_state <= 3'd0; end // LOAD_B
                3'd3: begin pe_en <= 1; current_state <= 3'd0; end       // COMPUTE
                3'd4: begin data_out_reg <= relu_output; current_state <= 3'd0; end // STREAM
            endcase
        end
    end

    assign data_out = data_out_reg;

    // Signed multiplier
    reg signed [15:0] pe_accum_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) pe_accum_reg <= 0;
        else if (pe_en) pe_accum_reg <= pe_accum_reg + (reg_a * reg_b);
    end
    assign pe_accum = pe_accum_reg;

    // Hardware ReLU
    wire signed [15:0] relu_output;
    assign relu_output = (pe_accum[15] == 1'b1) ? 16'sd0 : pe_accum;


endmodule
