`timescale 1us/1ps
module tb ();
  initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, t);
  end

  reg clk;
  wire pin_13, pin_12, pin_11, usbpu;

  initial begin
		clk = 1'b0;
	end

  always begin
    #31 clk = !clk;
  end

  initial #100000 $finish;

  top t (.CLK(clk), .PIN_13(pin_13), .PIN_12(pin_12), .PIN_11(pin_11), .USBPU(usbpu));

endmodule // tb
