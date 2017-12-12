// EEM16 - Logic Design
// Design Assignment #1 - Problem #1.1
// dassign1_1.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// CMOS gates (declarative Verilog)
// Includes propagation delay t_PD = 1
module inverter(a,y);
    input a;
    output y;

    assign #1 y = ~a;
endmodule

module fa_gate_1(a,b,c,y);
    input a,b,c;
    output y;

    assign #1 y = ~((a&b) | (c&(b|a)));
endmodule

module fa_gate_2(a,b,c,m,y);
    input a,b,c,m;
    output y;

    assign #1 y = ~((a&b&c) | ((a|b|c)&m));
endmodule

// Full adder (structural Verilog)
module fa(a,b,ci,co,s);
    input a,b,ci;
    output s,co;

    wire nco, ns;

    fa_gate_1   fa_gate_1_1(a,b,ci, nco);
    fa_gate_2   fa_gate_2_1(a,b,ci,nco, ns);
    inverter    inverter_1(nco, co); 
    inverter    inverter_2(ns, s);
endmodule

// 5+2 input full adder (structural Verilog)
// IMPORTANT: Do not change module or port names
module fa5 (a,b,c,d,e,ci0,ci1, 
            co1,co0,s);

  input a,b,c,d,e,ci0,ci1;
  output co1, co0, s;
  // do not use any delays!
  fa add1(.a(a),.b(b),.ci(ci0),.co(c0),.s(s0));
  fa add2(.a(c),.b(d),.ci(ci1),.co(c1),.s(s1));
  fa add3(.a(s0),.b(s1),.ci(e),.co(c2),.s(s));
  fa add4(.a(c0),.b(c1),.ci(c2),.co(co1),.s(co0));
endmodule

// 5-input 4-bit ripple-carry adder (structural Verilog)
// IMPORTANT: Do not change module or port names
module adder5 (a,b,c,d,e, sum);
  input [3:0] a,b,c,d,e;
  output [6:0] sum;
  // do not use any delays!
  fa5 five1(.a(a[0]),.b(b[0]),.c(c[0]),.d(d[0]),.e(e[0]),.ci0(0),.ci1(0),.co1(c2),.co0(c1),.s(sum[0]));
  fa5 five2(.a(a[1]),.b(b[1]),.c(c[1]),.d(d[1]),.e(e[1]),.ci0(c1),.ci1(0),.co1(c4),.co0(c3),.s(sum[1]));
  fa5 five3(.a(a[2]),.b(b[2]),.c(c[2]),.d(d[2]),.e(e[2]),.ci0(c3),.ci1(c2),.co1(c6),.co0(c5),.s(sum[2]));
  fa5 five4(.a(a[3]),.b(b[3]),.c(c[3]),.d(d[3]),.e(e[3]),.ci0(c5),.ci1(c4),.co1(c8),.co0(c7),.s(sum[3]));
  fa add1(.a(c7),.b(c6),.ci(0),.co(c9),.s(sum[4]));
  fa add2(.a(c8),.b(c9),.ci(0),.co(sum[6]),.s(sum[5]));
endmodule
