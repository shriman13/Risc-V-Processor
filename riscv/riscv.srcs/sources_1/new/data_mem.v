`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2026 10:00:34 PM
// Design Name: 
// Module Name: data_mem
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

module data_mem (
    input  wire        clk,
    input  wire        mem_read,      // Not used by memory, but kept for interface consistency
    input  wire        mem_write,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [31:0] mem [0:255];
    integer i;
    
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'b0;
    end
    
    always @(posedge clk) begin
        if (mem_write)
            mem[addr[9:2]] <= write_data;
    end
    
    assign read_data = mem[addr[9:2]];
    
endmodule