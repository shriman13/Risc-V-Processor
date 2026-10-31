`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2026 07:49:29 PM
// Design Name: 
// Module Name: alu
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

module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_ctrl,
    output reg  [31:0] result,
    output wire        zero
);
    always @(*) begin
        case (alu_ctrl)
            4'b0000: result = a + b;                                      // ADD
            4'b0001: result = a - b;                                      // SUB
            4'b0010: result = a & b;                                      // AND
            4'b0011: result = a | b;                                      // OR
            4'b0100: result = a ^ b;                                      // XOR
            4'b0101: result = a << b[4:0];                                // SLL (shift left logical)
            4'b0110: result = a >> b[4:0];                                // SRL (shift right logical)
            4'b0111: result = $signed(a) >>> b[4:0];                      // SRA (shift right arithmetic)
            4'b1000: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT (set less than - signed)
            4'b1001: result = (a < b) ? 32'd1 : 32'd0;                    // SLTU (set less than - unsigned)
            default: result = 32'b0;
        endcase
    end
    
    assign zero = (result == 32'b0);
endmodule