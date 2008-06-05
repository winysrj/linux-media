Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <wimmer.mike@googlemail.com>) id 1K4MRH-0008RQ-Jt
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 22:52:08 +0200
Received: by fg-out-1718.google.com with SMTP id e21so483370fga.25
	for <linux-dvb@linuxtv.org>; Thu, 05 Jun 2008 13:52:00 -0700 (PDT)
Message-ID: <484851E8.7030606@googlemail.com>
Date: Thu, 05 Jun 2008 22:51:52 +0200
From: Michael Wimmer <wimmer.mike@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Trident TM6010 based tv cards (WinTV-HVR 900H,
	Terratec Cinergy XE, ...
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

Hello group,

recently, there were people asking about the Happauge WinTV-HVR 900H USB 
video card. Was there any progress?
I ask this, as I have recently acquired the Terratec Cinergy XE card, 
and it seem to be based on the same chip set (as is the Twinhan 704D1 
video card) - at least the Windows drivers in both cases always refer to 
a file called UDXTTM6010.sys.

It seems safe to say that these cards are all Trident TM6010 based. I 
downloaded Mauro's tm6010 repository 
(http://linuxtv.org/hg/~mchehab/tm6010) and built the modules.

When calling "modprobe tm6000 card=3", (card=3 is described as 
TM6010_GENERIC in tm6000-cards.c) dmesg says

--------------------
[ 1356.661730] tm6000: alt 0, interface 0, class 255
[ 1356.661737] tm6000: alt 0, interface 0, class 255
[ 1356.661740] tm6000: Bulk IN endpoint: 0x82 (max size=512 bytes)
[ 1356.661744] tm6000: alt 0, interface 0, class 255
[ 1356.661747] tm6000: alt 1, interface 0, class 255
[ 1356.661750] tm6000: ISOC IN endpoint: 0x81 (max size=3072 bytes)
[ 1356.661753] tm6000: alt 1, interface 0, class 255
[ 1356.661757] tm6000: alt 1, interface 0, class 255
[ 1356.661760] tm6000: alt 2, interface 0, class 255
[ 1356.661763] tm6000: alt 2, interface 0, class 255
[ 1356.661765] tm6000: alt 2, interface 0, class 255
[ 1356.661768] tm6000: alt 3, interface 0, class 255
[ 1356.661771] tm6000: alt 3, interface 0, class 255
[ 1356.661774] tm6000: alt 3, interface 0, class 255
[ 1356.661777] tm6000: New video device @ 480 Mbps (0ccd:0086, ifnum 0)
[ 1356.661781] tm6000: Found Generic tm6010 board
[ 1357.523811] Error -32 while retrieving board version
[ 1357.827325] tm6000 #0: i2c eeprom 00: 42 59 54 45 12 01 00 02 00 00 
00 40 cd 0c 86 00  BYTE.......@....
[ 1358.023244] tm6000 #0: i2c eeprom 10: 01 00 10 20 40 01 02 03 48 79 
62 72 69 64 2d 55  ... @...Hybrid-U
[ 1358.223677] tm6000 #0: i2c eeprom 20: 53 42 ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff  SB..............
[ 1358.422380] tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff  ................
[ 1358.618076] tm6000 #0: i2c eeprom 40: 24 00 43 00 69 00 6e 00 65 00 
72 00 67 00 79 00  $.C.i.n.e.r.g.y.
[ 1358.809772] tm6000 #0: i2c eeprom 50: 20 00 48 00 79 00 62 00 72 00 
69 00 64 00 20 00   .H.y.b.r.i.d. .
[ 1359.005462] tm6000 #0: i2c eeprom 60: 58 00 45 00 ff ff ff ff ff ff 
08 03 32 00 2e 00  X.E.........2...
[ 1359.197158] tm6000 #0: i2c eeprom 70: 30 00 ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff  0...............
[ 1359.388853] tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff  ................
[ 1359.584546] tm6000 #0: i2c eeprom 90: ff ff ff ff 1a 03 30 00 30 00 
30 00 38 00 43 00  ......0.0.0.8.C.
[ 1359.776240] tm6000 #0: i2c eeprom a0: 41 00 31 00 32 00 33 00 34 00 
35 00 36 00 ff ff  A.1.2.3.4.5.6...
[ 1359.971940] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff  ................
[ 1360.163631] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff  ................
[ 1360.355322] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff  ................
[ 1360.551011] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff  ................
[ 1360.746700] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff  ................
[ 1360.926418]   ................
[ 1360.926477] Trident TVMaster TM5600/TM6000 USB2 board (Load status: 0)
--------------------

which seems promising - at least the video card name (Cinergy Hybrid XE) 
is read out correctly. After that, dmesg complained about a missing 
firmware called xc3028-v27.fw, that I got from a previous message to 
this list - although this post referred to a different card. 
Consequently, loading the tuner firmware fails:

--------------------
[ 1360.961939] Hack: enabling device at addr 0xc2
[ 1360.961949] tuner' 3-0061: chip found @ 0xc2 (tm6000 #0)
[ 1361.021613] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[ 1361.021731] Setting firmware parameters for xc2028
[ 1361.047203] xc2028 3-0061: Loading 80 firmware images from 
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 1361.341754] xc2028 3-0061: Loading firmware for type=BASE MTS (5), id 
0000000000000000.
[ 1395.287932] xc2028 3-0061: Loading firmware for type=MTS (4), id 
000000000000b700.
[ 1395.930937] xc2028 3-0061: Loading SCODE for type=MTS LCD NOGD MONO 
IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 1396.070703] xc2028 3-0061: Returned an incorrect version. However, 
read is not reliable enough. Ignoring it.
[ 1396.414145] xc2028 3-0061: Returned an incorrect version. However, 
read is not reliable enough. Ignoring it.
[ 1396.414151] xc2028 3-0061: Read invalid device hardware information - 
tuner hung?
[ 1396.765600] xc2028 3-0061: Loading firmware for type=BASE MTS (5), id 
0000000000000000.
[ 1430.695815] xc2028 3-0061: Loading firmware for type=MTS (4), id 
000000000000b700.
[ 1431.338799] xc2028 3-0061: Loading SCODE for type=MTS LCD NOGD MONO 
IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 1431.478569] xc2028 3-0061: Returned an incorrect version. However, 
read is not reliable enough. Ignoring it.
[ 1431.478578] xc2028 3-0061: Read invalid device hardware information - 
tuner hung?
[ 1431.767140] tm6000: no frontend defined for the device!
[ 1431.767151] tm6000: couldn't attach the frontend!
[ 1431.767179] tm6000: probe of 5-2:1.0 failed with error -1
--------------------

Right now, I don't know for sure which tuner is in this card (although 
the usual combination seems to be tm6010 and an xceive tuner as far as 
I've seen in the net), nor do I know which would be the correct firmware 
for the tuner.

Is it possible to extract the firmware from the Windows driver? I mean, 
is there a way to identify in an unknwown driver the parts corresponding 
to the firmware?
Any ideas or suggestions?

Best,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
