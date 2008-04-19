Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3JH0WeK031581
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 13:00:32 -0400
Received: from imo-m12.mail.aol.com (imo-m12.mx.aol.com [64.12.143.100])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3JH0Gkb032165
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 13:00:16 -0400
Received: from JonLowe@aol.com
	by imo-m12.mx.aol.com (mail_out_v38_r9.3.) id e.bde.2d627df3 (37540)
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 13:00:08 -0400 (EDT)
To: video4linux-list@redhat.com
Date: Sat, 19 Apr 2008 13:00:08 -0400
MIME-Version: 1.0
From: Jon Lowe <jonlowe@aol.com>
Message-Id: <8CA7055F5299145-D6C-10A4@webmail-me16.sysops.aol.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: [BUG} Installing latest Mercurial V4L drivers breaks builtin webcam
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


 Installed latest V4L drivers to get HVR-1500 working; it DOES!.? Syntek webcam on ASUS f3SV laptop stopped working using the stk11xx driver.? dmesg output below.? This has also been reported on HP Pavilions (http://aldeby.org/blog/?page_id=87#tv), which use an HP branded version of the HVR-1500 with a different webcam, so it doesn't appear to be webcam brand specific.

Ubuntu 8.04, kernel 2.6.24-16


 


Jon Lowe

Applicable dmesg output:
[?? 37.672382] Linux video capture interface: v2.00
[?? 37.759704] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/LNXVIDEO:00/input/input7
[?? 37.804224] ACPI: Video Device [VGA] (multi-head: yes? rom: no? post: no)
[?? 37.830372] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[?? 37.830383] PCI: Setting latency timer of device 0000:02:00.0 to 64
[?? 37.831247] atl1 0000:02:00.0: version 2.0.7
[?? 37.853266] usb 2-2: configuration #1 chosen from 1 choice
[?? 37.892214] nvidia: module license 'NVIDIA' taints kernel.
[?? 38.186920] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[?? 38.186928] PCI: Setting latency timer of device 0000:01:00.0 to 64
[?? 38.187032] NVRM: loading NVIDIA UNIX x86_64 Kernel Module? 169.12? Thu Feb 14 17:51:09 PST 2008
[?? 38.230672] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.0
[?? 38.230676] iwl3945: Copyright(c) 2003-2007 Intel Corporation
[?? 38.230772] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[?? 38.230785] PCI: Setting latency timer of device 0000:03:00.0 to 64
[?? 38.231627] iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
[?? 38.247553] stk11xx: disagrees about version of symbol video_devdata
[?? 38.247556] stk11xx: Unknown symbol video_devdata
[?? 38.247671] stk11xx: disagrees about version of symbol video_unregister_device
[?? 38.247673] stk11xx: Unknown symbol video_unregister_device
[?? 38.247712] stk11xx: disagrees about version of symbol video_device_alloc
[?? 38.247713] stk11xx: Unknown symbol video_device_alloc
[?? 38.247731] stk11xx: disagrees about version of symbol video_register_device
[?? 38.247733] stk11xx: Unknown symbol video_register_device
[?? 38.247794] stk11xx: disagrees about version of symbol video_device_release
[?? 38.247796] stk11xx: Unknown symbol video_device_release
[?? 38.388126] mmcblk0: mmc0:0002 SD??? 8067072KiB 
[?? 38.388158]? mmcblk0: p1
[?? 38.395941] Bluetooth: Core ver 2.11
[?? 38.396009] NET: Registered protocol family 31
[?? 38.396011] Bluetooth: HCI device and connection manager initialized
[?? 38.396013] Bluetooth: HCI socket layer initialized
[?? 38.419583] iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
[?? 38.423149] wmaster0: Selected rate control algorithm 'iwl-3945-rs'
[?? 38.449534] Bluetooth: HCI USB driver ver 2.9
[?? 38.452372] usbcore: registered new interface driver hci_usb
[?? 38.487213] cx23885 driver version 0.0.1 loaded
[?? 38.487277] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[?? 38.487288] CORE cx23885[0]: subsystem: 0070:7797, board: Hauppauge WinTV-HVR1500Q [card=5,autodetected]
[?? 38.588760] cx23885[0]: i2c bus 0 registered
[?? 38.588776] cx23885[0]: i2c bus 1 registered
[?? 38.588789] cx23885[0]: i2c bus 2 registered
[?? 38.615881] tveeprom 0-0050: Hauppauge model 77041, rev E2F0, serial# 3617992
[?? 38.615884] tveeprom 0-0050: MAC address is 00-0D-FE-37-34-C8
[?? 38.615886] tveeprom 0-0050: tuner model is Xceive XC5000 (idx 150, type 4)
[?? 38.615888] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
[?? 38.615890] tveeprom 0-0050: audio processor is CX23885 (idx 39)
[?? 38.615892] tveeprom 0-0050: decoder processor is CX23885 (idx 33)
[?? 38.615893] tveeprom 0-0050: has no radio, has no IR receiver, has no IR transmitter
[?? 38.615895] cx23885[0]: hauppauge eeprom: model=77041
[?? 38.615897] cx23885[0]: cx23885 based dvb card
[?? 38.728512] xc5000: Successfully identified at address 0x61
[?? 38.728516] xc5000: Firmware has been loaded previously
[?? 38.728519] DVB: registering new adapter (cx23885[0])
[?? 38.728522] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
[?? 38.728723] cx23885_dev_checkrevision() Hardware revision = 0xb0
[?? 38.728730] cx23885[0]/0: found at 0000:06:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfe800000


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
