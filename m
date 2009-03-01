Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:23774 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbZCATDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2009 14:03:22 -0500
Received: from e177043048.adsl.alicedsl.de ([85.177.43.48] helo=[192.168.0.124])
	by mail.uni-paderborn.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63 hoth)
	id 1LdqwW-0006AE-Rl
	for linux-media@vger.kernel.org; Sun, 01 Mar 2009 20:03:17 +0100
Message-ID: <49AADC5E.6090809@campus.upb.de>
Date: Sun, 01 Mar 2009 20:05:02 +0100
From: David Woitkowski <jarrn@campus.upb.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Using tm6010 for Haupauge WinTV-HVR 900H
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Reposted from linux-dvb because mailman told me linux-dvb is to be
replaced with linux-media. If you've already read this, just skip.]




Hi out there

I'm in the unfortunate position of having bought a 900H instead of a 900
and now I'm fiddling with the driver.

Details:
$ lsusb | grep Hauppauge
Bus 008 Device 004: ID 2040:6600 Hauppauge

My machine is running Ubuntu 8.10 with a 2.6.27-11-generic kernel. The
correct kernel-headers are installed.

As far as I've read there is (limited) support for the device with the
tm6010 driver. Putting together some info from the web I did the following:

$ hg clone http://linuxtv.org/hg/v4l-dvb
$ cd v4l-dvb
$ hg pull -u http://linuxtv.org/hg/~mchehab/tm6010

Inserted into v4l-dvb/v4l/.config three lines:
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_DVB=m

$ hg merge
$ make

and as root:
# make install

This far everything worked without error.

Then I got the Firmware the card was requesting in the dmesg-output from
http://steventoth.net/linux/hvr1400/xc3028L-v36.fw and copied it to /lib
/firmware

Since there is no Module tm6000 I did
# modprobe -v tm6000
insmod
/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/videobuf-core.ko
insmod
/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/videobuf-vmalloc.ko 



insmod /lib/modules/2.6.27-11-generic/kernel/drivers/i2c/i2c-core.ko
insmod
/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/tm6000/tm6000.ko

$ dmesg
[  187.646908] tm6000 v4l2 driver version 0.0.1 loaded
[  187.647898] usbcore: registered new interface driver tm6000

(tail /var/log/messages gives the same info)

Now - as I hope the module is loaded correctly - I attacht the USB-Device:

$ dmesg
[  373.881042] usb 8-1: new high speed USB device using ehci_hcd and
address 3
[  374.019648] usb 8-1: configuration #1 chosen from 1 choice
[  374.023090] tm6000: alt 0, interface 0, class 255
[  374.023102] tm6000: alt 0, interface 0, class 255
[  374.023107] tm6000: Bulk IN endpoint: 0x82 (max size=512 bytes)
[  374.023111] tm6000: alt 0, interface 0, class 255
[  374.023116] tm6000: alt 1, interface 0, class 255
[  374.023120] tm6000: ISOC IN endpoint: 0x81 (max size=3072 bytes)
[  374.023125] tm6000: alt 1, interface 0, class 255
[  374.023129] tm6000: alt 1, interface 0, class 255
[  374.023133] tm6000: alt 2, interface 0, class 255
[  374.023137] tm6000: alt 2, interface 0, class 255
[  374.023141] tm6000: alt 2, interface 0, class 255
[  374.023145] tm6000: alt 3, interface 0, class 255
[  374.023149] tm6000: alt 3, interface 0, class 255
[  374.023153] tm6000: alt 3, interface 0, class 255
[  374.023158] tm6000: New video device @ 480 Mbps (2040:6600, ifnum 0)
[  374.023162] tm6000: Found Hauppauge HVR-900H
[  374.884058] Error -32 while retrieving board version
[  375.184050] tm6000 #0: i2c eeprom 00: 01 59 54 45 12 01 00 02 00 00
00 40 40 20 00 66  .YTE.......@@ .f
[  375.380112] tm6000 #0: i2c eeprom 10: 69 00 10 20 40 01 02 03 48 00
79 00 62 00 72 00  i.. @...H.y.b.r.
[  375.572058] tm6000 #0: i2c eeprom 20: ff 00 64 ff ff ff ff ff ff ff
ff ff ff ff ff ff  ..d.............
[  375.764038] tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff  ................
[  375.956103] tm6000 #0: i2c eeprom 40: 10 03 48 00 56 00 52 00 39 00
30 00 30 00 48 00  ..H.V.R.9.0.0.H.
[  376.148062] tm6000 #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff  ................
[  376.344055] tm6000 #0: i2c eeprom 60: 30 ff ff ff 0f ff ff ff ff ff
0a 03 32 00 2e 00  0...........2...
[  376.536039] tm6000 #0: i2c eeprom 70: 3f 00 ff ff ff ff ff ff ff ff
ff ff ff ff ff ff  ?...............
[  376.728041] tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff  ................
[  376.920041] tm6000 #0: i2c eeprom 90: 35 ff ff ff 16 03 34 00 30 00
33 00 32 00 31 00  5.....4.0.3.2.1.
[  377.112039] tm6000 #0: i2c eeprom a0: 33 00 35 00 33 00 39 00 39 00
00 00 00 00 ff ff  3.5.3.9.9.......
[  377.308054] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff  ................
[  377.500046] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff  ................
[  377.692053] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff  ................
[  377.885037] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff  ................
[  378.076042] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff  ................
[  378.260374]   ................
[  378.260531] Trident TVMaster TM5600/TM6000 USB2 board (Load status: 0)
[  378.320709] Hack: enabling device at addr 0xc2
[  378.320722] tuner' 0-0061: chip found @ 0xc2 (tm6000 #0)
[  378.362555] xc2028 0-0061: creating new instance
[  378.362566] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[  378.362817] Setting firmware parameters for xc2028
[  378.362834] firmware: requesting xc3028L-v36.fw
[  378.395756] xc2028 0-0061: Loading 81 firmware images from
xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
[  378.692036] xc2028 0-0061: Loading firmware for type=BASE MTS (5), id
0000000000000000.


The device itself does not show any affection (LEDs stay dark), there is
no directory /dev/dvb created and MeTV tells me it's not finding any
reciever.

What am I missing? Did I oversee anything conserning the
driver-compilation? Or am I using the wrong firmware?

Comments appreciated,
David

