`timescale 1ns / 1ps

module tb_connections;

    // -------------------------
    // Clock and reset
    // -------------------------
    reg clk;
    reg reset;

    // -------------------------
    // DUT instantiation
    // -------------------------
    connections dut (
        .clk(clk),
        .reset(reset)
    );

    // -------------------------
    // OBSERVED SIGNALS (TB-level)
    // -------------------------
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] instr;
    wire [31:0] alu_result;
    wire [31:0] write_back_data;

    wire [31:0] x1;
    wire [31:0] x2;
    wire [31:0] x3;

    // -------------------------
    // HIERARCHICAL CONNECTIONS
    // -------------------------
    assign pc_current      = dut.pc_current;
    assign pc_next         = dut.pc_next;
    assign instr           = dut.instr;
    assign alu_result      = dut.alu_result;
    assign write_back_data = dut.write_back_data;

    assign x1 = dut.regfile_u.regs[1];
    assign x2 = dut.regfile_u.regs[2];
    assign x3 = dut.regfile_u.regs[3];
    assign x4 = dut.regfile_u.regs[4];
    

    // -------------------------
    // Clock generation (10 ns)
    // -------------------------
    always #5 clk = ~clk;

    // -------------------------
    // Test sequence
    // -------------------------
    initial begin
        clk   = 0;
        reset = 1;

        // Release reset
        #20;
        reset = 0;

        // Run long enough to see execution
        #200;

        // Print final values
        $display("=================================");
        $display(" FINAL REGISTER VALUES ");
        $display("=================================");
        $display("x1 = %0d", x1);
        $display("x2 = %0d", x2);
        $display("x3 = %0d", x3);
        $display("=================================");

        // Pause simulation (keeps waveform open)
        
    end

endmodule
