Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15306 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759842Ab3CZQG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 12:06:27 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 1/3] s5p-fimc: Use video entity for marking media
 pipeline as streaming
Date: Tue, 26 Mar 2013 17:06:04 +0100
Message-id: <1364313966-18868-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364313966-18868-1-git-send-email-s.nawrocki@samsung.com>
References: <1364313966-18868-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It doesn't matter whether we start from the sensor of from
the video node entity. Remove use of pipeline->subdevs array
where possible, so we can partly drop dependency on struct
fimc_pipeline in the fimc-lite module, which is also used
by the exynos5-is driver.
Also make sure we revert any media entity pipeline operations
when vb2_streamon() function fails.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |   27 +++++++++++++++---------
 drivers/media/platform/s5p-fimc/fimc-lite.c    |    9 ++++----
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 87b6842..257afc1 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -1230,36 +1230,43 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_pipeline *p = &fimc->pipeline;
-	struct v4l2_subdev *sd = p->subdevs[IDX_SENSOR];
+	struct fimc_vid_cap *vc = &fimc->vid_cap;
+	struct media_entity *entity = &vc->vfd.entity;
 	int ret;
 
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
-	ret = media_entity_pipeline_start(&sd->entity, p->m_pipeline);
+	ret = media_entity_pipeline_start(entity, p->m_pipeline);
 	if (ret < 0)
 		return ret;
 
-	if (fimc->vid_cap.user_subdev_api) {
+	if (vc->user_subdev_api) {
 		ret = fimc_pipeline_validate(fimc);
-		if (ret < 0) {
-			media_entity_pipeline_stop(&sd->entity);
-			return ret;
-		}
+		if (ret < 0)
+			goto err_p_stop;
 	}
-	return vb2_streamon(&fimc->vid_cap.vbq, type);
+
+	ret = vb2_streamon(&vc->vbq, type);
+	if (!ret)
+		return ret;
+
+err_p_stop:
+	media_entity_pipeline_stop(entity);
+	return ret;
 }
 
 static int fimc_cap_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
 	int ret;
 
 	ret = vb2_streamoff(&fimc->vid_cap.vbq, type);
+
 	if (ret == 0)
-		media_entity_pipeline_stop(&sd->entity);
+		media_entity_pipeline_stop(&fimc->vid_cap.vfd.entity);
+
 	return ret;
 }
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 8ebefdb..40733e0 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -800,20 +800,20 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 			      enum v4l2_buf_type type)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-	struct v4l2_subdev *sensor = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct media_entity *entity = &fimc->vfd.entity;
 	struct fimc_pipeline *p = &fimc->pipeline;
 	int ret;
 
 	if (fimc_lite_active(fimc))
 		return -EBUSY;
 
-	ret = media_entity_pipeline_start(&sensor->entity, p->m_pipeline);
+	ret = media_entity_pipeline_start(entity, p->m_pipeline);
 	if (ret < 0)
 		return ret;
 
 	ret = fimc_pipeline_validate(fimc);
 	if (ret) {
-		media_entity_pipeline_stop(&sensor->entity);
+		media_entity_pipeline_stop(entity);
 		return ret;
 	}
 
@@ -824,12 +824,11 @@ static int fimc_lite_streamoff(struct file *file, void *priv,
 			       enum v4l2_buf_type type)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
 	int ret;
 
 	ret = vb2_streamoff(&fimc->vb_queue, type);
 	if (ret == 0)
-		media_entity_pipeline_stop(&sd->entity);
+		media_entity_pipeline_stop(&fimc->vfd.entity);
 	return ret;
 }
 
-- 
1.7.9.5

