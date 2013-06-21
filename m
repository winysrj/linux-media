Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:13289 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3FUM4X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 08:56:23 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOQ002WIULV6I40@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Jun 2013 21:56:22 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, j.anaszewski@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/6] exynos4-is: Fix format propagation on FIMC-LITE.n subdevs
Date: Fri, 21 Jun 2013 14:55:53 +0200
Message-id: <1371819358-13106-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1371819358-13106-1-git-send-email-s.nawrocki@samsung.com>
References: <1371819358-13106-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-LITE subdevs have one sink pad and two source pads on which
the image formats are always same. This patch implements missing
format propagation from the sink pad to the source pads, to allow
user space to negotiate TRY format on whole media pipeline
involving FIMC-LITE.n subdevs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 07767c8..e51ef75 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1035,6 +1035,15 @@ static int fimc_lite_subdev_enum_mbus_code(struct v4l2_subdev *sd,
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
@@ -1044,7 +1053,7 @@ static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
 	struct flite_frame *f = &fimc->inp_frame;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf = __fimc_lite_subdev_get_try_fmt(fh, fmt->pad);
 		fmt->format = *mf;
 		return 0;
 	}
@@ -1094,8 +1103,17 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 				    &mf->code, NULL, fmt->pad);
 
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
-- 
1.7.9.5

