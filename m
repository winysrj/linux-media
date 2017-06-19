Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:56109 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752283AbdFSO4v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 10:56:51 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 11/19] camss: vfe: Format conversion support using PIX interface
Date: Mon, 19 Jun 2017 17:48:31 +0300
Message-Id: <1497883719-12410-12-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use VFE PIX input interface and do format conversion in VFE.

Supported input format is UYVY (single plane YUV 4:2:2) and
its different sample order variations.

Supported output formats are:
- NV12/NV21 (two plane YUV 4:2:0)
- NV16/NV61 (two plane YUV 4:2:2)

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss-8x16/ispif.c |   2 +
 drivers/media/platform/qcom/camss-8x16/vfe.c   | 672 ++++++++++++++++++++++---
 drivers/media/platform/qcom/camss-8x16/vfe.h   |  13 +-
 drivers/media/platform/qcom/camss-8x16/video.c | 331 +++++++++---
 drivers/media/platform/qcom/camss-8x16/video.h |   8 +-
 5 files changed, 874 insertions(+), 152 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/ispif.c b/drivers/media/platform/qcom/camss-8x16/ispif.c
index c72d06c..4f3d8c3 100644
--- a/drivers/media/platform/qcom/camss-8x16/ispif.c
+++ b/drivers/media/platform/qcom/camss-8x16/ispif.c
@@ -968,6 +968,8 @@ static enum ispif_intf ispif_get_intf(enum vfe_line_id line_id)
 		return RDI1;
 	case (VFE_LINE_RDI2):
 		return RDI2;
+	case (VFE_LINE_PIX):
+		return PIX0;
 	default:
 		return RDI0;
 	}
diff --git a/drivers/media/platform/qcom/camss-8x16/vfe.c b/drivers/media/platform/qcom/camss-8x16/vfe.c
index 00d4e5c..0964e23 100644
--- a/drivers/media/platform/qcom/camss-8x16/vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/vfe.c
@@ -19,6 +19,7 @@
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
+#include <linux/iopoll.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -52,29 +53,53 @@
 #define VFE_0_GLOBAL_RESET_CMD_BUS_MISR	(1 << 7)
 #define VFE_0_GLOBAL_RESET_CMD_TESTGEN	(1 << 8)
 
+#define VFE_0_MODULE_CFG		0x018
+#define VFE_0_MODULE_CFG_DEMUX			(1 << 2)
+#define VFE_0_MODULE_CFG_CHROMA_UPSAMPLE	(1 << 3)
+#define VFE_0_MODULE_CFG_SCALE_ENC		(1 << 23)
+
+#define VFE_0_CORE_CFG			0x01c
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_YCBYCR	0x4
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_YCRYCB	0x5
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_CBYCRY	0x6
+#define VFE_0_CORE_CFG_PIXEL_PATTERN_CRYCBY	0x7
+
 #define VFE_0_IRQ_CMD			0x024
 #define VFE_0_IRQ_CMD_GLOBAL_CLEAR	(1 << 0)
 
 #define VFE_0_IRQ_MASK_0		0x028
+#define VFE_0_IRQ_MASK_0_CAMIF_SOF			(1 << 0)
+#define VFE_0_IRQ_MASK_0_CAMIF_EOF			(1 << 1)
 #define VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n)		(1 << ((n) + 5))
+#define VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(n)		\
+	((n) == VFE_LINE_PIX ? (1 << 4) : VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n))
 #define VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(n)	(1 << ((n) + 8))
+#define VFE_0_IRQ_MASK_0_IMAGE_COMPOSITE_DONE_n(n)	(1 << ((n) + 25))
 #define VFE_0_IRQ_MASK_0_RESET_ACK			(1 << 31)
 #define VFE_0_IRQ_MASK_1		0x02c
+#define VFE_0_IRQ_MASK_1_CAMIF_ERROR			(1 << 0)
 #define VFE_0_IRQ_MASK_1_VIOLATION			(1 << 7)
 #define VFE_0_IRQ_MASK_1_BUS_BDG_HALT_ACK		(1 << 8)
 #define VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(n)	(1 << ((n) + 9))
+#define VFE_0_IRQ_MASK_1_RDIn_SOF(n)			(1 << ((n) + 29))
 
 #define VFE_0_IRQ_CLEAR_0		0x030
 #define VFE_0_IRQ_CLEAR_1		0x034
 
 #define VFE_0_IRQ_STATUS_0		0x038
+#define VFE_0_IRQ_STATUS_0_CAMIF_SOF			(1 << 0)
 #define VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n)		(1 << ((n) + 5))
+#define VFE_0_IRQ_STATUS_0_line_n_REG_UPDATE(n)		\
+	((n) == VFE_LINE_PIX ? (1 << 4) : VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n))
 #define VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG(n)	(1 << ((n) + 8))
+#define VFE_0_IRQ_STATUS_0_IMAGE_COMPOSITE_DONE_n(n)	(1 << ((n) + 25))
 #define VFE_0_IRQ_STATUS_0_RESET_ACK			(1 << 31)
 #define VFE_0_IRQ_STATUS_1		0x03c
 #define VFE_0_IRQ_STATUS_1_VIOLATION			(1 << 7)
 #define VFE_0_IRQ_STATUS_1_BUS_BDG_HALT_ACK		(1 << 8)
+#define VFE_0_IRQ_STATUS_1_RDIn_SOF(n)			(1 << ((n) + 29))
 
+#define VFE_0_IRQ_COMPOSITE_MASK_0	0x40
 #define VFE_0_VIOLATION_STATUS		0x48
 
 #define VFE_0_BUS_CMD			0x4c
@@ -83,7 +108,10 @@
 #define VFE_0_BUS_CFG			0x050
 
 #define VFE_0_BUS_XBAR_CFG_x(x)		(0x58 + 0x4 * ((x) / 2))
+#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN			(1 << 1)
+#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA	(0x3 << 4)
 #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT		8
+#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA		0
 #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0	5
 #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1	6
 #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2	7
@@ -99,6 +127,8 @@
 
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG(n)		(0x07c + 0x24 * (n))
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG_OFFSET_SHIFT	16
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(n)	(0x080 + 0x24 * (n))
+#define VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(n)	(0x084 + 0x24 * (n))
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_FRAMEDROP_PATTERN(n)	\
 							(0x088 + 0x24 * (n))
 #define VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(n)	\
@@ -128,8 +158,41 @@
 #define VFE_0_RDI_CFG_x_MIPI_EN_BITS		0x3
 #define VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(r)	(1 << (16 + (r)))
 
+#define VFE_0_CAMIF_CMD				0x2f4
+#define VFE_0_CAMIF_CMD_DISABLE_FRAME_BOUNDARY	0
+#define VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY	1
+#define VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS	(1 << 2)
+#define VFE_0_CAMIF_CFG				0x2f8
+#define VFE_0_CAMIF_CFG_VFE_OUTPUT_EN		(1 << 6)
+#define VFE_0_CAMIF_FRAME_CFG			0x300
+#define VFE_0_CAMIF_WINDOW_WIDTH_CFG		0x304
+#define VFE_0_CAMIF_WINDOW_HEIGHT_CFG		0x308
+#define VFE_0_CAMIF_SUBSAMPLE_CFG_0		0x30c
+#define VFE_0_CAMIF_IRQ_SUBSAMPLE_PATTERN	0x314
+#define VFE_0_CAMIF_STATUS			0x31c
+#define VFE_0_CAMIF_STATUS_HALT			(1 << 31)
+
 #define VFE_0_REG_UPDATE			0x378
 #define VFE_0_REG_UPDATE_RDIn(n)		(1 << (1 + (n)))
