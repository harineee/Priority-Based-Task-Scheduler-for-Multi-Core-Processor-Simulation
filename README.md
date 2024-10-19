# Priority-Based-Task-Scheduler-for-Multi-Core-Processor-Simulation

---

# Task Scheduler in Verilog

This EDA Playground project implements a **Task Scheduler** in Verilog that simulates task assignments to multiple processing cores. The scheduler assigns tasks based on priority and ensures that tasks are executed on free cores when available. The design supports different task priorities and handles task execution based on their duration.

## Project Link

You can view and run the project on [EDA Playground](https://www.edaplayground.com/x/Zd8y).

## Files Overview

- **`design.sv`**: This file contains the Verilog code for the task scheduler. It simulates task arrival, prioritization, and assignment to multiple processing cores.
  
- **`testbench.sv`**: This file contains the testbench that provides input to the task scheduler and monitors its outputs. It generates clock and reset signals, as well as various tasks with different priorities and durations for testing.

## Functionality

The task scheduler module assigns tasks to four cores, prioritizing higher-priority tasks before lower-priority ones. The task scheduler has the following key features:

- **Task Queuing**: Tasks are queued according to their priority (0 to 3, with 3 being the highest).
- **Task Assignment**: Tasks are assigned to the next available free core, with higher priority tasks being executed first.
- **Task Execution Time**: Each task is assigned an execution time, and the core remains busy until the task completes.
- **Core Status**: The status of each core is tracked and updated once a task completes.

### Inputs:

- **`clk`**: Clock signal to synchronize the system.
- **`reset`**: Resets the system, initializing all cores and queues.
- **`task_priority`**: Indicates the priority of an incoming task (0 to 3, with 3 being the highest).
- **`task_duration`**: Specifies the execution time of the task in clock cycles.

### Outputs:

- **`core_busy`**: 4-bit output indicating the busy status of each core (1 means the core is busy).
- **`core_task_time_X`**: Indicates the remaining time for the task currently being executed by each core (X = 0, 1, 2, 3).

## Simulation

The testbench simulates the following sequence of events:
- Resets the system.
- Generates several tasks with varying priorities and durations.
- Observes the core busy statuses and remaining execution times to verify that tasks are properly queued, prioritized, and executed.

### Running the Simulation

To run the simulation:
1. Open the project [here](https://www.edaplayground.com/x/Zd8y).
2. Click the **Run** button.
3. Review the **Run Log** for simulation results and any potential errors.
4. Optional: You can enable waveforms in the testbench for a graphical view of signal transitions over time by adding the `$dumpfile` and `$dumpvars` commands.

### Sample Testbench Output (Console):

```
Time: 155 | Reset: 0 | Priority: 0 | Duration:  20 | Core Busy: xxxx | Core Times:   1,   1,   1,   1
Time: 165 | Reset: 0 | Priority: 0 | Duration:  20 | Core Busy: xxxx | Core Times:   0,   0,   0,   0
Time: 185 | Reset: 0 | Priority: 0 | Duration:  20 | Core Busy: xxxx | Core Times:  25,  25,  25,  25
...
```
