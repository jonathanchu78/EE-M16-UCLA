// EEM16 - Logic Design
// Design Assignment #3.2
// dassign3_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided

// ****************
// Blocks to design
// ****************
`timescale 1ns / 1ps

// 3.2a) Inter-layer module
// four sets of inputs: 8 bit value, 1 bit input ready
// one 1 bit input new (from input layer of neurons)
// four sets of 8 bits output
// one 1 bit output ready
module interlayer(clk, new, in1, ready1, in2, ready2, in3, ready3, in4, ready4,
                  out1, out2, out3, out4, ready_out);
    input clk;
    input new;
    input [7:0] in1, in2, in3, in4;
    input ready1, ready2, ready3, ready4;
    output [7:0] out1, out2, out3, out4;
    output ready_out;
  ///////////////////
  //mux outputs
  wire [7:0] mx1, mx2, mx3, mx4;
  //ready register outputs
  wire ready, prevready, invready, rdy;
  //outputs before output reg
  wire [7:0] out1_0, out2_0, out3_0, out4_0;
  wire ready_out_0;
  //input muxes
  mux2 #(8) m1(out1, in1, ready1, mx1);
  mux2 #(8) m2(out2, in2, ready2, mx2);
  mux2 #(8) m3(out3, in3, ready3, mx3);
  mux2 #(8) m4(out4, in4, ready4, mx4);
  //output registers
  dreg #(8) dreg1(clk, mx1, out1_0);
  dreg #(8) dreg2(clk, mx2, out2_0);
  dreg #(8) dreg3(clk, mx3, out3_0);
  dreg #(8) dreg4(clk, mx4, out4_0);
  //ready
  assign ready = ready1 & ready2 & ready3 & ready4;
  dreg reg_ready(clk, ready, prevready);
  inverter invert(prevready, invready);
  assign rdy = invready & ready;
  dreg reg_ready2(clk, rdy, ready_out_0);
  //output registers
  dreg #(32) outputreg1(clk, {out1_0, out2_0, out3_0, out4_0}, {out1, out2, out3, out4});
  dreg outputreg2(clk, ready_out_0, ready_out);
endmodule
