Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40311 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752390AbdHHNa7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:30:59 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 14/21] camss: vfe: Support for frame padding
Date: Tue,  8 Aug 2017 16:30:11 +0300
Message-Id: <1502199018-28250-15-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for horizontal and vertical frame padding.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 85 +++++++++++++++++-----
 .../media/platform/qcom/camss-8x16/camss-video.c   | 53 ++++++++++----
 .../media/platform/qcom/camss-8x16/camss-video.h   |  2 +
 3 files changed, 109 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
index 44605e0..de9f1ae 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
@@ -300,21 +300,75 @@ static void vfe_wm_frame_based(struct vfe_device *vfe, u8 wm, u8 enable)
 			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT);
 }
 
+#define CALC_WORD(width, M, N) (((width) * (M) + (N) - 1) / (N))
+
+static int vfe_word_per_line(uint32_t format, uint32_t pixel_per_line)
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
 static void vfe_wm_line_based(struct vfe_device *vfe, u32 wm,
-			      u16 width, u16 height, u32 enable)
+			      struct v4l2_pix_format_mplane *pix,
+			      u8 plane, u32 enable)
 {
 	u32 reg;
 
 	if (enable) {
+		u16 width = 0, height = 0, bytesperline = 0, wpl;
+
+		vfe_get_wm_sizes(pix, plane, &width, &height, &bytesperline);
+
+		wpl = vfe_word_per_line(pix->pixelformat, width);
+
 		reg = height - 1;
-		reg |= (width / 16 - 1) << 16;
+		reg |= ((wpl + 1) / 2 - 1) << 16;
 
 		writel_relaxed(reg, vfe->base +
 			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
 
+		wpl = vfe_word_per_line(pix->pixelformat, bytesperline);
+
 		reg = 0x3;
 		reg |= (height - 1) << 4;
-		reg |= (width / 8) << 16;
+		reg |= wpl << 16;
 
 		writel_relaxed(reg, vfe->base +
 			       VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(wm));
@@ -1231,25 +1285,14 @@ static int vfe_enable_output(struct vfe_line *line)
 	} else {
 		ub_size /= output->wm_num;
 		for (i = 0; i < output->wm_num; i++) {
-			u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
-
 			vfe_set_cgc_override(vfe, output->wm_idx[i], 1);
 			vfe_wm_set_subsample(vfe, output->wm_idx[i]);
 			vfe_wm_set_ub_cfg(vfe, output->wm_idx[i],
 					  (ub_size + 1) * output->wm_idx[i],
 					  ub_size);
-			if ((i == 1) &&	(p == V4L2_PIX_FMT_NV12 ||
-						p == V4L2_PIX_FMT_NV21))
-				vfe_wm_line_based(vfe, output->wm_idx[i],
-						  line->fmt[MSM_VFE_PAD_SRC].width,
-						  line->fmt[MSM_VFE_PAD_SRC].height / 2,
-						  1);
-			else
-				vfe_wm_line_based(vfe, output->wm_idx[i],
-						  line->fmt[MSM_VFE_PAD_SRC].width,
-						  line->fmt[MSM_VFE_PAD_SRC].height,
-						  1);
-
+			vfe_wm_line_based(vfe, output->wm_idx[i],
+					&line->video_out.active_fmt.fmt.pix_mp,
+					i, 1);
 			vfe_wm_enable(vfe, output->wm_idx[i], 1);
 			vfe_bus_reload_wm(vfe, output->wm_idx[i]);
 		}
@@ -1311,7 +1354,7 @@ static int vfe_disable_output(struct vfe_line *line)
 		spin_unlock_irqrestore(&vfe->output_lock, flags);
 	} else {
 		for (i = 0; i < output->wm_num; i++) {
-			vfe_wm_line_based(vfe, output->wm_idx[i], 0, 0, 0);
+			vfe_wm_line_based(vfe, output->wm_idx[i], NULL, i, 0);
 			vfe_set_cgc_override(vfe, output->wm_idx[i], 0);
 		}
 
@@ -2395,6 +2438,12 @@ int msm_vfe_register_entities(struct vfe_device *vfe,
 		}
 
 		video_out->ops = &camss_vfe_video_ops;
+		video_out->bpl_alignment = 8;
+		video_out->line_based = 0;
+		if (i == VFE_LINE_PIX) {
+			video_out->bpl_alignment = 16;
+			video_out->line_based = 1;
+		}
 		snprintf(name, ARRAY_SIZE(name), "%s%d_%s%d",
 			 MSM_VFE_NAME, vfe->id, "video", i);
 		ret = msm_video_register(video_out, v4l2_dev, name,
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-video.c b/drivers/media/platform/qcom/camss-8x16/camss-video.c
index 8a45314..cf4219e 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-video.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-video.c
@@ -150,6 +150,7 @@ static int video_find_format(u32 code, u32 pixelformat,
  * @mbus: v4l2_mbus_framefmt format (input)
  * @pix: v4l2_pix_format_mplane format (output)
  * @f: a pointer to formats array element to be used for the conversion
+ * @alignment: bytesperline alignment value
  *
  * Fill the output pix structure with information from the input mbus format.
  *
@@ -157,7 +158,8 @@ static int video_find_format(u32 code, u32 pixelformat,
  */
 static int video_mbus_to_pix_mp(const struct v4l2_mbus_framefmt *mbus,
 				struct v4l2_pix_format_mplane *pix,
-				const struct camss_format_info *f)
+				const struct camss_format_info *f,
+				unsigned int alignment)
 {
 	unsigned int i;
 	u32 bytesperline;
@@ -169,7 +171,7 @@ static int video_mbus_to_pix_mp(const struct v4l2_mbus_framefmt *mbus,
 	for (i = 0; i < pix->num_planes; i++) {
 		bytesperline = pix->width / f->hsub[i].numerator *
 			f->hsub[i].denominator * f->bpp[i] / 8;
-		bytesperline = ALIGN(bytesperline, 8);
+		bytesperline = ALIGN(bytesperline, alignment);
 		pix->plane_fmt[i].bytesperline = bytesperline;
 		pix->plane_fmt[i].sizeimage = pix->height /
 				f->vsub[i].numerator * f->vsub[i].denominator *
@@ -223,7 +225,7 @@ static int video_get_subdev_format(struct camss_video *video,
 	format->type = video->type;
 
 	return video_mbus_to_pix_mp(&fmt.format, &format->fmt.pix_mp,
-				    &video->formats[ret]);
+				    &video->formats[ret], video->bpl_alignment);
 }
 
 /* -----------------------------------------------------------------------------
@@ -323,7 +325,6 @@ static int video_check_format(struct camss_video *video)
 	struct v4l2_pix_format_mplane *pix = &video->active_fmt.fmt.pix_mp;
 	struct v4l2_format format;
 	struct v4l2_pix_format_mplane *sd_pix = &format.fmt.pix_mp;
-	unsigned int i;
 	int ret;
 
 	sd_pix->pixelformat = pix->pixelformat;
@@ -338,13 +339,6 @@ static int video_check_format(struct camss_video *video)
 	    pix->field != format.fmt.pix_mp.field)
 		return -EPIPE;
 
-	for (i = 0; i < pix->num_planes; i++)
-		if (pix->plane_fmt[i].bytesperline !=
-				sd_pix->plane_fmt[i].bytesperline ||
-		    pix->plane_fmt[i].sizeimage !=
-				sd_pix->plane_fmt[i].sizeimage)
-			return -EINVAL;
-
 	return 0;
 }
 
@@ -498,12 +492,25 @@ static int __video_try_fmt(struct camss_video *video, struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *pix_mp;
 	const struct camss_format_info *fi;
+	struct v4l2_plane_pix_format *p;
+	u32 bytesperline[3] = { 0 };
+	u32 sizeimage[3] = { 0 };
 	u32 width, height;
-	u32 bpl;
+	u32 bpl, lines;
 	int i, j;
 
 	pix_mp = &f->fmt.pix_mp;
 
+	if (video->line_based)
+		for (i = 0; i < pix_mp->num_planes && i < 3; i++) {
+			p = &pix_mp->plane_fmt[i];
+			bytesperline[i] = clamp_t(u32, p->bytesperline,
+						  1, 65528);
+			sizeimage[i] = clamp_t(u32, p->sizeimage,
+					       bytesperline[i],
+					       bytesperline[i] * 4096);
+		}
+
 	for (j = 0; j < video->nformats; j++)
 		if (pix_mp->pixelformat == video->formats[j].pixelformat)
 			break;
@@ -524,7 +531,7 @@ static int __video_try_fmt(struct camss_video *video, struct v4l2_format *f)
 	for (i = 0; i < pix_mp->num_planes; i++) {
 		bpl = pix_mp->width / fi->hsub[i].numerator *
 			fi->hsub[i].denominator * fi->bpp[i] / 8;
-		bpl = ALIGN(bpl, 8);
+		bpl = ALIGN(bpl, video->bpl_alignment);
 		pix_mp->plane_fmt[i].bytesperline = bpl;
 		pix_mp->plane_fmt[i].sizeimage = pix_mp->height /
 			fi->vsub[i].numerator * fi->vsub[i].denominator * bpl;
@@ -538,6 +545,26 @@ static int __video_try_fmt(struct camss_video *video, struct v4l2_format *f)
 					pix_mp->colorspace, pix_mp->ycbcr_enc);
 	pix_mp->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(pix_mp->colorspace);
 
+	if (video->line_based)
+		for (i = 0; i < pix_mp->num_planes; i++) {
+			p = &pix_mp->plane_fmt[i];
+			p->bytesperline = clamp_t(u32, p->bytesperline,
+						  1, 65528);
+			p->sizeimage = clamp_t(u32, p->sizeimage,
+					       p->bytesperline,
+					       p->bytesperline * 4096);
+			lines = p->sizeimage / p->bytesperline;
+
+			if (p->bytesperline < bytesperline[i])
+				p->bytesperline = ALIGN(bytesperline[i], 8);
+
+			if (p->sizeimage < p->bytesperline * lines)
+				p->sizeimage = p->bytesperline * lines;
+
+			if (p->sizeimage < sizeimage[i])
+				p->sizeimage = sizeimage[i];
+		}
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-video.h b/drivers/media/platform/qcom/camss-8x16/camss-video.h
index e3b459f..38bd1f2 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-video.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-video.h
@@ -54,6 +54,8 @@ struct camss_video {
 	const struct camss_video_ops *ops;
 	struct mutex lock;
 	struct mutex q_lock;
+	unsigned int bpl_alignment;
+	unsigned int line_based;
 	const struct camss_format_info *formats;
 	unsigned int nformats;
 };
-- 
2.7.4
