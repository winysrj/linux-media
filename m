Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:59202 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3IMO2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Sep 2013 10:28:25 -0400
Received: by mail-bk0-f47.google.com with SMTP id mx12so497530bkb.20
        for <linux-media@vger.kernel.org>; Fri, 13 Sep 2013 07:28:23 -0700 (PDT)
From: Anca Emanuel <anca.emanuel@gmail.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, alfredodelaiti@netscape.net, oleg@kaa.org.ua,
	dheitmueller@kernellabs.com, hans.verkuil@cisco.com,
	awalls@md.metrocast.net, laurent.pinchart@ideasonboard.com,
	crope@iki.fi, Anca Emanuel <anca.emanuel@gmail.com>
Subject: [PATCH] [media] cx23885: Add Leadtek Winfast PxPVR2200
Date: Fri, 13 Sep 2013 17:28:12 +0300
Message-Id: <1379082492-3749-1-git-send-email-anca.emanuel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested:
Composite: http://imgur.com/Rb1TCF3
TV: http://imgur.com/KNrfsmv
Firmware used: xc3028-v27.fw

Not tested: audio, component, s-video, mpeg2 encoder, FM radio.
For audio it uses an CD style cable to connect to the analog "CD_IN" on the motherboard.
I didn't found how to unmute it (alsamixer do not show an CD or AUX channel).

Signed-off-by: Anca Emanuel <anca.emanuel@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 41 +++++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885-video.c |  3 ++-
 drivers/media/pci/cx23885/cx23885.h       |  1 +
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 6a71a96..4bbb126 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -223,6 +223,39 @@ struct cx23885_board cx23885_boards[] = {
 		.name		= "Leadtek Winfast PxDVR3200 H",
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200] = {
+		.name		= "Leadtek Winfast PxPVR2200",
+		.porta		= CX23885_ANALOG_VIDEO,
+		.tuner_type	= TUNER_XC2028,
+		.tuner_addr	= 0x61,
+		.tuner_bus	= 1,
+		.input		= {{
+			.type	= CX23885_VMUX_TELEVISION,
+			.vmux	= CX25840_VIN2_CH1 |
+				  CX25840_VIN5_CH2,
+			.amux	= CX25840_AUDIO8,
+			.gpio0	= 0x704040,
+		}, {
+			.type	= CX23885_VMUX_COMPOSITE1,
+			.vmux	= CX25840_COMPOSITE1,
+			.amux	= CX25840_AUDIO7,
+			.gpio0	= 0x704040,
+		}, {
+			.type	= CX23885_VMUX_SVIDEO,
+			.vmux	= CX25840_SVIDEO_LUMA3 |
+				  CX25840_SVIDEO_CHROMA4,
+			.amux	= CX25840_AUDIO7,
+			.gpio0	= 0x704040,
+		}, {
+			.type	= CX23885_VMUX_COMPONENT,
+			.vmux	= CX25840_VIN7_CH1 |
+				  CX25840_VIN6_CH2 |
+				  CX25840_VIN8_CH3 |
+				  CX25840_COMPONENT_ON,
+			.amux	= CX25840_AUDIO7,
+			.gpio0	= 0x704040,
+		} },
+	},
 	[CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000] = {
 		.name		= "Leadtek Winfast PxDVR3200 H XC4000",
 		.porta		= CX23885_ANALOG_VIDEO,
@@ -688,6 +721,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.card      = CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
 	}, {
 		.subvendor = 0x107d,
+		.subdevice = 0x6f21,
+		.card      = CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200,
+	}, {
+		.subvendor = 0x107d,
 		.subdevice = 0x6f39,
 		.card	   = CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000,
 	}, {
@@ -1043,6 +1080,7 @@ int cx23885_tuner_callback(void *priv, int component, int command, int arg)
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
@@ -1208,6 +1246,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		cx_set(GP0_IO, 0x000f000f);
 		break;
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
@@ -1704,6 +1743,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
@@ -1733,6 +1773,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 1616868..7891f34 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1865,7 +1865,8 @@ int cx23885_video_register(struct cx23885_dev *dev)
 
 			v4l2_subdev_call(sd, tuner, s_type_addr, &tun_setup);
 
-			if (dev->board == CX23885_BOARD_LEADTEK_WINFAST_PXTV1200) {
+			if ((dev->board == CX23885_BOARD_LEADTEK_WINFAST_PXTV1200) ||
+			    (dev->board == CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200)) {
 				struct xc2028_ctrl ctrl = {
 					.fname = XC2028_DEFAULT_FIRMWARE,
 					.max_len = 64
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 038caf5..b0b47a6 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -93,6 +93,7 @@
 #define CX23885_BOARD_PROF_8000                37
 #define CX23885_BOARD_HAUPPAUGE_HVR4400        38
 #define CX23885_BOARD_AVERMEDIA_HC81R          39
+#define CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200 40
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.8.3.2

