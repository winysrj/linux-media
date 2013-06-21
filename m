Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:36258 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422678Ab3FUNB5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 09:01:57 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOQ006OCUV8WF90@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Jun 2013 22:01:56 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, j.anaszewski@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 6/6] exynos4-is: Correct colorspace handling at FIMC-LITE
Date: Fri, 21 Jun 2013 15:00:35 +0200
Message-id: <1371819636-13499-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1371819636-13499-1-git-send-email-s.nawrocki@samsung.com>
References: <1371819636-13499-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure the colorspace is properly adjusted by the driver for YUV
and Bayer image formats. The subdev try_fmt helper is simplified.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   50 +++++++++++++------------
 include/media/s5p_fimc.h                      |    2 +
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index b4a0785..d1e869e 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -44,6 +44,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 	{
 		.name		= "YUV 4:2:2 packed, YCbYCr",
 		.fourcc		= V4L2_PIX_FMT_YUYV,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.depth		= { 16 },
 		.color		= FIMC_FMT_YCBYCR422,
 		.memplanes	= 1,
@@ -52,6 +53,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 	}, {
 		.name		= "YUV 4:2:2 packed, CbYCrY",
 		.fourcc		= V4L2_PIX_FMT_UYVY,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.depth		= { 16 },
 		.color		= FIMC_FMT_CBYCRY422,
 		.memplanes	= 1,
@@ -60,6 +62,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 	}, {
 		.name		= "YUV 4:2:2 packed, CrYCbY",
 		.fourcc		= V4L2_PIX_FMT_VYUY,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.depth		= { 16 },
 		.color		= FIMC_FMT_CRYCBY422,
 		.memplanes	= 1,
@@ -68,6 +71,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 	}, {
 		.name		= "YUV 4:2:2 packed, YCrYCb",
 		.fourcc		= V4L2_PIX_FMT_YVYU,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.depth		= { 16 },
 		.color		= FIMC_FMT_YCRYCB422,
 		.memplanes	= 1,
@@ -76,6 +80,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 	}, {
 		.name		= "RAW8 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG8,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.depth		= { 8 },
 		.color		= FIMC_FMT_RAW8,
 		.memplanes	= 1,
@@ -84,6 +89,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 	}, {
 		.name		= "RAW10 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG10,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.depth		= { 10 },
 		.color		= FIMC_FMT_RAW10,
 		.memplanes	= 1,
@@ -92,6 +98,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 	}, {
 		.name		= "RAW12 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG12,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.depth		= { 12 },
 		.color		= FIMC_FMT_RAW12,
 		.memplanes	= 1,
@@ -560,38 +567,35 @@ static const struct v4l2_file_operations fimc_lite_fops = {
  * Format and crop negotiation helpers
  */
 
-static const struct fimc_fmt *fimc_lite_try_format(struct fimc_lite *fimc,
-					u32 *width, u32 *height,
-					u32 *code, u32 *fourcc, int pad)
+static const struct fimc_fmt *fimc_lite_subdev_try_fmt(struct fimc_lite *fimc,
+					struct v4l2_subdev_format *format)
 {
 	struct flite_drvdata *dd = fimc->dd;
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	const struct fimc_fmt *fmt;
 	unsigned int flags = 0;
 
-	if (pad == FLITE_SD_PAD_SINK) {
-		v4l_bound_align_image(width, 8, dd->max_width,
-				      ffs(dd->out_width_align) - 1,
-				      height, 0, dd->max_height, 0, 0);
+	if (format->pad == FLITE_SD_PAD_SINK) {
+		v4l_bound_align_image(&mf->width, 8, dd->max_width,
+				ffs(dd->out_width_align) - 1,
+				&mf->height, 0, dd->max_height, 0, 0);
 	} else {
-		v4l_bound_align_image(width, 8, fimc->inp_frame.rect.width,
-				      ffs(dd->out_width_align) - 1,
-				      height, 0, fimc->inp_frame.rect.height,
-				      0, 0);
+		v4l_bound_align_image(&mf->width, 8, fimc->inp_frame.rect.width,
+				ffs(dd->out_width_align) - 1,
+				&mf->height, 0, fimc->inp_frame.rect.height,
+				0, 0);
 		flags = fimc->inp_frame.fmt->flags;
 	}
 
-	fmt = fimc_lite_find_format(fourcc, code, flags, 0);
+	fmt = fimc_lite_find_format(NULL, &mf->code, flags, 0);
 	if (WARN_ON(!fmt))
 		return NULL;
 
-	if (code)
-		*code = fmt->mbus_code;
-	if (fourcc)
-		*fourcc = fmt->fourcc;
+	mf->colorspace = fmt->colorspace;
+	mf->code = fmt->mbus_code;
 
 	v4l2_dbg(1, debug, &fimc->subdev, "code: 0x%x, %dx%d\n",
-		 code ? *code : 0, *width, *height);
-
+				mf->code, mf->width, mf->height);
 	return fmt;
 }
 
@@ -682,7 +686,7 @@ static int fimc_lite_g_fmt_mplane(struct file *file, void *fh,
 	pixm->width = frame->f_width;
 	pixm->height = frame->f_height;
 	pixm->field = V4L2_FIELD_NONE;
-	pixm->colorspace = V4L2_COLORSPACE_JPEG;
+	pixm->colorspace = fmt->colorspace;
 	return 0;
 }
 
@@ -725,7 +729,7 @@ static int fimc_lite_try_fmt(struct fimc_lite *fimc,
 						fmt->depth[0]) / 8;
 	pixm->num_planes = fmt->memplanes;
 	pixm->pixelformat = fmt->fourcc;
-	pixm->colorspace = V4L2_COLORSPACE_JPEG;
+	pixm->colorspace = fmt->colorspace;
 	pixm->field = V4L2_FIELD_NONE;
 	return 0;
 }
@@ -1057,9 +1061,9 @@ static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
 		fmt->format = *mf;
 		return 0;
 	}
