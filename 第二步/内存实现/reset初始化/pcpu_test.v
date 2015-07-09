`timescale 1ns / 1ps
`include "def.v"

module pcpu_test;

	// Inputs
	reg clock;
	reg enable;
	reg reset;
	reg start;
	
	// Wires
	wire [15:0] i_datain;
	wire [15:0] d_datain;
	wire [7:0] i_addr;
	wire [7:0] d_addr;
	wire d_we;
	wire [15:0] d_dataout;

	// Instantiate the Unit Under Test (UUT)
	pcpu uut (
		.clock(clock), 
		.enable(enable), 
		.reset(reset), 
		.start(start), 
		.i_datain(i_datain), 
		.d_datain(d_datain), 
		.i_addr(i_addr), 
		.d_addr(d_addr), 
		.d_we(d_we), 
		.d_dataout(d_dataout)
	);
	i_memory i_mem (
		.clk(clock),
		.rst(rst),
		.addr(i_addr),
		.we(1'b0),
		.datain(16'b0000_0000_0000_0000),
		.dataout(i_datain)
	);
	d_memory d_mem (
		.clk(clock),
		.rst(rst),
		.addr(d_addr),
		.we(d_we),
		.datain(d_dataout),
		.dataout(d_datain)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		enable = 0;
		reset = 1;
		start = 0;
		select_y = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$display("pc :               id_ir                :reg_A :reg_B :reg_C\
: da  :  dd  : w : reC1 :  gr1  :  gr2  :  gr3   :zf :nf:cf");
		$monitor("%h : %b : %h : %h : %h : %h : %h : %b : %h : %h : %h : %h : %b : %b : %b", 
			uut.pc, uut.id_ir, uut.reg_A, uut.reg_B, uut.reg_C,
			d_addr, d_dataout, d_we, uut.reg_C1, uut.gr[1], uut.gr[2], uut.gr[3],
			uut.zf, uut.nf, uut.cf);

		#10 reset <= 0;
		#10 reset <= 1;
		#10 enable <= 1;
		#10 start <=1;
		#10 start <= 0;
	end
	
	always #5
		clock = ~clock;
      
endmodule

