Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:35643 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730178AbeGYRva (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 13:51:30 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 25/34] media: camss: vfe: Add support for 8x96
Date: Wed, 25 Jul 2018 19:38:34 +0300
Message-Id: <1532536723-19062-26-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
References: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add VFE hardware dependent part for 8x96.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/Makefile         |   1 +
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c  |   6 +
 .../camss/{camss-vfe-4-1.c => camss-vfe-4-7.c}     | 347 ++++++++++++---------
 drivers/media/platform/qcom/camss/camss-vfe.c      |   4 +
 drivers/media/platform/qcom/camss/camss-vfe.h      |   2 +
 5 files changed, 209 insertions(+), 151 deletions(-)
 copy drivers/media/platform/qcom/camss/{camss-vfe-4-1.c => camss-vfe-4-7.c} (75%)

diff --git a/drivers/media/platform/qcom/camss/Makefile b/drivers/media/platform/qcom/camss/Makefile
index 38dc56e..f5e6e25 100644
--- a/drivers/media/platform/qcom/camss/Makefile
+++ b/drivers/media/platform/qcom/camss/Makefile
@@ -8,6 +8,7 @@ qcom-camss-objs += \
 		camss-csiphy.o \
 		camss-ispif.o \
 		camss-vfe-4-1.o \
+		camss-vfe-4-7.o \
 		camss-vfe.o \
 		camss-video.o \
 
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
index 070c0c3..41184dc 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
@@ -789,6 +789,11 @@ static void vfe_set_qos(struct vfe_device *vfe)
 	writel_relaxed(val7, vfe->base + VFE_0_BUS_BDG_QOS_CFG_7);
 }
 
