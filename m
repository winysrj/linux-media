Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:48969 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358AbZDNSeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 14:34:10 -0400
From: =?utf-8?q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] Added support for AVerMedia Cardbus Plus
Date: Tue, 14 Apr 2009 20:34:00 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200904142034.00667.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here comes the full support for AVerMedia Cardbus Plus (E501R) - including
remote control. TV, Composite and FM radio tested, I don't have S-Video to 
test. I've figured out that the radio works only with xtal frequency 13MHz.

Signed-off-by: Oldřich Jedlička <oldium.pro@seznam.cz>
---
diff -r dba0b6fae413 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Apr 09 08:21:42 
2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Mon Apr 13 23:21:53 2009 
+0200
@@ -282,6 +282,7 @@
 #define SAA7134_BOARD_HAUPPAUGE_HVR1120     155
 #define SAA7134_BOARD_HAUPPAUGE_HVR1110R3   156
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_507UA 157
+#define SAA7134_BOARD_AVERMEDIA_CARDBUS_501 158
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff -r dba0b6fae413 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Apr 09 08:21:42 
2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Apr 13 23:21:53 
2009 +0200
@@ -1669,6 +1669,39 @@
 			.amux = LINE1,
 		},
 	},
+	[SAA7134_BOARD_AVERMEDIA_CARDBUS_501] = {
+		/* Kees.Blom@cwi.nl */
+		.name           = "AVerMedia Cardbus TV/Radio (E501R)",
+		.audio_clock    = 0x187de7,
+		.tuner_type     = TUNER_ALPS_TSBE5_PAL,
+		.radio_type     = TUNER_TEA5767,
+		.tuner_addr	= 0x61,
+		.radio_addr	= 0x60,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x08000000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+			.gpio = 0x08000000,
+		},{
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+			.gpio = 0x08000000,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+			.gpio = 0x08000000,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+			.gpio = 0x00000000,
+		},
+	},
 	[SAA7134_BOARD_CINERGY400_CARDBUS] = {
 		.name           = "Terratec Cinergy 400 mobile",
 		.audio_clock    = 0x187de7,
@@ -5104,6 +5137,13 @@
 		.subdevice    = 0xd6ee,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_CARDBUS,
 	},{
+		/* AVerMedia CardBus */
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0xb7e9,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_CARDBUS_501,
+	},{
 		/* TransGear 3000TV */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
@@ -6341,6 +6381,16 @@
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0xffffffff);
 		msleep(10);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
+		/* power-down tuner chip */
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x08400000, 0x08400000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x08400000, 0);
+		msleep(10);
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x08400000, 0x08400000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x08400000, 0x08400000);
+		msleep(10);
+		dev->has_remote = SAA7134_REMOTE_I2C;
+		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 		saa7134_set_gpio(dev, 23, 0);
 		msleep(10);
@@ -6782,6 +6832,7 @@
 
 	switch (dev->board) {
 	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
+	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
 	{
 		struct v4l2_priv_tun_config tea5767_cfg;
 		struct tea5767_ctrl ctl;
