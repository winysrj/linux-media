Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56499 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098Ab3CZSjE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 14:39:04 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 4/4] exynos4-is: Ensure proper media pipeline state on
 device close
Date: Tue, 26 Mar 2013 19:38:20 +0100
Message-id: <1364323101-22046-9-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
References: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure media_entity_pipeline_stop() is called on video device
close in cases where there was VIDIOC_STREAMON ioctl and no
VIDIOC_STREAMOFF. This patch fixes media entities stream_count
state which could prevent links from being disconnected, due to
non-zero stream_count.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |   18 +++++++++++++-----
 drivers/media/platform/exynos4-is/fimc-core.h    |    1 +
 drivers/media/platform/exynos4-is/fimc-lite.c    |   18 ++++++++++++++----
 drivers/media/platform/exynos4-is/fimc-lite.h    |    1 +
 4 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index b9c0817..0ae6bdb 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -551,6 +551,7 @@ unlock:
 static int fimc_capture_release(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_vid_cap *vc = &fimc->vid_cap;
 	int ret;
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
@@ -558,6 +559,10 @@ static int fimc_capture_release(struct file *file)
 	mutex_lock(&fimc->lock);
 
 	if (v4l2_fh_is_singular_file(file)) {
+		if (vc->streaming) {
+			media_entity_pipeline_stop(&vc->vfd.entity);
+			vc->streaming = false;
+		}
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
 		fimc_stop_capture(fimc, false);
 		fimc_pipeline_call(fimc, close, &fimc->pipeline);
@@ -1243,8 +1248,10 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	}
 
 	ret = vb2_ioctl_streamon(file, priv, type);
-	if (!ret)
+	if (!ret) {
+		vc->streaming = true;
 		return ret;
+	}
 
 err_p_stop:
 	media_entity_pipeline_stop(entity);
@@ -1258,11 +1265,12 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 	int ret;
 
 	ret = vb2_ioctl_streamoff(file, priv, type);
+	if (ret < 0)
+		return ret;
 
-	if (ret == 0)
-		media_entity_pipeline_stop(&fimc->vid_cap.vfd.entity);
-
-	return ret;
+	media_entity_pipeline_stop(&fimc->vid_cap.vfd.entity);
+	fimc->vid_cap.streaming = false;
+	return 0;
 }
 
 static int fimc_cap_reqbufs(struct file *file, void *priv,
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 793333a..de2b57e 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -318,6 +318,7 @@ struct fimc_vid_cap {
 	int				buf_index;
 	unsigned int			frame_count;
 	unsigned int			reqbufs_count;
+	bool				streaming;
 	int				input_index;
 	int				refcnt;
 	u32				input;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index b11e358..cb196b8 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -507,6 +507,10 @@ static int fimc_lite_release(struct file *file)
 
 	if (v4l2_fh_is_singular_file(file) &&
 	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
+		if (fimc->streaming) {
+			media_entity_pipeline_stop(&fimc->vfd.entity);
+			fimc->streaming = false;
+		}
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
 		fimc_lite_stop_capture(fimc, false);
 		fimc_pipeline_call(fimc, close, &fimc->pipeline);
@@ -798,8 +802,11 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 		goto err_p_stop;
 
 	ret = vb2_ioctl_streamon(file, priv, type);
-	if (!ret)
+	if (!ret) {
+		fimc->streaming = true;
 		return ret;
+	}
+
 err_p_stop:
 	media_entity_pipeline_stop(entity);
 	return 0;
@@ -812,9 +819,12 @@ static int fimc_lite_streamoff(struct file *file, void *priv,
 	int ret;
 
 	ret = vb2_ioctl_streamoff(file, priv, type);
-	if (ret == 0)
-		media_entity_pipeline_stop(&fimc->vfd.entity);
-	return ret;
+	if (ret < 0)
+		return ret;
+
+	media_entity_pipeline_stop(&fimc->vfd.entity);
+	fimc->streaming = false;
+	return 0;
 }
 
 static int fimc_lite_reqbufs(struct file *file, void *priv,
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 8a8d26f..71fed51 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -166,6 +166,7 @@ struct fimc_lite {
 	int			ref_count;
 
 	struct fimc_lite_events	events;
+	bool			streaming;
 };
 
 static inline bool fimc_lite_active(struct fimc_lite *fimc)
-- 
1.7.9.5

