Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62114 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1BCUSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Feb 2011 15:18:05 -0500
Received: by wyb28 with SMTP id 28so1539486wyb.19
        for <linux-media@vger.kernel.org>; Thu, 03 Feb 2011 12:18:03 -0800 (PST)
From: Tomas Van Pottelbergh <vapoto@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Subject: Kworld DVB-T 380U alike device "tuner type not set" (em28xx)
Date: Thu, 3 Feb 2011 21:18:00 +0100
Message-Id: <75CD4190-5F4B-4939-A3CD-18D32B66BBFE@gmail.com>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1082)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'm trying to get a König DVB-T USB10 device to work with Ubuntu 10.10. I'm pretty sure this device is very similar to a Kworld 380U because the packed Windows drivers show evidence for that.
When I plug in the device, it gets recognized as a Kworld 355U. The dmesg output is:

[ 2637.843255] usb 1-1: new high speed USB device using ehci_hcd and address 5
[ 2638.109617] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:e357, interface 0, class 0)
[ 2638.112200] em28xx #0: chip ID is em2870
[ 2638.251688] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 57 e3 c0 12 62 40 6a 22 00 00
[ 2638.251707] em28xx #0: i2c eeprom 10: 00 00 04 57 6a 0d 00 00 60 00 00 00 02 00 00 00
[ 2638.251716] em28xx #0: i2c eeprom 20: 54 00 00 00 f0 10 01 00 00 00 00 00 5b 00 00 00
[ 2638.251725] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[ 2638.251733] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2638.251741] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2638.251749] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[ 2638.251758] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 20 00 44 00
[ 2638.251766] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[ 2638.251774] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2638.251783] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2638.251791] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2638.251799] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2638.251807] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2638.251815] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2638.251824] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2638.251833] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x32317d02
[ 2638.251835] em28xx #0: EEPROM info:
[ 2638.251837] em28xx #0:	No audio on board.
[ 2638.251838] em28xx #0:	500mA max power
[ 2638.251841] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 2638.259564] em28xx #0: Identified as Kworld 355 U DVB-T (card=42)
[ 2638.259567] em28xx #0: 
[ 2638.259568] 
[ 2638.259571] em28xx #0: The support for this board weren't valid yet.
[ 2638.259573] em28xx #0: Please send a report of having this working
[ 2638.259575] em28xx #0: not to V4L mailing list (and/or to other addresses)
[ 2638.259577] 
[ 2638.282240] tuner 0-0062: chip found @ 0xc4 (em28xx #0)
[ 2638.282259] tuner 0-0062: tuner type not set
[ 2638.282268] em28xx #0: v4l2 driver version 0.1.2
[ 2638.337385] em28xx #0: V4L2 video device registered as video0

The "tuner type not set" seems to be a problem, because the scan or dvbscan utilities don't find the device... I tried Googling the error, but I don't find any clue how to solve the problem. Does anyone recognize this error and has a possible solution?

