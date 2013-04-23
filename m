Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48995 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab3DWOjr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 10:39:47 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLP00JN8Q29ZW20@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Apr 2013 23:39:45 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] exynos4-is: Fix driver name reported in vidioc_querycap
Date: Tue, 23 Apr 2013 16:39:03 +0200
Message-id: <1366727943-26692-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Originally struct v4l2_capability driver and card name was filled
with name of the platform device. After switching to the device tree
the device names have changed and now are 4 different driver names
reported, depending on the video device opened. So instead of e.g.
"exynos4-fimc" there is now one of: 11800000.fimc, 11810000.fimc,
11820000.fimc, 11830000.fimc.

Fix this by using dev->driver_name, rather than platform device name.
A common vidioc_querycap function is created for both M2M and capture
video node.
This fixes any breakage at user space should any application/library
rely on the driver's name.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |   11 ++++-------
 drivers/media/platform/exynos4-is/fimc-core.c    |   13 ++++++++++++-
 drivers/media/platform/exynos4-is/fimc-core.h    |    4 +++-
 drivers/media/platform/exynos4-is/fimc-m2m.c     |   12 +++++-------
 4 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index da1a4e1..0e04ba1 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -742,16 +742,13 @@ static void fimc_capture_try_selection(struct fimc_ctx *ctx,
 /*
  * The video node ioctl operations
  */
-static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
+static int fimc_cap_querycap(struct file *file, void *priv,
 					struct v4l2_capability *cap)
 {
 	struct fimc_dev *fimc = video_drvdata(file);

-	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
-	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
-	cap->bus_info[0] = 0;
-	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE_MPLANE;
-
+	__fimc_vidioc_querycap(&fimc->pdev->dev, cap, V4L2_CAP_STREAMING |
+					V4L2_CAP_VIDEO_CAPTURE_MPLANE);
 	return 0;
 }

@@ -1375,7 +1372,7 @@ static int fimc_cap_s_selection(struct file *file, void *fh,
 }

 static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
-	.vidioc_querycap		= fimc_vidioc_querycap_capture,
+	.vidioc_querycap		= fimc_cap_querycap,

 	.vidioc_enum_fmt_vid_cap_mplane	= fimc_cap_enum_fmt_mplane,
 	.vidioc_try_fmt_vid_cap_mplane	= fimc_cap_try_fmt_mplane,
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index e6b4cd1..b47c10b 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -213,6 +213,17 @@ struct fimc_fmt *fimc_get_format(unsigned int index)
 	return &fimc_formats[index];
 }

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
+
 int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
 			    int dw, int dh, int rotation)
 {
@@ -1304,7 +1315,7 @@ static struct platform_driver fimc_driver = {
 	.id_table	= fimc_driver_ids,
 	.driver = {
 		.of_match_table = fimc_of_match,
-		.name		= FIMC_MODULE_NAME,
+		.name		= FIMC_DRIVER_NAME,
 		.owner		= THIS_MODULE,
 		.pm     	= &fimc_pm_ops,
 	}
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 7388d6b..45218da 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -34,7 +34,7 @@

 /* Time to wait for next frame VSYNC interrupt while stopping operation. */
 #define FIMC_SHUTDOWN_TIMEOUT	((100*HZ)/1000)
-#define FIMC_MODULE_NAME	"s5p-fimc"
+#define FIMC_DRIVER_NAME	"exynos4-fimc"
 #define FIMC_MAX_DEVS		4
 #define FIMC_MAX_OUT_BUFS	4
 #define SCALER_MAX_HRATIO	64
@@ -622,6 +622,8 @@ static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 /* fimc-core.c */
 int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
 				struct v4l2_fmtdesc *f);
+void __fimc_vidioc_querycap(struct device *dev, struct v4l2_capability *cap,
+						unsigned int caps);
 int fimc_ctrls_create(struct fimc_ctx *ctx);
 void fimc_ctrls_delete(struct fimc_ctx *ctx);
 void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active);
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 3936b09..bde1f47 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -251,22 +251,20 @@ static struct vb2_ops fimc_qops = {
  * V4L2 ioctl handlers
  */
 static int fimc_m2m_querycap(struct file *file, void *fh,
-			     struct v4l2_capability *cap)
+				     struct v4l2_capability *cap)
 {
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_dev *fimc = video_drvdata(file);
+	unsigned int caps;

-	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
-	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
-	cap->bus_info[0] = 0;
 	/*
 	 * This is only a mem-to-mem video device. The capture and output
 	 * device capability flags are left only for backward compatibility
 	 * and are scheduled for removal.
 	 */
-	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
+	caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
 		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;

+	__fimc_vidioc_querycap(&fimc->pdev->dev, cap, caps);
 	return 0;
 }

--
1.7.9.5

