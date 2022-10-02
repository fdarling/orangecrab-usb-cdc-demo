`default_nettype none

module reset_timer
#(
    parameter CLOCK_HZ = 48000000,
    parameter TIME_NS = 1000000
)
(
    input wire clk,
    output reg reset_out,
    output wire [7:0] counter_out,
    output wire       counter_non_zero
);
    // parameters
    localparam COUNTER_MAX = 64'd1 * TIME_NS * CLOCK_HZ / (1000*1000*1000) - 1; // NOTE: 64'd1 needed for yosys to prevent integer overflow
    localparam COUNTER_BITS = $clog2(COUNTER_MAX);

    // state
    reg [COUNTER_BITS-1:0] counter;

    // initial state
    initial begin
        counter = COUNTER_MAX;
        reset_out = 1'b1;
    end

    // state change
    always @(posedge clk) begin
        if (counter != 0) begin
            counter <= counter - 1;
        end
        else begin
            reset_out <= 1'b0;
        end
    end

    // output logic
    assign counter_out = counter;
    assign counter_non_zero = counter != 0;
endmodule
