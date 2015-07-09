`timescale 1ns / 1ps

module memory(
    input clk,
    input [7:0] addr,
    input we,
    input [15:0] datain,
    output [15:0] dataout
    );

	reg [15:0] RAM[255:0];
	
	assign dataout = RAM[addr];
	always @(posedge clk)
		if (we)
			RAM[addr] <= datain;

endmodule
