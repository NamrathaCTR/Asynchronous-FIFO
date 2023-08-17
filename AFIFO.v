module AFIFO(rclk,wclk,wrst,rrst,winc,rinc,writeData,readData,full,empty);
input rclk,wclk,wrst,rrst,winc,rinc;
input [7:0] writeData;
`timescale 10ns/1ps
output  full,empty;
output [7:0] readData;
wire wclken;
wire [3:0] readPointer,writePointer;

wire [2:0] waddr;
wire [2:0] raddr;

wire [3:0] readPointerSyncGray,writePointerSyncGray;
wire [3:0] readPointerSync,writePointerSync;
reg [15:0] FIFO [7:0];


writeModule wM(winc,wclk,wrst,readPointerSync,waddr,writePointer,full);

readModule rM(rinc,rclk,rrst,writePointerSync,raddr,readPointer,empty);

Synchronizer S1(rclk,writePointer ,writePointerSyncGray);
Synchronizer S2(wclk,readPointer ,readPointerSyncGray);



GraytoBinary gb1(writePointerSyncGray,writePointerSync);
GraytoBinary gb2(readPointerSyncGray,readPointerSync);



assign readData=FIFO[raddr];
assign wclken=winc & (!full);
always@(posedge wclk)
begin
if(wclken)
FIFO[waddr]=writeData;

end


endmodule




///////////////////////// write////////////////////////////

module writeModule(winc,wclk,wrst,readPointerSync,waddr,writePointer,full);
input winc;
input wclk;
input wrst;
input [3:0] readPointerSync;
output [2:0] waddr;
output reg [3:0]  writePointer;
output reg full;
reg [3:0] writePointerB;
reg [3:0]  writePointerBnext;
wire [3:0]  writePointerGraynext;

assign waddr=writePointerB[2:0];



/////////////////////////// generating full ////////////////////////

always@(posedge wclk,posedge wrst)
begin
if(wrst)
full=1'b0;

else if((writePointerBnext[3]!=readPointerSync[3]) && (writePointerBnext[2:0]==readPointerSync[2:0]))
full=1'b1;
else
full=1'b0;
end



////////////////////// incrementing pointer ///////////////////////

always@(winc,full,writePointerB)
begin
if(winc && !full)
writePointerBnext=writePointerB+1'b1;


end

BinarytoGray bg2(writePointerBnext,writePointerGraynext);



/////////////////////// flip flops//////////////////////////////

always@(posedge wclk or posedge wrst)
begin
if(wrst)
begin
writePointerB=4'b0;
writePointer=4'b0;
end
else 
begin
writePointerB<=writePointerBnext;
writePointer<=writePointerGraynext;
end


end

endmodule

















/////////////// Read ////////////////////////////////////////////



module readModule(rinc,rclk,rrst,writePointerSync,raddr,readPointer,empty);
input rinc;
input rclk;
input rrst;
input [3:0]  writePointerSync;
output [2:0] raddr;
output reg [3:0]  readPointer;
output reg  empty;
reg [3:0]  readPointerB;
reg [3:0]  readPointerBnext=4'b0;
wire [3:0]  readPointerGraynext;

assign raddr=readPointerB[2:0];



/////////////////////////// generating empty ////////////////////////

always@(posedge rclk or posedge rrst)
begin
if(rrst)
empty=1'b1;
else if((readPointerBnext[3:0]==writePointerSync[3:0]))
empty=1'b1;
else
empty=1'b0;
end



////////////////////// incrementing pointer ///////////////////////

always@(rinc,empty,readPointerB)
begin
if(rinc && !empty)
readPointerBnext=readPointerB+1'b1;



end
BinarytoGray bg1(readPointerBnext,readPointerGraynext);




/////////////////////// flip flops//////////////////////////////

always@(posedge rclk or posedge rrst)
begin
if(rrst)
begin
readPointerB=4'b0;

readPointer=4'b0;
end
else 
begin
readPointerB<=readPointerBnext;
readPointer<=readPointerGraynext;
end


end

endmodule