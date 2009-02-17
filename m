Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:63851 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbZBQUg4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 15:36:56 -0500
Received: by ewy12 with SMTP id 12so1081368ewy.13
        for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 12:36:54 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 17 Feb 2009 21:36:54 +0100
Message-ID: <8ed362a40902171236m612f05ck707479aa7484b644@mail.gmail.com>
Subject: ASUStek P1731 dual and tuner problems
From: Fernando Jimenez <fernandojmnz5@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!
I have problems to get my Asustek P1731 Dual working. I have install
v4l-dvb and the firmware dvb-fe-tda10046.fw.
The module saa7134-dvb loads fine, but dmesg shows:
tda827xo_set_params: could not write to tuner at addr: 0xc2
saa7134[0]/dvb: could not access tda8290 I2C gate
saa7134[0]/dvb: could not access tda8290 I2C gate
saa7134[0]/dvb: could not access tda8290 I2C gate

Also, w_scan cant tune:

w_scan version 20080105
Info: using DVB adapter auto detection.
   Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
-_-_-_-_ Getting frontend capabilities-_-_-_-_
frontend Philips TDA10046H DVB-T supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO not supported, trying HIERARCHY_NONE.
FEC_AUTO
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
177500:
184500:
191500:
198500:            ...........
....................
....................
ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!
dumping lists (0 services)
Done.

dmesg while loading with  modprobe saa7134 card=112 tuner=54
gpio_tracking=1 i2c_scan=1 is the same:

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7134[0]: found at 0000:03:04.0, rev: 1, irq: 16, latency: 64, mmio:
0xbffff000
saa7134[0]: subsystem: 1043:4860, board: ASUSTeK P7131 Dual
[card=78,insmod option]
saa7134[0]: board init: gpio is 0
saa7134[0]: gpio: mode=0x0000000 in=0x0000000 out=0x0000000 [pre-init]
input: saa7134 IR (ASUSTeK P7131 Dual) as /class/input/input10
saa7134[0]: i2c eeprom 00: 43 10 60 48 54 20 1c 00 43 43 a9 1c 55 d2
b2 92
saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff
ff ff
saa7134[0]: i2c eeprom 20: 01 40 01 03 03 02 03 04 08 ff 00 4c ff ff
ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
saa7134[0]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 0d 01 ff ff ff ff
ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c scan: found device @ 0x10  [???]
saa7134[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7134[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7134[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 20 -- ok
saa7134[0]/dvb: could not access tda8290 I2C gate
saa7134[0]/dvb: could not access tda8290 I2C gate

It's seems there's a problems while writen in the EEPROM.
