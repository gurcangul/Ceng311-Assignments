module control(in,in2,in3,regdest0,regdest1,jump,jreg,branchne,branchgtz,branchgez,branchltz,alusrc,memtoreg0,memtoreg1,regwrite,memread,memwrite,branch,aluop0,aluop1,aluop2,aluop3);
input [5:0] in,in2; // in2 instruction for jr control
input [4:0] in3; // in3 instruction for bgez and bltz rt control
output regdest0,regdest1,jump,jreg,branchne,branchgtz,branchgez,branchltz,alusrc,memtoreg0,memtoreg1,regwrite,memread,memwrite,branch,aluop0,aluop1,aluop2,aluop3;
wire rformat,lw,sw,beq,addi,andi,bne,j,jr,bgtz,bgez,bltz;
assign rformat=~|in;
assign addi=~in[5]& (~in[4])&(in[3])&(~in[2])&(~in[1])&(~in[0]);
assign andi=~in[5]& (~in[4])&(in[3])&(in[2])&(~in[1])&(~in[0]);
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);
assign bne=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&in[0];
assign bgtz=~in[5]& (~in[4])&(~in[3])&in[2]&in[1]&in[0];
assign bgez=((~in[5])&(~in[4])&(~in[3])&(~in[2])&(~in[1])&in[0])&((~in3[4])&(~in3[3])&(~in3[2])&(~in3[1])&in3[0]);
assign bltz=((~in[5])&(~in[4])&(~in[3])&(~in[2])&(~in[1])&in[0])&((~in3[4])&(~in3[3])&(~in3[2])&(~in3[1])&(~in3[0]));
assign j= ~in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&(~in[0]);
assign jr=(rformat & (~in2[5]& (~in2[4])&in2[3]&(~in2[2])&(~in2[1])&(~in2[0])));
assign jal = ~in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];
assign regdest0=jal;
assign regdest1=rformat&(~jr);
assign jump=j|jal;
assign jreg=jr;
assign memtoreg0 = jal;
assign memtoreg1=lw;
assign regwrite=(rformat&(~jr))|lw|addi|andi|jal;
assign memread=lw;
assign memwrite=sw;
assign branch=beq;
assign branchne=bne;
assign branchgtz=bgtz;
assign branchgez=bgez;
assign branchltz=bltz;
assign alusrc=lw|sw|addi|andi|bltz|bgtz|bgez;
assign aluop0=bltz|bgtz|bgez;
assign aluop1=addi|bgtz;
assign aluop2=rformat|andi|addi|jr;
assign aluop3=beq|bne|andi|bgez;
endmodule

