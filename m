Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:11469 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3EaQsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 12:48:07 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO0025J9BXB9O0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Jun 2013 01:48:06 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, yhwan.joo@samsung.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 6/7] exynos4-is: Add isp_dbg() macro
Date: Fri, 31 May 2013 18:47:04 +0200
Message-id: <1370018825-13088-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
References: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a debug trace macro for the FIMC-IS ISP subdev
and video node drivers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-isp.c |   16 ++++++++--------
 drivers/media/platform/exynos4-is/fimc-isp.h |    5 +++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 3a29e41..ecb82a9 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -30,8 +30,8 @@
 #include "fimc-is-regs.h"
 #include "fimc-is.h"
 
-static int debug;
-module_param_named(debug_isp, debug, int, S_IRUGO | S_IWUSR);
+int fimc_isp_debug;
+module_param_named(debug_isp, fimc_isp_debug, int, S_IRUGO | S_IWUSR);
 
 static const struct fimc_fmt fimc_isp_formats[FIMC_ISP_NUM_FORMATS] = {
 	{
@@ -157,8 +157,8 @@ static int fimc_isp_subdev_get_fmt(struct v4l2_subdev *sd,
 
 	mutex_unlock(&isp->subdev_lock);
 
-	v4l2_dbg(1, debug, sd, "%s: pad%d: fmt: 0x%x, %dx%d\n",
-		 __func__, fmt->pad, mf->code, mf->width, mf->height);
+	isp_dbg(1, sd, "%s: pad%d: fmt: 0x%x, %dx%d\n", __func__,
+		fmt->pad, mf->code, mf->width, mf->height);
 
 	return 0;
 }
@@ -191,7 +191,7 @@ static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
 	int ret = 0;
 
-	v4l2_dbg(1, debug, sd, "%s: pad%d: code: 0x%x, %dx%d\n",
+	isp_dbg(1, sd, "%s: pad%d: code: 0x%x, %dx%d\n",
 		 __func__, fmt->pad, mf->code, mf->width, mf->height);
 
 	mf->colorspace = V4L2_COLORSPACE_SRGB;
@@ -221,7 +221,7 @@ static int fimc_isp_subdev_s_stream(struct v4l2_subdev *sd, int on)
 	struct fimc_is *is = fimc_isp_to_is(isp);
 	int ret;
 
-	v4l2_dbg(1, debug, sd, "%s: on: %d\n", __func__, on);
+	isp_dbg(1, sd, "%s: on: %d\n", __func__, on);
 
 	if (!test_bit(IS_ST_INIT_DONE, &is->state))
 		return -EBUSY;
@@ -235,8 +235,8 @@ static int fimc_isp_subdev_s_stream(struct v4l2_subdev *sd, int on)
 				return ret;
 		}
 
-		v4l2_dbg(1, debug, sd, "changing mode to %d\n",
-						is->config_index);
+		isp_dbg(1, sd, "changing mode to %d\n", is->config_index);
+
 		ret = fimc_is_itf_mode_change(is);
 		if (ret)
 			return -EINVAL;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index f5c802c..756063e 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -26,6 +26,11 @@
 #include <media/v4l2-mediabus.h>
 #include <media/s5p_fimc.h>
 
+extern int fimc_isp_debug;
+
+#define isp_dbg(level, dev, fmt, arg...) \
+	v4l2_dbg(level, fimc_isp_debug, dev, fmt, ## arg)
+
 /* FIXME: revisit these constraints */
 #define FIMC_ISP_SINK_WIDTH_MIN		(16 + 8)
 #define FIMC_ISP_SINK_HEIGHT_MIN	(12 + 8)
-- 
1.7.9.5

