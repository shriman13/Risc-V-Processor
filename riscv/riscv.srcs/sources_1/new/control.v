module control (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    
    output reg        reg_write,
    output reg        mem_to_reg,
    output reg        mem_write,
    output reg        mem_read,
    output reg        alu_src,
    output reg        branch,
    output reg [3:0]  alu_control
);

    // Opcode definitions
    localparam R_TYPE  = 7'b0110011;
    localparam I_TYPE  = 7'b0010011;
    localparam LOAD    = 7'b0000011;
    localparam STORE   = 7'b0100011;
    localparam BRANCH  = 7'b1100011;

    always @(*) begin
        // Default values (prevent latches)
        reg_write   = 1'b0;
        mem_to_reg  = 1'b0;
        mem_write   = 1'b0;
        mem_read    = 1'b0;
        alu_src     = 1'b0;
        branch      = 1'b0;
        alu_control = 4'b0000;
        
        case (opcode)
            R_TYPE: begin
                reg_write   = 1'b1;
                mem_to_reg  = 1'b0;
                mem_write   = 1'b0;
                mem_read    = 1'b0;
                alu_src     = 1'b0;  // Use rs2
                branch      = 1'b0;
                
                // Decode ALU operation from funct3 and funct7
                case (funct3)
                    3'b000: begin  // ADD or SUB
                        if (funct7[5])
                            alu_control = 4'b0001;  // SUB
                        else
                            alu_control = 4'b0000;  // ADD
                    end
                    3'b001: alu_control = 4'b0101;  // SLL
                    3'b010: alu_control = 4'b1000;  // SLT
                    3'b011: alu_control = 4'b1001;  // SLTU
                    3'b100: alu_control = 4'b0100;  // XOR
                    3'b101: begin  // SRL or SRA
                        if (funct7[5])
                            alu_control = 4'b0111;  // SRA
                        else
                            alu_control = 4'b0110;  // SRL
                    end
                    3'b110: alu_control = 4'b0011;  // OR
                    3'b111: alu_control = 4'b0010;  // AND
                    default: alu_control = 4'b0000;
                endcase
            end
            
            I_TYPE: begin
                reg_write   = 1'b1;
                mem_to_reg  = 1'b0;
                mem_write   = 1'b0;
                mem_read    = 1'b0;
                alu_src     = 1'b1;  // Use immediate
                branch      = 1'b0;
                
                // Decode ALU operation from funct3
                case (funct3)
                    3'b000: alu_control = 4'b0000;  // ADDI
                    3'b001: alu_control = 4'b0101;  // SLLI
                    3'b010: alu_control = 4'b1000;  // SLTI
                    3'b011: alu_control = 4'b1001;  // SLTIU
                    3'b100: alu_control = 4'b0100;  // XORI
                    3'b101: begin  // SRLI or SRAI
                        if (funct7[5])
                            alu_control = 4'b0111;  // SRAI
                        else
                            alu_control = 4'b0110;  // SRLI
                    end
                    3'b110: alu_control = 4'b0011;  // ORI
                    3'b111: alu_control = 4'b0010;  // ANDI
                    default: alu_control = 4'b0000;
                endcase
            end
            
            LOAD: begin
                reg_write   = 1'b1;
                mem_to_reg  = 1'b1;  // Write data from memory
                mem_write   = 1'b0;
                mem_read    = 1'b1;
                alu_src     = 1'b1;  // Use immediate for address
                branch      = 1'b0;
                alu_control = 4'b0000; // ADD (base + offset)
            end
            
            STORE: begin
                reg_write   = 1'b0;  // Don't write to register
                mem_to_reg  = 1'b0;
                mem_write   = 1'b1;
                mem_read    = 1'b0;
                alu_src     = 1'b1;  // Use immediate for address
                branch      = 1'b0;
                alu_control = 4'b0000; // ADD (base + offset)
            end
            
            BRANCH: begin
                reg_write   = 1'b0;
                mem_to_reg  = 1'b0;
                mem_write   = 1'b0;
                mem_read    = 1'b0;
                alu_src     = 1'b0;  // Compare rs1 and rs2
                branch      = 1'b1;
                
                // ALU performs comparison
                case (funct3)
                    3'b000: alu_control = 4'b0001; // BEQ  (subtract)
                    3'b001: alu_control = 4'b0001; // BNE  (subtract)
                    3'b100: alu_control = 4'b1000; // BLT  (slt)
                    3'b101: alu_control = 4'b1000; // BGE  (slt)
                    3'b110: alu_control = 4'b1001; // BLTU (sltu)
                    3'b111: alu_control = 4'b1001; // BGEU (sltu)
                    default: alu_control = 4'b0001;
                endcase
            end
            
            default: begin
                // All signals already set to 0
            end
        endcase
    end
endmodule