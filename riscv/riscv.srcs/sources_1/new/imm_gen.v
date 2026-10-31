`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2026 09:51:09 PM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen (
    input  wire [31:0] instr,   // full 32-bit instruction
    output reg  [31:0] imm       // sign-extended immediate
);

    wire [6:0] opcode;
    assign opcode = instr[6:0];

    always @(*) begin
        case (opcode)

            // ---------------- I-type ----------------
            // ADDI, LW
            7'b0010011,   // ADDI
            7'b0000011:   // LW
                imm = {{20{instr[31]}}, instr[31:20]};

            // ---------------- S-type ----------------
            // SW
            7'b0100011:
                imm = {{20{instr[31]}},
                       instr[31:25],
                       instr[11:7]};

            // ---------------- B-type ----------------
            // BEQ
            7'b1100011:
                imm = {{19{instr[31]}},   // sign extension
                       instr[31],          // imm[12]
                       instr[7],           // imm[11]
                       instr[30:25],       // imm[10:5]
                       instr[11:8],        // imm[4:1]
                       1'b0};              // imm[0] (alignment)

            // ---------------- Default ----------------
            default:
                imm = 32'b0;
        endcase
    end

endmodule