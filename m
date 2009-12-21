Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37813 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZLUE4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2009 23:56:19 -0500
Received: by bwz27 with SMTP id 27so3240304bwz.21
        for <linux-media@vger.kernel.org>; Sun, 20 Dec 2009 20:56:17 -0800 (PST)
Date: Mon, 21 Dec 2009 14:00:38 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] Add lost config and PCI ID for card of Beholder
Message-ID: <20091221140038.18ab7b24@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/pHVPk3o+ZiwVJvLXzxmctSS"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/pHVPk3o+ZiwVJvLXzxmctSS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

Add lost configuration for our TV card.

diff -r 79fc32bba0a0 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Dec 14 17:43:13 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Dec 16 11:02:53 2009 +0900
@@ -4199,7 +4199,7 @@
 			.amux = LINE2,
 		},
 	},
-	[SAA7134_BOARD_BEHOLD_505RDS] = {
+	[SAA7134_BOARD_BEHOLD_505RDS_MK5] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV 505 RDS",
@@ -5359,6 +5359,41 @@
 			.vmux = 8,
 		} },
 	},
+	[SAA7134_BOARD_BEHOLD_505RDS_MK3] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 505 RDS",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = LINE2,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+		},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
 
 };
 
@@ -6274,7 +6309,13 @@
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = 0x0000,
 		.subdevice    = 0x505B,
-		.driver_data  = SAA7134_BOARD_BEHOLD_505RDS,
+		.driver_data  = SAA7134_BOARD_BEHOLD_505RDS_MK5,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x0000,
+		.subdevice    = 0x5051,
+		.driver_data  = SAA7134_BOARD_BEHOLD_505RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
@@ -6872,7 +6913,8 @@
 	case SAA7134_BOARD_BEHOLD_407FM:
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
-	case SAA7134_BOARD_BEHOLD_505RDS:
+	case SAA7134_BOARD_BEHOLD_505RDS_MK5:
+	case SAA7134_BOARD_BEHOLD_505RDS_MK3:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
diff -r 79fc32bba0a0 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Mon Dec 14 17:43:13 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Wed Dec 16 11:02:53 2009 +0900
@@ -625,7 +625,8 @@
 	case SAA7134_BOARD_BEHOLD_407FM:
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
-	case SAA7134_BOARD_BEHOLD_505RDS:
+	case SAA7134_BOARD_BEHOLD_505RDS_MK5:
+	case SAA7134_BOARD_BEHOLD_505RDS_MK3:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
diff -r 79fc32bba0a0 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Dec 14 17:43:13 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Dec 16 11:02:53 2009 +0900
@@ -283,7 +283,7 @@
 #define SAA7134_BOARD_HAUPPAUGE_HVR1120   156
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_507UA 157
 #define SAA7134_BOARD_AVERMEDIA_CARDBUS_501 158
-#define SAA7134_BOARD_BEHOLD_505RDS         159
+#define SAA7134_BOARD_BEHOLD_505RDS_MK5     159
 #define SAA7134_BOARD_BEHOLD_507RDS_MK3     160
 #define SAA7134_BOARD_BEHOLD_507RDS_MK5     161
 #define SAA7134_BOARD_BEHOLD_607FM_MK5      162
@@ -300,6 +300,7 @@
 #define SAA7134_BOARD_ZOLID_HYBRID_PCI		173
 #define SAA7134_BOARD_ASUS_EUROPA_HYBRID	174
 #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
+#define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/pHVPk3o+ZiwVJvLXzxmctSS
Content-Type: text/x-patch; name=behold_505rds_mk3.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_505rds_mk3.patch

diff -r 79fc32bba0a0 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Dec 14 17:43:13 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Dec 16 11:02:53 2009 +0900
@@ -4199,7 +4199,7 @@
 			.amux = LINE2,
 		},
 	},
-	[SAA7134_BOARD_BEHOLD_505RDS] = {
+	[SAA7134_BOARD_BEHOLD_505RDS_MK5] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV 505 RDS",
@@ -5359,6 +5359,41 @@
 			.vmux = 8,
 		} },
 	},
+	[SAA7134_BOARD_BEHOLD_505RDS_MK3] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 505 RDS",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = LINE2,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+		},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
 
 };
 
@@ -6274,7 +6309,13 @@
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = 0x0000,
 		.subdevice    = 0x505B,
-		.driver_data  = SAA7134_BOARD_BEHOLD_505RDS,
+		.driver_data  = SAA7134_BOARD_BEHOLD_505RDS_MK5,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x0000,
+		.subdevice    = 0x5051,
+		.driver_data  = SAA7134_BOARD_BEHOLD_505RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
@@ -6872,7 +6913,8 @@
 	case SAA7134_BOARD_BEHOLD_407FM:
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
-	case SAA7134_BOARD_BEHOLD_505RDS:
+	case SAA7134_BOARD_BEHOLD_505RDS_MK5:
+	case SAA7134_BOARD_BEHOLD_505RDS_MK3:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
diff -r 79fc32bba0a0 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Mon Dec 14 17:43:13 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Wed Dec 16 11:02:53 2009 +0900
@@ -625,7 +625,8 @@
 	case SAA7134_BOARD_BEHOLD_407FM:
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
-	case SAA7134_BOARD_BEHOLD_505RDS:
+	case SAA7134_BOARD_BEHOLD_505RDS_MK5:
+	case SAA7134_BOARD_BEHOLD_505RDS_MK3:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
 	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
diff -r 79fc32bba0a0 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Dec 14 17:43:13 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Dec 16 11:02:53 2009 +0900
@@ -283,7 +283,7 @@
 #define SAA7134_BOARD_HAUPPAUGE_HVR1120   156
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_507UA 157
 #define SAA7134_BOARD_AVERMEDIA_CARDBUS_501 158
-#define SAA7134_BOARD_BEHOLD_505RDS         159
+#define SAA7134_BOARD_BEHOLD_505RDS_MK5     159
 #define SAA7134_BOARD_BEHOLD_507RDS_MK3     160
 #define SAA7134_BOARD_BEHOLD_507RDS_MK5     161
 #define SAA7134_BOARD_BEHOLD_607FM_MK5      162
@@ -300,6 +300,7 @@
 #define SAA7134_BOARD_ZOLID_HYBRID_PCI		173
 #define SAA7134_BOARD_ASUS_EUROPA_HYBRID	174
 #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
+#define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/pHVPk3o+ZiwVJvLXzxmctSS--
