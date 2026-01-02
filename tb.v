`timescale 1ns / 1ps
module tb;
    reg clk = 0;
    reg reset = 1;
    reg workload;

    // Interconnects
    wire [7:0] hist;
    wire predict;
    wire master_clk;
    wire [3:0] worker_clks; // 4 worker clocks
    wire [2:0] active_count;

    // ALU Outputs (These caused your error earlier - they must be declared!)
    wire [7:0] master_out;
    wire [7:0] worker_out;

    // Power Measurement Counters
    wire [31:0] master_toggles;
    wire [31:0] worker_toggles;

    
    history_buffer HB(clk, reset, workload, hist);
    perceptron P(hist, predict);
    
    
    power_controller PC(clk, reset, predict, master_clk, worker_clks, active_count);

    dummy_alu MASTER_CORE (
        .clk(master_clk), 
        .out(master_out)
    );

    // The Worker Core receives one of the gated clocks (worker_clks[0])
    dummy_alu WORKER_CORE (
        .clk(worker_clks[0]), 
        .out(worker_out)
    );

    // Measures how often the Master toggles vs the Worker
    switch_counter MASTER_METER (master_clk, reset, master_out[0], master_toggles);
    switch_counter WORKER_METER (worker_clks[0], reset, worker_out[0], worker_toggles);


    // Clock Generation
    always #5 clk = ~clk;

    // Variables for Power Calculation
    integer baseline_power;
    integer optimized_power;
    integer saved_power;
    real percent_saved;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);

        // Header
        $display("---------------------------------------------------");
        $display("   ML-ADAPTIVE CORE MONITOR STARTING");
        $display("---------------------------------------------------");
        // Monitor changes in core count
        $monitor("Time: %0t | Workload: %b | Prediction: %b | ACTIVE CORES: %0d", 
                 $time, workload, predict, active_count);

        reset = 1; 
        #20 reset = 0;

        $display("\n[DEMO] Phase 1: High Workload Burst...");
        repeat(30) begin workload = 1; #10; end

        $display("\n[DEMO] Phase 2: System Idle (Power Saving Mode)...");
        repeat(200) begin workload = 0; #10; end

        $display("\n[DEMO] Phase 3: Dynamic Scaling...");
        repeat(50) begin 
            workload = ($random % 2); 
            #10; 
        end
        
        #100;

        baseline_power = master_toggles * 5; 

        optimized_power = master_toggles + (worker_toggles * 4);

        saved_power = baseline_power - optimized_power;
        percent_saved = (saved_power * 100.0) / baseline_power;

        $display("\n===================================================");
        $display("             POWER EFFICIENCY REPORT               ");
        $display("===================================================");
        $display("Total Toggles (Unoptimized System) : %0d", baseline_power);
        $display("Total Toggles (Your Adaptive System) : %0d", optimized_power);
        $display("---------------------------------------------------");
        $display("SWITCHING REDUCTION                : %0d toggles", saved_power);
        $display("ESTIMATED POWER SAVINGS            : %0.2f %%", percent_saved);
        $display("===================================================\n");

        $finish;
    end
endmodule