Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:37332
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933038Ab3ECT5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 May 2013 15:57:48 -0400
Received: from [24.206.66.147] (helo=saxophone.orchestra)
	by elasmtp-spurfowl.atl.sa.earthlink.net with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67)
	(envelope-from <thebitpit@earthlink.net>)
	id 1UYM0G-0002uc-CO
	for linux-media@vger.kernel.org; Fri, 03 May 2013 15:50:48 -0400
Message-ID: <51841517.4030504@earthlink.net>
Date: Fri, 03 May 2013 14:50:47 -0500
From: The Bit Pit <thebitpit@earthlink.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Driver for KWorld UB435Q Version 3 (ATSC)  USB id: 1b80:e34c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am Wilson Michaels, please let me introduce myself:

Eight years ago I contributed a driver for the DViCO FusionHDTV 3 & 5
PCI TV tuner cards (see lgdt330x.c).  The code is still in linux today.
 One of my tuners is starting to fail so a purchased a KWorld UB435Q
Version 3 (ATSC) from Newegg.  It's not supported so I started working
on a driver. Is anyone else working on a driver for the  KWorld UB435Q V-3?

I opened the case easily as it just snaps together with a plastic clip.
It is not glued :-) I verified that it contains:
EM2874B
NXP TDA18272/M
lgdt3305

I git the latest media_build tree and added entries to make it recognize
the KWorld USB id: 1b80:e34c.  The added code is like the KWorld UB435Q
Version 2 code with lgdt3304 replaced by lgdt3305 and no .dvb_gpio or
.tuner_gpio. It reports finding an em2874 chip using bulk transfer mode
as expected.  There appears to be code in the em28xx driver to handle
bulk transfer.  It does not recognize the lgdt3305.

I discovered (brute force scan) that there are two i2c addresses 0x50
and 0xd0. The lgdt3305 detection code is able to read something from
either i2c address, but is is always 0.

Does the eeprom data below have anything to help writing a driver for
the KWorld UB435Q?

I suspect some initialization needs to be done, but I don't know what to
try.  Does anyone have any information about how the hardware is
configured or information captured from the Windows driver?

Does anyone know where I can get a copy of the programming spec for the
lgdt3305?  The em2874 spec would be useful too.

Here is the dmsg after plugging in the KWorld UB435Q v-3:

