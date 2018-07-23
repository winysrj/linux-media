Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40016 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388184AbeGWMEt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:04:49 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 28/35] media: camss: vfe: Add support for UYVY output from VFE on 8x96
Date: Mon, 23 Jul 2018 14:02:45 +0300
Message-Id: <1532343772-27382-29-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support to output UYVY formats from the VFE (via the PIX interface).
A configuration for the realign module in the VFE is added. As the
realign module is present on 8x96 but not on 8x16, this is supported
on 8x96 only.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c |   6 +
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c | 129 ++++++++++++++++++----
 drivers/media/platform/qcom/camss/camss-vfe.c     |  31 +++++-
 drivers/media/platform/qcom/camss/camss-vfe.h     |   2 +
 drivers/media/platform/qcom/camss/camss-video.c   |   8 ++
 5 files changed, 152 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
index 41184dc..da3a9fe 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
@@ -542,6 +542,11 @@ static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
 	}
 }
 
+static void vfe_set_realign_cfg(struct vfe_device *vfe, struct vfe_line *line,
+				u8 enable)
+{
+	/* empty */
+}
 static void vfe_set_rdi_cid(struct vfe_device *vfe, enum vfe_line_id id, u8 cid)
 {
 	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(id),
@@ -989,6 +994,7 @@ const struct vfe_hw_ops vfe_ops_4_1 = {
 	.wm_set_subsample = vfe_wm_set_subsample,
 	.bus_disconnect_wm_from_rdi = vfe_bus_disconnect_wm_from_rdi,
 	.set_xbar_cfg = vfe_set_xbar_cfg,
+	.set_realign_cfg = vfe_set_realign_cfg,
 	.set_rdi_cid = vfe_set_rdi_cid,
 	.reg_update = vfe_reg_update,
 	.reg_update_clear = vfe_reg_update_clear,
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
index 45e6711..4c584bf 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
@@ -34,6 +34,7 @@
 #define VFE_0_MODULE_ZOOM_EN		0x04c
 #define VFE_0_MODULE_ZOOM_EN_SCALE_ENC		BIT(1)
 #define VFE_0_MODULE_ZOOM_EN_CROP_ENC		BIT(2)
+#define VFE_0_MODULE_ZOOM_EN_REALIGN_BUF	BIT(9)
 
 #define VFE_0_CORE_CFG			0x050
 #define VFE_0_CORE_CFG_PIXEL_PATTERN_YCBYCR	0x4
@@ -87,6 +88,9 @@
 
 #define VFE_0_BUS_XBAR_CFG_x(x)		(0x90 + 0x4 * ((x) / 2))
 #define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN			BIT(2)
+#define VFE_0_BUS_XBAR_CFG_x_M_REALIGN_BUF_EN			BIT(3)
+#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTRA		(0x1 << 4)
+#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER		(0x2 << 4)
 #define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA	(0x3 << 4)
 #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT		8
 #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA		0x0
@@ -221,6 +225,11 @@
 #define VFE_0_CLAMP_ENC_MIN_CFG_CH1		(0x0 << 8)
 #define VFE_0_CLAMP_ENC_MIN_CFG_CH2		(0x0 << 16)
 
+#define VFE_0_REALIGN_BUF_CFG			0xaac
+#define VFE_0_REALIGN_BUF_CFG_CB_ODD_PIXEL     BIT(2)
+#define VFE_0_REALIGN_BUF_CFG_CR_ODD_PIXEL     BIT(3)
+#define VFE_0_REALIGN_BUF_CFG_HSUB_ENABLE      BIT(4)
+
 #define CAMIF_TIMEOUT_SLEEP_US 1000
 #define CAMIF_TIMEOUT_ALL_US 1000000
 
@@ -311,7 +320,7 @@ static void vfe_wm_frame_based(struct vfe_device *vfe, u8 wm, u8 enable)
 
 #define CALC_WORD(width, M, N) (((width) * (M) + (N) - 1) / (N))
 
-static int vfe_word_per_line(u32 format, u32 pixel_per_line)
+static int vfe_word_per_line_by_pixel(u32 format, u32 pixel_per_line)
 {
 	int val = 0;
 
@@ -333,6 +342,11 @@ static int vfe_word_per_line(u32 format, u32 pixel_per_line)
 	return val;
 }
 
+static int vfe_word_per_line_by_bytes(u32 bytes_per_line)
+{
+	return CALC_WORD(bytes_per_line, 1, 8);
+}
+
 static void vfe_get_wm_sizes(struct v4l2_pix_format_mplane *pix, u8 plane,
 			     u16 *width, u16 *height, u16 *bytesperline)
 {
@@ -351,6 +365,15 @@ static void vfe_get_wm_sizes(struct v4l2_pix_format_mplane *pix, u8 plane,
 		*height = pix->height;
 		*bytesperline = pix->plane_fmt[0].bytesperline;
 		break;
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_UYVY:
+		*width = pix->width;
+		*height = pix->height;
+		*bytesperline = pix->plane_fmt[plane].bytesperline;
+		break;
+
 	}
 }
 
@@ -365,7 +388,7 @@ static void vfe_wm_line_based(struct vfe_device *vfe, u32 wm,
 
 		vfe_get_wm_sizes(pix, plane, &width, &height, &bytesperline);
 
-		wpl = vfe_word_per_line(pix->pixelformat, width);
+		wpl = vfe_word_per_line_by_pixel(pix->pixelformat, width);
 
 		reg = height - 1;
 		reg |= ((wpl + 3) / 4 - 1) << 16;
@@ -373,7 +396,7 @@ static void vfe_wm_line_based(struct vfe_device *vfe, u32 wm,
 		writel_relaxed(reg, vfe->base +
 			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
 
-		wpl = vfe_word_per_line(pix->pixelformat, bytesperline);
+		wpl = vfe_word_per_line_by_bytes(bytesperline);
 
 		reg = 0x3;
 		reg |= (height - 1) << 2;
@@ -536,32 +559,97 @@ static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
 	struct vfe_line *line = container_of(output, struct vfe_line, output);
 	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
 	u32 reg;
-	unsigned int i;
 
-	for (i = 0; i < output->wm_num; i++) {
-		if (i == 0) {
-			reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA <<
-				VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
-		} else if (i == 1) {
-			reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
-			if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
-				reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
-		}
+	switch (p) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA <<
+			VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
+
+		if (output->wm_idx[0] % 2 == 1)
+			reg <<= 16;
+
+		if (enable)
+			vfe_reg_set(vfe,
+				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[0]),
+				    reg);
+		else
+			vfe_reg_clr(vfe,
+				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[0]),
+				    reg);
+
+		reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
+		if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
+			reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
+
+		if (output->wm_idx[1] % 2 == 1)
+			reg <<= 16;
 
-		if (output->wm_idx[i] % 2 == 1)
+		if (enable)
+			vfe_reg_set(vfe,
+				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[1]),
+				    reg);
+		else
+			vfe_reg_clr(vfe,
+				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[1]),
+				    reg);
+		break;
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_UYVY:
+		reg = VFE_0_BUS_XBAR_CFG_x_M_REALIGN_BUF_EN;
+		reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
+
+		if (p == V4L2_PIX_FMT_YUYV || p == V4L2_PIX_FMT_YVYU)
+			reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
+
+		if (output->wm_idx[0] % 2 == 1)
 			reg <<= 16;
 
 		if (enable)
 			vfe_reg_set(vfe,
-				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[i]),
+				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[0]),
 				    reg);
 		else
 			vfe_reg_clr(vfe,
-				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[i]),
+				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[0]),
 				    reg);
