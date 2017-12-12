// EEM16 - Logic Design
// Design Assignment #2 - Problem #2.1
// dassign2_1.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

`timescale 1ns / 1ps // TA Albert said this would fix timescale warning

// ***************
// Building blocks
// ***************

// D-register (flipflop).  Width set via parameter.
// Includes propagation delay t_PD = 3
module dreg(clk, d, q);
    parameter width = 1;
    input clk;
    input [width-1:0] d;
    output [width-1:0] q;
    reg [width-1:0] q;

    always @(posedge clk) begin
        q <= #3 d;
    end
endmodule

// 2-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux2(a, b, sel, y); // 0 1
    parameter width = 1;
    input [width-1:0] a, b;
    input sel;
    output [width-1:0] y;

    assign #3 y = sel ? b : a;
endmodule

// Left-shifter
// No propagation delay, it's just wires really
module shl(a, y);
    parameter width = 1;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {a[width-2:0], 1'b0};
endmodule

// Right-shifter
// more wires 
module shr(a, y);
    parameter width = 1;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {1'b0, a[width-1:1]};
endmodule

// 16-bit adder (declarative Verilog)
// Includes propagation delay t_PD = 3n = 48
module adder16(a, b, sum);
    input [15:0] a, b;
    output [15:0] sum;

    assign #48 sum = a+b;
endmodule

// ****************
// Blocks to design
// ****************

// Lowest order partial product of two inputs 
// Use declarative verilog only
// IMPORTANT: Do not change module or port names
module partial_product (a, b, pp);
  input [15:0] a;
  input [7:0] b;
  output [15:0] pp;
  reg [15:0] pp;
  
  always @(*) begin
    if (b[0] == 1'b1)
      pp = #1 a;
    else
      pp = #1 16'b0000000000000000;
  end
endmodule

// Determine if multiplication is complete
// Use declarative verilog only
// IMPORTANT: Do not change module or port names
module is_done (a, b, done);
  input [15:0] a; 
  input [7:0] b;
  output done;
  reg temp;
  
  always @(*) begin
    if (b == 8'b00000000)
       temp = 1'b1;
    else
       temp = 1'b0;
  end
  
  assign #4 done = temp;
endmodule

//a needs to be 15 bits
// combinational logic to generate next state
module nextstate (a, b, ao, bo); 
  input [15:0] a;
  input [7:0] b;
  output [15:0] ao;
  output [7:0] bo;
  
  shl #(16) s1(a, ao);
  shr #(8) s2(b, bo);
endmodule

// 8 bit unsigned multiply 
// Use structural verilog only
// IMPORTANT: Do not change module or port names
module multiply (clk, ain, bin, reset, prod, ready);
  //inputs, outputs, regs
  input clk;
  input [7:0] ain, bin;
  input reset;
  output [15:0] prod;
  output ready;
  
  wire [15:0] sum, partial, carry;
  wire [15:0] ain1;
  wire [15:0] anx;
  wire [7:0] bnx;
  wire [15:0] am; 
  wire [7:0] bm;
  wire [15:0] apv; 
  wire [7:0] bpv;
  
  //turn a into a 16 bit value
  assign ain1 [15:8] = 8'b00000000;
  assign ain1 [7:0] = ain;
  
  //state logic
  nextstate next(apv, bpv, anx, bnx); 
  
  //output logic
  is_done i(apv, bnx, ready);
  partial_product p(apv, bpv, partial);
  adder16 add(partial, sum, prod);
  
  //state registers
  mux2 #(16) m1(anx, ain1, reset, am);
  mux2 #(8) m2(bnx, bin, reset, bm);
  mux2 #(16) m3(prod, 16'b0000000000000000, reset, carry);
  dreg #(16) dr1(clk, am, apv);
  dreg #(8) dr2(clk, bm, bpv);
  dreg #(16) dr3(clk, carry, sum);
endmodule

// Clock generation.  Period set via parameter:
//   clock changes every half_period ticks
//   full clock period = 2*half_period
// Replace half_period parameter with desired value
module clock_gen(clk);
    parameter half_period = 1; // REPLACE half_period HERE
    output clk;
    reg    clk;

    initial clk = 0;
    always #half_period clk = ~clk;
endmodule