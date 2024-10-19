module task_scheduler(
    input clk,                        // Clock signal
    input reset,                      // Reset signal
    input [2:0] task_priority,        // Priority of incoming task (0 to 3)
    input [7:0] task_duration,        // Execution time of incoming task (in clock cycles)
    output reg [3:0] core_busy,       // Core busy status (1 if core is busy, 0 if free)
    output reg [7:0] core_task_time_0,  // Remaining execution time for core 0
    output reg [7:0] core_task_time_1,  // Remaining execution time for core 1
    output reg [7:0] core_task_time_2,  // Remaining execution time for core 2
    output reg [7:0] core_task_time_3   // Remaining execution time for core 3
);

// Task queue for each priority level
reg [7:0] task_queue [3:0][15:0];    // 4 priority levels, each with space for 16 tasks
reg [3:0] queue_head [3:0];          // Head index for each task queue
reg [3:0] queue_tail [3:0];          // Tail index for each task queue

// Core status and remaining time
reg [3:0] core_status;                // 1 if core is busy, 0 if free
reg [7:0] core_time_remaining [3:0];  // Time remaining for task on each core

integer i;

// Reset or initialize the system
always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < 4; i = i + 1) begin
            core_status[i] <= 0;
            core_time_remaining[i] <= 0;
            queue_head[i] <= 0;
            queue_tail[i] <= 0;
        end
    end
    else begin
        // Decrease remaining time for active tasks
        for (i = 0; i < 4; i = i + 1) begin
            if (core_status[i]) begin
                if (core_time_remaining[i] > 0)
                    core_time_remaining[i] <= core_time_remaining[i] - 1;
                else
                    core_status[i] <= 0; // Core becomes free when task completes
            end
        end
    end
end

// Handle task arrivals and enqueue them
always @(posedge clk) begin
    // Enqueue incoming task if there's space in the corresponding priority queue
    if (task_priority < 4 && queue_tail[task_priority] < 16) begin
        task_queue[task_priority][queue_tail[task_priority]] <= task_duration;
        queue_tail[task_priority] <= queue_tail[task_priority] + 1;
    end
end

// Assign tasks to available cores based on priority
always @(posedge clk) begin
    for (i = 0; i < 4; i = i + 1) begin
        if (!core_status[i]) begin // If core is free
            // Check for tasks in the highest priority queue first
            if (queue_head[3] != queue_tail[3]) begin
                core_status[i] <= 1;
                core_time_remaining[i] <= task_queue[3][queue_head[3]];
                queue_head[3] <= queue_head[3] + 1;
            end
            else if (queue_head[2] != queue_tail[2]) begin
                core_status[i] <= 1;
                core_time_remaining[i] <= task_queue[2][queue_head[2]];
                queue_head[2] <= queue_head[2] + 1;
            end
            else if (queue_head[1] != queue_tail[1]) begin
                core_status[i] <= 1;
                core_time_remaining[i] <= task_queue[1][queue_head[1]];
                queue_head[1] <= queue_head[1] + 1;
            end
            else if (queue_head[0] != queue_tail[0]) begin
                core_status[i] <= 1;
                core_time_remaining[i] <= task_queue[0][queue_head[0]];
                queue_head[0] <= queue_head[0] + 1;
            end
        end
    end
end

// Assign core task time outputs
always @(posedge clk) begin
    core_task_time_0 <= core_time_remaining[0];
    core_task_time_1 <= core_time_remaining[1];
    core_task_time_2 <= core_time_remaining[2];
    core_task_time_3 <= core_time_remaining[3];
end

endmodule
