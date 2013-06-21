Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:13299 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965758Ab3FUM4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 08:56:31 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOQ002WIULV6I40@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Jun 2013 21:56:30 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, j.anaszewski@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/6] exynos4-is: Set valid initial format at FIMC-LITE
Date: Fri, 21 Jun 2013 14:55:54 +0200
Message-id: <1371819358-13106-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1371819358-13106-1-git-send-email-s.nawrocki@samsung.com>
References: <1371819358-13106-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure the image resolution and crop rectangle on the FIMC-LITE.n
subdevs and fimc-lite.n.capture video nodes is properly configured
upon the driver's initialization.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   23 ++++++++++++++++++++---
 drivers/media/platform/exynos4-is/fimc-lite.h |    2 ++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index e51ef75..b4a0785 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1273,9 +1273,6 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 	int ret;
 
 	memset(vfd, 0, sizeof(*vfd));
-
-	fimc->inp_frame.fmt = &fimc_lite_formats[0];
-	fimc->out_frame.fmt = &fimc_lite_formats[0];
 	atomic_set(&fimc->out_path, FIMC_IO_DMA);
 
 	snprintf(vfd->name, sizeof(vfd->name), "fimc-lite.%d.capture",
@@ -1391,6 +1388,23 @@ static const struct v4l2_ctrl_config fimc_lite_ctrl = {
 	.step	= 1,
 };
 
+static void fimc_lite_set_default_config(struct fimc_lite *fimc)
+{
+	struct flite_frame *sink = &fimc->inp_frame;
+	struct flite_frame *source = &fimc->out_frame;
+
+	sink->fmt = &fimc_lite_formats[0];
+	sink->f_width = FLITE_DEFAULT_WIDTH;
+	sink->f_height = FLITE_DEFAULT_HEIGHT;
+
+	sink->rect.width = FLITE_DEFAULT_WIDTH;
+	sink->rect.height = FLITE_DEFAULT_HEIGHT;
+	sink->rect.left = 0;
+	sink->rect.top = 0;
+
+	*source = *sink;
+}
+
 static int fimc_lite_create_capture_subdev(struct fimc_lite *fimc)
 {
 	struct v4l2_ctrl_handler *handler = &fimc->ctrl_handler;
@@ -1536,8 +1550,11 @@ static int fimc_lite_probe(struct platform_device *pdev)
 		ret = PTR_ERR(fimc->alloc_ctx);
 		goto err_pm;
 	}
+
 	pm_runtime_put(dev);
 
+	fimc_lite_set_default_config(fimc);
+
 	dev_dbg(dev, "FIMC-LITE.%d registered successfully\n",
 		fimc->index);
 	return 0;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index c98f3da..7428b2d 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -29,6 +29,8 @@
 #define FLITE_CLK_NAME		"flite"
 #define FIMC_LITE_MAX_DEVS	3
 #define FLITE_REQ_BUFS_MIN	2
+#define FLITE_DEFAULT_WIDTH	640
+#define FLITE_DEFAULT_HEIGHT	480
 
 /* Bit index definitions for struct fimc_lite::state */
 enum {
-- 
1.7.9.5

