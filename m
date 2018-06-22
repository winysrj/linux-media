Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46551 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933990AbeFVPeJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:34:09 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 24/32] media: camss: vfe: Add support for 8x96
Date: Fri, 22 Jun 2018 18:33:33 +0300
Message-Id: <1529681621-9682-25-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
References: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add VFE hardware dependent part for 8x96.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/Makefile        |    1 +
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c |    6 +
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c | 1051 +++++++++++++++++++++
 drivers/media/platform/qcom/camss/camss-vfe.c     |    5 +
 drivers/media/platform/qcom/camss/camss-vfe.h     |    1 +
 5 files changed, 1064 insertions(+)
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-7.c

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
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
new file mode 100644
index 0000000..45e6711
--- /dev/null
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
@@ -0,0 +1,1051 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * camss-vfe-4-7.c
+ *
+ * Qualcomm MSM Camera Subsystem - VFE (Video Front End) Module v4.7
+ *
+ * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2015-2018 Linaro Ltd.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/iopoll.h>
+
+#include "camss-vfe.h"
+
+#define VFE_0_HW_VERSION		0x000
+
+#define VFE_0_GLOBAL_RESET_CMD		0x018
+#define VFE_0_GLOBAL_RESET_CMD_CORE	BIT(0)
+#define VFE_0_GLOBAL_RESET_CMD_CAMIF	BIT(1)
+#define VFE_0_GLOBAL_RESET_CMD_BUS	BIT(2)
+#define VFE_0_GLOBAL_RESET_CMD_BUS_BDG	BIT(3)
+#define VFE_0_GLOBAL_RESET_CMD_REGISTER	BIT(4)
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
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_YCBYCR	0x4
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_YCRYCB	0x5
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_CBYCRY	0x6
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_CRYCBY	0x7
+#define VFE_0_CORE_CFG_COMPOSITE_REG_UPDATE_EN	BIT(4)
+
+#define VFE_0_IRQ_CMD			0x058
+#define VFE_0_IRQ_CMD_GLOBAL_CLEAR	BIT(0)
+
+#define VFE_0_IRQ_MASK_0		0x05c
+#define VFE_0_IRQ_MASK_0_CAMIF_SOF			BIT(0)
+#define VFE_0_IRQ_MASK_0_CAMIF_EOF			BIT(1)
+#define VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n)		BIT((n) + 5)
+#define VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(n)		\
+	((n) == VFE_LINE_PIX ? BIT(4) : VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n))
+#define VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(n)	BIT((n) + 8)
+#define VFE_0_IRQ_MASK_0_IMAGE_COMPOSITE_DONE_n(n)	BIT((n) + 25)
+#define VFE_0_IRQ_MASK_0_RESET_ACK			BIT(31)
+#define VFE_0_IRQ_MASK_1		0x060
+#define VFE_0_IRQ_MASK_1_CAMIF_ERROR			BIT(0)
+#define VFE_0_IRQ_MASK_1_VIOLATION			BIT(7)
+#define VFE_0_IRQ_MASK_1_BUS_BDG_HALT_ACK		BIT(8)
+#define VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(n)	BIT((n) + 9)
+#define VFE_0_IRQ_MASK_1_RDIn_SOF(n)			BIT((n) + 29)
+
+#define VFE_0_IRQ_CLEAR_0		0x064
+#define VFE_0_IRQ_CLEAR_1		0x068
+
+#define VFE_0_IRQ_STATUS_0		0x06c
+#define VFE_0_IRQ_STATUS_0_CAMIF_SOF			BIT(0)
+#define VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n)		BIT((n) + 5)
+#define VFE_0_IRQ_STATUS_0_line_n_REG_UPDATE(n)		\
+	((n) == VFE_LINE_PIX ? BIT(4) : VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n))
+#define VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG(n)	BIT((n) + 8)
+#define VFE_0_IRQ_STATUS_0_IMAGE_COMPOSITE_DONE_n(n)	BIT((n) + 25)
+#define VFE_0_IRQ_STATUS_0_RESET_ACK			BIT(31)
+#define VFE_0_IRQ_STATUS_1		0x070
+#define VFE_0_IRQ_STATUS_1_VIOLATION			BIT(7)
+#define VFE_0_IRQ_STATUS_1_BUS_BDG_HALT_ACK		BIT(8)
+#define VFE_0_IRQ_STATUS_1_RDIn_SOF(n)			BIT((n) + 29)
+
+#define VFE_0_IRQ_COMPOSITE_MASK_0	0x074
+#define VFE_0_VIOLATION_STATUS		0x07c
+
+#define VFE_0_BUS_CMD			0x80
+#define VFE_0_BUS_CMD_Mx_RLD_CMD(x)	BIT(x)
+
+#define VFE_0_BUS_CFG			0x084
+
+#define VFE_0_BUS_XBAR_CFG_x(x)		(0x90 + 0x4 * ((x) / 2))
+#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN			BIT(2)
+#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA	(0x3 << 4)
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT		8
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA		0x0
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0	0xc
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1	0xd
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2	0xe
+
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(n)		(0x0a0 + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_WR_PATH_SHIFT	0
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_PING_ADDR(n)	(0x0a4 + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_PONG_ADDR(n)	(0x0ac + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(n)		(0x0b4 + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_BASED_SHIFT	1
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_SHIFT	2
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_MASK	(0x1f << 2)
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG(n)		(0x0b8 + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG_OFFSET_SHIFT	16
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(n)	(0x0bc + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(n)	(0x0c0 + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_FRAMEDROP_PATTERN(n)	\
+							(0x0c4 + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(n)	\
+							(0x0c8 + 0x2c * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN_DEF	0xffffffff
+
+#define VFE_0_BUS_PING_PONG_STATUS	0x338
+
+#define VFE_0_BUS_BDG_CMD		0x400
+#define VFE_0_BUS_BDG_CMD_HALT_REQ	1
+
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
+#define VFE_0_RDI_CFG_x_RDI_STREAM_SEL_SHIFT	28
+#define VFE_0_RDI_CFG_x_RDI_STREAM_SEL_MASK	(0xf << 28)
+#define VFE_0_RDI_CFG_x_RDI_M0_SEL_SHIFT	4
+#define VFE_0_RDI_CFG_x_RDI_M0_SEL_MASK		(0xf << 4)
+#define VFE_0_RDI_CFG_x_RDI_EN_BIT		BIT(2)
+#define VFE_0_RDI_CFG_x_MIPI_EN_BITS		0x3
+
+#define VFE_0_CAMIF_CMD				0x478
+#define VFE_0_CAMIF_CMD_DISABLE_FRAME_BOUNDARY	0
+#define VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY	1
+#define VFE_0_CAMIF_CMD_NO_CHANGE		3
+#define VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS	BIT(2)
+#define VFE_0_CAMIF_CFG				0x47c
+#define VFE_0_CAMIF_CFG_VFE_OUTPUT_EN		BIT(6)
+#define VFE_0_CAMIF_FRAME_CFG			0x484
+#define VFE_0_CAMIF_WINDOW_WIDTH_CFG		0x488
+#define VFE_0_CAMIF_WINDOW_HEIGHT_CFG		0x48c
+#define VFE_0_CAMIF_SUBSAMPLE_CFG		0x490
+#define VFE_0_CAMIF_IRQ_FRAMEDROP_PATTERN	0x498
+#define VFE_0_CAMIF_IRQ_SUBSAMPLE_PATTERN	0x49c
+#define VFE_0_CAMIF_STATUS			0x4a4
+#define VFE_0_CAMIF_STATUS_HALT			BIT(31)
+
+#define VFE_0_REG_UPDATE		0x4ac
+#define VFE_0_REG_UPDATE_RDIn(n)		BIT(1 + (n))
+#define VFE_0_REG_UPDATE_line_n(n)		\
+			((n) == VFE_LINE_PIX ? 1 : VFE_0_REG_UPDATE_RDIn(n))
+
+#define VFE_0_DEMUX_CFG				0x560
+#define VFE_0_DEMUX_CFG_PERIOD			0x3
+#define VFE_0_DEMUX_GAIN_0			0x564
+#define VFE_0_DEMUX_GAIN_0_CH0_EVEN		(0x80 << 0)
+#define VFE_0_DEMUX_GAIN_0_CH0_ODD		(0x80 << 16)
+#define VFE_0_DEMUX_GAIN_1			0x568
+#define VFE_0_DEMUX_GAIN_1_CH1			(0x80 << 0)
+#define VFE_0_DEMUX_GAIN_1_CH2			(0x80 << 16)
+#define VFE_0_DEMUX_EVEN_CFG			0x574
+#define VFE_0_DEMUX_EVEN_CFG_PATTERN_YUYV	0x9cac
+#define VFE_0_DEMUX_EVEN_CFG_PATTERN_YVYU	0xac9c
+#define VFE_0_DEMUX_EVEN_CFG_PATTERN_UYVY	0xc9ca
+#define VFE_0_DEMUX_EVEN_CFG_PATTERN_VYUY	0xcac9
+#define VFE_0_DEMUX_ODD_CFG			0x578
+#define VFE_0_DEMUX_ODD_CFG_PATTERN_YUYV	0x9cac
+#define VFE_0_DEMUX_ODD_CFG_PATTERN_YVYU	0xac9c
+#define VFE_0_DEMUX_ODD_CFG_PATTERN_UYVY	0xc9ca
+#define VFE_0_DEMUX_ODD_CFG_PATTERN_VYUY	0xcac9
+
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
+#define VFE_0_CLAMP_ENC_MAX_CFG_CH0		(0xff << 0)
+#define VFE_0_CLAMP_ENC_MAX_CFG_CH1		(0xff << 8)
+#define VFE_0_CLAMP_ENC_MAX_CFG_CH2		(0xff << 16)
+#define VFE_0_CLAMP_ENC_MIN_CFG			0x988
+#define VFE_0_CLAMP_ENC_MIN_CFG_CH0		(0x0 << 0)
+#define VFE_0_CLAMP_ENC_MIN_CFG_CH1		(0x0 << 8)
+#define VFE_0_CLAMP_ENC_MIN_CFG_CH2		(0x0 << 16)
+
+#define CAMIF_TIMEOUT_SLEEP_US 1000
+#define CAMIF_TIMEOUT_ALL_US 1000000
+
+#define MSM_VFE_VFE0_UB_SIZE 2047
+#define MSM_VFE_VFE0_UB_SIZE_RDI (MSM_VFE_VFE0_UB_SIZE / 3)
+#define MSM_VFE_VFE1_UB_SIZE 1535
+#define MSM_VFE_VFE1_UB_SIZE_RDI (MSM_VFE_VFE1_UB_SIZE / 3)
+
+static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
+{
+	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
+
+	dev_err(dev, "VFE HW Version = 0x%08x\n", hw_version);
+}
+
+static u16 vfe_get_ub_size(u8 vfe_id)
+{
+	if (vfe_id == 0)
+		return MSM_VFE_VFE0_UB_SIZE_RDI;
+	else if (vfe_id == 1)
+		return MSM_VFE_VFE1_UB_SIZE_RDI;
+
+	return 0;
+}
+
+static inline void vfe_reg_clr(struct vfe_device *vfe, u32 reg, u32 clr_bits)
+{
+	u32 bits = readl_relaxed(vfe->base + reg);
+
+	writel_relaxed(bits & ~clr_bits, vfe->base + reg);
+}
+
+static inline void vfe_reg_set(struct vfe_device *vfe, u32 reg, u32 set_bits)
+{
+	u32 bits = readl_relaxed(vfe->base + reg);
+
+	writel_relaxed(bits | set_bits, vfe->base + reg);
+}
+
+static void vfe_global_reset(struct vfe_device *vfe)
+{
+	u32 reset_bits = VFE_0_GLOBAL_RESET_CMD_IDLE_CGC	|
+			 VFE_0_GLOBAL_RESET_CMD_DSP		|
+			 VFE_0_GLOBAL_RESET_CMD_TESTGEN		|
+			 VFE_0_GLOBAL_RESET_CMD_BUS_MISR	|
+			 VFE_0_GLOBAL_RESET_CMD_PM		|
+			 VFE_0_GLOBAL_RESET_CMD_REGISTER	|
+			 VFE_0_GLOBAL_RESET_CMD_BUS_BDG		|
+			 VFE_0_GLOBAL_RESET_CMD_BUS		|
+			 VFE_0_GLOBAL_RESET_CMD_CAMIF		|
+			 VFE_0_GLOBAL_RESET_CMD_CORE;
+
+	writel_relaxed(BIT(31), vfe->base + VFE_0_IRQ_MASK_0);
+	wmb();
+	writel_relaxed(reset_bits, vfe->base + VFE_0_GLOBAL_RESET_CMD);
+}
+
+static void vfe_halt_request(struct vfe_device *vfe)
+{
+	writel_relaxed(VFE_0_BUS_BDG_CMD_HALT_REQ,
+		       vfe->base + VFE_0_BUS_BDG_CMD);
+}
+
+static void vfe_halt_clear(struct vfe_device *vfe)
+{
+	writel_relaxed(0x0, vfe->base + VFE_0_BUS_BDG_CMD);
+}
+
+static void vfe_wm_enable(struct vfe_device *vfe, u8 wm, u8 enable)
+{
+	if (enable)
+		vfe_reg_set(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(wm),
+			    1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_WR_PATH_SHIFT);
+	else
+		vfe_reg_clr(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(wm),
+			    1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_WR_PATH_SHIFT);
+}
+
+static void vfe_wm_frame_based(struct vfe_device *vfe, u8 wm, u8 enable)
+{
+	if (enable)
+		vfe_reg_set(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(wm),
+			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_BASED_SHIFT);
+	else
+		vfe_reg_clr(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(wm),
+			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_BASED_SHIFT);
+}
+
+#define CALC_WORD(width, M, N) (((width) * (M) + (N) - 1) / (N))
+
+static int vfe_word_per_line(u32 format, u32 pixel_per_line)
+{
+	int val = 0;
+
+	switch (format) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		val = CALC_WORD(pixel_per_line, 1, 8);
+		break;
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+		val = CALC_WORD(pixel_per_line, 2, 8);
+		break;
+	}
+
+	return val;
+}
+
+static void vfe_get_wm_sizes(struct v4l2_pix_format_mplane *pix, u8 plane,
+			     u16 *width, u16 *height, u16 *bytesperline)
+{
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		*width = pix->width;
+		*height = pix->height;
+		*bytesperline = pix->plane_fmt[0].bytesperline;
+		if (plane == 1)
+			*height /= 2;
+		break;
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		*width = pix->width;
+		*height = pix->height;
+		*bytesperline = pix->plane_fmt[0].bytesperline;
+		break;
+	}
+}
+
+static void vfe_wm_line_based(struct vfe_device *vfe, u32 wm,
+			      struct v4l2_pix_format_mplane *pix,
+			      u8 plane, u32 enable)
+{
+	u32 reg;
+
+	if (enable) {
+		u16 width = 0, height = 0, bytesperline = 0, wpl;
+
+		vfe_get_wm_sizes(pix, plane, &width, &height, &bytesperline);
+
+		wpl = vfe_word_per_line(pix->pixelformat, width);
+
+		reg = height - 1;
+		reg |= ((wpl + 3) / 4 - 1) << 16;
+
+		writel_relaxed(reg, vfe->base +
+			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
+
+		wpl = vfe_word_per_line(pix->pixelformat, bytesperline);
+
+		reg = 0x3;
+		reg |= (height - 1) << 2;
+		reg |= ((wpl + 1) / 2) << 16;
+
+		writel_relaxed(reg, vfe->base +
+			       VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(wm));
+	} else {
+		writel_relaxed(0, vfe->base +
+			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
+		writel_relaxed(0, vfe->base +
+			       VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(wm));
+	}
+}
+
+static void vfe_wm_set_framedrop_period(struct vfe_device *vfe, u8 wm, u8 per)
+{
+	u32 reg;
+
+	reg = readl_relaxed(vfe->base +
+			    VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(wm));
+
+	reg &= ~(VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_MASK);
+
+	reg |= (per << VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_SHIFT)
+		& VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_MASK;
+
+	writel_relaxed(reg,
+		       vfe->base + VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(wm));
+}
+
+static void vfe_wm_set_framedrop_pattern(struct vfe_device *vfe, u8 wm,
+					 u32 pattern)
+{
+	writel_relaxed(pattern,
+	       vfe->base + VFE_0_BUS_IMAGE_MASTER_n_WR_FRAMEDROP_PATTERN(wm));
+}
+
+static void vfe_wm_set_ub_cfg(struct vfe_device *vfe, u8 wm,
+			      u16 offset, u16 depth)
+{
+	u32 reg;
+
+	reg = (offset << VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG_OFFSET_SHIFT) |
+		depth;
+	writel_relaxed(reg, vfe->base + VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG(wm));
+}
+
+static void vfe_bus_reload_wm(struct vfe_device *vfe, u8 wm)
+{
+	wmb();
+	writel_relaxed(VFE_0_BUS_CMD_Mx_RLD_CMD(wm), vfe->base + VFE_0_BUS_CMD);
+	wmb();
+}
+
+static void vfe_wm_set_ping_addr(struct vfe_device *vfe, u8 wm, u32 addr)
+{
+	writel_relaxed(addr,
+		       vfe->base + VFE_0_BUS_IMAGE_MASTER_n_WR_PING_ADDR(wm));
+}
+
+static void vfe_wm_set_pong_addr(struct vfe_device *vfe, u8 wm, u32 addr)
+{
+	writel_relaxed(addr,
+		       vfe->base + VFE_0_BUS_IMAGE_MASTER_n_WR_PONG_ADDR(wm));
+}
+
+static int vfe_wm_get_ping_pong_status(struct vfe_device *vfe, u8 wm)
+{
+	u32 reg;
+
+	reg = readl_relaxed(vfe->base + VFE_0_BUS_PING_PONG_STATUS);
+
+	return (reg >> wm) & 0x1;
+}
+
+static void vfe_bus_enable_wr_if(struct vfe_device *vfe, u8 enable)
+{
+	if (enable)
+		writel_relaxed(0x101, vfe->base + VFE_0_BUS_CFG);
+	else
+		writel_relaxed(0, vfe->base + VFE_0_BUS_CFG);
+}
+
+static void vfe_bus_connect_wm_to_rdi(struct vfe_device *vfe, u8 wm,
+				      enum vfe_line_id id)
+{
+	u32 reg;
+
+	reg = VFE_0_RDI_CFG_x_MIPI_EN_BITS;
+	vfe_reg_set(vfe, VFE_0_RDI_CFG_x(0), reg);
+
+	reg = VFE_0_RDI_CFG_x_RDI_EN_BIT;
+	reg |= ((3 * id) << VFE_0_RDI_CFG_x_RDI_STREAM_SEL_SHIFT) &
+		VFE_0_RDI_CFG_x_RDI_STREAM_SEL_MASK;
+	vfe_reg_set(vfe, VFE_0_RDI_CFG_x(id), reg);
+
+	switch (id) {
+	case VFE_LINE_RDI0:
+	default:
+		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0 <<
+		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
+		break;
+	case VFE_LINE_RDI1:
+		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1 <<
+		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
+		break;
+	case VFE_LINE_RDI2:
+		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2 <<
+		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
+		break;
+	}
+
+	if (wm % 2 == 1)
+		reg <<= 16;
+
+	vfe_reg_set(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
+}
+
+static void vfe_wm_set_subsample(struct vfe_device *vfe, u8 wm)
+{
+	writel_relaxed(VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN_DEF,
+	       vfe->base +
+	       VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(wm));
+}
+
+static void vfe_bus_disconnect_wm_from_rdi(struct vfe_device *vfe, u8 wm,
+					   enum vfe_line_id id)
+{
+	u32 reg;
+
+	reg = VFE_0_RDI_CFG_x_RDI_EN_BIT;
+	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(id), reg);
+
+	switch (id) {
+	case VFE_LINE_RDI0:
+	default:
+		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0 <<
+		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
+		break;
+	case VFE_LINE_RDI1:
+		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1 <<
+		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
+		break;
+	case VFE_LINE_RDI2:
+		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2 <<
+		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
+		break;
+	}
+
+	if (wm % 2 == 1)
+		reg <<= 16;
+
+	vfe_reg_clr(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
+}
+
+static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
+			     u8 enable)
+{
+	struct vfe_line *line = container_of(output, struct vfe_line, output);
+	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
+	u32 reg;
+	unsigned int i;
+
+	for (i = 0; i < output->wm_num; i++) {
+		if (i == 0) {
+			reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA <<
+				VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
+		} else if (i == 1) {
+			reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
+			if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
+				reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
+		}
+
+		if (output->wm_idx[i] % 2 == 1)
+			reg <<= 16;
+
+		if (enable)
+			vfe_reg_set(vfe,
+				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[i]),
+				    reg);
+		else
+			vfe_reg_clr(vfe,
+				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[i]),
+				    reg);
+	}
+}
+
+static void vfe_set_rdi_cid(struct vfe_device *vfe, enum vfe_line_id id, u8 cid)
+{
+	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(id),
+		    VFE_0_RDI_CFG_x_RDI_M0_SEL_MASK);
+
+	vfe_reg_set(vfe, VFE_0_RDI_CFG_x(id),
+		    cid << VFE_0_RDI_CFG_x_RDI_M0_SEL_SHIFT);
+}
+
+static void vfe_reg_update(struct vfe_device *vfe, enum vfe_line_id line_id)
+{
+	vfe->reg_update |= VFE_0_REG_UPDATE_line_n(line_id);
+	wmb();
+	writel_relaxed(vfe->reg_update, vfe->base + VFE_0_REG_UPDATE);
+	wmb();
+}
+
+static inline void vfe_reg_update_clear(struct vfe_device *vfe,
+					enum vfe_line_id line_id)
+{
+	vfe->reg_update &= ~VFE_0_REG_UPDATE_line_n(line_id);
+}
+
+static void vfe_enable_irq_wm_line(struct vfe_device *vfe, u8 wm,
+				   enum vfe_line_id line_id, u8 enable)
+{
+	u32 irq_en0 = VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(wm) |
+		      VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(line_id);
+	u32 irq_en1 = VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(wm) |
+		      VFE_0_IRQ_MASK_1_RDIn_SOF(line_id);
+
+	if (enable) {
+		vfe_reg_set(vfe, VFE_0_IRQ_MASK_0, irq_en0);
+		vfe_reg_set(vfe, VFE_0_IRQ_MASK_1, irq_en1);
+	} else {
+		vfe_reg_clr(vfe, VFE_0_IRQ_MASK_0, irq_en0);
+		vfe_reg_clr(vfe, VFE_0_IRQ_MASK_1, irq_en1);
+	}
+}
+
+static void vfe_enable_irq_pix_line(struct vfe_device *vfe, u8 comp,
+				    enum vfe_line_id line_id, u8 enable)
+{
+	struct vfe_output *output = &vfe->line[line_id].output;
+	unsigned int i;
+	u32 irq_en0;
+	u32 irq_en1;
+	u32 comp_mask = 0;
+
+	irq_en0 = VFE_0_IRQ_MASK_0_CAMIF_SOF;
+	irq_en0 |= VFE_0_IRQ_MASK_0_CAMIF_EOF;
+	irq_en0 |= VFE_0_IRQ_MASK_0_IMAGE_COMPOSITE_DONE_n(comp);
+	irq_en0 |= VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(line_id);
+	irq_en1 = VFE_0_IRQ_MASK_1_CAMIF_ERROR;
+	for (i = 0; i < output->wm_num; i++) {
+		irq_en1 |= VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(
+							output->wm_idx[i]);
+		comp_mask |= (1 << output->wm_idx[i]) << comp * 8;
+	}
+
+	if (enable) {
+		vfe_reg_set(vfe, VFE_0_IRQ_MASK_0, irq_en0);
+		vfe_reg_set(vfe, VFE_0_IRQ_MASK_1, irq_en1);
+		vfe_reg_set(vfe, VFE_0_IRQ_COMPOSITE_MASK_0, comp_mask);
+	} else {
+		vfe_reg_clr(vfe, VFE_0_IRQ_MASK_0, irq_en0);
+		vfe_reg_clr(vfe, VFE_0_IRQ_MASK_1, irq_en1);
+		vfe_reg_clr(vfe, VFE_0_IRQ_COMPOSITE_MASK_0, comp_mask);
+	}
+}
+
+static void vfe_enable_irq_common(struct vfe_device *vfe)
+{
+	u32 irq_en0 = VFE_0_IRQ_MASK_0_RESET_ACK;
+	u32 irq_en1 = VFE_0_IRQ_MASK_1_VIOLATION |
+		      VFE_0_IRQ_MASK_1_BUS_BDG_HALT_ACK;
+
+	vfe_reg_set(vfe, VFE_0_IRQ_MASK_0, irq_en0);
+	vfe_reg_set(vfe, VFE_0_IRQ_MASK_1, irq_en1);
+}
+
+static void vfe_set_demux_cfg(struct vfe_device *vfe, struct vfe_line *line)
+{
+	u32 val, even_cfg, odd_cfg;
+
+	writel_relaxed(VFE_0_DEMUX_CFG_PERIOD, vfe->base + VFE_0_DEMUX_CFG);
+
+	val = VFE_0_DEMUX_GAIN_0_CH0_EVEN | VFE_0_DEMUX_GAIN_0_CH0_ODD;
+	writel_relaxed(val, vfe->base + VFE_0_DEMUX_GAIN_0);
+
+	val = VFE_0_DEMUX_GAIN_1_CH1 | VFE_0_DEMUX_GAIN_1_CH2;
+	writel_relaxed(val, vfe->base + VFE_0_DEMUX_GAIN_1);
+
+	switch (line->fmt[MSM_VFE_PAD_SINK].code) {
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+		even_cfg = VFE_0_DEMUX_EVEN_CFG_PATTERN_YUYV;
+		odd_cfg = VFE_0_DEMUX_ODD_CFG_PATTERN_YUYV;
+		break;
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+		even_cfg = VFE_0_DEMUX_EVEN_CFG_PATTERN_YVYU;
+		odd_cfg = VFE_0_DEMUX_ODD_CFG_PATTERN_YVYU;
+		break;
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	default:
+		even_cfg = VFE_0_DEMUX_EVEN_CFG_PATTERN_UYVY;
+		odd_cfg = VFE_0_DEMUX_ODD_CFG_PATTERN_UYVY;
+		break;
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+		even_cfg = VFE_0_DEMUX_EVEN_CFG_PATTERN_VYUY;
+		odd_cfg = VFE_0_DEMUX_ODD_CFG_PATTERN_VYUY;
+		break;
+	}
+
+	writel_relaxed(even_cfg, vfe->base + VFE_0_DEMUX_EVEN_CFG);
+	writel_relaxed(odd_cfg, vfe->base + VFE_0_DEMUX_ODD_CFG);
+}
+
+static inline u8 vfe_calc_interp_reso(u16 input, u16 output)
+{
+	if (input / output >= 16)
+		return 0;
+
+	if (input / output >= 8)
+		return 1;
+
+	if (input / output >= 4)
+		return 2;
+
+	return 3;
+}
+
+static void vfe_set_scale_cfg(struct vfe_device *vfe, struct vfe_line *line)
+{
+	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
+	u32 reg;
+	u16 input, output;
+	u8 interp_reso;
+	u32 phase_mult;
+
+	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_Y_CFG);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].width - 1;
+	output = line->compose.width - 1;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_H_IMAGE_SIZE);
+
+	interp_reso = vfe_calc_interp_reso(input, output);
+	phase_mult = input * (1 << (14 + interp_reso)) / output;
+	reg = (interp_reso << 28) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_H_PHASE);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].height - 1;
+	output = line->compose.height - 1;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_V_IMAGE_SIZE);
+
+	interp_reso = vfe_calc_interp_reso(input, output);
+	phase_mult = input * (1 << (14 + interp_reso)) / output;
+	reg = (interp_reso << 28) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_V_PHASE);
+
+	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_CBCR_CFG);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].width - 1;
+	output = line->compose.width / 2 - 1;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE);
+
+	interp_reso = vfe_calc_interp_reso(input, output);
+	phase_mult = input * (1 << (14 + interp_reso)) / output;
+	reg = (interp_reso << 28) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_PHASE);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].height - 1;
+	output = line->compose.height - 1;
+	if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV21)
+		output = line->compose.height / 2 - 1;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE);
+
+	interp_reso = vfe_calc_interp_reso(input, output);
+	phase_mult = input * (1 << (14 + interp_reso)) / output;
+	reg = (interp_reso << 28) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_PHASE);
+}
+
+static void vfe_set_crop_cfg(struct vfe_device *vfe, struct vfe_line *line)
+{
+	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
+	u32 reg;
+	u16 first, last;
+
+	first = line->crop.left;
+	last = line->crop.left + line->crop.width - 1;
+	reg = (first << 16) | last;
+	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_Y_WIDTH);
+
+	first = line->crop.top;
+	last = line->crop.top + line->crop.height - 1;
+	reg = (first << 16) | last;
+	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_Y_HEIGHT);
+
+	first = line->crop.left / 2;
+	last = line->crop.left / 2 + line->crop.width / 2 - 1;
+	reg = (first << 16) | last;
+	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_CBCR_WIDTH);
+
+	first = line->crop.top;
+	last = line->crop.top + line->crop.height - 1;
+	if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV21) {
+		first = line->crop.top / 2;
+		last = line->crop.top / 2 + line->crop.height / 2 - 1;
+	}
+	reg = (first << 16) | last;
+	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_CBCR_HEIGHT);
+}
+
+static void vfe_set_clamp_cfg(struct vfe_device *vfe)
+{
+	u32 val = VFE_0_CLAMP_ENC_MAX_CFG_CH0 |
+		VFE_0_CLAMP_ENC_MAX_CFG_CH1 |
+		VFE_0_CLAMP_ENC_MAX_CFG_CH2;
+
+	writel_relaxed(val, vfe->base + VFE_0_CLAMP_ENC_MAX_CFG);
+
+	val = VFE_0_CLAMP_ENC_MIN_CFG_CH0 |
+		VFE_0_CLAMP_ENC_MIN_CFG_CH1 |
+		VFE_0_CLAMP_ENC_MIN_CFG_CH2;
+
+	writel_relaxed(val, vfe->base + VFE_0_CLAMP_ENC_MIN_CFG);
+}
+
+static void vfe_set_qos(struct vfe_device *vfe)
+{
+	u32 val = VFE_0_BUS_BDG_QOS_CFG_0_CFG;
+	u32 val7 = VFE_0_BUS_BDG_QOS_CFG_7_CFG;
+
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_0);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_1);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_2);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_3);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_4);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_5);
+	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_6);
+	writel_relaxed(val7, vfe->base + VFE_0_BUS_BDG_QOS_CFG_7);
+}
+
+static void vfe_set_ds(struct vfe_device *vfe)
+{
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
+
+static void vfe_set_cgc_override(struct vfe_device *vfe, u8 wm, u8 enable)
+{
+	/* empty */
+}
+
+static void vfe_set_camif_cfg(struct vfe_device *vfe, struct vfe_line *line)
+{
+	u32 val;
+
+	switch (line->fmt[MSM_VFE_PAD_SINK].code) {
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+		val = VFE_0_CORE_CFG_PIXEL_PATTERN_YCBYCR;
+		break;
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+		val = VFE_0_CORE_CFG_PIXEL_PATTERN_YCRYCB;
+		break;
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	default:
+		val = VFE_0_CORE_CFG_PIXEL_PATTERN_CBYCRY;
+		break;
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+		val = VFE_0_CORE_CFG_PIXEL_PATTERN_CRYCBY;
+		break;
+	}
+
+	val |= VFE_0_CORE_CFG_COMPOSITE_REG_UPDATE_EN;
+	writel_relaxed(val, vfe->base + VFE_0_CORE_CFG);
+
+	val = line->fmt[MSM_VFE_PAD_SINK].width * 2 - 1;
+	val |= (line->fmt[MSM_VFE_PAD_SINK].height - 1) << 16;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_FRAME_CFG);
+
+	val = line->fmt[MSM_VFE_PAD_SINK].width * 2 - 1;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_WINDOW_WIDTH_CFG);
+
+	val = line->fmt[MSM_VFE_PAD_SINK].height - 1;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_WINDOW_HEIGHT_CFG);
+
+	val = 0xffffffff;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_SUBSAMPLE_CFG);
+
+	val = 0xffffffff;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_IRQ_FRAMEDROP_PATTERN);
+
+	val = 0xffffffff;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_IRQ_SUBSAMPLE_PATTERN);
+
+	val = VFE_0_RDI_CFG_x_MIPI_EN_BITS;
+	vfe_reg_set(vfe, VFE_0_RDI_CFG_x(0), val);
+
+	val = VFE_0_CAMIF_CFG_VFE_OUTPUT_EN;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_CFG);
+}
+
+static void vfe_set_camif_cmd(struct vfe_device *vfe, u8 enable)
+{
+	u32 cmd;
+
+	cmd = VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS | VFE_0_CAMIF_CMD_NO_CHANGE;
+	writel_relaxed(cmd, vfe->base + VFE_0_CAMIF_CMD);
+	wmb();
+
+	if (enable)
+		cmd = VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY;
+	else
+		cmd = VFE_0_CAMIF_CMD_DISABLE_FRAME_BOUNDARY;
+
+	writel_relaxed(cmd, vfe->base + VFE_0_CAMIF_CMD);
+}
+
+static void vfe_set_module_cfg(struct vfe_device *vfe, u8 enable)
+{
+	u32 val_lens = VFE_0_MODULE_LENS_EN_DEMUX |
+		       VFE_0_MODULE_LENS_EN_CHROMA_UPSAMPLE;
+	u32 val_zoom = VFE_0_MODULE_ZOOM_EN_SCALE_ENC |
+		       VFE_0_MODULE_ZOOM_EN_CROP_ENC;
+
+	if (enable) {
+		writel_relaxed(val_lens, vfe->base + VFE_0_MODULE_LENS_EN);
+		writel_relaxed(val_zoom, vfe->base + VFE_0_MODULE_ZOOM_EN);
+	} else {
+		writel_relaxed(0x0, vfe->base + VFE_0_MODULE_LENS_EN);
+		writel_relaxed(0x0, vfe->base + VFE_0_MODULE_ZOOM_EN);
+	}
+}
+
+static int vfe_camif_wait_for_stop(struct vfe_device *vfe, struct device *dev)
+{
+	u32 val;
+	int ret;
+
+	ret = readl_poll_timeout(vfe->base + VFE_0_CAMIF_STATUS,
+				 val,
+				 (val & VFE_0_CAMIF_STATUS_HALT),
+				 CAMIF_TIMEOUT_SLEEP_US,
+				 CAMIF_TIMEOUT_ALL_US);
+	if (ret < 0)
+		dev_err(dev, "%s: camif stop timeout\n", __func__);
+
+	return ret;
+}
+
+static void vfe_isr_read(struct vfe_device *vfe, u32 *value0, u32 *value1)
+{
+	*value0 = readl_relaxed(vfe->base + VFE_0_IRQ_STATUS_0);
+	*value1 = readl_relaxed(vfe->base + VFE_0_IRQ_STATUS_1);
+
+	writel_relaxed(*value0, vfe->base + VFE_0_IRQ_CLEAR_0);
+	writel_relaxed(*value1, vfe->base + VFE_0_IRQ_CLEAR_1);
+
+	wmb();
+	writel_relaxed(VFE_0_IRQ_CMD_GLOBAL_CLEAR, vfe->base + VFE_0_IRQ_CMD);
+}
+
+static void vfe_violation_read(struct vfe_device *vfe)
+{
+	u32 violation = readl_relaxed(vfe->base + VFE_0_VIOLATION_STATUS);
+
+	pr_err_ratelimited("VFE: violation = 0x%08x\n", violation);
+}
+
+/*
+ * vfe_isr - ISPIF module interrupt handler
+ * @irq: Interrupt line
+ * @dev: VFE device
+ *
+ * Return IRQ_HANDLED on success
+ */
+static irqreturn_t vfe_isr(int irq, void *dev)
+{
+	struct vfe_device *vfe = dev;
+	u32 value0, value1;
+	int i, j;
+
+	vfe->ops->isr_read(vfe, &value0, &value1);
+
+	trace_printk("VFE: status0 = 0x%08x, status1 = 0x%08x\n",
+		     value0, value1);
+
+	if (value0 & VFE_0_IRQ_STATUS_0_RESET_ACK)
+		vfe->isr_ops.reset_ack(vfe);
+
+	if (value1 & VFE_0_IRQ_STATUS_1_VIOLATION)
+		vfe->ops->violation_read(vfe);
+
+	if (value1 & VFE_0_IRQ_STATUS_1_BUS_BDG_HALT_ACK)
+		vfe->isr_ops.halt_ack(vfe);
+
+	for (i = VFE_LINE_RDI0; i <= VFE_LINE_PIX; i++)
+		if (value0 & VFE_0_IRQ_STATUS_0_line_n_REG_UPDATE(i))
+			vfe->isr_ops.reg_update(vfe, i);
+
+	if (value0 & VFE_0_IRQ_STATUS_0_CAMIF_SOF)
+		vfe->isr_ops.sof(vfe, VFE_LINE_PIX);
+
+	for (i = VFE_LINE_RDI0; i <= VFE_LINE_RDI2; i++)
+		if (value1 & VFE_0_IRQ_STATUS_1_RDIn_SOF(i))
+			vfe->isr_ops.sof(vfe, i);
+
+	for (i = 0; i < MSM_VFE_COMPOSITE_IRQ_NUM; i++)
+		if (value0 & VFE_0_IRQ_STATUS_0_IMAGE_COMPOSITE_DONE_n(i)) {
+			vfe->isr_ops.comp_done(vfe, i);
+			for (j = 0; j < ARRAY_SIZE(vfe->wm_output_map); j++)
+				if (vfe->wm_output_map[j] == VFE_LINE_PIX)
+					value0 &= ~VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(j);
+		}
+
+	for (i = 0; i < MSM_VFE_IMAGE_MASTERS_NUM; i++)
+		if (value0 & VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG(i))
+			vfe->isr_ops.wm_done(vfe, i);
+
+	return IRQ_HANDLED;
+}
+
+const struct vfe_hw_ops vfe_ops_4_7 = {
+	.hw_version_read = vfe_hw_version_read,
+	.get_ub_size = vfe_get_ub_size,
+	.global_reset = vfe_global_reset,
+	.halt_request = vfe_halt_request,
+	.halt_clear = vfe_halt_clear,
+	.wm_enable = vfe_wm_enable,
+	.wm_frame_based = vfe_wm_frame_based,
+	.wm_line_based = vfe_wm_line_based,
+	.wm_set_framedrop_period = vfe_wm_set_framedrop_period,
+	.wm_set_framedrop_pattern = vfe_wm_set_framedrop_pattern,
+	.wm_set_ub_cfg = vfe_wm_set_ub_cfg,
+	.bus_reload_wm = vfe_bus_reload_wm,
+	.wm_set_ping_addr = vfe_wm_set_ping_addr,
+	.wm_set_pong_addr = vfe_wm_set_pong_addr,
+	.wm_get_ping_pong_status = vfe_wm_get_ping_pong_status,
+	.bus_enable_wr_if = vfe_bus_enable_wr_if,
+	.bus_connect_wm_to_rdi = vfe_bus_connect_wm_to_rdi,
+	.wm_set_subsample = vfe_wm_set_subsample,
+	.bus_disconnect_wm_from_rdi = vfe_bus_disconnect_wm_from_rdi,
+	.set_xbar_cfg = vfe_set_xbar_cfg,
+	.set_rdi_cid = vfe_set_rdi_cid,
+	.reg_update = vfe_reg_update,
+	.reg_update_clear = vfe_reg_update_clear,
+	.enable_irq_wm_line = vfe_enable_irq_wm_line,
+	.enable_irq_pix_line = vfe_enable_irq_pix_line,
+	.enable_irq_common = vfe_enable_irq_common,
+	.set_demux_cfg = vfe_set_demux_cfg,
+	.set_scale_cfg = vfe_set_scale_cfg,
+	.set_crop_cfg = vfe_set_crop_cfg,
+	.set_clamp_cfg = vfe_set_clamp_cfg,
+	.set_qos = vfe_set_qos,
+	.set_ds = vfe_set_ds,
+	.set_cgc_override = vfe_set_cgc_override,
+	.set_camif_cfg = vfe_set_camif_cfg,
+	.set_camif_cmd = vfe_set_camif_cmd,
+	.set_module_cfg = vfe_set_module_cfg,
+	.camif_wait_for_stop = vfe_camif_wait_for_stop,
+	.isr_read = vfe_isr_read,
+	.violation_read = vfe_violation_read,
+	.isr = vfe_isr,
+};
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 45a88c0..7356a81 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -46,6 +46,7 @@
 #define SCALER_RATIO_MAX 16
 
 extern struct vfe_hw_ops vfe_ops_4_1;
+extern struct vfe_hw_ops vfe_ops_4_7;
 
 static const struct {
 	u32 code;
@@ -693,6 +694,8 @@ static int vfe_enable(struct vfe_line *line)
 		vfe->ops->bus_enable_wr_if(vfe, 1);
 
 		vfe->ops->set_qos(vfe);
+
+		vfe->ops->set_ds(vfe);
 	}
 
 	vfe->stream_count++;
@@ -1853,6 +1856,8 @@ int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
 
 	if (camss->version == CAMSS_8x16)
 		vfe->ops = &vfe_ops_4_1;
+	else if (camss->version == CAMSS_8x96)
+		vfe->ops = &vfe_ops_4_7;
 	else
 		return -EINVAL;
 
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
index 872ae1e..bb09ed9 100644
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
-- 
2.7.4
