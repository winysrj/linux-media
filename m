Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:60565 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3EIPhM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 11:37:12 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00EQ1FDP2XF0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 May 2013 00:37:11 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, dh09.lee@samsung.com, a.hajda@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 02/13] exynos4-is: Correct querycap ioctl handling at fimc-lite
 driver
Date: Thu, 09 May 2013 17:36:34 +0200
Message-id: <1368113805-20233-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
References: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fill in properly bus_info and card fields and set device_caps.
The querycap ioctl handler is renamed for consistency with the
other ioctls.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 8af8add..c57fa65 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -637,13 +637,18 @@ static void fimc_lite_try_compose(struct fimc_lite *fimc, struct v4l2_rect *r)
 /*
  * Video node ioctl operations
  */
-static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
+static int fimc_lite_querycap(struct file *file, void *priv,
 					struct v4l2_capability *cap)
 {
+	struct fimc_lite *fimc = video_drvdata(file);
+
 	strlcpy(cap->driver, FIMC_LITE_DRV_NAME, sizeof(cap->driver));
-	cap->bus_info[0] = 0;
-	cap->card[0] = 0;
-	cap->capabilities = V4L2_CAP_STREAMING;
+	strlcpy(cap->card, FIMC_LITE_DRV_NAME, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+					dev_name(&fimc->pdev->dev));
+
+	cap->device_caps = V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -938,7 +943,7 @@ static int fimc_lite_s_selection(struct file *file, void *fh,
 }
 
 static const struct v4l2_ioctl_ops fimc_lite_ioctl_ops = {
-	.vidioc_querycap		= fimc_vidioc_querycap_capture,
+	.vidioc_querycap		= fimc_lite_querycap,
 	.vidioc_enum_fmt_vid_cap_mplane	= fimc_lite_enum_fmt_mplane,
 	.vidioc_try_fmt_vid_cap_mplane	= fimc_lite_try_fmt_mplane,
 	.vidioc_s_fmt_vid_cap_mplane	= fimc_lite_s_fmt_mplane,
-- 
1.7.9.5

