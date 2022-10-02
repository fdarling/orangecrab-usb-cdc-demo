PROJ=usb_serial_test

TOP_MODULE = top
VERILOG_SOURCES = \
	src/usb_serial_test.v \
	src/reset_timer.v \
	tinyfpga_bx_usbserial/usb/edge_detect.v \
	tinyfpga_bx_usbserial/usb/serial.v \
	tinyfpga_bx_usbserial/usb/usb_fs_in_arb.v \
	tinyfpga_bx_usbserial/usb/usb_fs_in_pe.v \
	tinyfpga_bx_usbserial/usb/usb_fs_out_arb.v \
	tinyfpga_bx_usbserial/usb/usb_fs_out_pe.v \
	tinyfpga_bx_usbserial/usb/usb_fs_pe.v \
	tinyfpga_bx_usbserial/usb/usb_fs_rx.v \
	tinyfpga_bx_usbserial/usb/usb_fs_tx_mux.v \
	tinyfpga_bx_usbserial/usb/usb_fs_tx.v \
	tinyfpga_bx_usbserial/usb/usb_reset_det.v \
	tinyfpga_bx_usbserial/usb/usb_serial_ctrl_ep.v \
	tinyfpga_bx_usbserial/usb/usb_uart_bridge_ep.v \
	tinyfpga_bx_usbserial/usb/usb_uart_core.v \
	src/usb_uart_ecp5.v

all: $(PROJ).dfu

dfu: $(PROJ).dfu
	dfu-util -D $<

%.json: $(VERILOG_SOURCES)
	yosys -p "synth_ecp5 -json $@ -top $(TOP_MODULE)" $(VERILOG_SOURCES)

%_out.config: %.json orangecrab_r0.2.pcf
	nextpnr-ecp5 --json $< --textcfg $@ --25k --package CSFBGA285 --lpf orangecrab_r0.2.pcf

%.bit: %_out.config
	ecppack --compress --freq 38.8 --input $< --bit $@

%.dfu : %.bit
	cp $< $@
	dfu-suffix -v 1209 -p 5af0 -a $@

clean:
	rm -f $(PROJ).svf $(PROJ).bit $(PROJ).config $(PROJ).json $(PROJ).dfu

.PHONY: all dfu clean
