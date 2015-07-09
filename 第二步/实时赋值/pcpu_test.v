`timescale 1ns / 1ps
`include "def.v"

module pcpu_test;

	// Inputs
	reg clock;
	reg enable;
	reg reset;
	reg start;
	reg [15:0] i_datain;
	reg [15:0] d_datain;

	// Outputs
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
		.d_dataout(d_dataout), 
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		enable = 0;
		reset = 1;
		start = 0;
		i_datain = 0;
		d_datain = 0;
		select_y = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$display("pc :     id_ir      : reg_A : reg_B : reg_C : da : dd : w : reC1 : gr1 : gr2 : gr3 : zf : nf : cf");
		$monitor("%h : %b : %h : %h : %h : %h : %h : %b : %h : %h : %h : %h: %b: %b: %b", 
			uut.pc, uut.id_ir, uut.reg_A, uut.reg_B, uut.reg_C,
			d_addr, d_dataout, d_we, uut.reg_C1, uut.gr[1], uut.gr[2], uut.gr[3],
			uut.zf, uut.nf, uut.cf);
		
		enable <= 1; start <= 0; i_datain <= 0; d_datain <= 0; select_y <= 0;

		#10 reset <= 0;
		#10 reset <= 1;
		#10 enable <= 1;
		#10 start <=1;
		#10 start <= 0;
			i_datain <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0000};
		#10 i_datain <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0001};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
			d_datain <=16'h00AB;  // 3 clk later from LOAD
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
			d_datain <=16'h3C00;  // 3 clk later from LOAD
		#10 i_datain <= {`ADD, `gr3, 1'b0, `gr1, 1'b0, `gr2};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`STORE, `gr3, 1'b0, `gr0, 4'b0010};
		#10 i_datain <= {`BNZ, `gr1, 8'b00100001};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`CMP, 4'b0000, `gr1, 1'b0, `gr2};  // 4 clk later from BNZ
		#10 i_datain <= {`HALT, 11'b000_0000_0000};
	end
	
	always #5
		clock = ~clock;
      
endmodule

