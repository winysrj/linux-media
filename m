Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:23090 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3DVOFr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:05:47 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN00CXRTTMW1I0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:05:46 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 04/12] exynos4-is: Fix initialization of subdev 'flags' field
Date: Mon, 22 Apr 2013 16:03:39 +0200
Message-id: <1366639427-14253-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure the value of struct v4l2_subdev::flags field as set
in v4l2_subdev_init() is preserved when initializing it in
the subdev drivers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c     |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 72c516a..558c528 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1869,7 +1869,7 @@ int fimc_initialize_capture_subdev(struct fimc_dev *fimc)
 	int ret;
 
 	v4l2_subdev_init(sd, &fimc_subdev_ops);
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->id);
 
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK_CAM].flags = MEDIA_PAD_FL_SINK;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 3b9a664..d63947f 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -621,7 +621,7 @@ int fimc_isp_subdev_create(struct fimc_isp *isp)
 
 	v4l2_subdev_init(sd, &fimc_is_subdev_ops);
 	sd->grp_id = GRP_ID_FIMC_IS;
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	snprintf(sd->name, sizeof(sd->name), "FIMC-IS-ISP");
 
 	isp->subdev_pads[FIMC_ISP_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 661d0d1..7ecf4e7 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1377,7 +1377,7 @@ static int fimc_lite_create_capture_subdev(struct fimc_lite *fimc)
 	int ret;
 
 	v4l2_subdev_init(sd, &fimc_lite_subdev_ops);
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	snprintf(sd->name, sizeof(sd->name), "FIMC-LITE.%d", fimc->index);
 
 	fimc->subdev_pads[FLITE_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
-- 
1.7.9.5

