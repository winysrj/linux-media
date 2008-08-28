Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KYjA5-0000t9-1v
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 17:11:51 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: stev391@email.com, "'jackden'" <jackden@gmail.com>
References: <20080828112649.8DAF511581F@ws1-7.us4.outblaze.com>
In-Reply-To: <20080828112649.8DAF511581F@ws1-7.us4.outblaze.com>
Date: Thu, 28 Aug 2008 23:12:14 +0800
Message-ID: <004e01c90920$767f56b0$637e0410$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
	TV/FM capture card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


> Tom, Jackden,
> 
> Please find attached a patch that should add support for the DVB side
> of this card.  Please follow the following to the dot and provide the
> outputs requested, this will ensure that I capture all possible issues
> as soon as possible (and yes I do expect at least one issue).
> 
> 1) Ensure that you have everything installed to build the v4l-dvb tree
> (usually the kernel headers, build-essentials and patch)
> 
> 2) Download and extract:
> http://linuxtv.org/hg/~stoth/cx23885-
> leadtek/archive/837860b92af5.tar.bz2
> 
> 3) Download attached patch to the same directory as the above file.
> 
> 4) Open up a terminal into the directory of the extracted files and
> apply the patch with this
> command:
> patch -p1 < ../Compro_VideoMate_E650.patch
> 
> 5) Make, install:
> make;
> sudo make install
> 
> 6) Download the firmware (see
> http://linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_th
> e_Firmware)
> 
> 7) Now this is going to sound weird (for linux) but it puts the card in
> a known state for me to work from:
> Turn the computer off, count to 10 and turn back on (no a reset will
> not do what I need). Ensure windows does NOT load, before going into
> Linux, if it does turn it back off again.
> 
> 8) Provide the dmesg for the lines after:
> "Linux video capture interface: v2.00"
> 
> 9) If no errors try scanning for channels (see
> http://linuxtv.org/wiki/index.php/Scan if you are unsure how do this).
> If this outputs tv channels then so far so good.
> 
> 10) Open up your favourite player (ensure the channels config is the
> correct directory e.g. for xine ~/.xine/) and try and watch a channel.
> 
> 11) Provide output of dmesg (only the continuation from the previous
> dmesg output).
> 
> Now if at any stage it doesn't work here are a few things that you can
> try (make sure you let me know which ones you did try):
> a) Perform a computer restart (soft restart - a restart controlled by
> the computer, not using any of the buttons on the front), and load
> windows ensure the card is working by tuning to DVB and then perform a
> soft restart into linux and resume at step above that caused errors.
> This is typically going to solve an issue where you cannot get past
> step 9.
> 
> b) Turn debugging on for the following modules:
> tuner_xc2028
> cx23885
> zl10353
> This is usually performed in: /etc/modprobe.d/options (this is what
> ubuntu has) by setting debug = 1. An example line is:
> options cx23885 debug=1
> Now go back to step 7 and try again when you run into a error message
> or unable to do the above provide the dmesg output as referred to in
> Step 11.
> 
> Thanks
> 
> Stephen
> 
> 
> --
> Nothing says Labor Day like 500hp of American muscle Visit OnCars.com
> today.
Stephen,

Thanks for the latest patch.  FYI, I had previously been experimenting with
the Dvico card source so to remove any of the changes I had made I did the
following:
	hg clone http://linuxtv.org/hg/v4l-dvb
	cd v4l-dvb
	make
	sudo make install
I then followed your instructions and restarted the PC after 10 second
delay.  Please see below for output.  

In terms of debugging I am unable to do a soft restart as I need to swap
drives over.  I did however enable debugging and you can see the output of
dmesg at the end of the email.

