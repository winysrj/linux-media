Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8TNv0u5026300
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 19:57:01 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8TNuhEd030210
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 19:56:44 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Content-Type: multipart/mixed; boundary="=-+KJM/tOJwkZvadFVRcu6"
Date: Tue, 30 Sep 2008 01:51:33 +0200
Message-Id: <1222732293.3988.32.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: [PATCH] saa7134: fixes for the Asus Tiger Revision 1.00
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--=-+KJM/tOJwkZvadFVRcu6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Hi Mauro,

have retested the above card.

Please apply from the attachment.

Thanks,
Hermann


saa7134: fixes for the Asus Tiger Revision 1.00

From: Hermann Pitton <hermann-pitton@arcor.de>

In opposite to the P7131 Dual this early OEM card has a male
radio antenna connector and also no remote.

We currently switch the DVB-T RF feed to the radio input, like
on the P7131 with female radio connector used also for DVB-T
and should improve this.

Priority: normal

Signed-off-by: Hermann Pitton <hermann-pitton@arcor.de>

diff -r 24bc99070e97 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Sep 29 05:25:40 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Sep 29 21:56:10 2008 +0200
@@ -4566,7 +4566,7 @@
 			.amux   = LINE2,
 			.tv     = 1,
 			.gpio   = 0x624000,
-	}, {
+		}, {
 			.name   = name_comp1,
 			.vmux   = 1,
 			.amux   = LINE1,
@@ -4603,13 +4603,47 @@
 			.tv   = 1,
 		}, {
 			.name = name_comp,
-		       .vmux = 4,
-		       .amux = LINE1,
-		}, {
-			.name = name_svideo,
-			.vmux = 8,
-			.amux = LINE1,
-		} },
+			.vmux = 4,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+	},
+	[SAA7134_BOARD_ASUSTeK_TIGER] = {
+		.name           = "Asus Tiger Rev:1.00",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tuner_config   = 0,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.gpiomask       = 0x0200000,
+		.inputs = { {
+			.name   = name_tv,
+			.vmux   = 1,
+			.amux   = TV,
+			.tv     = 1,
+		}, {
+			.name   = name_comp1,
+			.vmux   = 3,
+			.amux   = LINE2,
+		}, {
+			.name   = name_comp2,
+			.vmux   = 0,
+			.amux   = LINE2,
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE2,
+		} },
+		.radio = {
+			.name   = name_radio,
+			.amux   = TV,
+			.gpio   = 0x0200000,
+		},
 	},
 };
 
@@ -5397,8 +5431,8 @@
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1043,
-		.subdevice    = 0x4857,
-		.driver_data  = SAA7134_BOARD_ASUSTeK_P7131_DUAL,
+		.subdevice    = 0x4857,		/* REV:1.00 */
+		.driver_data  = SAA7134_BOARD_ASUSTeK_TIGER,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -6280,6 +6314,7 @@
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
 	case SAA7134_BOARD_KWORLD_DVBT_210:
 	case SAA7134_BOARD_TEVION_DVBT_220RF:
+	case SAA7134_BOARD_ASUSTeK_TIGER:
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_MEDION_MD8800_QUADRO:
diff -r 24bc99070e97 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Sep 29 05:25:40 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Sep 29 21:56:10 2008 +0200
@@ -1339,6 +1339,11 @@
 			}
 		}
 		break;
+	case SAA7134_BOARD_ASUSTeK_TIGER:
+		if (configure_tda827x_fe(dev, &philips_tiger_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r 24bc99070e97 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Sep 29 05:25:40 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Mon Sep 29 21:56:10 2008 +0200
@@ -275,6 +275,7 @@
 #define SAA7134_BOARD_AVERMEDIA_M135A    149
 #define SAA7134_BOARD_REAL_ANGEL_220     150
 #define SAA7134_BOARD_ADS_INSTANT_HDTV_PCI  151
+#define SAA7134_BOARD_ASUSTeK_TIGER         152
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8




--=-+KJM/tOJwkZvadFVRcu6
Content-Description: 
Content-Disposition: inline; filename=saa7134_asus-tiger-rev1_fixes.patch
Content-Type: text/x-patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 24bc99070e97 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Sep 29 05:25:40 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Sep 29 21:56:10 2008 +0200
@@ -4566,7 +4566,7 @@
 			.amux   = LINE2,
 			.tv     = 1,
 			.gpio   = 0x624000,
-	}, {
+		}, {
 			.name   = name_comp1,
 			.vmux   = 1,
 			.amux   = LINE1,
@@ -4603,13 +4603,47 @@
 			.tv   = 1,
 		}, {
 			.name = name_comp,
-		       .vmux = 4,
-		       .amux = LINE1,
-		}, {
-			.name = name_svideo,
-			.vmux = 8,
-			.amux = LINE1,
-		} },
+			.vmux = 4,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+	},
+	[SAA7134_BOARD_ASUSTeK_TIGER] = {
+		.name           = "Asus Tiger Rev:1.00",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tuner_config   = 0,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.gpiomask       = 0x0200000,
+		.inputs = { {
+			.name   = name_tv,
+			.vmux   = 1,
+			.amux   = TV,
+			.tv     = 1,
+		}, {
+			.name   = name_comp1,
+			.vmux   = 3,
+			.amux   = LINE2,
+		}, {
+			.name   = name_comp2,
+			.vmux   = 0,
+			.amux   = LINE2,
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE2,
+		} },
+		.radio = {
+			.name   = name_radio,
+			.amux   = TV,
+			.gpio   = 0x0200000,
+		},
 	},
 };
 
@@ -5397,8 +5431,8 @@
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1043,
-		.subdevice    = 0x4857,
-		.driver_data  = SAA7134_BOARD_ASUSTeK_P7131_DUAL,
+		.subdevice    = 0x4857,		/* REV:1.00 */
+		.driver_data  = SAA7134_BOARD_ASUSTeK_TIGER,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -6280,6 +6314,7 @@
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
 	case SAA7134_BOARD_KWORLD_DVBT_210:
 	case SAA7134_BOARD_TEVION_DVBT_220RF:
+	case SAA7134_BOARD_ASUSTeK_TIGER:
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_MEDION_MD8800_QUADRO:
diff -r 24bc99070e97 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Sep 29 05:25:40 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Sep 29 21:56:10 2008 +0200
@@ -1339,6 +1339,11 @@
 			}
 		}
 		break;
+	case SAA7134_BOARD_ASUSTeK_TIGER:
+		if (configure_tda827x_fe(dev, &philips_tiger_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r 24bc99070e97 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Sep 29 05:25:40 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Mon Sep 29 21:56:10 2008 +0200
@@ -275,6 +275,7 @@
 #define SAA7134_BOARD_AVERMEDIA_M135A    149
 #define SAA7134_BOARD_REAL_ANGEL_220     150
 #define SAA7134_BOARD_ADS_INSTANT_HDTV_PCI  151
+#define SAA7134_BOARD_ASUSTeK_TIGER         152
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

--=-+KJM/tOJwkZvadFVRcu6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-+KJM/tOJwkZvadFVRcu6--
