module Synchronizer(clk, d,q);
input clk;
input [7:0] d;
output reg [7:0] q;
reg [7:0] d2;
always@(clk)
begin
    d2<=d;
	 q<=d2;

end
endmodule