+#define VFE_0_REG_UPDATE_line_n(n)		\
+			((n) == VFE_LINE_PIX ? 1 : VFE_0_REG_UPDATE_RDIn(n))
+
+#define VFE_0_DEMUX_CFG				0x424
+#define VFE_0_DEMUX_GAIN_0			0x428
+#define VFE_0_DEMUX_GAIN_1			0x42c
+#define VFE_0_DEMUX_EVEN_CFG			0x438
+#define VFE_0_DEMUX_ODD_CFG			0x43c
+
+#define VFE_0_SCALE_ENC_CBCR_CFG		0x778
+#define VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE	0x77c
+#define VFE_0_SCALE_ENC_CBCR_H_PHASE		0x780
+#define VFE_0_SCALE_ENC_CBCR_H_PAD		0x78c
+#define VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE	0x790
+#define VFE_0_SCALE_ENC_CBCR_V_PHASE		0x794
+#define VFE_0_SCALE_ENC_CBCR_V_PAD		0x7a0
+
+#define VFE_0_CLAMP_ENC_MAX_CFG			0x874
+#define VFE_0_CLAMP_ENC_MIN_CFG			0x878
 
 #define VFE_0_CGC_OVERRIDE_1			0x974
 #define VFE_0_CGC_OVERRIDE_1_IMAGE_Mx_CGC_OVERRIDE(x)	(1 << (x))
@@ -143,6 +206,11 @@
 /* Frame drop value. NOTE: VAL + UPDATES should not exceed 31 */
 #define VFE_FRAME_DROP_VAL 20
 
+#define VFE_NEXT_SOF_MS 500
+
+#define CAMIF_TIMEOUT_SLEEP_US 1000
+#define CAMIF_TIMEOUT_ALL_US 1000000
+
 static const u32 vfe_formats[] = {
 	MEDIA_BUS_FMT_UYVY8_2X8,
 	MEDIA_BUS_FMT_VYUY8_2X8,
@@ -211,6 +279,32 @@ static void vfe_wm_frame_based(struct vfe_device *vfe, u8 wm, u8 enable)
 			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT);
 }
 
