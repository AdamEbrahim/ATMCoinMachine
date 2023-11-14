module mux_8 #(parameter WIDTH=1)(out, select, in0, in1, in2, in3, in4, in5, in6, in7); 
    input [2:0] select;
    input [WIDTH-1:0] in0, in1, in2, in3, in4, in5, in6, in7;
    output [WIDTH-1:0] out;
    wire [WIDTH-1:0] w1, w2;

    mux_4 #(WIDTH) first1(w1, select[1:0], in0, in1, in2, in3);
    mux_4 #(WIDTH) first2(w2, select[1:0], in4, in5, in6, in7);
    mux_2 #(WIDTH) second(out, select[2], w1, w2);
endmodule