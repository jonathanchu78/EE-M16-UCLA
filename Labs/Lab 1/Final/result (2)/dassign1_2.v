// EEM16 - Logic Design
// Design Assignment #1 - Problem #1.2
// dassign1_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not change the module or port names of these stubs

// Max/argmax (declarative verilog)
// IMPORTANT: Do not change module or port names
module mam (in1_value, in1_label, in2_value, in2_label, out_value, out_label);
    input   [7:0] in1_value, in2_value;
    input   [4:0] in1_label, in2_label;
    output  [7:0] out_value;
    output  [4:0] out_label;
  
    // do not use any delays!
  	assign out_value = in1_value < in2_value ? in2_value : in1_value;
  	assign out_label = in1_value < in2_value ? in2_label : in1_label;
endmodule

module doublemam(v1, l1, v2, l2, v3, l3, v4, l4, v_o, l_o);
  input [7:0] v1, v2, v3, v4;
  input [4:0] l1, l2, l3, l4;
  output [7:0] v_o;
  output [4:0] l_o;
  
  wire [7:0] vv1, vv2;
  wire [4:0] ll1, ll2;
  
  mam first(v1, l1, v2, l2, vv1, ll1);
  mam second(v3, l3, v4, l4, vv2, ll2);
  
  mam third(vv1, ll1, vv2, ll2, v_o, l_o);
endmodule

module mamout (in1_value, in1_label, in2_value, in2_label, out_label);
    input   [7:0] in1_value, in2_value;
    input   [4:0] in1_label, in2_label;
    output  [4:0] out_label;
    // your code here
    // do not use any delays!
  
  assign out_label = in2_value < in1_value ? in1_label : in2_label;
  
endmodule

// Maximum index (structural verilog)
// IMPORTANT: Do not change module or port names
module maxindex(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,out);
    input [7:0] a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z;
    output [4:0] out;
  /*
  wire [7:0] v_ad, v_eh, v_il, v_mp, v_qt, v_ux, v_ap, v_ax, v_yz, v_az;
  wire [4:0] l_ad, l_eh, l_il, l_mp, l_qt, l_ux, l_ap, l_ax, l_yz;
  doublemam cmp1(a, 5'b00000, b, 5'b00001, c, 5'b00010, d, 5'b00011, v_ad, l_ad);
  doublemam cmp2(e, 5'b00100, f, 5'b00101, g, 5'b00110, h, 5'b00111, v_eh, l_eh);
  doublemam cmp3(i, 5'b01000, j, 5'b01001, k, 5'b01010, l, 5'b01011, v_il, l_il);
  doublemam cmp4(m, 5'b01100, n, 5'b01101, o, 5'b01110, p, 5'b01111, v_mp, l_mp);
  doublemam cmp5(q, 5'b10000, r, 5'b10001, s, 5'b10010, t, 5'b10011, v_qt, l_qt);
  doublemam cmp6(u, 5'b10100, v, 5'b10101, w, 5'b10110, x, 5'b10111, v_ux, l_ux);
  mam cmp7(y, 5'b11000, z, 5'b11001, v_yz, l_yz);
  
  doublemam cmpp1(v_ad, l_ad, v_eh, l_eh, v_il, l_il, v_mp, l_mp, v_ap, l_ap);
  
  mam cmppp1(v_ap, l_ap, v_ux, l_ux, v_ax, l_ax);
  
  mam cmpppp1(v_ax, l_ax, v_yz, l_yz, v_az, out);*/
  
  
  
  wire [7:0] v0, v1, v2, v3, v4, v5, v6, v7;
  wire [4:0] l0, l1, l2, l3, l4, l5, l6, l7;
  
  doublemam cmp1(a, 5'b0, b, 5'b1, c, 5'b10, d, 5'b11, v0, l0);
  doublemam cmp2(e, 5'b100, f, 5'b101, g, 5'b110, h, 5'b111, v1, l1);
  doublemam cmp3(i, 5'b1000, j, 5'b1001, k, 5'b1010, l, 5'b1011, v2, l2);
  doublemam cmp4(m, 5'b1100, n, 5'b1101, o, 5'b1110, p, 5'b1111, v3, l3);
  doublemam cmp5(q, 5'b10000, r, 5'b10001, s, 5'b10010, t, 5'b10011, v4, l4);
  doublemam cmp6(u, 5'b10100, v, 5'b10101, w, 5'b10110, x, 5'b10111, v5, l5);
  
  doublemam cmp7(v0, l0, v1, l1, v2, l2, v3, l3, v6, l6);
  doublemam cmp8(v4, l4, v5, l5, y, 5'b11000, z, 5'b11001, v7, l7);
  
  mamout cmp9(v6, l6, v7, l7, out);
endmodule