+static void vfe_set_ds(struct vfe_device *vfe)
+{
+	/* empty */
+}
+
 static void vfe_set_cgc_override(struct vfe_device *vfe, u8 wm, u8 enable)
 {
 	u32 val = VFE_0_CGC_OVERRIDE_1_IMAGE_Mx_CGC_OVERRIDE(wm);
@@ -995,6 +1000,7 @@ const struct vfe_hw_ops vfe_ops_4_1 = {
 	.set_crop_cfg = vfe_set_crop_cfg,
 	.set_clamp_cfg = vfe_set_clamp_cfg,
 	.set_qos = vfe_set_qos,
+	.set_ds = vfe_set_ds,
 	.set_cgc_override = vfe_set_cgc_override,
 	.set_camif_cfg = vfe_set_camif_cfg,
 	.set_camif_cmd = vfe_set_camif_cmd,
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
similarity index 75%
copy from drivers/media/platform/qcom/camss/camss-vfe-4-1.c
copy to drivers/media/platform/qcom/camss/camss-vfe-4-7.c
index 070c0c3..45e6711 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * camss-vfe-4-1.c
+ * camss-vfe-4-7.c
  *
- * Qualcomm MSM Camera Subsystem - VFE (Video Front End) Module v4.1
+ * Qualcomm MSM Camera Subsystem - VFE (Video Front End) Module v4.7
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
@@ -15,33 +15,37 @@
 
 #define VFE_0_HW_VERSION		0x000
 
-#define VFE_0_GLOBAL_RESET_CMD		0x00c
+#define VFE_0_GLOBAL_RESET_CMD		0x018
 #define VFE_0_GLOBAL_RESET_CMD_CORE	BIT(0)
 #define VFE_0_GLOBAL_RESET_CMD_CAMIF	BIT(1)
 #define VFE_0_GLOBAL_RESET_CMD_BUS	BIT(2)
 #define VFE_0_GLOBAL_RESET_CMD_BUS_BDG	BIT(3)
 #define VFE_0_GLOBAL_RESET_CMD_REGISTER	BIT(4)
-#define VFE_0_GLOBAL_RESET_CMD_TIMER	BIT(5)
-#define VFE_0_GLOBAL_RESET_CMD_PM	BIT(6)
-#define VFE_0_GLOBAL_RESET_CMD_BUS_MISR	BIT(7)
-#define VFE_0_GLOBAL_RESET_CMD_TESTGEN	BIT(8)
-
-#define VFE_0_MODULE_CFG		0x018
-#define VFE_0_MODULE_CFG_DEMUX			BIT(2)
-#define VFE_0_MODULE_CFG_CHROMA_UPSAMPLE	BIT(3)
-#define VFE_0_MODULE_CFG_SCALE_ENC		BIT(23)
-#define VFE_0_MODULE_CFG_CROP_ENC		BIT(27)
-
-#define VFE_0_CORE_CFG			0x01c
+#define VFE_0_GLOBAL_RESET_CMD_PM	BIT(5)
+#define VFE_0_GLOBAL_RESET_CMD_BUS_MISR	BIT(6)
+#define VFE_0_GLOBAL_RESET_CMD_TESTGEN	BIT(7)
+#define VFE_0_GLOBAL_RESET_CMD_DSP	BIT(8)
+#define VFE_0_GLOBAL_RESET_CMD_IDLE_CGC	BIT(9)
+
+#define VFE_0_MODULE_LENS_EN		0x040
+#define VFE_0_MODULE_LENS_EN_DEMUX		BIT(2)
+#define VFE_0_MODULE_LENS_EN_CHROMA_UPSAMPLE	BIT(3)
+
+#define VFE_0_MODULE_ZOOM_EN		0x04c
+#define VFE_0_MODULE_ZOOM_EN_SCALE_ENC		BIT(1)
+#define VFE_0_MODULE_ZOOM_EN_CROP_ENC		BIT(2)
+
+#define VFE_0_CORE_CFG			0x050
 #define VFE_0_CORE_CFG_PIXEL_PATTERN_YCBYCR	0x4
 #define VFE_0_CORE_CFG_PIXEL_PATTERN_YCRYCB	0x5
 #define VFE_0_CORE_CFG_PIXEL_PATTERN_CBYCRY	0x6
 #define VFE_0_CORE_CFG_PIXEL_PATTERN_CRYCBY	0x7
+#define VFE_0_CORE_CFG_COMPOSITE_REG_UPDATE_EN	BIT(4)
 
-#define VFE_0_IRQ_CMD			0x024
+#define VFE_0_IRQ_CMD			0x058
 #define VFE_0_IRQ_CMD_GLOBAL_CLEAR	BIT(0)
 
-#define VFE_0_IRQ_MASK_0		0x028
+#define VFE_0_IRQ_MASK_0		0x05c
 #define VFE_0_IRQ_MASK_0_CAMIF_SOF			BIT(0)
 #define VFE_0_IRQ_MASK_0_CAMIF_EOF			BIT(1)
 #define VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n)		BIT((n) + 5)
@@ -50,17 +54,17 @@
 #define VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(n)	BIT((n) + 8)
 #define VFE_0_IRQ_MASK_0_IMAGE_COMPOSITE_DONE_n(n)	BIT((n) + 25)
 #define VFE_0_IRQ_MASK_0_RESET_ACK			BIT(31)
-#define VFE_0_IRQ_MASK_1		0x02c
+#define VFE_0_IRQ_MASK_1		0x060
 #define VFE_0_IRQ_MASK_1_CAMIF_ERROR			BIT(0)
 #define VFE_0_IRQ_MASK_1_VIOLATION			BIT(7)
 #define VFE_0_IRQ_MASK_1_BUS_BDG_HALT_ACK		BIT(8)
 #define VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(n)	BIT((n) + 9)
 #define VFE_0_IRQ_MASK_1_RDIn_SOF(n)			BIT((n) + 29)
 
-#define VFE_0_IRQ_CLEAR_0		0x030
-#define VFE_0_IRQ_CLEAR_1		0x034
+#define VFE_0_IRQ_CLEAR_0		0x064
+#define VFE_0_IRQ_CLEAR_1		0x068
 
-#define VFE_0_IRQ_STATUS_0		0x038
+#define VFE_0_IRQ_STATUS_0		0x06c
 #define VFE_0_IRQ_STATUS_0_CAMIF_SOF			BIT(0)
 #define VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n)		BIT((n) + 5)
 #define VFE_0_IRQ_STATUS_0_line_n_REG_UPDATE(n)		\
@@ -68,156 +72,176 @@
 #define VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG(n)	BIT((n) + 8)
 #define VFE_0_IRQ_STATUS_0_IMAGE_COMPOSITE_DONE_n(n)	BIT((n) + 25)
 #define VFE_0_IRQ_STATUS_0_RESET_ACK			BIT(31)
-#define VFE_0_IRQ_STATUS_1		0x03c
+#define VFE_0_IRQ_STATUS_1		0x070
 #define VFE_0_IRQ_STATUS_1_VIOLATION			BIT(7)
 #define VFE_0_IRQ_STATUS_1_BUS_BDG_HALT_ACK		BIT(8)
 #define VFE_0_IRQ_STATUS_1_RDIn_SOF(n)			BIT((n) + 29)
 
-#define VFE_0_IRQ_COMPOSITE_MASK_0	0x40
-#define VFE_0_VIOLATION_STATUS		0x48
+#define VFE_0_IRQ_COMPOSITE_MASK_0	0x074
+#define VFE_0_VIOLATION_STATUS		0x07c
 
-#define VFE_0_BUS_CMD			0x4c
+#define VFE_0_BUS_CMD			0x80
 #define VFE_0_BUS_CMD_Mx_RLD_CMD(x)	BIT(x)
 
-#define VFE_0_BUS_CFG			0x050
+#define VFE_0_BUS_CFG			0x084
 
-#define VFE_0_BUS_XBAR_CFG_x(x)		(0x58 + 0x4 * ((x) / 2))
-#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN			BIT(1)
+#define VFE_0_BUS_XBAR_CFG_x(x)		(0x90 + 0x4 * ((x) / 2))
+#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN			BIT(2)
 #define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA	(0x3 << 4)
 #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT		8
-#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA		0
-#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0	5
-#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1	6
-#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2	7
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA		0x0
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0	0xc
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1	0xd
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2	0xe
 
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(n)		(0x06c + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(n)		(0x0a0 + 0x2c * (n))
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_WR_PATH_SHIFT	0
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT	1
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_PING_ADDR(n)	(0x070 + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_PONG_ADDR(n)	(0x074 + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(n)		(0x078 + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_PING_ADDR(n)	(0x0a4 + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_PONG_ADDR(n)	(0x0ac + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(n)		(0x0b4 + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_BASED_SHIFT	1
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_SHIFT	2
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_MASK	(0x1f << 2)
-
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG(n)		(0x07c + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG(n)		(0x0b8 + 0x2c * (n))
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG_OFFSET_SHIFT	16
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(n)	(0x080 + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(n)	(0x084 + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(n)	(0x0bc + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(n)	(0x0c0 + 0x2c * (n))
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_FRAMEDROP_PATTERN(n)	\
-							(0x088 + 0x24 * (n))
+							(0x0c4 + 0x2c * (n))
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(n)	\
-							(0x08c + 0x24 * (n))
+							(0x0c8 + 0x2c * (n))
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN_DEF	0xffffffff
 
-#define VFE_0_BUS_PING_PONG_STATUS	0x268
+#define VFE_0_BUS_PING_PONG_STATUS	0x338
 
-#define VFE_0_BUS_BDG_CMD		0x2c0
+#define VFE_0_BUS_BDG_CMD		0x400
 #define VFE_0_BUS_BDG_CMD_HALT_REQ	1
 
-#define VFE_0_BUS_BDG_QOS_CFG_0		0x2c4
-#define VFE_0_BUS_BDG_QOS_CFG_0_CFG	0xaaa5aaa5
-#define VFE_0_BUS_BDG_QOS_CFG_1		0x2c8
-#define VFE_0_BUS_BDG_QOS_CFG_2		0x2cc
-#define VFE_0_BUS_BDG_QOS_CFG_3		0x2d0
-#define VFE_0_BUS_BDG_QOS_CFG_4		0x2d4
-#define VFE_0_BUS_BDG_QOS_CFG_5		0x2d8
-#define VFE_0_BUS_BDG_QOS_CFG_6		0x2dc
-#define VFE_0_BUS_BDG_QOS_CFG_7		0x2e0
-#define VFE_0_BUS_BDG_QOS_CFG_7_CFG	0x0001aaa5
-
-#define VFE_0_RDI_CFG_x(x)		(0x2e8 + (0x4 * (x)))
+#define VFE_0_BUS_BDG_QOS_CFG_0		0x404
+#define VFE_0_BUS_BDG_QOS_CFG_0_CFG	0xaaa9aaa9
+#define VFE_0_BUS_BDG_QOS_CFG_1		0x408
+#define VFE_0_BUS_BDG_QOS_CFG_2		0x40c
+#define VFE_0_BUS_BDG_QOS_CFG_3		0x410
+#define VFE_0_BUS_BDG_QOS_CFG_4		0x414
+#define VFE_0_BUS_BDG_QOS_CFG_5		0x418
+#define VFE_0_BUS_BDG_QOS_CFG_6		0x41c
+#define VFE_0_BUS_BDG_QOS_CFG_7		0x420
+#define VFE_0_BUS_BDG_QOS_CFG_7_CFG	0x0001aaa9
+
+#define VFE_0_BUS_BDG_DS_CFG_0		0x424
+#define VFE_0_BUS_BDG_DS_CFG_0_CFG	0xcccc0011
+#define VFE_0_BUS_BDG_DS_CFG_1		0x428
+#define VFE_0_BUS_BDG_DS_CFG_2		0x42c
+#define VFE_0_BUS_BDG_DS_CFG_3		0x430
+#define VFE_0_BUS_BDG_DS_CFG_4		0x434
+#define VFE_0_BUS_BDG_DS_CFG_5		0x438
+#define VFE_0_BUS_BDG_DS_CFG_6		0x43c
+#define VFE_0_BUS_BDG_DS_CFG_7		0x440
+#define VFE_0_BUS_BDG_DS_CFG_8		0x444
+#define VFE_0_BUS_BDG_DS_CFG_9		0x448
+#define VFE_0_BUS_BDG_DS_CFG_10		0x44c
+#define VFE_0_BUS_BDG_DS_CFG_11		0x450
+#define VFE_0_BUS_BDG_DS_CFG_12		0x454
+#define VFE_0_BUS_BDG_DS_CFG_13		0x458
+#define VFE_0_BUS_BDG_DS_CFG_14		0x45c
+#define VFE_0_BUS_BDG_DS_CFG_15		0x460
+#define VFE_0_BUS_BDG_DS_CFG_16		0x464
+#define VFE_0_BUS_BDG_DS_CFG_16_CFG	0x40000103
+
+#define VFE_0_RDI_CFG_x(x)		(0x46c + (0x4 * (x)))
 #define VFE_0_RDI_CFG_x_RDI_STREAM_SEL_SHIFT	28
 #define VFE_0_RDI_CFG_x_RDI_STREAM_SEL_MASK	(0xf << 28)
 #define VFE_0_RDI_CFG_x_RDI_M0_SEL_SHIFT	4
 #define VFE_0_RDI_CFG_x_RDI_M0_SEL_MASK		(0xf << 4)
 #define VFE_0_RDI_CFG_x_RDI_EN_BIT		BIT(2)
 #define VFE_0_RDI_CFG_x_MIPI_EN_BITS		0x3
-#define VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(r)	BIT(16 + (r))
 
-#define VFE_0_CAMIF_CMD				0x2f4
+#define VFE_0_CAMIF_CMD				0x478
 #define VFE_0_CAMIF_CMD_DISABLE_FRAME_BOUNDARY	0
 #define VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY	1
 #define VFE_0_CAMIF_CMD_NO_CHANGE		3
 #define VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS	BIT(2)
-#define VFE_0_CAMIF_CFG				0x2f8
+#define VFE_0_CAMIF_CFG				0x47c
 #define VFE_0_CAMIF_CFG_VFE_OUTPUT_EN		BIT(6)
-#define VFE_0_CAMIF_FRAME_CFG			0x300
-#define VFE_0_CAMIF_WINDOW_WIDTH_CFG		0x304
-#define VFE_0_CAMIF_WINDOW_HEIGHT_CFG		0x308
-#define VFE_0_CAMIF_SUBSAMPLE_CFG_0		0x30c
-#define VFE_0_CAMIF_IRQ_SUBSAMPLE_PATTERN	0x314
-#define VFE_0_CAMIF_STATUS			0x31c
+#define VFE_0_CAMIF_FRAME_CFG			0x484
+#define VFE_0_CAMIF_WINDOW_WIDTH_CFG		0x488
+#define VFE_0_CAMIF_WINDOW_HEIGHT_CFG		0x48c
+#define VFE_0_CAMIF_SUBSAMPLE_CFG		0x490
+#define VFE_0_CAMIF_IRQ_FRAMEDROP_PATTERN	0x498
+#define VFE_0_CAMIF_IRQ_SUBSAMPLE_PATTERN	0x49c
+#define VFE_0_CAMIF_STATUS			0x4a4
 #define VFE_0_CAMIF_STATUS_HALT			BIT(31)
 
-#define VFE_0_REG_UPDATE			0x378
+#define VFE_0_REG_UPDATE		0x4ac
 #define VFE_0_REG_UPDATE_RDIn(n)		BIT(1 + (n))
 #define VFE_0_REG_UPDATE_line_n(n)		\
 			((n) == VFE_LINE_PIX ? 1 : VFE_0_REG_UPDATE_RDIn(n))
 
-#define VFE_0_DEMUX_CFG				0x424
+#define VFE_0_DEMUX_CFG				0x560
 #define VFE_0_DEMUX_CFG_PERIOD			0x3
-#define VFE_0_DEMUX_GAIN_0			0x428
+#define VFE_0_DEMUX_GAIN_0			0x564
 #define VFE_0_DEMUX_GAIN_0_CH0_EVEN		(0x80 << 0)
 #define VFE_0_DEMUX_GAIN_0_CH0_ODD		(0x80 << 16)
-#define VFE_0_DEMUX_GAIN_1			0x42c
+#define VFE_0_DEMUX_GAIN_1			0x568
 #define VFE_0_DEMUX_GAIN_1_CH1			(0x80 << 0)
 #define VFE_0_DEMUX_GAIN_1_CH2			(0x80 << 16)
-#define VFE_0_DEMUX_EVEN_CFG			0x438
+#define VFE_0_DEMUX_EVEN_CFG			0x574
 #define VFE_0_DEMUX_EVEN_CFG_PATTERN_YUYV	0x9cac
 #define VFE_0_DEMUX_EVEN_CFG_PATTERN_YVYU	0xac9c
 #define VFE_0_DEMUX_EVEN_CFG_PATTERN_UYVY	0xc9ca
 #define VFE_0_DEMUX_EVEN_CFG_PATTERN_VYUY	0xcac9
-#define VFE_0_DEMUX_ODD_CFG			0x43c
+#define VFE_0_DEMUX_ODD_CFG			0x578
 #define VFE_0_DEMUX_ODD_CFG_PATTERN_YUYV	0x9cac
 #define VFE_0_DEMUX_ODD_CFG_PATTERN_YVYU	0xac9c
 #define VFE_0_DEMUX_ODD_CFG_PATTERN_UYVY	0xc9ca
 #define VFE_0_DEMUX_ODD_CFG_PATTERN_VYUY	0xcac9
 
-#define VFE_0_SCALE_ENC_Y_CFG			0x75c
-#define VFE_0_SCALE_ENC_Y_H_IMAGE_SIZE		0x760
-#define VFE_0_SCALE_ENC_Y_H_PHASE		0x764
-#define VFE_0_SCALE_ENC_Y_V_IMAGE_SIZE		0x76c
-#define VFE_0_SCALE_ENC_Y_V_PHASE		0x770
-#define VFE_0_SCALE_ENC_CBCR_CFG		0x778
-#define VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE	0x77c
-#define VFE_0_SCALE_ENC_CBCR_H_PHASE		0x780
-#define VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE	0x790
-#define VFE_0_SCALE_ENC_CBCR_V_PHASE		0x794
-
-#define VFE_0_CROP_ENC_Y_WIDTH			0x854
-#define VFE_0_CROP_ENC_Y_HEIGHT			0x858
-#define VFE_0_CROP_ENC_CBCR_WIDTH		0x85c
-#define VFE_0_CROP_ENC_CBCR_HEIGHT		0x860
-
-#define VFE_0_CLAMP_ENC_MAX_CFG			0x874
+#define VFE_0_SCALE_ENC_Y_CFG			0x91c
+#define VFE_0_SCALE_ENC_Y_H_IMAGE_SIZE		0x920
+#define VFE_0_SCALE_ENC_Y_H_PHASE		0x924
+#define VFE_0_SCALE_ENC_Y_V_IMAGE_SIZE		0x934
+#define VFE_0_SCALE_ENC_Y_V_PHASE		0x938
+#define VFE_0_SCALE_ENC_CBCR_CFG		0x948
+#define VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE	0x94c
+#define VFE_0_SCALE_ENC_CBCR_H_PHASE		0x950
+#define VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE	0x960
+#define VFE_0_SCALE_ENC_CBCR_V_PHASE		0x964
+
+#define VFE_0_CROP_ENC_Y_WIDTH			0x974
+#define VFE_0_CROP_ENC_Y_HEIGHT			0x978
+#define VFE_0_CROP_ENC_CBCR_WIDTH		0x97c
+#define VFE_0_CROP_ENC_CBCR_HEIGHT		0x980
+
+#define VFE_0_CLAMP_ENC_MAX_CFG			0x984
 #define VFE_0_CLAMP_ENC_MAX_CFG_CH0		(0xff << 0)
 #define VFE_0_CLAMP_ENC_MAX_CFG_CH1		(0xff << 8)
 #define VFE_0_CLAMP_ENC_MAX_CFG_CH2		(0xff << 16)
-#define VFE_0_CLAMP_ENC_MIN_CFG			0x878
+#define VFE_0_CLAMP_ENC_MIN_CFG			0x988
 #define VFE_0_CLAMP_ENC_MIN_CFG_CH0		(0x0 << 0)
 #define VFE_0_CLAMP_ENC_MIN_CFG_CH1		(0x0 << 8)
 #define VFE_0_CLAMP_ENC_MIN_CFG_CH2		(0x0 << 16)
 
-#define VFE_0_CGC_OVERRIDE_1			0x974
-#define VFE_0_CGC_OVERRIDE_1_IMAGE_Mx_CGC_OVERRIDE(x)	BIT(x)
-
 #define CAMIF_TIMEOUT_SLEEP_US 1000
 #define CAMIF_TIMEOUT_ALL_US 1000000
 
-#define MSM_VFE_VFE0_UB_SIZE 1023
+#define MSM_VFE_VFE0_UB_SIZE 2047
 #define MSM_VFE_VFE0_UB_SIZE_RDI (MSM_VFE_VFE0_UB_SIZE / 3)
+#define MSM_VFE_VFE1_UB_SIZE 1535
+#define MSM_VFE_VFE1_UB_SIZE_RDI (MSM_VFE_VFE1_UB_SIZE / 3)
 
 static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
 
-	dev_dbg(dev, "VFE HW Version = 0x%08x\n", hw_version);
+	dev_err(dev, "VFE HW Version = 0x%08x\n", hw_version);
 }
 
 static u16 vfe_get_ub_size(u8 vfe_id)
 {
 	if (vfe_id == 0)
 		return MSM_VFE_VFE0_UB_SIZE_RDI;
+	else if (vfe_id == 1)
+		return MSM_VFE_VFE1_UB_SIZE_RDI;
 
 	return 0;
 }
@@ -238,16 +262,19 @@ static inline void vfe_reg_set(struct vfe_device *vfe, u32 reg, u32 set_bits)
 
 static void vfe_global_reset(struct vfe_device *vfe)
 {
-	u32 reset_bits = VFE_0_GLOBAL_RESET_CMD_TESTGEN		|
+	u32 reset_bits = VFE_0_GLOBAL_RESET_CMD_IDLE_CGC	|
+			 VFE_0_GLOBAL_RESET_CMD_DSP		|
+			 VFE_0_GLOBAL_RESET_CMD_TESTGEN		|
 			 VFE_0_GLOBAL_RESET_CMD_BUS_MISR	|
 			 VFE_0_GLOBAL_RESET_CMD_PM		|
-			 VFE_0_GLOBAL_RESET_CMD_TIMER		|
 			 VFE_0_GLOBAL_RESET_CMD_REGISTER	|
 			 VFE_0_GLOBAL_RESET_CMD_BUS_BDG		|
 			 VFE_0_GLOBAL_RESET_CMD_BUS		|
 			 VFE_0_GLOBAL_RESET_CMD_CAMIF		|
 			 VFE_0_GLOBAL_RESET_CMD_CORE;
 
+	writel_relaxed(BIT(31), vfe->base + VFE_0_IRQ_MASK_0);
+	wmb();
 	writel_relaxed(reset_bits, vfe->base + VFE_0_GLOBAL_RESET_CMD);
 }
 
@@ -275,11 +302,11 @@ static void vfe_wm_enable(struct vfe_device *vfe, u8 wm, u8 enable)
 static void vfe_wm_frame_based(struct vfe_device *vfe, u8 wm, u8 enable)
 {
 	if (enable)
-		vfe_reg_set(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(wm),
-			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT);
+		vfe_reg_set(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(wm),
+			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_BASED_SHIFT);
 	else
-		vfe_reg_clr(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(wm),
-			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT);
+		vfe_reg_clr(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(wm),
+			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_BASED_SHIFT);
 }
 
 #define CALC_WORD(width, M, N) (((width) * (M) + (N) - 1) / (N))
@@ -341,7 +368,7 @@ static void vfe_wm_line_based(struct vfe_device *vfe, u32 wm,
 		wpl = vfe_word_per_line(pix->pixelformat, width);
 
 		reg = height - 1;
-		reg |= ((wpl + 1) / 2 - 1) << 16;
+		reg |= ((wpl + 3) / 4 - 1) << 16;
 
 		writel_relaxed(reg, vfe->base +
 			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
@@ -349,8 +376,8 @@ static void vfe_wm_line_based(struct vfe_device *vfe, u32 wm,
 		wpl = vfe_word_per_line(pix->pixelformat, bytesperline);
 
 		reg = 0x3;
-		reg |= (height - 1) << 4;
-		reg |= wpl << 16;
+		reg |= (height - 1) << 2;
+		reg |= ((wpl + 1) / 2) << 16;
 
 		writel_relaxed(reg, vfe->base +
 			       VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(wm));
@@ -426,7 +453,7 @@ static int vfe_wm_get_ping_pong_status(struct vfe_device *vfe, u8 wm)
 static void vfe_bus_enable_wr_if(struct vfe_device *vfe, u8 enable)
 {
 	if (enable)
-		writel_relaxed(0x10000009, vfe->base + VFE_0_BUS_CFG);
+		writel_relaxed(0x101, vfe->base + VFE_0_BUS_CFG);
 	else
 		writel_relaxed(0, vfe->base + VFE_0_BUS_CFG);
 }
@@ -437,7 +464,6 @@ static void vfe_bus_connect_wm_to_rdi(struct vfe_device *vfe, u8 wm,
 	u32 reg;
 
 	reg = VFE_0_RDI_CFG_x_MIPI_EN_BITS;
-	reg |= VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(id);
 	vfe_reg_set(vfe, VFE_0_RDI_CFG_x(0), reg);
 
 	reg = VFE_0_RDI_CFG_x_RDI_EN_BIT;
@@ -470,8 +496,8 @@ static void vfe_bus_connect_wm_to_rdi(struct vfe_device *vfe, u8 wm,
 static void vfe_wm_set_subsample(struct vfe_device *vfe, u8 wm)
 {
 	writel_relaxed(VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN_DEF,
-		       vfe->base +
-		       VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(wm));
+	       vfe->base +
+	       VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(wm));
 }
 
 static void vfe_bus_disconnect_wm_from_rdi(struct vfe_device *vfe, u8 wm,
@@ -479,9 +505,6 @@ static void vfe_bus_disconnect_wm_from_rdi(struct vfe_device *vfe, u8 wm,
 {
 	u32 reg;
 
-	reg = VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(id);
-	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(0), reg);
-
 	reg = VFE_0_RDI_CFG_x_RDI_EN_BIT;
 	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(id), reg);
 
@@ -523,9 +546,6 @@ static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
 			reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
 			if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
 				reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
-		} else {
-			/* On current devices output->wm_num is always <= 2 */
-			break;
 		}
 
 		if (output->wm_idx[i] % 2 == 1)
@@ -683,48 +703,48 @@ static void vfe_set_scale_cfg(struct vfe_device *vfe, struct vfe_line *line)
 
 	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_Y_CFG);
 
-	input = line->fmt[MSM_VFE_PAD_SINK].width;
-	output = line->compose.width;
+	input = line->fmt[MSM_VFE_PAD_SINK].width - 1;
+	output = line->compose.width - 1;
 	reg = (output << 16) | input;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_H_IMAGE_SIZE);
 
 	interp_reso = vfe_calc_interp_reso(input, output);
-	phase_mult = input * (1 << (13 + interp_reso)) / output;
-	reg = (interp_reso << 20) | phase_mult;
+	phase_mult = input * (1 << (14 + interp_reso)) / output;
+	reg = (interp_reso << 28) | phase_mult;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_H_PHASE);
 
-	input = line->fmt[MSM_VFE_PAD_SINK].height;
-	output = line->compose.height;
+	input = line->fmt[MSM_VFE_PAD_SINK].height - 1;
+	output = line->compose.height - 1;
 	reg = (output << 16) | input;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_V_IMAGE_SIZE);
 
 	interp_reso = vfe_calc_interp_reso(input, output);
-	phase_mult = input * (1 << (13 + interp_reso)) / output;
-	reg = (interp_reso << 20) | phase_mult;
+	phase_mult = input * (1 << (14 + interp_reso)) / output;
+	reg = (interp_reso << 28) | phase_mult;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_V_PHASE);
 
 	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_CBCR_CFG);
 
-	input = line->fmt[MSM_VFE_PAD_SINK].width;
-	output = line->compose.width / 2;
+	input = line->fmt[MSM_VFE_PAD_SINK].width - 1;
+	output = line->compose.width / 2 - 1;
 	reg = (output << 16) | input;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE);
 
 	interp_reso = vfe_calc_interp_reso(input, output);
-	phase_mult = input * (1 << (13 + interp_reso)) / output;
-	reg = (interp_reso << 20) | phase_mult;
+	phase_mult = input * (1 << (14 + interp_reso)) / output;
+	reg = (interp_reso << 28) | phase_mult;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_PHASE);
 
-	input = line->fmt[MSM_VFE_PAD_SINK].height;
-	output = line->compose.height;
+	input = line->fmt[MSM_VFE_PAD_SINK].height - 1;
+	output = line->compose.height - 1;
 	if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV21)
-		output = line->compose.height / 2;
+		output = line->compose.height / 2 - 1;
 	reg = (output << 16) | input;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE);
 
 	interp_reso = vfe_calc_interp_reso(input, output);
-	phase_mult = input * (1 << (13 + interp_reso)) / output;
-	reg = (interp_reso << 20) | phase_mult;
+	phase_mult = input * (1 << (14 + interp_reso)) / output;
+	reg = (interp_reso << 28) | phase_mult;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_PHASE);
 }
 
@@ -789,16 +809,33 @@ static void vfe_set_qos(struct vfe_device *vfe)
 	writel_relaxed(val7, vfe->base + VFE_0_BUS_BDG_QOS_CFG_7);
 }
 
-static void vfe_set_cgc_override(struct vfe_device *vfe, u8 wm, u8 enable)
+static void vfe_set_ds(struct vfe_device *vfe)
 {
-	u32 val = VFE_0_CGC_OVERRIDE_1_IMAGE_Mx_CGC_OVERRIDE(wm);
-
-	if (enable)
-		vfe_reg_set(vfe, VFE_0_CGC_OVERRIDE_1, val);
-	else
-		vfe_reg_clr(vfe, VFE_0_CGC_OVERRIDE_1, val);
+	u32 val = VFE_0_BUS_BDG_DS_CFG_0_CFG;
+	u32 val16 = VFE_0_BUS_BDG_DS_CFG_16_CFG;
+
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_0);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_1);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_2);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_3);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_4);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_5);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_6);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_7);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_8);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_9);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_10);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_11);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_12);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_13);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_14);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_DS_CFG_15);
+	writel_relaxed(val16, vfe->base + VFE_0_BUS_BDG_DS_CFG_16);
+}
 
