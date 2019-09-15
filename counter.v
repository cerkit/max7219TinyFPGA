/*
   Parameters:
     SIZE = 8
     DIV = 0
     TOP = 0
     UP = 1
*/
module counter (
    input clk,
    input rst,
    output reg [7:0] value
  );

  // These are non-functional until I learn what they're for
  parameter SIZE = 4'h8;
  parameter DIV = 1'h0;
  parameter TOP = 1'h0;
  parameter UP = 1'h1;


  reg [7:0] M_ctr_d, M_ctr_q = 1'h0;

  localparam MAX_VALUE = 1'h0;

  always @* begin
    M_ctr_d = M_ctr_q;

    value = M_ctr_q[0+7-:8];
    if (1'h1) begin
      M_ctr_d = M_ctr_q + 1'h1;
      if (1'h0 && M_ctr_q == 1'h0) begin
        M_ctr_d = 1'h0;
      end
    end else begin
      M_ctr_d = M_ctr_q - 1'h1;
      if (1'h0 && M_ctr_q == 1'h0) begin
        M_ctr_d = 1'h0;
      end
    end
  end

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      M_ctr_q <= 1'h0;
    end else begin
      M_ctr_q <= M_ctr_d;
    end
  end

endmodule
