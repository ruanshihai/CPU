`timescale 1ns / 1ps
`include "def.v"

module i_memory(
    input clk,
    input rst,
    input [7:0] addr,
    input we,
    input [15:0] datain,
    output [15:0] dataout
    );

	reg [15:0] RAM[255:0];
	
	assign dataout = RAM[addr];
	always @(posedge clk or negedge rst)
		begin
			if (!rst)
				begin
					RAM[0] <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0000};
					RAM[1] <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0001};
					RAM[2] <= {`ADD, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[3] <= {`STORE, `gr3, 1'b0, `gr0, 4'b0010};
					RAM[4] <= {`CMP, 4'b0000, `gr1, 1'b0, `gr2};
					RAM[5] <= {`BNZ, `gr0, 8'b0000_1100};
					RAM[6] <= {`AND, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[7] <= {`OR, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[8] <= {`XOR, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[9] <= {`AND, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[10] <= {`OR, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[11] <= {`XOR, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[12] <= {`SUB, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[13] <= {`STORE, `gr3, 1'b0, `gr0, 4'b0011};
					RAM[14] <= {`SLL, `gr3, 1'b0, `gr3, 4'b0001};
					RAM[15] <= {`SRL, `gr3, 1'b0, `gr3, 4'b0001};
					RAM[16] <= {`SLA, `gr3, 1'b0, `gr3, 4'b0001};
					RAM[17] <= {`SRA, `gr3, 1'b0, `gr3, 4'b0001};
					RAM[18] <= {`JUMP, 11'b000_0001_1001};
					RAM[19] <= {`AND, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[20] <= {`OR, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[21] <= {`XOR, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[22] <= {`AND, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[23] <= {`OR, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[24] <= {`XOR, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[25] <= {`ADDI, `gr1, 8'b0000_0001};
					RAM[26] <= {`ADDC, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[27] <= {`LDIH, `gr1, 8'b0010_0000};
					RAM[28] <= {`SUBC, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[29] <= {`AND, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[30] <= {`OR, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[31] <= {`XOR, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[32] <= {`HALT, 11'b000_0000_0000};
				end
			else if (we)
				RAM[addr] <= datain;
		end

endmodule
