module BinarytoGray(a,b);
input [3:0] a;
output [3:0] b;
assign b=a^{1'b0,a[3:1]};

endmodule