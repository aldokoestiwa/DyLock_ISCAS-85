module c17_tb();
  reg I1, I2, I3, I4, I5;
  wire O1, O2;
  integer i;

  c17 uut (
  .I1(I1), 
  .I2(I2), 
  .I3(I3), 
  .I4(I4), 
  .I5(I5), 
  .O1(O1), 
  .O2(O2)
  );

  initial begin
    $display("Time I1 I2 I3 I4 I5 | O1 O2");
    $display("-------------------------------");
    
    {I1, I2, I3, I4, I5} = 5'b00000;

    for (i=0; i<32; i++) begin
      {I1, I2, I3, I4, I5} = i; 
      #10;
      $display("%4t\t %b  %b  %b  %b  %b |  %b  %b", $time, I1, I2, I3, I4, I5, O1, O2);
    end

    #10;
  end
endmodule