`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2026 07:48:04 PM
// Design Name: 
// Module Name: regfile
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


module regfile (
    input  wire clk,
    input  wire we,        // write enable
    input  wire [4:0]  rs1,       // read register 1 index
    input  wire [4:0]  rs2,       // read register 2 index
    input  wire [4:0]  rd,        // write register index
    input  wire [31:0] wd,        // write data
    output wire [31:0] rd1,       // read data 1
    output wire [31:0] rd2        // read data 2
);

    // 32 registers, each 32-bit wide
    reg [31:0] regs [31:0];

    integer i;

    // Initialize registers (simulation-friendly)
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
    end

    // Combinational reads
    assign rd1 = (rs1 == 5'd0) ? 32'b0 : regs[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'b0 : regs[rs2];

    // Synchronous write
    always @(posedge clk) begin
        if (we && rd != 5'd0)
            regs[rd] <= wd;
    end

endmodule
