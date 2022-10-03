# OrangeCrab USB CDC echo demo

This is a minimum working example of implementing a USB CDC (Communications Class Device) virtual COM port on an OrangeCrab development board. The OrangeCrab is an open source FPGA development board featuring an open source toolchain friendly Lattice ECP5. The main parts of the open source toolchain are yosys and nextpnr.

The USB CDC code itself is third party:

https://github.com/davidthings/tinyfpga_bx_usbserial

## Hardware

You'll need an OrangeCrab v0.2 development board (designed by Greg Davill):

* https://1bitsquared.com/products/orangecrab
* https://github.com/orangecrab-fpga/orangecrab-hardware
* https://groupgets.com/manufacturers/good-stuff-department/products/orangecrab

## Dependencies

You must install the `yosys` toolchain, which I originally did by downloading a binary distribution from this releases section of a GitHub repository:

~~https://github.com/YosysHQ/fpga-toolchain/releases~~

Apparently that is no longer maintained, and you are recommended to download this toolchain distribution instead:

https://github.com/YosysHQ/oss-cad-suite-build/releases

## Downloading

This repository has a submodule dependency, so you must recursively clone it:

```
git clone --recursive https://github.com/fdarling/orangecrab-usb-cdc-demo.git
```

If you already cloned the repository without recursion, then you must use these commands inside the repository's directory to pull in the dependencies after the fact:

```
git submodule init
git submodule update
```

## Compiling

You must have your environment/path variables set so that the open source FPGA toolchain is accessible, otherwise the commands used in the Makefile won't be found, and it will give errors. Typically you must do one of the following like:

```
# for oss-cad-suite:
source ~/apps/oss-cad-suite/environment

# ...or for fpga-toolchain:
export PATH=~/apps/fpga-toolchain/bin/:$PATH
```

Inside the repository's directy, simply run `make`:

```
make
```

## Flashing

After a `.dfu` file is produced, you can flash it to the OrangeCrab by putting it into bootloader mode and running the following command:

```
make dfu
```

To get into bootloader mode, you either press the "user button" labeled `btn` on the OrangeCrab while it's running an existing design that allows resetting via this button (not required nor default behavior!), or more reliably, unplug the OrangeCrab from power, hold the button, and plug the OrangeCrab while still holding the button. This latter method will reliably put it into bootloader mode unless the device is bricked, in which case you need to un-brick it using a JTAG programmer.

## Testing

On Linux, the OrangeCrab should create a virtual COM port as device `/dev/ttyACM0` if it's available, otherwise it will show up with a different number suffix such as `/dev/ttyACM1`, etc. You can open this virtual COM port with any serial terminal client such as PuTTY, minicom, screen, etc.

Anything you type should be shown, as the device is echo'ing what it receives back to you!
