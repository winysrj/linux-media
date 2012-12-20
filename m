Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34601 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab2LTAzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 19:55:55 -0500
Received: by mail-ee0-f53.google.com with SMTP id c50so1432077eek.40
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2012 16:55:54 -0800 (PST)
Message-ID: <50D28A7E.9080209@gmail.com>
Date: Thu, 20 Dec 2012 06:48:14 +0300
From: =?UTF-8?B?0JDQvdC00YDQtdC5INCf0LDQstC70L7Qsg==?=
	<7134956@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] For new revision of the board AVerMedia Hybrid TV / Radio
 (A16D)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I'm trying to add support for card AVerMedia Hybrid TV / Radio (A16D) 
two new revisions. subsystem: 1461:fb36, subsystem: 1461:fc36.
The card capable of DVB-T, analog TV and FM radio.

--- drivers/media/pci/saa7134/saa7134-cards.c.orig      2012-12-17 
22:14:54.000000000 +0300
+++ drivers/media/pci/saa7134/saa7134-cards.c   2012-12-20 
04:01:51.673631779 +0300
@@ -6858,6 +6858,18 @@
                 .subdevice    = 0xf936,
                 .driver_data  = SAA7134_BOARD_AVERMEDIA_A16D,
         }, {
+                .vendor       = PCI_VENDOR_ID_PHILIPS,
+                .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+                .subvendor    = 0x1461, /* Avermedia Technologies Inc */
+                .subdevice    = 0xfb36, /*A16D-ZL10353*/
+                .driver_data  = SAA7134_BOARD_AVERMEDIA_A16D,
+        }, {
+                .vendor       = PCI_VENDOR_ID_PHILIPS,
+                .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+                .subvendor    = 0x1461, /* Avermedia Technologies Inc */
+                .subdevice    = 0xfc36, /*A16D-ANALOG*/
+                .driver_data  = SAA7134_BOARD_AVERMEDIA_A16D,
+        }, {
                 .vendor       = PCI_VENDOR_ID_PHILIPS,
                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
                 .subvendor    = 0x1461, /* Avermedia Technologies Inc */


The result is:
[   22.893960] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   22.894167] saa7133[0]: found at 0000:05:02.0, rev: 209, irq: 18, 
latency: 64, mmio: 0xfebff800
[   22.894322] saa7133[0]: subsystem: 1461:fb36, board: AVerMedia Hybrid 
TV/Radio (A16D) [card=137,autodetected]
[   22.894502] saa7133[0]: board init: gpio is 200000
[   23.068033] saa7133[0]: i2c eeprom 00: 61 14 36 fb 00 00 00 00 00 00 
00 00 00 00 00 00
[   23.068960] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff 
ff ff ff ff ff ff
[   23.069876] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 08 ff 
00 10 ff ff ff ff
[   23.070795] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.071709] saa7133[0]: i2c eeprom 40: ff 6a 00 ff c2 1e ff ff ff ff 
ff ff ff ff ff ff
[   23.072643] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.073558] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.074470] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.075384] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.076314] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.077233] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.078144] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.079030] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.079915] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.080820] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.081708] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   23.660110] tuner 1-0061: Tuner -1 found with type(s) Radio TV.
[   23.887953] xc2028 1-0061: creating new instance
[   23.888099] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   23.889581] saa7133[0]: registered device video0 [v4l2]
[   23.889961] saa7133[0]: registered device vbi0
[   23.922834] saa7133[0]: registered device radio0
[   23.928898] xc2028 1-0061: Loading 80 firmware images from 
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   23.975442] dvb_init() allocating 1 frontend
[   24.023475] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), 
id 0000000000000000.
[   24.551822] saa7134 ALSA driver for DMA sound loaded
[   24.551987] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 18 
registered as card -1
[   33.092040] (0), id 00000000000000ff:
[   33.092112] xc2028 1-0061: Loading firmware for type=(0), id 
0000000100000007.
[   33.260020] xc2028 1-0061: Loading SCODE for type=MONO SCODE 
HAS_IF_5320 (60008000), id 0000000f00000007.
[   33.382173] ppdev: user-space parallel port driver
[   33.460032] xc2028 1-0061: Loading firmware for type=BASE FM (401), 
id 0000000000000000.
[   41.824143] xc2028 1-0061: Loading firmware for type=FM (400), id 
0000000000000000.
[   42.144085] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), 
id 0000000000000000.
[   50.728030] (0), id 00000000000000ff:
[   50.728133] xc2028 1-0061: Loading firmware for type=(0), id 
0000000100000007.
[   50.896027] xc2028 1-0061: Loading SCODE for type=MONO SCODE 
HAS_IF_5320 (60008000), id 0000000f00000007.
[   51.088666] xc2028 1-0061: Error on line 1293: -5
[   51.093507] xc2028 1-0061: Error on line 1293: -5

With this patch board starts and takes the analog signal. To receive a 
DVB-T,  add the support demodulator zl10353 вместо Zarlink MT352
Any ideas?


