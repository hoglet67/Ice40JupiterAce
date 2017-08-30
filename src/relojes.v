module cuatro_relojes
  (
   // Clock in ports
   input wire  CLK_IN1,
   // Clock out ports
   output wire CLK_OUT1,
   output wire CLK_OUT2,
   output wire CLK_OUT3,
   output wire CLK_OUT4
   );

   wire        clkout0;
   wire        PLL_BYPASS = 0;
   wire        PLL_RESETB = 1;

   SB_PLL40_CORE
     #(
       .FEEDBACK_PATH("SIMPLE"),
       .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
       .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
       .PLLOUT_SELECT("GENCLK"),
       .SHIFTREG_DIV_MODE(1'b0),
       .FDA_FEEDBACK(4'b0000),
       .FDA_RELATIVE(4'b0000),
       .DIVR(4'b1000),
       .DIVF(7'b1001010),
       .DIVQ(3'b101),
       .FILTER_RANGE(3'b001)
       ) 
   uut
     (
      .REFERENCECLK   (CLK_IN1),
      .PLLOUTGLOBAL   (clkout0),
      .BYPASS         (PLL_BYPASS),
      .RESETB         (PLL_RESETB),
      .LOCK           ()
      );

   reg [2:0]   clkdivider = 3'b000;
   always @(posedge clkout0)
     clkdivider <= clkdivider + 3'b001;
   
   assign CLK_OUT1 = clkout0;
   assign CLK_OUT2 = clkdivider[0];
   assign CLK_OUT3 = clkdivider[1];
   assign CLK_OUT4 = clkdivider[2];
   
endmodule
