Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46425 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933987AbeFVPeJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:34:09 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 23/32] media: camss: vfe: Split to hardware dependent and independent parts
Date: Fri, 22 Jun 2018 18:33:32 +0300
Message-Id: <1529681621-9682-24-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
References: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will allow to add support for different hardware.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/Makefile        |    1 +
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c | 1006 +++++++++++++++++++
 drivers/media/platform/qcom/camss/camss-vfe.c     | 1076 ++-------------------
 drivers/media/platform/qcom/camss/camss-vfe.h     |   71 +-
 4 files changed, 1169 insertions(+), 985 deletions(-)
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-1.c

diff --git a/drivers/media/platform/qcom/camss/Makefile b/drivers/media/platform/qcom/camss/Makefile
index 36b9f7c..38dc56e 100644
--- a/drivers/media/platform/qcom/camss/Makefile
+++ b/drivers/media/platform/qcom/camss/Makefile
@@ -7,6 +7,7 @@ qcom-camss-objs += \
 		camss-csiphy-3ph-1-0.o \
 		camss-csiphy.o \
 		camss-ispif.o \
+		camss-vfe-4-1.o \
 		camss-vfe.o \
 		camss-video.o \
 
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
new file mode 100644
index 0000000..070c0c3
--- /dev/null
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
@@ -0,0 +1,1006 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * camss-vfe-4-1.c
+ *
+ * Qualcomm MSM Camera Subsystem - VFE (Video Front End) Module v4.1
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
+#define VFE_0_GLOBAL_RESET_CMD		0x00c
+#define VFE_0_GLOBAL_RESET_CMD_CORE	BIT(0)
+#define VFE_0_GLOBAL_RESET_CMD_CAMIF	BIT(1)
+#define VFE_0_GLOBAL_RESET_CMD_BUS	BIT(2)
+#define VFE_0_GLOBAL_RESET_CMD_BUS_BDG	BIT(3)
+#define VFE_0_GLOBAL_RESET_CMD_REGISTER	BIT(4)
+#define VFE_0_GLOBAL_RESET_CMD_TIMER	BIT(5)
+#define VFE_0_GLOBAL_RESET_CMD_PM	BIT(6)
+#define VFE_0_GLOBAL_RESET_CMD_BUS_MISR	BIT(7)
+#define VFE_0_GLOBAL_RESET_CMD_TESTGEN	BIT(8)
+
+#define VFE_0_MODULE_CFG		0x018
+#define VFE_0_MODULE_CFG_DEMUX			BIT(2)
+#define VFE_0_MODULE_CFG_CHROMA_UPSAMPLE	BIT(3)
+#define VFE_0_MODULE_CFG_SCALE_ENC		BIT(23)
+#define VFE_0_MODULE_CFG_CROP_ENC		BIT(27)
+
+#define VFE_0_CORE_CFG			0x01c
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_YCBYCR	0x4
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_YCRYCB	0x5
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_CBYCRY	0x6
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_CRYCBY	0x7
+
+#define VFE_0_IRQ_CMD			0x024
+#define VFE_0_IRQ_CMD_GLOBAL_CLEAR	BIT(0)
+
+#define VFE_0_IRQ_MASK_0		0x028
+#define VFE_0_IRQ_MASK_0_CAMIF_SOF			BIT(0)
+#define VFE_0_IRQ_MASK_0_CAMIF_EOF			BIT(1)
+#define VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n)		BIT((n) + 5)
+#define VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(n)		\
+	((n) == VFE_LINE_PIX ? BIT(4) : VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n))
+#define VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(n)	BIT((n) + 8)
+#define VFE_0_IRQ_MASK_0_IMAGE_COMPOSITE_DONE_n(n)	BIT((n) + 25)
+#define VFE_0_IRQ_MASK_0_RESET_ACK			BIT(31)
+#define VFE_0_IRQ_MASK_1		0x02c
+#define VFE_0_IRQ_MASK_1_CAMIF_ERROR			BIT(0)
+#define VFE_0_IRQ_MASK_1_VIOLATION			BIT(7)
+#define VFE_0_IRQ_MASK_1_BUS_BDG_HALT_ACK		BIT(8)
+#define VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(n)	BIT((n) + 9)
+#define VFE_0_IRQ_MASK_1_RDIn_SOF(n)			BIT((n) + 29)
+
+#define VFE_0_IRQ_CLEAR_0		0x030
+#define VFE_0_IRQ_CLEAR_1		0x034
+
+#define VFE_0_IRQ_STATUS_0		0x038
+#define VFE_0_IRQ_STATUS_0_CAMIF_SOF			BIT(0)
+#define VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n)		BIT((n) + 5)
+#define VFE_0_IRQ_STATUS_0_line_n_REG_UPDATE(n)		\
+	((n) == VFE_LINE_PIX ? BIT(4) : VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n))
+#define VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG(n)	BIT((n) + 8)
+#define VFE_0_IRQ_STATUS_0_IMAGE_COMPOSITE_DONE_n(n)	BIT((n) + 25)
+#define VFE_0_IRQ_STATUS_0_RESET_ACK			BIT(31)
+#define VFE_0_IRQ_STATUS_1		0x03c
+#define VFE_0_IRQ_STATUS_1_VIOLATION			BIT(7)
+#define VFE_0_IRQ_STATUS_1_BUS_BDG_HALT_ACK		BIT(8)
+#define VFE_0_IRQ_STATUS_1_RDIn_SOF(n)			BIT((n) + 29)
+
+#define VFE_0_IRQ_COMPOSITE_MASK_0	0x40
+#define VFE_0_VIOLATION_STATUS		0x48
+
+#define VFE_0_BUS_CMD			0x4c
+#define VFE_0_BUS_CMD_Mx_RLD_CMD(x)	BIT(x)
+
+#define VFE_0_BUS_CFG			0x050
+
+#define VFE_0_BUS_XBAR_CFG_x(x)		(0x58 + 0x4 * ((x) / 2))
+#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN			BIT(1)
+#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA	(0x3 << 4)
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT		8
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA		0
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0	5
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1	6
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2	7
+
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(n)		(0x06c + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_WR_PATH_SHIFT	0
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT	1
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_PING_ADDR(n)	(0x070 + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_PONG_ADDR(n)	(0x074 + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(n)		(0x078 + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_SHIFT	2
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_MASK	(0x1f << 2)
+
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG(n)		(0x07c + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG_OFFSET_SHIFT	16
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(n)	(0x080 + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(n)	(0x084 + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_FRAMEDROP_PATTERN(n)	\
+							(0x088 + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(n)	\
+							(0x08c + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN_DEF	0xffffffff
+
+#define VFE_0_BUS_PING_PONG_STATUS	0x268
+
+#define VFE_0_BUS_BDG_CMD		0x2c0
+#define VFE_0_BUS_BDG_CMD_HALT_REQ	1
+
+#define VFE_0_BUS_BDG_QOS_CFG_0		0x2c4
+#define VFE_0_BUS_BDG_QOS_CFG_0_CFG	0xaaa5aaa5
+#define VFE_0_BUS_BDG_QOS_CFG_1		0x2c8
+#define VFE_0_BUS_BDG_QOS_CFG_2		0x2cc
+#define VFE_0_BUS_BDG_QOS_CFG_3		0x2d0
+#define VFE_0_BUS_BDG_QOS_CFG_4		0x2d4
+#define VFE_0_BUS_BDG_QOS_CFG_5		0x2d8
+#define VFE_0_BUS_BDG_QOS_CFG_6		0x2dc
+#define VFE_0_BUS_BDG_QOS_CFG_7		0x2e0
+#define VFE_0_BUS_BDG_QOS_CFG_7_CFG	0x0001aaa5
+
+#define VFE_0_RDI_CFG_x(x)		(0x2e8 + (0x4 * (x)))
+#define VFE_0_RDI_CFG_x_RDI_STREAM_SEL_SHIFT	28
+#define VFE_0_RDI_CFG_x_RDI_STREAM_SEL_MASK	(0xf << 28)
+#define VFE_0_RDI_CFG_x_RDI_M0_SEL_SHIFT	4
+#define VFE_0_RDI_CFG_x_RDI_M0_SEL_MASK		(0xf << 4)
+#define VFE_0_RDI_CFG_x_RDI_EN_BIT		BIT(2)
+#define VFE_0_RDI_CFG_x_MIPI_EN_BITS		0x3
+#define VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(r)	BIT(16 + (r))
+
+#define VFE_0_CAMIF_CMD				0x2f4
+#define VFE_0_CAMIF_CMD_DISABLE_FRAME_BOUNDARY	0
+#define VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY	1
+#define VFE_0_CAMIF_CMD_NO_CHANGE		3
+#define VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS	BIT(2)
+#define VFE_0_CAMIF_CFG				0x2f8
+#define VFE_0_CAMIF_CFG_VFE_OUTPUT_EN		BIT(6)
+#define VFE_0_CAMIF_FRAME_CFG			0x300
+#define VFE_0_CAMIF_WINDOW_WIDTH_CFG		0x304
+#define VFE_0_CAMIF_WINDOW_HEIGHT_CFG		0x308
+#define VFE_0_CAMIF_SUBSAMPLE_CFG_0		0x30c
+#define VFE_0_CAMIF_IRQ_SUBSAMPLE_PATTERN	0x314
+#define VFE_0_CAMIF_STATUS			0x31c
+#define VFE_0_CAMIF_STATUS_HALT			BIT(31)
+
+#define VFE_0_REG_UPDATE			0x378
+#define VFE_0_REG_UPDATE_RDIn(n)		BIT(1 + (n))
+#define VFE_0_REG_UPDATE_line_n(n)		\
+			((n) == VFE_LINE_PIX ? 1 : VFE_0_REG_UPDATE_RDIn(n))
+
+#define VFE_0_DEMUX_CFG				0x424
+#define VFE_0_DEMUX_CFG_PERIOD			0x3
+#define VFE_0_DEMUX_GAIN_0			0x428
+#define VFE_0_DEMUX_GAIN_0_CH0_EVEN		(0x80 << 0)
+#define VFE_0_DEMUX_GAIN_0_CH0_ODD		(0x80 << 16)
+#define VFE_0_DEMUX_GAIN_1			0x42c
+#define VFE_0_DEMUX_GAIN_1_CH1			(0x80 << 0)
+#define VFE_0_DEMUX_GAIN_1_CH2			(0x80 << 16)
+#define VFE_0_DEMUX_EVEN_CFG			0x438
+#define VFE_0_DEMUX_EVEN_CFG_PATTERN_YUYV	0x9cac
+#define VFE_0_DEMUX_EVEN_CFG_PATTERN_YVYU	0xac9c
+#define VFE_0_DEMUX_EVEN_CFG_PATTERN_UYVY	0xc9ca
+#define VFE_0_DEMUX_EVEN_CFG_PATTERN_VYUY	0xcac9
+#define VFE_0_DEMUX_ODD_CFG			0x43c
+#define VFE_0_DEMUX_ODD_CFG_PATTERN_YUYV	0x9cac
+#define VFE_0_DEMUX_ODD_CFG_PATTERN_YVYU	0xac9c
+#define VFE_0_DEMUX_ODD_CFG_PATTERN_UYVY	0xc9ca
+#define VFE_0_DEMUX_ODD_CFG_PATTERN_VYUY	0xcac9
+
+#define VFE_0_SCALE_ENC_Y_CFG			0x75c
+#define VFE_0_SCALE_ENC_Y_H_IMAGE_SIZE		0x760
+#define VFE_0_SCALE_ENC_Y_H_PHASE		0x764
+#define VFE_0_SCALE_ENC_Y_V_IMAGE_SIZE		0x76c
+#define VFE_0_SCALE_ENC_Y_V_PHASE		0x770
+#define VFE_0_SCALE_ENC_CBCR_CFG		0x778
+#define VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE	0x77c
+#define VFE_0_SCALE_ENC_CBCR_H_PHASE		0x780
+#define VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE	0x790
+#define VFE_0_SCALE_ENC_CBCR_V_PHASE		0x794
+
+#define VFE_0_CROP_ENC_Y_WIDTH			0x854
+#define VFE_0_CROP_ENC_Y_HEIGHT			0x858
+#define VFE_0_CROP_ENC_CBCR_WIDTH		0x85c
+#define VFE_0_CROP_ENC_CBCR_HEIGHT		0x860
+
+#define VFE_0_CLAMP_ENC_MAX_CFG			0x874
+#define VFE_0_CLAMP_ENC_MAX_CFG_CH0		(0xff << 0)
+#define VFE_0_CLAMP_ENC_MAX_CFG_CH1		(0xff << 8)
+#define VFE_0_CLAMP_ENC_MAX_CFG_CH2		(0xff << 16)
+#define VFE_0_CLAMP_ENC_MIN_CFG			0x878
+#define VFE_0_CLAMP_ENC_MIN_CFG_CH0		(0x0 << 0)
+#define VFE_0_CLAMP_ENC_MIN_CFG_CH1		(0x0 << 8)
+#define VFE_0_CLAMP_ENC_MIN_CFG_CH2		(0x0 << 16)
+
+#define VFE_0_CGC_OVERRIDE_1			0x974
+#define VFE_0_CGC_OVERRIDE_1_IMAGE_Mx_CGC_OVERRIDE(x)	BIT(x)
+
+#define CAMIF_TIMEOUT_SLEEP_US 1000
+#define CAMIF_TIMEOUT_ALL_US 1000000
+
+#define MSM_VFE_VFE0_UB_SIZE 1023
+#define MSM_VFE_VFE0_UB_SIZE_RDI (MSM_VFE_VFE0_UB_SIZE / 3)
+
+static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
+{
+	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
+
+	dev_dbg(dev, "VFE HW Version = 0x%08x\n", hw_version);
+}
+
+static u16 vfe_get_ub_size(u8 vfe_id)
+{
+	if (vfe_id == 0)
+		return MSM_VFE_VFE0_UB_SIZE_RDI;
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
+	u32 reset_bits = VFE_0_GLOBAL_RESET_CMD_TESTGEN		|
+			 VFE_0_GLOBAL_RESET_CMD_BUS_MISR	|
+			 VFE_0_GLOBAL_RESET_CMD_PM		|
+			 VFE_0_GLOBAL_RESET_CMD_TIMER		|
+			 VFE_0_GLOBAL_RESET_CMD_REGISTER	|
+			 VFE_0_GLOBAL_RESET_CMD_BUS_BDG		|
+			 VFE_0_GLOBAL_RESET_CMD_BUS		|
+			 VFE_0_GLOBAL_RESET_CMD_CAMIF		|
+			 VFE_0_GLOBAL_RESET_CMD_CORE;
+
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
+		vfe_reg_set(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(wm),
+			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT);
+	else
+		vfe_reg_clr(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(wm),
+			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT);
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
+		reg |= ((wpl + 1) / 2 - 1) << 16;
+
+		writel_relaxed(reg, vfe->base +
+			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
+
+		wpl = vfe_word_per_line(pix->pixelformat, bytesperline);
+
+		reg = 0x3;
+		reg |= (height - 1) << 4;
+		reg |= wpl << 16;
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
+		writel_relaxed(0x10000009, vfe->base + VFE_0_BUS_CFG);
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
+	reg |= VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(id);
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
+		       vfe->base +
+		       VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(wm));
+}
+
+static void vfe_bus_disconnect_wm_from_rdi(struct vfe_device *vfe, u8 wm,
+					   enum vfe_line_id id)
+{
+	u32 reg;
+
+	reg = VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(id);
+	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(0), reg);
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
+		} else {
+			/* On current devices output->wm_num is always <= 2 */
+			break;
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
+	input = line->fmt[MSM_VFE_PAD_SINK].width;
+	output = line->compose.width;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_H_IMAGE_SIZE);
+
+	interp_reso = vfe_calc_interp_reso(input, output);
+	phase_mult = input * (1 << (13 + interp_reso)) / output;
+	reg = (interp_reso << 20) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_H_PHASE);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].height;
+	output = line->compose.height;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_V_IMAGE_SIZE);
+
+	interp_reso = vfe_calc_interp_reso(input, output);
+	phase_mult = input * (1 << (13 + interp_reso)) / output;
+	reg = (interp_reso << 20) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_V_PHASE);
+
+	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_CBCR_CFG);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].width;
+	output = line->compose.width / 2;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE);
+
+	interp_reso = vfe_calc_interp_reso(input, output);
+	phase_mult = input * (1 << (13 + interp_reso)) / output;
+	reg = (interp_reso << 20) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_PHASE);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].height;
+	output = line->compose.height;
+	if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV21)
+		output = line->compose.height / 2;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE);
+
+	interp_reso = vfe_calc_interp_reso(input, output);
+	phase_mult = input * (1 << (13 + interp_reso)) / output;
+	reg = (interp_reso << 20) | phase_mult;
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
+static void vfe_set_cgc_override(struct vfe_device *vfe, u8 wm, u8 enable)
+{
+	u32 val = VFE_0_CGC_OVERRIDE_1_IMAGE_Mx_CGC_OVERRIDE(wm);
+
+	if (enable)
+		vfe_reg_set(vfe, VFE_0_CGC_OVERRIDE_1, val);
+	else
+		vfe_reg_clr(vfe, VFE_0_CGC_OVERRIDE_1, val);
+
+	wmb();
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
+	writel_relaxed(val, vfe->base + VFE_0_CORE_CFG);
+
+	val = line->fmt[MSM_VFE_PAD_SINK].width * 2;
+	val |= line->fmt[MSM_VFE_PAD_SINK].height << 16;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_FRAME_CFG);
+
+	val = line->fmt[MSM_VFE_PAD_SINK].width * 2 - 1;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_WINDOW_WIDTH_CFG);
+
+	val = line->fmt[MSM_VFE_PAD_SINK].height - 1;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_WINDOW_HEIGHT_CFG);
+
+	val = 0xffffffff;
+	writel_relaxed(val, vfe->base + VFE_0_CAMIF_SUBSAMPLE_CFG_0);
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
+	u32 val = VFE_0_MODULE_CFG_DEMUX |
+		  VFE_0_MODULE_CFG_CHROMA_UPSAMPLE |
+		  VFE_0_MODULE_CFG_SCALE_ENC |
+		  VFE_0_MODULE_CFG_CROP_ENC;
+
+	if (enable)
+		writel_relaxed(val, vfe->base + VFE_0_MODULE_CFG);
+	else
+		writel_relaxed(0x0, vfe->base + VFE_0_MODULE_CFG);
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
+const struct vfe_hw_ops vfe_ops_4_1 = {
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
index 4afbef8..45a88c0 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -11,7 +11,6 @@
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
-#include <linux/iopoll.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -33,194 +32,6 @@
 #define to_vfe(ptr_line)	\
 	container_of(vfe_line_array(ptr_line), struct vfe_device, line)
 
-#define VFE_0_HW_VERSION		0x000
-
-#define VFE_0_GLOBAL_RESET_CMD		0x00c
-#define VFE_0_GLOBAL_RESET_CMD_CORE	(1 << 0)
-#define VFE_0_GLOBAL_RESET_CMD_CAMIF	(1 << 1)
-#define VFE_0_GLOBAL_RESET_CMD_BUS	(1 << 2)
-#define VFE_0_GLOBAL_RESET_CMD_BUS_BDG	(1 << 3)
-#define VFE_0_GLOBAL_RESET_CMD_REGISTER	(1 << 4)
-#define VFE_0_GLOBAL_RESET_CMD_TIMER	(1 << 5)
-#define VFE_0_GLOBAL_RESET_CMD_PM	(1 << 6)
-#define VFE_0_GLOBAL_RESET_CMD_BUS_MISR	(1 << 7)
-#define VFE_0_GLOBAL_RESET_CMD_TESTGEN	(1 << 8)
-
-#define VFE_0_MODULE_CFG		0x018
-#define VFE_0_MODULE_CFG_DEMUX			(1 << 2)
-#define VFE_0_MODULE_CFG_CHROMA_UPSAMPLE	(1 << 3)
-#define VFE_0_MODULE_CFG_SCALE_ENC		(1 << 23)
-#define VFE_0_MODULE_CFG_CROP_ENC		(1 << 27)
-
-#define VFE_0_CORE_CFG			0x01c
-#define VFE_0_CORE_CFG_PIXEL_PATTERN_YCBYCR	0x4
-#define VFE_0_CORE_CFG_PIXEL_PATTERN_YCRYCB	0x5
-#define VFE_0_CORE_CFG_PIXEL_PATTERN_CBYCRY	0x6
-#define VFE_0_CORE_CFG_PIXEL_PATTERN_CRYCBY	0x7
-
-#define VFE_0_IRQ_CMD			0x024
-#define VFE_0_IRQ_CMD_GLOBAL_CLEAR	(1 << 0)
-
-#define VFE_0_IRQ_MASK_0		0x028
-#define VFE_0_IRQ_MASK_0_CAMIF_SOF			(1 << 0)
-#define VFE_0_IRQ_MASK_0_CAMIF_EOF			(1 << 1)
-#define VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n)		(1 << ((n) + 5))
-#define VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(n)		\
-	((n) == VFE_LINE_PIX ? (1 << 4) : VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n))
-#define VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(n)	(1 << ((n) + 8))
-#define VFE_0_IRQ_MASK_0_IMAGE_COMPOSITE_DONE_n(n)	(1 << ((n) + 25))
-#define VFE_0_IRQ_MASK_0_RESET_ACK			(1 << 31)
-#define VFE_0_IRQ_MASK_1		0x02c
-#define VFE_0_IRQ_MASK_1_CAMIF_ERROR			(1 << 0)
-#define VFE_0_IRQ_MASK_1_VIOLATION			(1 << 7)
-#define VFE_0_IRQ_MASK_1_BUS_BDG_HALT_ACK		(1 << 8)
-#define VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(n)	(1 << ((n) + 9))
-#define VFE_0_IRQ_MASK_1_RDIn_SOF(n)			(1 << ((n) + 29))
-
-#define VFE_0_IRQ_CLEAR_0		0x030
-#define VFE_0_IRQ_CLEAR_1		0x034
-
-#define VFE_0_IRQ_STATUS_0		0x038
-#define VFE_0_IRQ_STATUS_0_CAMIF_SOF			(1 << 0)
-#define VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n)		(1 << ((n) + 5))
-#define VFE_0_IRQ_STATUS_0_line_n_REG_UPDATE(n)		\
-	((n) == VFE_LINE_PIX ? (1 << 4) : VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n))
-#define VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG(n)	(1 << ((n) + 8))
-#define VFE_0_IRQ_STATUS_0_IMAGE_COMPOSITE_DONE_n(n)	(1 << ((n) + 25))
-#define VFE_0_IRQ_STATUS_0_RESET_ACK			(1 << 31)
-#define VFE_0_IRQ_STATUS_1		0x03c
-#define VFE_0_IRQ_STATUS_1_VIOLATION			(1 << 7)
-#define VFE_0_IRQ_STATUS_1_BUS_BDG_HALT_ACK		(1 << 8)
-#define VFE_0_IRQ_STATUS_1_RDIn_SOF(n)			(1 << ((n) + 29))
-
-#define VFE_0_IRQ_COMPOSITE_MASK_0	0x40
-#define VFE_0_VIOLATION_STATUS		0x48
-
-#define VFE_0_BUS_CMD			0x4c
-#define VFE_0_BUS_CMD_Mx_RLD_CMD(x)	(1 << (x))
-
-#define VFE_0_BUS_CFG			0x050
-
-#define VFE_0_BUS_XBAR_CFG_x(x)		(0x58 + 0x4 * ((x) / 2))
-#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN			(1 << 1)
-#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA	(0x3 << 4)
-#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT		8
-#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA		0
-#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0	5
-#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1	6
-#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2	7
-
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(n)		(0x06c + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_WR_PATH_SHIFT	0
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT	1
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_PING_ADDR(n)	(0x070 + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_PONG_ADDR(n)	(0x074 + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(n)		(0x078 + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_SHIFT	2
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_MASK	(0x1F << 2)
-
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG(n)		(0x07c + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG_OFFSET_SHIFT	16
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(n)	(0x080 + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(n)	(0x084 + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_FRAMEDROP_PATTERN(n)	\
-							(0x088 + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(n)	\
-							(0x08c + 0x24 * (n))
-#define VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN_DEF	0xffffffff
-
-#define VFE_0_BUS_PING_PONG_STATUS	0x268
-
-#define VFE_0_BUS_BDG_CMD		0x2c0
-#define VFE_0_BUS_BDG_CMD_HALT_REQ	1
-
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
-#define VFE_0_RDI_CFG_x_RDI_STREAM_SEL_SHIFT	28
-#define VFE_0_RDI_CFG_x_RDI_STREAM_SEL_MASK	(0xf << 28)
-#define VFE_0_RDI_CFG_x_RDI_M0_SEL_SHIFT	4
-#define VFE_0_RDI_CFG_x_RDI_M0_SEL_MASK		(0xf << 4)
-#define VFE_0_RDI_CFG_x_RDI_EN_BIT		(1 << 2)
-#define VFE_0_RDI_CFG_x_MIPI_EN_BITS		0x3
-#define VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(r)	(1 << (16 + (r)))
-
-#define VFE_0_CAMIF_CMD				0x2f4
-#define VFE_0_CAMIF_CMD_DISABLE_FRAME_BOUNDARY	0
-#define VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY	1
-#define VFE_0_CAMIF_CMD_NO_CHANGE		3
-#define VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS	(1 << 2)
-#define VFE_0_CAMIF_CFG				0x2f8
-#define VFE_0_CAMIF_CFG_VFE_OUTPUT_EN		(1 << 6)
-#define VFE_0_CAMIF_FRAME_CFG			0x300
-#define VFE_0_CAMIF_WINDOW_WIDTH_CFG		0x304
-#define VFE_0_CAMIF_WINDOW_HEIGHT_CFG		0x308
-#define VFE_0_CAMIF_SUBSAMPLE_CFG_0		0x30c
-#define VFE_0_CAMIF_IRQ_SUBSAMPLE_PATTERN	0x314
-#define VFE_0_CAMIF_STATUS			0x31c
-#define VFE_0_CAMIF_STATUS_HALT			(1 << 31)
-
-#define VFE_0_REG_UPDATE			0x378
-#define VFE_0_REG_UPDATE_RDIn(n)		(1 << (1 + (n)))
-#define VFE_0_REG_UPDATE_line_n(n)		\
-			((n) == VFE_LINE_PIX ? 1 : VFE_0_REG_UPDATE_RDIn(n))
-
-#define VFE_0_DEMUX_CFG				0x424
-#define VFE_0_DEMUX_CFG_PERIOD			0x3
-#define VFE_0_DEMUX_GAIN_0			0x428
-#define VFE_0_DEMUX_GAIN_0_CH0_EVEN		(0x80 << 0)
-#define VFE_0_DEMUX_GAIN_0_CH0_ODD		(0x80 << 16)
-#define VFE_0_DEMUX_GAIN_1			0x42c
-#define VFE_0_DEMUX_GAIN_1_CH1			(0x80 << 0)
-#define VFE_0_DEMUX_GAIN_1_CH2			(0x80 << 16)
-#define VFE_0_DEMUX_EVEN_CFG			0x438
-#define VFE_0_DEMUX_EVEN_CFG_PATTERN_YUYV	0x9cac
-#define VFE_0_DEMUX_EVEN_CFG_PATTERN_YVYU	0xac9c
-#define VFE_0_DEMUX_EVEN_CFG_PATTERN_UYVY	0xc9ca
-#define VFE_0_DEMUX_EVEN_CFG_PATTERN_VYUY	0xcac9
-#define VFE_0_DEMUX_ODD_CFG			0x43c
-#define VFE_0_DEMUX_ODD_CFG_PATTERN_YUYV	0x9cac
-#define VFE_0_DEMUX_ODD_CFG_PATTERN_YVYU	0xac9c
-#define VFE_0_DEMUX_ODD_CFG_PATTERN_UYVY	0xc9ca
-#define VFE_0_DEMUX_ODD_CFG_PATTERN_VYUY	0xcac9
-
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
-#define VFE_0_CLAMP_ENC_MAX_CFG_CH0		(0xff << 0)
-#define VFE_0_CLAMP_ENC_MAX_CFG_CH1		(0xff << 8)
-#define VFE_0_CLAMP_ENC_MAX_CFG_CH2		(0xff << 16)
-#define VFE_0_CLAMP_ENC_MIN_CFG			0x878
-#define VFE_0_CLAMP_ENC_MIN_CFG_CH0		(0x0 << 0)
-#define VFE_0_CLAMP_ENC_MIN_CFG_CH1		(0x0 << 8)
-#define VFE_0_CLAMP_ENC_MIN_CFG_CH2		(0x0 << 16)
-
-#define VFE_0_CGC_OVERRIDE_1			0x974
-#define VFE_0_CGC_OVERRIDE_1_IMAGE_Mx_CGC_OVERRIDE(x)	(1 << (x))
-
 /* VFE reset timeout */
 #define VFE_RESET_TIMEOUT_MS 50
 /* VFE halt timeout */
@@ -232,11 +43,10 @@
 
 #define VFE_NEXT_SOF_MS 500
 
-#define CAMIF_TIMEOUT_SLEEP_US 1000
-#define CAMIF_TIMEOUT_ALL_US 1000000
-
 #define SCALER_RATIO_MAX 16
 
+extern struct vfe_hw_ops vfe_ops_4_1;
+
 static const struct {
 	u32 code;
 	u8 bpp;
@@ -326,541 +136,6 @@ static u8 vfe_get_bpp(u32 code)
 	return vfe_formats[0].bpp;
 }
 
-static inline void vfe_reg_clr(struct vfe_device *vfe, u32 reg, u32 clr_bits)
-{
-	u32 bits = readl_relaxed(vfe->base + reg);
-
-	writel_relaxed(bits & ~clr_bits, vfe->base + reg);
-}
-
-static inline void vfe_reg_set(struct vfe_device *vfe, u32 reg, u32 set_bits)
-{
-	u32 bits = readl_relaxed(vfe->base + reg);
-
-	writel_relaxed(bits | set_bits, vfe->base + reg);
-}
-
-static void vfe_global_reset(struct vfe_device *vfe)
-{
-	u32 reset_bits = VFE_0_GLOBAL_RESET_CMD_TESTGEN		|
-			 VFE_0_GLOBAL_RESET_CMD_BUS_MISR	|
-			 VFE_0_GLOBAL_RESET_CMD_PM		|
-			 VFE_0_GLOBAL_RESET_CMD_TIMER		|
-			 VFE_0_GLOBAL_RESET_CMD_REGISTER	|
-			 VFE_0_GLOBAL_RESET_CMD_BUS_BDG		|
-			 VFE_0_GLOBAL_RESET_CMD_BUS		|
-			 VFE_0_GLOBAL_RESET_CMD_CAMIF		|
-			 VFE_0_GLOBAL_RESET_CMD_CORE;
-
-	writel_relaxed(reset_bits, vfe->base + VFE_0_GLOBAL_RESET_CMD);
-}
-
-static void vfe_wm_enable(struct vfe_device *vfe, u8 wm, u8 enable)
-{
-	if (enable)
-		vfe_reg_set(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(wm),
-			    1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_WR_PATH_SHIFT);
-	else
-		vfe_reg_clr(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(wm),
-			    1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_WR_PATH_SHIFT);
-}
-
-static void vfe_wm_frame_based(struct vfe_device *vfe, u8 wm, u8 enable)
-{
-	if (enable)
-		vfe_reg_set(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(wm),
-			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT);
-	else
-		vfe_reg_clr(vfe, VFE_0_BUS_IMAGE_MASTER_n_WR_CFG(wm),
-			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT);
-}
-
-#define CALC_WORD(width, M, N) (((width) * (M) + (N) - 1) / (N))
-
-static int vfe_word_per_line(uint32_t format, uint32_t pixel_per_line)
-{
-	int val = 0;
-
-	switch (format) {
-	case V4L2_PIX_FMT_NV12:
-	case V4L2_PIX_FMT_NV21:
-	case V4L2_PIX_FMT_NV16:
-	case V4L2_PIX_FMT_NV61:
-		val = CALC_WORD(pixel_per_line, 1, 8);
-		break;
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_VYUY:
-		val = CALC_WORD(pixel_per_line, 2, 8);
-		break;
-	}
-
-	return val;
-}
-
-static void vfe_get_wm_sizes(struct v4l2_pix_format_mplane *pix, u8 plane,
-			     u16 *width, u16 *height, u16 *bytesperline)
-{
-	switch (pix->pixelformat) {
-	case V4L2_PIX_FMT_NV12:
-	case V4L2_PIX_FMT_NV21:
-		*width = pix->width;
-		*height = pix->height;
-		*bytesperline = pix->plane_fmt[0].bytesperline;
-		if (plane == 1)
-			*height /= 2;
-		break;
-	case V4L2_PIX_FMT_NV16:
-	case V4L2_PIX_FMT_NV61:
-		*width = pix->width;
-		*height = pix->height;
-		*bytesperline = pix->plane_fmt[0].bytesperline;
-		break;
-	}
-}
-
-static void vfe_wm_line_based(struct vfe_device *vfe, u32 wm,
-			      struct v4l2_pix_format_mplane *pix,
-			      u8 plane, u32 enable)
-{
-	u32 reg;
-
-	if (enable) {
-		u16 width = 0, height = 0, bytesperline = 0, wpl;
-
-		vfe_get_wm_sizes(pix, plane, &width, &height, &bytesperline);
-
-		wpl = vfe_word_per_line(pix->pixelformat, width);
-
-		reg = height - 1;
-		reg |= ((wpl + 1) / 2 - 1) << 16;
-
-		writel_relaxed(reg, vfe->base +
-			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
-
-		wpl = vfe_word_per_line(pix->pixelformat, bytesperline);
-
-		reg = 0x3;
-		reg |= (height - 1) << 4;
-		reg |= wpl << 16;
-
-		writel_relaxed(reg, vfe->base +
-			       VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(wm));
-	} else {
-		writel_relaxed(0, vfe->base +
-			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
-		writel_relaxed(0, vfe->base +
-			       VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(wm));
-	}
-}
-
-static void vfe_wm_set_framedrop_period(struct vfe_device *vfe, u8 wm, u8 per)
-{
-	u32 reg;
-
-	reg = readl_relaxed(vfe->base +
-			    VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(wm));
-
-	reg &= ~(VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_MASK);
-
-	reg |= (per << VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_SHIFT)
-		& VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG_FRM_DROP_PER_MASK;
-
-	writel_relaxed(reg,
-		       vfe->base + VFE_0_BUS_IMAGE_MASTER_n_WR_ADDR_CFG(wm));
-}
-
-static void vfe_wm_set_framedrop_pattern(struct vfe_device *vfe, u8 wm,
-					 u32 pattern)
-{
-	writel_relaxed(pattern,
-	       vfe->base + VFE_0_BUS_IMAGE_MASTER_n_WR_FRAMEDROP_PATTERN(wm));
-}
-
-static void vfe_wm_set_ub_cfg(struct vfe_device *vfe, u8 wm, u16 offset,
-			      u16 depth)
-{
-	u32 reg;
-
-	reg = (offset << VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG_OFFSET_SHIFT) |
-		depth;
-	writel_relaxed(reg, vfe->base + VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG(wm));
-}
-
-static void vfe_bus_reload_wm(struct vfe_device *vfe, u8 wm)
-{
-	wmb();
-	writel_relaxed(VFE_0_BUS_CMD_Mx_RLD_CMD(wm), vfe->base + VFE_0_BUS_CMD);
-	wmb();
-}
-
-static void vfe_wm_set_ping_addr(struct vfe_device *vfe, u8 wm, u32 addr)
-{
-	writel_relaxed(addr,
-		       vfe->base + VFE_0_BUS_IMAGE_MASTER_n_WR_PING_ADDR(wm));
-}
-
-static void vfe_wm_set_pong_addr(struct vfe_device *vfe, u8 wm, u32 addr)
-{
-	writel_relaxed(addr,
-		       vfe->base + VFE_0_BUS_IMAGE_MASTER_n_WR_PONG_ADDR(wm));
-}
-
-static int vfe_wm_get_ping_pong_status(struct vfe_device *vfe, u8 wm)
-{
-	u32 reg;
-
-	reg = readl_relaxed(vfe->base + VFE_0_BUS_PING_PONG_STATUS);
-
-	return (reg >> wm) & 0x1;
-}
-
-static void vfe_bus_enable_wr_if(struct vfe_device *vfe, u8 enable)
-{
-	if (enable)
-		writel_relaxed(0x10000009, vfe->base + VFE_0_BUS_CFG);
-	else
-		writel_relaxed(0, vfe->base + VFE_0_BUS_CFG);
-}
-
-static void vfe_bus_connect_wm_to_rdi(struct vfe_device *vfe, u8 wm,
-				      enum vfe_line_id id)
-{
-	u32 reg;
-
-	reg = VFE_0_RDI_CFG_x_MIPI_EN_BITS;
-	reg |= VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(id);
-	vfe_reg_set(vfe, VFE_0_RDI_CFG_x(0), reg);
-
-	reg = VFE_0_RDI_CFG_x_RDI_EN_BIT;
-	reg |= ((3 * id) << VFE_0_RDI_CFG_x_RDI_STREAM_SEL_SHIFT) &
-		VFE_0_RDI_CFG_x_RDI_STREAM_SEL_MASK;
-	vfe_reg_set(vfe, VFE_0_RDI_CFG_x(id), reg);
-
-	switch (id) {
-	case VFE_LINE_RDI0:
-	default:
-		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0 <<
-		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
-		break;
-	case VFE_LINE_RDI1:
-		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1 <<
-		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
-		break;
-	case VFE_LINE_RDI2:
-		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2 <<
-		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
-		break;
-	}
-
-	if (wm % 2 == 1)
-		reg <<= 16;
-
-	vfe_reg_set(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
-}
-
-static void vfe_wm_set_subsample(struct vfe_device *vfe, u8 wm)
-{
-	writel_relaxed(VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN_DEF,
-	       vfe->base +
-	       VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(wm));
-}
-
-static void vfe_bus_disconnect_wm_from_rdi(struct vfe_device *vfe, u8 wm,
-					   enum vfe_line_id id)
-{
-	u32 reg;
-
-	reg = VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(id);
-	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(0), reg);
-
-	reg = VFE_0_RDI_CFG_x_RDI_EN_BIT;
-	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(id), reg);
-
-	switch (id) {
-	case VFE_LINE_RDI0:
-	default:
-		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0 <<
-		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
-		break;
-	case VFE_LINE_RDI1:
-		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1 <<
-		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
-		break;
-	case VFE_LINE_RDI2:
-		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2 <<
-		      VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
-		break;
-	}
-
-	if (wm % 2 == 1)
-		reg <<= 16;
-
-	vfe_reg_clr(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
-}
-
-static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
-			     u8 enable)
-{
-	struct vfe_line *line = container_of(output, struct vfe_line, output);
-	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
-	u32 reg;
-	unsigned int i;
-
-	for (i = 0; i < output->wm_num; i++) {
-		if (i == 0) {
-			reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA <<
-				VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
-		} else if (i == 1) {
-			reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
-			if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
-				reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
-		} else {
-			/* On current devices output->wm_num is always <= 2 */
-			break;
-		}
-
-		if (output->wm_idx[i] % 2 == 1)
-			reg <<= 16;
-
-		if (enable)
-			vfe_reg_set(vfe,
-				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[i]),
-				    reg);
-		else
-			vfe_reg_clr(vfe,
-				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[i]),
-				    reg);
-	}
-}
-
-static void vfe_set_rdi_cid(struct vfe_device *vfe, enum vfe_line_id id, u8 cid)
-{
-	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(id),
-		    VFE_0_RDI_CFG_x_RDI_M0_SEL_MASK);
-
-	vfe_reg_set(vfe, VFE_0_RDI_CFG_x(id),
-		    cid << VFE_0_RDI_CFG_x_RDI_M0_SEL_SHIFT);
-}
-
-static void vfe_reg_update(struct vfe_device *vfe, enum vfe_line_id line_id)
-{
-	vfe->reg_update |= VFE_0_REG_UPDATE_line_n(line_id);
-	wmb();
-	writel_relaxed(vfe->reg_update, vfe->base + VFE_0_REG_UPDATE);
-	wmb();
-}
-
-static void vfe_enable_irq_wm_line(struct vfe_device *vfe, u8 wm,
-				   enum vfe_line_id line_id, u8 enable)
-{
-	u32 irq_en0 = VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(wm) |
-		      VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(line_id);
-	u32 irq_en1 = VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(wm) |
-		      VFE_0_IRQ_MASK_1_RDIn_SOF(line_id);
-
-	if (enable) {
-		vfe_reg_set(vfe, VFE_0_IRQ_MASK_0, irq_en0);
-		vfe_reg_set(vfe, VFE_0_IRQ_MASK_1, irq_en1);
-	} else {
-		vfe_reg_clr(vfe, VFE_0_IRQ_MASK_0, irq_en0);
-		vfe_reg_clr(vfe, VFE_0_IRQ_MASK_1, irq_en1);
-	}
-}
-
-static void vfe_enable_irq_pix_line(struct vfe_device *vfe, u8 comp,
-				    enum vfe_line_id line_id, u8 enable)
-{
-	struct vfe_output *output = &vfe->line[line_id].output;
-	unsigned int i;
-	u32 irq_en0;
-	u32 irq_en1;
-	u32 comp_mask = 0;
-
-	irq_en0 = VFE_0_IRQ_MASK_0_CAMIF_SOF;
-	irq_en0 |= VFE_0_IRQ_MASK_0_CAMIF_EOF;
-	irq_en0 |= VFE_0_IRQ_MASK_0_IMAGE_COMPOSITE_DONE_n(comp);
-	irq_en0 |= VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(line_id);
-	irq_en1 = VFE_0_IRQ_MASK_1_CAMIF_ERROR;
-	for (i = 0; i < output->wm_num; i++) {
-		irq_en1 |= VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(
-							output->wm_idx[i]);
-		comp_mask |= (1 << output->wm_idx[i]) << comp * 8;
-	}
-
-	if (enable) {
-		vfe_reg_set(vfe, VFE_0_IRQ_MASK_0, irq_en0);
-		vfe_reg_set(vfe, VFE_0_IRQ_MASK_1, irq_en1);
-		vfe_reg_set(vfe, VFE_0_IRQ_COMPOSITE_MASK_0, comp_mask);
-	} else {
-		vfe_reg_clr(vfe, VFE_0_IRQ_MASK_0, irq_en0);
-		vfe_reg_clr(vfe, VFE_0_IRQ_MASK_1, irq_en1);
-		vfe_reg_clr(vfe, VFE_0_IRQ_COMPOSITE_MASK_0, comp_mask);
-	}
-}
-
-static void vfe_enable_irq_common(struct vfe_device *vfe)
-{
-	u32 irq_en0 = VFE_0_IRQ_MASK_0_RESET_ACK;
-	u32 irq_en1 = VFE_0_IRQ_MASK_1_VIOLATION |
-		      VFE_0_IRQ_MASK_1_BUS_BDG_HALT_ACK;
-
-	vfe_reg_set(vfe, VFE_0_IRQ_MASK_0, irq_en0);
-	vfe_reg_set(vfe, VFE_0_IRQ_MASK_1, irq_en1);
-}
-
-static void vfe_set_demux_cfg(struct vfe_device *vfe, struct vfe_line *line)
-{
-	u32 val, even_cfg, odd_cfg;
-
-	writel_relaxed(VFE_0_DEMUX_CFG_PERIOD, vfe->base + VFE_0_DEMUX_CFG);
-
-	val = VFE_0_DEMUX_GAIN_0_CH0_EVEN | VFE_0_DEMUX_GAIN_0_CH0_ODD;
-	writel_relaxed(val, vfe->base + VFE_0_DEMUX_GAIN_0);
-
-	val = VFE_0_DEMUX_GAIN_1_CH1 | VFE_0_DEMUX_GAIN_1_CH2;
-	writel_relaxed(val, vfe->base + VFE_0_DEMUX_GAIN_1);
-
-	switch (line->fmt[MSM_VFE_PAD_SINK].code) {
-	case MEDIA_BUS_FMT_YUYV8_2X8:
-		even_cfg = VFE_0_DEMUX_EVEN_CFG_PATTERN_YUYV;
-		odd_cfg = VFE_0_DEMUX_ODD_CFG_PATTERN_YUYV;
-		break;
-	case MEDIA_BUS_FMT_YVYU8_2X8:
-		even_cfg = VFE_0_DEMUX_EVEN_CFG_PATTERN_YVYU;
-		odd_cfg = VFE_0_DEMUX_ODD_CFG_PATTERN_YVYU;
-		break;
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-	default:
-		even_cfg = VFE_0_DEMUX_EVEN_CFG_PATTERN_UYVY;
-		odd_cfg = VFE_0_DEMUX_ODD_CFG_PATTERN_UYVY;
-		break;
-	case MEDIA_BUS_FMT_VYUY8_2X8:
-		even_cfg = VFE_0_DEMUX_EVEN_CFG_PATTERN_VYUY;
-		odd_cfg = VFE_0_DEMUX_ODD_CFG_PATTERN_VYUY;
-		break;
-	}
-
-	writel_relaxed(even_cfg, vfe->base + VFE_0_DEMUX_EVEN_CFG);
-	writel_relaxed(odd_cfg, vfe->base + VFE_0_DEMUX_ODD_CFG);
-}
-
-static inline u8 vfe_calc_interp_reso(u16 input, u16 output)
-{
-	if (input / output >= 16)
-		return 0;
-
-	if (input / output >= 8)
-		return 1;
-
-	if (input / output >= 4)
-		return 2;
-
-	return 3;
-}
-
-static void vfe_set_scale_cfg(struct vfe_device *vfe, struct vfe_line *line)
-{
-	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
-	u32 reg;
-	u16 input, output;
-	u8 interp_reso;
-	u32 phase_mult;
-
-	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_Y_CFG);
-
-	input = line->fmt[MSM_VFE_PAD_SINK].width;
-	output = line->compose.width;
-	reg = (output << 16) | input;
-	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_H_IMAGE_SIZE);
-
-	interp_reso = vfe_calc_interp_reso(input, output);
-	phase_mult = input * (1 << (13 + interp_reso)) / output;
-	reg = (interp_reso << 20) | phase_mult;
-	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_H_PHASE);
-
-	input = line->fmt[MSM_VFE_PAD_SINK].height;
-	output = line->compose.height;
-	reg = (output << 16) | input;
-	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_V_IMAGE_SIZE);
-
-	interp_reso = vfe_calc_interp_reso(input, output);
-	phase_mult = input * (1 << (13 + interp_reso)) / output;
-	reg = (interp_reso << 20) | phase_mult;
-	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_V_PHASE);
-
-	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_CBCR_CFG);
-
-	input = line->fmt[MSM_VFE_PAD_SINK].width;
-	output = line->compose.width / 2;
-	reg = (output << 16) | input;
-	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE);
-
-	interp_reso = vfe_calc_interp_reso(input, output);
-	phase_mult = input * (1 << (13 + interp_reso)) / output;
-	reg = (interp_reso << 20) | phase_mult;
-	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_PHASE);
-
-	input = line->fmt[MSM_VFE_PAD_SINK].height;
-	output = line->compose.height;
-	if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV21)
-		output = line->compose.height / 2;
-	reg = (output << 16) | input;
-	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE);
-
-	interp_reso = vfe_calc_interp_reso(input, output);
-	phase_mult = input * (1 << (13 + interp_reso)) / output;
-	reg = (interp_reso << 20) | phase_mult;
-	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_PHASE);
-}
-
-static void vfe_set_crop_cfg(struct vfe_device *vfe, struct vfe_line *line)
-{
-	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
-	u32 reg;
-	u16 first, last;
-
-	first = line->crop.left;
-	last = line->crop.left + line->crop.width - 1;
-	reg = (first << 16) | last;
-	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_Y_WIDTH);
-
-	first = line->crop.top;
-	last = line->crop.top + line->crop.height - 1;
-	reg = (first << 16) | last;
-	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_Y_HEIGHT);
-
-	first = line->crop.left / 2;
-	last = line->crop.left / 2 + line->crop.width / 2 - 1;
-	reg = (first << 16) | last;
-	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_CBCR_WIDTH);
-
-	first = line->crop.top;
-	last = line->crop.top + line->crop.height - 1;
-	if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV21) {
-		first = line->crop.top / 2;
-		last = line->crop.top / 2 + line->crop.height / 2 - 1;
-	}
-	reg = (first << 16) | last;
-	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_CBCR_HEIGHT);
-}
-
-static void vfe_set_clamp_cfg(struct vfe_device *vfe)
-{
-	u32 val = VFE_0_CLAMP_ENC_MAX_CFG_CH0 |
-		VFE_0_CLAMP_ENC_MAX_CFG_CH1 |
-		VFE_0_CLAMP_ENC_MAX_CFG_CH2;
-
-	writel_relaxed(val, vfe->base + VFE_0_CLAMP_ENC_MAX_CFG);
-
-	val = VFE_0_CLAMP_ENC_MIN_CFG_CH0 |
-		VFE_0_CLAMP_ENC_MIN_CFG_CH1 |
-		VFE_0_CLAMP_ENC_MIN_CFG_CH2;
-
-	writel_relaxed(val, vfe->base + VFE_0_CLAMP_ENC_MIN_CFG);
-}
-
 /*
  * vfe_reset - Trigger reset on VFE module and wait to complete
  * @vfe: VFE device
@@ -873,7 +148,7 @@ static int vfe_reset(struct vfe_device *vfe)
 
 	reinit_completion(&vfe->reset_complete);
 
-	vfe_global_reset(vfe);
+	vfe->ops->global_reset(vfe);
 
 	time = wait_for_completion_timeout(&vfe->reset_complete,
 		msecs_to_jiffies(VFE_RESET_TIMEOUT_MS));
@@ -897,8 +172,7 @@ static int vfe_halt(struct vfe_device *vfe)
 
 	reinit_completion(&vfe->halt_complete);
 
-	writel_relaxed(VFE_0_BUS_BDG_CMD_HALT_REQ,
-		       vfe->base + VFE_0_BUS_BDG_CMD);
+	vfe->ops->halt_request(vfe);
 
 	time = wait_for_completion_timeout(&vfe->halt_complete,
 		msecs_to_jiffies(VFE_HALT_TIMEOUT_MS));
@@ -936,117 +210,6 @@ static void vfe_reset_output_maps(struct vfe_device *vfe)
 		vfe->wm_output_map[i] = VFE_LINE_NONE;
 }
 
-static void vfe_set_qos(struct vfe_device *vfe)
-{
-	u32 val = VFE_0_BUS_BDG_QOS_CFG_0_CFG;
-	u32 val7 = VFE_0_BUS_BDG_QOS_CFG_7_CFG;
-
-	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_0);
-	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_1);
-	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_2);
-	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_3);
-	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_4);
-	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_5);
-	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_6);
-	writel_relaxed(val7, vfe->base + VFE_0_BUS_BDG_QOS_CFG_7);
-}
-
-static void vfe_set_cgc_override(struct vfe_device *vfe, u8 wm, u8 enable)
-{
-	u32 val = VFE_0_CGC_OVERRIDE_1_IMAGE_Mx_CGC_OVERRIDE(wm);
-
-	if (enable)
-		vfe_reg_set(vfe, VFE_0_CGC_OVERRIDE_1, val);
-	else
-		vfe_reg_clr(vfe, VFE_0_CGC_OVERRIDE_1, val);
-
-	wmb();
-}
-
-static void vfe_set_module_cfg(struct vfe_device *vfe, u8 enable)
-{
-	u32 val = VFE_0_MODULE_CFG_DEMUX |
-		  VFE_0_MODULE_CFG_CHROMA_UPSAMPLE |
-		  VFE_0_MODULE_CFG_SCALE_ENC |
-		  VFE_0_MODULE_CFG_CROP_ENC;
-
-	if (enable)
-		writel_relaxed(val, vfe->base + VFE_0_MODULE_CFG);
-	else
-		writel_relaxed(0x0, vfe->base + VFE_0_MODULE_CFG);
-}
-
-static void vfe_set_camif_cfg(struct vfe_device *vfe, struct vfe_line *line)
-{
-	u32 val;
-
-	switch (line->fmt[MSM_VFE_PAD_SINK].code) {
-	case MEDIA_BUS_FMT_YUYV8_2X8:
-		val = VFE_0_CORE_CFG_PIXEL_PATTERN_YCBYCR;
-		break;
-	case MEDIA_BUS_FMT_YVYU8_2X8:
-		val = VFE_0_CORE_CFG_PIXEL_PATTERN_YCRYCB;
-		break;
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-	default:
-		val = VFE_0_CORE_CFG_PIXEL_PATTERN_CBYCRY;
-		break;
-	case MEDIA_BUS_FMT_VYUY8_2X8:
-		val = VFE_0_CORE_CFG_PIXEL_PATTERN_CRYCBY;
-		break;
-	}
-
-	writel_relaxed(val, vfe->base + VFE_0_CORE_CFG);
-
-	val = line->fmt[MSM_VFE_PAD_SINK].width * 2;
-	val |= line->fmt[MSM_VFE_PAD_SINK].height << 16;
-	writel_relaxed(val, vfe->base + VFE_0_CAMIF_FRAME_CFG);
-
-	val = line->fmt[MSM_VFE_PAD_SINK].width * 2 - 1;
-	writel_relaxed(val, vfe->base + VFE_0_CAMIF_WINDOW_WIDTH_CFG);
-
-	val = line->fmt[MSM_VFE_PAD_SINK].height - 1;
-	writel_relaxed(val, vfe->base + VFE_0_CAMIF_WINDOW_HEIGHT_CFG);
-
-	val = 0xffffffff;
-	writel_relaxed(val, vfe->base + VFE_0_CAMIF_SUBSAMPLE_CFG_0);
-
-	val = 0xffffffff;
-	writel_relaxed(val, vfe->base + VFE_0_CAMIF_IRQ_SUBSAMPLE_PATTERN);
-
-	val = VFE_0_RDI_CFG_x_MIPI_EN_BITS;
-	vfe_reg_set(vfe, VFE_0_RDI_CFG_x(0), val);
-
-	val = VFE_0_CAMIF_CFG_VFE_OUTPUT_EN;
-	writel_relaxed(val, vfe->base + VFE_0_CAMIF_CFG);
-}
-
-static void vfe_set_camif_cmd(struct vfe_device *vfe, u32 cmd)
-{
-	writel_relaxed(VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS |
-		       VFE_0_CAMIF_CMD_NO_CHANGE,
-		       vfe->base + VFE_0_CAMIF_CMD);
-	wmb();
-
-	writel_relaxed(cmd, vfe->base + VFE_0_CAMIF_CMD);
-}
-
-static int vfe_camif_wait_for_stop(struct vfe_device *vfe)
-{
-	u32 val;
-	int ret;
-
-	ret = readl_poll_timeout(vfe->base + VFE_0_CAMIF_STATUS,
-				 val,
-				 (val & VFE_0_CAMIF_STATUS_HALT),
-				 CAMIF_TIMEOUT_SLEEP_US,
-				 CAMIF_TIMEOUT_ALL_US);
-	if (ret < 0)
-		dev_err(vfe->camss->dev, "%s: camif stop timeout\n", __func__);
-
-	return ret;
-}
-
 static void vfe_output_init_addrs(struct vfe_device *vfe,
 				  struct vfe_output *output, u8 sync)
 {
@@ -1067,10 +230,10 @@ static void vfe_output_init_addrs(struct vfe_device *vfe,
 		else
 			pong_addr = ping_addr;
 
-		vfe_wm_set_ping_addr(vfe, output->wm_idx[i], ping_addr);
-		vfe_wm_set_pong_addr(vfe, output->wm_idx[i], pong_addr);
+		vfe->ops->wm_set_ping_addr(vfe, output->wm_idx[i], ping_addr);
+		vfe->ops->wm_set_pong_addr(vfe, output->wm_idx[i], pong_addr);
 		if (sync)
-			vfe_bus_reload_wm(vfe, output->wm_idx[i]);
+			vfe->ops->bus_reload_wm(vfe, output->wm_idx[i]);
 	}
 }
 
@@ -1086,9 +249,9 @@ static void vfe_output_update_ping_addr(struct vfe_device *vfe,
 		else
 			addr = 0;
 
-		vfe_wm_set_ping_addr(vfe, output->wm_idx[i], addr);
+		vfe->ops->wm_set_ping_addr(vfe, output->wm_idx[i], addr);
 		if (sync)
-			vfe_bus_reload_wm(vfe, output->wm_idx[i]);
+			vfe->ops->bus_reload_wm(vfe, output->wm_idx[i]);
 	}
 }
 
@@ -1104,9 +267,9 @@ static void vfe_output_update_pong_addr(struct vfe_device *vfe,
 		else
 			addr = 0;
 
-		vfe_wm_set_pong_addr(vfe, output->wm_idx[i], addr);
+		vfe->ops->wm_set_pong_addr(vfe, output->wm_idx[i], addr);
 		if (sync)
-			vfe_bus_reload_wm(vfe, output->wm_idx[i]);
+			vfe->ops->bus_reload_wm(vfe, output->wm_idx[i]);
 	}
 
 }
@@ -1150,12 +313,13 @@ static void vfe_output_frame_drop(struct vfe_device *vfe,
 	drop_period = VFE_FRAME_DROP_VAL + output->drop_update_idx;
 
 	for (i = 0; i < output->wm_num; i++) {
-		vfe_wm_set_framedrop_period(vfe, output->wm_idx[i],
-					    drop_period);
-		vfe_wm_set_framedrop_pattern(vfe, output->wm_idx[i],
-					     drop_pattern);
+		vfe->ops->wm_set_framedrop_period(vfe, output->wm_idx[i],
+						  drop_period);
+		vfe->ops->wm_set_framedrop_pattern(vfe, output->wm_idx[i],
+						   drop_pattern);
 	}
-	vfe_reg_update(vfe, container_of(output, struct vfe_line, output)->id);
+	vfe->ops->reg_update(vfe,
+			     container_of(output, struct vfe_line, output)->id);
 }
 
 static struct camss_buffer *vfe_buf_get_pending(struct vfe_output *output)
@@ -1352,24 +516,18 @@ static int vfe_enable_output(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
+	struct vfe_hw_ops *ops = vfe->ops;
 	unsigned long flags;
 	unsigned int i;
 	u16 ub_size;
 
-	switch (vfe->id) {
-	case 0:
-		ub_size = MSM_VFE_VFE0_UB_SIZE_RDI;
-		break;
-	case 1:
-		ub_size = MSM_VFE_VFE1_UB_SIZE_RDI;
-		break;
-	default:
+	ub_size = ops->get_ub_size(vfe->id);
+	if (!ub_size)
 		return -EINVAL;
-	}
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
-	vfe->reg_update &= ~VFE_0_REG_UPDATE_line_n(line->id);
+	ops->reg_update_clear(vfe, line->id);
 
 	if (output->state != VFE_OUTPUT_RESERVED) {
 		dev_err(vfe->camss->dev, "Output is not in reserved state %d\n",
@@ -1414,42 +572,42 @@ static int vfe_enable_output(struct vfe_line *line)
 	vfe_output_init_addrs(vfe, output, 0);
 
 	if (line->id != VFE_LINE_PIX) {
-		vfe_set_cgc_override(vfe, output->wm_idx[0], 1);
-		vfe_enable_irq_wm_line(vfe, output->wm_idx[0], line->id, 1);
-		vfe_bus_connect_wm_to_rdi(vfe, output->wm_idx[0], line->id);
-		vfe_wm_set_subsample(vfe, output->wm_idx[0]);
-		vfe_set_rdi_cid(vfe, line->id, 0);
-		vfe_wm_set_ub_cfg(vfe, output->wm_idx[0],
-				  (ub_size + 1) * output->wm_idx[0], ub_size);
-		vfe_wm_frame_based(vfe, output->wm_idx[0], 1);
-		vfe_wm_enable(vfe, output->wm_idx[0], 1);
-		vfe_bus_reload_wm(vfe, output->wm_idx[0]);
+		ops->set_cgc_override(vfe, output->wm_idx[0], 1);
+		ops->enable_irq_wm_line(vfe, output->wm_idx[0], line->id, 1);
+		ops->bus_connect_wm_to_rdi(vfe, output->wm_idx[0], line->id);
+		ops->wm_set_subsample(vfe, output->wm_idx[0]);
+		ops->set_rdi_cid(vfe, line->id, 0);
+		ops->wm_set_ub_cfg(vfe, output->wm_idx[0],
+				   (ub_size + 1) * output->wm_idx[0], ub_size);
+		ops->wm_frame_based(vfe, output->wm_idx[0], 1);
+		ops->wm_enable(vfe, output->wm_idx[0], 1);
+		ops->bus_reload_wm(vfe, output->wm_idx[0]);
 	} else {
 		ub_size /= output->wm_num;
 		for (i = 0; i < output->wm_num; i++) {
-			vfe_set_cgc_override(vfe, output->wm_idx[i], 1);
-			vfe_wm_set_subsample(vfe, output->wm_idx[i]);
-			vfe_wm_set_ub_cfg(vfe, output->wm_idx[i],
-					  (ub_size + 1) * output->wm_idx[i],
-					  ub_size);
-			vfe_wm_line_based(vfe, output->wm_idx[i],
+			ops->set_cgc_override(vfe, output->wm_idx[i], 1);
+			ops->wm_set_subsample(vfe, output->wm_idx[i]);
+			ops->wm_set_ub_cfg(vfe, output->wm_idx[i],
+					   (ub_size + 1) * output->wm_idx[i],
+					   ub_size);
+			ops->wm_line_based(vfe, output->wm_idx[i],
 					&line->video_out.active_fmt.fmt.pix_mp,
 					i, 1);
-			vfe_wm_enable(vfe, output->wm_idx[i], 1);
-			vfe_bus_reload_wm(vfe, output->wm_idx[i]);
+			ops->wm_enable(vfe, output->wm_idx[i], 1);
+			ops->bus_reload_wm(vfe, output->wm_idx[i]);
 		}
-		vfe_enable_irq_pix_line(vfe, 0, line->id, 1);
-		vfe_set_module_cfg(vfe, 1);
-		vfe_set_camif_cfg(vfe, line);
-		vfe_set_xbar_cfg(vfe, output, 1);
-		vfe_set_demux_cfg(vfe, line);
-		vfe_set_scale_cfg(vfe, line);
-		vfe_set_crop_cfg(vfe, line);
-		vfe_set_clamp_cfg(vfe);
-		vfe_set_camif_cmd(vfe, VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY);
+		ops->enable_irq_pix_line(vfe, 0, line->id, 1);
+		ops->set_module_cfg(vfe, 1);
+		ops->set_camif_cfg(vfe, line);
+		ops->set_xbar_cfg(vfe, output, 1);
+		ops->set_demux_cfg(vfe, line);
+		ops->set_scale_cfg(vfe, line);
+		ops->set_crop_cfg(vfe, line);
+		ops->set_clamp_cfg(vfe);
+		ops->set_camif_cmd(vfe, 1);
 	}
 
-	vfe_reg_update(vfe, line->id);
+	ops->reg_update(vfe, line->id);
 
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
 
@@ -1460,6 +618,7 @@ static int vfe_disable_output(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
+	struct vfe_hw_ops *ops = vfe->ops;
 	unsigned long flags;
 	unsigned long time;
 	unsigned int i;
@@ -1476,9 +635,9 @@ static int vfe_disable_output(struct vfe_line *line)
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 	for (i = 0; i < output->wm_num; i++)
-		vfe_wm_enable(vfe, output->wm_idx[i], 0);
+		ops->wm_enable(vfe, output->wm_idx[i], 0);
 
-	vfe_reg_update(vfe, line->id);
+	ops->reg_update(vfe, line->id);
 	output->wait_reg_update = 1;
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
 
@@ -1490,25 +649,26 @@ static int vfe_disable_output(struct vfe_line *line)
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
 	if (line->id != VFE_LINE_PIX) {
-		vfe_wm_frame_based(vfe, output->wm_idx[0], 0);
-		vfe_bus_disconnect_wm_from_rdi(vfe, output->wm_idx[0], line->id);
-		vfe_enable_irq_wm_line(vfe, output->wm_idx[0], line->id, 0);
-		vfe_set_cgc_override(vfe, output->wm_idx[0], 0);
+		ops->wm_frame_based(vfe, output->wm_idx[0], 0);
+		ops->bus_disconnect_wm_from_rdi(vfe, output->wm_idx[0],
+						line->id);
+		ops->enable_irq_wm_line(vfe, output->wm_idx[0], line->id, 0);
+		ops->set_cgc_override(vfe, output->wm_idx[0], 0);
 		spin_unlock_irqrestore(&vfe->output_lock, flags);
 	} else {
 		for (i = 0; i < output->wm_num; i++) {
-			vfe_wm_line_based(vfe, output->wm_idx[i], NULL, i, 0);
-			vfe_set_cgc_override(vfe, output->wm_idx[i], 0);
+			ops->wm_line_based(vfe, output->wm_idx[i], NULL, i, 0);
+			ops->set_cgc_override(vfe, output->wm_idx[i], 0);
 		}
 
-		vfe_enable_irq_pix_line(vfe, 0, line->id, 0);
-		vfe_set_module_cfg(vfe, 0);
-		vfe_set_xbar_cfg(vfe, output, 0);
+		ops->enable_irq_pix_line(vfe, 0, line->id, 0);
+		ops->set_module_cfg(vfe, 0);
+		ops->set_xbar_cfg(vfe, output, 0);
 
-		vfe_set_camif_cmd(vfe, VFE_0_CAMIF_CMD_DISABLE_FRAME_BOUNDARY);
+		ops->set_camif_cmd(vfe, 0);
 		spin_unlock_irqrestore(&vfe->output_lock, flags);
 
-		vfe_camif_wait_for_stop(vfe);
+		ops->camif_wait_for_stop(vfe, vfe->camss->dev);
 	}
 
 	return 0;
@@ -1528,11 +688,11 @@ static int vfe_enable(struct vfe_line *line)
 	mutex_lock(&vfe->stream_lock);
 
 	if (!vfe->stream_count) {
-		vfe_enable_irq_common(vfe);
+		vfe->ops->enable_irq_common(vfe);
 
-		vfe_bus_enable_wr_if(vfe, 1);
+		vfe->ops->bus_enable_wr_if(vfe, 1);
 
-		vfe_set_qos(vfe);
+		vfe->ops->set_qos(vfe);
 	}
 
 	vfe->stream_count++;
@@ -1559,7 +719,7 @@ static int vfe_enable(struct vfe_line *line)
 	mutex_lock(&vfe->stream_lock);
 
 	if (vfe->stream_count == 1)
-		vfe_bus_enable_wr_if(vfe, 0);
+		vfe->ops->bus_enable_wr_if(vfe, 0);
 
 	vfe->stream_count--;
 
@@ -1585,7 +745,7 @@ static int vfe_disable(struct vfe_line *line)
 	mutex_lock(&vfe->stream_lock);
 
 	if (vfe->stream_count == 1)
-		vfe_bus_enable_wr_if(vfe, 0);
+		vfe->ops->bus_enable_wr_if(vfe, 0);
 
 	vfe->stream_count--;
 
@@ -1624,7 +784,7 @@ static void vfe_isr_reg_update(struct vfe_device *vfe, enum vfe_line_id line_id)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
-	vfe->reg_update &= ~VFE_0_REG_UPDATE_line_n(line_id);
+	vfe->ops->reg_update_clear(vfe, line_id);
 
 	output = &vfe->line[line_id].output;
 
@@ -1694,7 +854,7 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
 	u64 ts = ktime_get_ns();
 	unsigned int i;
 
-	active_index = vfe_wm_get_ping_pong_status(vfe, wm);
+	active_index = vfe->ops->wm_get_ping_pong_status(vfe, wm);
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
@@ -1736,12 +896,12 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
 
 	if (active_index)
 		for (i = 0; i < output->wm_num; i++)
-			vfe_wm_set_ping_addr(vfe, output->wm_idx[i],
-					     new_addr[i]);
+			vfe->ops->wm_set_ping_addr(vfe, output->wm_idx[i],
+						   new_addr[i]);
 	else
 		for (i = 0; i < output->wm_num; i++)
-			vfe_wm_set_pong_addr(vfe, output->wm_idx[i],
-					     new_addr[i]);
+			vfe->ops->wm_set_pong_addr(vfe, output->wm_idx[i],
+						   new_addr[i]);
 
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
 
@@ -1772,67 +932,15 @@ static void vfe_isr_comp_done(struct vfe_device *vfe, u8 comp)
 		}
 }
 
-/*
- * vfe_isr - ISPIF module interrupt handler
- * @irq: Interrupt line
- * @dev: VFE device
- *
- * Return IRQ_HANDLED on success
- */
-static irqreturn_t vfe_isr(int irq, void *dev)
+static inline void vfe_isr_reset_ack(struct vfe_device *vfe)
 {
-	struct vfe_device *vfe = dev;
-	u32 value0, value1;
-	u32 violation;
-	int i, j;
-
-	value0 = readl_relaxed(vfe->base + VFE_0_IRQ_STATUS_0);
-	value1 = readl_relaxed(vfe->base + VFE_0_IRQ_STATUS_1);
-
-	writel_relaxed(value0, vfe->base + VFE_0_IRQ_CLEAR_0);
-	writel_relaxed(value1, vfe->base + VFE_0_IRQ_CLEAR_1);
-
-	wmb();
-	writel_relaxed(VFE_0_IRQ_CMD_GLOBAL_CLEAR, vfe->base + VFE_0_IRQ_CMD);
-
-	if (value0 & VFE_0_IRQ_STATUS_0_RESET_ACK)
-		complete(&vfe->reset_complete);
-
-	if (value1 & VFE_0_IRQ_STATUS_1_VIOLATION) {
-		violation = readl_relaxed(vfe->base + VFE_0_VIOLATION_STATUS);
-		dev_err_ratelimited(vfe->camss->dev,
-				    "VFE: violation = 0x%08x\n", violation);
-	}
-
-	if (value1 & VFE_0_IRQ_STATUS_1_BUS_BDG_HALT_ACK) {
-		complete(&vfe->halt_complete);
-		writel_relaxed(0x0, vfe->base + VFE_0_BUS_BDG_CMD);
-	}
-
-	for (i = VFE_LINE_RDI0; i <= VFE_LINE_PIX; i++)
-		if (value0 & VFE_0_IRQ_STATUS_0_line_n_REG_UPDATE(i))
-			vfe_isr_reg_update(vfe, i);
-
-	if (value0 & VFE_0_IRQ_STATUS_0_CAMIF_SOF)
-		vfe_isr_sof(vfe, VFE_LINE_PIX);
-
-	for (i = VFE_LINE_RDI0; i <= VFE_LINE_RDI2; i++)
-		if (value1 & VFE_0_IRQ_STATUS_1_RDIn_SOF(i))
-			vfe_isr_sof(vfe, i);
-
-	for (i = 0; i < MSM_VFE_COMPOSITE_IRQ_NUM; i++)
-		if (value0 & VFE_0_IRQ_STATUS_0_IMAGE_COMPOSITE_DONE_n(i)) {
-			vfe_isr_comp_done(vfe, i);
-			for (j = 0; j < ARRAY_SIZE(vfe->wm_output_map); j++)
-				if (vfe->wm_output_map[j] == VFE_LINE_PIX)
-					value0 &= ~VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(j);
-		}
-
-	for (i = 0; i < MSM_VFE_IMAGE_MASTERS_NUM; i++)
-		if (value0 & VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG(i))
-			vfe_isr_wm_done(vfe, i);
+	complete(&vfe->reset_complete);
+}
 
