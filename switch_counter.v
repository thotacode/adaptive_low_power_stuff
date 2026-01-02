module switch_counter(
    input clk,
    input reset,
    input signal,
    output reg [31:0] count
);

reg prev;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        count <= 0;
        prev <= 0;
    end
    else begin
        if(signal != prev)
            count <= count + 1;
        prev <= signal;
    end
end

endmodule
