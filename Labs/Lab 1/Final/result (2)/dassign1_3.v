// EEM16 - Logic Design
// Design Assignment #1 - Problem #1.3
// dassign1_3.v
// Verilog template

// You may define any additional modules as necessary
// Do not change the module or port names of the given stubs

/* Arrays for convenience



  | GFEDCBA <-- display segment
__|________
a | 1110111
b | 1111100
c | 1011000
d | 1011110
e | 1111001
f | 1110001
g | 1101111
h | 1110110
i | 0000110
j | 0011110
k | 1111000
l | 0111000
m | 0010101
n | 1010100
o | 1011100
p | 1110011
q | 1100111
r | 1010000
s | 1101101
t | 1000110
u | 0111110
v | 0011100
w | 0101010
x | 1001001
y | 1101110
z | 1011011
^-- letter
*/

// Display driver (procedural verilog)
// IMPORTANT: Do not change module or port names
module display_rom (letter, display);
    input   [4:0] letter;
    output  [6:0] display;
 	 reg display;
    // do not use any delays!
  always @(letter)
  begin
    case(letter)
      0: display=7'b1110111;
      1: display=7'b1111100;
      2: display=7'b1011000;
      3: display=7'b1011110;
      4: display=7'b1111001;
      5: display=7'b1110001;
      6: display=7'b1101111;
      7: display=7'b1110110;
      8: display=7'b0000110;
      9: display=7'b0011110;
      10: display=7'b1111000;
      11: display=7'b0111000;
      12: display=7'b0010101;
      13: display=7'b1010100;
      14: display=7'b1011100;
      15: display=7'b1110011;
      16: display=7'b1100111;
      17: display=7'b1010000;
      18: display=7'b1101101;
      19: display=7'b1000110;
      20: display=7'b0111110;
      21: display=7'b0011100;
      22: display=7'b0101010;
      23: display=7'b1001001;
      24: display=7'b1101110;
      25: display=7'b1011011;
      default: display=7'b1000000;
    endcase
  end
endmodule

module mux8(bitsin, sel, out);
  input [7:0] bitsin; 
  input [2:0] sel;
  output out;
  
  reg out;
  
  always @(*)
    begin
      case(sel)
        0: out=bitsin[7];
        1: out=bitsin[6];
        2: out=bitsin[5];
        3: out=bitsin[4];
        4: out=bitsin[3];
        5: out=bitsin[2];
        6: out=bitsin[1];
        7: out=bitsin[0];
      endcase
    end
endmodule

module mux4(in, sel, out);
  input [3:0] in;
  input [1:0] sel;
  output out;
  reg out;
  always @(*)
    begin
      case(sel)
        0: out=in[3];
        1: out=in[2];
        2: out=in[1];
        3: out=in[0];
      endcase
    end
endmodule

module single_display(inwires, letter, out);
  input	[31:0] inwires;
  input	[4:0]  letter;
  output out;
  
  wire	l0, l1, l2, l3;
  
  mux8 mux8_1(inwires[31:24], letter[4:2], l0);
  mux8 mux8_2(inwires[23:16], letter[4:2], l1);
  mux8 mux8_3(inwires[15:8], letter[4:2], l2);
  mux8 mux8_4(inwires[7:0], letter[4:2], l3);
  
  mux4 mux4_1({l0, l1, l2, l3}, letter[1:0], out);
endmodule


/*
  | abcdefghijklmnopqrstuvwxyz  <-- letter
__|___________________________
G | 11111111001001111111000111
F | 11001111001100011010101010
E | 11111101011111110100110001
D | 01111010011100100010111111
C | 11010011110011101011110010
B | 10010011110000011001101011
A | 10001110000010011010000101
^-- display segment
~~~*/

// Display driver (declarative verilog)
// IMPORTANT: Do not change module or port names
module display_mux (letter, g,f,e,d,c,b,a);
  input   [4:0] letter;
  output  g,f,e,d,c,b,a;
  // do assign not use any delays!
  single_display am(32'b11011000010000100100100000010100, letter, a);
  single_display bm(32'b10101110001000100100010011011000, letter, b);
  single_display cm(32'b10111110101101000101100011001000, letter, c);
  single_display dm(32'b01000110101001101111110010100100, letter, d);
  single_display em(32'b11010100111111101011000011110000, letter, e);
  single_display fm(32'b11001110110000000110110001110000, letter, f);
  single_display gm(32'b11001011110110111111101111011111, letter, g);
endmodule
