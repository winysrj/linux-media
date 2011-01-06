Return-path: <mchehab@pedra>
Received: from smtp.work.de ([212.12.45.188]:42054 "EHLO smtp2.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab1AFWbm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 17:31:42 -0500
Message-ID: <4D2642CA.4080309@jusst.de>
Date: Thu, 06 Jan 2011 23:31:38 +0100
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-2200 analog
References: <4CFE14A1.3040801@jusst.de> <1291726869.2073.5.camel@morgan.silverblock.net> <4D07A829.6080406@jusst.de> <4D07CAA6.3030300@kernellabs.com> <67DB049D-B91E-4457-93CE-2CE0164C5B54@jusst.de> <4D2283AD.3000006@jusst.de>
In-Reply-To: <4D2283AD.3000006@jusst.de>
Content-Type: multipart/mixed;
 boundary="------------030104030200050908020507"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------030104030200050908020507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


> Attached is the diff I currently use.
>
Some more process. Attached is a new patch, which allows me to capture 
video and audio from a PAL tuner. Imho the video has wrong colours 
though (using PAL-B). Maybe someone would want to test that patch and 
give some feedback?

Regards,
Julian


--------------030104030200050908020507
Content-Type: text/x-patch;
 name="saa7164-card-pal.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="saa7164-card-pal.diff"

Nur in linux-2.6.37/drivers/media/video/saa7164/: modules.order.
diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-api.c linux-2.6.37/drivers/media/video/saa7164//saa7164-api.c
--- linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-api.c	2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37/drivers/media/video/saa7164//saa7164-api.c	2011-01-06 23:22:17.000000000 +0100
@@ -548,7 +548,7 @@
 		tvaudio.std = TU_STANDARD_NTSC_M;
 		tvaudio.country = 1;
 	} else {
-		tvaudio.std = TU_STANDARD_PAL_I;
+		tvaudio.std = 0x04; //TU_STANDARD_PAL_I;
 		tvaudio.country = 44;
 	}
 
diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-cards.c linux-2.6.37/drivers/media/video/saa7164//saa7164-cards.c
--- linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-cards.c	2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37/drivers/media/video/saa7164//saa7164-cards.c	2011-01-06 16:16:56.000000000 +0100
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
diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-dvb.c linux-2.6.37/drivers/media/video/saa7164//saa7164-dvb.c
--- linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-dvb.c	2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37/drivers/media/video/saa7164//saa7164-dvb.c	2011-01-06 16:16:56.000000000 +0100
@@ -475,6 +475,7 @@
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_2:
 	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
+	case SAA7164_BOARD_HAUPPAUGE_HVR2200_4:
 		i2c_bus = &dev->i2c_bus[port->nr + 1];
 		switch (port->nr) {
 		case 0:
diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-encoder.c linux-2.6.37/drivers/media/video/saa7164//saa7164-encoder.c
--- linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-encoder.c	2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37/drivers/media/video/saa7164//saa7164-encoder.c	2011-01-06 23:09:52.000000000 +0100
@@ -32,7 +32,25 @@
 	}, {
 		.name      = "NTSC-JP",
 		.id        = V4L2_STD_NTSC_M_JP,
-	}
+	}, {
+                .name      = "PAL-I",
+                .id        = V4L2_STD_PAL_I,
+	}, {
+                .name      = "PAL-M",
+                .id        = V4L2_STD_PAL_M,
+	}, {
+                .name      = "PAL-N",
+                .id        = V4L2_STD_PAL_N,
+	}, {
+                .name      = "PAL-Nc",
+                .id        = V4L2_STD_PAL_Nc,
+	}, {
+                .name      = "PAL-B",
+                .id        = V4L2_STD_PAL_B,
+	}, {
+                .name      = "PAL-DK",
+                .id        = V4L2_STD_PAL_DK,
+        }
 };
 
 static const u32 saa7164_v4l2_ctrls[] = {
diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164.h linux-2.6.37/drivers/media/video/saa7164//saa7164.h
--- linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164.h	2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37/drivers/media/video/saa7164//saa7164.h	2011-01-06 23:13:06.000000000 +0100
@@ -83,6 +83,7 @@
 #define SAA7164_BOARD_HAUPPAUGE_HVR2200_3	6
 #define SAA7164_BOARD_HAUPPAUGE_HVR2250_2	7
 #define SAA7164_BOARD_HAUPPAUGE_HVR2250_3	8
+#define SAA7164_BOARD_HAUPPAUGE_HVR2200_4	9
 
 #define SAA7164_MAX_UNITS		8
 #define SAA7164_TS_NUMBER_OF_LINES	312
@@ -113,7 +114,7 @@
 #define DBGLVL_THR 4096
 #define DBGLVL_CPU 8192
 
-#define SAA7164_NORMS (V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP |  V4L2_STD_NTSC_443)
+#define SAA7164_NORMS (V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP |  V4L2_STD_NTSC_443 | V4L2_STD_PAL_I | V4L2_STD_PAL_M | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc | V4L2_STD_PAL_B | V4L2_STD_PAL_DK)
 
 enum port_t {
 	SAA7164_MPEG_UNDEFINED = 0,
diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-vbi.c linux-2.6.37/drivers/media/video/saa7164//saa7164-vbi.c
--- linux-2.6.37-rc8.a/drivers/media/video/saa7164//saa7164-vbi.c	2010-12-29 02:05:48.000000000 +0100
+++ linux-2.6.37/drivers/media/video/saa7164//saa7164-vbi.c	2011-01-06 23:10:04.000000000 +0100
@@ -28,7 +28,25 @@
 	}, {
 		.name      = "NTSC-JP",
 		.id        = V4L2_STD_NTSC_M_JP,
-	}
+	}, {
+                .name      = "PAL-I",
+                .id        = V4L2_STD_PAL_I,
+        }, {
+                .name      = "PAL-M",
+                .id        = V4L2_STD_PAL_M,
+        }, {
+                .name      = "PAL-N",
+                .id        = V4L2_STD_PAL_N,
+        }, {
+                .name      = "PAL-Nc",
+                .id        = V4L2_STD_PAL_Nc,
+        }, {
+                .name      = "PAL-B",
+                .id        = V4L2_STD_PAL_B,
+        }, {
+                .name      = "PAL-DK",
+                .id        = V4L2_STD_PAL_DK,
+        }
 };
 
 static const u32 saa7164_v4l2_ctrls[] = {

--------------030104030200050908020507--
