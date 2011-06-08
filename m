Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58947 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1FHDKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 23:10:11 -0400
Received: by vws1 with SMTP id 1so61343vws.19
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2011 20:10:11 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Jun 2011 21:10:10 -0600
Message-ID: <BANLkTikSacfHp6ndaf8FPJi-PDu-PFSTsg@mail.gmail.com>
Subject: Getting IR to work on a hvr-1250 tuner.
From: Dark Shadow <shadowofdarkness@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I have a capture card that was sold as a Hauppauge HVR-1250 (according
to the box) that I am trying to use but I am having trouble getting
all it's features at once. When I leave it auto detected by the module
I have working TV in MythTV even though it thinks it is a 1270 but IR
isn't setup.

dmesg outputs
#modprobe cx23885 enable_885_ir=1
[    7.592714] cx23885 driver version 0.0.2 loaded
[    7.592748] cx23885 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.592926] CORE cx23885[0]: subsystem: 0070:2211, board: Hauppauge
WinTV-HVR1270 [card=18,autodetected]
[    7.728163] IR JVC protocol handler initialized
[    7.738971] tveeprom 0-0050: Hauppauge model 22111, rev C2F5, serial# 6429897
[    7.738974] tveeprom 0-0050: MAC address is 00:0d:fe:62:1c:c9
[    7.738975] tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155, type 54)
[    7.738977] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[    7.738979] tveeprom 0-0050: audio processor is CX23888 (idx 40)
[    7.738980] tveeprom 0-0050: decoder processor is CX23888 (idx 34)
[    7.738982] tveeprom 0-0050: has no radio, has IR receiver, has no
IR transmitter
[    7.738983] cx23885[0]: hauppauge eeprom: model=22111
[    7.738985] cx23885_dvb_register() allocating 1 frontend(s)
[    7.738991] cx23885[0]: cx23885 based dvb card
[    7.961122] IR Sony protocol handler initialized
[    7.977301] tda18271 1-0060: creating new instance
[    7.979325] TDA18271HD/C2 detected @ 1-0060
[    8.209663] DVB: registering new adapter (cx23885[0])
[    8.209668] DVB: registering adapter 0 frontend 0 (LG Electronics
LGDT3305 VSB/QAM Frontend)...
[    8.210095] cx23885_dev_checkrevision() Hardware revision = 0xd0
[    8.210101] cx23885[0]/0: found at 0000:07:00.0, rev: 4, irq: 17,
latency: 0, mmio: 0xf7c00000
[    8.210109] cx23885 0000:07:00.0: setting latency timer to 64
[    8.210186] cx23885 0000:07:00.0: irq 49 for MSI/MSI-X


When I force it to be a 1250 no video works but IR seems to show up
(with the exception that it never seems to receive signals from the
remote)

#modprobe cx23885 enable_885_ir=1 card=3
[38647.660740] cx23885 driver version 0.0.2 loaded
[38647.660779] cx23885 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[38647.661009] CORE cx23885[0]: subsystem: 0070:2211, board: Hauppauge
WinTV-HVR1250 [card=3,insmod option]
[38647.787427] tveeprom 0-0050: Hauppauge model 22111, rev C2F5, serial# 6429897
[38647.787431] tveeprom 0-0050: MAC address is 00:0d:fe:62:1c:c9
[38647.787434] tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155, type 54)
[38647.787437] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[38647.787439] tveeprom 0-0050: audio processor is CX23888 (idx 40)
[38647.787442] tveeprom 0-0050: decoder processor is CX23888 (idx 34)
[38647.787444] tveeprom 0-0050: has no radio, has IR receiver, has no
IR transmitter
[38647.787447] cx23885[0]: hauppauge eeprom: model=22111
[38647.824508] cx25840 2-0044: cx23888 A/V decoder found @ 0x88 (cx23885[0])
[38648.457502] cx25840 2-0044: loaded v4l-cx23885-avcore-01.fw
firmware (16382 bytes)
[38648.465061] cx23885_dvb_register() allocating 1 frontend(s)
[38648.465064] cx23885[0]: cx23885 based dvb card
[38648.492632] cx23885[0]: frontend initialization failed
[38648.492637] cx23885_dvb_register() dvb_register failed err = -22
[38648.492640] cx23885_dev_setup() Failed to register dvb on VID_C
[38648.492644] cx23885_dev_checkrevision() Hardware revision = 0xd0
[38648.492650] cx23885[0]/0: found at 0000:07:00.0, rev: 4, irq: 17,
latency: 0, mmio: 0xf7c00000
[38648.492660] cx23885 0000:07:00.0: setting latency timer to 64
[38648.492740] cx23885 0000:07:00.0: irq 48 for MSI/MSI-X
[38648.539598] Registered IR keymap rc-hauppauge
[38648.539775] input: cx23885 IR (Hauppauge WinTV-HVR1250) as
/devices/pci0000:00/0000:00:1c.1/0000:07:00.0/rc/rc0/input4
[38648.539852] rc0: cx23885 IR (Hauppauge WinTV-HVR1250) as
/devices/pci0000:00/0000:00:1c.1/0000:07:00.0/rc/rc0
[38648.539926] rc rc0: lirc_dev: driver ir-lirc-codec (cx23885)
registered at minor = 0


My setup commands for it's settings when using card=3

(I have read this is needed for this remote although according to the
Internet my grey remote is supposed to need a "hauppauge=1" parameter
but it doesn't exist (modinfo) in my version of the module from kernel
3.0-rc1
#modprobe ir-kbd-i2c

#ir-keytable -a /etc/rc_maps.cfg
Old keytable cleared
Wrote 136 keycode(s) to driver
Protocols changed to RC-5

#lsinput
/dev/input/event4
   bustype : BUS_PCI
   vendor  : 0x70
   product : 0x2211
   version : 1
   name    : "cx23885 IR (Hauppauge WinTV-HVR1"
   phys    : "pci-0000:07:00.0/ir0"
   bits ev : EV_SYN EV_KEY EV_MSC EV_REP

#lspci -v (plus a little -n)
07:00.0 0400: 14f1:8880 (rev 04)
	Subsystem: 0070:2211

07:00.0 Multimedia video controller: Conexant Systems, Inc. Hauppauge
Inc. HDPVR-1250 model 1196 (rev 04)
	Subsystem: Hauppauge computer works Inc. Device 2211
	Flags: bus master, fast devsel, latency 0, IRQ 48
	Memory at f7c00000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express Endpoint, MSI 00
	Capabilities: [80] Power Management version 3
	Capabilities: [90] Vital Product Data <?>
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: cx23885
	Kernel modules: cx23885


I have heard this should show up as a normal keyboard to the system
but no button presses cause anything to happen to the system and
trying lirc with devinput (with devinput lircd.conf) and then opening
irw doesn't show any button presses either