-	mf->colorspace = V4L2_COLORSPACE_JPEG;
 
 	mutex_lock(&fimc->lock);
+	mf->colorspace = f->fmt->colorspace;
 	mf->code = f->fmt->mbus_code;
 
 	if (fmt->pad == FLITE_SD_PAD_SINK) {
@@ -1088,7 +1092,6 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 	v4l2_dbg(1, debug, sd, "pad%d: code: 0x%x, %dx%d\n",
 		 fmt->pad, mf->code, mf->width, mf->height);
 
-	mf->colorspace = V4L2_COLORSPACE_JPEG;
 	mutex_lock(&fimc->lock);
 
 	if ((atomic_read(&fimc->out_path) == FIMC_IO_ISP &&
@@ -1099,8 +1102,7 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 		return -EBUSY;
 	}
 
-	ffmt = fimc_lite_try_format(fimc, &mf->width, &mf->height,
-				    &mf->code, NULL, fmt->pad);
+	ffmt = fimc_lite_subdev_try_fmt(fimc, fmt);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_mbus_framefmt *src_fmt;
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 0afadb6..b975c28 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -116,6 +116,7 @@ struct s5p_platform_fimc {
  * @color: the driver's private color format id
  * @memplanes: number of physically non-contiguous data planes
  * @colplanes: number of physically contiguous data planes
+ * @colorspace: v4l2 colorspace (V4L2_COLORSPACE_*)
  * @depth: per plane driver's private 'number of bits per pixel'
  * @mdataplanes: bitmask indicating meta data plane(s), (1 << plane_no)
  * @flags: flags indicating which operation mode format applies to
@@ -127,6 +128,7 @@ struct fimc_fmt {
 	u32	color;
 	u16	memplanes;
 	u16	colplanes;
+	u8	colorspace;
 	u8	depth[FIMC_MAX_PLANES];
 	u16	mdataplanes;
 	u16	flags;
-- 
1.7.9.5

