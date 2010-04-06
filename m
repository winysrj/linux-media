Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:41629 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab0DFD6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 23:58:12 -0400
Received: by ewy20 with SMTP id 20so265556ewy.1
        for <linux-media@vger.kernel.org>; Mon, 05 Apr 2010 20:58:10 -0700 (PDT)
Date: Tue, 6 Apr 2010 14:00:05 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Add support new TV cards
Message-ID: <20100406140005.49505a01@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi 

Add support our new TV cards.

diff -r 4ee1e97ba6ad linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Apr 04 20:58:13 2010 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Apr 06 13:51:11 2010 +1000
@@ -5411,6 +5411,62 @@
 			.gpio = 0x389c00,
 		} },
 	},
+	[SAA7134_BOARD_BEHOLD_H7] = {
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV H7",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_XC5000,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 2,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 9,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_A7] = {
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV A7",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_XC5000,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 2,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 9,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+		},
+	},
 
 };
 
@@ -6605,6 +6661,18 @@
 		.subvendor    = PCI_ANY_ID,
 		.subdevice    = PCI_ANY_ID,
 		.driver_data  = SAA7134_BOARD_UNKNOWN,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7190,
+		.driver_data  = SAA7134_BOARD_BEHOLD_H7,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7090,
+		.driver_data  = SAA7134_BOARD_BEHOLD_A7,
 	},{
 		/* --- end of list --- */
 	}
@@ -6696,6 +6764,8 @@
 {
 	switch (dev->board) {
 	case SAA7134_BOARD_BEHOLD_X7:
+	case SAA7134_BOARD_BEHOLD_H7:
+	case SAA7134_BOARD_BEHOLD_A7:
 		if (command == XC5000_TUNER_RESET) {
 		/* Down and UP pheripherial RESET pin for reset all chips */
 			saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
@@ -7074,6 +7144,8 @@
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
 	case SAA7134_BOARD_BEHOLD_X7:
+	case SAA7134_BOARD_BEHOLD_H7:
+	case SAA7134_BOARD_BEHOLD_A7:
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:
diff -r 4ee1e97ba6ad linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sun Apr 04 20:58:13 2010 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Apr 06 13:51:11 2010 +1000
@@ -1537,6 +1537,15 @@
 				   &dev->i2c_adap, &behold_x7_tunerconfig);
 		}
 		break;
+	case SAA7134_BOARD_BEHOLD_H7:
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
+						&behold_x7_config,
+						&dev->i2c_adap);
+		if (fe0->dvb.frontend) {
+			dvb_attach(xc5000_attach, fe0->dvb.frontend,
+				   &dev->i2c_adap, &behold_x7_tunerconfig);
+		}
+		break;
 	case SAA7134_BOARD_AVERMEDIA_A700_PRO:
 	case SAA7134_BOARD_AVERMEDIA_A700_HYBRID:
 		/* Zarlink ZL10313 */
diff -r 4ee1e97ba6ad linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Apr 04 20:58:13 2010 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Tue Apr 06 13:51:11 2010 +1000
@@ -942,6 +942,8 @@
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
 	case SAA7134_BOARD_BEHOLD_X7:
+	case SAA7134_BOARD_BEHOLD_H7:
+	case SAA7134_BOARD_BEHOLD_A7:
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
 		snprintf(ir->c.name, sizeof(ir->c.name), "BeholdTV");
 		ir->get_key   = get_key_beholdm6xx;
diff -r 4ee1e97ba6ad linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Apr 04 20:58:13 2010 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 06 13:51:11 2010 +1000
@@ -302,6 +302,8 @@
 #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
 #define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
 #define SAA7134_BOARD_HAWELL_HW_404M7		177
+#define SAA7134_BOARD_BEHOLD_H7             178
+#define SAA7134_BOARD_BEHOLD_A7             179
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
