`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2026 08:04:32 PM
// Design Name: 
// Module Name: instr_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instr_mem (
    input  wire [31:0] addr,   // PC value (byte address)
    output wire [31:0] instr    // instruction output
);

    // Instruction memory: 256 words (1 KB)
    reg [31:0] mem [0:255];

    integer i;

    // Initialize instruction memory (simulation only)
    initial begin
        // Fill entire memory with NOPs
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'h00000013; // ADDI x0, x0, 0 (NOP)

        // Example program (you can change this later)
        mem[0] = 32'h00000093; // ADDI x1, x0, 0   (a = 0)
mem[1] = 32'h00100113; // ADDI x2, x0, 1   (b = 1)

mem[2] = 32'h002081b3; // ADD  x3, x1, x2  (temp = a + b)
mem[3] = 32'h000100b3; // ADD  x1, x2, x0  (a = b)
mem[4] = 32'h00018133; // ADD  x2, x3, x0  (b = temp)
mem[5] = 32'hfe000ae3; // BNE  x0, x0, loop (always taken)

    end
    

    // Combinational read (word-aligned)
    assign instr = mem[addr[9:2]];

endmodule