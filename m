Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:55289
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZIGM7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 08:59:44 -0400
Date: Mon, 7 Sep 2009 14:49:34 +0200
From: spam@systol-ng.god.lan
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for Zolid Hybrid PCI card
Message-ID: <20090907124934.GA8339@systol-ng.god.lan>
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com> <13c90c570909070127j11ae6ee2w2aa677529096f820@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <13c90c570909070127j11ae6ee2w2aa677529096f820@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hmm gmail front-end encoded the attachment as binary, retry.... 
----- snip -----

This patch adds support for Zolid Hybrid TV card. The results are
pretty encouraging DVB reception and analog TV reception are confirmed
to work. Might still need to find the GPIO pin that switches AGC on
the TDA18271 for even better reception.

see:
http://linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner
for more information.

Signed-off-by: Henk.Vergonet@gmail.com


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Zolid_Hybrid_PCI.patch"

diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Sep 07 00:16:24 2009 +0200
@@ -3521,6 +3521,35 @@
 			.gpio = 0x0800100, /* GPIO 23 HI for FM */
 		},
 	},
+	[SAA7134_BOARD_ZOLID_HYBRID_PCI] = {
+		.name           = "NXP Europa DVB-T hybrid reference design",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tuner_config   = 3,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 6,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+		},
+	},
 	[SAA7134_BOARD_CINERGY_HT_PCMCIA] = {
 		.name           = "Terratec Cinergy HT PCMCIA",
 		.audio_clock    = 0x00187de7,
@@ -6429,6 +6458,12 @@
 		.subdevice    = 0x0138, /* LifeView FlyTV Prime30 OEM */
 		.driver_data  = SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = PCI_VENDOR_ID_PHILIPS,
+		.subdevice    = 0x2004,
+		.driver_data  = SAA7134_BOARD_ZOLID_HYBRID_PCI,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -6655,6 +6690,7 @@
 	switch (dev->board) {
 	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
 	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
+	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
 		/* tda8290 + tda18271 */
 		ret = saa7134_tda8290_18271_callback(dev, command, arg);
 		break;
diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Sep 07 00:16:24 2009 +0200
@@ -1125,6 +1125,13 @@
 			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
+	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
+		/* match interface type of SAA713x and TDA10048 */
+                if (saa7134_boards[dev->board].ts_type == SAA7134_MPEG_TS_PARALLEL) {
+			hcw_tda10048_config.output_mode = TDA10048_PARALLEL_OUTPUT;
+		} else {
+			hcw_tda10048_config.output_mode = TDA10048_SERIAL_OUTPUT;
+		}
 		fe0->dvb.frontend = dvb_attach(tda10048_attach,
 					       &hcw_tda10048_config,
 					       &dev->i2c_adap);
diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Mon Sep 07 00:16:24 2009 +0200
@@ -297,6 +297,7 @@
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_505  170
 #define SAA7134_BOARD_BEHOLD_X7             171
 #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
+#define SAA7134_BOARD_ZOLID_HYBRID_PCI		173
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

--cWoXeonUoKmBZSoM--
