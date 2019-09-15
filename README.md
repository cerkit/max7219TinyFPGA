# max7219TinyFPGA
Display DEADBEEF on Max7219 7-Segment Display for TinyFPGA

This code was originally written in the Lucid HDL from [Alchitry](https://alchitry.com), but it was transpiled into Verilog by the Mojo IDE. One of the side-effects of this process is that the module parameters are defined as localparam and are not used anywhere.

I have slightly modified the Verilog that was generated so that it would run on the TinyFPGA.

* Pin 13 - Max7219 clk
* Pin 12 - Max7219 din
* Pin 11 - Max7219 CS
