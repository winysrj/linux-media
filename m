Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52783 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2LHWVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 17:21:05 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so628196eaa.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 14:21:03 -0800 (PST)
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: linux-media@vger.kernel.org
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH] [media] Added support for AVerTV Hybrid Express Slim HC81R
Date: Sun,  9 Dec 2012 00:20:59 +0200
Message-Id: <1355005259-10475-1-git-send-email-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch provide only analog support.
The device is based on AF9013 demodulator, XC3028 tuner
and CX23885 chipset; subsystem id: 1461:d939

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 drivers/media/pci/cx23885/cx23885-cards.c |   75 +++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885-video.c |   15 +++++-
 drivers/media/pci/cx23885/cx23885.h       |    1 +
 3 files changed, 90 insertions(+), 1 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 6277e145..d213019 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -572,6 +572,35 @@ struct cx23885_board cx23885_boards[] = {
 	[CX23885_BOARD_PROF_8000] = {
 		.name		= "Prof Revolution DVB-S2 8000",
 		.portb		= CX23885_MPEG_DVB,
+	},
+	[CX23885_BOARD_AVERMEDIA_HC81R] = {
+		.name		= "AVerTV Hybrid Express Slim HC81R",
+		.tuner_type	= TUNER_XC2028,
+		.tuner_addr	= 0x61, /* 0xc2 >> 1 */
+		.tuner_bus	= 1,
+		.porta		= CX23885_ANALOG_VIDEO,
+		.input          = {{
+			.type   = CX23885_VMUX_TELEVISION,
+			.vmux   = CX25840_VIN2_CH1 |
+				  CX25840_VIN5_CH2 |
+				  CX25840_NONE0_CH3 |
+				  CX25840_NONE1_CH3,
+			.amux   = CX25840_AUDIO8,
+		}, {
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   = CX25840_VIN8_CH1 |
+				  CX25840_NONE_CH2 |
+				  CX25840_VIN7_CH3 |
+				  CX25840_SVIDEO_ON,
+			.amux   = CX25840_AUDIO6,
+		}, {
+			.type   = CX23885_VMUX_COMPONENT,
+			.vmux   = CX25840_VIN1_CH1 |
+				  CX25840_NONE_CH2 |
+				  CX25840_NONE0_CH3 |
+				  CX25840_NONE1_CH3,
+			.amux   = CX25840_AUDIO6,
+		} },
 	}
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
@@ -788,6 +817,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x8000,
 		.subdevice = 0x3034,
 		.card      = CX23885_BOARD_PROF_8000,
+	}, {
+		.subvendor = 0x1461,
+		.subdevice = 0xd939,
+		.card      = CX23885_BOARD_AVERMEDIA_HC81R,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1012,6 +1045,10 @@ int cx23885_tuner_callback(void *priv, int component, int command, int arg)
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
 		altera_ci_tuner_reset(dev, port->nr);
 		break;
+	case CX23885_BOARD_AVERMEDIA_HC81R:
+		/* XC3028L Reset Command */
+		bitmask = 1 << 2;
+		break;
 	}
 
 	if (bitmask) {
@@ -1301,6 +1338,32 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		/* enable irq */
 		cx_write(GPIO_ISM, 0x00000000);/* INTERRUPTS active low*/
 		break;
+	case CX23885_BOARD_AVERMEDIA_HC81R:
+		cx_clear(MC417_CTL, 1);
+		/* GPIO-0,1,2 setup direction as output */
+		cx_set(GP0_IO, 0x00070000);
+		mdelay(10);
+		/* AF9013 demod reset */
+		cx_set(GP0_IO, 0x00010001);
+		mdelay(10);
+		cx_clear(GP0_IO, 0x00010001);
+		mdelay(10);
+		cx_set(GP0_IO, 0x00010001);
+		mdelay(10);
+		/* demod tune? */
+		cx_clear(GP0_IO, 0x00030003);
+		mdelay(10);
+		cx_set(GP0_IO, 0x00020002);
+		mdelay(10);
+		cx_set(GP0_IO, 0x00010001);
+		mdelay(10);
+		cx_clear(GP0_IO, 0x00020002);
+		/* XC3028L tuner reset */
+		cx_set(GP0_IO, 0x00040004);
+		cx_clear(GP0_IO, 0x00040004);
+		cx_set(GP0_IO, 0x00040004);
+		mdelay(60);
+		break;
 	}
 }
 
@@ -1515,6 +1578,17 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	}
 
 	switch (dev->board) {
+	case CX23885_BOARD_AVERMEDIA_HC81R:
+		/* Defaults for VID B */
+		ts1->gen_ctrl_val  = 0x4; /* Parallel */
+		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		/* Defaults for VID C */
+		/* DREQ_POL, SMODE, PUNC_CLK, MCLK_POL Serial bus + punc clk */
+		ts2->gen_ctrl_val  = 0x10e;
+		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts2->src_sel_val     = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
@@ -1636,6 +1710,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_MPX885:
 	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
+	case CX23885_BOARD_AVERMEDIA_HC81R:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 1a21926..f131888 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -509,7 +509,8 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
-		(dev->board == CX23885_BOARD_MYGICA_X8507)) {
+		(dev->board == CX23885_BOARD_MYGICA_X8507) ||
+		(dev->board == CX23885_BOARD_AVERMEDIA_HC81R)) {
 		/* Configure audio routing */
 		v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
 			INPUT(input)->amux, 0, 0);
@@ -1878,6 +1879,18 @@ int cx23885_video_register(struct cx23885_dev *dev)
 				};
 				v4l2_subdev_call(sd, tuner, s_config, &cfg);
 			}
+
+			if (dev->board == CX23885_BOARD_AVERMEDIA_HC81R) {
+				struct xc2028_ctrl ctrl = {
+					.fname = "xc3028L-v36.fw",
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
 
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 67f40d3..f0c4705 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -91,6 +91,7 @@
 #define CX23885_BOARD_TEVII_S471               35
 #define CX23885_BOARD_HAUPPAUGE_HVR1255_22111  36
 #define CX23885_BOARD_PROF_8000                37
+#define CX23885_BOARD_AVERMEDIA_HC81R          38
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.7.8.6

