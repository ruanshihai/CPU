`timescale 1ns / 1ps

module VGA_info_display(
    input clk,
    input rst,
    input [7:0] pc,
    input [15:0] id_ir,
    input [15:0] ex_ir,
    input [15:0] reg_B,
    input [15:0] reg_A,
    input [15:0] smdr,
    input [15:0] mem_ir,
    input zf,
    input nf,
    input cf,
    input dw,
    input [15:0] reg_C,
    input [15:0] smdr1,
    input [15:0] wb_ir,
    input [15:0] reg_C1,
    input [15:0] gr0,
    input [15:0] gr1,
    input [15:0] gr2,
    input [15:0] gr3,
    
    output reg [2:0] r,
    output reg [2:0] g,
    output reg [1:0] b,
    output hs,
    output vs
    );

	parameter UP_BOUND = 31;
	parameter DOWN_BOUND = 510;
	parameter LEFT_BOUND = 144;
	parameter RIGHT_BOUND = 783;
	parameter INFO_UP_POS = 201;
	parameter INFO_DOWN_POS = 208;
	parameter INFO_LEFT_POS = 144;
	parameter INFO_RIGHT_POS = 783;
	parameter REG_UP_POS = 213;
	parameter REG_DOWN_POS = 220;
	parameter REG_LEFT_POS = 144;
	parameter REG_RIGHT_POS = 783;
			
	wire pclk;
	reg [1:0] count;
	reg [9:0] hcount, vcount;
	wire [7:0] info[639:0];
	wire [7:0] pixel[639:0];
	
	// 获得像素时钟25MHz
	assign pclk = count[1];
	always @ (posedge clk or negedge rst)
	begin
		if (!rst)
			count <= 0;
		else
			count <= count+1;
	end
	
	// 列计数与行同步
	assign hs = (hcount < 96) ? 0 : 1;
	always @ (posedge pclk or negedge rst)
	begin
		if (!rst)
			hcount <= 0;
		else if (hcount == 799)
			hcount <= 0;
		else
			hcount <= hcount+1;
	end
	
	// 行计数与场同步
	assign vs = (vcount < 2) ? 0 : 1;
	always @ (posedge pclk or negedge rst)
	begin
		if (!rst)
			vcount <= 0;
		else if (hcount == 799) begin
			if (vcount == 520)
				vcount <= 0;
			else
				vcount <= vcount+1;
		end
		else
			vcount <= vcount;
	end
	
	// 在屏幕特定区域显示信号值
	always @ (posedge pclk or negedge rst)
	begin
		if (!rst) begin
			r <= 0;
			g <= 0;
			b <= 0;
		end
		else begin
			if (vcount>=INFO_UP_POS && vcount<=INFO_DOWN_POS
					&& hcount>=INFO_LEFT_POS && hcount<=INFO_RIGHT_POS) begin
				if (info[hcount-INFO_LEFT_POS][vcount-INFO_UP_POS]) begin
					r <= 3'b111;
					g <= 3'b111;
					b <= 2'b11;
				end
				else begin
					r <= 3'b000;
					g <= 3'b000;
					b <= 2'b00;
				end
			end
			else if (vcount>=REG_UP_POS && vcount<=REG_DOWN_POS
					&& hcount>=REG_LEFT_POS && hcount<=REG_RIGHT_POS) begin
				if (pixel[hcount-REG_LEFT_POS][vcount-REG_UP_POS]) begin
					r <= 3'b111;
					g <= 3'b111;
					b <= 2'b11;
				end
				else begin
					r <= 3'b000;
					g <= 3'b000;
					b <= 2'b00;
				end
			end
			else begin
				r <= 3'b000;
				g <= 3'b000;
				b <= 2'b00;
			end
		end
	end

	assign info[0] = 8'b0000_0000;
	assign info[1] = 8'b0000_0000;
	assign info[2] = 8'b0000_0000;
	assign info[3] = 8'b0000_0000;
	assign info[4] = 8'b0000_0000;
	assign info[5] = 8'b0000_0000;
	assign info[6] = 8'b0000_0000;
	RAM_set u_info_1 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1001),
		.col0(info[7]),
		.col1(info[8]),
		.col2(info[9]),
		.col3(info[10]),
		.col4(info[11]),
		.col5(info[12]),
		.col6(info[13])
	);
	RAM_set u_info_2 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1100),
		.col0(info[14]),
		.col1(info[15]),
		.col2(info[16]),
		.col3(info[17]),
		.col4(info[18]),
		.col5(info[19]),
		.col6(info[20])
	);
	RAM_set u_info_3 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[21]),
		.col1(info[22]),
		.col2(info[23]),
		.col3(info[24]),
		.col4(info[25]),
		.col5(info[26]),
		.col6(info[27])
	);
	RAM_set u_info_4 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[28]),
		.col1(info[29]),
		.col2(info[30]),
		.col3(info[31]),
		.col4(info[32]),
		.col5(info[33]),
		.col6(info[34])
	);
	RAM_set u_info_5 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[35]),
		.col1(info[36]),
		.col2(info[37]),
		.col3(info[38]),
		.col4(info[39]),
		.col5(info[40]),
		.col6(info[41])
	);
	RAM_set u_info_6 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[42]),
		.col1(info[43]),
		.col2(info[44]),
		.col3(info[45]),
		.col4(info[46]),
		.col5(info[47]),
		.col6(info[48])
	);
	RAM_set u_info_7 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[49]),
		.col1(info[50]),
		.col2(info[51]),
		.col3(info[52]),
		.col4(info[53]),
		.col5(info[54]),
		.col6(info[55])
	);
	RAM_set u_info_8 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[56]),
		.col1(info[57]),
		.col2(info[58]),
		.col3(info[59]),
		.col4(info[60]),
		.col5(info[61]),
		.col6(info[62])
	);
	RAM_set u_info_9 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[63]),
		.col1(info[64]),
		.col2(info[65]),
		.col3(info[66]),
		.col4(info[67]),
		.col5(info[68]),
		.col6(info[69])
	);
	RAM_set u_info_10 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[70]),
		.col1(info[71]),
		.col2(info[72]),
		.col3(info[73]),
		.col4(info[74]),
		.col5(info[75]),
		.col6(info[76])
	);
	RAM_set u_info_11 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0010),
		.col0(info[77]),
		.col1(info[78]),
		.col2(info[79]),
		.col3(info[80]),
		.col4(info[81]),
		.col5(info[82]),
		.col6(info[83])
	);
	RAM_set u_info_12 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1101),
		.col0(info[84]),
		.col1(info[85]),
		.col2(info[86]),
		.col3(info[87]),
		.col4(info[88]),
		.col5(info[89]),
		.col6(info[90])
	);
	RAM_set u_info_13 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[91]),
		.col1(info[92]),
		.col2(info[93]),
		.col3(info[94]),
		.col4(info[95]),
		.col5(info[96]),
		.col6(info[97])
	);
	RAM_set u_info_14 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[98]),
		.col1(info[99]),
		.col2(info[100]),
		.col3(info[101]),
		.col4(info[102]),
		.col5(info[103]),
		.col6(info[104])
	);
	RAM_set u_info_15 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[105]),
		.col1(info[106]),
		.col2(info[107]),
		.col3(info[108]),
		.col4(info[109]),
		.col5(info[110]),
		.col6(info[111])
	);
	RAM_set u_info_16 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[112]),
		.col1(info[113]),
		.col2(info[114]),
		.col3(info[115]),
		.col4(info[116]),
		.col5(info[117]),
		.col6(info[118])
	);
	RAM_set u_info_17 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[119]),
		.col1(info[120]),
		.col2(info[121]),
		.col3(info[122]),
		.col4(info[123]),
		.col5(info[124]),
		.col6(info[125])
	);
	RAM_set u_info_18 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[126]),
		.col1(info[127]),
		.col2(info[128]),
		.col3(info[129]),
		.col4(info[130]),
		.col5(info[131]),
		.col6(info[132])
	);
	RAM_set u_info_19 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[133]),
		.col1(info[134]),
		.col2(info[135]),
		.col3(info[136]),
		.col4(info[137]),
		.col5(info[138]),
		.col6(info[139])
	);
	RAM_set u_info_20 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[140]),
		.col1(info[141]),
		.col2(info[142]),
		.col3(info[143]),
		.col4(info[144]),
		.col5(info[145]),
		.col6(info[146])
	);
	RAM_set u_info_21 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[147]),
		.col1(info[148]),
		.col2(info[149]),
		.col3(info[150]),
		.col4(info[151]),
		.col5(info[152]),
		.col6(info[153])
	);
	RAM_set u_info_22 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1110),
		.col0(info[154]),
		.col1(info[155]),
		.col2(info[156]),
		.col3(info[157]),
		.col4(info[158]),
		.col5(info[159]),
		.col6(info[160])
	);
	RAM_set u_info_23 (
		.clk(clk),
		.rst(rst),
		.data(6'b10_0001),
		.col0(info[161]),
		.col1(info[162]),
		.col2(info[163]),
		.col3(info[164]),
		.col4(info[165]),
		.col5(info[166]),
		.col6(info[167])
	);
	RAM_set u_info_24 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[168]),
		.col1(info[169]),
		.col2(info[170]),
		.col3(info[171]),
		.col4(info[172]),
		.col5(info[173]),
		.col6(info[174])
	);
	RAM_set u_info_25 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[175]),
		.col1(info[176]),
		.col2(info[177]),
		.col3(info[178]),
		.col4(info[179]),
		.col5(info[180]),
		.col6(info[181])
	);
	RAM_set u_info_26 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1011),
		.col0(info[182]),
		.col1(info[183]),
		.col2(info[184]),
		.col3(info[185]),
		.col4(info[186]),
		.col5(info[187]),
		.col6(info[188])
	);
	RAM_set u_info_27 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1110),
		.col0(info[189]),
		.col1(info[190]),
		.col2(info[191]),
		.col3(info[192]),
		.col4(info[193]),
		.col5(info[194]),
		.col6(info[195])
	);
	RAM_set u_info_28 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0000),
		.col0(info[196]),
		.col1(info[197]),
		.col2(info[198]),
		.col3(info[199]),
		.col4(info[200]),
		.col5(info[201]),
		.col6(info[202])
	);
	RAM_set u_info_29 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1011),
		.col0(info[203]),
		.col1(info[204]),
		.col2(info[205]),
		.col3(info[206]),
		.col4(info[207]),
		.col5(info[208]),
		.col6(info[209])
	);
	RAM_set u_info_30 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[210]),
		.col1(info[211]),
		.col2(info[212]),
		.col3(info[213]),
		.col4(info[214]),
		.col5(info[215]),
		.col6(info[216])
	);
	RAM_set u_info_31 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1011),
		.col0(info[217]),
		.col1(info[218]),
		.col2(info[219]),
		.col3(info[220]),
		.col4(info[221]),
		.col5(info[222]),
		.col6(info[223])
	);
	RAM_set u_info_32 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1110),
		.col0(info[224]),
		.col1(info[225]),
		.col2(info[226]),
		.col3(info[227]),
		.col4(info[228]),
		.col5(info[229]),
		.col6(info[230])
	);
	RAM_set u_info_33 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0000),
		.col0(info[231]),
		.col1(info[232]),
		.col2(info[233]),
		.col3(info[234]),
		.col4(info[235]),
		.col5(info[236]),
		.col6(info[237])
	);
	RAM_set u_info_34 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1010),
		.col0(info[238]),
		.col1(info[239]),
		.col2(info[240]),
		.col3(info[241]),
		.col4(info[242]),
		.col5(info[243]),
		.col6(info[244])
	);
	RAM_set u_info_35 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[245]),
		.col1(info[246]),
		.col2(info[247]),
		.col3(info[248]),
		.col4(info[249]),
		.col5(info[250]),
		.col6(info[251])
	);
	RAM_set u_info_36 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1100),
		.col0(info[252]),
		.col1(info[253]),
		.col2(info[254]),
		.col3(info[255]),
		.col4(info[256]),
		.col5(info[257]),
		.col6(info[258])
	);
	RAM_set u_info_37 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0110),
		.col0(info[259]),
		.col1(info[260]),
		.col2(info[261]),
		.col3(info[262]),
		.col4(info[263]),
		.col5(info[264]),
		.col6(info[265])
	);
	RAM_set u_info_38 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1101),
		.col0(info[266]),
		.col1(info[267]),
		.col2(info[268]),
		.col3(info[269]),
		.col4(info[270]),
		.col5(info[271]),
		.col6(info[272])
	);
	RAM_set u_info_39 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1011),
		.col0(info[273]),
		.col1(info[274]),
		.col2(info[275]),
		.col3(info[276]),
		.col4(info[277]),
		.col5(info[278]),
		.col6(info[279])
	);
	RAM_set u_info_40 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[280]),
		.col1(info[281]),
		.col2(info[282]),
		.col3(info[283]),
		.col4(info[284]),
		.col5(info[285]),
		.col6(info[286])
	);
	RAM_set u_info_41 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0110),
		.col0(info[287]),
		.col1(info[288]),
		.col2(info[289]),
		.col3(info[290]),
		.col4(info[291]),
		.col5(info[292]),
		.col6(info[293])
	);
	RAM_set u_info_42 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1110),
		.col0(info[294]),
		.col1(info[295]),
		.col2(info[296]),
		.col3(info[297]),
		.col4(info[298]),
		.col5(info[299]),
		.col6(info[300])
	);
	RAM_set u_info_43 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0110),
		.col0(info[301]),
		.col1(info[302]),
		.col2(info[303]),
		.col3(info[304]),
		.col4(info[305]),
		.col5(info[306]),
		.col6(info[307])
	);
	RAM_set u_info_44 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[308]),
		.col1(info[309]),
		.col2(info[310]),
		.col3(info[311]),
		.col4(info[312]),
		.col5(info[313]),
		.col6(info[314])
	);
	RAM_set u_info_45 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[315]),
		.col1(info[316]),
		.col2(info[317]),
		.col3(info[318]),
		.col4(info[319]),
		.col5(info[320]),
		.col6(info[321])
	);
	RAM_set u_info_46 (
		.clk(clk),
		.rst(rst),
		.data(6'b10_0011),
		.col0(info[322]),
		.col1(info[323]),
		.col2(info[324]),
		.col3(info[325]),
		.col4(info[326]),
		.col5(info[327]),
		.col6(info[328])
	);
	RAM_set u_info_47 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0111),
		.col0(info[329]),
		.col1(info[330]),
		.col2(info[331]),
		.col3(info[332]),
		.col4(info[333]),
		.col5(info[334]),
		.col6(info[335])
	);
	RAM_set u_info_48 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1100),
		.col0(info[336]),
		.col1(info[337]),
		.col2(info[338]),
		.col3(info[339]),
		.col4(info[340]),
		.col5(info[341]),
		.col6(info[342])
	);
	RAM_set u_info_49 (
		.clk(clk),
		.rst(rst),
		.data(6'b10_0000),
		.col0(info[343]),
		.col1(info[344]),
		.col2(info[345]),
		.col3(info[346]),
		.col4(info[347]),
		.col5(info[348]),
		.col6(info[349])
	);
	RAM_set u_info_50 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[350]),
		.col1(info[351]),
		.col2(info[352]),
		.col3(info[353]),
		.col4(info[354]),
		.col5(info[355]),
		.col6(info[356])
	);
	RAM_set u_info_51 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1011),
		.col0(info[357]),
		.col1(info[358]),
		.col2(info[359]),
		.col3(info[360]),
		.col4(info[361]),
		.col5(info[362]),
		.col6(info[363])
	);
	RAM_set u_info_52 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1110),
		.col0(info[364]),
		.col1(info[365]),
		.col2(info[366]),
		.col3(info[367]),
		.col4(info[368]),
		.col5(info[369]),
		.col6(info[370])
	);
	RAM_set u_info_53 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0000),
		.col0(info[371]),
		.col1(info[372]),
		.col2(info[373]),
		.col3(info[374]),
		.col4(info[375]),
		.col5(info[376]),
		.col6(info[377])
	);
	RAM_set u_info_54 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1100),
		.col0(info[378]),
		.col1(info[379]),
		.col2(info[380]),
		.col3(info[381]),
		.col4(info[382]),
		.col5(info[383]),
		.col6(info[384])
	);
	RAM_set u_info_55 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[385]),
		.col1(info[386]),
		.col2(info[387]),
		.col3(info[388]),
		.col4(info[389]),
		.col5(info[390]),
		.col6(info[391])
	);
	RAM_set u_info_56 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1100),
		.col0(info[392]),
		.col1(info[393]),
		.col2(info[394]),
		.col3(info[395]),
		.col4(info[396]),
		.col5(info[397]),
		.col6(info[398])
	);
	RAM_set u_info_57 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1101),
		.col0(info[399]),
		.col1(info[400]),
		.col2(info[401]),
		.col3(info[402]),
		.col4(info[403]),
		.col5(info[404]),
		.col6(info[405])
	);
	RAM_set u_info_58 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1011),
		.col0(info[406]),
		.col1(info[407]),
		.col2(info[408]),
		.col3(info[409]),
		.col4(info[410]),
		.col5(info[411]),
		.col6(info[412])
	);
	RAM_set u_info_59 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_0001),
		.col0(info[413]),
		.col1(info[414]),
		.col2(info[415]),
		.col3(info[416]),
		.col4(info[417]),
		.col5(info[418]),
		.col6(info[419])
	);
	RAM_set u_info_60 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[420]),
		.col1(info[421]),
		.col2(info[422]),
		.col3(info[423]),
		.col4(info[424]),
		.col5(info[425]),
		.col6(info[426])
	);
	RAM_set u_info_61 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[427]),
		.col1(info[428]),
		.col2(info[429]),
		.col3(info[430]),
		.col4(info[431]),
		.col5(info[432]),
		.col6(info[433])
	);
	RAM_set u_info_62 (
		.clk(clk),
		.rst(rst),
		.data(6'b10_0000),
		.col0(info[434]),
		.col1(info[435]),
		.col2(info[436]),
		.col3(info[437]),
		.col4(info[438]),
		.col5(info[439]),
		.col6(info[440])
	);
	RAM_set u_info_63 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1011),
		.col0(info[441]),
		.col1(info[442]),
		.col2(info[443]),
		.col3(info[444]),
		.col4(info[445]),
		.col5(info[446]),
		.col6(info[447])
	);
	RAM_set u_info_64 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[448]),
		.col1(info[449]),
		.col2(info[450]),
		.col3(info[451]),
		.col4(info[452]),
		.col5(info[453]),
		.col6(info[454])
	);
	RAM_set u_info_65 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[455]),
		.col1(info[456]),
		.col2(info[457]),
		.col3(info[458]),
		.col4(info[459]),
		.col5(info[460]),
		.col6(info[461])
	);
	RAM_set u_info_66 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1011),
		.col0(info[462]),
		.col1(info[463]),
		.col2(info[464]),
		.col3(info[465]),
		.col4(info[466]),
		.col5(info[467]),
		.col6(info[468])
	);
	RAM_set u_info_67 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0000),
		.col0(info[469]),
		.col1(info[470]),
		.col2(info[471]),
		.col3(info[472]),
		.col4(info[473]),
		.col5(info[474]),
		.col6(info[475])
	);
	RAM_set u_info_68 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_1100),
		.col0(info[476]),
		.col1(info[477]),
		.col2(info[478]),
		.col3(info[479]),
		.col4(info[480]),
		.col5(info[481]),
		.col6(info[482])
	);
	RAM_set u_info_69 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_0001),
		.col0(info[483]),
		.col1(info[484]),
		.col2(info[485]),
		.col3(info[486]),
		.col4(info[487]),
		.col5(info[488]),
		.col6(info[489])
	);
	RAM_set u_info_70 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[490]),
		.col1(info[491]),
		.col2(info[492]),
		.col3(info[493]),
		.col4(info[494]),
		.col5(info[495]),
		.col6(info[496])
	);
	RAM_set u_info_71 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0000),
		.col0(info[497]),
		.col1(info[498]),
		.col2(info[499]),
		.col3(info[500]),
		.col4(info[501]),
		.col5(info[502]),
		.col6(info[503])
	);
	RAM_set u_info_72 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1011),
		.col0(info[504]),
		.col1(info[505]),
		.col2(info[506]),
		.col3(info[507]),
		.col4(info[508]),
		.col5(info[509]),
		.col6(info[510])
	);
	RAM_set u_info_73 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_0000),
		.col0(info[511]),
		.col1(info[512]),
		.col2(info[513]),
		.col3(info[514]),
		.col4(info[515]),
		.col5(info[516]),
		.col6(info[517])
	);
	RAM_set u_info_74 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[518]),
		.col1(info[519]),
		.col2(info[520]),
		.col3(info[521]),
		.col4(info[522]),
		.col5(info[523]),
		.col6(info[524])
	);
	RAM_set u_info_75 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[525]),
		.col1(info[526]),
		.col2(info[527]),
		.col3(info[528]),
		.col4(info[529]),
		.col5(info[530]),
		.col6(info[531])
	);
	RAM_set u_info_76 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0000),
		.col0(info[532]),
		.col1(info[533]),
		.col2(info[534]),
		.col3(info[535]),
		.col4(info[536]),
		.col5(info[537]),
		.col6(info[538])
	);
	RAM_set u_info_77 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1011),
		.col0(info[539]),
		.col1(info[540]),
		.col2(info[541]),
		.col3(info[542]),
		.col4(info[543]),
		.col5(info[544]),
		.col6(info[545])
	);
	RAM_set u_info_78 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_0001),
		.col0(info[546]),
		.col1(info[547]),
		.col2(info[548]),
		.col3(info[549]),
		.col4(info[550]),
		.col5(info[551]),
		.col6(info[552])
	);
	RAM_set u_info_79 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[553]),
		.col1(info[554]),
		.col2(info[555]),
		.col3(info[556]),
		.col4(info[557]),
		.col5(info[558]),
		.col6(info[559])
	);
	RAM_set u_info_80 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[560]),
		.col1(info[561]),
		.col2(info[562]),
		.col3(info[563]),
		.col4(info[564]),
		.col5(info[565]),
		.col6(info[566])
	);
	RAM_set u_info_81 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0000),
		.col0(info[567]),
		.col1(info[568]),
		.col2(info[569]),
		.col3(info[570]),
		.col4(info[571]),
		.col5(info[572]),
		.col6(info[573])
	);
	RAM_set u_info_82 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1011),
		.col0(info[574]),
		.col1(info[575]),
		.col2(info[576]),
		.col3(info[577]),
		.col4(info[578]),
		.col5(info[579]),
		.col6(info[580])
	);
	RAM_set u_info_83 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_0010),
		.col0(info[581]),
		.col1(info[582]),
		.col2(info[583]),
		.col3(info[584]),
		.col4(info[585]),
		.col5(info[586]),
		.col6(info[587])
	);
	RAM_set u_info_84 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[588]),
		.col1(info[589]),
		.col2(info[590]),
		.col3(info[591]),
		.col4(info[592]),
		.col5(info[593]),
		.col6(info[594])
	);
	RAM_set u_info_85 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[595]),
		.col1(info[596]),
		.col2(info[597]),
		.col3(info[598]),
		.col4(info[599]),
		.col5(info[600]),
		.col6(info[601])
	);
	RAM_set u_info_86 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_0000),
		.col0(info[602]),
		.col1(info[603]),
		.col2(info[604]),
		.col3(info[605]),
		.col4(info[606]),
		.col5(info[607]),
		.col6(info[608])
	);
	RAM_set u_info_87 (
		.clk(clk),
		.rst(rst),
		.data(6'b01_1011),
		.col0(info[609]),
		.col1(info[610]),
		.col2(info[611]),
		.col3(info[612]),
		.col4(info[613]),
		.col5(info[614]),
		.col6(info[615])
	);
	RAM_set u_info_88 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_0011),
		.col0(info[616]),
		.col1(info[617]),
		.col2(info[618]),
		.col3(info[619]),
		.col4(info[620]),
		.col5(info[621]),
		.col6(info[622])
	);
	RAM_set u_info_89 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(info[623]),
		.col1(info[624]),
		.col2(info[625]),
		.col3(info[626]),
		.col4(info[627]),
		.col5(info[628]),
		.col6(info[629])
	);
	assign info[630] = 8'b0000_0000;
	assign info[631] = 8'b0000_0000;
	assign info[632] = 8'b0000_0000;
	assign info[633] = 8'b0000_0000;
	assign info[634] = 8'b0000_0000;
	assign info[635] = 8'b0000_0000;
	assign info[636] = 8'b0000_0000;
	assign info[637] = 8'b0000_0000;
	assign info[638] = 8'b0000_0000;
	assign info[639] = 8'b0000_0000;

	assign pixel[0] = 8'b0000_0000;
	assign pixel[1] = 8'b0000_0000;
	assign pixel[2] = 8'b0000_0000;
	assign pixel[3] = 8'b0000_0000;
	assign pixel[4] = 8'b0000_0000;
	assign pixel[5] = 8'b0000_0000;
	assign pixel[6] = 8'b0000_0000;
	RAM_set u_pc_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, pc[7:4]}),
		.col0(pixel[7]),
		.col1(pixel[8]),
		.col2(pixel[9]),
		.col3(pixel[10]),
		.col4(pixel[11]),
		.col5(pixel[12]),
		.col6(pixel[13])
	);
	RAM_set u_pc_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, pc[3:0]}),
		.col0(pixel[14]),
		.col1(pixel[15]),
		.col2(pixel[16]),
		.col3(pixel[17]),
		.col4(pixel[18]),
		.col5(pixel[19]),
		.col6(pixel[20])
	);
	RAM_set u_colon_1 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[21]),
		.col1(pixel[22]),
		.col2(pixel[23]),
		.col3(pixel[24]),
		.col4(pixel[25]),
		.col5(pixel[26]),
		.col6(pixel[27])
	);
	RAM_set u_id_ir_15 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[15]}),
		.col0(pixel[28]),
		.col1(pixel[29]),
		.col2(pixel[30]),
		.col3(pixel[31]),
		.col4(pixel[32]),
		.col5(pixel[33]),
		.col6(pixel[34])
	);
	RAM_set u_id_ir_14 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[14]}),
		.col0(pixel[35]),
		.col1(pixel[36]),
		.col2(pixel[37]),
		.col3(pixel[38]),
		.col4(pixel[39]),
		.col5(pixel[40]),
		.col6(pixel[41])
	);
	RAM_set u_id_ir_13 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[13]}),
		.col0(pixel[42]),
		.col1(pixel[43]),
		.col2(pixel[44]),
		.col3(pixel[45]),
		.col4(pixel[46]),
		.col5(pixel[47]),
		.col6(pixel[48])
	);
	RAM_set u_id_ir_12 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[12]}),
		.col0(pixel[49]),
		.col1(pixel[50]),
		.col2(pixel[51]),
		.col3(pixel[52]),
		.col4(pixel[53]),
		.col5(pixel[54]),
		.col6(pixel[55])
	);
	RAM_set u_id_ir_11 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[11]}),
		.col0(pixel[56]),
		.col1(pixel[57]),
		.col2(pixel[58]),
		.col3(pixel[59]),
		.col4(pixel[60]),
		.col5(pixel[61]),
		.col6(pixel[62])
	);
	RAM_set u_id_ir_10 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[10]}),
		.col0(pixel[63]),
		.col1(pixel[64]),
		.col2(pixel[65]),
		.col3(pixel[66]),
		.col4(pixel[67]),
		.col5(pixel[68]),
		.col6(pixel[69])
	);
	RAM_set u_id_ir_9 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[9]}),
		.col0(pixel[70]),
		.col1(pixel[71]),
		.col2(pixel[72]),
		.col3(pixel[73]),
		.col4(pixel[74]),
		.col5(pixel[75]),
		.col6(pixel[76])
	);
	RAM_set u_id_ir_8 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[8]}),
		.col0(pixel[77]),
		.col1(pixel[78]),
		.col2(pixel[79]),
		.col3(pixel[80]),
		.col4(pixel[81]),
		.col5(pixel[82]),
		.col6(pixel[83])
	);
	RAM_set u_id_ir_7 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[7]}),
		.col0(pixel[84]),
		.col1(pixel[85]),
		.col2(pixel[86]),
		.col3(pixel[87]),
		.col4(pixel[88]),
		.col5(pixel[89]),
		.col6(pixel[90])
	);
	RAM_set u_id_ir_6 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[6]}),
		.col0(pixel[91]),
		.col1(pixel[92]),
		.col2(pixel[93]),
		.col3(pixel[94]),
		.col4(pixel[95]),
		.col5(pixel[96]),
		.col6(pixel[97])
	);
	RAM_set u_id_ir_5 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[5]}),
		.col0(pixel[98]),
		.col1(pixel[99]),
		.col2(pixel[100]),
		.col3(pixel[101]),
		.col4(pixel[102]),
		.col5(pixel[103]),
		.col6(pixel[104])
	);
	RAM_set u_id_ir_4 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[4]}),
		.col0(pixel[105]),
		.col1(pixel[106]),
		.col2(pixel[107]),
		.col3(pixel[108]),
		.col4(pixel[109]),
		.col5(pixel[110]),
		.col6(pixel[111])
	);
	RAM_set u_id_ir_3 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[3]}),
		.col0(pixel[112]),
		.col1(pixel[113]),
		.col2(pixel[114]),
		.col3(pixel[115]),
		.col4(pixel[116]),
		.col5(pixel[117]),
		.col6(pixel[118])
	);
	RAM_set u_id_ir_2 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[2]}),
		.col0(pixel[119]),
		.col1(pixel[120]),
		.col2(pixel[121]),
		.col3(pixel[122]),
		.col4(pixel[123]),
		.col5(pixel[124]),
		.col6(pixel[125])
	);
	RAM_set u_id_ir_1 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[1]}),
		.col0(pixel[126]),
		.col1(pixel[127]),
		.col2(pixel[128]),
		.col3(pixel[129]),
		.col4(pixel[130]),
		.col5(pixel[131]),
		.col6(pixel[132])
	);
	RAM_set u_id_ir_0 (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, id_ir[0]}),
		.col0(pixel[133]),
		.col1(pixel[134]),
		.col2(pixel[135]),
		.col3(pixel[136]),
		.col4(pixel[137]),
		.col5(pixel[138]),
		.col6(pixel[139])
	);
	RAM_set u_colon_2 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[140]),
		.col1(pixel[141]),
		.col2(pixel[142]),
		.col3(pixel[143]),
		.col4(pixel[144]),
		.col5(pixel[145]),
		.col6(pixel[146])
	);
	RAM_set u_ex_ir_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, ex_ir[15:12]}),
		.col0(pixel[147]),
		.col1(pixel[148]),
		.col2(pixel[149]),
		.col3(pixel[150]),
		.col4(pixel[151]),
		.col5(pixel[152]),
		.col6(pixel[153])
	);
	RAM_set u_ex_ir_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, ex_ir[11:8]}),
		.col0(pixel[154]),
		.col1(pixel[155]),
		.col2(pixel[156]),
		.col3(pixel[157]),
		.col4(pixel[158]),
		.col5(pixel[159]),
		.col6(pixel[160])
	);
	RAM_set u_ex_ir_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, ex_ir[7:4]}),
		.col0(pixel[161]),
		.col1(pixel[162]),
		.col2(pixel[163]),
		.col3(pixel[164]),
		.col4(pixel[165]),
		.col5(pixel[166]),
		.col6(pixel[167])
	);
	RAM_set u_ex_ir_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, ex_ir[3:0]}),
		.col0(pixel[168]),
		.col1(pixel[169]),
		.col2(pixel[170]),
		.col3(pixel[171]),
		.col4(pixel[172]),
		.col5(pixel[173]),
		.col6(pixel[174])
	);
	RAM_set u_colon_3 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[175]),
		.col1(pixel[176]),
		.col2(pixel[177]),
		.col3(pixel[178]),
		.col4(pixel[179]),
		.col5(pixel[180]),
		.col6(pixel[181])
	);
	RAM_set u_reg_B_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_B[15:12]}),
		.col0(pixel[182]),
		.col1(pixel[183]),
		.col2(pixel[184]),
		.col3(pixel[185]),
		.col4(pixel[186]),
		.col5(pixel[187]),
		.col6(pixel[188])
	);
	RAM_set u_reg_B_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_B[11:8]}),
		.col0(pixel[189]),
		.col1(pixel[190]),
		.col2(pixel[191]),
		.col3(pixel[192]),
		.col4(pixel[193]),
		.col5(pixel[194]),
		.col6(pixel[195])
	);
	RAM_set u_reg_B_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_B[7:4]}),
		.col0(pixel[196]),
		.col1(pixel[197]),
		.col2(pixel[198]),
		.col3(pixel[199]),
		.col4(pixel[200]),
		.col5(pixel[201]),
		.col6(pixel[202])
	);
	RAM_set u_reg_B_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_B[3:0]}),
		.col0(pixel[203]),
		.col1(pixel[204]),
		.col2(pixel[205]),
		.col3(pixel[206]),
		.col4(pixel[207]),
		.col5(pixel[208]),
		.col6(pixel[209])
	);
	RAM_set u_colon_4 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[210]),
		.col1(pixel[211]),
		.col2(pixel[212]),
		.col3(pixel[213]),
		.col4(pixel[214]),
		.col5(pixel[215]),
		.col6(pixel[216])
	);
	RAM_set u_reg_A_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_A[15:12]}),
		.col0(pixel[217]),
		.col1(pixel[218]),
		.col2(pixel[219]),
		.col3(pixel[220]),
		.col4(pixel[221]),
		.col5(pixel[222]),
		.col6(pixel[223])
	);
	RAM_set u_reg_A_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_A[11:8]}),
		.col0(pixel[224]),
		.col1(pixel[225]),
		.col2(pixel[226]),
		.col3(pixel[227]),
		.col4(pixel[228]),
		.col5(pixel[229]),
		.col6(pixel[230])
	);
	RAM_set u_reg_A_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_A[7:4]}),
		.col0(pixel[231]),
		.col1(pixel[232]),
		.col2(pixel[233]),
		.col3(pixel[234]),
		.col4(pixel[235]),
		.col5(pixel[236]),
		.col6(pixel[237])
	);
	RAM_set u_reg_A_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_A[3:0]}),
		.col0(pixel[238]),
		.col1(pixel[239]),
		.col2(pixel[240]),
		.col3(pixel[241]),
		.col4(pixel[242]),
		.col5(pixel[243]),
		.col6(pixel[244])
	);
	RAM_set u_colon_5 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[245]),
		.col1(pixel[246]),
		.col2(pixel[247]),
		.col3(pixel[248]),
		.col4(pixel[249]),
		.col5(pixel[250]),
		.col6(pixel[251])
	);
	RAM_set u_smdr_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, smdr[15:12]}),
		.col0(pixel[252]),
		.col1(pixel[253]),
		.col2(pixel[254]),
		.col3(pixel[255]),
		.col4(pixel[256]),
		.col5(pixel[257]),
		.col6(pixel[258])
	);
	RAM_set u_smdr_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, smdr[11:8]}),
		.col0(pixel[259]),
		.col1(pixel[260]),
		.col2(pixel[261]),
		.col3(pixel[262]),
		.col4(pixel[263]),
		.col5(pixel[264]),
		.col6(pixel[265])
	);
	RAM_set u_smdr_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, smdr[7:4]}),
		.col0(pixel[266]),
		.col1(pixel[267]),
		.col2(pixel[268]),
		.col3(pixel[269]),
		.col4(pixel[270]),
		.col5(pixel[271]),
		.col6(pixel[272])
	);
	RAM_set u_smdr_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, smdr[3:0]}),
		.col0(pixel[273]),
		.col1(pixel[274]),
		.col2(pixel[275]),
		.col3(pixel[276]),
		.col4(pixel[277]),
		.col5(pixel[278]),
		.col6(pixel[279])
	);
	RAM_set u_colon_6 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[280]),
		.col1(pixel[281]),
		.col2(pixel[282]),
		.col3(pixel[283]),
		.col4(pixel[284]),
		.col5(pixel[285]),
		.col6(pixel[286])
	);
	RAM_set u_mem_ir_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, mem_ir[15:12]}),
		.col0(pixel[287]),
		.col1(pixel[288]),
		.col2(pixel[289]),
		.col3(pixel[290]),
		.col4(pixel[291]),
		.col5(pixel[292]),
		.col6(pixel[293])
	);
	RAM_set u_mem_ir_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, mem_ir[11:8]}),
		.col0(pixel[294]),
		.col1(pixel[295]),
		.col2(pixel[296]),
		.col3(pixel[297]),
		.col4(pixel[298]),
		.col5(pixel[299]),
		.col6(pixel[300])
	);
	RAM_set u_mem_ir_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, mem_ir[7:4]}),
		.col0(pixel[301]),
		.col1(pixel[302]),
		.col2(pixel[303]),
		.col3(pixel[304]),
		.col4(pixel[305]),
		.col5(pixel[306]),
		.col6(pixel[307])
	);
	RAM_set u_mem_ir_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, mem_ir[3:0]}),
		.col0(pixel[308]),
		.col1(pixel[309]),
		.col2(pixel[310]),
		.col3(pixel[311]),
		.col4(pixel[312]),
		.col5(pixel[313]),
		.col6(pixel[314])
	);
	RAM_set u_colon_7 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[315]),
		.col1(pixel[316]),
		.col2(pixel[317]),
		.col3(pixel[318]),
		.col4(pixel[319]),
		.col5(pixel[320]),
		.col6(pixel[321])
	);
	RAM_set u_zf (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, zf}),
		.col0(pixel[322]),
		.col1(pixel[323]),
		.col2(pixel[324]),
		.col3(pixel[325]),
		.col4(pixel[326]),
		.col5(pixel[327]),
		.col6(pixel[328])
	);
	RAM_set u_nf (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, nf}),
		.col0(pixel[329]),
		.col1(pixel[330]),
		.col2(pixel[331]),
		.col3(pixel[332]),
		.col4(pixel[333]),
		.col5(pixel[334]),
		.col6(pixel[335])
	);
	RAM_set u_cf (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, cf}),
		.col0(pixel[336]),
		.col1(pixel[337]),
		.col2(pixel[338]),
		.col3(pixel[339]),
		.col4(pixel[340]),
		.col5(pixel[341]),
		.col6(pixel[342])
	);
	RAM_set u_dw (
		.clk(clk),
		.rst(rst),
		.data({5'b00000, dw}),
		.col0(pixel[343]),
		.col1(pixel[344]),
		.col2(pixel[345]),
		.col3(pixel[346]),
		.col4(pixel[347]),
		.col5(pixel[348]),
		.col6(pixel[349])
	);
	RAM_set u_colon_8 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[350]),
		.col1(pixel[351]),
		.col2(pixel[352]),
		.col3(pixel[353]),
		.col4(pixel[354]),
		.col5(pixel[355]),
		.col6(pixel[356])
	);
	RAM_set u_reg_C_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_C[15:12]}),
		.col0(pixel[357]),
		.col1(pixel[358]),
		.col2(pixel[359]),
		.col3(pixel[360]),
		.col4(pixel[361]),
		.col5(pixel[362]),
		.col6(pixel[363])
	);
	RAM_set u_reg_C_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_C[11:8]}),
		.col0(pixel[364]),
		.col1(pixel[365]),
		.col2(pixel[366]),
		.col3(pixel[367]),
		.col4(pixel[368]),
		.col5(pixel[369]),
		.col6(pixel[370])
	);
	RAM_set u_reg_C_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_C[7:4]}),
		.col0(pixel[371]),
		.col1(pixel[372]),
		.col2(pixel[373]),
		.col3(pixel[374]),
		.col4(pixel[375]),
		.col5(pixel[376]),
		.col6(pixel[377])
	);
	RAM_set u_reg_C_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_C[3:0]}),
		.col0(pixel[378]),
		.col1(pixel[379]),
		.col2(pixel[380]),
		.col3(pixel[381]),
		.col4(pixel[382]),
		.col5(pixel[383]),
		.col6(pixel[384])
	);
	RAM_set u_colon_9 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[385]),
		.col1(pixel[386]),
		.col2(pixel[387]),
		.col3(pixel[388]),
		.col4(pixel[389]),
		.col5(pixel[390]),
		.col6(pixel[391])
	);
	RAM_set u_smdr1_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, smdr1[15:12]}),
		.col0(pixel[392]),
		.col1(pixel[393]),
		.col2(pixel[394]),
		.col3(pixel[395]),
		.col4(pixel[396]),
		.col5(pixel[397]),
		.col6(pixel[398])
	);
	RAM_set u_smdr1_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, smdr1[11:8]}),
		.col0(pixel[399]),
		.col1(pixel[400]),
		.col2(pixel[401]),
		.col3(pixel[402]),
		.col4(pixel[403]),
		.col5(pixel[404]),
		.col6(pixel[405])
	);
	RAM_set u_smdr1_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, smdr1[7:4]}),
		.col0(pixel[406]),
		.col1(pixel[407]),
		.col2(pixel[408]),
		.col3(pixel[409]),
		.col4(pixel[410]),
		.col5(pixel[411]),
		.col6(pixel[412])
	);
	RAM_set u_smdr1_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, smdr1[3:0]}),
		.col0(pixel[413]),
		.col1(pixel[414]),
		.col2(pixel[415]),
		.col3(pixel[416]),
		.col4(pixel[417]),
		.col5(pixel[418]),
		.col6(pixel[419])
	);
	RAM_set u_colon_10 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[420]),
		.col1(pixel[421]),
		.col2(pixel[422]),
		.col3(pixel[423]),
		.col4(pixel[424]),
		.col5(pixel[425]),
		.col6(pixel[426])
	);
	RAM_set u_wb_ir_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, wb_ir[15:12]}),
		.col0(pixel[427]),
		.col1(pixel[428]),
		.col2(pixel[429]),
		.col3(pixel[430]),
		.col4(pixel[431]),
		.col5(pixel[432]),
		.col6(pixel[433])
	);
	RAM_set u_wb_ir_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, wb_ir[11:8]}),
		.col0(pixel[434]),
		.col1(pixel[435]),
		.col2(pixel[436]),
		.col3(pixel[437]),
		.col4(pixel[438]),
		.col5(pixel[439]),
		.col6(pixel[440])
	);
	RAM_set u_wb_ir_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, wb_ir[7:4]}),
		.col0(pixel[441]),
		.col1(pixel[442]),
		.col2(pixel[443]),
		.col3(pixel[444]),
		.col4(pixel[445]),
		.col5(pixel[446]),
		.col6(pixel[447])
	);
	RAM_set u_wb_ir_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, wb_ir[3:0]}),
		.col0(pixel[448]),
		.col1(pixel[449]),
		.col2(pixel[450]),
		.col3(pixel[451]),
		.col4(pixel[452]),
		.col5(pixel[453]),
		.col6(pixel[454])
	);
	RAM_set u_colon_11 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[455]),
		.col1(pixel[456]),
		.col2(pixel[457]),
		.col3(pixel[458]),
		.col4(pixel[459]),
		.col5(pixel[460]),
		.col6(pixel[461])
	);
	RAM_set u_reg_C1_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_C1[15:12]}),
		.col0(pixel[462]),
		.col1(pixel[463]),
		.col2(pixel[464]),
		.col3(pixel[465]),
		.col4(pixel[466]),
		.col5(pixel[467]),
		.col6(pixel[468])
	);
	RAM_set u_reg_C1_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_C1[11:8]}),
		.col0(pixel[469]),
		.col1(pixel[470]),
		.col2(pixel[471]),
		.col3(pixel[472]),
		.col4(pixel[473]),
		.col5(pixel[474]),
		.col6(pixel[475])
	);
	RAM_set u_reg_C1_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_C1[7:4]}),
		.col0(pixel[476]),
		.col1(pixel[477]),
		.col2(pixel[478]),
		.col3(pixel[479]),
		.col4(pixel[480]),
		.col5(pixel[481]),
		.col6(pixel[482])
	);
	RAM_set u_reg_C1_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, reg_C1[3:0]}),
		.col0(pixel[483]),
		.col1(pixel[484]),
		.col2(pixel[485]),
		.col3(pixel[486]),
		.col4(pixel[487]),
		.col5(pixel[488]),
		.col6(pixel[489])
	);
	RAM_set u_colon_12 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[490]),
		.col1(pixel[491]),
		.col2(pixel[492]),
		.col3(pixel[493]),
		.col4(pixel[494]),
		.col5(pixel[495]),
		.col6(pixel[496])
	);
	RAM_set u_gr0_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr0[15:12]}),
		.col0(pixel[497]),
		.col1(pixel[498]),
		.col2(pixel[499]),
		.col3(pixel[500]),
		.col4(pixel[501]),
		.col5(pixel[502]),
		.col6(pixel[503])
	);
	RAM_set u_gr0_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr0[11:8]}),
		.col0(pixel[504]),
		.col1(pixel[505]),
		.col2(pixel[506]),
		.col3(pixel[507]),
		.col4(pixel[508]),
		.col5(pixel[509]),
		.col6(pixel[510])
	);
	RAM_set u_gr0_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr0[7:4]}),
		.col0(pixel[511]),
		.col1(pixel[512]),
		.col2(pixel[513]),
		.col3(pixel[514]),
		.col4(pixel[515]),
		.col5(pixel[516]),
		.col6(pixel[517])
	);
	RAM_set u_gr0_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr0[3:0]}),
		.col0(pixel[518]),
		.col1(pixel[519]),
		.col2(pixel[520]),
		.col3(pixel[521]),
		.col4(pixel[522]),
		.col5(pixel[523]),
		.col6(pixel[524])
	);
	RAM_set u_colon_13 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[525]),
		.col1(pixel[526]),
		.col2(pixel[527]),
		.col3(pixel[528]),
		.col4(pixel[529]),
		.col5(pixel[530]),
		.col6(pixel[531])
	);
	RAM_set u_gr1_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr1[15:12]}),
		.col0(pixel[532]),
		.col1(pixel[533]),
		.col2(pixel[534]),
		.col3(pixel[535]),
		.col4(pixel[536]),
		.col5(pixel[537]),
		.col6(pixel[538])
	);
	RAM_set u_gr1_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr1[11:8]}),
		.col0(pixel[539]),
		.col1(pixel[540]),
		.col2(pixel[541]),
		.col3(pixel[542]),
		.col4(pixel[543]),
		.col5(pixel[544]),
		.col6(pixel[545])
	);
	RAM_set u_gr1_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr1[7:4]}),
		.col0(pixel[546]),
		.col1(pixel[547]),
		.col2(pixel[548]),
		.col3(pixel[549]),
		.col4(pixel[550]),
		.col5(pixel[551]),
		.col6(pixel[552])
	);
	RAM_set u_gr1_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr1[3:0]}),
		.col0(pixel[553]),
		.col1(pixel[554]),
		.col2(pixel[555]),
		.col3(pixel[556]),
		.col4(pixel[557]),
		.col5(pixel[558]),
		.col6(pixel[559])
	);
	RAM_set u_colon_14 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[560]),
		.col1(pixel[561]),
		.col2(pixel[562]),
		.col3(pixel[563]),
		.col4(pixel[564]),
		.col5(pixel[565]),
		.col6(pixel[566])
	);
	RAM_set u_gr2_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr2[15:12]}),
		.col0(pixel[567]),
		.col1(pixel[568]),
		.col2(pixel[569]),
		.col3(pixel[570]),
		.col4(pixel[571]),
		.col5(pixel[572]),
		.col6(pixel[573])
	);
	RAM_set u_gr2_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr2[11:8]}),
		.col0(pixel[574]),
		.col1(pixel[575]),
		.col2(pixel[576]),
		.col3(pixel[577]),
		.col4(pixel[578]),
		.col5(pixel[579]),
		.col6(pixel[580])
	);
	RAM_set u_gr2_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr2[7:4]}),
		.col0(pixel[581]),
		.col1(pixel[582]),
		.col2(pixel[583]),
		.col3(pixel[584]),
		.col4(pixel[585]),
		.col5(pixel[586]),
		.col6(pixel[587])
	);
	RAM_set u_gr2_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr2[3:0]}),
		.col0(pixel[588]),
		.col1(pixel[589]),
		.col2(pixel[590]),
		.col3(pixel[591]),
		.col4(pixel[592]),
		.col5(pixel[593]),
		.col6(pixel[594])
	);
	RAM_set u_colon_15 (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1111),
		.col0(pixel[595]),
		.col1(pixel[596]),
		.col2(pixel[597]),
		.col3(pixel[598]),
		.col4(pixel[599]),
		.col5(pixel[600]),
		.col6(pixel[601])
	);
	RAM_set u_gr3_3 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr3[15:12]}),
		.col0(pixel[602]),
		.col1(pixel[603]),
		.col2(pixel[604]),
		.col3(pixel[605]),
		.col4(pixel[606]),
		.col5(pixel[607]),
		.col6(pixel[608])
	);
	RAM_set u_gr3_2 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr3[11:8]}),
		.col0(pixel[609]),
		.col1(pixel[610]),
		.col2(pixel[611]),
		.col3(pixel[612]),
		.col4(pixel[613]),
		.col5(pixel[614]),
		.col6(pixel[615])
	);
	RAM_set u_gr3_1 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr3[7:4]}),
		.col0(pixel[616]),
		.col1(pixel[617]),
		.col2(pixel[618]),
		.col3(pixel[619]),
		.col4(pixel[620]),
		.col5(pixel[621]),
		.col6(pixel[622])
	);
	RAM_set u_gr3_0 (
		.clk(clk),
		.rst(rst),
		.data({2'b00, gr3[3:0]}),
		.col0(pixel[623]),
		.col1(pixel[624]),
		.col2(pixel[625]),
		.col3(pixel[626]),
		.col4(pixel[627]),
		.col5(pixel[628]),
		.col6(pixel[629])
	);
	assign pixel[630] = 8'b0000_0000;
	assign pixel[631] = 8'b0000_0000;
	assign pixel[632] = 8'b0000_0000;
	assign pixel[633] = 8'b0000_0000;
	assign pixel[634] = 8'b0000_0000;
	assign pixel[635] = 8'b0000_0000;
	assign pixel[636] = 8'b0000_0000;
	assign pixel[637] = 8'b0000_0000;
	assign pixel[638] = 8'b0000_0000;
	assign pixel[639] = 8'b0000_0000;

endmodule
