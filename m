Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:61836 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZH2MZM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2009 08:25:12 -0400
Received: by ewy2 with SMTP id 2so2814679ewy.17
        for <linux-media@vger.kernel.org>; Sat, 29 Aug 2009 05:25:12 -0700 (PDT)
From: Eugene Yudin <eugene.yudin@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Subject: [PATCH] Add support for RoverMedia TV Link Pro FM
Date: Sat, 29 Aug 2009 16:32:11 +0400
Cc: linux-media@vger.kernel.org
References: <200908272104.59221.Eugene.Yudin@gmail.com> <1251492543.9277.23.camel@pc07.localdom.local> <200908291613.16863.Eugene.Yudin@gmail.com>
In-Reply-To: <200908291613.16863.Eugene.Yudin@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_L/RmK466SjMJtCD"
Message-Id: <200908291632.11813.Eugene.Yudin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_L/RmK466SjMJtCD
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

This patch add support for RoverMedia TV Link Pro FM (LR138 REV:I) card based 
on saa7134.

Signed-off-by: Eugene Yudin <Eugene.Yudin@gmail.com>

Best Regards,
Eugene

--Boundary-00=_L/RmK466SjMJtCD
Content-Type: text/x-patch;
  charset="UTF-8";
  name="saa7134_support-Rovermedia-TV-Link-Pro-FM.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="saa7134_support-Rovermedia-TV-Link-Pro-FM.patch"

diff -r ad2f24d34b83 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Fri Aug 28 04:12:06 2009 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Sat Aug 29 15:53:10 2009 +0400
@@ -168,3 +168,4 @@
 167 -> Beholder BeholdTV 609 RDS                [5ace:6092]
 168 -> Beholder BeholdTV 609 RDS                [5ace:6093]
 169 -> Compro VideoMate S350/S300               [185b:c900]
+170 -> RoverMedia TV Link Pro FM                [19d1:0138]
diff -r ad2f24d34b83 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Aug 28 04:12:06 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Aug 29 15:53:10 2009 +0400
@@ -5182,6 +5182,56 @@
 			.amux	= LINE1
 		} },
 	},
+	[SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM] = {
+		/* RoverMedia TV Link Pro FM (LR138 REV:I) */
+		/* Eugene Yudin <Eugene.Yudin@gmail.com> */
+		.name		= "RoverMedia TV Link Pro FM",
+		.audio_clock	= 0x00200000,
+		.tuner_type	= TUNER_PHILIPS_FM1216ME_MK3, /* TCL MFPE05 2 */
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0xe000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.gpio = 0x8000,
+			.tv   = 1,
+		},{
+			.name = name_tv_mono,
+			.vmux = 1,
+			.amux = LINE2,
+			.gpio = 0x0000,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE2,
+			.gpio = 0x4000,
+		},{
+			.name = name_comp2,
+			.vmux = 3,
+			.amux = LINE2,
+			.gpio = 0x4000,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+			.gpio = 0x4000,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+			.gpio = 0x2000,
+		},
+		.mute = {
+			.name = name_mute,
+			.amux = TV,
+			.gpio = 0x8000,
+		},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6296,6 +6346,12 @@
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_S350,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x19d1, /* RoverMedia */
+		.subdevice    = 0x0138, /* LifeView FlyTV Prime30 OEM */
+		.driver_data  = SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -6656,6 +6712,7 @@
 	case SAA7134_BOARD_REAL_ANGEL_220:
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
 	case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
+	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
diff -r ad2f24d34b83 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Fri Aug 28 04:12:06 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Sat Aug 29 15:53:10 2009 +0400
@@ -456,6 +456,7 @@
 	case SAA7134_BOARD_FLYVIDEO3000:
 	case SAA7134_BOARD_FLYTVPLATINUM_FM:
 	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
+	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
 		ir_codes     = ir_codes_flyvideo;
 		mask_keycode = 0xEC00000;
 		mask_keydown = 0x0040000;
diff -r ad2f24d34b83 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Fri Aug 28 04:12:06 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Sat Aug 29 15:53:10 2009 +0400
@@ -294,6 +294,7 @@
 #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
 #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
 #define SAA7134_BOARD_VIDEOMATE_S350        169
+#define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM     170
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

--Boundary-00=_L/RmK466SjMJtCD--
