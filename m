Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:57644 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZHZEBr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 00:01:47 -0400
Received: by ewy2 with SMTP id 2so1052619ewy.17
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2009 21:01:47 -0700 (PDT)
Date: Wed, 26 Aug 2009 14:01:12 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATH] Add support BeholdTV X7 card
Message-ID: <20090826140112.33c3bad6@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_//cQs0aKmVloJpJ0r=B1N6ak"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_//cQs0aKmVloJpJ0r=B1N6ak
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi 

Add support our new TV card based on xc5000 and saa7134. Analog TV works well.

diff -r 28f8b0ebd224 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Aug 23 13:55:25 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Aug 26 08:52:37 2009 +1000
@@ -32,6 +32,7 @@
 #include <media/tveeprom.h>
 #include "tea5767.h"
 #include "tda18271.h"
+#include "xc5000.h"
 
 /* commly used strings */
 static char name_mute[]    = "mute";
@@ -5182,6 +5183,34 @@
 			.amux	= LINE1
 		} },
 	},
+	[SAA7134_BOARD_BEHOLD_X7] = {
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV X7",
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
+
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6295,6 +6324,12 @@
 		.subvendor    = 0x185b,
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_S350,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7595,
+		.driver_data  = SAA7134_BOARD_BEHOLD_X7,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -6418,11 +6453,20 @@
 	return -EINVAL;
 }
 
-#if 0
+#if 1
 static int saa7134_xc5000_callback(struct saa7134_dev *dev,
 				   int command, int arg)
 {
 	switch (dev->board) {
+	case SAA7134_BOARD_BEHOLD_X7:
+		if (command == XC5000_TUNER_RESET) {
+		/* Down and UP pheripherial RESET pin for reset all chips */
+			saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
+			msleep(10);
+			saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
+			msleep(10);
+		}
+		break;
 	default:
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0x06e20000);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0x06a20000);
@@ -6533,7 +6577,7 @@
 			return saa7134_tda8290_callback(dev, command, arg);
 		case TUNER_XC2028:
 			return saa7134_xc2028_callback(dev, command, arg);
-#if 0
+#if 1
 		case TUNER_XC5000:
 			return saa7134_xc5000_callback(dev, command, arg);
 #endif
@@ -6788,6 +6832,7 @@
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
+	case SAA7134_BOARD_BEHOLD_X7:
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:
diff -r 28f8b0ebd224 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Aug 23 13:55:25 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Wed Aug 26 08:52:37 2009 +1000
@@ -854,6 +854,7 @@
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
+	case SAA7134_BOARD_BEHOLD_X7:
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
 		snprintf(ir->c.name, sizeof(ir->c.name), "BeholdTV");
 		ir->get_key   = get_key_beholdm6xx;
diff -r 28f8b0ebd224 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Aug 23 13:55:25 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Aug 26 08:52:37 2009 +1000
@@ -294,6 +294,7 @@
 #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
 #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
 #define SAA7134_BOARD_VIDEOMATE_S350        169
+#define SAA7134_BOARD_BEHOLD_X7             170
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--MP_//cQs0aKmVloJpJ0r=B1N6ak
Content-Type: text/x-patch; name=behold_x7.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_x7.diff

diff -r 28f8b0ebd224 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Aug 23 13:55:25 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Aug 26 08:52:37 2009 +1000
@@ -32,6 +32,7 @@
 #include <media/tveeprom.h>
 #include "tea5767.h"
 #include "tda18271.h"
+#include "xc5000.h"
 
 /* commly used strings */
 static char name_mute[]    = "mute";
@@ -5182,6 +5183,34 @@
 			.amux	= LINE1
 		} },
 	},
+	[SAA7134_BOARD_BEHOLD_X7] = {
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV X7",
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
+
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6295,6 +6324,12 @@
 		.subvendor    = 0x185b,
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_S350,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7595,
+		.driver_data  = SAA7134_BOARD_BEHOLD_X7,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -6418,11 +6453,20 @@
 	return -EINVAL;
 }
 
-#if 0
+#if 1
 static int saa7134_xc5000_callback(struct saa7134_dev *dev,
 				   int command, int arg)
 {
 	switch (dev->board) {
+	case SAA7134_BOARD_BEHOLD_X7:
+		if (command == XC5000_TUNER_RESET) {
+		/* Down and UP pheripherial RESET pin for reset all chips */
+			saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
+			msleep(10);
+			saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
+			msleep(10);
+		}
+		break;
 	default:
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0x06e20000);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0x06a20000);
@@ -6533,7 +6577,7 @@
 			return saa7134_tda8290_callback(dev, command, arg);
 		case TUNER_XC2028:
 			return saa7134_xc2028_callback(dev, command, arg);
-#if 0
+#if 1
 		case TUNER_XC5000:
 			return saa7134_xc5000_callback(dev, command, arg);
 #endif
@@ -6788,6 +6832,7 @@
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
+	case SAA7134_BOARD_BEHOLD_X7:
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:
diff -r 28f8b0ebd224 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Aug 23 13:55:25 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Wed Aug 26 08:52:37 2009 +1000
@@ -854,6 +854,7 @@
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
+	case SAA7134_BOARD_BEHOLD_X7:
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
 		snprintf(ir->c.name, sizeof(ir->c.name), "BeholdTV");
 		ir->get_key   = get_key_beholdm6xx;
diff -r 28f8b0ebd224 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Aug 23 13:55:25 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Aug 26 08:52:37 2009 +1000
@@ -294,6 +294,7 @@
 #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
 #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
 #define SAA7134_BOARD_VIDEOMATE_S350        169
+#define SAA7134_BOARD_BEHOLD_X7             170
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_//cQs0aKmVloJpJ0r=B1N6ak--
