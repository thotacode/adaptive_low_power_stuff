module tb;

reg clk = 0;
reg reset = 1;
reg workload;

wire [7:0] hist;
wire predict;
wire [7:0] alu_out;

wire [31:0] toggle_count;

always #5 clk = ~clk;   // 100MHz
// wire gated_clk = clk;   // force always ON

// Instantiate modules
history_buffer HB(clk, reset, workload, hist);
perceptron P(hist, predict);
dummy_alu ALU(gated_clk, alu_out);
power_controller PC(clk, reset, predict, gated_clk);
switch_counter SW(gated_clk, reset, alu_out[0], toggle_count);




initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);

    reset = 1;
    #20 reset = 0;

    // -------- WORKLOAD PATTERN --------
    // Burst phase
// Long ACTIVE phase
// Active
repeat(40) begin workload = 1; #10; end

// Huge idle, ML should dominate
repeat(200) begin workload = 0; #10; end

// Mixed
repeat(60) begin workload = ( ($time/10) % 5 != 0 ); #10; end

    
    #2000;
    $display("FINAL SWITCHING COUNT = %d", toggle_count);
    $finish;
end
endmodule
