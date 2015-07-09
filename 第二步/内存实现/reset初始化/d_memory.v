`timescale 1ns / 1ps

module d_memory(
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
					RAM[0] <= 16'h00AB;
					RAM[1] <= 16'h3C00;
					RAM[2] <= 16'h0000;
				end
			else if (we)
				RAM[addr] <= datain;
		end

endmodule
