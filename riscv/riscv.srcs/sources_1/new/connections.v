module connections (
    input wire clk,
    input wire reset
);

    // =====================
    // PC wires
    // =====================
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] branch_target;

    // =====================
    // Instruction fetch
    // =====================
    wire [31:0] instr;

    // =====================
    // Decode fields
    // =====================
    wire [6:0] opcode  = instr[6:0];
    wire [4:0] rs1     = instr[19:15];
    wire [4:0] rs2     = instr[24:20];
    wire [4:0] rd      = instr[11:7];
    wire [2:0] funct3  = instr[14:12];
    wire [6:0] funct7  = instr[31:25];

    // =====================
    // Register file
    // =====================
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] write_back_data;

    // =====================
    // Immediate
    // =====================
    wire [31:0] imm;

    // =====================
    // Control signals
    // =====================
    wire reg_write;
    wire mem_to_reg;
    wire mem_write;
    wire mem_read;
    wire alu_src;
    wire branch;
    wire [3:0] alu_control;

    // =====================
    // ALU
    // =====================
    wire [31:0] alu_in_b;
    wire [31:0] alu_result;
    wire zero;

    // =====================
    // Data memory
    // =====================
    wire [31:0] mem_data;

    // =====================
    // Program Counter
    // =====================
    pc pc_u (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_out(pc_current)
    );

    // PC + 4
    adder pc_adder (
        .a(pc_current),
        .b(32'd4),
        .sum(pc_plus4)
    );

    // =====================
    // Instruction Memory
    // =====================
    instr_mem imem_u (
        .addr(pc_current),
        .instr(instr)
    );

    // =====================
    // Control Unit
    // =====================
    control control_u (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .alu_src(alu_src),
        .branch(branch),
        .alu_control(alu_control)
    );

    // =====================
    // Register File
    // =====================
    regfile regfile_u (
        .clk(clk),
        .we(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(write_back_data),
        .rd1(rs1_data),
        .rd2(rs2_data)
    );

    // =====================
    // Immediate Generator
    // =====================
    imm_gen immgen_u (
        .instr(instr),
        .imm(imm)
    );

    // =====================
    // ALU input MUX
    // =====================
    assign alu_in_b = (alu_src) ? imm : rs2_data;

    // =====================
    // ALU
    // =====================
    alu alu_u (
        .a(rs1_data),
        .b(alu_in_b),
        .alu_ctrl(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // =====================
    // Data Memory
    // =====================
    data_mem dmem_u (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_result),
        .write_data(rs2_data),
        .read_data(mem_data)
    );

    // =====================
    // Writeback MUX
    // =====================
    assign write_back_data = (mem_to_reg) ? mem_data : alu_result;

    // =====================
    // Branch Target
    // =====================
    adder branch_adder (
        .a(pc_current),
        .b(imm),
        .sum(branch_target)
    );

    // =====================
    // Branch Condition Logic (UPDATED!)
    // =====================
    wire branch_condition;
    assign branch_condition = 
        (funct3 == 3'b000) ? zero :           // BEQ:  take if zero (a == b)
        (funct3 == 3'b001) ? ~zero :          // BNE:  take if not zero (a != b)
        (funct3 == 3'b100) ? alu_result[0] :  // BLT:  take if result = 1 (a < b signed)
        (funct3 == 3'b101) ? ~alu_result[0] : // BGE:  take if result = 0 (a >= b signed)
        (funct3 == 3'b110) ? alu_result[0] :  // BLTU: take if result = 1 (a < b unsigned)
        (funct3 == 3'b111) ? ~alu_result[0] : // BGEU: take if result = 0 (a >= b unsigned)
        1'b0;                                  // Default: don't branch
    
    wire branch_taken;
    assign branch_taken = branch && branch_condition;

    // =====================
    // PC selection
    // =====================
    assign pc_next = (branch_taken) ? branch_target : pc_plus4;

endmodule