+		break;
+	default:
+		break;
 	}
 }
 
+static void vfe_set_realign_cfg(struct vfe_device *vfe, struct vfe_line *line,
+				u8 enable)
+{
+	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
+	u32 val = VFE_0_MODULE_ZOOM_EN_REALIGN_BUF;
+
+	if (p != V4L2_PIX_FMT_YUYV && p != V4L2_PIX_FMT_YVYU &&
+			p != V4L2_PIX_FMT_VYUY && p != V4L2_PIX_FMT_UYVY)
+		return;
+
+	if (enable) {
+		vfe_reg_set(vfe, VFE_0_MODULE_ZOOM_EN, val);
+	} else {
+		vfe_reg_clr(vfe, VFE_0_MODULE_ZOOM_EN, val);
+		return;
+	}
+
+	val = VFE_0_REALIGN_BUF_CFG_HSUB_ENABLE;
+
+	if (p == V4L2_PIX_FMT_UYVY || p == V4L2_PIX_FMT_YUYV)
+		val |= VFE_0_REALIGN_BUF_CFG_CR_ODD_PIXEL;
+	else
+		val |= VFE_0_REALIGN_BUF_CFG_CB_ODD_PIXEL;
+
+	writel_relaxed(val, vfe->base + VFE_0_REALIGN_BUF_CFG);
+}
+
 static void vfe_set_rdi_cid(struct vfe_device *vfe, enum vfe_line_id id, u8 cid)
 {
 	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(id),
@@ -911,11 +999,11 @@ static void vfe_set_module_cfg(struct vfe_device *vfe, u8 enable)
 		       VFE_0_MODULE_ZOOM_EN_CROP_ENC;
 
 	if (enable) {
-		writel_relaxed(val_lens, vfe->base + VFE_0_MODULE_LENS_EN);
-		writel_relaxed(val_zoom, vfe->base + VFE_0_MODULE_ZOOM_EN);
+		vfe_reg_set(vfe, VFE_0_MODULE_LENS_EN, val_lens);
+		vfe_reg_set(vfe, VFE_0_MODULE_ZOOM_EN, val_zoom);
 	} else {
-		writel_relaxed(0x0, vfe->base + VFE_0_MODULE_LENS_EN);
-		writel_relaxed(0x0, vfe->base + VFE_0_MODULE_ZOOM_EN);
+		vfe_reg_clr(vfe, VFE_0_MODULE_LENS_EN, val_lens);
+		vfe_reg_clr(vfe, VFE_0_MODULE_ZOOM_EN, val_zoom);
 	}
 }
 
