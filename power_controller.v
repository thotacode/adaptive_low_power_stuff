module power_controller(
    input clk,
    input reset,
    input predict,          
    output master_clk,       // Always ON
    output [3:0] worker_clks,
    output [2:0] active_count // Number for your display (0-5)
);
    reg enable;
    reg [5:0] warmup = 0;
    reg latch_en;

    // Logic: Enable workers if predict is high AND warmup done
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            warmup <= 0;
            enable <= 1;
        end else begin
            if(warmup < 4) begin
                warmup <= warmup + 1;
                enable <= 1;
            end else begin
                enable <= predict;
            end
        end
    end

    // Safe Latch-based gating
    always @(clk or enable) begin
        if (!clk) latch_en <= enable;
    end

    assign master_clk = clk;
    
    // If predict is 1, all 4 workers turn on. If 0, they turn off.
    assign worker_clks = {4{clk & latch_en}};
    
    // Display Logic: 1 Master + (4 workers IF enable is high)
    assign active_count = enable ? 3'd5 : 3'd1;

endmodule