Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40299 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752361AbdHHNa6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:30:58 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 12/21] camss: vfe: Format conversion support using PIX interface
Date: Tue,  8 Aug 2017 16:30:09 +0300
Message-Id: <1502199018-28250-13-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
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
 .../media/platform/qcom/camss-8x16/camss-ispif.c   |   2 +
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 705 ++++++++++++++++++---
 drivers/media/platform/qcom/camss-8x16/camss-vfe.h |  13 +-
 .../media/platform/qcom/camss-8x16/camss-video.c   | 308 ++++++---
 .../media/platform/qcom/camss-8x16/camss-video.h   |   8 +-
 5 files changed, 879 insertions(+), 157 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-ispif.c b/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
index b047811..31e00e5 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
@@ -1003,6 +1003,8 @@ static enum ispif_intf ispif_get_intf(enum vfe_line_id line_id)
 		return RDI1;
 	case (VFE_LINE_RDI2):
 		return RDI2;
+	case (VFE_LINE_PIX):
+		return PIX0;
 	default:
 		return RDI0;
 	}
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
index fe6b8ab..44605e0 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
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
@@ -130,8 +160,60 @@
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
+#define VFE_0_SCALE_ENC_CBCR_CFG		0x778
+#define VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE	0x77c
+#define VFE_0_SCALE_ENC_CBCR_H_PHASE		0x780
+#define VFE_0_SCALE_ENC_CBCR_H_PAD		0x78c
+#define VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE	0x790
+#define VFE_0_SCALE_ENC_CBCR_V_PHASE		0x794
+#define VFE_0_SCALE_ENC_CBCR_V_PAD		0x7a0
+
+#define VFE_0_CLAMP_ENC_MAX_CFG			0x874
+#define VFE_0_CLAMP_ENC_MAX_CFG_CH0		(0xff << 0)
+#define VFE_0_CLAMP_ENC_MAX_CFG_CH1		(0xff << 8)
+#define VFE_0_CLAMP_ENC_MAX_CFG_CH2		(0xff << 16)
+#define VFE_0_CLAMP_ENC_MIN_CFG			0x878
+#define VFE_0_CLAMP_ENC_MIN_CFG_CH0		(0x0 << 0)
+#define VFE_0_CLAMP_ENC_MIN_CFG_CH1		(0x0 << 8)
+#define VFE_0_CLAMP_ENC_MIN_CFG_CH2		(0x0 << 16)
 
 #define VFE_0_CGC_OVERRIDE_1			0x974
 #define VFE_0_CGC_OVERRIDE_1_IMAGE_Mx_CGC_OVERRIDE(x)	(1 << (x))