[  566.649812] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0010
[  566.650257] hub 1-1:1.0: port 4, status 0101, change 0001, 12 Mb/s
[  566.753819] hub 1-1:1.0: debounce: port 4: total 100ms stable 100ms
status 0x101
[  566.764810] hub 1-1:1.0: port 4 not reset yet, waiting 10ms
[  566.826760] usb 1-1.4: new high-speed USB device number 4 using ehci_hcd
[  566.837765] hub 1-1:1.0: port 4 not reset yet, waiting 10ms
[  566.912465] usb 1-1.4: default language 0x0409
[  566.912830] usb 1-1.4: udev 4, busnum 1, minor = 3
[  566.912836] usb 1-1.4: New USB device found, idVendor=1b80,
idProduct=e34c
[  566.912838] usb 1-1.4: New USB device strings: Mfr=0, Product=1,
SerialNumber=2
[  566.912841] usb 1-1.4: Product: USB 2875 Device
[  566.912844] usb 1-1.4: SerialNumber: 1
[  566.912930] usb 1-1.4: usb_probe_device
[  566.912932] usb 1-1.4: configuration #1 chosen from 1 choice
[  566.913034] usb 1-1.4: adding 1-1.4:1.0 (config #1, interface 0)
[  566.962815] em28xx 1-1.4:1.0: usb_probe_interface
[  566.962818] em28xx 1-1.4:1.0: usb_probe_interface - got id
[  566.962822] em28xx: New device  USB 2875 Device @ 480 Mbps
(1b80:e34c, interface 0, class 0)
[  566.962823] em28xx: DVB interface 0 found: bulk
[  566.962916] em28xx: chip ID is em2874
[  567.037248] em2874 #0: i2c eeprom 0000: 26 00 01 00 02 09 0f e5 f5 64
01 60 09 e5 f5 64
[  567.037260] em2874 #0: i2c eeprom 0010: 09 60 03 c2 c6 22 e5 f7 b4 03
13 e5 f6 b4 87 03
[  567.037269] em2874 #0: i2c eeprom 0020: 02 08 a3 e5 f6 b4 93 03 02 07
58 c2 c6 22 c2 c6
[  567.037278] em2874 #0: i2c eeprom 0030: 22 00 60 00 ef 70 08 85 3a 82
85 39 83 93 ff ef
[  567.037288] em2874 #0: i2c eeprom 0040: 60 19 85 3a 82 85 39 83 e4 93
12 06 67 12 08 f5
[  567.037297] em2874 #0: i2c eeprom 0050: 05 3a e5 3a 70 02 05 39 1f 80
e4 22 12 08 fd 02
[  567.037306] em2874 #0: i2c eeprom 0060: 06 02 02 00 1a eb 67 95 80 1b
4c e3 d0 13 6c 00
[  567.037315] em2874 #0: i2c eeprom 0070: 6a 20 8a 04 00 00 24 57 00 5c
39 00 00 00 00 00
[  567.037330] em2874 #0: i2c eeprom 0080: 00 00 00 00 44 00 00 00 f0 10
44 00 00 00 00 00
[  567.037334] em2874 #0: i2c eeprom 0090: 5b 1c c0 00 00 00 20 40 20 80
02 20 01 01 00 00
[  567.037338] em2874 #0: i2c eeprom 00a0: 00 00 00 00 00 00 00 04 00 00
00 00 00 00 00 00
[  567.037342] em2874 #0: i2c eeprom 00b0: c6 40 00 00 00 00 87 00 00 80
00 00 00 00 00 00
[  567.037346] em2874 #0: i2c eeprom 00c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 20 03
[  567.037349] em2874 #0: i2c eeprom 00d0: 55 00 53 00 42 00 20 00 32 00
38 00 37 00 35 00
[  567.037353] em2874 #0: i2c eeprom 00e0: 20 00 44 00 65 00 76 00 69 00
63 00 65 00 04 03
[  567.037357] em2874 #0: i2c eeprom 00f0: 31 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  567.037361] em2874 #0: i2c eeprom 0100: ... (skipped)
[  567.037363] em2874 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x5d3e97ab
[  567.037363] em2874 #0: EEPROM info:
[  567.037364] em2874 #0:       microcode start address = 0x0004, boot
configuration = 0x01
[  567.061606] em2874 #0:       No audio on board.
[  567.061610] em2874 #0:       500mA max power
[  567.061612] em2874 #0:       Table at offset 0x00, strings=0x0000,
0x0000, 0x0000
[  567.061615] em2874 #0: Identified as KWorld UB435-Q v-3 (ATSC) (card=89)
[  567.061618] em2874 #0: v4l2 driver version 0.2.0
[  567.066790] em2874 #0: V4L2 video device registered as video2
[  567.066792] em2874 #0: dvb set to bulk mode.
[  567.067231] usbcore: registered new interface driver em28xx

### The following is my added debugging code to dump the value read by
### the first read in the lgdt3305 detection code.
### This prints only if the read status is OK
[  567.104291] lgdt3305_attach: read register - val = 0x00

### The write status following the first read is OK.
### The following is printed during the second read in the lgdt3305  ###
detection code.
[  567.105290] lgdt3305_read_reg: error (addr 50 reg 0808 error (ret == -19)
[  567.105292] lgdt3305_attach: error -19 on line 1152
[  567.105294] lgdt3305_attach: unable to detect LGDT3305 hardware - val
= 0x00
[  567.105298] em2874 #0: /2: frontend initialization failed
[  567.105300] Em28xx: Initialized (Em28xx dvb Extension) extension
