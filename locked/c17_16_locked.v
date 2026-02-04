/* 
  C17         : Rangkaian kombinasional sederhana
  Ninputs     : 5
  Noutputs    : 2
*/ 

module c17_locked(
    input I1,I2,I3,I4,I5,
    input clk, rst_n,
    input [15:0] static_key,
    input [15:0] correct_TK,
    input output_key_bit,
    output O1,O2
  );

  wire W1,W2,W3,W3_locked,W4,O1_locked;
  wire set;

  nonlinear_gen_16bit dylock (
    .clk(clk),
    .rst_n(rst_n),
    .K_16(static_key),
    .correct_TK(correct_TK),
    .set(set)
  );

  assign  W1 = ~(I1 & I3),
          W2 = ~(I3 & I4),
          W3 = ~(I2 & W2),
          W3_locked = W3 ^ (~set),
          W4 = ~(W2 & I5),
          O1_locked = ~(W1 & W3_locked),
          O1 = ~(O1_locked ^ output_key_bit),
          O2 = ~(W3_locked & W4);
endmodule

module nonlinear_gen (
  input   [3:0] K,
  output  [3:0] TK
  );
  
  assign TK[0] =  (K[3] & ~K[0]) | 
                  (K[1] & K[2] & K[3]) | 
                  (K[0] & K[2] & ~K[3]) | 
                  (K[3] & ~K[1] & ~K[2]);

  
  assign TK[1] =  (K[0] & K[2] & K[3]) | 
                  (K[0] & K[3] & ~K[1]) | 
                  (K[1] & ~K[0] & ~K[2]) | 
                  (K[1] & ~K[2] & K[3]) | 
                  (K[2] & ~K[0] & ~K[1]);

  assign TK[2] =  (K[0] & K[2] & K[3]) | 
                  (K[0] & ~K[1] & ~K[3]) | 
                  (K[1] & ~K[0] & ~K[3]) | 
                  (K[3] & ~K[0] & ~K[2]);

  assign TK[3] =  (K[0] & K[2] & ~K[1]) | 
                  (K[0] & K[3] & ~K[1]) | 
                  (K[1] & ~K[2] & ~K[0]) | 
                  (K[1] & ~K[3] & ~K[0]) | 
                  (K[0] & K[1] & ~K[2] & ~K[3]) | 
                  (~K[0] & ~K[1] & ~K[2] & ~K[3]);
endmodule

module nonlinear_gen_16bit (
  input clk, rst_n,
  input [15:0] K_16,
  input [15:0] correct_TK,
  output set
  );

  wire [15:0] TK_16;
  reg [3:0] count;

  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin : nonlinear_key_16bit_inst
      nonlinear_gen nonlinear_key_16bit (
        .K(K_16[(i*4)+3 : i*4]),     // K_16[3:0], K_16[7:4], K_16[11:8], K_16[15:12]
        .TK(TK_16[(i*4)+3 : i*4])    // TK_16[3:0], TK_16[7:4], TK_16[11:8], TK_16[15:12]
      );
    end
  endgenerate

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= 4'b0000;
    end 
    else begin
      if (TK_16 == correct_TK) begin
        count <= count + 1'b1;
      end
      else begin
        count <= 4'b0000;
      end    
    end
  end
endmodule