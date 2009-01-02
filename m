Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <elio.voci@gmail.com>) id 1LIjm9-0005CW-Nj
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 14:09:18 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2293183fga.25
	for <linux-dvb@linuxtv.org>; Fri, 02 Jan 2009 05:09:14 -0800 (PST)
From: Elio Voci <elio.voci@gmail.com>
To: linux-dvb@linuxtv.org
Date: Fri, 02 Jan 2009 14:09:00 +0100
Message-Id: <1230901740.14839.15.camel@localhost>
Mime-Version: 1.0
Subject: [linux-dvb] em28xx frontend does not attach
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1436525482=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1436525482==
Content-Type: multipart/alternative; boundary="=-XYXJ8mwcLli5WSElwnp+"


--=-XYXJ8mwcLli5WSElwnp+
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello.

I have recently upgraded my Debian Lenny from kernel 2.6.25 to 2.6.26.
After this, I couldn't use my Cinergy Hybrid T USB XS (0ccd:0042).
Up to now I used the mcentral.de driver, now I would like to switch to
linuxtv driver.

Following the wiki "How to install DVB device drivers, and "How to build
drivers from Mercurial", I have cloned v4l-dvb. Make and install ran
smoothly.
I have generated the firmware from
http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip, Driver85/hcw85bda.sys

