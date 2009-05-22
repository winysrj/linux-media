Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhmoodie@telkomsa.net>) id 1M7bZq-0007IT-8D
	for linux-dvb@linuxtv.org; Fri, 22 May 2009 22:42:51 +0200
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id 4430534627A
	for <linux-dvb@linuxtv.org>; Fri, 22 May 2009 16:42:43 -0400 (EDT)
Message-Id: <1243024963.14790.1316818399@webmail.messagingengine.com>
From: jhmoodie@telkomsa.net
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Date: Fri, 22 May 2009 13:42:43 -0700
Subject: [linux-dvb] Gigabyte GT-P8000 dvb-t / analog / fm radio - pci
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Does anyone have any information on the support status of this card? Or
perhaps any hints I might try to get it working?

I have built and installed the latest V4L-DVB kernel driver modules, but
no luck.

I noticed windows installs Philips 3xhybrid drivers if this helps...

Product website:
http://www.gigabyte.com.tw/Products/TVCard/Products_Spec.aspx?ClassValue=TV+Card&ProductID=2757&ProductName=GT-P8000

Tuner NXP 18271
Decoder NXP 7131E

lspci -vnn:
00:09.0 Multimedia controller [0480]: Philips Semiconductors
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
        Subsystem: Giga-byte Technology Device [1458:9004]
        Flags: bus master, medium devsel, latency 32, IRQ 11
        Memory at e6000000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: saa7134
        Kernel modules: saa7134

dmesg output:
[ 3089.801191] saa7130/34: v4l2 driver version 0.2.15 loaded
[ 3089.801419] saa7133[0]: found at 0000:00:09.0, rev: 209, irq: 11,
latency: 32, mmio: 0xe6000000
[ 3089.801443] saa7133[0]: subsystem: 1458:9004, board: UNKNOWN/GENERIC
[card=0,autodetected]
[ 3089.801656] saa7133[0]: board init: gpio is 40000
[ 3089.952088] saa7133[0]: i2c eeprom 00: 58 14 04 90 54 20 1c 00 43 43
a9
1c 55 d2 b2 92
[ 3089.952125] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952153] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff
00
b3 ff ff ff ff
[ 3089.952180] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952206] saa7133[0]: i2c eeprom 40: 50 35 00 c0 96 10 05 32 d5 15
0e
00 ff ff ff ff
[ 3089.952233] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952260] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952287] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952314] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952340] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952367] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952394] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952421] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952447] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952474] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.952501] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff
ff ff ff ff ff
[ 3089.953430] saa7133[0]: registered device video0 [v4l2]
[ 3089.953507] saa7133[0]: registered device vbi0
[ 3090.023006] saa7134 ALSA driver for DMA sound loaded
[ 3090.023158] saa7133[0]/alsa: saa7133[0] at 0xe6000000 irq 11
registered
as card -2

-- 
  
  raincloud@fastmail.fm

-- 
http://www.fastmail.fm - Email service worth paying for. Try it for free


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
