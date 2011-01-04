Return-path: <mchehab@gaivota>
Received: from smtp.work.de ([212.12.45.188]:45044 "EHLO smtp2.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1ADCTa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jan 2011 21:19:30 -0500
Message-ID: <4D2283AD.3000006@jusst.de>
Date: Tue, 04 Jan 2011 03:19:25 +0100
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-2200 analog
References: <4CFE14A1.3040801@jusst.de> <1291726869.2073.5.camel@morgan.silverblock.net> <4D07A829.6080406@jusst.de> <4D07CAA6.3030300@kernellabs.com> <67DB049D-B91E-4457-93CE-2CE0164C5B54@jusst.de>
In-Reply-To: <67DB049D-B91E-4457-93CE-2CE0164C5B54@jusst.de>
Content-Type: multipart/mixed;
 boundary="------------090407040001090200060608"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------090407040001090200060608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Am 15.12.2010 08:04, schrieb Julian Scheel:
> Am 14.12.2010 um 20:51 schrieb Steven Toth:
>
>> On 12/14/10 12:23 PM, Julian Scheel wrote:
>>> Is there any reason, why the additional card-information found here:
>>> http://www.kernellabs.com/hg/~stoth/saa7164-dev/
>>> is not yet in the kernel tree?
>> On my todo list.
> Ok, fine.
>
>> I validate each board before I add its profile to the core tree. If certain
>> boards are missing then its because that board is considered experimental or is
>> pending testing and merge.
>>
>> PAL encoder support is broken in the current tree and it currently getting my
>> love and attention. Point me at the specific boards you think are missing and
>> I'll also add these to my todo list, they'll likely get merged at the same time.
> Actually this is the board I am testing with:
> http://www.kernellabs.com/hg/~stoth/saa7164-dev/rev/cf2d7530d676
>
> Should it work with your testing tree or is the encoder part broken there as well?
I was able to get the encoder working now. The diff I referenced did not 
contain the encoder port settings. I added them manually and now get 
/dev/video0,1 and /dev/vbi0,1. A simple cat /dev/video0 > test.mpg 
reveals that the encoder seems to be running - it shows a nice 
mpeg-encoded bluescreen.
Anyway running scantv did not show any results although I have a proper 
input signal connected. I guess there is something broken still? Any ideas?
Also it seems so far only NTSC is supported. dmesg shows that the 
firmware is capable of PAL - just the question is what needs to be 
changed in the drivers to switch between the modes?

Attached is the diff I currently use.

-Julian


--------------090407040001090200060608
Content-Type: text/x-patch;
 name="saa7164-card.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="saa7164-card.diff"

diff -ru -x '*.o*' -x '*.ko*' -x '*.cmd' -x '*.orig' linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-cards.c linux-2.6.37-rc8/drivers/media/video/saa7164//saa7164-cards.c
--- linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-cards.c	2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37-rc8/drivers/media/video/saa7164//saa7164-cards.c	2011-01-04 02:26:56.000000000 +0100
@@ -203,6 +203,66 @@
 			.i2c_reg_len	= REGLEN_8bit,
 		} },
 	},