em28xx installed correctly, dvb frontend did not: zl10353_read_register
returned -19
Below the relevant dmesg section (em28xx modprobed with core_debug=1

________________________________________________________________________


> [ 3417.818736] Linux video capture interface: v2.00
> [ 3417.852895] em28xx: Unknown parameter `fontend_debug'
> [ 3435.747549] em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS @ 480 Mbps (0ccd:0042, interface 0, class 0)
> [ 3435.747763] em28xx #0: Identified as Terratec Hybrid XS (card=11)
> [ 3435.748177] em28xx #0: chip ID is em2882/em2883
> [ 3435.881979] cx25843.c: starting probe for adapter em28xx #0 (0x1001f)
> [ 3435.909135] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 42 00 50 12 5c 03 6a 32 9c 34
> [ 3435.909145] em28xx #0: i2c eeprom 10: 00 00 06 57 46 07 00 00 00 00 00 00 00 00 00 00
> [ 3435.909151] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 00 00 00
> [ 3435.909158] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
> [ 3435.909165] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 3435.909172] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 3435.909179] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 32 03 43 00 69 00
> [ 3435.909185] em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79 00
> [ 3435.909192] em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55 00
> [ 3435.909199] em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 00 00 34 03 54 00
> [ 3435.909206] em28xx #0: i2c eeprom a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20 00
> [ 3435.909213] em28xx #0: i2c eeprom b0: 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00
> [ 3435.909219] em28xx #0: i2c eeprom c0: 69 00 63 00 20 00 47 00 6d 00 62 00 48 00 00 00
> [ 3435.909226] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 3435.909233] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 3435.909240] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 3435.909247] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x41d0bf96
> [ 3435.909249] em28xx #0: EEPROM info:
> [ 3435.909251] em28xx #0:	AC97 audio (5 sample rates)
> [ 3435.909252] em28xx #0:	500mA max power
> [ 3435.909254] em28xx #0:	Table at 0x06, strings=0x326a, 0x349c, 0x0000
> [ 3435.932331] tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
> [ 3435.948856] xc2028 1-0061: creating new instance
> [ 3435.948862] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
> [ 3435.949018] firmware: requesting xc3028-v27.fw
> [ 3435.953666] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [ 3436.000194] xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> [ 3436.909811] xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
> [ 3436.923409] SCODE (20000000), id 000000000000b700:
> [ 3436.923422] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
> [ 3437.104224] em28xx #0: Config register raw data: 0x50
> [ 3437.104913] em28xx #0: AC97 vendor ID = 0xffffffff
> [ 3437.105266] em28xx #0: AC97 features = 0x6a90
> [ 3437.105273] em28xx #0: Empia 202 AC97 audio processor detected
> [ 3437.196447] tvp5150 1-005c: tvp5150am1 detected.
> [ 3437.296809] em28xx #0: v4l2 driver version 0.1.1
> [ 3437.345215] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> [ 3437.345260] usbcore: registered new interface driver em28xx
> [ 3437.345267] em28xx driver loaded
> [ 3437.456026] em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
> [ 3437.456033] em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
> [ 3437.456821] em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
> [ 3437.465968] em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
> [ 3437.479454] zl10353_read_register: readreg error (reg=127, ret==-19)
> [ 3437.479484] em28xx #0/2: dvb frontend not attached. Can't attach xc3028
> [ 3437.479487] Em28xx: Initialized (Em28xx dvb Extension) extension
> [ 3437.528441] tvp5150 1-005c: tvp5150am1 detected.
> [ 3437.626629] em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
> [ 3437.647170] em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc


________________________________________________________________________

Hints are welcome.
Thanks
___________________________________
Elio Voci <elio.voci@gmail.com>
Mobile +39-329-2343564
Voip +39-0962-1876557
Fax +39-0962-1870163
Skype Elio.Voci


--=-XYXJ8mwcLli5WSElwnp+
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.18.3">
</HEAD>
<BODY>
Hello.<BR>
<BR>
I have recently upgraded my Debian Lenny from kernel 2.6.25 to 2.6.26.<BR>
After this, I couldn't use my Cinergy Hybrid T USB XS (0ccd:0042).<BR>
Up to now I used the mcentral.de driver, now I would like to switch to linuxtv driver.<BR>
<BR>
Following the wiki &quot;<A HREF="http://linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers">How to install DVB device drivers,</A> and &quot;<A HREF="http://linuxtv.org/wiki/index.php/How_to_build_from_Mercurial">How to build drivers from Mercurial</A>&quot;, I have cloned v4l-dvb. Make and install ran smoothly.<BR>
I have generated the firmware from <A HREF="http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip,">http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip,</A> Driver85/hcw85bda.sys<BR>
<BR>
em28xx installed correctly, dvb frontend did not: zl10353_read_register returned -19<BR>
Below the relevant dmesg section (em28xx modprobed with core_debug=1<BR>

<HR NOSHADE>
<BR>
<BR>
<BLOCKQUOTE TYPE=CITE>
<PRE>
[ 3417.818736] Linux video capture interface: v2.00
[ 3417.852895] em28xx: Unknown parameter `fontend_debug'
[ 3435.747549] em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS @ 480 Mbps (0ccd:0042, interface 0, class 0)
[ 3435.747763] em28xx #0: Identified as Terratec Hybrid XS (card=11)
[ 3435.748177] em28xx #0: chip ID is em2882/em2883
[ 3435.881979] cx25843.c: starting probe for adapter em28xx #0 (0x1001f)
[ 3435.909135] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 42 00 50 12 5c 03 6a 32 9c 34
[ 3435.909145] em28xx #0: i2c eeprom 10: 00 00 06 57 46 07 00 00 00 00 00 00 00 00 00 00
[ 3435.909151] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 00 00 00
[ 3435.909158] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
[ 3435.909165] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3435.909172] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3435.909179] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 32 03 43 00 69 00
[ 3435.909185] em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79 00
[ 3435.909192] em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55 00
[ 3435.909199] em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 00 00 34 03 54 00
[ 3435.909206] em28xx #0: i2c eeprom a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20 00
[ 3435.909213] em28xx #0: i2c eeprom b0: 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00
[ 3435.909219] em28xx #0: i2c eeprom c0: 69 00 63 00 20 00 47 00 6d 00 62 00 48 00 00 00
[ 3435.909226] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3435.909233] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3435.909240] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3435.909247] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x41d0bf96
[ 3435.909249] em28xx #0: EEPROM info:
[ 3435.909251] em28xx #0:	AC97 audio (5 sample rates)
[ 3435.909252] em28xx #0:	500mA max power
[ 3435.909254] em28xx #0:	Table at 0x06, strings=0x326a, 0x349c, 0x0000
[ 3435.932331] tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
[ 3435.948856] xc2028 1-0061: creating new instance
[ 3435.948862] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 3435.949018] firmware: requesting xc3028-v27.fw
[ 3435.953666] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 3436.000194] xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[ 3436.909811] xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
[ 3436.923409] SCODE (20000000), id 000000000000b700:
[ 3436.923422] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
[ 3437.104224] em28xx #0: Config register raw data: 0x50
[ 3437.104913] em28xx #0: AC97 vendor ID = 0xffffffff
[ 3437.105266] em28xx #0: AC97 features = 0x6a90
[ 3437.105273] em28xx #0: Empia 202 AC97 audio processor detected
[ 3437.196447] tvp5150 1-005c: tvp5150am1 detected.
[ 3437.296809] em28xx #0: v4l2 driver version 0.1.1
[ 3437.345215] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[ 3437.345260] usbcore: registered new interface driver em28xx
[ 3437.345267] em28xx driver loaded
[ 3437.456026] em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
[ 3437.456033] em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
[ 3437.456821] em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
[ 3437.465968] em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
<B>[ 3437.479454] zl10353_read_register: readreg error (reg=127, ret==-19)</B>
<B>[ 3437.479484] em28xx #0/2: dvb frontend not attached. Can't attach xc3028</B>
[ 3437.479487] Em28xx: Initialized (Em28xx dvb Extension) extension
[ 3437.528441] tvp5150 1-005c: tvp5150am1 detected.
[ 3437.626629] em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
[ 3437.647170] em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
</PRE>
</BLOCKQUOTE>

<HR NOSHADE>
<BR>
<BR>
Hints are welcome.<BR>
Thanks<BR>
<TABLE CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
<TR>
<TD>
___________________________________<BR>
<TABLE CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
<TR>
<TD>
<I>Elio Voci &lt;<A HREF="mailto:elio.voci@gmail.com">elio.voci@gmail.com</A>&gt;</I><BR>
<I>Mobile +39-329-2343564</I><BR>
<I>Voip +39-0962-1876557</I><BR>
<I>Fax +39-0962-1870163</I>
</TD>
</TR>
</TABLE>
Skype Elio.Voci
</TD>
</TR>
</TABLE>
<BR>
</BODY>
</HTML>

--=-XYXJ8mwcLli5WSElwnp+--



--===============1436525482==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1436525482==--