+static void vfe_wm_line_based(struct vfe_device *vfe, u32 wm,
+			      u16 width, u16 height, u32 enable)
+{
+	u32 reg;
+
+	if (enable) {
+		reg = height - 1;
+		reg |= (width / 16 - 1) << 16;
+
+		writel_relaxed(reg, vfe->base +
+			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
+
+		reg = 0x3;
+		reg |= (height - 1) << 4;
+		reg |= (width / 8) << 16;
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
 static void vfe_wm_set_framedrop_period(struct vfe_device *vfe, u8 wm, u8 per)
 {
 	u32 reg;
@@ -314,7 +408,10 @@ static void vfe_bus_connect_wm_to_rdi(struct vfe_device *vfe, u8 wm,
 		reg <<= 16;
 
 	vfe_reg_set(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
+}
 
+static void vfe_wm_set_subsample(struct vfe_device *vfe, u8 wm)
+{
 	writel_relaxed(VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN_DEF,
 	       vfe->base +
 	       VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(wm));
@@ -353,6 +450,38 @@ static void vfe_bus_disconnect_wm_from_rdi(struct vfe_device *vfe, u8 wm,
 	vfe_reg_clr(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
 }
 
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
 static void vfe_set_rdi_cid(struct vfe_device *vfe, enum vfe_line_id id, u8 cid)
 {
 	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(id),
@@ -364,7 +493,7 @@ static void vfe_set_rdi_cid(struct vfe_device *vfe, enum vfe_line_id id, u8 cid)
 
 static void vfe_reg_update(struct vfe_device *vfe, enum vfe_line_id line_id)
 {
-	vfe->reg_update |= VFE_0_REG_UPDATE_RDIn(line_id);
+	vfe->reg_update |= VFE_0_REG_UPDATE_line_n(line_id);
 	wmb();
 	writel_relaxed(vfe->reg_update, vfe->base + VFE_0_REG_UPDATE);
 	wmb();
@@ -374,8 +503,9 @@ static void vfe_enable_irq_wm_line(struct vfe_device *vfe, u8 wm,
 				   enum vfe_line_id line_id, u8 enable)
 {
 	u32 irq_en0 = VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(wm) |
-		      VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(line_id);
-	u32 irq_en1 = VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(wm);
+		      VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(line_id);
+	u32 irq_en1 = VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(wm) |
+		      VFE_0_IRQ_MASK_1_RDIn_SOF(line_id);
 
 	if (enable) {
 		vfe_reg_set(vfe, VFE_0_IRQ_MASK_0, irq_en0);
@@ -386,6 +516,36 @@ static void vfe_enable_irq_wm_line(struct vfe_device *vfe, u8 wm,
 	}
 }
 
+static void vfe_enable_irq_pix_line(struct vfe_device *vfe, u8 comp,
+				    enum vfe_line_id line_id, u8 enable) {
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
 static void vfe_enable_irq_common(struct vfe_device *vfe)
 {
 	u32 irq_en0 = VFE_0_IRQ_MASK_0_RESET_ACK;
@@ -396,6 +556,83 @@ static void vfe_enable_irq_common(struct vfe_device *vfe)
 	vfe_reg_set(vfe, VFE_0_IRQ_MASK_1, irq_en1);
 }
 
+static void vfe_set_demux_cfg(struct vfe_device *vfe, struct vfe_line *line)
+{
+	u32 even_cfg, odd_cfg;
+
+	writel_relaxed(0x3, vfe->base + VFE_0_DEMUX_CFG);
+	writel_relaxed(0x800080, vfe->base + VFE_0_DEMUX_GAIN_0);
+	writel_relaxed(0x800080, vfe->base + VFE_0_DEMUX_GAIN_1);
+
+	switch (line->fmt[MSM_VFE_PAD_SINK].code) {
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+		even_cfg = 0x9cac;
+		odd_cfg = 0x9cac;
+		break;
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+		even_cfg = 0xac9c;
+		odd_cfg = 0xac9c;
+		break;
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	default:
+		even_cfg = 0xc9ca;
+		odd_cfg = 0xc9ca;
+		break;
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+		even_cfg = 0xcac9;
+		odd_cfg = 0xcac9;
+		break;
+	}
+
+	writel_relaxed(even_cfg, vfe->base + VFE_0_DEMUX_EVEN_CFG);
+	writel_relaxed(odd_cfg, vfe->base + VFE_0_DEMUX_ODD_CFG);
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
+	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_CBCR_CFG);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].width;
+	output = line->fmt[MSM_VFE_PAD_SRC].width / 2;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE);
+
+	interp_reso = 3;
+	phase_mult = input * (1 << (13 + interp_reso)) / output;
+	reg = (interp_reso << 20) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_PHASE);
+
+	reg = input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_PAD);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].height;
+	output = line->fmt[MSM_VFE_PAD_SRC].height;
+	if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV21)
+		output = line->fmt[MSM_VFE_PAD_SRC].height / 2;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE);
+
+	interp_reso = 3;
+	phase_mult = input * (1 << (13 + interp_reso)) / output;
+	reg = (interp_reso << 20) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_PHASE);
+
+	reg = input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_PAD);
+}
+
+static void vfe_set_clamp_cfg(struct vfe_device *vfe)
+{
+	writel_relaxed(0x00ffffff, vfe->base + VFE_0_CLAMP_ENC_MAX_CFG);
+	writel_relaxed(0x0, vfe->base + VFE_0_CLAMP_ENC_MIN_CFG);
+}
+
 /*
  * vfe_reset - Trigger reset on VFE module and wait to complete
  * @vfe: VFE device
@@ -456,6 +693,10 @@ static void vfe_init_outputs(struct vfe_device *vfe)
 		output->buf[0] = NULL;
 		output->buf[1] = NULL;
 		INIT_LIST_HEAD(&output->pending_bufs);
+
+		output->wm_num = 1;
+		if (vfe->line[i].id == VFE_LINE_PIX)
+			output->wm_num = 2;
 	}
 }
 
@@ -494,52 +735,148 @@ static void vfe_set_cgc_override(struct vfe_device *vfe, u8 wm, u8 enable)
 	wmb();
 }
 
+static void vfe_set_module_cfg(struct vfe_device *vfe, u8 enable)
+{
+	u32 val = VFE_0_MODULE_CFG_DEMUX |
+		  VFE_0_MODULE_CFG_CHROMA_UPSAMPLE |
+		  VFE_0_MODULE_CFG_SCALE_ENC;
+
+	if (enable)
+		writel_relaxed(val, vfe->base + VFE_0_MODULE_CFG);
+	else
+		writel_relaxed(0x0, vfe->base + VFE_0_MODULE_CFG);
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
+static void vfe_set_camif_cmd(struct vfe_device *vfe, u32 cmd)
+{
+	writel_relaxed(VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS,
+		       vfe->base + VFE_0_CAMIF_CMD);
+
+	writel_relaxed(cmd, vfe->base + VFE_0_CAMIF_CMD);
+}
+
+static int vfe_camif_wait_for_stop(struct vfe_device *vfe)
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
+		dev_err(to_device(vfe), "%s: camif stop timeout\n", __func__);
+
+	return ret;
+}
+
 static void vfe_output_init_addrs(struct vfe_device *vfe,
 				  struct vfe_output *output, u8 sync)
 {
-	u32 ping_addr = 0;
-	u32 pong_addr = 0;
+	u32 ping_addr;
+	u32 pong_addr;
+	unsigned int i;
 
 	output->active_buf = 0;
 
-	if (output->buf[0])
-		ping_addr = output->buf[0]->addr;
-
-	if (output->buf[1])
-		pong_addr = output->buf[1]->addr;
-	else
-		pong_addr = ping_addr;
+	for (i = 0; i < output->wm_num; i++) {
+		if (output->buf[0])
+			ping_addr = output->buf[0]->addr[i];
+		else
+			ping_addr = 0;
 
-	vfe_wm_set_ping_addr(vfe, output->wm_idx, ping_addr);
-	vfe_wm_set_pong_addr(vfe, output->wm_idx, pong_addr);
-	if (sync)
-		vfe_bus_reload_wm(vfe, output->wm_idx);
+		if (output->buf[1])
+			pong_addr = output->buf[1]->addr[i];
+		else
+			pong_addr = ping_addr;
+
+		vfe_wm_set_ping_addr(vfe, output->wm_idx[i], ping_addr);
+		vfe_wm_set_pong_addr(vfe, output->wm_idx[i], pong_addr);
+		if (sync)
+			vfe_bus_reload_wm(vfe, output->wm_idx[i]);
+	}
 }
 
 static void vfe_output_update_ping_addr(struct vfe_device *vfe,
 					struct vfe_output *output, u8 sync)
 {
-	u32 addr = 0;
+	u32 addr;
+	unsigned int i;
 
-	if (output->buf[0])
-		addr = output->buf[0]->addr;
+	for (i = 0; i < output->wm_num; i++) {
+		if (output->buf[0])
+			addr = output->buf[0]->addr[i];
+		else
+			addr = 0;
 
-	vfe_wm_set_ping_addr(vfe, output->wm_idx, addr);
-	if (sync)
-		vfe_bus_reload_wm(vfe, output->wm_idx);
+		vfe_wm_set_ping_addr(vfe, output->wm_idx[i], addr);
+		if (sync)
+			vfe_bus_reload_wm(vfe, output->wm_idx[i]);
+	}
 }
 
 static void vfe_output_update_pong_addr(struct vfe_device *vfe,
 					struct vfe_output *output, u8 sync)
 {
-	u32 addr = 0;
+	u32 addr;
+	unsigned int i;
 
-	if (output->buf[1])
-		addr = output->buf[1]->addr;
+	for (i = 0; i < output->wm_num; i++) {
+		if (output->buf[1])
+			addr = output->buf[1]->addr[i];
+		else
+			addr = 0;
 
-	vfe_wm_set_pong_addr(vfe, output->wm_idx, addr);
-	if (sync)
-		vfe_bus_reload_wm(vfe, output->wm_idx);
+		vfe_wm_set_pong_addr(vfe, output->wm_idx[i], addr);
+		if (sync)
+			vfe_bus_reload_wm(vfe, output->wm_idx[i]);
+	}
 
 }
 
@@ -574,14 +911,19 @@ static void vfe_output_frame_drop(struct vfe_device *vfe,
 				  u32 drop_pattern)
 {
 	u8 drop_period;
+	unsigned int i;
 
 	/* We need to toggle update period to be valid on next frame */
 	output->drop_update_idx++;
 	output->drop_update_idx %= VFE_FRAME_DROP_UPDATES;
 	drop_period = VFE_FRAME_DROP_VAL + output->drop_update_idx;
 
-	vfe_wm_set_framedrop_period(vfe, output->wm_idx, drop_period);
-	vfe_wm_set_framedrop_pattern(vfe, output->wm_idx, drop_pattern);
+	for (i = 0; i < output->wm_num; i++) {
+		vfe_wm_set_framedrop_period(vfe, output->wm_idx[i],
+					    drop_period);
+		vfe_wm_set_framedrop_pattern(vfe, output->wm_idx[i],
+					     drop_pattern);
+	}
 	vfe_reg_update(vfe, container_of(output, struct vfe_line, output)->id);
 
 }
@@ -719,6 +1061,7 @@ static int vfe_get_output(struct vfe_line *line)
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output;
 	unsigned long flags;
+	int i;
 	int wm_idx;
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
@@ -732,20 +1075,24 @@ static int vfe_get_output(struct vfe_line *line)
 
 	output->active_buf = 0;
 