-	wmb();
+static void vfe_set_cgc_override(struct vfe_device *vfe, u8 wm, u8 enable)
+{
+	/* empty */
 }
 
 static void vfe_set_camif_cfg(struct vfe_device *vfe, struct vfe_line *line)
@@ -821,10 +858,11 @@ static void vfe_set_camif_cfg(struct vfe_device *vfe, struct vfe_line *line)
 		break;
 	}
 
+	val |= VFE_0_CORE_CFG_COMPOSITE_REG_UPDATE_EN;
 	writel_relaxed(val, vfe->base + VFE_0_CORE_CFG);
 
-	val = line->fmt[MSM_VFE_PAD_SINK].width * 2;
-	val |= line->fmt[MSM_VFE_PAD_SINK].height << 16;
+	val = line->fmt[MSM_VFE_PAD_SINK].width * 2 - 1;
+	val |= (line->fmt[MSM_VFE_PAD_SINK].height - 1) << 16;
 	writel_relaxed(val, vfe->base + VFE_0_CAMIF_FRAME_CFG);
 
 	val = line->fmt[MSM_VFE_PAD_SINK].width * 2 - 1;
@@ -834,7 +872,10 @@ static void vfe_set_camif_cfg(struct vfe_device *vfe, struct vfe_line *line)
 	writel_relaxed(val, vfe->base + VFE_0_CAMIF_WINDOW_HEIGHT_CFG);
 
 	val = 0xffffffff;
