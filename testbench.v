module tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg [2:0] task_priority;
    reg [7:0] task_duration;
    wire [3:0] core_busy;
    wire [7:0] core_task_time_0;
    wire [7:0] core_task_time_1;
    wire [7:0] core_task_time_2;
    wire [7:0] core_task_time_3;

    // Instantiate the task_scheduler module
    task_scheduler uut (
        .clk(clk),
        .reset(reset),
        .task_priority(task_priority),
        .task_duration(task_duration),
        .core_busy(core_busy),
        .core_task_time_0(core_task_time_0),
        .core_task_time_1(core_task_time_1),
        .core_task_time_2(core_task_time_2),
        .core_task_time_3(core_task_time_3)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        task_priority = 0;
        task_duration = 0;
        #20 reset = 0;  // Release reset after 20 time units

        // Apply tasks with different priorities and durations
        #10 task_priority = 3; task_duration = 10;
        #10 task_priority = 2; task_duration = 20;
        #10 task_priority = 1; task_duration = 15;
        #10 task_priority = 0; task_duration = 30;

        // Add more tasks as needed for thorough testing
        #50 task_priority = 3; task_duration = 25;
        #10 task_priority = 2; task_duration = 10;
        #10 task_priority = 1; task_duration = 5;
        #10 task_priority = 0; task_duration = 20;

        // Finish simulation after sufficient time
        #100 $finish;
    end

    // Optional: Monitor signals for debugging
    initial begin
        $monitor("Time: %0t | Reset: %b | Priority: %d | Duration: %d | Core Busy: %b | Core Times: %d, %d, %d, %d",
                 $time, reset, task_priority, task_duration, core_busy,
                 core_task_time_0, core_task_time_1, core_task_time_2, core_task_time_3);
    end

endmodule