@@ -1028,6 +1116,7 @@ const struct vfe_hw_ops vfe_ops_4_7 = {
 	.wm_set_subsample = vfe_wm_set_subsample,
 	.bus_disconnect_wm_from_rdi = vfe_bus_disconnect_wm_from_rdi,
 	.set_xbar_cfg = vfe_set_xbar_cfg,
+	.set_realign_cfg = vfe_set_realign_cfg,
 	.set_rdi_cid = vfe_set_rdi_cid,
 	.reg_update = vfe_reg_update,
 	.reg_update_clear = vfe_reg_update_clear,
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index b3d2cbf..314eed9 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -206,6 +206,9 @@ static u32 vfe_src_pad_code(struct vfe_line *line, u32 sink_code,
 		{
 			u32 src_code[] = {
 				MEDIA_BUS_FMT_YUYV8_2X8,
+				MEDIA_BUS_FMT_YVYU8_2X8,
+				MEDIA_BUS_FMT_UYVY8_2X8,
+				MEDIA_BUS_FMT_VYUY8_2X8,
 				MEDIA_BUS_FMT_YUYV8_1_5X8,
 			};
 
@@ -216,6 +219,9 @@ static u32 vfe_src_pad_code(struct vfe_line *line, u32 sink_code,
 		{
 			u32 src_code[] = {
 				MEDIA_BUS_FMT_YVYU8_2X8,
+				MEDIA_BUS_FMT_YUYV8_2X8,
+				MEDIA_BUS_FMT_UYVY8_2X8,
+				MEDIA_BUS_FMT_VYUY8_2X8,
 				MEDIA_BUS_FMT_YVYU8_1_5X8,
 			};
 
@@ -226,6 +232,9 @@ static u32 vfe_src_pad_code(struct vfe_line *line, u32 sink_code,
 		{
 			u32 src_code[] = {
 				MEDIA_BUS_FMT_UYVY8_2X8,
+				MEDIA_BUS_FMT_YUYV8_2X8,
+				MEDIA_BUS_FMT_YVYU8_2X8,
+				MEDIA_BUS_FMT_VYUY8_2X8,
 				MEDIA_BUS_FMT_UYVY8_1_5X8,
 			};
 
@@ -236,6 +245,9 @@ static u32 vfe_src_pad_code(struct vfe_line *line, u32 sink_code,
 		{
 			u32 src_code[] = {
 				MEDIA_BUS_FMT_VYUY8_2X8,
+				MEDIA_BUS_FMT_YUYV8_2X8,
+				MEDIA_BUS_FMT_YVYU8_2X8,
+				MEDIA_BUS_FMT_UYVY8_2X8,
 				MEDIA_BUS_FMT_VYUY8_1_5X8,
 			};
 
@@ -311,10 +323,6 @@ static void vfe_init_outputs(struct vfe_device *vfe)
 		output->buf[0] = NULL;
 		output->buf[1] = NULL;
 		INIT_LIST_HEAD(&output->pending_bufs);
-
-		output->wm_num = 1;
-		if (vfe->line[i].id == VFE_LINE_PIX)
-			output->wm_num = 2;
 	}
 }
 
@@ -570,6 +578,7 @@ static int vfe_get_output(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output;
+	struct v4l2_format *f = &line->video_out.active_fmt;
 	unsigned long flags;
 	int i;
 	int wm_idx;
@@ -585,6 +594,18 @@ static int vfe_get_output(struct vfe_line *line)
 
 	output->active_buf = 0;
 
+	switch (f->fmt.pix_mp.pixelformat) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		output->wm_num = 2;
+		break;
+	default:
+		output->wm_num = 1;
+		break;
+	}
+
 	for (i = 0; i < output->wm_num; i++) {
 		wm_idx = vfe_reserve_wm(vfe, line->id);
 		if (wm_idx < 0) {
@@ -715,6 +736,7 @@ static int vfe_enable_output(struct vfe_line *line)
 		ops->enable_irq_pix_line(vfe, 0, line->id, 1);
 		ops->set_module_cfg(vfe, 1);
 		ops->set_camif_cfg(vfe, line);
+		ops->set_realign_cfg(vfe, line, 1);
 		ops->set_xbar_cfg(vfe, output, 1);
 		ops->set_demux_cfg(vfe, line);
 		ops->set_scale_cfg(vfe, line);
@@ -779,6 +801,7 @@ static int vfe_disable_output(struct vfe_line *line)
 
 		ops->enable_irq_pix_line(vfe, 0, line->id, 0);
 		ops->set_module_cfg(vfe, 0);
+		ops->set_realign_cfg(vfe, line, 0);
 		ops->set_xbar_cfg(vfe, output, 0);
 
 		ops->set_camif_cmd(vfe, 0);
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
index 764b734..5dcc37f 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss/camss-vfe.h
@@ -107,6 +107,8 @@ struct vfe_hw_ops {
 			     u8 enable);
 	void (*set_rdi_cid)(struct vfe_device *vfe, enum vfe_line_id id,
 			    u8 cid);
+	void (*set_realign_cfg)(struct vfe_device *vfe, struct vfe_line *line,
+				u8 enable);
 	void (*reg_update)(struct vfe_device *vfe, enum vfe_line_id line_id);
 	void (*reg_update_clear)(struct vfe_device *vfe,
 				 enum vfe_line_id line_id);
diff --git a/drivers/media/platform/qcom/camss/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
index ba7d0c4..e6e114a 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -179,6 +179,14 @@ static const struct camss_format_info formats_pix_8x96[] = {
 	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
 	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_NV61, 1,
 	  { { 1, 1 } }, { { 1, 2 } }, { 8 } },
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_UYVY, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_VYUY, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_YUYV, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_YVYU, 1,
+	  { { 1, 1 } }, { { 1, 1 } }, { 16 } },
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.7.4
