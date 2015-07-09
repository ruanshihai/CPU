`timescale 1ns / 1ps

module top_test;

	// Inputs
	reg clk;
	reg enable;
	reg start;
	reg rst;
	reg [3:0] select_y;

	// Outputs
	wire [15:0] y;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.enable(enable), 
		.start(start), 
		.rst(rst), 
		.select_y(select_y), 
		.y(y)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		enable = 0;
		start = 0;
		rst = 1;
		select_y = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$display("pc :               id_ir                :reg_A :reg_B :reg_C\
: da  :  dd  : w : reC1 :  gr1  :  gr2  :  gr3   :zf :nf:cf");
		$monitor("%h : %b : %h : %h : %h : %h : %h : %b : %h : %h : %h : %h : %b : %b : %b", 
			uut.u_pcpu.pc, uut.u_pcpu.id_ir, uut.u_pcpu.reg_A, uut.u_pcpu.reg_B,
			uut.u_pcpu.reg_C, uut.d_addr, uut.d_dataout, uut.d_we, uut.u_pcpu.reg_C1,
			uut.u_pcpu.gr[1], uut.u_pcpu.gr[2], uut.u_pcpu.gr[3],
			uut.u_pcpu.zf, uut.u_pcpu.nf, uut.u_pcpu.cf);

		#10 rst <= 0;
		#10 rst <= 1;
		#10 enable <= 1;
		#10 start <=1;
		#10 start <= 0;
	end
	
	always #5
		clk = ~clk;
      
endmodule

