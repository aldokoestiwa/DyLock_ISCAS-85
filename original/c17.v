/* 
  C17         : Rangkaian kombinasional sederhana
  Ninputs     : 5
  Noutputs    : 2
*/ 

module c17(
    input I1,I2,I3,I4,I5,
    output O1,O2 
  );

  wire W1,W2,W3,W4;

  assign  W1 = ~(I1 & I3),
          W2 = ~(I3 & I4),
          W3 = ~(I2 & W2),
          W4 = ~(W2 & I5),
          O1 = ~(W1 & W3),
          O2 = ~(W3 & W4);
endmodule

