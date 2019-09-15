/*
   Parameters:
     CLK_DIV = 8
     CPOL = 0
     CPHA = 0
*/
module spi_master (
    input clk,
    input rst,
    input miso,
    output reg mosi,
    output reg sck,
    input start,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg new_data,
    output reg busy
  );

  // These are currently non-functional until I learn what they're for
  localparam CLK_DIV = 4'h8;
  localparam CPOL = 1'h0;
  localparam CPHA = 1'h0;


  localparam IDLE_state = 1'd0;
  localparam TRANSFER_state = 1'd1;

  reg M_state_d, M_state_q = IDLE_state;
  reg [7:0] M_data_d, M_data_q = 1'h0;
  reg [7:0] M_sck_reg_d, M_sck_reg_q = 1'h0;
  reg M_mosi_reg_d, M_mosi_reg_q = 1'h0;
  reg [2:0] M_ctr_d, M_ctr_q = 1'h0;

  always @* begin
    M_state_d = M_state_q;
    M_mosi_reg_d = M_mosi_reg_q;
    M_sck_reg_d = M_sck_reg_q;
    M_data_d = M_data_q;
    M_ctr_d = M_ctr_q;

    new_data = 1'h0;
    busy = M_state_q != IDLE_state;
    data_out = M_data_q;
    sck = ((1'h0 ^ M_sck_reg_q[7+0-:1]) & (M_state_q == TRANSFER_state)) ^ 1'h0;
    mosi = M_mosi_reg_q;

    case (M_state_q)
      IDLE_state: begin
        M_sck_reg_d = 1'h0;
        M_ctr_d = 1'h0;
        if (start) begin
          M_data_d = data_in;
          M_state_d = TRANSFER_state;
        end
      end
      TRANSFER_state: begin
        M_sck_reg_d = M_sck_reg_q + 1'h1;
        if (M_sck_reg_q == 1'h0) begin
          M_mosi_reg_d = M_data_q[7+0-:1];
        end else begin
          if (M_sck_reg_q == 7'h7f) begin
            M_data_d = {M_data_q[0+6-:7], miso};
          end else begin
            if (M_sck_reg_q == 8'hff) begin
              M_ctr_d = M_ctr_q + 1'h1;
              if (M_ctr_q == 3'h7) begin
                M_state_d = IDLE_state;
                new_data = 1'h1;
              end
            end
          end
        end
      end
    endcase
  end

  always @(posedge clk) begin
    M_data_q <= M_data_d;
    M_sck_reg_q <= M_sck_reg_d;
    M_mosi_reg_q <= M_mosi_reg_d;
    M_ctr_q <= M_ctr_d;

    if (rst == 1'b1) begin
      M_state_q <= 1'h0;
    end else begin
      M_state_q <= M_state_d;
    end
  end

endmodule
