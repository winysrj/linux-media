Return-path: <linux-media-owner@vger.kernel.org>
Received: from njbrsmtp2.vzwmail.net ([66.174.76.156]:51141 "EHLO
	njbrsmtp2.vzwmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZAUBzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 20:55:10 -0500
Received: from [70.193.45.134] (smtp.vzwmail.net [66.174.76.25])
	(authenticated bits=0)
	by njbrsmtp2.vzwmail.net (8.12.9/8.12.9) with ESMTP id n0L1cOlK026380
	for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 01:38:34 GMT
Message-ID: <49767CAB.8030004@vzwmail.net>
Date: Tue, 20 Jan 2009 18:38:51 -0700
From: "T.P. Reitzel" <4066724035@vzwmail.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: gspca_spca505
Content-Type: multipart/mixed;
 boundary="------------050507060908090800090905"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050507060908090800090905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Original linux driver for Intel PC Camera Pro (see link for more detail):

http://sourceforge.net/projects/spca50x

Intel's webpage for Intel Pro PC Camera (internal capture card):

http://downloadcenter.intel.com/filter_results.aspx?strTypes=all&ProductID=459&OSFullName=Windows*+98+SE&lang=eng&strOSs=18&submit=Go!

P.S. I'm using libv4l version 0.5.7

HTH and thanks!







--------------050507060908090800090905
Content-Type: text/plain;
 name="kernel.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="kernel.txt"

Jan 20 11:32:54 believer kernel: usb usb1: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: hub 1-0:1.0: USB hub found
Jan 20 11:32:54 believer kernel: hub 1-0:1.0: 4 ports detected
Jan 20 11:32:54 believer kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Jan 20 11:32:54 believer kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 20 11:32:54 believer kernel: usb usb1: Product: EHCI Host Controller
Jan 20 11:32:54 believer kernel: usb usb1: Manufacturer: Linux 2.6.27.7 ehci_hcd
Jan 20 11:32:54 believer kernel: usb usb1: SerialNumber: 0000:00:07.2
Jan 20 11:32:54 believer kernel: ehci_hcd 0000:00:10.4: PCI INT C -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
Jan 20 11:32:54 believer kernel: ehci_hcd 0000:00:10.4: EHCI Host Controller
Jan 20 11:32:54 believer kernel: ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 2
Jan 20 11:32:54 believer kernel: ehci_hcd 0000:00:10.4: irq 21, io mem 0xe8112000
Jan 20 11:32:54 believer kernel: ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Jan 20 11:32:54 believer kernel: usb usb2: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: hub 2-0:1.0: USB hub found
Jan 20 11:32:54 believer kernel: hub 2-0:1.0: 8 ports detected
Jan 20 11:32:54 believer kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Jan 20 11:32:54 believer kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 20 11:32:54 believer kernel: usb usb2: Product: EHCI Host Controller
Jan 20 11:32:54 believer kernel: usb usb2: Manufacturer: Linux 2.6.27.7 ehci_hcd
Jan 20 11:32:54 believer kernel: usb usb2: SerialNumber: 0000:00:10.4
Jan 20 11:32:54 believer kernel: 116x: driver isp116x-hcd, 03 Nov 2005
Jan 20 11:32:54 believer kernel: USB Universal Host Controller Interface driver v3.0
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:07.0: UHCI Host Controller
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:07.0: new USB bus registered, assigned bus number 3
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:07.0: irq 18, io base 0x0000c000
Jan 20 11:32:54 believer kernel: usb usb3: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: hub 3-0:1.0: USB hub found
Jan 20 11:32:54 believer kernel: hub 3-0:1.0: 2 ports detected
Jan 20 11:32:54 believer kernel: usb 1-2: new high speed USB device using ehci_hcd and address 3
Jan 20 11:32:54 believer kernel: usb 1-2: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: usb 1-2: New USB device found, idVendor=041e, idProduct=4063
Jan 20 11:32:54 believer kernel: usb 1-2: New USB device strings: Mfr=2, Product=1, SerialNumber=3
Jan 20 11:32:54 believer kernel: usb 1-2: Product: VF0410 Live! Cam Video IM Pro
Jan 20 11:32:54 believer kernel: usb 1-2: Manufacturer: Creative Technology Ltd
Jan 20 11:32:54 believer kernel: usb 1-2: SerialNumber: 071127_A_28975
Jan 20 11:32:54 believer kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Jan 20 11:32:54 believer kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 20 11:32:54 believer kernel: usb usb3: Product: UHCI Host Controller
Jan 20 11:32:54 believer kernel: usb usb3: Manufacturer: Linux 2.6.27.7 uhci_hcd
Jan 20 11:32:54 believer kernel: usb usb3: SerialNumber: 0000:00:07.0
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:07.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:07.1: UHCI Host Controller
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:07.1: new USB bus registered, assigned bus number 4
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:07.1: irq 19, io base 0x0000c400
Jan 20 11:32:54 believer kernel: usb usb4: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: hub 4-0:1.0: USB hub found
Jan 20 11:32:54 believer kernel: hub 4-0:1.0: 2 ports detected
Jan 20 11:32:54 believer kernel: usb 2-1: new high speed USB device using ehci_hcd and address 2
Jan 20 11:32:54 believer kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Jan 20 11:32:54 believer kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 20 11:32:54 believer kernel: usb usb4: Product: UHCI Host Controller
Jan 20 11:32:54 believer kernel: usb usb4: Manufacturer: Linux 2.6.27.7 uhci_hcd
Jan 20 11:32:54 believer kernel: usb usb4: SerialNumber: 0000:00:07.1
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.0: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.0: UHCI Host Controller
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 5
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d000
Jan 20 11:32:54 believer kernel: usb usb5: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: hub 5-0:1.0: USB hub found
Jan 20 11:32:54 believer kernel: hub 5-0:1.0: 2 ports detected
Jan 20 11:32:54 believer kernel: usb 2-1: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: usb 2-1: New USB device found, idVendor=106c, idProduct=3711
Jan 20 11:32:54 believer kernel: usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Jan 20 11:32:54 believer kernel: usb 2-1: Product: PANTECH USB MODEM
Jan 20 11:32:54 believer kernel: usb 2-1: Manufacturer: PANTECH
Jan 20 11:32:54 believer kernel: usb 2-2: new high speed USB device using ehci_hcd and address 3
Jan 20 11:32:54 believer kernel: usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Jan 20 11:32:54 believer kernel: usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 20 11:32:54 believer kernel: usb usb5: Product: UHCI Host Controller
Jan 20 11:32:54 believer kernel: usb usb5: Manufacturer: Linux 2.6.27.7 uhci_hcd
Jan 20 11:32:54 believer kernel: usb usb5: SerialNumber: 0000:00:10.0
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.1: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.1: UHCI Host Controller
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 6
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.1: irq 21, io base 0x0000d400
Jan 20 11:32:54 believer kernel: usb usb6: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: hub 6-0:1.0: USB hub found
Jan 20 11:32:54 believer kernel: hub 6-0:1.0: 2 ports detected
Jan 20 11:32:54 believer kernel: usb 2-2: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: usb 2-2: New USB device found, idVendor=041e, idProduct=4063
Jan 20 11:32:54 believer kernel: usb 2-2: New USB device strings: Mfr=2, Product=1, SerialNumber=3
Jan 20 11:32:54 believer kernel: usb 2-2: Product: VF0410 Live! Cam Video IM Pro
Jan 20 11:32:54 believer kernel: usb 2-2: Manufacturer: Creative Technology Ltd
Jan 20 11:32:54 believer kernel: usb 2-2: SerialNumber: 080118_A_19700
Jan 20 11:32:54 believer kernel: usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Jan 20 11:32:54 believer kernel: usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 20 11:32:54 believer kernel: usb usb6: Product: UHCI Host Controller
Jan 20 11:32:54 believer kernel: usb usb6: Manufacturer: Linux 2.6.27.7 uhci_hcd
Jan 20 11:32:54 believer kernel: usb usb6: SerialNumber: 0000:00:10.1
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.2: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.2: UHCI Host Controller
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 7
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.2: irq 21, io base 0x0000d800
Jan 20 11:32:54 believer kernel: usb usb7: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: hub 7-0:1.0: USB hub found
Jan 20 11:32:54 believer kernel: hub 7-0:1.0: 2 ports detected
Jan 20 11:32:54 believer kernel: usb 2-4: new high speed USB device using ehci_hcd and address 5
Jan 20 11:32:54 believer kernel: usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Jan 20 11:32:54 believer kernel: usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 20 11:32:54 believer kernel: usb usb7: Product: UHCI Host Controller
Jan 20 11:32:54 believer kernel: usb usb7: Manufacturer: Linux 2.6.27.7 uhci_hcd
Jan 20 11:32:54 believer kernel: usb usb7: SerialNumber: 0000:00:10.2
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.3: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.3: UHCI Host Controller
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 8
Jan 20 11:32:54 believer kernel: uhci_hcd 0000:00:10.3: irq 21, io base 0x0000dc00
Jan 20 11:32:54 believer kernel: usb usb8: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: hub 8-0:1.0: USB hub found
Jan 20 11:32:54 believer kernel: hub 8-0:1.0: 2 ports detected
Jan 20 11:32:54 believer kernel: usb 2-4: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: usb 2-4: New USB device found, idVendor=041e, idProduct=4063
Jan 20 11:32:54 believer kernel: usb 2-4: New USB device strings: Mfr=2, Product=1, SerialNumber=3
Jan 20 11:32:54 believer kernel: usb 2-4: Product: VF0410 Live! Cam Video IM Pro
Jan 20 11:32:54 believer kernel: usb 2-4: Manufacturer: Creative Technology Ltd
Jan 20 11:32:54 believer kernel: usb 2-4: SerialNumber: 080117_A_17635
Jan 20 11:32:54 believer kernel: usb 2-7: new high speed USB device using ehci_hcd and address 6
Jan 20 11:32:54 believer kernel: usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
Jan 20 11:32:54 believer kernel: usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 20 11:32:54 believer kernel: usb usb8: Product: UHCI Host Controller
Jan 20 11:32:54 believer kernel: usb usb8: Manufacturer: Linux 2.6.27.7 uhci_hcd
Jan 20 11:32:54 believer kernel: usb usb8: SerialNumber: 0000:00:10.3
Jan 20 11:32:54 believer kernel: sl811: driver sl811-hcd, 19 May 2005
Jan 20 11:32:54 believer kernel: Initializing USB Mass Storage driver...
Jan 20 11:32:54 believer kernel: usb 2-7: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: usb 2-7: New USB device found, idVendor=045e, idProduct=00f8
Jan 20 11:32:54 believer kernel: usb 2-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Jan 20 11:32:54 believer kernel: usb 2-7: Product: Microsoft® LifeCam NX-6000
Jan 20 11:32:54 believer kernel: usb 2-7: Manufacturer: Microsoft
Jan 20 11:32:54 believer kernel: usb 3-1: new full speed USB device using uhci_hcd and address 2
Jan 20 11:32:54 believer kernel: usb 3-1: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: usb 3-1: New USB device found, idVendor=0733, idProduct=0430
Jan 20 11:32:54 believer kernel: usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Jan 20 11:32:54 believer kernel: scsi0 : SCSI emulation for USB Mass Storage devices
Jan 20 11:32:54 believer kernel: usb 6-1: new full speed USB device using uhci_hcd and address 2
Jan 20 11:32:54 believer kernel: usb 6-1: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: usb 6-1: New USB device found, idVendor=0471, idProduct=0329
Jan 20 11:32:54 believer kernel: usb 6-1: New USB device strings: Mfr=0, Product=0, SerialNumber=1
Jan 20 11:32:54 believer kernel: usb 6-1: SerialNumber: 01690000C712003A
Jan 20 11:32:54 believer kernel: usb 8-2: new low speed USB device using uhci_hcd and address 2
Jan 20 11:32:54 believer kernel: usb 8-2: configuration #1 chosen from 1 choice
Jan 20 11:32:54 believer kernel: usb 8-2: New USB device found, idVendor=046d, idProduct=c521
Jan 20 11:32:54 believer kernel: usb 8-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Jan 20 11:32:54 believer kernel: usb 8-2: Product: USB Receiver
Jan 20 11:32:54 believer kernel: usb 8-2: Manufacturer: Logitech
Jan 20 11:32:54 believer kernel: usbcore: registered new interface driver usb-storage
Jan 20 11:32:54 believer kernel: USB Mass Storage support registered.
Jan 20 11:32:54 believer kernel: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
Jan 20 11:32:54 believer kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 20 11:32:54 believer kernel: mice: PS/2 mouse device common for all mice
Jan 20 11:32:54 believer kernel: rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
Jan 20 11:32:54 believer kernel: rtc0: alarms up to one year, y3k
Jan 20 11:32:54 believer kernel: rtc-test rtc-test.0: rtc core: registered test as rtc1
Jan 20 11:32:54 believer kernel: rtc-test rtc-test.1: rtc core: registered test as rtc2
Jan 20 11:32:54 believer kernel: i2c /dev entries driver
Jan 20 11:32:54 believer kernel: md: linear personality registered for level -1
Jan 20 11:32:54 believer kernel: md: raid0 personality registered for level 0
Jan 20 11:32:54 believer kernel: md: raid1 personality registered for level 1
Jan 20 11:32:54 believer kernel: md: raid10 personality registered for level 10
Jan 20 11:32:54 believer kernel: md: raid6 personality registered for level 6
Jan 20 11:32:54 believer kernel: md: raid5 personality registered for level 5
Jan 20 11:32:54 believer kernel: md: raid4 personality registered for level 4
Jan 20 11:32:54 believer kernel: md: multipath personality registered for level -4
Jan 20 11:32:54 believer kernel: device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Jan 20 11:32:54 believer kernel: usbcore: registered new interface driver hiddev
Jan 20 11:32:54 believer kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:10.3/usb8/8-2/8-2:1.0/input/input1
Jan 20 11:32:54 believer kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
Jan 20 11:32:54 believer kernel: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:10.3-2
Jan 20 11:32:54 believer kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:10.3/usb8/8-2/8-2:1.1/input/input3
Jan 20 11:32:54 believer kernel: input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:10.3-2
Jan 20 11:32:54 believer kernel: usbcore: registered new interface driver usbhid
Jan 20 11:32:54 believer kernel: usbhid: v2.6:USB HID core driver
Jan 20 11:32:54 believer kernel: TCP cubic registered
Jan 20 11:32:54 believer kernel: Initializing XFRM netlink socket
Jan 20 11:32:54 believer kernel: NET: Registered protocol family 17
Jan 20 11:32:54 believer kernel: RPC: Registered udp transport module.
Jan 20 11:32:54 believer kernel: RPC: Registered tcp transport module.
Jan 20 11:32:54 believer kernel: rtc_cmos 00:05: setting system clock to 2009-01-20 18:32:39 UTC (1232476359)
Jan 20 11:32:54 believer kernel: md: Autodetecting RAID arrays.
Jan 20 11:32:54 believer kernel: md: Scanned 0 and added 0 devices.
Jan 20 11:32:54 believer kernel: md: autorun ...
Jan 20 11:32:54 believer kernel: md: ... autorun DONE.
Jan 20 11:32:54 believer kernel: kjournald starting.  Commit interval 5 seconds
Jan 20 11:32:54 believer kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jan 20 11:32:54 believer kernel: Freeing unused kernel memory: 428k freed
Jan 20 11:32:54 believer kernel: processor ACPI0007:00: registered as cooling_device0
Jan 20 11:32:54 believer kernel: input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
Jan 20 11:32:54 believer kernel: ACPI: Power Button (FF) [PWRF]
Jan 20 11:32:54 believer kernel: input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
Jan 20 11:32:54 believer kernel: ACPI: Power Button (CM) [PWRB]
Jan 20 11:32:54 believer kernel: cdc_acm 2-1:1.0: ttyACM0: USB ACM device
Jan 20 11:32:54 believer kernel: usbcore: registered new interface driver cdc_acm
Jan 20 11:32:54 believer kernel: cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
Jan 20 11:32:54 believer kernel: parport_pc 00:09: reported by Plug and Play ACPI
Jan 20 11:32:54 believer kernel: parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
Jan 20 11:32:54 believer kernel: thermal LNXTHERM:01: registered as thermal_zone0
Jan 20 11:32:54 believer kernel: ACPI: Thermal Zone [THRM] (44 C)
Jan 20 11:32:54 believer kernel: fan PNP0C0B:00: registered as cooling_device1
Jan 20 11:32:54 believer kernel: ACPI: Fan [FAN] (on)
Jan 20 11:32:54 believer kernel: 8139too Fast Ethernet driver 0.9.28
Jan 20 11:32:54 believer kernel: 8139too 0000:00:0a.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Jan 20 11:32:54 believer kernel: eth0: RealTek RTL8139 at 0xc800, 00:40:ca:a7:bf:07, IRQ 17
Jan 20 11:32:54 believer kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Jan 20 11:32:54 believer kernel: ACPI: Device needs an ACPI driver
Jan 20 11:32:54 believer kernel: Linux video capture interface: v2.00
Jan 20 11:32:54 believer kernel: gspca: main v2.4.0 registered
Jan 20 11:32:54 believer kernel: ppdev: user-space parallel port driver
Jan 20 11:32:54 believer kernel: gspca: probing 0733:0430
Jan 20 11:32:54 believer kernel: scsi 0:0:0:0: Direct-Access     PANTECH  Mass Storage     0001 PQ: 0 ANSI: 0 CCS
Jan 20 11:32:54 believer kernel: sd 0:0:0:0: [sda] Attached SCSI removable disk
Jan 20 11:32:54 believer kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Jan 20 11:32:54 believer kernel: gspca: probe ok
Jan 20 11:32:54 believer kernel: usbcore: registered new interface driver spca505
Jan 20 11:32:54 believer kernel: spca505: registered
Jan 20 11:32:54 believer kernel: uvcvideo: Found UVC 1.00 device VF0410 Live! Cam Video IM Pro (041e:4063)
Jan 20 11:32:54 believer kernel: input: VF0410 Live! Cam Video IM Pro as /devices/pci0000:00/0000:00:07.2/usb1/1-2/1-2:1.0/input/input6
Jan 20 11:32:54 believer kernel: uvcvideo: Found UVC 1.00 device VF0410 Live! Cam Video IM Pro (041e:4063)
Jan 20 11:32:54 believer kernel: input: VF0410 Live! Cam Video IM Pro as /devices/pci0000:00/0000:00:10.4/usb2/2-2/2-2:1.0/input/input7
Jan 20 11:32:54 believer kernel: uvcvideo: Found UVC 1.00 device VF0410 Live! Cam Video IM Pro (041e:4063)
Jan 20 11:32:54 believer kernel: input: VF0410 Live! Cam Video IM Pro as /devices/pci0000:00/0000:00:10.4/usb2/2-4/2-4:1.0/input/input8
Jan 20 11:32:54 believer kernel: uvcvideo: Found UVC 1.00 device Microsoft® LifeCam NX-6000 (045e:00f8)
Jan 20 11:32:54 believer kernel: uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
Jan 20 11:32:54 believer kernel: input: Microsoft® LifeCam NX-6000 as /devices/pci0000:00/0000:00:10.4/usb2/2-7/2-7:1.0/input/input9
Jan 20 11:32:54 believer kernel: usbcore: registered new interface driver uvcvideo
Jan 20 11:32:54 believer kernel: USB Video Class driver (v0.1.0)
Jan 20 11:32:54 believer kernel: pwc: Philips webcam module version 10.0.13 loaded.
Jan 20 11:32:54 believer kernel: pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
Jan 20 11:32:54 believer kernel: pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
Jan 20 11:32:54 believer kernel: pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
Jan 20 11:32:54 believer kernel: pwc: Philips SPC 900NC USB webcam detected.
Jan 20 11:32:54 believer kernel: pwc: Registered as /dev/video5.
Jan 20 11:32:54 believer kernel: input: PWC snapshot button as /devices/pci0000:00/0000:00:10.1/usb6/6-1/input/input10
Jan 20 11:32:54 believer kernel: usbcore: registered new interface driver Philips webcam
Jan 20 11:32:54 believer kernel: VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[ALKC] -> GSI 22 (level, low) -> IRQ 22
Jan 20 11:32:54 believer kernel: 6:3:1 : sample bitwidth 24 in over sample bytes 2
Jan 20 11:32:54 believer kernel: usbcore: registered new interface driver snd-usb-audio
Jan 20 11:32:54 believer kernel: Adding 1943824k swap on /dev/hda1.  Priority:-1 extents:1 across:1943824k
Jan 20 11:32:54 believer kernel: EXT3 FS on hda3, internal journal
Jan 20 11:32:54 believer kernel: lp0: using parport0 (interrupt-driven).
Jan 20 11:32:54 believer kernel: lp0: console ready
Jan 20 11:32:54 believer kernel: kjournald starting.  Commit interval 5 seconds
Jan 20 11:32:54 believer kernel: EXT3 FS on hda4, internal journal
Jan 20 11:32:54 believer kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jan 20 11:32:54 believer kernel: NTFS volume version 3.1.
Jan 20 11:32:55 believer logger: /etc/rc.d/rc.inet1:  /sbin/ifconfig lo 127.0.0.1
Jan 20 11:32:55 believer logger: /etc/rc.d/rc.inet1:  /sbin/route add -net 127.0.0.0 netmask 255.0.0.0 lo
Jan 20 11:32:57 believer kernel: NET: Registered protocol family 10
Jan 20 11:32:57 believer kernel: lo: Disabled Privacy Extensions
Jan 20 11:32:57 believer sshd[3195]: Server listening on :: port 22.
Jan 20 11:32:57 believer sshd[3195]: Server listening on 0.0.0.0 port 22.
Jan 20 11:32:57 believer ntpd[3202]: ntpd 4.2.4p5@1.1541-o Sat Nov 29 15:44:24 UTC 2008 (1)
Jan 20 11:32:57 believer ntpd[3203]: precision = 1.000 usec
Jan 20 11:32:57 believer ntpd[3203]: Listening on interface #0 wildcard, 0.0.0.0#123 Disabled
Jan 20 11:32:57 believer ntpd[3203]: Listening on interface #1 wildcard, ::#123 Disabled
Jan 20 11:32:57 believer ntpd[3203]: Listening on interface #2 lo, ::1#123 Enabled
Jan 20 11:32:57 believer ntpd[3203]: Listening on interface #3 lo, 127.0.0.1#123 Enabled
Jan 20 11:32:57 believer ntpd[3203]: kernel time sync status 0040
Jan 20 11:32:57 believer ntpd[3203]: frequency initialized 0.000 PPM from /etc/ntp/drift
Jan 20 11:32:57 believer acpid: starting up 
Jan 20 11:32:57 believer acpid: 1 rule loaded 
Jan 20 11:32:57 believer acpid: waiting for events: event logging is off 
Jan 20 11:33:05 believer acpid: client connected from 3266[82:82] 
Jan 20 11:33:05 believer acpid: 1 client rule loaded 
Jan 20 11:33:07 believer hcid[3303]: Bluetooth HCI daemon
Jan 20 11:33:07 believer kernel: Bluetooth: Core ver 2.13
Jan 20 11:33:07 believer kernel: NET: Registered protocol family 31
Jan 20 11:33:07 believer kernel: Bluetooth: HCI device and connection manager initialized
Jan 20 11:33:07 believer kernel: Bluetooth: HCI socket layer initialized
Jan 20 11:33:07 believer hcid[3303]: Starting SDP server
Jan 20 11:33:07 believer kernel: Bluetooth: L2CAP ver 2.11
Jan 20 11:33:07 believer kernel: Bluetooth: L2CAP socket layer initialized
Jan 20 11:33:07 believer kernel: Bluetooth: RFCOMM socket layer initialized
Jan 20 11:33:07 believer kernel: Bluetooth: RFCOMM TTY layer initialized
Jan 20 11:33:07 believer kernel: Bluetooth: RFCOMM ver 1.10
Jan 20 11:33:07 believer hcid[3303]: Registered manager path:/org/bluez/serial
Jan 20 11:33:07 believer hcid[3303]: Unix socket created: 12
Jan 20 11:33:07 believer hcid[3303]: Registered manager path:/org/bluez/audio
Jan 20 11:33:08 believer kernel: Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Jan 20 11:33:08 believer kernel: Bluetooth: BNEP filters: protocol multicast
Jan 20 11:33:08 believer kernel: Bridge firewalling registered
Jan 20 11:33:08 believer hcid[3303]: bridge pan0 created
Jan 20 11:33:08 believer hcid[3303]: Registered manager path:/org/bluez/network
Jan 20 11:33:08 believer hcid[3303]: Registered input manager path:/org/bluez/input
Jan 20 11:33:12 believer /usr/sbin/gpm[3452]: *** info [startup.c(95)]: 
Jan 20 11:33:12 believer /usr/sbin/gpm[3452]: Started gpm successfully. Entered daemon mode.
Jan 20 11:33:29 believer acpid: client connected from 3533[0:100] 
Jan 20 11:33:29 believer acpid: 1 client rule loaded 
Jan 20 11:33:30 believer kernel: [drm] Initialized drm 1.1.0 20060810
Jan 20 11:33:30 believer kernel: pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 20 11:33:30 believer kernel: [drm] Initialized radeon 1.29.0 20080528 on minor 0
Jan 20 11:33:31 believer kernel: agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
Jan 20 11:33:31 believer kernel: agpgart-amd64 0000:00:00.0: putting AGP V3 device into 8x mode
Jan 20 11:33:31 believer kernel: pci 0000:01:00.0: putting AGP V3 device into 8x mode
Jan 20 11:33:31 believer kernel: [drm] Setting GART location based on new memory map
Jan 20 11:33:31 believer kernel: [drm] Loading R300 Microcode
Jan 20 11:33:31 believer kernel: [drm] Num pipes: 1
Jan 20 11:33:31 believer kernel: [drm] writeback test succeeded in 1 usecs
Jan 20 11:36:12 believer ntpd[3203]: synchronized to LOCAL(0), stratum 10
Jan 20 11:36:12 believer ntpd[3203]: kernel time sync status change 0001

--------------050507060908090800090905
Content-Type: application/octet-stream;
 name="image.dat"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="image.dat"

AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
--------------050507060908090800090905--