-	/* We will use only one wm per output for now */
-	wm_idx = vfe_reserve_wm(vfe, line->id);
-	if (wm_idx < 0) {
-		dev_err(to_device(vfe), "Can not reserve wm\n");
-		goto error_get_wm;
+	for (i = 0; i < output->wm_num; i++) {
+		wm_idx = vfe_reserve_wm(vfe, line->id);
+		if (wm_idx < 0) {
+			dev_err(to_device(vfe), "Can not reserve wm\n");
+			goto error_get_wm;
+		}
+		output->wm_idx[i] = wm_idx;
 	}
+
 	output->drop_update_idx = 0;
-	output->wm_idx = wm_idx;
 
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
 
 	return 0;
 
 error_get_wm:
+	for (i--; i >= 0; i--)
+		vfe_release_wm(vfe, output->wm_idx[i]);
 	output->state = VFE_OUTPUT_OFF;
 error:
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
@@ -758,19 +1105,17 @@ static int vfe_put_output(struct vfe_line *line)
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
 	unsigned long flags;
-	int ret;
+	unsigned int i;
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
-	ret = vfe_release_wm(vfe, output->wm_idx);
-	if (ret < 0)
-		goto out;
+	for (i = 0; i < output->wm_num; i++)
+		vfe_release_wm(vfe, output->wm_idx[i]);
 
 	output->state = VFE_OUTPUT_OFF;
 
-out:
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
-	return ret;
+	return 0;
 }
 
 static int vfe_enable_output(struct vfe_line *line)
@@ -778,6 +1123,7 @@ static int vfe_enable_output(struct vfe_line *line)
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
 	unsigned long flags;
