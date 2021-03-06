module processor;
reg [31:0] pc; //32-bit program counter
reg clk; //clock
reg [7:0] datmem[0:31],mem[0:31]; //32-size data and instruction memory (8 bit(1 byte) for each location)
wire [31:0] 
dataa,	//Read data 1 output of Register File
datab,	//Read data 2 output of Register File
out2,		//Output of mux with ALUSrc control-mult2
out3,		//Output of mux with MemToReg control-mult3
out4,		//Output of mux with (Branch&ALUZero) control-mult4
out5,		// Output of mux with (Jump&out4) control-mult5
out6,		// Output of mux with jr control mult6
sum,		//ALU result
extad,	//Output of sign-extend unit
adder1out,	//Output of adder which adds PC and 4-add1
adder2out,	//Output of adder which adds PC+4 and 2 shifted sign-extend result-add2
sextad;	//Output of shift left 2 unit

wire [27:0] shleft1;	//Output of shift left 2 unit for jump instruction
wire [5:0] inst31_26, //31-26 bits of instruction
inst5_0;	// 5-0 bits of instruction
wire [4:0] 
inst25_21,	//25-21 bits of instruction
inst20_16,	//20-16 bits of instruction
inst15_11,	//15-11 bits of instruction
out1;		//Write data input of Register File

wire [15:0] inst15_0;	//15-0 bits of instruction

wire [31:0] instruc,	//current instruction
jumppc,	//Read the address that merge shleft1 and pc+4[31:28]
dpack;	//Read data output of memory (data read from memory)

wire [3:0] gout;	//Output of ALU control unit

wire zout,	//Zero output of ALU
pcsrc,	//Output of AND gate with Branch and ZeroOut inputs
pcsrc2,	// Output of And gate with Branch and negation Zero inputs
pcsrctotal, // Output of OR gate with pcsrc and pcsrc2
//Control signals
regdest0,regdest1,jump,jreg,branch,branchne,branchgtz,branchgez,branchltz,alusrc,aluop0,aluop1,aluop2,aluop3,memtoreg0,memtoreg1,regwrite,memread,memwrite;

//32-size register file (32 bit(1 word) for each register)
reg [31:0] registerfile[0:31];
integer i;
// datamemory connections

always @(posedge clk)
//write data to memory
if (memwrite)
begin 
//sum stores address,datab stores the value to be written
datmem[sum[4:0]+3]=datab[7:0];
datmem[sum[4:0]+2]=datab[15:8];
datmem[sum[4:0]+1]=datab[23:16];
datmem[sum[4:0]]=datab[31:24];
end

//instruction memory
//4-byte instruction
 assign instruc={mem[pc[4:0]],mem[pc[4:0]+1],mem[pc[4:0]+2],mem[pc[4:0]+3]};
 assign inst31_26=instruc[31:26];
 assign inst25_21=instruc[25:21];
 assign inst20_16=instruc[20:16];
 assign inst15_11=instruc[15:11];
 assign inst15_0=instruc[15:0];
 assign inst5_0=instruc[5:0];

// registers

assign dataa=registerfile[inst25_21];//Read register 1
assign datab=registerfile[inst20_16];//Read register 2
always @(posedge clk)
 registerfile[out1]= regwrite ? out3:registerfile[out1];//Write data to register

//read data from memory, sum stores address
assign dpack={datmem[sum[5:0]],datmem[sum[5:0]+1],datmem[sum[5:0]+2],datmem[sum[5:0]+3]}; //big endian format

// merge pc+4 and shleft1 wire
assign jumppc = {adder1out[31:28],shleft1[27:0]};

//multiplexers
//mux with RegDst control
mult4_to_1_5  mult1(out1, instruc[20:16],instruc[15:11],5'b11111,5'b00000,regdest0,regdest1);

//mux with ALUSrc control
mult2_to_1_32 mult2(out2, datab,extad,alusrc);

//mux with MemToReg control
mult4_to_1_32 mult3(out3, sum,dpack,adder1out,32'b00000000000000000000000000000000,memtoreg0,memtoreg1);

//mux with (Branch&ALUZero) control
mult2_to_1_32 mult4(out4, adder1out,adder2out,pcsrctotal);

//mux with (Jump&out4) control
mult2_to_1_32 mult5(out5,out4,jumppc,jump);

//mux with jr control
mult2_to_1_32 mult6(out6,out5,dataa,jreg);

// load pc
always @(posedge clk)

pc=out6;

// alu, adder and control logic connections

//ALU unit
alu32 alu1(sum,dataa,out2,zout,gout);

//adder which adds PC and 4
adder add1(pc,32'h4,adder1out);

//adder which adds PC+4 and 2 shifted sign-extend result
adder add2(adder1out,sextad,adder2out);

//Control unit
control cont(instruc[31:26],instruc[5:0],instruc[20:16],regdest0,regdest1,jump,jreg,branchne,branchgtz,branchgez,branchltz,
alusrc,memtoreg0,memtoreg1,regwrite,memread,memwrite,branch,aluop0,aluop1,aluop2,aluop3);

//Sign extend unit
signext sext(instruc[15:0],extad);

//ALU control unit
alucont acont(aluop0,aluop1,aluop2,aluop3,instruc[3],instruc[2], instruc[1], instruc[0] ,gout);

//Shift-left 2 unit
shift shift2(sextad,extad);

//Shift left 2 unit for jump
shift2 shift3(shleft1, instruc[25:0]);

//AND gate
assign pcsrc=branch && zout; 

//And Gate for bne zout
assign pcsrc2 = branchne && ~zout;

assign pcsrcbgtz = branchgtz && zout;

assign pcsrcbgez = branchgez && zout;

assign pcsrcbltz = branchltz && zout;

// Or Gate for bne zout
assign pcsrctotal = pcsrc | pcsrc2 |pcsrcbgtz |pcsrcbgez|pcsrcbltz ;

//initialize datamemory,instruction memory and registers
//read initial data from files given in hex
initial
begin
$readmemh("initDm.dat",datmem); //read Data Memory
$readmemh("initIM2.dat",mem);//read Instruction Memory
$readmemh("initReg.dat",registerfile);//read Register File

	for(i=0; i<31; i=i+1)
	$display("Instruction Memory[%0d]= %h  ",i,mem[i],"Data Memory[%0d]= %h   ",i,datmem[i],
	"Register[%0d]= %h",i,registerfile[i]);
end

initial
begin
pc=0;
#400 $finish;
	
end
initial
begin
clk=0;
//40 time unit for each cycle
forever #20  clk=~clk;
end
initial 
begin
  $monitor($time,"PC %h",pc,"  SUM %h",sum,"   INST %h",instruc[31:0],
"   REGISTER %h %h %h %h ",registerfile[4],registerfile[5], registerfile[6],registerfile[1] );
end
endmodule


