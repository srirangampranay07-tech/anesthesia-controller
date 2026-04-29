`timescale 1ns/1ps

module tb_anesthesia_controller_v2;

// Inputs
reg clk;
reg reset;
reg [3:0] sensor_value;

// Outputs
wire [1:0] pump_control;
wire alarm;

// Instantiate DUT
anesthesia_controller_v2 uut (
    .clk(clk),
    .reset(reset),
    .sensor_value(sensor_value),
    .pump_control(pump_control),
    .alarm(alarm)
);

// Clock generation (10ns period)
always #5 clk = ~clk;

initial begin
    // Initialize
    clk = 0;
    reset = 1;
    sensor_value = 0;

    // Apply reset
    #10 reset = 0;

    // 🔹 Test 1: LOW condition (< LOW_TH)
    #10 sensor_value = 3;   // LOW → INCREASE

    // 🔹 Test 2: NORMAL condition
    #40 sensor_value = 6;   // NORMAL → STABLE

    // 🔹 Test 3: HIGH condition (> HIGH_TH)
    #40 sensor_value = 12;  // HIGH → DECREASE

    // 🔹 Test 4: Back to NORMAL
    #40 sensor_value = 7;

    // 🔹 Test 5: Rapid change
    #20 sensor_value = 2;
    #20 sensor_value = 13;
    #20 sensor_value = 5;

    // 🔹 Test 6: Edge values
    #20 sensor_value = 4;
    #20 sensor_value = 10;

    // Finish
    #50 $finish;
end

// Monitor
initial begin
    $monitor("Time=%0t | Reset=%b | Sensor=%d | Pump=%b | Alarm=%b",
              $time, reset, sensor_value, pump_control, alarm);
end

endmodule