+	unsigned int i;
 	u16 ub_size;
 
 	switch (vfe->id) {
@@ -793,7 +1139,7 @@ static int vfe_enable_output(struct vfe_line *line)
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
-	vfe->reg_update &= ~VFE_0_REG_UPDATE_RDIn(line->id);
+	vfe->reg_update &= ~VFE_0_REG_UPDATE_line_n(line->id);
 
 	if (output->state != VFE_OUTPUT_RESERVED) {
 		dev_err(to_device(vfe), "Output is not in reserved state %d\n",
@@ -830,24 +1176,58 @@ static int vfe_enable_output(struct vfe_line *line)
 	}
 
 	output->sequence = 0;
+	output->wait_sof = 0;
+	output->wait_reg_update = 0;
+	reinit_completion(&output->sof);
+	reinit_completion(&output->reg_update);
 
 	vfe_output_init_addrs(vfe, output, 0);
 
-	vfe_set_cgc_override(vfe, output->wm_idx, 1);
-
-	vfe_enable_irq_wm_line(vfe, output->wm_idx, line->id, 1);
-
-	vfe_bus_connect_wm_to_rdi(vfe, output->wm_idx, line->id);
-
-	vfe_set_rdi_cid(vfe, line->id, 0);
-
-	vfe_wm_set_ub_cfg(vfe, output->wm_idx,
-			  (ub_size + 1) * output->wm_idx, ub_size);
-
-	vfe_wm_frame_based(vfe, output->wm_idx, 1);
-	vfe_wm_enable(vfe, output->wm_idx, 1);
+	if (line->id != VFE_LINE_PIX) {
+		vfe_set_cgc_override(vfe, output->wm_idx[0], 1);
+		vfe_enable_irq_wm_line(vfe, output->wm_idx[0], line->id, 1);
+		vfe_bus_connect_wm_to_rdi(vfe, output->wm_idx[0], line->id);
+		vfe_wm_set_subsample(vfe, output->wm_idx[0]);
+		vfe_set_rdi_cid(vfe, line->id, 0);
+		vfe_wm_set_ub_cfg(vfe, output->wm_idx[0],
+				  (ub_size + 1) * output->wm_idx[0], ub_size);
+		vfe_wm_frame_based(vfe, output->wm_idx[0], 1);
+		vfe_wm_enable(vfe, output->wm_idx[0], 1);
+		vfe_bus_reload_wm(vfe, output->wm_idx[0]);
+	} else {
+		ub_size /= output->wm_num;
+		for (i = 0; i < output->wm_num; i++) {
+			u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
+
+			vfe_set_cgc_override(vfe, output->wm_idx[i], 1);
+			vfe_wm_set_subsample(vfe, output->wm_idx[i]);
+			vfe_wm_set_ub_cfg(vfe, output->wm_idx[i],
+					  (ub_size + 1) * output->wm_idx[i],
+					  ub_size);
+			if ((i == 1) &&	(p == V4L2_PIX_FMT_NV12 ||
+						p == V4L2_PIX_FMT_NV21))
+				vfe_wm_line_based(vfe, output->wm_idx[i],
+						  line->fmt[MSM_VFE_PAD_SRC].width,
+						  line->fmt[MSM_VFE_PAD_SRC].height / 2,
+						  1);
+			else
+				vfe_wm_line_based(vfe, output->wm_idx[i],
+						  line->fmt[MSM_VFE_PAD_SRC].width,
+						  line->fmt[MSM_VFE_PAD_SRC].height,
+						  1);
 
-	vfe_bus_reload_wm(vfe, output->wm_idx);
+			vfe_wm_enable(vfe, output->wm_idx[i], 1);
+			vfe_bus_reload_wm(vfe, output->wm_idx[i]);
+		}
+		vfe_enable_irq_pix_line(vfe, 0, line->id, 1);
+		vfe_set_module_cfg(vfe, 1);
+		vfe_set_camif_cfg(vfe, line);
+		vfe_set_xbar_cfg(vfe, output, 1);
+		vfe_set_demux_cfg(vfe, line);
+		vfe_set_scale_cfg(vfe, line);
+		vfe_set_clamp_cfg(vfe);
+		vfe_set_camif_cmd(vfe, VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY);
+	}
 
 	vfe_reg_update(vfe, line->id);
 
@@ -861,15 +1241,56 @@ static int vfe_disable_output(struct vfe_line *line)
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
 	unsigned long flags;
+	unsigned long time;
+	unsigned int i;
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
-	vfe_wm_enable(vfe, output->wm_idx, 0);
-	vfe_bus_disconnect_wm_from_rdi(vfe, output->wm_idx, line->id);
-	vfe_reg_update(vfe, line->id);
+	output->wait_sof = 1;
+	spin_unlock_irqrestore(&vfe->output_lock, flags);
+
+	time = wait_for_completion_timeout(&output->sof,
+					   msecs_to_jiffies(VFE_NEXT_SOF_MS));
+	if (!time)
+		dev_err(to_device(vfe), "VFE sof timeout\n");
+
+	spin_lock_irqsave(&vfe->output_lock, flags);
+	for (i = 0; i < output->wm_num; i++)
+		vfe_wm_enable(vfe, output->wm_idx[i], 0);
 
+	vfe_reg_update(vfe, line->id);
+	output->wait_reg_update = 1;
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
 
+	time = wait_for_completion_timeout(&output->reg_update,
+					   msecs_to_jiffies(VFE_NEXT_SOF_MS));
+	if (!time)
+		dev_err(to_device(vfe), "VFE reg update timeout\n");
+
+	spin_lock_irqsave(&vfe->output_lock, flags);
+
+	if (line->id != VFE_LINE_PIX) {
+		vfe_wm_frame_based(vfe, output->wm_idx[0], 0);
+		vfe_bus_disconnect_wm_from_rdi(vfe, output->wm_idx[0], line->id);
+		vfe_enable_irq_wm_line(vfe, output->wm_idx[0], line->id, 0);
+		vfe_set_cgc_override(vfe, output->wm_idx[0], 0);
+		spin_unlock_irqrestore(&vfe->output_lock, flags);
+	} else {
+		for (i = 0; i < output->wm_num; i++) {
+			vfe_wm_line_based(vfe, output->wm_idx[i], 0, 0, 0);
+			vfe_set_cgc_override(vfe, output->wm_idx[i], 0);
+		}
+
+		vfe_enable_irq_pix_line(vfe, 0, line->id, 0);
+		vfe_set_module_cfg(vfe, 0);
+		vfe_set_xbar_cfg(vfe, output, 0);
+
+		vfe_set_camif_cmd(vfe, VFE_0_CAMIF_CMD_DISABLE_FRAME_BOUNDARY);
+		spin_unlock_irqrestore(&vfe->output_lock, flags);
+
+		vfe_camif_wait_for_stop(vfe);
+	}
+
 	return 0;
 }
 
@@ -937,6 +1358,10 @@ static int vfe_disable(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
 
+	vfe_disable_output(line);
+
+	vfe_put_output(line);
+
 	mutex_lock(&vfe->stream_lock);
 
 	if (vfe->stream_count == 1)
@@ -946,11 +1371,26 @@ static int vfe_disable(struct vfe_line *line)
 
 	mutex_unlock(&vfe->stream_lock);
 
-	vfe_disable_output(line);
+	return 0;
+}
 
-	vfe_put_output(line);
+/*
+ * vfe_isr_sof - Process start of frame interrupt
+ * @vfe: VFE Device
+ * @line_id: VFE line
+ */
+static void vfe_isr_sof(struct vfe_device *vfe, enum vfe_line_id line_id)
+{
+	struct vfe_output *output;
+	unsigned long flags;
 
-	return 0;
+	spin_lock_irqsave(&vfe->output_lock, flags);
+	output = &vfe->line[line_id].output;
+	if (output->wait_sof) {
+		output->wait_sof = 0;
+		complete(&output->sof);
+	}
+	spin_unlock_irqrestore(&vfe->output_lock, flags);
 }
 
 /*
@@ -964,9 +1404,17 @@ static void vfe_isr_reg_update(struct vfe_device *vfe, enum vfe_line_id line_id)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
-	vfe->reg_update &= ~VFE_0_REG_UPDATE_RDIn(line_id);
+	vfe->reg_update &= ~VFE_0_REG_UPDATE_line_n(line_id);
 
 	output = &vfe->line[line_id].output;
+
+	if (output->wait_reg_update) {
+		output->wait_reg_update = 0;
+		complete(&output->reg_update);
+		spin_unlock_irqrestore(&vfe->output_lock, flags);
+		return;
+	}
+
 	if (output->state == VFE_OUTPUT_STOPPING) {
 		/* Release last buffer when hw is idle */
 		if (output->last_buffer) {
@@ -1020,10 +1468,11 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
 {
 	struct camss_buffer *ready_buf;
 	struct vfe_output *output;
-	dma_addr_t new_addr;
+	dma_addr_t *new_addr;
 	unsigned long flags;
 	u32 active_index;
 	u64 ts = ktime_get_ns();
+	unsigned int i;
 
 	active_index = vfe_wm_get_ping_pong_status(vfe, wm);
 
@@ -1066,9 +1515,13 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
 	}
 
 	if (active_index)
-		vfe_wm_set_ping_addr(vfe, wm, new_addr);
+		for (i = 0; i < output->wm_num; i++)
+			vfe_wm_set_ping_addr(vfe, output->wm_idx[i],
+					     new_addr[i]);
 	else
-		vfe_wm_set_pong_addr(vfe, wm, new_addr);
+		for (i = 0; i < output->wm_num; i++)
+			vfe_wm_set_pong_addr(vfe, output->wm_idx[i],
+					     new_addr[i]);
 
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
 
@@ -1084,6 +1537,22 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
 }
 
 /*
+ * vfe_isr_wm_done - Process composite image done interrupt
+ * @vfe: VFE Device
+ * @comp: Composite image id
+ */
+static void vfe_isr_comp_done(struct vfe_device *vfe, u8 comp)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(vfe->wm_output_map); i++)
+		if (vfe->wm_output_map[i] == VFE_LINE_PIX) {
+			vfe_isr_wm_done(vfe, i);
+			break;
+		}
+}
+
+/*
  * vfe_isr - ISPIF module interrupt handler
  * @irq: Interrupt line
  * @dev: VFE device
@@ -1095,7 +1564,7 @@ static irqreturn_t vfe_isr(int irq, void *dev)
 	struct vfe_device *vfe = dev;
 	u32 value0, value1;
 	u32 violation;
-	int i;
+	int i, j;
 
 	value0 = readl_relaxed(vfe->base + VFE_0_IRQ_STATUS_0);
 	value1 = readl_relaxed(vfe->base + VFE_0_IRQ_STATUS_1);
@@ -1120,10 +1589,25 @@ static irqreturn_t vfe_isr(int irq, void *dev)
 		writel_relaxed(0x0, vfe->base + VFE_0_BUS_BDG_CMD);
 	}
 
-	for (i = VFE_LINE_RDI0; i <= VFE_LINE_RDI2; i++)
-		if (value0 & VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(i))
+	for (i = VFE_LINE_RDI0; i <= VFE_LINE_PIX; i++)
+		if (value0 & VFE_0_IRQ_STATUS_0_line_n_REG_UPDATE(i))
 			vfe_isr_reg_update(vfe, i);
 
+	if (value0 & VFE_0_IRQ_STATUS_0_CAMIF_SOF)
+		vfe_isr_sof(vfe, VFE_LINE_PIX);
+
+	for (i = VFE_LINE_RDI0; i <= VFE_LINE_RDI2; i++)
+		if (value1 & VFE_0_IRQ_STATUS_1_RDIn_SOF(i))
+			vfe_isr_sof(vfe, i);
+
+	for (i = 0; i < MSM_VFE_COMPOSITE_IRQ_NUM; i++)
+		if (value0 & VFE_0_IRQ_STATUS_0_IMAGE_COMPOSITE_DONE_n(i)) {
+			vfe_isr_comp_done(vfe, i);
+			for (j = 0; j < ARRAY_SIZE(vfe->wm_output_map); j++)
+				if (vfe->wm_output_map[j] == VFE_LINE_PIX)
+					value0 &= ~VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(j);
+		}
+
 	for (i = 0; i < MSM_VFE_IMAGE_MASTERS_NUM; i++)
 		if (value0 & VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG(i))
 			vfe_isr_wm_done(vfe, i);
@@ -1393,6 +1877,7 @@ static void vfe_try_format(struct vfe_line *line,
 			   enum v4l2_subdev_format_whence which)
 {
 	unsigned int i;
+	u32 code;
 
 	switch (pad) {
 	case MSM_VFE_PAD_SINK:
@@ -1417,9 +1902,40 @@ static void vfe_try_format(struct vfe_line *line,
 	case MSM_VFE_PAD_SRC:
 		/* Set and return a format same as sink pad */
 