-	writel_relaxed(val, vfe->base + VFE_0_CAMIF_SUBSAMPLE_CFG_0);
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_SUBSAMPLE_CFG);
+
+	val = 0xffffffff;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_IRQ_FRAMEDROP_PATTERN);
 
 	val = 0xffffffff;
 	writel_relaxed(val, vfe->base + VFE_0_CAMIF_IRQ_SUBSAMPLE_PATTERN);
@@ -864,15 +905,18 @@ static void vfe_set_camif_cmd(struct vfe_device *vfe, u8 enable)
 
 static void vfe_set_module_cfg(struct vfe_device *vfe, u8 enable)
 {
-	u32 val = VFE_0_MODULE_CFG_DEMUX |
-		  VFE_0_MODULE_CFG_CHROMA_UPSAMPLE |
-		  VFE_0_MODULE_CFG_SCALE_ENC |
-		  VFE_0_MODULE_CFG_CROP_ENC;
+	u32 val_lens = VFE_0_MODULE_LENS_EN_DEMUX |
+		       VFE_0_MODULE_LENS_EN_CHROMA_UPSAMPLE;
+	u32 val_zoom = VFE_0_MODULE_ZOOM_EN_SCALE_ENC |
+		       VFE_0_MODULE_ZOOM_EN_CROP_ENC;
 
-	if (enable)
-		writel_relaxed(val, vfe->base + VFE_0_MODULE_CFG);
-	else
-		writel_relaxed(0x0, vfe->base + VFE_0_MODULE_CFG);
+	if (enable) {
+		writel_relaxed(val_lens, vfe->base + VFE_0_MODULE_LENS_EN);
+		writel_relaxed(val_zoom, vfe->base + VFE_0_MODULE_ZOOM_EN);
+	} else {
+		writel_relaxed(0x0, vfe->base + VFE_0_MODULE_LENS_EN);
+		writel_relaxed(0x0, vfe->base + VFE_0_MODULE_ZOOM_EN);
+	}
 }
 
 static int vfe_camif_wait_for_stop(struct vfe_device *vfe, struct device *dev)
