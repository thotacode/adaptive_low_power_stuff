module dummy_alu(
    input clk,
    output reg [7:0] out
);

initial out = 0;

always @(posedge clk)
    out <= out + 1;

endmodule
