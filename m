Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:9399 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3FYKxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 06:53:09 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOY00MO13KK0W40@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Jun 2013 19:53:08 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, a.hajda@samsung.com,
	j.anaszewski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 5/6] exynos4-is: Set valid initial format on FIMC.n subdevs
Date: Tue, 25 Jun 2013 12:52:34 +0200
Message-id: <1372157555-29557-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1372157555-29557-1-git-send-email-s.nawrocki@samsung.com>
References: <1372157555-29557-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure there are valid initial image formats on the FIMC.n subdev pads.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |   19 +++++++++++++++++--
 drivers/media/platform/exynos4-is/fimc-core.h    |    2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 2b045b6..fb27ff7 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1722,8 +1722,8 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc)
 	struct v4l2_format fmt = {
 		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
 		.fmt.pix_mp = {
-			.width		= 640,
-			.height		= 480,
+			.width		= FIMC_DEFAULT_WIDTH,
+			.height		= FIMC_DEFAULT_HEIGHT,
 			.pixelformat	= V4L2_PIX_FMT_YUYV,
 			.field		= V4L2_FIELD_NONE,
 			.colorspace	= V4L2_COLORSPACE_JPEG,
@@ -1741,6 +1741,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	struct vb2_queue *q = &fimc->vid_cap.vbq;
 	struct fimc_ctx *ctx;
 	struct fimc_vid_cap *vid_cap;
+	struct fimc_fmt *fmt;
 	int ret = -ENOMEM;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -1788,6 +1789,20 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	if (ret)
 		goto err_free_ctx;
 
+	/* Default format configuration */
+	fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
+	vid_cap->ci_fmt.width = FIMC_DEFAULT_WIDTH;
+	vid_cap->ci_fmt.height = FIMC_DEFAULT_HEIGHT;
+	vid_cap->ci_fmt.code = fmt->mbus_code;
+
+	ctx->s_frame.width = FIMC_DEFAULT_WIDTH;
+	ctx->s_frame.height = FIMC_DEFAULT_HEIGHT;
+	ctx->s_frame.fmt = fmt;
+
+	fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_WRITEBACK, 0);
+	vid_cap->wb_fmt = vid_cap->ci_fmt;
+	vid_cap->wb_fmt.code = fmt->mbus_code;
+
 	vid_cap->vd_pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_init(&vfd->entity, 1, &vid_cap->vd_pad, 0);
 	if (ret)
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 0f25ce0..65c8ce7 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -47,6 +47,8 @@
 #define FIMC_DEF_MIN_SIZE	16
 #define FIMC_DEF_HEIGHT_ALIGN	2
 #define FIMC_DEF_HOR_OFFS_ALIGN	1
+#define FIMC_DEFAULT_WIDTH	640
+#define FIMC_DEFAULT_HEIGHT	480
 
 /* indices to the clocks array */
 enum {
-- 
1.7.9.5

