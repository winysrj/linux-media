Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:13607 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422719Ab3FUNAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 09:00:48 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOQ001D8USPDT50@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Jun 2013 22:00:47 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, j.anaszewski@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/6] exynos4-is: Fix format propagation on FIMC-IS-ISP subdev
Date: Fri, 21 Jun 2013 15:00:32 +0200
Message-id: <1371819636-13499-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure TRY formats are propagated from the sink pad to the source pads
of the FIMC-IS-ISP subdev and the TRY and ACTIVE formats are separated.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-isp.c |   90 ++++++++++++++++++--------
 drivers/media/platform/exynos4-is/fimc-isp.h |    3 +-
 2 files changed, 64 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index eda8134..9a37272 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -129,31 +129,26 @@ static int fimc_isp_subdev_get_fmt(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_format *fmt)
 {
 	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
-	struct fimc_is *is = fimc_isp_to_is(isp);
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
-	struct v4l2_mbus_framefmt cur_fmt;

 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
-		fmt->format = *mf;
+		*mf = *v4l2_subdev_get_try_format(fh, fmt->pad);
 		return 0;
 	}

 	mf->colorspace = V4L2_COLORSPACE_SRGB;

 	mutex_lock(&isp->subdev_lock);
-	__is_get_frame_size(is, &cur_fmt);

 	if (fmt->pad == FIMC_ISP_SD_PAD_SINK) {
-		/* full camera input frame size */
-		mf->width = cur_fmt.width + FIMC_ISP_CAC_MARGIN_WIDTH;
-		mf->height = cur_fmt.height + FIMC_ISP_CAC_MARGIN_HEIGHT;
-		mf->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		/* ISP OTF input image format */
+		*mf = isp->sink_fmt;
 	} else {
-		/* crop size */
-		mf->width = cur_fmt.width;
-		mf->height = cur_fmt.height;
-		mf->code = V4L2_MBUS_FMT_YUV10_1X30;
+		/* ISP OTF output image format */
+		*mf = isp->src_fmt;
+
+		if (fmt->pad == FIMC_ISP_SD_PAD_SRC_FIFO)
+			mf->code = V4L2_MBUS_FMT_YUV10_1X30;
 	}

 	mutex_unlock(&isp->subdev_lock);
@@ -165,21 +160,37 @@ static int fimc_isp_subdev_get_fmt(struct v4l2_subdev *sd,
 }

 static void __isp_subdev_try_format(struct fimc_isp *isp,
-				   struct v4l2_subdev_format *fmt)
+				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_format *fmt)
 {
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
+	struct v4l2_mbus_framefmt *format;
+
+	mf->colorspace = V4L2_COLORSPACE_SRGB;

 	if (fmt->pad == FIMC_ISP_SD_PAD_SINK) {
 		v4l_bound_align_image(&mf->width, FIMC_ISP_SINK_WIDTH_MIN,
 				FIMC_ISP_SINK_WIDTH_MAX, 0,
 				&mf->height, FIMC_ISP_SINK_HEIGHT_MIN,
 				FIMC_ISP_SINK_HEIGHT_MAX, 0, 0);
-		isp->subdev_fmt = *mf;
+		mf->code = V4L2_MBUS_FMT_SGRBG10_1X10;
 	} else {
+		if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
+			format = v4l2_subdev_get_try_format(fh,
+						FIMC_ISP_SD_PAD_SINK);
+		else
+			format = &isp->sink_fmt;
+
 		/* Allow changing format only on sink pad */
-		mf->width = isp->subdev_fmt.width - FIMC_ISP_CAC_MARGIN_WIDTH;
-		mf->height = isp->subdev_fmt.height - FIMC_ISP_CAC_MARGIN_HEIGHT;
-		mf->code = isp->subdev_fmt.code;
+		mf->width = format->width - FIMC_ISP_CAC_MARGIN_WIDTH;
+		mf->height = format->height - FIMC_ISP_CAC_MARGIN_HEIGHT;
+
+		if (fmt->pad == FIMC_ISP_SD_PAD_SRC_FIFO) {
+			mf->code = V4L2_MBUS_FMT_YUV10_1X30;
+			mf->colorspace = V4L2_COLORSPACE_JPEG;
+		} else {
+			mf->code = format->code;
+		}
 	}
 }

@@ -195,24 +206,47 @@ static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
 	isp_dbg(1, sd, "%s: pad%d: code: 0x%x, %dx%d\n",
 		 __func__, fmt->pad, mf->code, mf->width, mf->height);

-	mf->colorspace = V4L2_COLORSPACE_SRGB;
-
 	mutex_lock(&isp->subdev_lock);
-	__isp_subdev_try_format(isp, fmt);
+	__isp_subdev_try_format(isp, fh, fmt);

 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
 		*mf = fmt->format;
-		mutex_unlock(&isp->subdev_lock);
-		return 0;
+
+		/* Propagate format to the source pads */
+		if (fmt->pad == FIMC_ISP_SD_PAD_SINK) {
+			struct v4l2_subdev_format format = *fmt;
+			unsigned int pad;
+
+			for (pad = FIMC_ISP_SD_PAD_SRC_FIFO;
+					pad < FIMC_ISP_SD_PADS_NUM; pad++) {
+				format.pad = pad;
+				__isp_subdev_try_format(isp, fh, &format);
+				mf = v4l2_subdev_get_try_format(fh, pad);
+				*mf = format.format;
+			}
+		}
+	} else {
+		if (sd->entity.stream_count == 0) {
+			if (fmt->pad == FIMC_ISP_SD_PAD_SINK) {
+				struct v4l2_subdev_format format = *fmt;
+
+				isp->sink_fmt = *mf;
+
+				format.pad = FIMC_ISP_SD_PAD_SRC_DMA;
+				__isp_subdev_try_format(isp, fh, &format);
+
+				isp->src_fmt = format.format;
+				__is_set_frame_size(is, &isp->src_fmt);
+			} else {
+				isp->src_fmt = *mf;
+			}
+		} else {
+			ret = -EBUSY;
+		}
 	}

-	if (sd->entity.stream_count == 0)
-		__is_set_frame_size(is, mf);
-	else
-		ret = -EBUSY;
 	mutex_unlock(&isp->subdev_lock);
-
 	return ret;
 }

diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index 0aa2a54..4dc55a1 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -164,7 +164,8 @@ struct fimc_isp {
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct v4l2_subdev		subdev;
 	struct media_pad		subdev_pads[FIMC_ISP_SD_PADS_NUM];
-	struct v4l2_mbus_framefmt	subdev_fmt;
+	struct v4l2_mbus_framefmt	src_fmt;
+	struct v4l2_mbus_framefmt	sink_fmt;
 	struct v4l2_ctrl		*test_pattern;
 	struct fimc_isp_ctrls		ctrls;

--
1.7.9.5