@@ -145,6 +227,11 @@
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
@@ -213,6 +300,32 @@ static void vfe_wm_frame_based(struct vfe_device *vfe, u8 wm, u8 enable)
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
@@ -316,7 +429,10 @@ static void vfe_bus_connect_wm_to_rdi(struct vfe_device *vfe, u8 wm,
 		reg <<= 16;
 
 	vfe_reg_set(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
+}
 
+static void vfe_wm_set_subsample(struct vfe_device *vfe, u8 wm)
+{
 	writel_relaxed(VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN_DEF,
 	       vfe->base +
 	       VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(wm));
@@ -355,6 +471,38 @@ static void vfe_bus_disconnect_wm_from_rdi(struct vfe_device *vfe, u8 wm,
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
@@ -366,7 +514,7 @@ static void vfe_set_rdi_cid(struct vfe_device *vfe, enum vfe_line_id id, u8 cid)
 
 static void vfe_reg_update(struct vfe_device *vfe, enum vfe_line_id line_id)
 {
-	vfe->reg_update |= VFE_0_REG_UPDATE_RDIn(line_id);
+	vfe->reg_update |= VFE_0_REG_UPDATE_line_n(line_id);
 	wmb();
 	writel_relaxed(vfe->reg_update, vfe->base + VFE_0_REG_UPDATE);
 	wmb();
@@ -376,8 +524,9 @@ static void vfe_enable_irq_wm_line(struct vfe_device *vfe, u8 wm,
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
@@ -388,6 +537,37 @@ static void vfe_enable_irq_wm_line(struct vfe_device *vfe, u8 wm,
 	}
 }
 
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
 static void vfe_enable_irq_common(struct vfe_device *vfe)
 {
 	u32 irq_en0 = VFE_0_IRQ_MASK_0_RESET_ACK;
@@ -398,6 +578,96 @@ static void vfe_enable_irq_common(struct vfe_device *vfe)
 	vfe_reg_set(vfe, VFE_0_IRQ_MASK_1, irq_en1);
 }
 
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
 /*
  * vfe_reset - Trigger reset on VFE module and wait to complete
  * @vfe: VFE device
@@ -458,6 +728,10 @@ static void vfe_init_outputs(struct vfe_device *vfe)
 		output->buf[0] = NULL;
 		output->buf[1] = NULL;
 		INIT_LIST_HEAD(&output->pending_bufs);
+
+		output->wm_num = 1;
+		if (vfe->line[i].id == VFE_LINE_PIX)
+			output->wm_num = 2;
 	}
 }
 
@@ -496,52 +770,148 @@ static void vfe_set_cgc_override(struct vfe_device *vfe, u8 wm, u8 enable)
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
 
@@ -576,14 +946,19 @@ static void vfe_output_frame_drop(struct vfe_device *vfe,
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
 
@@ -720,6 +1095,7 @@ static int vfe_get_output(struct vfe_line *line)
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output;
 	unsigned long flags;
+	int i;
 	int wm_idx;
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
@@ -733,20 +1109,24 @@ static int vfe_get_output(struct vfe_line *line)
 
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
@@ -759,19 +1139,17 @@ static int vfe_put_output(struct vfe_line *line)
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
@@ -779,6 +1157,7 @@ static int vfe_enable_output(struct vfe_line *line)
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
 	unsigned long flags;
+	unsigned int i;
 	u16 ub_size;
 
 	switch (vfe->id) {
@@ -794,7 +1173,7 @@ static int vfe_enable_output(struct vfe_line *line)
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
-	vfe->reg_update &= ~VFE_0_REG_UPDATE_RDIn(line->id);
+	vfe->reg_update &= ~VFE_0_REG_UPDATE_line_n(line->id);
 
 	if (output->state != VFE_OUTPUT_RESERVED) {
 		dev_err(to_device(vfe), "Output is not in reserved state %d\n",
@@ -831,24 +1210,58 @@ static int vfe_enable_output(struct vfe_line *line)
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
 
@@ -862,15 +1275,56 @@ static int vfe_disable_output(struct vfe_line *line)
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
 
+	spin_lock_irqsave(&vfe->output_lock, flags);
+	for (i = 0; i < output->wm_num; i++)
+		vfe_wm_enable(vfe, output->wm_idx[i], 0);
+
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
 
@@ -938,6 +1392,10 @@ static int vfe_disable(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
 
+	vfe_disable_output(line);
+
+	vfe_put_output(line);
+
 	mutex_lock(&vfe->stream_lock);
 
 	if (vfe->stream_count == 1)
@@ -947,11 +1405,26 @@ static int vfe_disable(struct vfe_line *line)
 
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
@@ -965,9 +1438,17 @@ static void vfe_isr_reg_update(struct vfe_device *vfe, enum vfe_line_id line_id)
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
@@ -1021,10 +1502,11 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
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
 
@@ -1067,9 +1549,13 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
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
 
@@ -1085,6 +1571,22 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
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
@@ -1096,7 +1598,7 @@ static irqreturn_t vfe_isr(int irq, void *dev)
 	struct vfe_device *vfe = dev;
 	u32 value0, value1;
 	u32 violation;
-	int i;
+	int i, j;
 
 	value0 = readl_relaxed(vfe->base + VFE_0_IRQ_STATUS_0);
 	value1 = readl_relaxed(vfe->base + VFE_0_IRQ_STATUS_1);
@@ -1121,10 +1623,25 @@ static irqreturn_t vfe_isr(int irq, void *dev)
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
@@ -1394,6 +1911,7 @@ static void vfe_try_format(struct vfe_line *line,
 			   enum v4l2_subdev_format_whence which)
 {
 	unsigned int i;
+	u32 code;
 
 	switch (pad) {
 	case MSM_VFE_PAD_SINK:
@@ -1418,9 +1936,40 @@ static void vfe_try_format(struct vfe_line *line,
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
 
@@ -1668,11 +2217,13 @@ int msm_vfe_subdev_init(struct vfe_device *vfe, const struct resources *res)
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
 
 	init_completion(&vfe->reset_complete);
@@ -1810,8 +2361,13 @@ int msm_vfe_register_entities(struct vfe_device *vfe,
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
@@ -1841,7 +2397,8 @@ int msm_vfe_register_entities(struct vfe_device *vfe,
 		video_out->ops = &camss_vfe_video_ops;
 		snprintf(name, ARRAY_SIZE(name), "%s%d_%s%d",
 			 MSM_VFE_NAME, vfe->id, "video", i);
-		ret = msm_video_register(video_out, v4l2_dev, name);
+		ret = msm_video_register(video_out, v4l2_dev, name,
+					 i == VFE_LINE_PIX ? 1 : 0);
 		if (ret < 0) {
 			dev_err(dev, "Failed to register video node: %d\n",
 				ret);
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
index 6d2fc57..b0598e4 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
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
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-video.c b/drivers/media/platform/qcom/camss-8x16/camss-video.c
index 2e3f012..8a45314 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-video.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-video.c
@@ -27,72 +27,155 @@
 #include "camss-video.h"
 #include "camss.h"
 
+struct fract {
+	u8 numerator;
+	u8 denominator;
+};
+
 /*
  * struct camss_format_info - ISP media bus format information
  * @code: V4L2 media bus format code
  * @pixelformat: V4L2 pixel format FCC identifier
- * @bpp: Bits per pixel when stored in memory
+ * @planes: Number of planes
+ * @hsub: Horizontal subsampling (for each plane)
+ * @vsub: Vertical subsampling (for each plane)
+ * @bpp: Bits per pixel when stored in memory (for each plane)
  */
-static const struct camss_format_info {
+struct camss_format_info {
 	u32 code;
 	u32 pixelformat;
-	unsigned int bpp;
-} formats[] = {
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
-	{ MEDIA_BUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SBGGR12P, 12 },
-	{ MEDIA_BUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12P, 12 },
-	{ MEDIA_BUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12P, 12 },
-	{ MEDIA_BUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12P, 12 }
+	u8 planes;
+	struct fract hsub[3];
+	struct fract vsub[3];
+	unsigned int bpp[3];
+};
+
+static const struct camss_format_info formats_rdi[] = {
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_UYVY, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_VYUY, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_YUYV, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_YVYU, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, V4L2_PIX_FMT_SBGGR8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 } },
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, V4L2_PIX_FMT_SGBRG8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 } },
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 } },
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, V4L2_PIX_FMT_SRGGB8, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 8 } },
+	{ MEDIA_BUS_FMT_SBGGR10_1X10, V4L2_PIX_FMT_SBGGR10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
+	{ MEDIA_BUS_FMT_SGBRG10_1X10, V4L2_PIX_FMT_SGBRG10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
+	{ MEDIA_BUS_FMT_SRGGB10_1X10, V4L2_PIX_FMT_SRGGB10P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 10 } },
+	{ MEDIA_BUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SBGGR12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
+	{ MEDIA_BUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
+	{ MEDIA_BUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12P, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 12 } },
+};
+
+static const struct camss_format_info formats_pix[] = {
+	{ MEDIA_BUS_FMT_YUYV8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YVYU8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_UYVY8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_VYUY8_1_5X8, V4L2_PIX_FMT_NV12, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YUYV8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YVYU8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_UYVY8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_VYUY8_1_5X8, V4L2_PIX_FMT_NV21, 1,
+	  { { 1, 1 } }, { { 2, 3 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_NV16, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_NV61, 1,
+	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
 };
 
 /* -----------------------------------------------------------------------------
  * Helper functions
  */
 
+static int video_find_format(u32 code, u32 pixelformat,
+			     const struct camss_format_info *formats,
+			     unsigned int nformats)
+{
+	int i;
+
+	for (i = 0; i < nformats; i++) {
+		if (formats[i].code == code &&
+		    formats[i].pixelformat == pixelformat)
+			return i;
+	}
+
+	for (i = 0; i < nformats; i++)
+		if (formats[i].code == code)
+			return i;
+
+	WARN_ON(1);
+
+	return -EINVAL;
+}
+
 /*
  * video_mbus_to_pix_mp - Convert v4l2_mbus_framefmt to v4l2_pix_format_mplane
  * @mbus: v4l2_mbus_framefmt format (input)
  * @pix: v4l2_pix_format_mplane format (output)
+ * @f: a pointer to formats array element to be used for the conversion
  *
  * Fill the output pix structure with information from the input mbus format.
  *
  * Return 0 on success or a negative error code otherwise
  */
-static unsigned int video_mbus_to_pix_mp(const struct v4l2_mbus_framefmt *mbus,
-					 struct v4l2_pix_format_mplane *pix)
+static int video_mbus_to_pix_mp(const struct v4l2_mbus_framefmt *mbus,
+				struct v4l2_pix_format_mplane *pix,
+				const struct camss_format_info *f)
 {
 	unsigned int i;
 	u32 bytesperline;
 
 	memset(pix, 0, sizeof(*pix));
 	v4l2_fill_pix_format_mplane(pix, mbus);
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
 
-	if (WARN_ON(i == ARRAY_SIZE(formats)))
-		return -EINVAL;
-
-	pix->pixelformat = formats[i].pixelformat;
-	pix->num_planes = 1;
-	bytesperline = pix->width * formats[i].bpp / 8;
-	bytesperline = ALIGN(bytesperline, 8);
-	pix->plane_fmt[0].bytesperline = bytesperline;
-	pix->plane_fmt[0].sizeimage = bytesperline * pix->height;
-
 	return 0;
 }
 
@@ -131,8 +214,16 @@ static int video_get_subdev_format(struct camss_video *video,
 	if (ret)
 		return ret;
 
+	ret = video_find_format(fmt.format.code,
+				format->fmt.pix_mp.pixelformat,
+				video->formats, video->nformats);
+	if (ret < 0)
+		return ret;
+
 	format->type = video->type;
-	return video_mbus_to_pix_mp(&fmt.format, &format->fmt.pix_mp);
+
+	return video_mbus_to_pix_mp(&fmt.format, &format->fmt.pix_mp,
+				    &video->formats[ret]);
 }
 
 /* -----------------------------------------------------------------------------
@@ -144,44 +235,73 @@ static int video_queue_setup(struct vb2_queue *q,
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
 
-	vb2_set_plane_payload(vb, 0,
-			video->active_fmt.fmt.pix_mp.plane_fmt[0].sizeimage);
+		buffer->addr[i] = sg_dma_address(sgt->sgl);
+	}
+
+	if (format->pixelformat == V4L2_PIX_FMT_NV12 ||
+			format->pixelformat == V4L2_PIX_FMT_NV21 ||
+			format->pixelformat == V4L2_PIX_FMT_NV16 ||
+			format->pixelformat == V4L2_PIX_FMT_NV61)
+		buffer->addr[1] = buffer->addr[0] +
+				format->plane_fmt[0].bytesperline *
+				format->height;
+
+	return 0;
+}
+
+static int video_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct camss_video *video = vb2_get_drv_priv(vb->vb2_queue);
+	const struct v4l2_pix_format_mplane *format =
+						&video->active_fmt.fmt.pix_mp;
+	unsigned int i;
 
-	sgt = vb2_dma_sg_plane_desc(vb, 0);
-	if (!sgt)
-		return -EFAULT;
+	for (i = 0; i < format->num_planes; i++) {
+		if (format->plane_fmt[i].sizeimage > vb2_plane_size(vb, i))
+			return -EINVAL;
 
-	buffer->addr = sg_dma_address(sgt->sgl);
+		vb2_set_plane_payload(vb, i, format->plane_fmt[i].sizeimage);
+	}
 
 	vbuf->field = V4L2_FIELD_NONE;
 
@@ -203,8 +323,10 @@ static int video_check_format(struct camss_video *video)
 	struct v4l2_pix_format_mplane *pix = &video->active_fmt.fmt.pix_mp;
 	struct v4l2_format format;
 	struct v4l2_pix_format_mplane *sd_pix = &format.fmt.pix_mp;
+	unsigned int i;
 	int ret;
 
+	sd_pix->pixelformat = pix->pixelformat;
 	ret = video_get_subdev_format(video, &format);
 	if (ret < 0)
 		return ret;
@@ -213,12 +335,16 @@ static int video_check_format(struct camss_video *video)
 	    pix->height != sd_pix->height ||
 	    pix->width != sd_pix->width ||
 	    pix->num_planes != sd_pix->num_planes ||
-	    pix->num_planes != 1 ||
-	    pix->plane_fmt[0].bytesperline != sd_pix->plane_fmt[0].bytesperline ||
-	    pix->plane_fmt[0].sizeimage != sd_pix->plane_fmt[0].sizeimage ||
 	    pix->field != format.fmt.pix_mp.field)
 		return -EPIPE;
 
+	for (i = 0; i < pix->num_planes; i++)
+		if (pix->plane_fmt[i].bytesperline !=
+				sd_pix->plane_fmt[i].bytesperline ||
+		    pix->plane_fmt[i].sizeimage !=
+				sd_pix->plane_fmt[i].sizeimage)
+			return -EINVAL;
+
 	return 0;
 }
 
@@ -274,7 +400,6 @@ static void video_stop_streaming(struct vb2_queue *q)
 	struct media_entity *entity;
 	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
-	struct v4l2_subdev *subdev_vfe = NULL;
 
 	entity = &vdev->entity;
 	while (1) {
@@ -289,14 +414,7 @@ static void video_stop_streaming(struct vb2_queue *q)
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
@@ -308,6 +426,7 @@ static const struct vb2_ops msm_video_vb2_q_ops = {
 	.queue_setup     = video_queue_setup,
 	.wait_prepare    = vb2_ops_wait_prepare,
 	.wait_finish     = vb2_ops_wait_finish,
+	.buf_init        = video_buf_init,
 	.buf_prepare     = video_buf_prepare,
 	.buf_queue       = video_buf_queue,
 	.start_streaming = video_start_streaming,
@@ -334,14 +453,34 @@ static int video_querycap(struct file *file, void *fh,
 static int video_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 {
 	struct camss_video *video = video_drvdata(file);
+	int i, j, k;
 
 	if (f->type != video->type)
 		return -EINVAL;
 
-	if (f->index >= ARRAY_SIZE(formats))
+	if (f->index >= video->nformats)
+		return -EINVAL;
+
+	/* find index "i" of "k"th unique pixelformat in formats array */
+	k = -1;
+	for (i = 0; i < video->nformats; i++) {
+		for (j = 0; j < i; j++) {
+			if (video->formats[i].pixelformat ==
+					video->formats[j].pixelformat)
+				break;
+		}
+
+		if (j == i)
+			k++;
+
+		if (k == f->index)
+			break;
+	}
+
+	if (k < f->index)
 		return -EINVAL;
 
-	f->pixelformat = formats[f->index].pixelformat;
+	f->pixelformat = video->formats[i].pixelformat;
 
 	return 0;
 }
@@ -358,32 +497,38 @@ static int video_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 static int __video_try_fmt(struct camss_video *video, struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *pix_mp;
+	const struct camss_format_info *fi;
 	u32 width, height;
 	u32 bpl;
-	int j;
+	int i, j;
 
 	pix_mp = &f->fmt.pix_mp;
 
-	for (j = 0; j < ARRAY_SIZE(formats); j++)
-		if (pix_mp->pixelformat == formats[j].pixelformat)
+	for (j = 0; j < video->nformats; j++)
+		if (pix_mp->pixelformat == video->formats[j].pixelformat)
 			break;
 
-	if (j == ARRAY_SIZE(formats))
+	if (j == video->nformats)
 		j = 0; /* default format */
 
+	fi = &video->formats[j];
 	width = pix_mp->width;
 	height = pix_mp->height;
 
 	memset(pix_mp, 0, sizeof(*pix_mp));
 
-	pix_mp->pixelformat = formats[j].pixelformat;
+	pix_mp->pixelformat = fi->pixelformat;
 	pix_mp->width = clamp_t(u32, width, 1, 8191);
 	pix_mp->height = clamp_t(u32, height, 1, 8191);
-	pix_mp->num_planes = 1;
-	bpl = pix_mp->width * formats[j].bpp / 8;
-	bpl = ALIGN(bpl, 8);
-	pix_mp->plane_fmt[0].bytesperline = bpl;
-	pix_mp->plane_fmt[0].sizeimage = bpl * pix_mp->height;
+	pix_mp->num_planes = fi->planes;
+	for (i = 0; i < pix_mp->num_planes; i++) {
+		bpl = pix_mp->width / fi->hsub[i].numerator *
+			fi->hsub[i].denominator * fi->bpp[i] / 8;
+		bpl = ALIGN(bpl, 8);
+		pix_mp->plane_fmt[i].bytesperline = bpl;
+		pix_mp->plane_fmt[i].sizeimage = pix_mp->height /
+			fi->vsub[i].numerator * fi->vsub[i].denominator * bpl;
+	}
 
 	pix_mp->field = V4L2_FIELD_NONE;
 	pix_mp->colorspace = V4L2_COLORSPACE_SRGB;
@@ -564,7 +709,7 @@ static int msm_video_init_format(struct camss_video *video)
 		.fmt.pix_mp = {
 			.width = 1920,
 			.height = 1080,
-			.pixelformat = formats[0].pixelformat,
+			.pixelformat = video->formats[0].pixelformat,
 		},
 	};
 
@@ -590,7 +735,7 @@ static int msm_video_init_format(struct camss_video *video)
  */
 
 int msm_video_register(struct camss_video *video, struct v4l2_device *v4l2_dev,
-		       const char *name)
+		       const char *name, int is_pix)
 {
 	struct media_pad *pad = &video->pad;
 	struct video_device *vdev;
@@ -627,6 +772,13 @@ int msm_video_register(struct camss_video *video, struct v4l2_device *v4l2_dev,
 
 	mutex_init(&video->lock);
 
+	video->formats = formats_rdi;
+	video->nformats = ARRAY_SIZE(formats_rdi);
+	if (is_pix) {
+		video->formats = formats_pix;
+		video->nformats = ARRAY_SIZE(formats_pix);
+	}
+
 	ret = msm_video_init_format(video);
 	if (ret < 0) {
 		dev_err(v4l2_dev->dev, "Failed to init format: %d\n", ret);
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-video.h b/drivers/media/platform/qcom/camss-8x16/camss-video.h
index 0d2cef3..e3b459f 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-video.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-video.h
@@ -29,7 +29,7 @@
 
 struct camss_buffer {
 	struct vb2_v4l2_buffer vb;
-	dma_addr_t addr;
+	dma_addr_t addr[3];
 	struct list_head queue;
 };
 
@@ -41,6 +41,8 @@ struct camss_video_ops {
 			     enum vb2_buffer_state state);
 };
 
+struct camss_format_info;
+
 struct camss_video {
 	struct camss *camss;
 	struct vb2_queue vb2_q;
@@ -52,12 +54,14 @@ struct camss_video {
 	const struct camss_video_ops *ops;
 	struct mutex lock;
 	struct mutex q_lock;
+	const struct camss_format_info *formats;
+	unsigned int nformats;
 };
 
 void msm_video_stop_streaming(struct camss_video *video);
 
 int msm_video_register(struct camss_video *video, struct v4l2_device *v4l2_dev,
-		       const char *name);
+		       const char *name, int is_pix);
 
 void msm_video_unregister(struct camss_video *video);
 
-- 
2.7.4