+		code = fmt->code;
+
 		*fmt = *__vfe_get_format(line, cfg, MSM_VFE_PAD_SINK,
 					 which);
 
+		if (line->id == VFE_LINE_PIX)
+			switch (fmt->code) {
+			case MEDIA_BUS_FMT_YUYV8_2X8:
+				if (code == MEDIA_BUS_FMT_YUYV8_1_5X8)
+					fmt->code = MEDIA_BUS_FMT_YUYV8_1_5X8;
+				else
+					fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
+				break;
+			case MEDIA_BUS_FMT_YVYU8_2X8:
+				if (code == MEDIA_BUS_FMT_YVYU8_1_5X8)
+					fmt->code = MEDIA_BUS_FMT_YVYU8_1_5X8;
+				else
+					fmt->code = MEDIA_BUS_FMT_YVYU8_2X8;
+				break;
+			case MEDIA_BUS_FMT_UYVY8_2X8:
+			default:
+				if (code == MEDIA_BUS_FMT_UYVY8_1_5X8)
+					fmt->code = MEDIA_BUS_FMT_UYVY8_1_5X8;
+				else
+					fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
+				break;
+			case MEDIA_BUS_FMT_VYUY8_2X8:
+				if (code == MEDIA_BUS_FMT_VYUY8_1_5X8)
+					fmt->code = MEDIA_BUS_FMT_VYUY8_1_5X8;
+				else
+					fmt->code = MEDIA_BUS_FMT_VYUY8_2X8;
+				break;
+			}
+
 		break;
 	}
 
@@ -1608,11 +2124,13 @@ int msm_vfe_subdev_init(struct vfe_device *vfe, struct resources *res)
 	vfe->id = 0;
 	vfe->reg_update = 0;
 
-	for (i = VFE_LINE_RDI0; i <= VFE_LINE_RDI2; i++) {
+	for (i = VFE_LINE_RDI0; i <= VFE_LINE_PIX; i++) {
 		vfe->line[i].video_out.type =
 					V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 		vfe->line[i].video_out.camss = camss;
 		vfe->line[i].id = i;
+		init_completion(&vfe->line[i].output.sof);
+		init_completion(&vfe->line[i].output.reg_update);
 	}
 
 	/* Memory */
@@ -1804,8 +2322,13 @@ int msm_vfe_register_entities(struct vfe_device *vfe,
 		v4l2_subdev_init(sd, &vfe_v4l2_ops);
 		sd->internal_ops = &vfe_v4l2_internal_ops;
 		sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-		snprintf(sd->name, ARRAY_SIZE(sd->name), "%s%d_%s%d",
-			 MSM_VFE_NAME, vfe->id, "rdi", i);
+		if (i == VFE_LINE_PIX)
+			snprintf(sd->name, ARRAY_SIZE(sd->name), "%s%d_%s",
+				 MSM_VFE_NAME, vfe->id, "pix");
+		else
+			snprintf(sd->name, ARRAY_SIZE(sd->name), "%s%d_%s%d",
+				 MSM_VFE_NAME, vfe->id, "rdi", i);
+
 		v4l2_set_subdevdata(sd, &vfe->line[i]);
 
 		ret = vfe_init_formats(sd, NULL);
@@ -1833,6 +2356,9 @@ int msm_vfe_register_entities(struct vfe_device *vfe,
 		}
 
 		video_out->ops = &camss_vfe_video_ops;
+		video_out->fmt_tag = CAMSS_FMT_TAG_RDI;
+		if (i == VFE_LINE_PIX)
+			video_out->fmt_tag = CAMSS_FMT_TAG_PIX;
 		snprintf(name, ARRAY_SIZE(name), "%s%d_%s%d",
 			 MSM_VFE_NAME, vfe->id, "video", i);
 		ret = msm_video_register(video_out, v4l2_dev, name);
diff --git a/drivers/media/platform/qcom/camss-8x16/vfe.h b/drivers/media/platform/qcom/camss-8x16/vfe.h
index ab551a5..74ad2a6 100644
--- a/drivers/media/platform/qcom/camss-8x16/vfe.h
+++ b/drivers/media/platform/qcom/camss-8x16/vfe.h
@@ -30,8 +30,9 @@
 #define MSM_VFE_PAD_SRC 1
 #define MSM_VFE_PADS_NUM 2
 
-#define MSM_VFE_LINE_NUM 3
+#define MSM_VFE_LINE_NUM 4
 #define MSM_VFE_IMAGE_MASTERS_NUM 7
+#define MSM_VFE_COMPOSITE_IRQ_NUM 4
 
 #define MSM_VFE_VFE0_UB_SIZE 1023
 #define MSM_VFE_VFE0_UB_SIZE_RDI (MSM_VFE_VFE0_UB_SIZE / 3)
@@ -51,11 +52,13 @@ enum vfe_line_id {
 	VFE_LINE_NONE = -1,
 	VFE_LINE_RDI0 = 0,
 	VFE_LINE_RDI1 = 1,
-	VFE_LINE_RDI2 = 2
+	VFE_LINE_RDI2 = 2,
+	VFE_LINE_PIX = 3
 };
 
 struct vfe_output {
-	u8 wm_idx;
+	u8 wm_num;
+	u8 wm_idx[3];
 
 	int active_buf;
 	struct camss_buffer *buf[2];
@@ -66,6 +69,10 @@ struct vfe_output {
 
 	enum vfe_output_state state;
 	unsigned int sequence;
+	int wait_sof;
+	int wait_reg_update;
+	struct completion sof;
+	struct completion reg_update;
 };
 
 struct vfe_line {
diff --git a/drivers/media/platform/qcom/camss-8x16/video.c b/drivers/media/platform/qcom/camss-8x16/video.c
index 07175d3..36c949d 100644
--- a/drivers/media/platform/qcom/camss-8x16/video.c
+++ b/drivers/media/platform/qcom/camss-8x16/video.c
@@ -27,72 +27,200 @@
 #include "video.h"
 #include "camss.h"
 
+struct fract {
+	u8 numerator;
+	u8 denominator;
+};
+
 /*
  * struct format_info - ISP media bus format information
  * @code: V4L2 media bus format code
  * @pixelformat: V4L2 pixel format FCC identifier
- * @bpp: Bits per pixel when stored in memory
+ * @hsub: Horizontal subsampling (for each plane)
+ * @vsub: Vertical subsampling (for each plane)
+ * @bpp: Bits per pixel when stored in memory (for each plane)
+ * @fmt_tags: Tags that indicate for which output this format can be used
  */
 static const struct format_info {
 	u32 code;
 	u32 pixelformat;
-	unsigned int bpp;
+	u8 planes;
+	struct fract hsub[3];
+	struct fract vsub[3];
+	unsigned int bpp[3];
+	u8 fmt_tags;
 } formats[] = {
-	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_UYVY, 16 },
-	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_VYUY, 16 },
-	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_YUYV, 16 },
-	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_YVYU, 16 },
-	{ MEDIA_BUS_FMT_SBGGR8_1X8, V4L2_PIX_FMT_SBGGR8, 8 },
-	{ MEDIA_BUS_FMT_SGBRG8_1X8, V4L2_PIX_FMT_SGBRG8, 8 },
-	{ MEDIA_BUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8, 8 },
-	{ MEDIA_BUS_FMT_SRGGB8_1X8, V4L2_PIX_FMT_SRGGB8, 8 },
-	{ MEDIA_BUS_FMT_SBGGR10_1X10, V4L2_PIX_FMT_SBGGR10P, 10 },
-	{ MEDIA_BUS_FMT_SGBRG10_1X10, V4L2_PIX_FMT_SGBRG10P, 10 },
-	{ MEDIA_BUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10P, 10 },
-	{ MEDIA_BUS_FMT_SRGGB10_1X10, V4L2_PIX_FMT_SRGGB10P, 10 },
-	{ MEDIA_BUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SRGGB12P, 12 },
-	{ MEDIA_BUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12P, 12 },
-	{ MEDIA_BUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12P, 12 },
-	{ MEDIA_BUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12P, 12 }
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_UYVY, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_VYUY, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_YUYV, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_YVYU, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, V4L2_PIX_FMT_SBGGR8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, V4L2_PIX_FMT_SGBRG8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, V4L2_PIX_FMT_SRGGB8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SBGGR10_1X10, V4L2_PIX_FMT_SBGGR10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SGBRG10_1X10, V4L2_PIX_FMT_SGBRG10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SRGGB10_1X10, V4L2_PIX_FMT_SRGGB10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SRGGB12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 },
+	  CAMSS_FMT_TAG_RDI },
+	{ MEDIA_BUS_FMT_YUYV8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_YVYU8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_UYVY8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_VYUY8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_YUYV8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_YVYU8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_UYVY8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_VYUY8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 },
+	  CAMSS_FMT_TAG_PIX },
 };
 
 /* -----------------------------------------------------------------------------
  * Helper functions
  */
 
