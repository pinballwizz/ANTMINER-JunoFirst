//============================================================================
//
//  SD card ROM loader and ROM selector for MISTer.
//  Copyright (C) 2019, 2020 Kitrinx (aka Rysha)
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
//============================================================================

// ROM layout for Juno First (index 0 - main CPU board):
// 0x00000-0x01FFF = prog_rom1 (jfa_b9.bin,  CPU 0xA000-0xBFFF)
// 0x02000-0x03FFF = prog_rom2 (jfb_b10.bin, CPU 0xC000-0xDFFF)
// 0x04000-0x05FFF = prog_rom3 (jfc_a10.bin, CPU 0xE000-0xFFFF)
// 0x06000-0x07FFF = bank0     (jfc1_a4.bin, banked code+graphics)
// 0x08000-0x09FFF = bank1     (jfc2_a5.bin)
// 0x0A000-0x0BFFF = bank2     (jfc3_a6.bin)
// 0x0C000-0x0DFFF = bank3     (jfc4_a7.bin)
// 0x0E000-0x0FFFF = bank4     (jfc5_a8.bin)
// 0x10000-0x11FFF = bank5     (jfc6_a9.bin)
// 0x12000-0x13FFF = blit0     (jfs3_c7.bin, blitter sprite data)
// 0x14000-0x15FFF = blit1     (jfs4_d7.bin)
// 0x16000-0x17FFF = blit2     (jfs5_e7.bin)

module selector
(
	input logic [24:0] ioctl_addr,
	output logic prog_rom1_cs, prog_rom2_cs, prog_rom3_cs,
	output logic bank0_cs, bank1_cs, bank2_cs, bank3_cs, bank4_cs, bank5_cs,
	output logic blit0_cs, blit1_cs, blit2_cs
);

	always_comb begin
		{prog_rom1_cs, prog_rom2_cs, prog_rom3_cs,
		 bank0_cs, bank1_cs, bank2_cs, bank3_cs, bank4_cs, bank5_cs,
		 blit0_cs, blit1_cs, blit2_cs} = 0;

		if(ioctl_addr < 'h2000)
			prog_rom1_cs = 1;
		else if(ioctl_addr < 'h4000)
			prog_rom2_cs = 1;
		else if(ioctl_addr < 'h6000)
			prog_rom3_cs = 1;
		else if(ioctl_addr < 'h8000)
			bank0_cs = 1;
		else if(ioctl_addr < 'hA000)
			bank1_cs = 1;
		else if(ioctl_addr < 'hC000)
			bank2_cs = 1;
		else if(ioctl_addr < 'hE000)
			bank3_cs = 1;
		else if(ioctl_addr < 'h10000)
			bank4_cs = 1;
		else if(ioctl_addr < 'h12000)
			bank5_cs = 1;
		else if(ioctl_addr < 'h14000)
			blit0_cs = 1;
		else if(ioctl_addr < 'h16000)
			blit1_cs = 1;
		else if(ioctl_addr < 'h18000)
			blit2_cs = 1;
	end
endmodule

////////////
// EPROMS //
////////////

//Generic 4KB ROM module (12-bit address)
module eprom_4k
(
	input logic        CLK,
	input logic        CLK_DL,
	input logic [11:0] ADDR,
	input logic [24:0] ADDR_DL,
	input logic [7:0]  DATA_IN,
	input logic        CS_DL,
	input logic        WR,
	output logic [7:0] DATA
);
	dpram_dc #(.widthad_a(12)) rom
	(
		.clock_a(CLK),
		.address_a(ADDR[11:0]),
		.q_a(DATA[7:0]),

		.clock_b(CLK_DL),
		.address_b(ADDR_DL[11:0]),
		.data_b(DATA_IN),
		.wren_b(WR & CS_DL)
	);
endmodule

//Generic 8KB ROM module (13-bit address)
module eprom_8k
(
	input logic        CLK,
	input logic        CLK_DL,
	input logic [12:0] ADDR,
	input logic [24:0] ADDR_DL,
	input logic [7:0]  DATA_IN,
	input logic        CS_DL,
	input logic        WR,
	output logic [7:0] DATA
);
	dpram_dc #(.widthad_a(13)) rom
	(
		.clock_a(CLK),
		.address_a(ADDR[12:0]),
		.q_a(DATA[7:0]),

		.clock_b(CLK_DL),
		.address_b(ADDR_DL[12:0]),
		.data_b(DATA_IN),
		.wren_b(WR & CS_DL)
	);
endmodule

//Sound board ROM (8KB, 13-bit address) - used by sound board index 1
module eprom_7
(
	input logic        CLK,
	input logic        CLK_DL,
	input logic [12:0] ADDR,
	input logic [24:0] ADDR_DL,
	input logic [7:0]  DATA_IN,
	input logic        CS_DL,
	input logic        WR,
	output logic [7:0] DATA
);
	dpram_dc #(.widthad_a(13)) eprom_7
	(
		.clock_a(CLK),
		.address_a(ADDR[12:0]),
		.q_a(DATA[7:0]),

		.clock_b(CLK_DL),
		.address_b(ADDR_DL[12:0]),
		.data_b(DATA_IN),
		.wren_b(WR & CS_DL)
	);
endmodule
