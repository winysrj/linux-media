Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mANBmFOS020794
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 06:48:15 -0500
Received: from speedy.tutby.com (mail.tut.by [195.137.160.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mANBm2bp013692
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 06:48:02 -0500
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org, video4linux-list@redhat.com
Date: Sun, 23 Nov 2008 13:47:41 +0200
References: <49293640.10808@cadsoft.de>
In-Reply-To: <49293640.10808@cadsoft.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811231347.41452.liplianin@tut.by>
Cc: Mauro Chehab <mchehab@infradead.org>
Subject: [PATCH] Add Compro VideoMate E650F (DVB-T part only)
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

From: Igor M. Liplianin <liplianin@me.by>

Add Compro VideoMate E650F (DVB-T part only).
The card based on cx23885 PCI-Express chip, xc3028 tuner and ce6353 demodulator.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

---
diff -r 17754ef554b0 -r adce5197979d linux/drivers/media/video/cx23885/cx23885-cards.c
--- a/linux/drivers/media/video/cx23885/cx23885-cards.c	Fri Nov 21 20:00:55 2008 -0200
+++ b/linux/drivers/media/video/cx23885/cx23885-cards.c	Sun Nov 23 13:21:10 2008 +0200
@@ -159,6 +159,10 @@
 		.name		= "Leadtek Winfast PxDVR3200 H",
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_COMPRO_VIDEOMATE_E650F] = {
+		.name		= "Compro VideoMate E650F",
+		.portc		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -238,6 +242,10 @@
 		.subvendor = 0x107d,
 		.subdevice = 0x6681,
 		.card      = CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
+	}, {
+		.subvendor = 0x185b,
+		.subdevice = 0xe800,
+		.card      = CX23885_BOARD_COMPRO_VIDEOMATE_E650F,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -391,6 +399,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 		/* Tuner Reset Command */
 		bitmask = 0x04;
 		break;
@@ -531,6 +540,7 @@
 		cx_set(GP0_IO, 0x000f000f);
 		break;
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 		/* GPIO-2  xc3028 tuner reset */
 
 		/* The following GPIO's are on the internal AVCore (cx25840) */
@@ -631,6 +641,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	default:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
@@ -645,6 +656,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 		request_module("cx25840");
 		break;
 	}
diff -r 17754ef554b0 -r adce5197979d linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	Fri Nov 21 20:00:55 2008 -0200
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	Sun Nov 23 13:21:10 2008 +0200
@@ -503,6 +503,7 @@
 		break;
 	}
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 		i2c_bus = &dev->i2c_bus[0];
 
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
diff -r 17754ef554b0 -r adce5197979d linux/drivers/media/video/cx23885/cx23885.h
--- a/linux/drivers/media/video/cx23885/cx23885.h	Fri Nov 21 20:00:55 2008 -0200
+++ b/linux/drivers/media/video/cx23885/cx23885.h	Sun Nov 23 13:21:10 2008 +0200
@@ -67,6 +67,7 @@
 #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
 #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
 #define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 12
+#define CX23885_BOARD_COMPRO_VIDEOMATE_E650F   13
 
 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */
 #define CX23885_NORMS (\

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
