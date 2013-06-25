Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:18968 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3FYKxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 06:53:13 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOY00GJC3KOYX20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Jun 2013 19:53:12 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, a.hajda@samsung.com,
	j.anaszewski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 6/6] exynos4-is: Correct colorspace handling at FIMC-LITE
Date: Tue, 25 Jun 2013 12:52:35 +0200
Message-id: <1372157555-29557-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1372157555-29557-1-git-send-email-s.nawrocki@samsung.com>
References: <1372157555-29557-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure the colorspace is properly adjusted by the driver for YUV
and Bayer image formats. The subdev try_fmt helper is simplified.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   17 +++++++++++++----
 include/media/s5p_fimc.h                      |    2 ++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 4fa2e05..08fbfed 100644
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
@@ -577,6 +584,7 @@ static const struct fimc_fmt *fimc_lite_subdev_try_fmt(struct fimc_lite *fimc,
 		if (WARN_ON(!fmt))
 			return NULL;
 
+		mf->colorspace = fmt->colorspace;
 		mf->code = fmt->mbus_code;
 	} else {
 		struct flite_frame *sink = &fimc->inp_frame;
@@ -588,11 +596,13 @@ static const struct fimc_fmt *fimc_lite_subdev_try_fmt(struct fimc_lite *fimc,
 						FLITE_SD_PAD_SINK);
 
 			mf->code = sink_fmt->code;
+			mf->colorspace = sink_fmt->colorspace;
 
 			rect = v4l2_subdev_get_try_crop(fh,
 						FLITE_SD_PAD_SINK);
 		} else {
 			mf->code = sink->fmt->mbus_code;
+			mf->colorspace = sink->fmt->colorspace;
 			rect = &sink->rect;
 		}
 
@@ -696,7 +706,7 @@ static int fimc_lite_g_fmt_mplane(struct file *file, void *fh,
 	pixm->width = frame->f_width;
 	pixm->height = frame->f_height;
 	pixm->field = V4L2_FIELD_NONE;
-	pixm->colorspace = V4L2_COLORSPACE_JPEG;
+	pixm->colorspace = fmt->colorspace;
 	return 0;
 }
 
@@ -739,7 +749,7 @@ static int fimc_lite_try_fmt(struct fimc_lite *fimc,
 						fmt->depth[0]) / 8;
 	pixm->num_planes = fmt->memplanes;
 	pixm->pixelformat = fmt->fourcc;
-	pixm->colorspace = V4L2_COLORSPACE_JPEG;
+	pixm->colorspace = fmt->colorspace;
 	pixm->field = V4L2_FIELD_NONE;
 	return 0;
 }
@@ -1071,9 +1081,9 @@ static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
 		fmt->format = *mf;
 		return 0;
 	}
-	mf->colorspace = V4L2_COLORSPACE_JPEG;
 
 	mutex_lock(&fimc->lock);
+	mf->colorspace = f->fmt->colorspace;
 	mf->code = f->fmt->mbus_code;
 
 	if (fmt->pad == FLITE_SD_PAD_SINK) {
@@ -1102,7 +1112,6 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 	v4l2_dbg(1, debug, sd, "pad%d: code: 0x%x, %dx%d\n",
 		 fmt->pad, mf->code, mf->width, mf->height);
 
-	mf->colorspace = V4L2_COLORSPACE_JPEG;
 	mutex_lock(&fimc->lock);
 
 	if ((atomic_read(&fimc->out_path) == FIMC_IO_ISP &&
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

