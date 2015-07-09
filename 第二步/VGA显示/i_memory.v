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
					RAM[2] <= {`NOP, 11'b000_0000_0000};
					RAM[3] <= {`NOP, 11'b000_0000_0000};
					RAM[4] <= {`NOP, 11'b000_0000_0000};
					RAM[5] <= {`ADD, `gr3, 1'b0, `gr1, 1'b0, `gr2};
					RAM[6] <= {`NOP, 11'b000_0000_0000};
					RAM[7] <= {`NOP, 11'b000_0000_0000};
					RAM[8] <= {`NOP, 11'b000_0000_0000};
					RAM[9] <= {`STORE, `gr3, 1'b0, `gr0, 4'b0010};
					RAM[10] <= {`BNZ, `gr1, 8'b0001_0000};
					RAM[11] <= {`NOP, 11'b000_0000_0000};
					RAM[12] <= {`NOP, 11'b000_0000_0000};
					RAM[13] <= {`NOP, 11'b000_0000_0000};
					RAM[187] <= {`CMP, 4'b0000, `gr1, 1'b0, `gr2};
					RAM[188] <= {`HALT, 11'b000_0000_0000};
				end
			else if (we)
				RAM[addr] <= datain;
		end

endmodule
