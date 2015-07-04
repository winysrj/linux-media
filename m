Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.leissner.se ([212.3.1.210]:35412 "EHLO
	mailgate.leissner.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbGEIcH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2015 04:32:07 -0400
Received: from mailgate.leissner.se (localhost [127.0.0.1])
	by mailgate.leissner.se (8.15.1/8.15.1) with ESMTP id t64B7L8c062288
	for <linux-media@vger.kernel.org>; Sat, 4 Jul 2015 13:07:21 +0200 (CEST)
	(envelope-from pf@leissner.se)
Received: (from uucp@localhost)
	by mailgate.leissner.se (8.15.1/8.15.1/Submit) id t64B7K9U062287
	for <linux-media@vger.kernel.org>; Sat, 4 Jul 2015 13:07:20 +0200 (CEST)
	(envelope-from pf@leissner.se)
Received: from nic-i.leissner.se (localhost [127.0.0.1])
	by nic-i.leissner.se (8.15.1/8.15.1) with ESMTP id t64B7H7u085956
	for <linux-media@vger.kernel.org>; Sat, 4 Jul 2015 13:07:17 +0200 (CEST)
	(envelope-from pf@leissner.se)
Received: from localhost (pf@localhost)
	by nic-i.leissner.se (8.15.1/8.14.9/Submit) with ESMTP id t64B7H08085953
	for <linux-media@vger.kernel.org>; Sat, 4 Jul 2015 13:07:17 +0200 (CEST)
	(envelope-from pf@leissner.se)
Date: Sat, 4 Jul 2015 13:07:17 +0200 (SST)
From: Peter Fassberg <pf@leissner.se>
To: linux-media@vger.kernel.org
Subject: PCTV Triplestick and Raspberry Pi B+
Message-ID: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

I'm trying to get PCTV TripleStick 292e working in a Raspberry Pi B+ environment.

I have no problem getting DVB-T to work, but I can't tune to any DVB-T2 channels. I have tried with three different kernels: 3.18.11, 3.18.16 and 4.0.6.  Same problem.  I also cloned the media_build under 4.0.6 to no avail.

The same physical stick works perfectly with DVB-T2 in an Intel platform using kernel 3.16.0.

Do you have any suggestions what I can do to get this running or is there a known problem with Raspberry/ARM?



Best regards,

Peter Fassberg
Sweden

----------

>From dmesg:


Working Debian:
Linux debian-usb 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1 (2015-05-24) x86_64 GNU/Linux

[   10.148481] media: Linux media interface: v0.10
[   10.154268] Linux video capture interface: v2.00
[  549.805030] usb 2-2: new high-speed USB device number 8 using xhci_hcd
[  549.933927] usb 2-2: New USB device found, idVendor=2013, idProduct=025f
[  549.933931] usb 2-2: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[  549.933933] usb 2-2: Product: PCTV 292e
[  549.933935] usb 2-2: Manufacturer: PCTV
[  549.933936] usb 2-2: SerialNumber: 0011477026
[  550.955796] em28xx: New device PCTV PCTV 292e @ 480 Mbps (2013:025f, interface 0, class 0)
[  550.955805] em28xx: DVB interface 0 found: isoc
[  550.955875] em28xx: chip ID is em28178
[  552.918404] em28178 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x5110ff04
[  552.918411] em28178 #0: EEPROM info:
[  552.918414] em28178 #0:      microcode start address = 0x0004, boot configuration = 0x01
[  552.925114] em28178 #0:      AC97 audio (5 sample rates)
[  552.925123] em28178 #0:      500mA max power
[  552.925128] em28178 #0:      Table at offset 0x27, strings=0x146a, 0x1888, 0x0a7e
[  552.925245] em28178 #0: Identified as PCTV tripleStick (292e) (card=94)
[  552.925250] em28178 #0: dvb set to isoc mode.
[  552.925350] usbcore: registered new interface driver em28xx
[  552.939512] em28178 #0: Binding DVB extension
[  552.947676] i2c i2c-10: Added multiplexed i2c bus 11
[  552.947683] si2168 10-0064: si2168: Silicon Labs Si2168 successfully attached
[  552.952791] si2157 11-0060: si2157: Silicon Labs Si2157 successfully attached
[  552.952803] DVB: registering new adapter (em28178 #0)
[  552.952810] usb 2-2: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
[  552.954155] em28178 #0: DVB extension successfully initialized
[  552.954161] em28xx: Registered (Em28xx dvb Extension) extension
[  552.960517] em28178 #0: Registering input extension
[  552.987528] Registered IR keymap rc-pinnacle-pctv-hd
[  552.987649] input: em28xx IR (em28178 #0) as /devices/pci0000:00/0000:00:14.0/usb2/2-2/rc/rc0/input26
[  552.987786] rc0: em28xx IR (em28178 #0) as /devices/pci0000:00/0000:00:14.0/usb2/2-2/rc/rc0
[  552.987904] em28178 #0: Input extension successfully initalized
[  552.987908] em28xx: Registered (Em28xx Input Extension) extension
[ 1268.446509] si2168 10-0064: si2168: found a 'Silicon Labs Si2168' in cold state
[ 1268.446564] si2168 10-0064: firmware: direct-loading firmware dvb-demod-si2168-02.fw
[ 1268.446574] si2168 10-0064: si2168: downloading firmware from file 'dvb-demod-si2168-02.fw'
[ 1268.604691] si2168 10-0064: si2168: found a 'Silicon Labs Si2168' in warm state



Non-working Raspberry:
Linux raspberrypi 4.0.6-v7+ #798 SMP PREEMPT Tue Jun 23 18:06:01 BST 2015 armv7l GNU/Linux

[    0.000000] Linux version 4.0.6-v7+ (dc4@dc4-XPS13-9333) (gcc version 4.8.3 20140303 (prerelease) (crosstool-NG linaro-1.13.1+bzr2650 - Linaro GCC 2014.03) ) #798 SMP PREEMPT Tue Jun 23 18:06:01 BST 2015
[    0.000000] CPU: ARMv7 Processor [410fc075] revision 5 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine model: Raspberry Pi 2 Model B Rev 1.1
[    7.200879] media: Linux media interface: v0.10
[    7.223037] Linux video capture interface: v2.00
[    7.245815] em28xx: New device PCTV PCTV 292e @ 480 Mbps (2013:025f, interface 0, class 0)
[    7.256731] em28xx: DVB interface 0 found: isoc
[    7.262712] em28xx: chip ID is em28178
[    9.258341] em28178 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x5110ff04
[    9.267163] em28178 #0: EEPROM info:
[    9.272644] em28178 #0:      microcode start address = 0x0004, boot configuration = 0x01
[    9.291418] em28178 #0:      AC97 audio (5 sample rates)
[    9.298231] em28178 #0:      500mA max power
[    9.303993] em28178 #0:      Table at offset 0x27, strings=0x146a, 0x1888, 0x0a7e
[    9.313288] em28178 #0: Identified as PCTV tripleStick (292e) (card=94)
[    9.321852] em28178 #0: dvb set to isoc mode.
[    9.328536] usbcore: registered new interface driver em28xx
[    9.357476] em28178 #0: Binding DVB extension
[    9.380909] i2c i2c-1: Added multiplexed i2c bus 2
[    9.389469] si2168 1-0064: Silicon Labs Si2168 successfully attached
[    9.410263] si2157 2-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
[    9.422419] DVB: registering new adapter (em28178 #0)
[    9.428929] usb 1-1.4: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
[    9.442954] em28178 #0: DVB extension successfully initialized
[    9.450692] em28xx: Registered (Em28xx dvb Extension) extension
[    9.482115] em28178 #0: Registering input extension
[    9.529742] Registered IR keymap rc-pinnacle-pctv-hd
[    9.538138] input: em28xx IR (em28178 #0) as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.4/rc/rc0/input0
[    9.551330] rc0: em28xx IR (em28178 #0) as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.4/rc/rc0
[    9.563907] em28178 #0: Input extension successfully initalized
[    9.571364] em28xx: Registered (Em28xx Input Extension) extension
[  297.703612] si2168 1-0064: found a 'Silicon Labs Si2168-B40'
[  300.998391] si2168 1-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
[  301.275434] si2168 1-0064: firmware version: 4.0.4
[  301.284625] si2157 2-0060: found a 'Silicon Labs Si2157-A30'
[  301.340643] si2157 2-0060: firmware version: 3.0.5

----------