Outfrom dmesg:
[   32.244477] Linux video capture interface: v2.00
[   32.270595] cx23885 driver version 0.0.1 loaded
[   32.270640] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) ->
IRQ 16
[   32.270651] CORE cx23885[0]: subsystem: 185b:e800, board: Compro
VideoMate E650 [card=13,autodetected]
[   32.443275] cx23885[0]: i2c bus 0 registered
[   32.443288] cx23885[0]: i2c bus 1 registered
[   32.443299] cx23885[0]: i2c bus 2 registered
[   32.470204] cx23885[0]: cx23885 based dvb card
[   32.471207] lirc_dev: IR Remote Control driver registered, major 61
[   32.477659] lirc_imon: no version for "lirc_unregister_plugin" found:
kernel tainted.
[   32.478369] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c: Driver
for Soundgraph iMON MultiMedia IR/VFD, v0.3
[   32.478370] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c: Venky
Raju <dev@venky.ws>
[   32.478392] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c:
imon_probe: found IMON device
[   32.478396] lirc_dev: lirc_register_plugin: sample_rate: 0
[   32.478408] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c:
imon_probe: Registered iMON plugin(minor:0)
[   32.478432] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c:
imon_probe: iMON device on usb<5:2> initialized
[   32.478437] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c:
imon_probe: found IMON device
[   32.478439] lirc_dev: lirc_register_plugin: sample_rate: 0
[   32.478448] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c:
imon_probe: Registered iMON plugin(minor:1)
[   32.478461] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c:
imon_probe: iMON device on usb<5:2> initialized
[   32.478470] usbcore: registered new interface driver lirc_imon
[   32.648252] nvidia: module license 'NVIDIA' taints kernel.
[   32.943549] usbcore: registered new interface driver hiddev
[   32.949197] input: Logitech Logitech BT Mini-Receiver as
/devices/pci0000:00/0000:00:1a.2/usb3/3-2/3-2.2/3-2.2:1.0/input/input4
[   32.996828] input,hidraw0: USB HID v1.11 Keyboard [Logitech Logitech BT
Mini-Receiver] on usb-0000:00:1a.2-2.2
[   33.008109] input: Logitech Logitech BT Mini-Receiver as
/devices/pci0000:00/0000:00:1a.2/usb3/3-2/3-2.3/3-2.3:1.0/input/input5
[   33.016231] dib0700: loaded with support for 7 different device-types
[   33.016463] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
state, will try to load a firmware
[   33.023429] xc2028 1-0061: creating new instance
[   33.023431] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   33.023434] DVB: registering new adapter (cx23885[0])
[   33.023436] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   33.023570] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   33.023576] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfe800000
[   33.023581] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   33.023821] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) ->
IRQ 16
[   33.023826] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   33.023961] NVRM: loading NVIDIA UNIX x86 Kernel Module  173.14.09  Wed
Jun  4 23:43:17 PDT 2008
[   33.025495] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) ->
IRQ 22
[   33.025510] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   33.058794] hda_codec: Unknown model for ALC883, trying auto-probe from
BIOS...
[   33.071378] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.10.fw'
[   33.080751] input,hiddev96,hidraw1: USB HID v1.11 Mouse [Logitech
Logitech BT Mini-Receiver] on usb-0000:00:1a.2-2.3
[   33.080763] usbcore: registered new interface driver usbhid
[   33.080771] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   33.277932] usbcore: registered new interface driver dvb_usb_dib0700
[   33.611862] lp: driver loaded but no devices found
[   33.656757] w83627ehf: Found W83627DHG chip at 0x290
[   33.679680] coretemp coretemp.0: Using undocumented features, absolute
temperature might be wrong!
[   33.679707] coretemp coretemp.1: Using undocumented features, absolute
temperature might be wrong!
[   33.889981] Adding 9847804k swap on /dev/sda5.  Priority:-1 extents:1
across:9847804k
[   34.561845] EXT3 FS on sda1, internal journal
[   36.015617] ip_tables: (C) 2000-2006 Netfilter Core Team
[   36.302264]  CIFS VFS: Error connecting to IPv4 socket. Aborting
operation
[   36.302267]  CIFS VFS: cifs_mount failed w/return code = -101
[   36.305803]  CIFS VFS: Error connecting to IPv4 socket. Aborting
operation
[   36.305806]  CIFS VFS: cifs_mount failed w/return code = -101
[   36.309144]  CIFS VFS: Error connecting to IPv4 socket. Aborting
operation
[   36.309147]  CIFS VFS: cifs_mount failed w/return code = -101
[   37.078803] No dock devices found.
[   39.171426] NET: Registered protocol family 10
[   39.171563] lo: Disabled Privacy Extensions
[   40.824135] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   40.824138] apm: disabled - APM is not SMP safe.
[   49.068260] atl1 0000:02:00.0: eth0 link is up 100 Mbps full duplex
[   53.170602] NET: Registered protocol family 17
[   63.167854] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c: VFD port
opened
[   64.725185] eth0: no IPv6 routers present
[   65.009138] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c: IR port
opened
[   67.652311] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c: IR port
opened