-	return IRQ_HANDLED;
+static inline void vfe_isr_halt_ack(struct vfe_device *vfe)
+{
+	complete(&vfe->halt_complete);
+	vfe->ops->halt_clear(vfe);
 }
 
 /*
@@ -2138,15 +1246,11 @@ static int vfe_set_power(struct v4l2_subdev *sd, int on)
 	int ret;
 
 	if (on) {
-		u32 hw_version;
-
 		ret = vfe_get(vfe);
 		if (ret < 0)
 			return ret;
 
-		hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
-		dev_dbg(vfe->camss->dev,
-			"VFE HW Version = 0x%08x\n", hw_version);
+		vfe->ops->hw_version_read(vfe, vfe->camss->dev);
 	} else {
 		vfe_put(vfe);
 	}
@@ -2740,6 +1844,18 @@ int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
 	int i, j;
 	int ret;
 
+	vfe->isr_ops.reset_ack = vfe_isr_reset_ack;
+	vfe->isr_ops.halt_ack = vfe_isr_halt_ack;
+	vfe->isr_ops.reg_update = vfe_isr_reg_update;
+	vfe->isr_ops.sof = vfe_isr_sof;
+	vfe->isr_ops.comp_done = vfe_isr_comp_done;
+	vfe->isr_ops.wm_done = vfe_isr_wm_done;
+
+	if (camss->version == CAMSS_8x16)
+		vfe->ops = &vfe_ops_4_1;
+	else
+		return -EINVAL;
+
 	/* Memory */
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, res->reg[0]);
@@ -2761,7 +1877,7 @@ int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
 	vfe->irq = r->start;
 	snprintf(vfe->irq_name, sizeof(vfe->irq_name), "%s_%s%d",
 		 dev_name(dev), MSM_VFE_NAME, vfe->id);
