Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:61501 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781AbaKVOzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Nov 2014 09:55:42 -0500
Message-ID: <5470A3DE.3030907@internode.on.net>
Date: Sun, 23 Nov 2014 01:55:26 +1100
From: Raena <raen@internode.on.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: ASUSTeK P7131 Hybrid Frontend stopped opening
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I run Ubuntu 14 3.13.0-40-generic. After the last kernel upgrade my Card 
stopped working so I am not sure if it a linux kernel issue and thought 
best to start with LinuxTV as I cannot work out what the problem is.

The card seems to load Ok as per dmesg below but when I try it in 
mplayer it fails with ERROR

OPENING FRONTEND DEVICE /dev/dvb/adapter0/frontend0: ERRNO 16
DVB_SET_CHANNEL2, COULDN'T OPEN DEVICES OF CARD: 0, EXIT

I have dvb-fe-xc5000-1.6.114.fw installed in /lib/firmware. It was all 
working very well until the kernel upgrade.

Heres my dmesg. Hope you can help. Thanks. RL-Sdynamic conservative mode
[    0.981911] e1000e 0000:33:00.0: irq 53 for MSI/MSI-X
[    0.981914] e1000e 0000:33:00.0: irq 54 for MSI/MSI-X
[    0.981918] e1000e 0000:33:00.0: irq 55 for MSI/MSI-X
[    1.034434] ata8: SATA link down (SStatus 0 SControl 300)
[    1.034504] ata9: SATA link down (SStatus 0 SControl 300)
[    1.034519] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.034598] ata7: SATA link down (SStatus 0 SControl 300)
[    1.034660] ata10: SATA link down (SStatus 0 SControl 300)
[    1.034674] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.034784] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.035580] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) 
succeeded
[    1.035585] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
[    1.035589] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE 
CONFIGURATION OVERLAY) filtered out
[    1.035988] ata3.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) 
succeeded
[    1.035993] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
[    1.035996] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE 
CONFIGURATION OVERLAY) filtered out
[    1.036442] ata1.00: ATA-8: Hitachi HDS721010DLE630, MS2OA610, max 
UDMA/133
[    1.036447] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 
31/32), AA
[    1.037232] ata3.00: ATA-8: Hitachi HDT721010SLA360, ST6OA31B, max 
UDMA/133
[    1.037235] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 
31/32), AA
[    1.037379] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) 
succeeded
[    1.037383] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
[    1.037386] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE 
CONFIGURATION OVERLAY) filtered out
[    1.037960] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) 
succeeded
[    1.037965] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
[    1.037968] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE 
CONFIGURATION OVERLAY) filtered out
[    1.038187] ata1.00: configured for UDMA/133
[    1.038371] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72101 
MS2O PQ: 0 ANSI: 5
[    1.038519] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: 
(1.00 TB/931 GiB)
[    1.038521] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.038525] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.038558] sd 0:0:0:0: [sda] Write Protect is off
[    1.038559] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.038572] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.038583] ata3.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) 
succeeded
[    1.038585] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
[    1.038587] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE 
CONFIGURATION OVERLAY) filtered out
[    1.039795] ata3.00: configured for UDMA/133
[    1.039947] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDT72101 
ST6O PQ: 0 ANSI: 5
[    1.040040] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: 
(1.00 TB/931 GiB)
[    1.040070] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    1.040237] sd 2:0:0:0: [sdb] Write Protect is off
[    1.040248] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.040282] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.040984] ata5.00: ATAPI: PIONEER BD-RW   BDR-205, 1.03, max UDMA/100
[    1.044679] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) 
succeeded
[    1.044684] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE 
LOCK) filtered out
[    1.044687] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE 
CONFIGURATION OVERLAY) filtered out
[    1.047814] ata5.00: configured for UDMA/100
[    1.058747] scsi 4:0:0:0: CD-ROM            PIONEER  BD-RW BDR-205  
1.03 PQ: 0 ANSI: 5
[    1.076402]  sdb: sdb1 sdb2 < sdb5 >
[    1.077088] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.078421] sr0: scsi3-mmc drive: 125x/125x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    1.078423] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.078519] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    1.078598] sr 4:0:0:0: Attached scsi generic sg2 type 5
[    1.082754] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.082759] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    1.082988] hub 1-1:1.0: USB hub found
[    1.083091] hub 1-1:1.0: 6 ports detected
[    1.084271]  sda: sda1 sda2 < sda5 >
[    1.084449] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.090125] e1000e 0000:33:00.0 eth1: registered PHC clock
[    1.090127] e1000e 0000:33:00.0 eth1: (PCI Express:2.5GT/s:Width x1) 
00:22:4d:9d:72:7a
[    1.090128] e1000e 0000:33:00.0 eth1: Intel(R) PRO/1000 Network 
Connection
[    1.090143] e1000e 0000:33:00.0 eth1: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[    1.194426] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.326857] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.326861] usb 2-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    1.327122] hub 2-1:1.0: USB hub found
[    1.327225] hub 2-1:1.0: 8 ports detected
[    1.439154] usb 4-1: new SuperSpeed USB device number 2 using xhci_hcd
[    1.460135] usb 4-1: New USB device found, idVendor=05e3, idProduct=0612
[    1.460137] usb 4-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    1.460138] usb 4-1: Product: USB3.0 Hub 123
[    1.460139] usb 4-1: Manufacturer: GenesysLogic
[    1.470494] hub 4-1:1.0: USB hub found
[    1.470937] hub 4-1:1.0: 3 ports detected
[    1.574592] tsc: Refined TSC clocksource calibration: 3392.292 MHz
[    1.587109] usb 4-4: new SuperSpeed USB device number 3 using xhci_hcd
[    1.607824] usb 4-4: New USB device found, idVendor=05e3, idProduct=0612
[    1.607828] usb 4-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    1.607831] usb 4-4: Product: USB3.0 Hub 123
[    1.607833] usb 4-4: Manufacturer: GenesysLogic
[    1.618023] hub 4-4:1.0: USB hub found
[    1.618465] hub 4-4:1.0: 3 ports detected
[    1.786771] usb 3-1: new high-speed USB device number 2 using xhci_hcd
[    1.809345] usb 3-1: New USB device found, idVendor=05e3, idProduct=0610
[    1.809349] usb 3-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    1.809352] usb 3-1: Product: USB2.0 Hub 456
[    1.809354] usb 3-1: Manufacturer: GenesysLogic
[    1.810124] hub 3-1:1.0: USB hub found
[    1.810894] hub 3-1:1.0: 3 ports detected
[    1.926769] usb 3-4: new high-speed USB device number 3 using xhci_hcd
[    1.949355] usb 3-4: New USB device found, idVendor=05e3, idProduct=0610
[    1.949359] usb 3-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    1.949362] usb 3-4: Product: USB2.0 Hub 456
[    1.949364] usb 3-4: Manufacturer: GenesysLogic
[    1.950133] hub 3-4:1.0: USB hub found
[    1.950884] hub 3-4:1.0: 3 ports detected
[    2.026917] usb 1-1.1: new low-speed USB device number 3 using ehci-pci
[    2.125502] usb 1-1.1: New USB device found, idVendor=046d, 
idProduct=c521
[    2.125506] usb 1-1.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    2.125509] usb 1-1.1: Product: USB Receiver
[    2.125511] usb 1-1.1: Manufacturer: Logitech
[    2.129391] hidraw: raw HID events driver (C) Jiri Kosina
[    2.137989] usbcore: registered new interface driver usbhid
[    2.137991] usbhid: USB HID core driver
[    2.138961] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input5
[    2.139042] hid-generic 0003:046D:C521.0001: input,hidraw0: USB HID 
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input0
[    2.141473] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.1/input/input6
[    2.141551] hid-generic 0003:046D:C521.0002: input,hiddev0,hidraw1: 
USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input1
[    2.198995] usb 1-1.2: new full-speed USB device number 4 using ehci-pci
[    2.296936] usb 1-1.2: New USB device found, idVendor=045e, 
idProduct=0745
[    2.296941] usb 1-1.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    2.296943] usb 1-1.2: Product: 
Microsoft\xffffffc2\xffffffae\xffffffae Nano Transceiver v2.0
[    2.296945] usb 1-1.2: Manufacturer: Microsoft
[    2.300438] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 
Nano Transceiver v2.0 as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input7
[    2.300605] hid-generic 0003:045E:0745.0003: input,hidraw2: USB HID 
v1.11 Keyboard [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae Nano 
Transceiver v2.0] on usb-0000:00:1a.0-1.2/input0
[    2.306218] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 
Nano Transceiver v2.0 as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.1/input/input8
[    2.306530] hid-generic 0003:045E:0745.0004: input,hidraw3: USB HID 
v1.11 Mouse [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae Nano 
Transceiver v2.0] on usb-0000:00:1a.0-1.2/input1
[    2.322023] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 
Nano Transceiver v2.0 as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/input/input9
[    2.322320] hid-generic 0003:045E:0745.0005: input,hiddev0,hidraw4: 
USB HID v1.11 Device [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 
Nano Transceiver v2.0] on usb-0000:00:1a.0-1.2/input2
[    2.391073] usb 2-1.7: new high-speed USB device number 3 using ehci-pci
[    2.504921] usb 2-1.7: New USB device found, idVendor=0db0, 
idProduct=3871
[    2.504926] usb 2-1.7: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    2.504928] usb 2-1.7: Product: 802.11 n WLAN
[    2.504930] usb 2-1.7: Manufacturer: Ralink
[    2.504932] usb 2-1.7: SerialNumber: 1.0
[    2.575147] usb 2-1.8: new full-speed USB device number 4 using ehci-pci
[    2.575245] Switched to clocksource tsc
[    2.864958] usb 2-1.8: New USB device found, idVendor=0db0, 
idProduct=a871
[    2.864963] usb 2-1.8: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    7.527690] EXT4-fs (sda1): mounted filesystem with ordered data 
mode. Opts: (null)
[    7.785613] random: nonblocking pool is initialized
[   19.090464] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   19.090468] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   19.173157] systemd-udevd[383]: starting version 204
[   19.425722] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   19.443466] lp: driver loaded but no devices found
[   19.446576] ppdev: user-space parallel port driver
[   19.452631] wmi: Mapper loaded
[   19.466977] nvidia: module license 'NVIDIA' taints kernel.
[   19.466981] Disabling lock debugging due to kernel taint
[   19.469551] nvidia: module verification failed: signature and/or 
required key missing - tainting kernel
[   19.472280] vgaarb: device changed decodes: 
PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=none
[   19.472355] NVRM: loading NVIDIA UNIX x86_64 Kernel Module 304.117  
Tue Nov 26 21:25:36 PST 2013
[   19.474135] mei_me 0000:00:16.0: irq 56 for MSI/MSI-X
[   19.481033] Linux video capture interface: v2.00
[   19.484281] ACPI Warning: 0x0000000000000428-0x000000000000042f 
SystemIO conflicts with Region \PMIO 1 (20131115/utaddress-251)
[   19.484285] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   19.484288] ACPI Warning: 0x0000000000000530-0x000000000000053f 
SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[   19.484290] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   19.484290] ACPI Warning: 0x0000000000000500-0x000000000000052f 
SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[   19.484292] ACPI Warning: 0x0000000000000500-0x000000000000052f 
SystemIO conflicts with Region \_SB_.PCI0.RLED.DBG0 2 
(20131115/utaddress-251)
[   19.484294] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   19.484294] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   19.490866] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   19.491014] saa7133[0]: found at 0000:3b:01.0, rev: 209, irq: 19, 
latency: 32, mmio: 0xef100000
[   19.491024] saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131 
Hybrid [card=112,autodetected]
[   19.491041] saa7133[0]: board init: gpio is 0
[   19.492249] Bluetooth: Core ver 2.17
[   19.492263] NET: Registered protocol family 31
[   19.492264] Bluetooth: HCI device and connection manager initialized
[   19.492271] Bluetooth: HCI socket layer initialized
[   19.492273] Bluetooth: L2CAP socket layer initialized
[   19.492277] Bluetooth: SCO socket layer initialized
[   19.493850] usbcore: registered new interface driver btusb
[   19.507999] snd_hda_intel 0000:00:1b.0: irq 57 for MSI/MSI-X
[   19.514837] Registered IR keymap rc-asus-pc39
[   19.514891] input: saa7134 IR (ASUSTeK P7131 Hybri as 
/devices/pci0000:00/0000:00:1c.5/0000:34:00.0/0000:35:09.0/0000:3a:00.0/0000:3b:01.0/rc/rc0/input10
[   19.514928] rc0: saa7134 IR (ASUSTeK P7131 Hybri as 
/devices/pci0000:00/0000:00:1c.5/0000:34:00.0/0000:35:09.0/0000:3a:00.0/0000:3b:01.0/rc/rc0
[   19.517395] IR NEC protocol handler initialized
[   19.518477] SKU: Nid=0x1d sku_cfg=0x4016f601
[   19.518478] SKU: port_connectivity=0x1
[   19.518480] SKU: enable_pcbeep=0x1
[   19.518481] SKU: check_sum=0x00000006
[   19.518481] SKU: customization=0x000000f6
[   19.518482] SKU: external_amp=0x0
[   19.518483] SKU: platform_type=0x0
[   19.518484] SKU: swap=0x0
[   19.518485] SKU: override=0x1
[   19.519208] autoconfig: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[   19.519210]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   19.519212]    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   19.519212]    mono: mono_out=0x0
[   19.519214]    dig-out=0x11/0x1e
[   19.519214]    inputs:
[   19.519216]      Front Mic=0x19
[   19.519218]      Rear Mic=0x18
[   19.519219]      Line=0x1a
[   19.519220] realtek: No valid SSID, checking pincfg 0x4016f601 for 
NID 0x1d
[   19.519221] realtek: Enabling init ASM_ID=0xf601 CODEC_ID=10ec0899
[   19.519567] IR RC5(x) protocol handler initialized
[   19.522472] IR RC6 protocol handler initialized
[   19.522688] IR JVC protocol handler initialized
[   19.527999] IR Sony protocol handler initialized
[   19.529885] IR SANYO protocol handler initialized
[   19.529935] IR MCE Keyboard/mouse protocol handler initialized
[   19.530534] input: HDA Intel PCH Front Headphone as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[   19.531345] input: HDA Intel PCH Line Out CLFE as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[   19.531417] input: HDA Intel PCH Line Out Surround as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   19.531430] input: MCE IR Keyboard/Mouse (saa7134) as 
/devices/virtual/input/input18
[   19.531656] input: HDA Intel PCH Line Out Front as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   19.532502] input: HDA Intel PCH Line as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   19.532548] input: HDA Intel PCH Rear Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   19.532592] input: HDA Intel PCH Front Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   19.532710] lirc_dev: IR Remote Control driver registered, major 248
[   19.532830] hda_intel: Disabling MSI
[   19.532836] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
[   19.532867] hda-intel 0000:01:00.1: Disabling 64bit DMA
[   19.533430] rc rc0: lirc_dev: driver ir-lirc-codec (saa7134) 
registered at minor = 0
[   19.533431] IR LIRC bridge handler initialized
[   19.536121] hda-intel 0000:01:00.1: Enable delay in RIRB handling
[   19.678923] saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43 43 
a9 1c 55 d2 b2 92
[   19.678934] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff 
ff ff ff ff ff ff
[   19.678943] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 
00 d5 ff ff ff ff
[   19.678951] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.678959] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55 50 
ff ff ff ff ff ff
[   19.678976] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.678979] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.678982] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.678986] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.678989] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.678993] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.678996] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.679000] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.679003] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.679006] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.679010] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   19.692978] intel_rapl: domain uncore energy ctr 0:0 not working, skip
[   19.714929] tuner 0-004b: Tuner -1 found with type(s) Radio TV.
[   19.794972] tda829x 0-004b: setting tuner address to 61
[   19.844943] cfg80211: Calling CRDA to update world regulatory domain
[   19.857382] type=1400 audit(1416661838.671:2): apparmor="STATUS" 
operation="profile_load" profile="unconfined" name="/sbin/dhclient" 
pid=563 comm="apparmor_parser"
[   19.857387] type=1400 audit(1416661838.671:3): apparmor="STATUS" 
operation="profile_load" profile="unconfined" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=563 
comm="apparmor_parser"
[   19.857389] type=1400 audit(1416661838.671:4): apparmor="STATUS" 
operation="profile_load" profile="unconfined" 
name="/usr/lib/connman/scripts/dhclient-script" pid=563 
comm="apparmor_parser"
[   19.857395] type=1400 audit(1416661838.671:5): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" name="/sbin/dhclient" 
pid=561 comm="apparmor_parser"
[   19.857400] type=1400 audit(1416661838.671:6): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=561 
comm="apparmor_parser"
[   19.857402] type=1400 audit(1416661838.671:7): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" 
name="/usr/lib/connman/scripts/dhclient-script" pid=561 
comm="apparmor_parser"
[   19.857408] type=1400 audit(1416661838.671:8): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" name="/sbin/dhclient" 
pid=562 comm="apparmor_parser"
[   19.857412] type=1400 audit(1416661838.671:9): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=562 
comm="apparmor_parser"
[   19.857414] type=1400 audit(1416661838.671:10): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" 
name="/usr/lib/connman/scripts/dhclient-script" pid=562 
comm="apparmor_parser"
[   19.857640] type=1400 audit(1416661838.671:11): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=563 
comm="apparmor_parser"
[   19.858998] tda829x 0-004b: type set to tda8290+75a
[   19.927161] usb 2-1.7: reset high-speed USB device number 3 using 
ehci-pci
[   19.935082] input: HDA NVidia HDMI/DP,pcm=7 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input20
[   19.935175] input: HDA NVidia HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input19
[   20.033941] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 3070, 
rev 0201 detected
[   20.058566] init: failsafe main process (719) killed by TERM signal
[   20.062577] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0005 
detected
[   20.064767] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   20.064933] usbcore: registered new interface driver rt2800usb
[   20.077912] cfg80211: World regulatory domain updated:
[   20.077914] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   20.077915] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   20.077916] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   20.077917] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[   20.077918] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   20.077918] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   21.262013] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   21.262015] Bluetooth: BNEP filters: protocol multicast
[   21.262021] Bluetooth: BNEP socket layer initialized
[   21.262347] Bluetooth: RFCOMM TTY layer initialized
[   21.262352] Bluetooth: RFCOMM socket layer initialized
[   21.262356] Bluetooth: RFCOMM ver 1.11
[   21.631863] init: cups main process (933) killed by HUP signal
[   21.631870] init: cups main process ended, respawning
[   23.000515] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[   23.104574] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[   23.104660] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   23.104889] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   23.256145] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   23.256337] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   23.257743] ieee80211 phy0: rt2x00lib_request_firmware: Info - 
Loading firmware file 'rt2870.bin'
[   23.365905] ieee80211 phy0: rt2x00lib_request_firmware: Info - 
Firmware detected - version: 0.29
[   23.628825] saa7133[0]: registered device video0 [v4l2]
[   23.628848] saa7133[0]: registered device vbi0
[   23.628872] saa7133[0]: registered device radio0
[   23.630591] saa7134 ALSA driver for DMA sound loaded
[   23.630609] saa7133[0]/alsa: saa7133[0] at 0xef100000 irq 19 
registered as card -2
[   23.633154] dvb_init() allocating 1 frontend
[   23.664801] DVB: registering new adapter (saa7133[0])
[   23.664805] saa7134 0000:3b:01.0: DVB: registering adapter 0 frontend 
0 (Philips TDA10046H DVB-T)...
[   23.740653] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   23.740997] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   23.904928] tda1004x: setting up plls for 48MHz sampling clock
[   23.996906] init: samba-ad-dc main process (1389) terminated with 
status 1
[   24.369156] tda1004x: found firmware revision 20 -- ok
[   24.870419] e1000e: eth1 NIC Link is Up 100 Mbps Full Duplex, Flow 
Control: Rx/Tx
[   24.870538] e1000e 0000:33:00.0 eth1: 10/100 speed: disabling TSO
[   24.870753] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   28.934508] bio: create slab <bio-1> at 1
[   29.979947] tda1004x: setting up plls for 48MHz sampling clock
[   30.264045] tda1004x: found firmware revision 20 -- ok
[   32.052707] Adding 8355836k swap on /dev/mapper/cryptswap1. 
Priority:-1 extents:1 across:8355836k FS
[   33.571694] init: plymouth-upstart-bridge main process ended, respawning
[   33.574875] init: plymouth-upstart-bridge main process (2031) 
terminated with status 1
[   33.574882] init: plymouth-upstart-bridge main process ended, respawning
[   51.435802] audit_printk_skb: 234 callbacks suppressed
[   51.435804] type=1400 audit(1416661870.240:90): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" 
name="/usr/lib/cups/backend/cups-pdf" pid=2805 comm="apparmor_parser"
[   51.435808] type=1400 audit(1416661870.240:91): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" name="/usr/sbin/cupsd" 
pid=2805 comm="apparmor_parser"
[   51.436066] type=1400 audit(1416661870.240:92): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" name="/usr/sbin/cupsd" 
pid=2805 comm="apparmor_parser"
