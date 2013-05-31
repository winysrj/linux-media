Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:13700 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3EaQsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 12:48:02 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO001RN9C1A010@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Jun 2013 01:48:01 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, yhwan.joo@samsung.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 5/7] exynos4-is: Move __fimc_videoc_querycap() function
 to the common module
Date: Fri, 31 May 2013 18:47:03 +0200
Message-id: <1370018825-13088-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
References: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move __fimc_videoc_querycap() function to the common exynos4-is-common.ko
module so it don't need to be reimplemented in multiple video node drivers
of the exynos4-is.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/common.c    |   12 ++++++++++++
 drivers/media/platform/exynos4-is/common.h    |    4 ++++
 drivers/media/platform/exynos4-is/fimc-core.c |   11 -----------
 drivers/media/platform/exynos4-is/fimc-core.h |    2 --
 drivers/media/platform/exynos4-is/fimc-m2m.c  |    1 +
 5 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/common.c b/drivers/media/platform/exynos4-is/common.c
index 6720520..e427e1d 100644
--- a/drivers/media/platform/exynos4-is/common.c
+++ b/drivers/media/platform/exynos4-is/common.c
@@ -38,4 +38,16 @@ struct v4l2_subdev *fimc_find_remote_sensor(struct media_entity *entity)
 }
 EXPORT_SYMBOL(fimc_find_remote_sensor);
 
+void __fimc_vidioc_querycap(struct device *dev, struct v4l2_capability *cap,
+						unsigned int caps)
+{
+	strlcpy(cap->driver, dev->driver->name, sizeof(cap->driver));
+	strlcpy(cap->card, dev->driver->name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+				"platform:%s", dev_name(dev));
+	cap->device_caps = caps;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+}
+EXPORT_SYMBOL(__fimc_vidioc_querycap);
+
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/exynos4-is/common.h b/drivers/media/platform/exynos4-is/common.h
index 3c39803..75b9c71 100644
--- a/drivers/media/platform/exynos4-is/common.h
+++ b/drivers/media/platform/exynos4-is/common.h
@@ -6,7 +6,11 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/device.h>
+#include <linux/videodev2.h>
 #include <media/media-entity.h>
 #include <media/v4l2-subdev.h>
 
 struct v4l2_subdev *fimc_find_remote_sensor(struct media_entity *entity);
+void __fimc_vidioc_querycap(struct device *dev, struct v4l2_capability *cap,
+			    unsigned int caps);
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index e856730..aa6716e 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -213,17 +213,6 @@ struct fimc_fmt *fimc_get_format(unsigned int index)
 	return &fimc_formats[index];
 }
 
-void __fimc_vidioc_querycap(struct device *dev, struct v4l2_capability *cap,
-						unsigned int caps)
-{
-	strlcpy(cap->driver, dev->driver->name, sizeof(cap->driver));
-	strlcpy(cap->card, dev->driver->name, sizeof(cap->card));
-	snprintf(cap->bus_info, sizeof(cap->bus_info),
-				"platform:%s", dev_name(dev));
-	cap->device_caps = caps;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-}
-
 int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
 			    int dw, int dh, int rotation)
 {
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index bba6b25..0f25ce0 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -621,8 +621,6 @@ static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 /* fimc-core.c */
 int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
 				struct v4l2_fmtdesc *f);
-void __fimc_vidioc_querycap(struct device *dev, struct v4l2_capability *cap,
-						unsigned int caps);
 int fimc_ctrls_create(struct fimc_ctx *ctx);
 void fimc_ctrls_delete(struct fimc_ctx *ctx);
 void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active);
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index bde1f47..8d33b68 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -27,6 +27,7 @@
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 
+#include "common.h"
 #include "fimc-core.h"
 #include "fimc-reg.h"
 #include "media-dev.h"
-- 
1.7.9.5

