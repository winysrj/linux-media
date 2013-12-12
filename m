Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53163 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3LLIgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 03:36:45 -0500
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <k.debski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 7/8] v4l: ti-vpe: enable CSC support for VPE
Date: Thu, 12 Dec 2013 14:06:03 +0530
Message-ID: <1386837364-1264-8-git-send-email-archit@ti.com>
In-Reply-To: <1386837364-1264-1-git-send-email-archit@ti.com>
References: <1386837364-1264-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the csc library functions to configure the CSC block in VPE.

Some changes are required in try_fmt to handle the pix->colorspace parameter
more correctly. Previously, we copied the source queue colorspace to the
destination queue colorspace as we didn't support RGB formats. Now, we configure
pix->colorspace based on the color format set(and the height of the image if
it's a YUV format).

Add basic RGB color formats to the list of supported vpe formats.

If the destination format is RGB colorspace, we also need to use the RGB output
port instead of the Luma and Chroma output ports. This requires configuring the
output data descriptors differently.

Also, make the default colorspace V4L2_COLORSPACE_SMPTE170M as that resembles
the Standard Definition colorspace more closely.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 95 ++++++++++++++++++++++++++++---------
 1 file changed, 72 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 6c4db57..1296c53 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -267,6 +267,38 @@ static struct vpe_fmt vpe_formats[] = {
 		.vpdma_fmt	= { &vpdma_yuv_fmts[VPDMA_DATA_FMT_CY422],
 				  },
 	},
+	{
+		.name		= "RGB888 packed",
+		.fourcc		= V4L2_PIX_FMT_RGB24,
+		.types		= VPE_FMT_TYPE_CAPTURE,
+		.coplanar	= 0,
+		.vpdma_fmt	= { &vpdma_rgb_fmts[VPDMA_DATA_FMT_RGB24],
+				  },
+	},
+	{
+		.name		= "ARGB32",
+		.fourcc		= V4L2_PIX_FMT_RGB32,
+		.types		= VPE_FMT_TYPE_CAPTURE,
+		.coplanar	= 0,
+		.vpdma_fmt	= { &vpdma_rgb_fmts[VPDMA_DATA_FMT_ARGB32],
+				  },
+	},
+	{
+		.name		= "BGR888 packed",
+		.fourcc		= V4L2_PIX_FMT_BGR24,
+		.types		= VPE_FMT_TYPE_CAPTURE,
+		.coplanar	= 0,
+		.vpdma_fmt	= { &vpdma_rgb_fmts[VPDMA_DATA_FMT_BGR24],
+				  },
+	},
+	{
+		.name		= "ABGR32",
+		.fourcc		= V4L2_PIX_FMT_BGR32,
+		.types		= VPE_FMT_TYPE_CAPTURE,
+		.coplanar	= 0,
+		.vpdma_fmt	= { &vpdma_rgb_fmts[VPDMA_DATA_FMT_ABGR32],
+				  },
+	},
 };
 
 /*
@@ -689,17 +721,20 @@ static void set_src_registers(struct vpe_ctx *ctx)
 static void set_dst_registers(struct vpe_ctx *ctx)
 {
 	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
+	enum v4l2_colorspace clrspc = ctx->q_data[Q_DATA_DST].colorspace;
 	struct vpe_fmt *fmt = ctx->q_data[Q_DATA_DST].fmt;
 	u32 val = 0;
 
-	/* select RGB path when color space conversion is supported in future */
-	if (fmt->fourcc == V4L2_PIX_FMT_RGB24)
-		val |= VPE_RGB_OUT_SELECT | VPE_CSC_SRC_DEI_SCALER;
+	if (clrspc == V4L2_COLORSPACE_SRGB)
+		val |= VPE_RGB_OUT_SELECT;
 	else if (fmt->fourcc == V4L2_PIX_FMT_NV16)
 		val |= VPE_COLOR_SEPARATE_422;
 
-	/* The source of CHR_DS is always the scaler, whether it's used or not */
-	val |= VPE_DS_SRC_DEI_SCALER;
+	/*
+	 * the source of CHR_DS and CSC is always the scaler, irrespective of
+	 * whether it's used or not
+	 */
+	val |= VPE_DS_SRC_DEI_SCALER | VPE_CSC_SRC_DEI_SCALER;
 
 	if (fmt->fourcc != V4L2_PIX_FMT_NV12)
 		val |= VPE_DS_BYPASS;
@@ -813,7 +848,8 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 	set_cfg_and_line_modes(ctx);
 	set_dei_regs(ctx);
 
