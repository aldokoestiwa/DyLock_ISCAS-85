module c499 (
  input in1, in2, in3, in4, in5, in6, in7, in8, in9,
        in10, in11, in12, in13, in14, in15, in16, in17,
        in18, in19, in20, in21, in22, in23, in24, in25,
        in26, in27, in28, in29, in30, in31, in32, in33,
        in34, in35, in36, in37, in38, in39, in40, in41,
  output  out1, out2, out3, out4, out5, out6, out7, out8,
          out9, out10, out11, out12, out13, out14, out15, out16,
          out17, out18, out19, out20, out21, out22, out23, out24,
          out25, out26, out27, out28, out29, out30, out31, out32
  );

  wire [0:31] ID, OD; // Input Data (ID) , Output Data (OD)
  wire [0:7]  IC;     // Input Check (IC)
  wire        R;      // Redundancy (R)

  // Mapping Input
  assign ID[0:31] = { in1, in2, in3, in4, in5, in6, in7, in8, 
                      in9, in10, in11, in12, in13, in14, in15, in16,
                      in17, in18, in19, in20, in21, in22, in23, in24,
                      in25, in26, in27, in28, in29, in30, in31, in32 };
  assign IC[0:7]  = { in33, in34, in35, in36, in37, in38, in39, in40 };
  assign R        = in41;

  // Mapping Output
  assign { out1, out2, out3, out4, out5, out6, out7, out8,
           out9, out10, out11, out12, out13, out14, out15, out16,
           out17, out18, out19, out20, out21, out22, out23, out24,
           out25, out26, out27, out28, out29, out30, out31, out32 } = OD[0:31];

  // Instansiasi Logika Utama
  TopLevel499b Ckt499b (ID, IC, R, OD);
endmodule

module  TopLevel499b (ID, IC, R, OD);
  input[0:31]   ID;
  input[0:7]    IC;
  input          R;
  output[0:31]  OD;

  wire[0:7]      S;

  Syndrome M1(S, R, IC, ID);
  Correction M2(OD, S, ID);
endmodule 

module Syndrome (S, R, IC, ID);
  input[0:31]   ID;
  input[0:7]    IC;
  input         R;
  output[0:7]   S;
  
  assign S[0] = (ID[0] ^ ID[4] ^ ID[8] ^ ID[12]) ^ 
                (ID[16] ^ ID[17] ^ ID[18] ^ ID[19]) ^
                (ID[20] ^ ID[21] ^ ID[22] ^ ID[23]) ^
                (R & IC[0]);
  assign S[1] = (ID[1] ^ ID[5] ^ ID[9] ^ ID[13]) ^ 
                (ID[24] ^ ID[25] ^ ID[26] ^ ID[27]) ^
                (ID[28] ^ ID[29] ^ ID[30] ^ ID[31]) ^
                (R & IC[1]);
  assign S[2] = (ID[2] ^ ID[6] ^ ID[10] ^ ID[14]) ^ 
                (ID[16] ^ ID[17] ^ ID[18] ^ ID[19]) ^
                (ID[24] ^ ID[25] ^ ID[26] ^ ID[27]) ^
                (R & IC[2]);
  assign S[3] = (ID[3] ^ ID[7] ^ ID[11] ^ ID[15]) ^ 
                (ID[20] ^ ID[21] ^ ID[22] ^ ID[23]) ^
                (ID[28] ^ ID[29] ^ ID[30] ^ ID[31]) ^
                (R & IC[3]);
  assign S[4] = (ID[16] ^ ID[20] ^ ID[24] ^ ID[28]) ^ 
                (ID[0] ^ ID[1] ^ ID[2] ^ ID[3]) ^
                (ID[4] ^ ID[5] ^ ID[6] ^ ID[7]) ^
                (R & IC[4]);
  assign S[5] = (ID[17] ^ ID[21] ^ ID[25] ^ ID[29]) ^ 
                (ID[8] ^ ID[9] ^ ID[10] ^ ID[11]) ^
                (ID[12] ^ ID[13] ^ ID[14] ^ ID[15]) ^
                (R & IC[5]);
  assign S[6] = (ID[18] ^ ID[22] ^ ID[26] ^ ID[30]) ^ 
                (ID[0] ^ ID[1] ^ ID[2] ^ ID[3]) ^
                (ID[8] ^ ID[9] ^ ID[10] ^ ID[11]) ^
                (R & IC[6]);
  assign S[7] = (ID[19] ^ ID[23] ^ ID[27] ^ ID[31]) ^ 
                (ID[4] ^ ID[5] ^ ID[6] ^ ID[7]) ^
                (ID[12] ^ ID[13] ^ ID[14] ^ ID[15]) ^
                (R & IC[7]);
endmodule 