+static int video_find_format(u32 code, u32 pixelformat, enum camss_fmt_tag tag)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(formats); i++) {
+		if (formats[i].code == code &&
+		    formats[i].fmt_tags & tag &&
+		    formats[i].pixelformat == pixelformat)
+			return i;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(formats); i++)
+		if (formats[i].code == code &&
+		    formats[i].fmt_tags & tag)
+			return i;
+
+	WARN_ON(1);
+
+	return -EINVAL;
+}
+
+static int video_find_format_n(u32 code, u32 index, enum camss_fmt_tag tag)
+{
+	int i;
+	u32 n = 0;
+
+	for (i = 0; i < ARRAY_SIZE(formats); i++)
+		if (formats[i].code == code &&
+		    formats[i].fmt_tags & tag) {
+			if (n == index)
+				return i;
+			n++;
+		}
+
+	return -EINVAL;
+}
+
 /*
  * video_mbus_to_pix_mp - Convert v4l2_mbus_framefmt to v4l2_pix_format_mplane
- * @mbus: v4l2_mbus_framefmt format (input)
+ * @mbus: v4l2_mbus_framefmt format
  * @pix: v4l2_pix_format_mplane format (output)
+ * @index: index of an entry in formats array to be used for the conversion
  *
  * Fill the output pix structure with information from the input mbus format.
  *
  * Return 0 on success or a negative error code otherwise
  */
