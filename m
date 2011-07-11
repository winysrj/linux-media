Return-path: <mchehab@localhost>
Received: from mail.juropnet.hu ([212.24.188.131]:38355 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab1GKN6q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 09:58:46 -0400
Received: from [94.248.228.50] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QgH0P-0006dm-BD
	for linux-media@vger.kernel.org; Mon, 11 Jul 2011 15:58:43 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH] cx23885: added support for card 107d:6f39
MIME-Version: 1.0
Date: Mon, 11 Jul 2011 15:58:35 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107111558.35588.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This patch, based on code by Mirek Slugen, implements support for the
Leadtek WinFast PxDVR3200 H card with XC4000 tuner (107d:6f39).

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr xc4000_orig/drivers/media/video/cx23885/cx23885-cards.c xc4000/drivers/media/video/cx23885/cx23885-cards.c
--- xc4000_orig/drivers/media/video/cx23885/cx23885-cards.c	2011-07-08 16:47:29.000000000 +0200
+++ xc4000/drivers/media/video/cx23885/cx23885-cards.c	2011-07-10 13:31:15.000000000 +0200
@@ -31,6 +31,7 @@
 #include "tuner-xc2028.h"
 #include "netup-init.h"
 #include "altera-ci.h"
+#include "xc4000.h"
 #include "xc5000.h"
 #include "cx23888-ir.h"
 
@@ -175,6 +176,34 @@
 		.name		= "Leadtek Winfast PxDVR3200 H",
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000] = {
+		.name		= "Leadtek Winfast PxDVR3200 H XC4000",
+		.porta		= CX23885_ANALOG_VIDEO,
+		.portc		= CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_XC4000,
+		.tuner_addr	= 0x61,
+		.radio_type	= TUNER_XC4000,
+		.radio_addr	= 0x61,
+		.input		= {{
+			.type	= CX23885_VMUX_TELEVISION,
+			.vmux	= CX25840_VIN2_CH1 |
+				  CX25840_VIN5_CH2 |
+				  CX25840_NONE0_CH3,
+		}, {
+			.type	= CX23885_VMUX_COMPOSITE1,
+			.vmux	= CX25840_COMPOSITE1,
+		}, {
+			.type	= CX23885_VMUX_SVIDEO,
+			.vmux	= CX25840_SVIDEO_LUMA3 |
+				  CX25840_SVIDEO_CHROMA4,
+		}, {
+			.type	= CX23885_VMUX_COMPONENT,
+			.vmux	= CX25840_VIN7_CH1 |
+				  CX25840_VIN6_CH2 |
+				  CX25840_VIN8_CH3 |
+				  CX25840_COMPONENT_ON,
+		} },
+	},
 	[CX23885_BOARD_COMPRO_VIDEOMATE_E650F] = {
 		.name		= "Compro VideoMate E650F",
 		.portc		= CX23885_MPEG_DVB,
@@ -433,6 +462,10 @@
 		.subdevice = 0x6681,
 		.card      = CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
 	}, {
+		.subvendor = 0x107d,
+		.subdevice = 0x6f39,
+		.card	   = CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000,
+	}, {
 		.subvendor = 0x185b,
 		.subdevice = 0xe800,
 		.card      = CX23885_BOARD_COMPRO_VIDEOMATE_E650F,
@@ -749,6 +782,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
@@ -909,6 +943,7 @@
 		cx_set(GP0_IO, 0x000f000f);
 		break;
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
@@ -1334,6 +1369,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
 	case CX23885_BOARD_HAUPPAUGE_HVR1275:
@@ -1362,6 +1398,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
diff -uNr xc4000_orig/drivers/media/video/cx23885/cx23885-dvb.c xc4000/drivers/media/video/cx23885/cx23885-dvb.c
--- xc4000_orig/drivers/media/video/cx23885/cx23885-dvb.c	2011-07-08 16:47:29.000000000 +0200
+++ xc4000/drivers/media/video/cx23885/cx23885-dvb.c	2011-07-10 13:36:32.000000000 +0200
@@ -37,6 +37,7 @@
 #include "tda8290.h"
 #include "tda18271.h"
 #include "lgdt330x.h"
+#include "xc4000.h"
 #include "xc5000.h"
 #include "max2165.h"
 #include "tda10048.h"
@@ -921,6 +922,26 @@
 				fe->ops.tuner_ops.set_config(fe, &ctl);
 		}
 		break;
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
+		i2c_bus = &dev->i2c_bus[0];
+
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
+					       &dvico_fusionhdtv_xc3028,
+					       &i2c_bus->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			struct dvb_frontend	*fe;
+			struct xc4000_config	cfg = {
+				.i2c_address	  = 0x61,
+				.default_pm	  = 0,
+				.dvb_amplitude	  = 134,
+				.set_smoothedcvbs = 1,
+				.if_khz		  = 4560
+			};
+
+			fe = dvb_attach(xc4000_attach, fe0->dvb.frontend,
+					&dev->i2c_bus[1].i2c_adap, &cfg);
+		}
+		break;
 	case CX23885_BOARD_TBS_6920:
 		i2c_bus = &dev->i2c_bus[1];
 
diff -uNr xc4000_orig/drivers/media/video/cx23885/cx23885.h xc4000/drivers/media/video/cx23885/cx23885.h
--- xc4000_orig/drivers/media/video/cx23885/cx23885.h	2011-07-08 16:47:29.000000000 +0200
+++ xc4000/drivers/media/video/cx23885/cx23885.h	2011-07-10 13:26:11.000000000 +0200
@@ -85,6 +85,7 @@
 #define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200 28
 #define CX23885_BOARD_GOTVIEW_X5_3D_HYBRID     29
 #define CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF 30
+#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000 31
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
