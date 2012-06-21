Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60471 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404Ab2FUCFH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 22:05:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1ShWlc-0000WZ-Sn
	for linux-media@vger.kernel.org; Thu, 21 Jun 2012 04:05:05 +0200
Received: from 183.62.57.5 ([183.62.57.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 04:05:04 +0200
Received: from julia.cheung723 by 183.62.57.5 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 04:05:04 +0200
To: linux-media@vger.kernel.org
From: Julia <julia.cheung723@gmail.com>
Subject: DVC100 doesn't work on cm-t3530 board 
Date: Thu, 21 Jun 2012 01:54:57 +0000 (UTC)
Message-ID: <loom.20120621T035359-49@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I use Pinnacle DVC100 capture card on cm-t3530 card to capture analog images.
cm-t3530 uses linux 2.6.32 kernel. at first the card can be correctly detected
and by the cm-t3530 and generated as the device file /dev/video1.
root@cm-t35:/dev# dmesg | grep em28xx
em28xx 1-2.1:1.0: usb_probe_interface
em28xx 1-2.1:1.0: usb_probe_interface - got id
em28xx: New device Pinnacle Systems GmbH DVC100 @ 480 Mbps (2304:021a, interface
0, class 0)
em28xx: Video interface 0 found
em28xx #0: chip ID is em2820 (or em2710)
em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 1a 02 12 00 11 03 98 10 6a 2e
em28xx #0: i2c eeprom 10: 00 00 06 57 4e 00 00 00 60 00 00 00 02 00 00 00
em28xx #0: i2c eeprom 20: 02 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 2e 03 50 00 69 00
em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 20 00 47 00
em28xx #0: i2c eeprom 90: 6d 00 62 00 48 00 00 00 10 03 44 00 56 00 43 00
em28xx #0: i2c eeprom a0: 31 00 30 00 30 00 00 00 32 00 30 00 33 00 35 00
em28xx #0: i2c eeprom b0: 36 00 30 00 37 00 35 00 31 00 33 00 34 00 31 00
em28xx #0: i2c eeprom c0: 30 00 32 00 30 00 30 00 30 00 31 00 00 00 32 00
em28xx #0: i2c eeprom d0: 33 00 31 00 32 00 33 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 b3 d4 60 01 b3 b5 56 07
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xc6a61888
em28xx #0: EEPROM info:
em28xx #0:\0x09AC97 audio (5 sample rates)
em28xx #0:\0x09300mA max power
em28xx #0:\0x09Table at 0x06, strings=0x1098, 0x2e6a, 0x0000
em28xx #0: Identified as Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video
to DVD maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U (card=9)
saa7115 2-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
em28xx #0: Config register raw data: 0x12
em28xx #0: AC97 vendor ID = 0xffffffff
em28xx #0: AC97 features = 0x6a90
em28xx #0: Empia 202 AC97 audio processor detected
em28xx #0: v4l2 driver version 0.1.3
em28xx #0: V4L2 video device registered as video1
em28xx 1-2.1:1.1: usb_probe_interface
em28xx 1-2.1:1.1: usb_probe_interface - got id
em28xx audio device (2304:021a): interface 1, class 1
em28xx 1-2.1:1.2: usb_probe_interface
em28xx 1-2.1:1.2: usb_probe_interface - got id
em28xx audio device (2304:021a): interface 2, class 1
usbcore: registered new interface driver em28xx

I use some application to capture the images by use of v4l2. now there is
something wrong and the strace of the application shows the error message is
"ioctl(3, VIDIOC_DQBUF, 0xbeeb4a00)      = ? ERESTARTSYS (To be restarted)",
while the same application can correctly capture my usb-camera images.
so what can i do to solve this problem?

