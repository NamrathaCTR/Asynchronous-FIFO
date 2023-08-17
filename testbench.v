`timescale 10ns/1ps
module testbench;
reg rclk=1'b0;
reg wclk=1'b0;
reg wrst,rrst,winc,rinc;
reg [7:0] writeData;
wire full,empty;
wire [7:0] readData;

 AFIFO dut(rclk,wclk,wrst,rrst,winc,rinc,writeData,readData,full,empty);
 
 always rclk= # 7 ~rclk;
 
 always wclk= #5 ~wclk;
 
 initial
 begin
 
 #14 wrst=1'b1; rrst=1'b1;
 #12 writeData=8'h12;wrst=1'b0; rrst=1'b0;winc=1'b1;rinc=1'b1;
 #12 writeData=8'h13;
  #12 writeData=8'h14;

   #12 writeData=8'h15;

	 #12 writeData=8'h21;

	  #12 writeData=8'h22;

	   #12 writeData=8'h23;
 #12 writeData=8'h24;
 #12 writeData=8'h25;
 #12 writeData=8'h26;
 #12 writeData=8'h27;
 #12 writeData=8'h28;
 #12 writeData=8'h29;
 #12 writeData=8'h30;
# 200   $finish;
 end

endmodule