Output from scan:
root@quark:~# scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth >
/root/.tzap/channels.conf
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 2 9 3 1 1 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 536500000 1 2 9 3 1 2 0
>>> tune to:
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSIO
N_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSIO
N_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSIO
N_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSIO
N_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSIO
N_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
dumping lists (0 services)
Done.

I then tried to tune to channels using the MythTV backend setup.  I was able
to add the card but when I tried to scan all Australian channels none were
detected.  

I then added the debugging option as requested and rebooted with 10 second
power off on power supply switch ie no power to backplane.

With Debugging On:
root@quark:/etc/modprobe.d# cat cx23885
options cx23885 debug=1
root@quark:/etc/modprobe.d# cat zl10353
options zl10353 debug=1
root@quark:/etc/modprobe.d# cat tuner_xc2028
options tuner_xc2028 debug=1

Output from dmesg:
[   32.350547] Linux video capture interface: v2.00
[   32.380727] input,hidraw0: USB HID v1.11 Keyboard [Logitech Logitech BT
Mini-Receiver] on usb-0000:00:1a.2-2.2
[   32.392016] input: Logitech Logitech BT Mini-Receiver as
/devices/pci0000:00/0000:00:1a.2/usb3/3-2/3-2.3/3-2.3:1.0/input/input5
[   32.397767] cx23885 driver version 0.0.1 loaded
[   32.397809] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) ->
IRQ 16
[   32.397812] cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe
bridge type 885
[   32.397814] cx23885[0]/0: cx23885_init_tsport(portno=2)
[   32.397820] CORE cx23885[0]: subsystem: 185b:e800, board: Compro
VideoMate E650 [card=13,autodetected]
[   32.397822] cx23885[0]/0: cx23885_pci_quirks()
[   32.397825] cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr
= 0x0
[   32.397827] cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr
= 0x0
[   32.397828] cx23885[0]/0: cx23885_reset()
[   32.497035] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [VID A]
[   32.497045] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch2]
[   32.497046] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS1 B]
[   32.497060] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch4]
[   32.497061] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch5]
[   32.497063] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS2 C]
[   32.497076] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch7]
[   32.497077] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch8]
[   32.497079] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch9]
[   32.536923] cx23885[0]: i2c bus 0 registered
[   32.536934] cx23885[0]: i2c bus 1 registered
[   32.536944] cx23885[0]: i2c bus 2 registered
[   32.563751] cx23885[0]: cx23885 based dvb card
[   32.596552] dib0700: loaded with support for 7 different device-types
[   32.596619] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
state, will try to load a firmware
[   32.624555] input,hiddev96,hidraw1: USB HID v1.11 Mouse [Logitech
Logitech BT Mini-Receiver] on usb-0000:00:1a.2-2.3
[   32.624568] usbcore: registered new interface driver usbhid
[   32.624571] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   32.640555] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.10.fw'
[   32.692348] xc2028: Xcv2028/3028 init called!
[   32.692351] xc2028 1-0061: creating new instance
[   32.692352] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   32.692354] xc2028 1-0061: xc2028_set_config called
[   32.692357] DVB: registering new adapter (cx23885[0])
[   32.692359] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   32.692507] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   32.692513] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfe800000
[   32.692519] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   32.850867] usbcore: registered new interface driver dvb_usb_dib0700
[   33.092528] lp: driver loaded but no devices found
[   33.137196] w83627ehf: Found W83627DHG chip at 0x290
[   33.160472] coretemp coretemp.0: Using undocumented features, absolute
temperature might be wrong!
[   33.160499] coretemp coretemp.1: Using undocumented features, absolute
temperature might be wrong!
[   33.403690] Adding 9847804k swap on /dev/sda5.  Priority:-1 extents:1
across:9847804k
[   34.064500] EXT3 FS on sda1, internal journal
[   35.529326] ip_tables: (C) 2000-2006 Netfilter Core Team
[   35.771602]  CIFS VFS: Error connecting to IPv4 socket. Aborting
operation
[   35.771606]  CIFS VFS: cifs_mount failed w/return code = -101
[   35.775091]  CIFS VFS: Error connecting to IPv4 socket. Aborting
operation
[   35.775094]  CIFS VFS: cifs_mount failed w/return code = -101
[   35.778450]  CIFS VFS: Error connecting to IPv4 socket. Aborting
operation
[   35.778453]  CIFS VFS: cifs_mount failed w/return code = -101
[   36.537404] No dock devices found.
[   38.596444] NET: Registered protocol family 10
[   38.596583] lo: Disabled Privacy Extensions
[   40.138256] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   40.138258] apm: disabled - APM is not SMP safe.
[   47.368015] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 =>
0x5ae9
[   47.368694] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600,
adc_clock 450560 => -6633 / 0xe617
[   47.370382] xc2028 1-0061: xc2028_set_params called
[   47.370384] xc2028 1-0061: generic_set_freq called
[   47.370387] xc2028 1-0061: should set frequency 219500 kHz
[   47.370388] xc2028 1-0061: check_firmware called
[   47.370390] xc2028 1-0061: load_all_firmwares called
[   47.370392] xc2028 1-0061: Reading firmware xc3028-v27.fw
[   47.385345] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,
type: xc2028 firmware, ver 2.7
[   47.385355] xc2028 1-0061: Reading firmware type BASE F8MHZ (3), id 0,
size=8718.
[   47.385363] xc2028 1-0061: Reading firmware type BASE F8MHZ MTS (7), id
0, size=8712.
[   47.385373] xc2028 1-0061: Reading firmware type BASE FM (401), id 0,
size=8562.
[   47.385381] xc2028 1-0061: Reading firmware type BASE FM INPUT1 (c01), id
0, size=8576.
[   47.385389] xc2028 1-0061: Reading firmware type BASE (1), id 0,
size=8706.
[   47.385397] xc2028 1-0061: Reading firmware type BASE MTS (5), id 0,
size=8682.
[   47.385403] xc2028 1-0061: Reading firmware type (0), id 100000007,
size=161.
[   47.385406] xc2028 1-0061: Reading firmware type MTS (4), id 100000007,
size=169.
[   47.385409] xc2028 1-0061: Reading firmware type (0), id 200000007,
size=161.
[   47.385412] xc2028 1-0061: Reading firmware type MTS (4), id 200000007,
size=169.
[   47.385415] xc2028 1-0061: Reading firmware type (0), id 400000007,
size=161.
[   47.385418] xc2028 1-0061: Reading firmware type MTS (4), id 400000007,
size=169.
[   47.385422] xc2028 1-0061: Reading firmware type (0), id 800000007,
size=161.
[   47.385425] xc2028 1-0061: Reading firmware type MTS (4), id 800000007,
size=169.
[   47.385428] xc2028 1-0061: Reading firmware type (0), id 3000000e0,
size=161.
[   47.385431] xc2028 1-0061: Reading firmware type MTS (4), id 3000000e0,
size=169.
[   47.385434] xc2028 1-0061: Reading firmware type (0), id c000000e0,
size=161.
[   47.385437] xc2028 1-0061: Reading firmware type MTS (4), id c000000e0,
size=169.
[   47.385440] xc2028 1-0061: Reading firmware type (0), id 200000,
size=161.
[   47.385443] xc2028 1-0061: Reading firmware type MTS (4), id 200000,
size=169.
[   47.385446] xc2028 1-0061: Reading firmware type (0), id 4000000,
size=161.
[   47.385448] xc2028 1-0061: Reading firmware type MTS (4), id 4000000,
size=169.
[   47.385451] xc2028 1-0061: Reading firmware type D2633 DTV6 ATSC (10030),
id 0, size=149.
[   47.385455] xc2028 1-0061: Reading firmware type D2620 DTV6 QAM (68), id
0, size=149.
[   47.385459] xc2028 1-0061: Reading firmware type D2633 DTV6 QAM (70), id
0, size=149.
[   47.385463] xc2028 1-0061: Reading firmware type D2620 DTV7 (88), id 0,
size=149.
[   47.385467] xc2028 1-0061: Reading firmware type D2633 DTV7 (90), id 0,
size=149.
[   47.385470] xc2028 1-0061: Reading firmware type D2620 DTV78 (108), id 0,
size=149.
[   47.385474] xc2028 1-0061: Reading firmware type D2633 DTV78 (110), id 0,
size=149.
[   47.385477] xc2028 1-0061: Reading firmware type D2620 DTV8 (208), id 0,
size=149.
[   47.385480] xc2028 1-0061: Reading firmware type D2633 DTV8 (210), id 0,
size=149.
[   47.385483] xc2028 1-0061: Reading firmware type FM (400), id 0,
size=135.
[   47.385487] xc2028 1-0061: Reading firmware type (0), id 10, size=161.
[   47.385489] xc2028 1-0061: Reading firmware type MTS (4), id 10,
size=169.
[   47.385493] xc2028 1-0061: Reading firmware type (0), id 1000400000,
size=169.
[   47.385496] xc2028 1-0061: Reading firmware type (0), id c00400000,
size=161.
[   47.385499] xc2028 1-0061: Reading firmware type (0), id 800000,
size=161.
[   47.385501] xc2028 1-0061: Reading firmware type (0), id 8000, size=161.
[   47.385504] xc2028 1-0061: Reading firmware type LCD (1000), id 8000,
size=161.
[   47.385507] xc2028 1-0061: Reading firmware type LCD NOGD (3000), id
8000, size=161.
[   47.385510] xc2028 1-0061: Reading firmware type MTS (4), id 8000,
size=169.
[   47.385513] xc2028 1-0061: Reading firmware type (0), id b700, size=161.
[   47.385516] xc2028 1-0061: Reading firmware type LCD (1000), id b700,
size=161.
[   47.385519] xc2028 1-0061: Reading firmware type LCD NOGD (3000), id
b700, size=161.
[   47.385522] xc2028 1-0061: Reading firmware type (0), id 2000, size=161.
[   47.385525] xc2028 1-0061: Reading firmware type MTS (4), id b700,
size=169.
[   47.385528] xc2028 1-0061: Reading firmware type MTS LCD (1004), id b700,
size=169.
[   47.385531] xc2028 1-0061: Reading firmware type MTS LCD NOGD (3004), id
b700, size=169.
[   47.385535] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3280
(60000000), id 0, size=192.
[   47.385539] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3300
(60000000), id 0, size=192.
[   47.385543] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3440
(60000000), id 0, size=192.
[   47.385546] xc2028 1-0061: Reading firmware type SCODE HAS_IF_3460
(60000000), id 0, size=192.
[   47.385550] xc2028 1-0061: Reading firmware type DTV6 ATSC OREN36 SCODE
HAS_IF_3800 (60210020), id 0, size=192.
[   47.385555] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4000
(60000000), id 0, size=192.
[   47.385558] xc2028 1-0061: Reading firmware type DTV6 ATSC TOYOTA388
SCODE HAS_IF_4080 (60410020), id 0, size=192.
[   47.385565] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4200
(60000000), id 0, size=192.
[   47.385568] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_4320
(60008000), id 8000, size=192.
[   47.385573] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4450
(60000000), id 0, size=192.
[   47.385576] xc2028 1-0061: Reading firmware type MTS LCD NOGD MONO IF
SCODE HAS_IF_4500 (6002b004), id b700, size=192.
[   47.385582] xc2028 1-0061: Reading firmware type LCD NOGD IF SCODE
HAS_IF_4600 (60023000), id 8000, size=192.
[   47.385587] xc2028 1-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
[   47.385593] xc2028 1-0061: Reading firmware type SCODE HAS_IF_4940
(60000000), id 0, size=192.
[   47.385596] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5260
(60000000), id 0, size=192.
[   47.385600] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_5320
(60008000), id f00000007, size=192.
[   47.385604] xc2028 1-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52
CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
[   47.385610] xc2028 1-0061: Reading firmware type DTV6 ATSC OREN538 SCODE
HAS_IF_5580 (60110020), id 0, size=192.
[   47.385615] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5640
(60000000), id 300000007, size=192.
[   47.385619] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5740
(60000000), id c00000007, size=192.
[   47.385623] xc2028 1-0061: Reading firmware type SCODE HAS_IF_5900
(60000000), id 0, size=192.
[   47.385626] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6000
(60008000), id c04c000f0, size=192.
[   47.385631] xc2028 1-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ
SCODE HAS_IF_6200 (68050060), id 0, size=192.
[   47.385637] xc2028 1-0061: Reading firmware type SCODE HAS_IF_6240
(60000000), id 10, size=192.
[   47.385640] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6320
(60008000), id 200000, size=192.
[   47.385644] xc2028 1-0061: Reading firmware type SCODE HAS_IF_6340
(60000000), id 200000, size=192.
[   47.385648] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6500
(60008000), id c044000e0, size=192.
[   47.385653] xc2028 1-0061: Reading firmware type DTV6 ATSC ATI638 SCODE
HAS_IF_6580 (60090020), id 0, size=192.
[   47.385659] xc2028 1-0061: Reading firmware type SCODE HAS_IF_6600
(60000000), id 3000000e0, size=192.
[   47.385663] xc2028 1-0061: Reading firmware type MONO SCODE HAS_IF_6680
(60008000), id 3000000e0, size=192.
[   47.385667] xc2028 1-0061: Reading firmware type DTV6 ATSC TOYOTA794
SCODE HAS_IF_8140 (60810020), id 0, size=192.
[   47.385672] xc2028 1-0061: Reading firmware type SCODE HAS_IF_8200
(60000000), id 0, size=192.
[   47.385681] xc2028 1-0061: Firmware files loaded.
[   47.385683] xc2028 1-0061: checking firmware, user requested type=F8MHZ
D2620 DTV7 (8a), id 0000000000000000, int_freq 4760, scode_nr 0
[   47.583956] xc2028 1-0061: load_firmware called
[   47.583958] xc2028 1-0061: seek_firmware called, want type=BASE F8MHZ
D2620 DTV7 (8b), id 0000000000000000.
[   47.583961] xc2028 1-0061: Found firmware for type=BASE F8MHZ (3), id
0000000000000000.
[   47.583964] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
[   48.726038] xc2028 1-0061: Load init1 firmware, if exists
[   48.726041] xc2028 1-0061: load_firmware called
[   48.726043] xc2028 1-0061: seek_firmware called, want type=BASE INIT1
F8MHZ D2620 DTV7 (408b), id 0000000000000000.
[   48.726048] xc2028 1-0061: Can't find firmware for type=BASE INIT1 F8MHZ
(4003), id 0000000000000000.
[   48.726051] xc2028 1-0061: load_firmware called
[   48.726052] xc2028 1-0061: seek_firmware called, want type=BASE INIT1
D2620 DTV7 (4089), id 0000000000000000.
[   48.726055] xc2028 1-0061: Can't find firmware for type=BASE INIT1
(4001), id 0000000000000000.
[   48.726058] xc2028 1-0061: load_firmware called
[   48.726059] xc2028 1-0061: seek_firmware called, want type=F8MHZ D2620
DTV7 (8a), id 0000000000000000.
[   48.726062] xc2028 1-0061: Found firmware for type=D2620 DTV7 (88), id
0000000000000000.
[   48.726065] xc2028 1-0061: Loading firmware for type=D2620 DTV7 (88), id
0000000000000000.
[   48.739823] xc2028 1-0061: Trying to load scode 0
[   48.739825] xc2028 1-0061: load_scode called
[   48.739827] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[   48.769126] xc2028 1-0061: xc2028_get_reg 0004 called
[   48.769846] xc2028 1-0061: xc2028_get_reg 0008 called
[   48.770558] xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware
version 2.7
[   48.870205] atl1 0000:02:00.0: eth0 link is up 100 Mbps full duplex
[   48.907994] xc2028 1-0061: divisor= 00 00 36 30 (freq=219.500)
[   51.786851] NET: Registered protocol family 17
[   63.368864] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c: VFD port
opened
[   65.272619] eth0: no IPv6 routers present
[   65.331954] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c: IR port
opened
[   67.864414] /home/tom/source/lirc/drivers/lirc_imon/lirc_imon.c: IR port
opened

Again thanks for your help and please let me know if you want me to try
something else.

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
