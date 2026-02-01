/* 
  c432        : 27-channel interrupt controller
  Ninputs     : 36
  Noutputs    : 7
*/


module c432 (
  input in1, in2, in3, in4, in5, in6, in7, in8, in9,           // E Group
  input in10, in11, in12, in13, in14, in15, in16, in17, in18,  // A Group
  input in19, in20, in21, in22, in23, in24, in25, in26, in27,  // B Group
  input in28, in29, in30, in31, in32, in33, in34, in35, in36,  // C Group
  output out1, out2, out3,                                     // Status PA, PB, PC
  output out4, out5, out6, out7                                // Channel Bits
);

  wire [8:0] A, B, C, E;
  wire PA, PB, PC;
  wire [3:0] Chan;
  
  assign
  E[8:0] = { in1, in2, in3, in4, in5, in6, in7, in8, in9 },
  A[8:0] = { in10, in11, in12, in13, in14, in15, in16, in17, in18 },
  B[8:0] = { in19, in20, in21, in22, in23, in24, in25, in26, in27 },
  C[8:0] = { in28, in29, in30, in31, in32, in33, in34, in35, in36 },
  out1 = PA,
  out2 = PB,
  out3 = PC,
  { out4, out5, out6, out7 } = Chan[3:0];
	
  TopLevel432 circuit432 (E, A, B, C, PA, PB, PC, Chan);
endmodule

module TopLevel432 (E, A, B, C, PA, PB, PC, Chan);
    input[8:0] E, A, B, C;
    output PA, PB, PC;
    output[3:0] Chan;
    wire[8:0] X1, X2, I;

    PriorityA  M1(E, A, PA, X1);
    PriorityB  M2(E, X1, B, PB, X2);
    PriorityC  M3(E, X1, X2, C, PC);
    EncodeChan M4(E, A, B, C, PA, PB, PC, I);
    DecodeChan M5(I, Chan);
endmodule

module PriorityA(input[8:0] E, A, output PA, output[8:0] X1);
  wire [8:0] Anot = ~A;
  wire [8:0] Anot_E = ~(Anot & E);
  assign PA = ~&Anot_E;
  assign X1 = Anot_E ^ {9{PA}};
endmodule

module PriorityB(input[8:0] E, X1, B, output PB, output[8:0] X2);
  wire [8:0] Enot = ~E;
  wire [8:0] Enot_B = ~(Enot | B);
  wire [8:0] X1_Enot_B = ~(X1 & Enot_B);
  assign PB = ~&X1_Enot_B;
  assign X2 = X1_Enot_B ^ {9{PB}};
endmodule

module PriorityC(input[8:0] E, X1, X2, C, output PC);
  wire [8:0] Enot = ~E;
  wire [8:0] Enot_C = ~(Enot | C);
  wire [8:0] X1_X2_Enot_C = ~(X1 & X2 & Enot_C);
  assign PC = ~&X1_X2_Enot_C;
endmodule

module EncodeChan(input[8:0] E, A, B, C, input PA, PB, PC, output[8:0] I);
  wire [8:0] APA = ~(A & {9{PA}});
  wire [8:0] BPB = ~(B & {9{PB}});
  wire [8:0] CPC = ~(C & {9{PC}});
  assign I = ~(E & APA & BPB & CPC);
endmodule

module DecodeChan(input[8:0] I, output[3:0] Chan);
  wire Iand = &I[7:0];
  assign Chan[3] = ~(~I[8] | Iand);
  
  wire I1not = ~I[1], I2not = ~I[2], I3not = ~I[3], I5not = ~I[5];
  wire I5not_I6 = ~(I5not & I[6]);
  wire I2not_I4_I5 = ~(I2not & I[4] & I[5]);
  wire I3not_I4_I5_I6 = ~(I3not & I[4] & I[5] & I[6]);
  wire I1not_I2_I5_I6 = ~(I1not & I[2] & I[5] & I[6]);

  assign Chan[2] = ~(I[4] & I[6] & I[7] & I5not_I6);
  assign Chan[1] = ~(I[6] & I[7] & I2not_I4_I5 & I3not_I4_I5_I6);
  assign Chan[0] = ~(I[7] & I5not_I6 & I1not_I2_I5_I6 & I3not_I4_I5_I6);
endmodule