module history_buffer(
    input clk,
    input reset,
    input workload_bit,
    output reg [7:0] hist
);
always @(posedge clk or posedge reset) begin
    if(reset)
        hist <= 8'b0;
    else
        hist <= {hist[6:0], workload_bit};
end
endmodule
