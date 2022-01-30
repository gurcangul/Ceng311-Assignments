module alucont(aluop0,aluop1,aluop2,aluop3,f3,f2,f1,f0,gout);//Figure 4.12 
input aluop0,aluop1,aluop2,aluop3,f3,f2,f1,f0;
output [3:0] gout;
reg [3:0] gout;
always @(aluop0 or aluop1 or aluop2 or aluop3 or f3 or f2 or f1 or f0)
begin
if((~aluop0)&(~aluop1)&aluop2&aluop3) gout=4'b0000;	//andi aluop = 0011, control = 0000
if((~aluop0)& aluop1&aluop2&(~aluop3)) gout=4'b0010;	//addi aluop=0110, control=0010
if(aluop0&(~aluop1)&(~aluop2)&(~aluop3)) gout=4'b1000;	//bltz aluop=1000, control=1000
if(aluop0&(aluop1)&(~aluop2)&(~aluop3)) gout=4'b1100;	//bgtz aluop= 1100, control = 1100
if((aluop0)&(~aluop1)&(~aluop2)&(aluop3)) gout=4'b1001;	//bgez aluop= 1001, control = 1001

if((~aluop0)&(~aluop1)&(~aluop2)&aluop3)gout=4'b0110; //beq and bne aluop = 0001, control=0110 (sub)
if((~aluop0)&(~aluop1)&aluop2&(~aluop3))//R-type
begin
	if (~(f3|f2|f1|f0))gout=4'b0010; 	//function code=0000,ALU control=0010 (add)
	if (f1&f3)gout=4'b0111;			//function code=1x1x,ALU control=0111 (set on less than)
	if (f1&~(f3))gout=4'b0110;		//function code=0x10,ALU control=0110 (sub)
	if (f2&f0)gout=4'b0001;			//function code=x1x1,ALU control=00001 (or)
	if (f2&~(f0))gout=4'b0000;		//function code=x1x0,ALU control=0000 (and)
	if (f2&f1&f0) gout=4'b0100;		// function code = x111, ALU control = 0100 (nor)
end
end
endmodule

