Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:56017 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752175AbdFSO4r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 10:56:47 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 13/19] camss: vfe: Support for frame padding
Date: Mon, 19 Jun 2017 17:48:33 +0300
Message-Id: <1497883719-12410-14-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for horizontal and vertical frame padding.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss-8x16/vfe.c   | 86 ++++++++++++++++++++------
 drivers/media/platform/qcom/camss-8x16/video.c | 66 +++++++++++++++-----
 drivers/media/platform/qcom/camss-8x16/video.h |  2 +
 3 files changed, 118 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/vfe.c b/drivers/media/platform/qcom/camss-8x16/vfe.c
index 0964e23..433a54e 100644
--- a/drivers/media/platform/qcom/camss-8x16/vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/vfe.c
@@ -279,21 +279,75 @@ static void vfe_wm_frame_based(struct vfe_device *vfe, u8 wm, u8 enable)
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
@@ -1197,25 +1251,14 @@ static int vfe_enable_output(struct vfe_line *line)
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
@@ -1277,7 +1320,7 @@ static int vfe_disable_output(struct vfe_line *line)
 		spin_unlock_irqrestore(&vfe->output_lock, flags);
 	} else {
 		for (i = 0; i < output->wm_num; i++) {
-			vfe_wm_line_based(vfe, output->wm_idx[i], 0, 0, 0);
+			vfe_wm_line_based(vfe, output->wm_idx[i], NULL, i, 0);
 			vfe_set_cgc_override(vfe, output->wm_idx[i], 0);
 		}
 
@@ -2356,9 +2399,14 @@ int msm_vfe_register_entities(struct vfe_device *vfe,
 		}
 
 		video_out->ops = &camss_vfe_video_ops;
+		video_out->bpl_alignment = 8;
+		video_out->line_based = 0;
 		video_out->fmt_tag = CAMSS_FMT_TAG_RDI;
-		if (i == VFE_LINE_PIX)
+		if (i == VFE_LINE_PIX) {
+			video_out->bpl_alignment = 16;
+			video_out->line_based = 1;
 			video_out->fmt_tag = CAMSS_FMT_TAG_PIX;
+		}
 		snprintf(name, ARRAY_SIZE(name), "%s%d_%s%d",
 			 MSM_VFE_NAME, vfe->id, "video", i);
 		ret = msm_video_register(video_out, v4l2_dev, name);
diff --git a/drivers/media/platform/qcom/camss-8x16/video.c b/drivers/media/platform/qcom/camss-8x16/video.c
index 36c949d..1104544 100644
--- a/drivers/media/platform/qcom/camss-8x16/video.c
+++ b/drivers/media/platform/qcom/camss-8x16/video.c
@@ -194,13 +194,15 @@ static int video_find_format_n(u32 code, u32 index, enum camss_fmt_tag tag)
  * @mbus: v4l2_mbus_framefmt format
  * @pix: v4l2_pix_format_mplane format (output)
  * @index: index of an entry in formats array to be used for the conversion
+ * @alignment: bytesperline alignment value
  *
  * Fill the output pix structure with information from the input mbus format.
  *
  * Return 0 on success or a negative error code otherwise
  */
 static int video_mbus_to_pix_mp(const struct v4l2_mbus_framefmt *mbus,
-				struct v4l2_pix_format_mplane *pix, int index)
+				struct v4l2_pix_format_mplane *pix, int index,
+				unsigned int alignment)
 {
 	const struct format_info *f;
 	unsigned int i;
@@ -215,7 +217,7 @@ static int video_mbus_to_pix_mp(const struct v4l2_mbus_framefmt *mbus,
 	for (i = 0; i < pix->num_planes; i++) {
 		bytesperline = pix->width / f->hsub[i].numerator *
 			f->hsub[i].denominator * f->bpp[i] / 8;
-		bytesperline = ALIGN(bytesperline, 8);
+		bytesperline = ALIGN(bytesperline, alignment);
 		pix->plane_fmt[i].bytesperline = bytesperline;
 		pix->plane_fmt[i].sizeimage = pix->height /
 				f->vsub[i].numerator * f->vsub[i].denominator *
@@ -270,7 +272,8 @@ static int video_get_subdev_format(struct camss_video *video,
 	if (ret < 0)
 		return ret;
 
-	return video_mbus_to_pix_mp(&fmt.format, &format->fmt.pix_mp, ret);
+	return video_mbus_to_pix_mp(&fmt.format, &format->fmt.pix_mp, ret,
+				    video->bpl_alignment);
 }
 
 static int video_get_pixelformat(struct camss_video *video, u32 *pixelformat,
@@ -398,7 +401,6 @@ static int video_check_format(struct camss_video *video)
 	struct v4l2_pix_format_mplane *pix = &video->active_fmt.fmt.pix_mp;
 	struct v4l2_pix_format_mplane *sd_pix;
 	struct v4l2_format format;
-	unsigned int i;
 	int ret;
 
 	sd_pix = &format.fmt.pix_mp;
@@ -414,13 +416,6 @@ static int video_check_format(struct camss_video *video)
 	    pix->field != format.fmt.pix_mp.field)
 		return -EINVAL;
 
-	for (i = 0; i < pix->num_planes; i++)
-		if (pix->plane_fmt[i].bytesperline !=
-				sd_pix->plane_fmt[i].bytesperline ||
-		    pix->plane_fmt[i].sizeimage !=
-				sd_pix->plane_fmt[i].sizeimage)
-			return -EINVAL;
-
 	return 0;
 }
 
@@ -548,31 +543,68 @@ static int video_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 	return 0;
 }
 
-static int video_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
+static int video_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
 {
 	struct camss_video *video = video_drvdata(file);
+	struct v4l2_plane_pix_format *p;
+	u32 bytesperline[3] = { 0 };
+	u32 sizeimage[3] = { 0 };
+	u32 lines;
 	int ret;
+	int i;
 
 	if (f->type != video->type)
 		return -EINVAL;
 
+	if (video->line_based)
+		for (i = 0; i < f->fmt.pix_mp.num_planes && i < 3; i++) {
+			p = &f->fmt.pix_mp.plane_fmt[i];
+			bytesperline[i] = clamp_t(u32, p->bytesperline,
+						  1, 65528);
+			sizeimage[i] = clamp_t(u32, p->sizeimage,
+					       bytesperline[i],
+					       bytesperline[i] * 4096);
+		}
+
 	ret = video_get_subdev_format(video, f);
 	if (ret < 0)
 		return ret;
 
-	video->active_fmt = *f;
+	if (video->line_based)
+		for (i = 0; i < f->fmt.pix_mp.num_planes; i++) {
+			p = &f->fmt.pix_mp.plane_fmt[i];
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
 
 	return 0;
 }
 
-static int video_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
+static int video_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
 {
 	struct camss_video *video = video_drvdata(file);
+	int ret;
 
-	if (f->type != video->type)
-		return -EINVAL;
+	ret = video_try_fmt(file, fh, f);
+	if (ret < 0)
+		return ret;
 
-	return video_get_subdev_format(video, f);
+	video->active_fmt = *f;
+
+	return 0;
 }
 
 static int video_enum_input(struct file *file, void *fh,
diff --git a/drivers/media/platform/qcom/camss-8x16/video.h b/drivers/media/platform/qcom/camss-8x16/video.h
index 8f06c92..5130964 100644
--- a/drivers/media/platform/qcom/camss-8x16/video.h
+++ b/drivers/media/platform/qcom/camss-8x16/video.h
@@ -57,6 +57,8 @@ struct camss_video {
 	const struct camss_video_ops *ops;
 	struct mutex lock;
 	struct mutex q_lock;
+	unsigned int bpl_alignment;
+	unsigned int line_based;
 	enum camss_fmt_tag fmt_tag;
 };
 
-- 
1.9.1