-	ret = devm_request_irq(dev, vfe->irq, vfe_isr,
+	ret = devm_request_irq(dev, vfe->irq, vfe->ops->isr,
 			       IRQF_TRIGGER_RISING, vfe->irq_name, vfe);
 	if (ret < 0) {
 		dev_err(dev, "request_irq failed: %d\n", ret);
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
index 17d431e..872ae1e 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss/camss-vfe.h
@@ -26,11 +26,6 @@
 #define MSM_VFE_IMAGE_MASTERS_NUM 7
 #define MSM_VFE_COMPOSITE_IRQ_NUM 4
 
-#define MSM_VFE_VFE0_UB_SIZE 1023
-#define MSM_VFE_VFE0_UB_SIZE_RDI (MSM_VFE_VFE0_UB_SIZE / 3)
-#define MSM_VFE_VFE1_UB_SIZE 1535
-#define MSM_VFE_VFE1_UB_SIZE_RDI (MSM_VFE_VFE1_UB_SIZE / 3)
-
 enum vfe_output_state {
 	VFE_OUTPUT_OFF,
 	VFE_OUTPUT_RESERVED,
@@ -78,6 +73,70 @@ struct vfe_line {
 	struct vfe_output output;
 };
 
+struct vfe_device;
+
+struct vfe_hw_ops {
+	void (*hw_version_read)(struct vfe_device *vfe, struct device *dev);
+	u16 (*get_ub_size)(u8 vfe_id);
+	void (*global_reset)(struct vfe_device *vfe);
+	void (*halt_request)(struct vfe_device *vfe);
+	void (*halt_clear)(struct vfe_device *vfe);
+	void (*wm_enable)(struct vfe_device *vfe, u8 wm, u8 enable);
+	void (*wm_frame_based)(struct vfe_device *vfe, u8 wm, u8 enable);
+	void (*wm_line_based)(struct vfe_device *vfe, u32 wm,
+			      struct v4l2_pix_format_mplane *pix,
+			      u8 plane, u32 enable);
+	void (*wm_set_framedrop_period)(struct vfe_device *vfe, u8 wm, u8 per);
+	void (*wm_set_framedrop_pattern)(struct vfe_device *vfe, u8 wm,
+					 u32 pattern);
+	void (*wm_set_ub_cfg)(struct vfe_device *vfe, u8 wm, u16 offset,
+			      u16 depth);
+	void (*bus_reload_wm)(struct vfe_device *vfe, u8 wm);
+	void (*wm_set_ping_addr)(struct vfe_device *vfe, u8 wm, u32 addr);
+	void (*wm_set_pong_addr)(struct vfe_device *vfe, u8 wm, u32 addr);
+	int (*wm_get_ping_pong_status)(struct vfe_device *vfe, u8 wm);
+	void (*bus_enable_wr_if)(struct vfe_device *vfe, u8 enable);
+	void (*bus_connect_wm_to_rdi)(struct vfe_device *vfe, u8 wm,
+				      enum vfe_line_id id);
+	void (*wm_set_subsample)(struct vfe_device *vfe, u8 wm);
+	void (*bus_disconnect_wm_from_rdi)(struct vfe_device *vfe, u8 wm,
+					   enum vfe_line_id id);
+	void (*set_xbar_cfg)(struct vfe_device *vfe, struct vfe_output *output,
+			     u8 enable);
+	void (*set_rdi_cid)(struct vfe_device *vfe, enum vfe_line_id id,
+			    u8 cid);
+	void (*reg_update)(struct vfe_device *vfe, enum vfe_line_id line_id);
+	void (*reg_update_clear)(struct vfe_device *vfe,
+				 enum vfe_line_id line_id);
+	void (*enable_irq_wm_line)(struct vfe_device *vfe, u8 wm,
+				   enum vfe_line_id line_id, u8 enable);
+	void (*enable_irq_pix_line)(struct vfe_device *vfe, u8 comp,
+				    enum vfe_line_id line_id, u8 enable);
+	void (*enable_irq_common)(struct vfe_device *vfe);
+	void (*set_demux_cfg)(struct vfe_device *vfe, struct vfe_line *line);
+	void (*set_scale_cfg)(struct vfe_device *vfe, struct vfe_line *line);
+	void (*set_crop_cfg)(struct vfe_device *vfe, struct vfe_line *line);
+	void (*set_clamp_cfg)(struct vfe_device *vfe);
+	void (*set_qos)(struct vfe_device *vfe);
+	void (*set_cgc_override)(struct vfe_device *vfe, u8 wm, u8 enable);
+	void (*set_camif_cfg)(struct vfe_device *vfe, struct vfe_line *line);
+	void (*set_camif_cmd)(struct vfe_device *vfe, u8 enable);
+	void (*set_module_cfg)(struct vfe_device *vfe, u8 enable);
+	int (*camif_wait_for_stop)(struct vfe_device *vfe, struct device *dev);
+	void (*isr_read)(struct vfe_device *vfe, u32 *value0, u32 *value1);
+	void (*violation_read)(struct vfe_device *vfe);
+	irqreturn_t (*isr)(int irq, void *dev);
+};
+
+struct vfe_isr_ops {
+	void (*reset_ack)(struct vfe_device *vfe);
+	void (*halt_ack)(struct vfe_device *vfe);
+	void (*reg_update)(struct vfe_device *vfe, enum vfe_line_id line_id);
+	void (*sof)(struct vfe_device *vfe, enum vfe_line_id line_id);
+	void (*comp_done)(struct vfe_device *vfe, u8 comp);
+	void (*wm_done)(struct vfe_device *vfe, u8 wm);
+};
+
 struct vfe_device {
 	struct camss *camss;
 	u8 id;
@@ -97,6 +156,8 @@ struct vfe_device {
 	struct vfe_line line[MSM_VFE_LINE_NUM];
 	u32 reg_update;
 	u8 was_streaming;
+	struct vfe_hw_ops *ops;
+	struct vfe_isr_ops isr_ops;
 };
 
 struct resources;
-- 
2.7.4
