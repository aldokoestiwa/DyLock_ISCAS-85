`timescale 1ns / 1ps

module tb_c432();

    // Register untuk menampung input (Total 36 bit)
    reg [35:0] test_vector;
    
    // Wire untuk memantau output
    wire out1, out2, out3;
    wire out4, out5, out6, out7;

    // Instansiasi Unit Under Test (UUT)
    // Menghubungkan test_vector ke input in1-in36 secara urut
    c432 uut (
        .in1(test_vector[35]), .in2(test_vector[34]), .in3(test_vector[33]), 
        .in4(test_vector[32]), .in5(test_vector[31]), .in6(test_vector[30]), 
        .in7(test_vector[29]), .in8(test_vector[28]), .in9(test_vector[27]),
        .in10(test_vector[26]), .in11(test_vector[25]), .in12(test_vector[24]), 
        .in13(test_vector[23]), .in14(test_vector[22]), .in15(test_vector[21]), 
        .in16(test_vector[20]), .in17(test_vector[19]), .in18(test_vector[18]),
        .in19(test_vector[17]), .in20(test_vector[16]), .in21(test_vector[15]), 
        .in22(test_vector[14]), .in23(test_vector[13]), .in24(test_vector[12]), 
        .in25(test_vector[11]), .in26(test_vector[10]), .in27(test_vector[9]),
        .in28(test_vector[8]),  .in29(test_vector[7]),  .in30(test_vector[6]), 
        .in31(test_vector[5]),  .in32(test_vector[4]),  .in33(test_vector[3]), 
        .in34(test_vector[2]),  .in35(test_vector[1]),  .in36(test_vector[0]),
        .out1(out1), .out2(out2), .out3(out3),
        .out4(out4), .out5(out5), .out6(out6), .out7(out7)
    );

    initial begin
        // --- Skenario 1: Tidak ada interupsi (Input semua 0) ---
        test_vector = 36'h0;
        #10;
        $display("T=%0t | E=0, A=0, B=0, C=0 | Status: PA=%b PB=%b PC=%b | Chan: %b%b%b%b", 
                 $time, out1, out2, out3, out4, out5, out6, out7);

        // --- Skenario 2: Enable Aktif (Grup E), tapi tidak ada request ---
        // E[8:0] = in1-in9 (bit 35-27)
        test_vector = 36'b111111111_000000000_000000000_000000000;
        #10;
        
        // --- Skenario 3: Interupsi pada Grup A (bit 26-18) ---
        // Mengaktifkan salah satu bit di Grup A
        test_vector[26:18] = 9'b100000000; 
        #10;
        $display("T=%0t | Interupsi Grup A Aktif! | PA=%b PB=%b PC=%b | Chan: %b%b%b%b", 
                 $time, out1, out2, out3, out4, out5, out6, out7);

        // --- Skenario 4: Interupsi Grup B lebih diprioritaskan ---
        // (Tergantung logika internal c432 untuk prioritas grup)
        test_vector[17:9] = 9'b010000000;
        #10;
        $display("T=%0t | Interupsi Grup B Aktif! | PA=%b PB=%b PC=%b | Chan: %b%b%b%b", 
                 $time, out1, out2, out3, out4, out5, out6, out7);

        // --- Skenario 5: Interupsi Semua Grup Aktif ---
        test_vector = 36'hFFFFFFFFF;
        #10;
        $display("T=%0t | Semua Aktif | PA=%b PB=%b PC=%b | Chan: %b%b%b%b", 
                 $time, out1, out2, out3, out4, out5, out6, out7);

        #10 $finish;
    end

endmodule