Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [195.7.61.12] (helo=killala.koala.ie)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon@koala.ie>) id 1LAA89-0006fn-7m
	for linux-dvb@linuxtv.org; Tue, 09 Dec 2008 22:28:33 +0100
Received: from [195.7.61.7] (cozumel.koala.ie [195.7.61.7])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id mB9LSYeB001617
	for <linux-dvb@linuxtv.org>; Tue, 9 Dec 2008 21:28:34 GMT
Message-ID: <493EE2FC.4000504@koala.ie>
Date: Tue, 09 Dec 2008 21:28:28 +0000
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] problems with a TerraTec Cinergy Hybrid T USB XS
	(0ccd:0042)
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

with drivers from mercurial it works fine on my x86 laptop
but when i try to plug it into my amd64 machine i get this (note the 
failure three lines from the end):

anybody got and ideas?
--
simon

em28xx v4l2 driver version 0.1.0 
loaded                                                                                                               

em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS @ 
480 Mbps (0ccd:0042, interface 0, class 
0)                                     
em28xx #0: Identified as Terratec Hybrid XS 
(card=11)                                                                                                 

em28xx #0: chip ID is 
em2882/em2883                                                                                                                   

em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 42 00 50 12 5c 03 6a 32 9c 34
em28xx #0: i2c eeprom 10: 00 00 06 57 46 07 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 32 03 43 00 69 00
em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79 00
em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55 00
em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 00 00 34 03 54 00
em28xx #0: i2c eeprom a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20 00
em28xx #0: i2c eeprom b0: 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00
em28xx #0: i2c eeprom c0: 69 00 63 00 20 00 47 00 6d 00 62 00 48 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x41d0bf96
em28xx #0: EEPROM info:
em28xx #0:      AC97 audio (5 sample rates)
em28xx #0:      500mA max power
em28xx #0:      Table at 0x06, strings=0x326a, 0x349c, 0x0000
tuner' 5-0061: chip found @ 0xc2 (em28xx #0)
xc2028 5-0061: creating new instance
xc2028 5-0061: type set to XCeive xc2028/xc3028 tuner
firmware: requesting xc3028-v27.fw
xc2028 5-0061: Loading 80 firmware images from xc3028-v27.fw, type: 
xc2028 firmware, ver 2.7
xc2028 5-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 5-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 5-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), 
id 0000000000008000.
em28xx #0: Config register raw data: 0x50
em28xx #0: AC97 vendor ID = 0x83847652
em28xx #0: AC97 features = 0x6a90
em28xx #0: Sigmatel audio processor detected(stac 9752)
tvp5150 5-005c: tvp5150am1 detected.
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx audio device (0ccd:0042): interface 1, class 1
em28xx audio device (0ccd:0042): interface 2, class 1
usbcore: registered new interface driver em28xx
zl10353_read_register: readreg error (reg=127, ret==-19)
em28xx #0/2: dvb frontend not attached. Can't attach xc3028
Em28xx: Initialized (Em28xx dvb Extension) extension



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
