module anesthesia_controller_v2 (
    input clk,
    input reset,
    input [3:0] sensor_value,   // real value (0–15)
    output reg [1:0] pump_control,
    output reg alarm
);

// Parameters (Adjustable thresholds)
parameter LOW_TH  = 4;
parameter HIGH_TH = 10;

// States
parameter IDLE    = 3'b000,
          CHECK   = 3'b001,
          INCR    = 3'b010,
          DECR    = 3'b011,
          STABLE  = 3'b100,
          ERROR   = 3'b101;

reg [2:0] current_state, next_state;

// Delay counter
reg [2:0] delay_cnt;

// Comparator outputs
wire low, high, normal;

assign low    = (sensor_value < LOW_TH);
assign high   = (sensor_value > HIGH_TH);
assign normal = (~low && ~high);

// 🔷 State Register (Sequential)
always @(posedge clk or posedge reset) begin
    if (reset)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// 🔷 Delay Counter (Sequential)
always @(posedge clk or posedge reset) begin
    if (reset)
        delay_cnt <= 0;
    else if (current_state == CHECK)
        delay_cnt <= delay_cnt + 1;
    else
        delay_cnt <= 0;
end

// 🔷 Next State Logic
always @(*) begin
    case (current_state)

        IDLE: next_state = CHECK;

        CHECK: begin
            if (sensor_value > 4'd15) // invalid condition
                next_state = ERROR;
            else if (delay_cnt < 3)
                next_state = CHECK;
            else if (low)
                next_state = INCR;
            else if (high)
                next_state = DECR;
            else
                next_state = STABLE;
        end

        INCR:   next_state = CHECK;
        DECR:   next_state = CHECK;
        STABLE: next_state = CHECK;

        ERROR:  next_state = IDLE;

        default: next_state = IDLE;
    endcase
end

// 🔷 Output Logic
always @(*) begin
    // default values
    pump_control = 2'b00;
    alarm = 0;

    case (current_state)

        INCR:   pump_control = 2'b01; // increase
        DECR:   pump_control = 2'b10; // decrease
        STABLE: pump_control = 2'b11; // maintain

        ERROR: begin
            pump_control = 2'b00;
            alarm = 1; // safety alert
        end

    endcase
end

endmodule
