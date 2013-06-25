Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:31296 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3FYKuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 06:50:23 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOY00BC53FYLH40@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Jun 2013 19:50:22 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, a.hajda@samsung.com,
	j.anaszewski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/6] exynos4-is: Fix format propagation on FIMC-LITE.n
 subdevs
Date: Tue, 25 Jun 2013 12:48:12 +0200
Message-id: <1372157297-29195-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1372157297-29195-1-git-send-email-s.nawrocki@samsung.com>
References: <1372157297-29195-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-LITE subdevs have one sink pad and two source pads on which the image
formats are always same. This patch implements missing format propagation
from the sink pad to the source pads, to allow user space to negotiate TRY
format on whole media pipeline involving FIMC-LITE.n subdevs. The subdev
try_fmt helper is simplified.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   92 ++++++++++++++++---------
 1 file changed, 59 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 07767c8..993bd79 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -560,37 +560,51 @@ static const struct v4l2_file_operations fimc_lite_fops = {
  * Format and crop negotiation helpers
  */
 
-static const struct fimc_fmt *fimc_lite_try_format(struct fimc_lite *fimc,
-					u32 *width, u32 *height,
-					u32 *code, u32 *fourcc, int pad)
+static const struct fimc_fmt *fimc_lite_subdev_try_fmt(struct fimc_lite *fimc,
+					struct v4l2_subdev_fh *fh,
+					struct v4l2_subdev_format *format)
 {
 	struct flite_drvdata *dd = fimc->dd;
-	const struct fimc_fmt *fmt;
-	unsigned int flags = 0;
+	struct v4l2_mbus_framefmt *mf = &format->format;
+	const struct fimc_fmt *fmt = NULL;
+
+	if (format->pad == FLITE_SD_PAD_SINK) {
+		v4l_bound_align_image(&mf->width, 8, dd->max_width,
+				ffs(dd->out_width_align) - 1,
+				&mf->height, 0, dd->max_height, 0, 0);
 
-	if (pad == FLITE_SD_PAD_SINK) {
-		v4l_bound_align_image(width, 8, dd->max_width,
-				      ffs(dd->out_width_align) - 1,
-				      height, 0, dd->max_height, 0, 0);
+		fmt = fimc_lite_find_format(NULL, &mf->code, 0, 0);
+		if (WARN_ON(!fmt))
+			return NULL;
+
+		mf->code = fmt->mbus_code;
 	} else {
-		v4l_bound_align_image(width, 8, fimc->inp_frame.rect.width,
-				      ffs(dd->out_width_align) - 1,
-				      height, 0, fimc->inp_frame.rect.height,
-				      0, 0);
-		flags = fimc->inp_frame.fmt->flags;
-	}
+		struct flite_frame *sink = &fimc->inp_frame;
+		struct v4l2_mbus_framefmt *sink_fmt;
+		struct v4l2_rect *rect;
 
-	fmt = fimc_lite_find_format(fourcc, code, flags, 0);
-	if (WARN_ON(!fmt))
-		return NULL;
+		if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+			sink_fmt = v4l2_subdev_get_try_format(fh,
+						FLITE_SD_PAD_SINK);
 
-	if (code)
-		*code = fmt->mbus_code;
-	if (fourcc)
-		*fourcc = fmt->fourcc;
+			mf->code = sink_fmt->code;
+
+			rect = v4l2_subdev_get_try_crop(fh,
+						FLITE_SD_PAD_SINK);
+		} else {
+			mf->code = sink->fmt->mbus_code;
+			rect = &sink->rect;
+		}
+
+		/* Allow changing format only on sink pad */
+		mf->width = rect->width;
+		mf->height = rect->height;
+	}
 
-	v4l2_dbg(1, debug, &fimc->subdev, "code: 0x%x, %dx%d\n",
-		 code ? *code : 0, *width, *height);
+	mf->field = V4L2_FIELD_NONE;
+
+	v4l2_dbg(1, debug, &fimc->subdev, "code: %#x (%d), %dx%d\n",
+		 mf->code, mf->colorspace, mf->width, mf->height);
 
 	return fmt;
 }
@@ -1035,6 +1049,15 @@ static int fimc_lite_subdev_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static struct v4l2_mbus_framefmt *__fimc_lite_subdev_get_try_fmt(
+			struct v4l2_subdev_fh *fh, unsigned int pad)
+{
+	if (pad != FLITE_SD_PAD_SINK)
+		pad = FLITE_SD_PAD_SOURCE_DMA;
+
+	return v4l2_subdev_get_try_format(fh, pad);
+}
+
 static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
 				    struct v4l2_subdev_fh *fh,
 				    struct v4l2_subdev_format *fmt)
@@ -1044,7 +1067,7 @@ static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
 	struct flite_frame *f = &fimc->inp_frame;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf = __fimc_lite_subdev_get_try_fmt(fh, fmt->pad);
 		fmt->format = *mf;
 		return 0;
 	}
@@ -1090,12 +1113,20 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 		return -EBUSY;
 	}
 
-	ffmt = fimc_lite_try_format(fimc, &mf->width, &mf->height,
-				    &mf->code, NULL, fmt->pad);
+	ffmt = fimc_lite_subdev_try_fmt(fimc, fh, fmt);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		struct v4l2_mbus_framefmt *src_fmt;
+
+		mf = __fimc_lite_subdev_get_try_fmt(fh, fmt->pad);
 		*mf = fmt->format;
+
+		if (fmt->pad == FLITE_SD_PAD_SINK) {
+			unsigned int pad = FLITE_SD_PAD_SOURCE_DMA;
+			src_fmt = __fimc_lite_subdev_get_try_fmt(fh, pad);
+			*src_fmt = *mf;
+		}
+
 		mutex_unlock(&fimc->lock);
 		return 0;
 	}
@@ -1113,11 +1144,6 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 		source->rect = sink->rect;
 		source->f_width = mf->width;
 		source->f_height = mf->height;
-	} else {
-		/* Allow changing format only on sink pad */
-		mf->code = sink->fmt->mbus_code;
-		mf->width = sink->rect.width;
-		mf->height = sink->rect.height;
 	}
 
 	mutex_unlock(&fimc->lock);
-- 
1.7.9.5

