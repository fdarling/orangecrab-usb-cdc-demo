`default_nettype none

module top
(
    input wire clk48, // 48MHz clock input (convenient for USB)

    // RGB LED outputs
    output wire rgb_led0_r,
    output wire rgb_led0_g,
    output wire rgb_led0_b,

    output reg rst_n, // reset output (for resetting onself)
    input wire usr_btn, // button input (propogated to reset output)

    // USB signals
    inout wire usb_d_p,
    inout wire usb_d_n,
    output wire usb_pullup
);
    localparam CLOCK_HZ = 48000000;

    // inter-modular wires
    wire       usb_uart_reset;
    wire [7:0] usb_uart_tx_data;
    wire       usb_uart_tx_data_valid;
    wire       usb_uart_tx_ready;
    wire [7:0] reset_counter;
    wire       counter_non_zero;

    // assert reset for the USB COM port module for 6 microseconds
    reset_timer
    #(
        .CLOCK_HZ(CLOCK_HZ),
        .TIME_NS(6000)
    )
    usb_uart_reset_inst
    (
        .clk(clk48),
        .reset_out(usb_uart_reset),
        .counter_out(reset_counter),
        .counter_non_zero(counter_non_zero)
    );

    // USB COM port module
    usb_uart_np usb_uart_inst
    (
        // clock and reset
        .clk_48mhz(clk48),
        .reset(usb_uart_reset),

        // physical USB pins
        .pin_usb_p(usb_d_p),
        .pin_usb_n(usb_d_n),

        // uart pipeline in (out of the device, into the host)
        .uart_in_data(usb_uart_tx_data),
        .uart_in_valid(usb_uart_tx_data_valid),
        .uart_in_ready(usb_uart_tx_ready),

        // uart pipeline out (into the device, out of the host)
        .uart_out_data(usb_uart_tx_data),
        .uart_out_valid(usb_uart_tx_data_valid),
        .uart_out_ready(usb_uart_tx_ready)
    );

    // state

    // initial state
    initial begin
        rst_n = 1'b1;
    end

    // state change
    always @(posedge clk48) begin
        rst_n <= usr_btn;
    end

    // output logic
    assign rgb_led0_r = 1;
    assign rgb_led0_g = 1;
    assign rgb_led0_b = 1;
    assign usb_pullup = 1'b1;
endmodule