+	[SAA7164_BOARD_HAUPPAUGE_HVR2200_4] = {
+		.name		= "Hauppauge WinTV-HVR2200",
+		.porta		= SAA7164_MPEG_DVB,
+		.portb		= SAA7164_MPEG_DVB,
+                .portc          = SAA7164_MPEG_ENCODER,
+                .portd          = SAA7164_MPEG_ENCODER,
+                .porte          = SAA7164_MPEG_VBI,
+                .portf          = SAA7164_MPEG_VBI,
+		.chiprev	= SAA7164_CHIP_REV3,
+		.unit		= {{
+			.id		= 0x1d,
+			.type		= SAA7164_UNIT_EEPROM,
+			.name		= "4K EEPROM",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_0,
+			.i2c_bus_addr	= 0xa0 >> 1,
+			.i2c_reg_len	= REGLEN_8bit,
+		}, {
+			.id		= 0x04,
+			.type		= SAA7164_UNIT_TUNER,
+			.name		= "TDA18271-1",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
+			.i2c_bus_addr	= 0xc0 >> 1,
+			.i2c_reg_len	= REGLEN_8bit,
+		}, {
+			.id		= 0x05,
+			.type		= SAA7164_UNIT_ANALOG_DEMODULATOR,
+			.name		= "TDA8290-1",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
+			.i2c_bus_addr	= 0x84 >> 1,
+			.i2c_reg_len	= REGLEN_8bit,
+		}, {
+			.id		= 0x1b,
+			.type		= SAA7164_UNIT_TUNER,
+			.name		= "TDA18271-2",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
+			.i2c_bus_addr	= 0xc0 >> 1,
+			.i2c_reg_len	= REGLEN_8bit,
+		}, {
+			.id		= 0x1c,
+			.type		= SAA7164_UNIT_ANALOG_DEMODULATOR,
+			.name		= "TDA8290-2",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
+			.i2c_bus_addr	= 0x84 >> 1,
+			.i2c_reg_len	= REGLEN_8bit,
+		}, {
+			.id		= 0x1e,
+			.type		= SAA7164_UNIT_DIGITAL_DEMODULATOR,
+			.name		= "TDA10048-1",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
+			.i2c_bus_addr	= 0x10 >> 1,
+			.i2c_reg_len	= REGLEN_8bit,
+		}, {
+			.id		= 0x1f,
+			.type		= SAA7164_UNIT_DIGITAL_DEMODULATOR,
+			.name		= "TDA10048-2",
+			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
+			.i2c_bus_addr	= 0x12 >> 1,
+			.i2c_reg_len	= REGLEN_8bit,
+		} },
+	},
 	[SAA7164_BOARD_HAUPPAUGE_HVR2250] = {
 		.name		= "Hauppauge WinTV-HVR2250",
 		.porta		= SAA7164_MPEG_DVB,
@@ -426,6 +486,10 @@
 		.subvendor = 0x0070,
 		.subdevice = 0x8851,
 		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2250_2,
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0x8940,
+		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2200_4,
 	},
 };
 const unsigned int saa7164_idcount = ARRAY_SIZE(saa7164_subids);
@@ -469,6 +533,7 @@
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_2:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
+	case SAA7164_BOARD_HAUPPAUGE_HVR2200_4:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250_2:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250_3:
@@ -549,6 +614,7 @@
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_2:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
+	case SAA7164_BOARD_HAUPPAUGE_HVR2200_4:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250_2:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2250_3:
Nur in linux-2.6.37-rc8/drivers/media/video/saa7164/: saa7164-cards.c.rej.
diff -ru -x '*.o*' -x '*.ko*' -x '*.cmd' -x '*.orig' linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-dvb.c linux-2.6.37-rc8/drivers/media/video/saa7164//saa7164-dvb.c
--- linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-dvb.c	2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37-rc8/drivers/media/video/saa7164//saa7164-dvb.c	2011-01-04 02:23:35.000000000 +0100
@@ -475,6 +475,7 @@
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_2:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
+	case SAA7164_BOARD_HAUPPAUGE_HVR2200_4:
 		i2c_bus = &dev->i2c_bus[port->nr + 1];
 		switch (port->nr) {
 		case 0:
diff -ru -x '*.o*' -x '*.ko*' -x '*.cmd' -x '*.orig' linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-encoder.c linux-2.6.37-rc8/drivers/media/video/saa7164//saa7164-encoder.c
--- linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-encoder.c	2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37-rc8/drivers/media/video/saa7164//saa7164-encoder.c	2011-01-04 03:05:30.000000000 +0100
@@ -32,7 +32,10 @@
 	}, {
 		.name      = "NTSC-JP",
 		.id        = V4L2_STD_NTSC_M_JP,
-	}
+	}, {
+                .name      = "PAL-B",
+                .id        = V4L2_STD_PAL_B,
+        }
 };
 
 static const u32 saa7164_v4l2_ctrls[] = {
diff -ru -x '*.o*' -x '*.ko*' -x '*.cmd' -x '*.orig' linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164.h linux-2.6.37-rc8/drivers/media/video/saa7164//saa7164.h
--- linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164.h	2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37-rc8/drivers/media/video/saa7164//saa7164.h	2011-01-04 02:23:35.000000000 +0100
@@ -83,6 +83,7 @@
 #define SAA7164_BOARD_HAUPPAUGE_HVR2200_3	6
 #define SAA7164_BOARD_HAUPPAUGE_HVR2250_2	7
 #define SAA7164_BOARD_HAUPPAUGE_HVR2250_3	8
+#define SAA7164_BOARD_HAUPPAUGE_HVR2200_4	9
 
 #define SAA7164_MAX_UNITS		8
 #define SAA7164_TS_NUMBER_OF_LINES	312
Nur in linux-2.6.37-rc8/drivers/media/video/saa7164/: saa7164.mod.c.

--------------090407040001090200060608--
