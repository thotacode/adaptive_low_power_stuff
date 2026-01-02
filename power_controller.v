module power_controller(
    input clk,
    input reset,
    input predict,
    output gated_clk
);

reg enable;
reg [5:0] warmup = 0;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        warmup <= 0;
        enable <= 1;
    end
    else begin
        if(warmup < 4) begin
            warmup <= warmup + 1;
            enable <= 1;          // force ON during warmup
        end
        else begin
            enable <= predict;    // ML controls after warmup
        end
    end
end

assign gated_clk = enable ? clk : 1'b0;

endmodule

