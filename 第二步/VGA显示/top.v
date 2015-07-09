`timescale 1ns / 1ps
`include "def.v"

module top(
    input clk,
    input test_clk,
    input enable,
    input start,
    input rst,
    input [3:0] select_y,
    output [15:0] y,
    output [2:0] r,
    output [2:0] g,
    output [1:0] b,
    output hs,
    output vs
    );
	
	wire [15:0] i_datain;
	wire [15:0] d_datain;
	wire [7:0] i_addr;
	wire [7:0] d_addr;
	wire d_we;
	wire [15:0] d_dataout;
	
	wire [7:0] pc;
	wire [15:0] id_ir;
	wire [15:0] ex_ir;
	wire [15:0] reg_B;
	wire [15:0] reg_A;
	wire [15:0] smdr;
	wire [15:0] mem_ir;
	wire zf;
	wire nf;
	wire cf;
	wire dw;
	wire [15:0] reg_C;
	wire [15:0] smdr1;
	wire [15:0] wb_ir;
	wire [15:0] reg_C1;
	wire [15:0] gr0;
	wire [15:0] gr1;
	wire [15:0] gr2;
	wire [15:0] gr3;

	pcpu u_pcpu (
		.clock(test_clk), 
		.enable(enable), 
		.reset(rst), 
		.start(start), 
		.i_datain(i_datain), 
		.d_datain(d_datain), 
		.select_y(select_y), 
		.i_addr(i_addr), 
		.d_addr(d_addr), 
		.d_we(d_we), 
		.d_dataout(d_dataout), 
		.y(y),
		.vga_pc(pc),
		.vga_id_ir(id_ir),
		.vga_ex_ir(ex_ir),
		.vga_reg_B(reg_B),
		.vga_reg_A(reg_A),
		.vga_smdr(smdr),
		.vga_mem_ir(mem_ir),
		.vga_zf(zf),
		.vga_nf(nf),
		.vga_cf(cf),
		.vga_dw(dw),
		.vga_reg_C(reg_C),
		.vga_smdr1(smdr1),
		.vga_wb_ir(wb_ir),
		.vga_reg_C1(reg_C1),
		.vga_gr0(gr0),
		.vga_gr1(gr1),
		.vga_gr2(gr2),
		.vga_gr3(gr3)
	);
	i_memory i_mem (
		.clk(test_clk),
		.rst(rst),
		.addr(i_addr),
		.we(1'b0),
		.datain(16'b0000_0000_0000_0000),
		.dataout(i_datain)
	);
	d_memory d_mem (
		.clk(test_clk),
		.rst(rst),
		.addr(d_addr),
		.we(d_we),
		.datain(d_dataout),
		.dataout(d_datain)
	);
	VGA_info_display u_vga (
		.clk(clk),
		.rst(rst),
		.pc(pc), 
		.id_ir(id_ir), 
		.ex_ir(ex_ir), 
		.reg_B(reg_B), 
		.reg_A(reg_A), 
		.smdr(smdr), 
		.mem_ir(mem_ir), 
		.zf(zf), 
		.nf(nf), 
		.cf(cf), 
		.dw(dw), 
		.reg_C(reg_C), 
		.smdr1(smdr1), 
		.wb_ir(wb_ir), 
		.reg_C1(reg_C1), 
		.gr0(gr0), 
		.gr1(gr1), 
		.gr2(gr2), 
		.gr3(gr3),
		.r(r),
		.g(g),
		.b(b),
		.hs(hs),
		.vs(vs)
	);

endmodule
