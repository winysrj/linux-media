Return-path: <linux-media-owner@vger.kernel.org>
Received: from msa103.auone-net.jp ([61.117.18.163]:36487 "EHLO
	msa103.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0AVHz3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 02:55:29 -0500
Date: Fri, 22 Jan 2010 16:55:28 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cx23885: Add support for LEADTEK WinFast PxTV1200.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Message-Id: <20100122075528.A44A514C03A@msa103.auone-net.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tested only tv and composite. Video works fine but no audio.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 Documentation/video4linux/CARDLIST.cx23885  |    1 +
 drivers/media/video/cx23885/cx23885-cards.c |   32 +++++++++++++++++++++++++++
 drivers/media/video/cx23885/cx23885-video.c |   13 +++++++++++
 drivers/media/video/cx23885/cx23885.h       |    1 +
 4 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.cx23885 b/Documentation/video4linux/CARDLIST.cx23885
index 7539e8f..16ca030 100644
--- a/Documentation/video4linux/CARDLIST.cx23885
+++ b/Documentation/video4linux/CARDLIST.cx23885
@@ -26,3 +26,4 @@
  25 -> Compro VideoMate E800                               [1858:e800]
  26 -> Hauppauge WinTV-HVR1290                             [0070:8551]
  27 -> Mygica X8558 PRO DMB-TH                             [14f1:8578]
+ 28 -> LEADTEK WinFast PxTV1200                            [107d:6f22]
diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 1ec4816..d639186 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -274,6 +274,31 @@ struct cx23885_board cx23885_boards[] = {
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_LEADTEK_WINFAST_PXTV1200] = {
+		.name           = "LEADTEK WinFast PxTV1200",
+		.porta          = CX23885_ANALOG_VIDEO,
+		.tuner_type     = TUNER_XC2028,
+		.tuner_addr     = 0x61,
+		.input          = {{
+			.type   = CX23885_VMUX_TELEVISION,
+			.vmux   = CX25840_VIN2_CH1 |
+				  CX25840_VIN5_CH2 |
+				  CX25840_NONE0_CH3,
+		}, {
+			.type   = CX23885_VMUX_COMPOSITE1,
+			.vmux   = CX25840_COMPOSITE1,
+		}, {
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   = CX25840_SVIDEO_LUMA3 |
+				  CX25840_SVIDEO_CHROMA4,
+		}, {
+			.type   = CX23885_VMUX_COMPONENT,
+			.vmux   = CX25840_VIN7_CH1 |
+				  CX25840_VIN6_CH2 |
+				  CX25840_VIN8_CH3 |
+				  CX25840_COMPONENT_ON,
+		} },
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -417,6 +442,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x14f1,
 		.subdevice = 0x8578,
 		.card      = CX23885_BOARD_MYGICA_X8558PRO,
+	}, {
+		.subvendor = 0x107d,
+		.subdevice = 0x6f22,
+		.card      = CX23885_BOARD_LEADTEK_WINFAST_PXTV1200,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -617,6 +646,7 @@ int cx23885_tuner_callback(void *priv, int component, int command, int arg)
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
 		/* Tuner Reset Command */
 		bitmask = 0x04;
 		break;
@@ -769,6 +799,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
 		/* GPIO-2  xc3028 tuner reset */
 
 		/* The following GPIO's are on the internal AVCore (cx25840) */
@@ -1076,6 +1107,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_MYGICA_X8506:
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", "cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 8934d61..2d3ac8b 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -36,6 +36,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include "cx23885-ioctl.h"
+#include "tuner-xc2028.h"
 
 MODULE_DESCRIPTION("v4l2 driver module for cx23885 based TV cards");
 MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
@@ -1505,6 +1506,18 @@ int cx23885_video_register(struct cx23885_dev *dev)
 			tun_setup.tuner_callback = cx23885_tuner_callback;
 
 			v4l2_subdev_call(sd, tuner, s_type_addr, &tun_setup);
+
+			if (dev->board == CX23885_BOARD_LEADTEK_WINFAST_PXTV1200) {
+				struct xc2028_ctrl ctrl = {
+					.fname = XC2028_DEFAULT_FIRMWARE,
+					.max_len = 64
+				};
+				struct v4l2_priv_tun_config cfg = {
+					.tuner = dev->tuner_type,
+					.priv = &ctrl
+				};
+				v4l2_subdev_call(sd, tuner, s_config, &cfg);
+			}
 		}
 	}
 
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 08b3f6b..0e3a98d 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -81,6 +81,7 @@
 #define CX23885_BOARD_COMPRO_VIDEOMATE_E800    25
 #define CX23885_BOARD_HAUPPAUGE_HVR1290        26
 #define CX23885_BOARD_MYGICA_X8558PRO          27
+#define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200 28
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.6.6

