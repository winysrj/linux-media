Return-path: <linux-media-owner@vger.kernel.org>
Received: from forwards8.yandex.ru ([77.88.61.49]:41128 "EHLO
	forwards8.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbZD2QCS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 12:02:18 -0400
Received: from webmail90.yandex.ru (webmail90.yandex.ru [77.88.47.164])
	by forwards8.yandex.ru (Yandex) with ESMTP id DD0F0DFC6E8
	for <linux-media@vger.kernel.org>; Wed, 29 Apr 2009 19:56:38 +0400 (MSD)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by webmail90.yandex.ru (Yandex) with ESMTP id B71754543E1
	for <linux-media@vger.kernel.org>; Wed, 29 Apr 2009 19:56:38 +0400 (MSD)
From: Vladimir Geroy <geroin22@yandex.ru>
To: linux-media@vger.kernel.org
Subject: Fwd: [linux-dvb] Signal ok but no Channels && add support Compro Videomate e800 (dvt-t part only)
MIME-Version: 1.0
Message-Id: <102861241020598@webmail90.yandex.ru>
Date: Wed, 29 Apr 2009 19:56:38 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



dmesg 

[   13.177367] cx23885 driver version 0.0.2 loaded
[   13.177862] ACPI: PCI Interrupt Link [APC8] enabled at IRQ 16
[   13.177873] cx23885 0000:04:00.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
[   13.178014] CORE cx23885[0]: subsystem: 1858:e800, board: Compro VideoMate E800 [card=18,autodetected]
[   13.373933] cx25840 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   13.378062] cx25840 2-0044: firmware: requesting v4l-cx23885-avcore-01.fw
[   13.387800] HDA Intel 0000:00:09.0: power state changed by ACPI to D0
[   13.388243] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
[   13.388248] HDA Intel 0000:00:09.0: PCI INT A -> Link[AAZA] -> GSI 22 (level, low) -> IRQ 22
[   13.388299] HDA Intel 0000:00:09.0: setting latency timer to 64
[   14.020387] cx25840 2-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
[   14.026309] cx23885_dvb_register() allocating 1 frontend(s)
[   14.026313] cx23885[0]: cx23885 based dvb card
[   14.102491] xc2028 1-0061: creating new instance
[   14.102495] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   14.102501] DVB: registering new adapter (cx23885[0])
[   14.102506] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   14.102855] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   14.102863] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xef600000
[   14.102871] cx23885 0000:04:00.0: setting latency timer to 64


w_scan version 20081106
Info: using DVB adapter auto detection.
   Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
-_-_-_-_ Getting frontend capabilities-_-_-_-_ 
frontend Zarlink ZL10353 DVB-T supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_ 
177500: 
184500: 
191500: 
198500: 
205500: 
212500: 
219500: 
226500: 
474000: 
482000: 
490000: 
498000: 
506000: 
514000: 
522000: 
530000: 
538000: 
546000: 
554000: 
562000: 
570000: 
578000: 
586000: 
594000: 
602000: 
610000: 
618000: 
626000: 
634000: signal ok (I999B8C999D999M999T999G999Y999)
642000: 
650000: signal ok (I999B8C999D999M999T999G999Y999)
658000: 
666000: 
674000: 
682000: 
690000: 
698000: 
706000: 
714000: signal ok (I999B8C999D999M999T999G999Y999)
722000: 
730000: 
738000: 
746000: 
754000: 
762000: 
770000: 
778000: 
786000: 
794000: 
802000: 
810000: 
818000: 
826000: 
834000: 
842000: 
850000: 
858000: 
tune to: :634000:I999B8C999D999M999T999G999Y999:T:27500:
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
tune to: :650000:I999B8C999D999M999T999G999Y999:T:27500:
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
tune to: :714000:I999B8C999D999M999T999G999Y999:T:27500:
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
dumping lists (0 services)
Done.


Patch for  add support Compro Videomate e800 (dvt-t part only)

diff -Naur a/linux/Documentation/video4linux/CARDLIST.cx23885 b/linux/Documentation/video4linux/CARDLIST.cx23885
--- a/linux/Documentation/video4linux/CARDLIST.cx23885	2009-04-26 15:30:18.000000000 +0300
+++ b/linux/Documentation/video4linux/CARDLIST.cx23885	2009-04-29 18:19:45.561827543 +0300
@@ -16,3 +16,4 @@
  15 -> TeVii S470                                          [d470:9022]
  16 -> DVBWorld DVB-S2 2005                                [0001:2005]
  17 -> NetUP Dual DVB-S2 CI                                [1b55:2a2c]
+ 18 -> Compro VideoMate E800                               [1858:e800]
diff -Naur a/linux/drivers/media/video/cx23885/cx23885-cards.c b/linux/drivers/media/video/cx23885/cx23885-cards.c
--- a/linux/drivers/media/video/cx23885/cx23885-cards.c	2009-04-26 15:30:18.000000000 +0300
+++ b/linux/drivers/media/video/cx23885/cx23885-cards.c	2009-04-29 18:19:45.561827543 +0300
@@ -182,6 +182,10 @@
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
+        [CX23885_BOARD_COMPRO_VIDEOMATE_E800] = {
+		.name		= "Compro VideoMate E800",
+		.portc		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -281,6 +285,10 @@
 		.subvendor = 0x1b55,
 		.subdevice = 0x2a2c,
 		.card      = CX23885_BOARD_NETUP_DUAL_DVBS2_CI,
+        }, {
+		.subvendor = 0x1858,
+		.subdevice = 0xe800,
+		.card      = CX23885_BOARD_COMPRO_VIDEOMATE_E800,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -435,6 +443,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		/* Tuner Reset Command */
 		bitmask = 0x04;
 		break;
@@ -576,6 +585,7 @@
 		break;
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		/* GPIO-2  xc3028 tuner reset */
 
 		/* The following GPIO's are on the internal AVCore (cx25840) */
@@ -724,6 +734,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	default:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
@@ -740,6 +751,7 @@
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", "cx25840", 0x88 >> 1);
diff -Naur a/linux/drivers/media/video/cx23885/cx23885-dvb.c b/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	2009-04-26 15:30:18.000000000 +0300
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	2009-04-29 18:19:45.565435068 +0300
@@ -565,6 +565,7 @@
 	}
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		i2c_bus = &dev->i2c_bus[0];
 
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
diff -Naur a/linux/drivers/media/video/cx23885/cx23885.h b/linux/drivers/media/video/cx23885/cx23885.h
--- a/linux/drivers/media/video/cx23885/cx23885.h	2009-04-26 15:30:18.000000000 +0300
+++ b/linux/drivers/media/video/cx23885/cx23885.h	2009-04-29 18:19:45.565435068 +0300
@@ -72,6 +72,7 @@
 #define CX23885_BOARD_TEVII_S470               15
 #define CX23885_BOARD_DVBWORLD_2005            16
 #define CX23885_BOARD_NETUP_DUAL_DVBS2_CI      17
+#define CX23885_BOARD_COMPRO_VIDEOMATE_E800    18
 
 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */
 #define CX23885_NORMS (\
