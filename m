Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49665 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab3EaOlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 10:41:16 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO000MJ3GRJPW0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 23:41:15 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hj210.choi@samsung.com,
	arun.kk@samsung.com, shaik.ameer@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH v2 09/11] exynos4-is: Add locking at fimc(-lite) subdev
 unregistered handler
Date: Fri, 31 May 2013 16:37:25 +0200
Message-id: <1370011047-11488-10-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
References: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Protect the fimc/fimc-lite video nodes unregistration with their video
lock. This prevents a kernel crash when e.g. udev opens a video node
right after the driver registers it and then the driver tries to
unregister it and defers its probing. Using video_is_unregistered()
together with the video mutex allows safe unregistration of the video
nodes at any time.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |    4 ++++
 drivers/media/platform/exynos4-is/fimc-lite.c    |    4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index c2586a2..25f8a1e 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1855,6 +1855,8 @@ static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
 	if (fimc == NULL)
 		return;
 
+	mutex_lock(&fimc->lock);
+
 	fimc_unregister_m2m_device(fimc);
 	vdev = &fimc->vid_cap.ve.vdev;
 
@@ -1866,6 +1868,8 @@ static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
 	}
 	kfree(fimc->vid_cap.ctx);
 	fimc->vid_cap.ctx = NULL;
+
+	mutex_unlock(&fimc->lock);
 }
 
 static const struct v4l2_subdev_internal_ops fimc_capture_sd_internal_ops = {
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 27232cd..142788a 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1300,11 +1300,15 @@ static void fimc_lite_subdev_unregistered(struct v4l2_subdev *sd)
 	if (fimc == NULL)
 		return;
 
+	mutex_lock(&fimc->lock);
+
 	if (video_is_registered(&fimc->ve.vdev)) {
 		video_unregister_device(&fimc->ve.vdev);
 		media_entity_cleanup(&fimc->ve.vdev.entity);
 		fimc->ve.pipe = NULL;
 	}
+
+	mutex_unlock(&fimc->lock);
 }
 
 static const struct v4l2_subdev_internal_ops fimc_lite_subdev_internal_ops = {
-- 
1.7.9.5

