module alu32(alu_out,a,b,zout,alu_control);//ALU operation according to the ALU control line values
output [31:0] alu_out;
input [31:0] a,b; 
input [3:0] alu_control;//ALU control line
reg [31:0] alu_out;
reg [31:0] less;
output zout;
reg zout;
always @(a or b or alu_control)
begin
	case(alu_control)
	4'b0010: alu_out=a+b; 		//ALU control line=0010, ADD
	4'b0110: alu_out=a+1+(~b);	//ALU control line=0110, SUB
	4'b0111: begin less=a+1+(~b);	//ALU control line=0111, set on less than
			if (less[31]) alu_out=1;	
			else alu_out=0;
		  end
	4'b1001: begin	less = 1+(~a);//bgez  ALU control line = 1001
			if(less[31]) alu_out=0;
			else if (a == 0) alu_out = 0; 
			else alu_out=1;
		end
	4'b1000: begin 	less = 1+(~a);//bltz  ALU control line = 1000
			if(less[31]) alu_out=1;
			else if (a == 0) alu_out = 1; 
			else alu_out=0;
		end
	4'b1100: begin 	less = 1+(~a);//bgtz  ALU control line = 1100
			if(less[31]) alu_out=0;
			else if (a == 0) alu_out = 1; 
			else alu_out=1;
		end
	4'b0000: alu_out=a & b;	//ALU control line=0000, AND
	4'b0001: alu_out=a|b;		//ALU control line=0001, OR
	4'b0100: alu_out = ~(a|b);		// ALU control line = 0100 NOR
	default: alu_out=31'bx;	
	endcase
zout=~(|alu_out);
end
endmodule