-static unsigned int video_mbus_to_pix_mp(const struct v4l2_mbus_framefmt *mbus,
-					 struct v4l2_pix_format_mplane *pix)
+static int video_mbus_to_pix_mp(const struct v4l2_mbus_framefmt *mbus,
+				struct v4l2_pix_format_mplane *pix, int index)
 {
+	const struct format_info *f;
 	unsigned int i;
 	u32 bytesperline;
 
+	f = &formats[index];
 	memset(pix, 0, sizeof(*pix));
 	pix->width = mbus->width;
 	pix->height = mbus->height;
-
-	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
-		if (formats[i].code == mbus->code)
-			break;
+	pix->pixelformat = f->pixelformat;
+	pix->num_planes = f->planes;
+	for (i = 0; i < pix->num_planes; i++) {
+		bytesperline = pix->width / f->hsub[i].numerator *
+			f->hsub[i].denominator * f->bpp[i] / 8;
+		bytesperline = ALIGN(bytesperline, 8);
+		pix->plane_fmt[i].bytesperline = bytesperline;
+		pix->plane_fmt[i].sizeimage = pix->height /
+				f->vsub[i].numerator * f->vsub[i].denominator *
+				bytesperline;
 	}
-
-	if (WARN_ON(i == ARRAY_SIZE(formats)))
-		return -EINVAL;
-
-	pix->pixelformat = formats[i].pixelformat;
-	pix->num_planes = 1;
-	bytesperline = pix->width * formats[i].bpp / 8;
-	bytesperline = ALIGN(bytesperline, 8);
-	pix->plane_fmt[0].bytesperline = bytesperline;
-	pix->plane_fmt[0].sizeimage = bytesperline * pix->height;
 	pix->colorspace = mbus->colorspace;
 	pix->field = mbus->field;
 
@@ -135,7 +263,42 @@ static int video_get_subdev_format(struct camss_video *video,
 		return ret;
 
 	format->type = video->type;
-	return video_mbus_to_pix_mp(&fmt.format, &format->fmt.pix_mp);
+
+	ret = video_find_format(fmt.format.code,
+				format->fmt.pix_mp.pixelformat,
+				video->fmt_tag);
+	if (ret < 0)
+		return ret;
+
+	return video_mbus_to_pix_mp(&fmt.format, &format->fmt.pix_mp, ret);
+}
+
+static int video_get_pixelformat(struct camss_video *video, u32 *pixelformat,
+				 u32 index)
+{
+	struct v4l2_subdev_format fmt;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	subdev = video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	fmt.pad = pad;
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
+	if (ret)
+		return ret;
+
+	ret = video_find_format_n(fmt.format.code, index, video->fmt_tag);
+	if (ret < 0)
+		return ret;
+
+	*pixelformat = formats[ret].pixelformat;
+
+	return 0;
 }
 
 /* -----------------------------------------------------------------------------
@@ -147,44 +310,73 @@ static int video_queue_setup(struct vb2_queue *q,
 	unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct camss_video *video = vb2_get_drv_priv(q);
+	const struct v4l2_pix_format_mplane *format =
+						&video->active_fmt.fmt.pix_mp;
+	unsigned int i;
 
 	if (*num_planes) {
-		if (*num_planes != 1)
+		if (*num_planes != format->num_planes)
 			return -EINVAL;
 
-		if (sizes[0] < video->active_fmt.fmt.pix_mp.plane_fmt[0].sizeimage)
-			return -EINVAL;
+		for (i = 0; i < *num_planes; i++)
+			if (sizes[i] < format->plane_fmt[i].sizeimage)
+				return -EINVAL;
 
 		return 0;
 	}
 
-	*num_planes = 1;
+	*num_planes = format->num_planes;
 
-	sizes[0] = video->active_fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
+	for (i = 0; i < *num_planes; i++)
+		sizes[i] = format->plane_fmt[i].sizeimage;
 
 	return 0;
 }
 
-static int video_buf_prepare(struct vb2_buffer *vb)
+static int video_buf_init(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct camss_video *video = vb2_get_drv_priv(vb->vb2_queue);
 	struct camss_buffer *buffer = container_of(vbuf, struct camss_buffer,
 						   vb);
+	const struct v4l2_pix_format_mplane *format =
+						&video->active_fmt.fmt.pix_mp;
 	struct sg_table *sgt;
+	unsigned int i;
 
-	if (video->active_fmt.fmt.pix_mp.plane_fmt[0].sizeimage >
-							vb2_plane_size(vb, 0))
-		return -EINVAL;
+	for (i = 0; i < format->num_planes; i++) {
+		sgt = vb2_dma_sg_plane_desc(vb, i);
+		if (!sgt)
+			return -EFAULT;
+
+		buffer->addr[i] = sg_dma_address(sgt->sgl);
+	}
 
-	vb2_set_plane_payload(vb, 0,
-			video->active_fmt.fmt.pix_mp.plane_fmt[0].sizeimage);
+	if (format->pixelformat == V4L2_PIX_FMT_NV12 ||
+			format->pixelformat == V4L2_PIX_FMT_NV21 ||
+			format->pixelformat == V4L2_PIX_FMT_NV16 ||
+			format->pixelformat == V4L2_PIX_FMT_NV61)
+		buffer->addr[1] = buffer->addr[0] +
+				format->plane_fmt[0].bytesperline *
+				format->height;
 
-	sgt = vb2_dma_sg_plane_desc(vb, 0);
-	if (!sgt)
-		return -EFAULT;
+	return 0;
+}
 
-	buffer->addr = sg_dma_address(sgt->sgl);
+static int video_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct camss_video *video = vb2_get_drv_priv(vb->vb2_queue);
+	const struct v4l2_pix_format_mplane *format =
+						&video->active_fmt.fmt.pix_mp;
+	unsigned int i;
+
+	for (i = 0; i < format->num_planes; i++) {
+		if (format->plane_fmt[i].sizeimage > vb2_plane_size(vb, i))
+			return -EINVAL;
+
+		vb2_set_plane_payload(vb, i, format->plane_fmt[i].sizeimage);
+	}
 
 	vbuf->field = V4L2_FIELD_NONE;
 
@@ -206,22 +398,29 @@ static int video_check_format(struct camss_video *video)
 	struct v4l2_pix_format_mplane *pix = &video->active_fmt.fmt.pix_mp;
 	struct v4l2_pix_format_mplane *sd_pix;
 	struct v4l2_format format;
+	unsigned int i;
 	int ret;
 
+	sd_pix = &format.fmt.pix_mp;
+	sd_pix->pixelformat = pix->pixelformat;
 	ret = video_get_subdev_format(video, &format);
 	if (ret < 0)
 		return ret;
 
-	sd_pix = &format.fmt.pix_mp;
 	if (pix->pixelformat != sd_pix->pixelformat ||
 	    pix->height != sd_pix->height ||
 	    pix->width != sd_pix->width ||
 	    pix->num_planes != sd_pix->num_planes ||
-	    pix->plane_fmt[0].bytesperline != sd_pix->plane_fmt[0].bytesperline ||
-	    pix->plane_fmt[0].sizeimage != sd_pix->plane_fmt[0].sizeimage ||
 	    pix->field != format.fmt.pix_mp.field)
 		return -EINVAL;
 
+	for (i = 0; i < pix->num_planes; i++)
+		if (pix->plane_fmt[i].bytesperline !=
+				sd_pix->plane_fmt[i].bytesperline ||
+		    pix->plane_fmt[i].sizeimage !=
+				sd_pix->plane_fmt[i].sizeimage)
+			return -EINVAL;
+
 	return 0;
 }
 
@@ -277,7 +476,6 @@ static void video_stop_streaming(struct vb2_queue *q)
 	struct media_entity *entity;
 	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
-	struct v4l2_subdev *subdev_vfe = NULL;
 
 	entity = &vdev->entity;
 	while (1) {
@@ -292,14 +490,7 @@ static void video_stop_streaming(struct vb2_queue *q)
 		entity = pad->entity;
 		subdev = media_entity_to_v4l2_subdev(entity);
 
-		if (strstr(subdev->name, "vfe")) {
-			subdev_vfe = subdev;
-		} else if (strstr(subdev->name, "ispif")) {
-			v4l2_subdev_call(subdev, video, s_stream, 0);
-			v4l2_subdev_call(subdev_vfe, video, s_stream, 0);
-		} else {
-			v4l2_subdev_call(subdev, video, s_stream, 0);
-		}
+		v4l2_subdev_call(subdev, video, s_stream, 0);
 	}
 
 	media_pipeline_stop(&vdev->entity);
@@ -311,6 +502,7 @@ static void video_stop_streaming(struct vb2_queue *q)
 	.queue_setup     = video_queue_setup,
 	.wait_prepare    = vb2_ops_wait_prepare,
 	.wait_finish     = vb2_ops_wait_finish,
+	.buf_init        = video_buf_init,
 	.buf_prepare     = video_buf_prepare,
 	.buf_queue       = video_buf_queue,
 	.start_streaming = video_start_streaming,
@@ -337,22 +529,11 @@ static int video_querycap(struct file *file, void *fh,
 static int video_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 {
 	struct camss_video *video = video_drvdata(file);
-	struct v4l2_format format;
-	int ret;
 
 	if (f->type != video->type)
 		return -EINVAL;
 
-	if (f->index)
-		return -EINVAL;
-
-	ret = video_get_subdev_format(video, &format);
-	if (ret < 0)
-		return ret;
-
-	f->pixelformat = format.fmt.pix.pixelformat;
-
-	return 0;
+	return video_get_pixelformat(video, &f->pixelformat, f->index);
 }
 
 static int video_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
diff --git a/drivers/media/platform/qcom/camss-8x16/video.h b/drivers/media/platform/qcom/camss-8x16/video.h
index 9ad7bbc..8f06c92 100644
--- a/drivers/media/platform/qcom/camss-8x16/video.h
+++ b/drivers/media/platform/qcom/camss-8x16/video.h
@@ -29,7 +29,7 @@
 
 struct camss_buffer {
 	struct vb2_v4l2_buffer vb;
-	dma_addr_t addr;
+	dma_addr_t addr[3];
 	struct list_head queue;
 };
 
@@ -41,6 +41,11 @@ struct camss_video_ops {
 			     enum vb2_buffer_state state);
 };
 
+enum camss_fmt_tag {
+	CAMSS_FMT_TAG_RDI = 1 << 0,
+	CAMSS_FMT_TAG_PIX = 1 << 1
+};
+
 struct camss_video {
 	struct camss *camss;
 	struct vb2_queue vb2_q;
@@ -52,6 +57,7 @@ struct camss_video {
 	const struct camss_video_ops *ops;
 	struct mutex lock;
 	struct mutex q_lock;
+	enum camss_fmt_tag fmt_tag;
 };
 
 void msm_video_stop_streaming(struct camss_video *video);
-- 
1.9.1
