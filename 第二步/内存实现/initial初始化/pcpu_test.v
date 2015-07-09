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
	memory i_mem (
		.clk(clock),
		.addr(i_addr),
		.we(),
		.datain(),
		.dataout(i_datain)
	);
	memory d_mem (
		.clk(clock),
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

		i_mem.RAM[0] <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0000};
		i_mem.RAM[1] <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0001};
		i_mem.RAM[2] <= {`NOP, 11'b000_0000_0000};
		i_mem.RAM[3] <= {`NOP, 11'b000_0000_0000};
		i_mem.RAM[4] <= {`NOP, 11'b000_0000_0000};
		i_mem.RAM[5] <= {`ADD, `gr3, 1'b0, `gr1, 1'b0, `gr2};
		i_mem.RAM[6] <= {`NOP, 11'b000_0000_0000};
		i_mem.RAM[7] <= {`NOP, 11'b000_0000_0000};
		i_mem.RAM[8] <= {`NOP, 11'b000_0000_0000};
		i_mem.RAM[9] <= {`STORE, `gr3, 1'b0, `gr0, 4'b0010};
		i_mem.RAM[10] <= {`BNZ, `gr1, 8'b0001_0000};
		i_mem.RAM[11] <= {`NOP, 11'b000_0000_0000};
		i_mem.RAM[12] <= {`NOP, 11'b000_0000_0000};
		i_mem.RAM[13] <= {`NOP, 11'b000_0000_0000};
		i_mem.RAM[187] <= {`CMP, 4'b0000, `gr1, 1'b0, `gr2};
		i_mem.RAM[188] <= {`HALT, 11'b000_0000_0000};
		
		
		d_mem.RAM[0] <= 16'h00AB;
		d_mem.RAM[1] <= 16'h3C00;
		d_mem.RAM[2] <= 16'h0000;

		#10 reset <= 0;
		#10 reset <= 1;
		#10 enable <= 1;
		#10 start <=1;
		#10 start <= 0;
	end
	
	always #5
		clock = ~clock;
      
endmodule