@@ -963,7 +1007,7 @@ static irqreturn_t vfe_isr(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-const struct vfe_hw_ops vfe_ops_4_1 = {
+const struct vfe_hw_ops vfe_ops_4_7 = {
 	.hw_version_read = vfe_hw_version_read,
 	.get_ub_size = vfe_get_ub_size,
 	.global_reset = vfe_global_reset,
@@ -995,6 +1039,7 @@ const struct vfe_hw_ops vfe_ops_4_1 = {
 	.set_crop_cfg = vfe_set_crop_cfg,
 	.set_clamp_cfg = vfe_set_clamp_cfg,
 	.set_qos = vfe_set_qos,
+	.set_ds = vfe_set_ds,
 	.set_cgc_override = vfe_set_cgc_override,
 	.set_camif_cfg = vfe_set_camif_cfg,
 	.set_camif_cmd = vfe_set_camif_cmd,
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 7f07a22..e6f66cf 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -691,6 +691,8 @@ static int vfe_enable(struct vfe_line *line)
 		vfe->ops->bus_enable_wr_if(vfe, 1);
 
 		vfe->ops->set_qos(vfe);
+
+		vfe->ops->set_ds(vfe);
 	}
 
 	vfe->stream_count++;
@@ -1855,6 +1857,8 @@ int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
 
 	if (camss->version == CAMSS_8x16)
 		vfe->ops = &vfe_ops_4_1;
+	else if (camss->version == CAMSS_8x96)
+		vfe->ops = &vfe_ops_4_7;
 	else
 		return -EINVAL;
 
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
index 19041ba..eaebe83 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss/camss-vfe.h
@@ -118,6 +118,7 @@ struct vfe_hw_ops {
 	void (*set_crop_cfg)(struct vfe_device *vfe, struct vfe_line *line);
 	void (*set_clamp_cfg)(struct vfe_device *vfe);
 	void (*set_qos)(struct vfe_device *vfe);
+	void (*set_ds)(struct vfe_device *vfe);
 	void (*set_cgc_override)(struct vfe_device *vfe, u8 wm, u8 enable);
 	void (*set_camif_cfg)(struct vfe_device *vfe, struct vfe_line *line);
 	void (*set_camif_cmd)(struct vfe_device *vfe, u8 enable);
@@ -176,5 +177,6 @@ void msm_vfe_get_vfe_line_id(struct media_entity *entity, enum vfe_line_id *id);
 void msm_vfe_stop_streaming(struct vfe_device *vfe);
 
 extern const struct vfe_hw_ops vfe_ops_4_1;
+extern const struct vfe_hw_ops vfe_ops_4_7;
 
 #endif /* QC_MSM_CAMSS_VFE_H */
-- 
2.7.4
