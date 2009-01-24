Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:11883 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZAXI4d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 03:56:33 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2822742fgg.17
        for <linux-media@vger.kernel.org>; Sat, 24 Jan 2009 00:56:31 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 24 Jan 2009 09:56:31 +0100
Message-ID: <6fd6e6490901240056u59e275b2nc82e755123ffc87b@mail.gmail.com>
Subject: Volar X remote control problem
From: Felipe Morales <felipe.morales.moreno@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I've successfully managed to use the remote RM-KS using the patch
below in a Acer Aspire 5020 laptop. I can evtest the input device and
get the correct keycodes. The lsusb of that machine is:

00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 01)
00:02.0 PCI bridge: ATI Technologies Inc RS480 PCI-X Root Port
00:06.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
00:07.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller
00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller
00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host Controller
00:14.0 SMBus: ATI Technologies Inc IXP SB400 SMBus Controller (rev 11)
00:14.1 IDE interface: ATI Technologies Inc IXP SB400 IDE Controller
00:14.3 ISA bridge: ATI Technologies Inc IXP SB400 PCI-ISA Bridge
00:14.4 PCI bridge: ATI Technologies Inc IXP SB400 PCI-PCI Bridge
00:14.5 Multimedia audio controller: ATI Technologies Inc IXP SB400
AC'97 Audio Controller (rev 02)
00:14.6 Modem: ATI Technologies Inc SB400 AC'97 Modem Controller (rev 02)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
01:00.0 VGA compatible controller: ATI Technologies Inc M24 1P [Radeon
Mobility X600]
06:05.0 Network controller: Broadcom Corporation BCM4318 [AirForce One
54g] 802.11g Wireless LAN Controller (rev 02)
06:06.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
06:06.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE
1394 Host Controller
06:06.3 Mass storage controller: Texas Instruments PCIxx21 Integrated
FlashMedia Controller
06:06.4 SD Host controller: Texas Instruments
PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller
06:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
Gigabit Ethernet (rev 10)

But I've tried to used it in both on a HP Pavillion dv1000 and an
eeepc, and, although everything loads fine, I can only get the first
remote command, and then it overflows with a value like ^[ or ^K or
something different depending on the button pressed, and then the
system becomes useless until I disconnect the Volar X from USB.

$ evtest /dev/input/by-path/pci-3-3-event-ir
Input driver version is 1.0.0
Input device ID: bus 0x3 vendor 0x7ca product 0xa815 version 0x200
Input device name: "IR-receiver inside an USB DVB receiver"
Supported events:
 Event type 0 (Sync)
 Event type 1 (Key)
   Event code 2 (1)
   Event code 3 (2)
   Event code 4 (3)
   Event code 5 (4)
   Event code 6 (5)
   Event code 7 (6)
   Event code 8 (7)
   Event code 9 (8)
   Event code 10 (9)
   Event code 11 (0)
   Event code 105 (Left)
   Event code 106 (Right)
   Event code 113 (Mute)
   Event code 114 (VolumeDown)
   Event code 115 (VolumeUp)
   Event code 116 (Power)
   Event code 128 (Stop)
   Event code 139 (Menu)
   Event code 148 (Prog1)
   Event code 149 (Prog2)
   Event code 158 (Back)
   Event code 159 (Forward)
   Event code 164 (PlayPause)
   Event code 167 (Record)
   Event code 202 (Prog3)
   Event code 207 (Play)
   Event code 365 (EPG)
   Event code 372 (Zoom)
   Event code 388 (Text)
   Event code 392 (Audio)
   Event code 402 (ChannelUp)
   Event code 403 (ChannelDown)
   Event code 404 (First)
   Event code 405 (Last)
Testing ... (interrupt to exit)
Event: time 1232785830.707890, type 1 (Key), code 3 (2), value 1
Event: time 1232785830.707903, type 1 (Key), code 3 (2), value 0
Event: time 1232785830.707906, -------------- Report Sync ------------
^K^K^K^K^K^K^K^K^K^K^K^K^K^K^K^K^K^K^K^K^K^K^K^K...... and so on

The lsusb of the pavillion is:
00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82852/855GM
Integrated Graphics Device (rev 02)
00:02.1 Display controller: Intel Corporation 82852/855GM Integrated
Graphics Device (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M)
USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface
Bridge (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE
Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
SMBus Controller (rev 03)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
AC'97 Modem Controller (rev 03)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
02:06.0 Network controller: Intel Corporation PRO/Wireless 2200BG
[Calexico2] Network Connection (rev 05)
02:09.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
02:09.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE
1394 Host Controller
02:09.3 Mass storage controller: Texas Instruments PCIxx21 Integrated
FlashMedia Controller
02:09.4 SD Host controller: Texas Instruments
PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller

The same behavior repeats in the eeepc 1000H. I'm using Debian testing
on the three machines, with the same 2.6.26 kernel. The drivers I've
tried are the ones from
http://linuxtv.org/hg/v4l-dvb/archive/tip.tar.gz, with the Volar X
RM-KS patch applied.

Does anybody have any clue why this happens?

Thanks a lot
