// EEM16 - Logic Design
// Design Assignment #3.1
// dassign3_1.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided

// ****************
// Blocks to design
// ****************
`include "constants3.vh"
`timescale 1ns / 1ps

// 3.1a) Rectified linear unit
// out = max(0, in/4)
// 16 bit signed input
// 8 bit unsigned output
module relu(in, out);
    input [15:0] in;
    output [7:0] out;
  ////////
  reg [12:0] div;
  reg out;

  always @(*) begin
    if (in[15] == 1'b0) begin
      div = in/4;
      out = div[7:0];
    end
    else
      out = 8'b0;
  end
endmodule



// 3.1b) Pipelined 5 input ripple-carry adder
// 16 bit signed inputs
// 1 bit input: valid (when the other inputs are useful numbers)
// 16 bit signed output (truncated)
// 1 bit output: ready (when the output is the sum of valid inputs)
module piped_adder(clk, a, b, c, d, e, valid, sum, ready);
    input clk, valid;
    input [15:0] a, b, c, d, e;
    output [15:0] sum;
    output ready;
  ///////
  //carries:
  wire [2:0] first, first1, second, second1, third, third1, fourth; //fourth is never actually used usefully
  //inputs saves
  wire [59:0] in0; //59:48 is a, 47:36 is b, etc
  wire [39:0] in1; //39:32 is a, 31:24 is b, etc
  wire [19:0] in2; //19:16 is a, 15:12 is b, etc
  //output saves
  wire [15:0] out0;
  wire [11:0] out1;
  wire [7:0] out2;
  wire [3:0] out3;
  
  //adders
  adder5carry add0(a[3:0], b[3:0], c[3:0], d[3:0], e[3:0], 1'b0, 1'b0, 1'b0, first[2], first[1], first[0], out0[3:0]);
  adder5carry add1(in0[51:48], in0[39:36], in0[27:24], in0[15:12], in0[3:0], first1[2], first1[1], first1[0], second[2], second[1], second[0], out0[7:4]);
  adder5carry add2(in1[35:32], in1[27:24], in1[19:16], in1[11:8], in1[3:0], second1[2], second1[1], second1[0], third[2], third[1], third[0], out0[11:8]);
  adder5carry add3(in2[19:16], in2[15:12], in2[11:8], in2[7:4], in2[3:0], third1[2], third1[1], third1[0], fourth[2], fourth[1], fourth[0], out0[15:12]);
  
  //pipeline registers
  dreg #(3) pipe1(clk, first, first1);
  dreg #(3) pipe2(clk, second, second1);
  dreg #(3) pipe3(clk, third, third1);
  
  //input registers
  dreg #(60) regin0(clk, {a[15:4], b[15:4], c[15:4], d[15:4], e[15:4]}, in0);
  dreg #(40) regin1(clk, {in0[59:52], in0[47:40], in0[35:28], in0[23:16], in0[11:4]}, in1); 
  dreg #(20) regin2(clk, {in1[39:36], in1[31:28], in1[23:20], in1[15:12], in1[7:4]}, in2);
  
  //output registers
  dreg #(16) regout0(clk, out0, {sum[15:12], out1});
  dreg #(12) regout1(clk, out1, {sum[11:8], out2});
  dreg #(8) regout2(clk, out2, {sum[7:4], out3});
  dreg #(4) regout3(clk, out3, sum[3:0]);
                                 
  //valid and ready
  wire betw0, betw1, betw2;
  dreg vldrdy0(clk, valid, betw0);
  dreg vldrdy1(clk, betw0, betw1);
  dreg vldrdy2(clk, betw1, betw2);
  dreg vldrdy3(clk, betw2, ready);
  
endmodule



// 3.1c) Pipelined neuron
// 8 bit signed weights, bias (constant)
// 8 bit unsigned inputs 
// 1 bit input: new (when a set of inputs are available)
// 8 bit unsigned output 
// 1 bit output: ready (when the output is valid)
module neuron(clk, w1, w2, w3, w4, b, x1, x2, x3, x4, new, y, ready);
    input clk;
    input [7:0] w1, w2, w3, w4, b;  // signed 2s complement
    input [7:0] x1, x2, x3, x4;     // unsigned
    input new;
    output [7:0] y;                 // unsigned
    output ready;
  ///////////////////
  //outputs before output reg
  wire [7:0] y_0;
  wire ready_0;
  //products
  wire [15:0] p1, p2, p3, p4;
  //readys
  wire rdy1, rdy2, rdy3, rdy4, newp;
  //sum
  wire [15:0] sum;
  //padding for bias
  wire [7:0] extend;
  assign extend = {b[7], b[7], b[7], b[7], b[7], b[7], b[7], b[7]};
  //multiplication modules
  multiply mult1(clk, w1, x1, new, p1, rdy1);
  multiply mult2(clk, w2, x2, new, p2, rdy2);
  multiply mult3(clk, w3, x3, new, p3, rdy3);
  multiply mult4(clk, w4, x4, new, p4, rdy4);
  assign newp = rdy1 & rdy2 & rdy3 & rdy4;
  //piped adder
  piped_adder adder(clk, p1, p2, p3, p4, {extend, b}, newp, sum, ready_0);
  //relu
  relu relu(sum, y_0);
  
  //output registers
  dreg out1(clk, ready_0, ready);
  dreg #(8) out2(clk, y_0, y);
endmodule
