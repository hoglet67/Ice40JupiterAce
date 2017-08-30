`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:18:12 11/07/2015 
// Design Name: 
// Module Name:    jupiter_ace 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module jupiter_ace (
    input wire         clk100,
    input wire         clkps2,
    input wire         dataps2,
    input wire         ear,
    output wire        audio_out_left,
    output wire        audio_out_right,
    output wire [2:0]  r,
    output wire [2:0]  g,
    output wire [2:0]  b,
    output wire        hsync,
	 output wire        vsync,
    output wire        stdn,
    output wire        stdnb
    );
        
    wire clkram; // 26.666666MHz to clock internal RAM/ROM
    wire clk65;  // 6.5MHz main frequency Jupiter ACE
    wire clkcpu; // CPU CLK
	 wire clkvga; // Twice the original pixel clock
                    
    wire kbd_reset;
    wire [7:0] kbd_rows;
    wire [4:0] kbd_columns;
    wire video; // 1-bit video signal (black/white)
    
    // Trivial conversion from B/W video to RGB for the scandoubler
	 wire pal_hsync, pal_vsync; // inputs to the scandoubler
    wire [2:0] ri = {video,video,1'b0};
    wire [2:0] gi = {video,video,1'b0};
    wire [2:0] bi = {video,video,1'b0};
    
    // Trivial conversion for audio
    wire mic,spk;
    assign audio_out_left = spk;
    assign audio_out_right = mic;
    
    // Select PAL
    assign stdn = 1'b0;  // PAL selection for AD724
    assign stdnb = 1'b1;  // 4.43MHz crystal selected

    
    // Power-on RESET (8 clocks)
    reg [7:0] poweron_reset = 8'h00;
    always @(posedge clk65) begin
        poweron_reset <= {poweron_reset[6:0],1'b1};
    end
    
    cuatro_relojes system_clocks_pll (
        .CLK_IN1(clk100),
        .CLK_OUT1(clkram),  // for driving RAM and ROM = 26 MHz
        .CLK_OUT2(clkvga),  // VGA clock: 2 x video clock
        .CLK_OUT3(clk65),   // video clock = 6.5 MHz
        .CLK_OUT4(clkcpu)   // CPU clock = 3.25 MHz
    );

    fpga_ace the_core (
        .clkram(clkram),
        .clk65(clk65),
        .clkcpu(clkcpu),
        .reset(kbd_reset & poweron_reset[7]),
        .ear(ear),
        .filas(kbd_rows),
        .columnas(kbd_columns),
        .video(video),
        .hsync(pal_hsync),
		  .vsync(pal_vsync),
        .mic(mic),
        .spk(spk)
	);

    keyboard_for_ace the_keyboard (
        .clk(clk65),
        .clkps2(clkps2),
        .dataps2(dataps2),
        .rows(kbd_rows),
        .columns(kbd_columns),
        .kbd_reset(kbd_reset),
        .kbd_nmi(),
        .kbd_mreset()
    );
	 
	vga_scandoubler #(.CLKVIDEO(6500)) salida_vga (
		.clkvideo(clk65),
		.clkvga(clkvga),
      .enable_scandoubling(1'b1),
      .disable_scaneffect(1'b1),
		.ri(ri),
		.gi(gi),
		.bi(bi),
		.hsync_ext_n(pal_hsync),
		.vsync_ext_n(pal_vsync),
		.ro(r),
		.go(g),
		.bo(b),
		.hsync(hsync),
		.vsync(vsync)
   );	 
   
endmodule