-	csc_set_coeff_bypass(ctx->dev->csc, &mmr_adb->csc_regs[5]);
+	csc_set_coeff(ctx->dev->csc, &mmr_adb->csc_regs[0],
+		s_q_data->colorspace, d_q_data->colorspace);
 
 	sc_set_hs_coeffs(ctx->dev->sc, ctx->sc_coeff_h.addr, src_w, dst_w);
 	sc_set_vs_coeffs(ctx->dev->sc, ctx->sc_coeff_v.addr, src_h, dst_h);
@@ -1095,9 +1131,13 @@ static void device_run(void *priv)
 	if (ctx->deinterlacing)
 		add_out_dtd(ctx, VPE_PORT_MV_OUT);
 
-	add_out_dtd(ctx, VPE_PORT_LUMA_OUT);
-	if (d_q_data->fmt->coplanar)
-		add_out_dtd(ctx, VPE_PORT_CHROMA_OUT);
+	if (d_q_data->colorspace == V4L2_COLORSPACE_SRGB) {
+		add_out_dtd(ctx, VPE_PORT_RGB_OUT);
+	} else {
+		add_out_dtd(ctx, VPE_PORT_LUMA_OUT);
+		if (d_q_data->fmt->coplanar)
+			add_out_dtd(ctx, VPE_PORT_CHROMA_OUT);
+	}
 
 	/* input data descriptors */
 	if (ctx->deinterlacing) {
@@ -1133,9 +1173,16 @@ static void device_run(void *priv)
 	}
 
 	/* sync on channel control descriptors for output ports */
-	vpdma_add_sync_on_channel_ctd(&ctx->desc_list, VPE_CHAN_LUMA_OUT);
-	if (d_q_data->fmt->coplanar)
-		vpdma_add_sync_on_channel_ctd(&ctx->desc_list, VPE_CHAN_CHROMA_OUT);
+	if (d_q_data->colorspace == V4L2_COLORSPACE_SRGB) {
+		vpdma_add_sync_on_channel_ctd(&ctx->desc_list,
+			VPE_CHAN_RGB_OUT);
+	} else {
+		vpdma_add_sync_on_channel_ctd(&ctx->desc_list,
+			VPE_CHAN_LUMA_OUT);
+		if (d_q_data->fmt->coplanar)
+			vpdma_add_sync_on_channel_ctd(&ctx->desc_list,
+				VPE_CHAN_CHROMA_OUT);
+	}
 
 	if (ctx->deinterlacing)
 		vpdma_add_sync_on_channel_ctd(&ctx->desc_list, VPE_CHAN_MV_OUT);
@@ -1413,16 +1460,18 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	pix->num_planes = fmt->coplanar ? 2 : 1;
 	pix->pixelformat = fmt->fourcc;
 
-	if (type == VPE_FMT_TYPE_CAPTURE) {
-		struct vpe_q_data *s_q_data;
-
-		/* get colorspace from the source queue */
-		s_q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
-
-		pix->colorspace = s_q_data->colorspace;
-	} else {
-		if (!pix->colorspace)
-			pix->colorspace = V4L2_COLORSPACE_SMPTE240M;
+	if (!pix->colorspace) {
+		if (fmt->fourcc == V4L2_PIX_FMT_RGB24 ||
+				fmt->fourcc == V4L2_PIX_FMT_BGR24 ||
+				fmt->fourcc == V4L2_PIX_FMT_RGB32 ||
+				fmt->fourcc == V4L2_PIX_FMT_BGR32) {
+			pix->colorspace = V4L2_COLORSPACE_SRGB;
+		} else {
+			if (pix->height > 1280)	/* HD */
+				pix->colorspace = V4L2_COLORSPACE_REC709;
+			else			/* SD */
+				pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
+		}
 	}
 
 	for (i = 0; i < pix->num_planes; i++) {
@@ -1817,7 +1866,7 @@ static int vpe_open(struct file *file)
 	s_q_data->height = 1080;
 	s_q_data->sizeimage[VPE_LUMA] = (s_q_data->width * s_q_data->height *
 			s_q_data->fmt->vpdma_fmt[VPE_LUMA]->depth) >> 3;
-	s_q_data->colorspace = V4L2_COLORSPACE_SMPTE240M;
+	s_q_data->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	s_q_data->field = V4L2_FIELD_NONE;
 	s_q_data->c_rect.left = 0;
 	s_q_data->c_rect.top = 0;
-- 
1.8.3.2