module Correction (OD, S, ID);

  input[0:31]   ID;
  input[0:7]    S;
  output[0:31]  OD;

  assign OD[0] = (S[0] & ~S[1] & ~S[2] & ~S[3] & S[4] & ~S[5] & S[6] & ~S[7]) ^ ID[0];
  assign OD[1] = (~S[0] & S[1] & ~S[2] & ~S[3] & S[4] & ~S[5] & S[6] & ~S[7]) ^ ID[1];
  assign OD[2] = (~S[0] & ~S[1] & S[2] & ~S[3] & S[4] & ~S[5] & S[6] & ~S[7]) ^ ID[2];
  assign OD[3] = (~S[0] & ~S[1] & ~S[2] & S[3] & S[4] & ~S[5] & S[6] & ~S[7]) ^ ID[3];
  assign OD[4] = (S[0] & ~S[1] & ~S[2] & ~S[3] & S[4] & ~S[5] & ~S[6] & S[7]) ^ ID[4];
  assign OD[5] = (~S[0] & S[1] & ~S[2] & ~S[3] & S[4] & ~S[5] & ~S[6] & S[7]) ^ ID[5];
  assign OD[6] = (~S[0] & ~S[1] & S[2] & ~S[3] & S[4] & ~S[5] & ~S[6] & S[7]) ^ ID[6];
  assign OD[7] = (~S[0] & ~S[1] & ~S[2] & S[3] & S[4] & ~S[5] & ~S[6] & S[7]) ^ ID[7];
  assign OD[8] = (S[0] & ~S[1] & ~S[2] & ~S[3] & ~S[4] & S[5] & S[6] & ~S[7]) ^ ID[8];
  assign OD[9] = (~S[0] & S[1] & ~S[2] & ~S[3] & ~S[4] & S[5] & S[6] & ~S[7]) ^ ID[9];
  assign OD[10] = (~S[0] & ~S[1] & S[2] & ~S[3] & ~S[4] & S[5] & S[6] & ~S[7]) ^ ID[10];
  assign OD[11] = (~S[0] & ~S[1] & ~S[2] & S[3] & ~S[4] & S[5] & S[6] & ~S[7]) ^ ID[11];
  assign OD[12] = (S[0] & ~S[1] & ~S[2] & ~S[3] & ~S[4] & S[5] & ~S[6] & S[7]) ^ ID[12];
  assign OD[13] = (~S[0] & S[1] & ~S[2] & ~S[3] & ~S[4] & S[5] & ~S[6] & S[7]) ^ ID[13];
  assign OD[14] = (~S[0] & ~S[1] & S[2] & ~S[3] & ~S[4] & S[5] & ~S[6] & S[7]) ^ ID[14];
  assign OD[15] = (~S[0] & ~S[1] & ~S[2] & S[3] & ~S[4] & S[5] & ~S[6] & S[7]) ^ ID[15];
  assign OD[16] = (S[4] & ~S[5] & ~S[6] & ~S[7] & S[0] & ~S[1] & S[2] & ~S[3]) ^ ID[16];
  assign OD[17] = (~S[4] & S[5] & ~S[6] & ~S[7] & S[0] & ~S[1] & S[2] & ~S[3]) ^ ID[17];
  assign OD[18] = (~S[4] & ~S[5] & S[6] & ~S[7] & S[0] & ~S[1] & S[2] & ~S[3]) ^ ID[18];
  assign OD[19] = (~S[4] & ~S[5] & ~S[6] & S[7] & S[0] & ~S[1] & S[2] & ~S[3]) ^ ID[19];
  assign OD[20] = (S[4] & ~S[5] & ~S[6] & ~S[7] & S[0] & ~S[1] & ~S[2] & S[3]) ^ ID[20];
  assign OD[21] = (~S[4] & S[5] & ~S[6] & ~S[7] & S[0] & ~S[1] & ~S[2] & S[3]) ^ ID[21];
  assign OD[22] = (~S[4] & ~S[5] & S[6] & ~S[7] & S[0] & ~S[1] & ~S[2] & S[3]) ^ ID[22];
  assign OD[23] = (~S[4] & ~S[5] & ~S[6] & S[7] & S[0] & ~S[1] & ~S[2] & S[3]) ^ ID[23];
  assign OD[24] = (S[4] & ~S[5] & ~S[6] & ~S[7] & ~S[0] & S[1] & S[2] & ~S[3]) ^ ID[24];
  assign OD[25] = (~S[4] & S[5] & ~S[6] & ~S[7] & ~S[0] & S[1] & S[2] & ~S[3]) ^ ID[25];
  assign OD[26] = (~S[4] & ~S[5] & S[6] & ~S[7] & ~S[0] & S[1] & S[2] & ~S[3]) ^ ID[26];
  assign OD[27] = (~S[4] & ~S[5] & ~S[6] & S[7] & ~S[0] & S[1] & S[2] & ~S[3]) ^ ID[27];
  assign OD[28] = (S[4] & ~S[5] & ~S[6] & ~S[7] & ~S[0] & S[1] & ~S[2] & S[3]) ^ ID[28];
  assign OD[29] = (~S[4] & S[5] & ~S[6] & ~S[7] & ~S[0] & S[1] & ~S[2] & S[3]) ^ ID[29];
  assign OD[30] = (~S[4] & ~S[5] & S[6] & ~S[7] & ~S[0] & S[1] & ~S[2] & S[3]) ^ ID[30];
  assign OD[31] = (~S[4] & ~S[5] & ~S[6] & S[7] & ~S[0] & S[1] & ~S[2] & S[3]) ^ ID[31];
endmodule 
