Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43780 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751844AbeERUmL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 16:42:11 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v11 02/10] media: vsp1: Move video suspend resume handling to video object
Date: Fri, 18 May 2018 21:41:55 +0100
Message-Id: <1969e3639e2a1bcfd104a1054b30f9d914fe5dfb.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The suspend and resume handlers are only utilised by video pipelines,
yet the functions currently reside in the vsp1_pipe object.

This causes an issue with resume, as the functions incorrectly call
vsp1_pipeline_run() directly instead of processing the video object
through vsp1_video_pipeline_run().

Move the functions to the video object, renaming accordingly and update
the resume handler to call vsp1_video_pipeline_run() as appropriate.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c   |  4 +-
 drivers/media/platform/vsp1/vsp1_pipe.c  | 70 +-----------------------
 drivers/media/platform/vsp1/vsp1_pipe.h  |  3 +-
 drivers/media/platform/vsp1/vsp1_video.c | 75 +++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_video.h |  3 +-
 5 files changed, 80 insertions(+), 75 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index d29f9c4baebe..5d82f6ee56ea 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -589,7 +589,7 @@ static int __maybe_unused vsp1_pm_suspend(struct device *dev)
 	 * restarted explicitly by the DU.
 	 */
 	if (!vsp1->drm)
-		vsp1_pipelines_suspend(vsp1);
+		vsp1_video_suspend(vsp1);
 
 	pm_runtime_force_suspend(vsp1->dev);
 
@@ -607,7 +607,7 @@ static int __maybe_unused vsp1_pm_resume(struct device *dev)
 	 * restarted explicitly by the DU.
 	 */
 	if (!vsp1->drm)
-		vsp1_pipelines_resume(vsp1);
+		vsp1_video_resume(vsp1);
 
 	return 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 6fde4c0b9844..da21f1a7cd75 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -386,73 +386,3 @@ void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
 	}
 }
 
-void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
-{
-	unsigned long flags;
-	unsigned int i;
-	int ret;
-
-	/*
-	 * To avoid increasing the system suspend time needlessly, loop over the
-	 * pipelines twice, first to set them all to the stopping state, and
-	 * then to wait for the stop to complete.
-	 */
-	for (i = 0; i < vsp1->info->wpf_count; ++i) {
-		struct vsp1_rwpf *wpf = vsp1->wpf[i];
-		struct vsp1_pipeline *pipe;
-
-		if (wpf == NULL)
-			continue;
-
-		pipe = wpf->entity.pipe;
-		if (pipe == NULL)
-			continue;
-
-		spin_lock_irqsave(&pipe->irqlock, flags);
-		if (pipe->state == VSP1_PIPELINE_RUNNING)
-			pipe->state = VSP1_PIPELINE_STOPPING;
-		spin_unlock_irqrestore(&pipe->irqlock, flags);
-	}
-
-	for (i = 0; i < vsp1->info->wpf_count; ++i) {
-		struct vsp1_rwpf *wpf = vsp1->wpf[i];
-		struct vsp1_pipeline *pipe;
-
-		if (wpf == NULL)
-			continue;
-
-		pipe = wpf->entity.pipe;
-		if (pipe == NULL)
-			continue;
-
-		ret = wait_event_timeout(pipe->wq, vsp1_pipeline_stopped(pipe),
-					 msecs_to_jiffies(500));
-		if (ret == 0)
-			dev_warn(vsp1->dev, "pipeline %u stop timeout\n",
-				 wpf->entity.index);
-	}
-}
-
-void vsp1_pipelines_resume(struct vsp1_device *vsp1)
-{
-	unsigned long flags;
-	unsigned int i;
-
-	/* Resume all running pipelines. */
-	for (i = 0; i < vsp1->info->wpf_count; ++i) {
-		struct vsp1_rwpf *wpf = vsp1->wpf[i];
-		struct vsp1_pipeline *pipe;
-
-		if (wpf == NULL)
-			continue;
-
-		pipe = wpf->entity.pipe;
-		if (pipe == NULL)
-			continue;
-
-		spin_lock_irqsave(&pipe->irqlock, flags);
-		if (vsp1_pipeline_ready(pipe))
-			vsp1_pipeline_run(pipe);
-		spin_unlock_irqrestore(&pipe->irqlock, flags);
-	}
-}
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 663d7fed7929..69858ba6cb31 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -164,9 +164,6 @@ void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
 				       unsigned int index,
 				       struct vsp1_partition_window *window);
 
-void vsp1_pipelines_suspend(struct vsp1_device *vsp1);
-void vsp1_pipelines_resume(struct vsp1_device *vsp1);
-
 const struct vsp1_format_info *vsp1_get_format_info(struct vsp1_device *vsp1,
 						    u32 fourcc);
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index ba89dd176a13..5deb35210055 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -1171,6 +1171,81 @@ static const struct v4l2_file_operations vsp1_video_fops = {
 };
 
 /* -----------------------------------------------------------------------------
+ * Suspend and Resume
+ */
+
+void vsp1_video_suspend(struct vsp1_device *vsp1)
+{
+	unsigned long flags;
+	unsigned int i;
+	int ret;
+
+	/*
+	 * To avoid increasing the system suspend time needlessly, loop over the
+	 * pipelines twice, first to set them all to the stopping state, and
+	 * then to wait for the stop to complete.
+	 */
+	for (i = 0; i < vsp1->info->wpf_count; ++i) {
+		struct vsp1_rwpf *wpf = vsp1->wpf[i];
+		struct vsp1_pipeline *pipe;
+
+		if (wpf == NULL)
+			continue;
+
+		pipe = wpf->entity.pipe;
+		if (pipe == NULL)
+			continue;
+
+		spin_lock_irqsave(&pipe->irqlock, flags);
+		if (pipe->state == VSP1_PIPELINE_RUNNING)
+			pipe->state = VSP1_PIPELINE_STOPPING;
+		spin_unlock_irqrestore(&pipe->irqlock, flags);
+	}
+
+	for (i = 0; i < vsp1->info->wpf_count; ++i) {
+		struct vsp1_rwpf *wpf = vsp1->wpf[i];
+		struct vsp1_pipeline *pipe;
+
+		if (wpf == NULL)
+			continue;
+
+		pipe = wpf->entity.pipe;
+		if (pipe == NULL)
+			continue;
+
+		ret = wait_event_timeout(pipe->wq, vsp1_pipeline_stopped(pipe),
+					 msecs_to_jiffies(500));
+		if (ret == 0)
+			dev_warn(vsp1->dev, "pipeline %u stop timeout\n",
+				 wpf->entity.index);
+	}
+}
+
+void vsp1_video_resume(struct vsp1_device *vsp1)
+{
+	unsigned long flags;
+	unsigned int i;
+
+	/* Resume all running pipelines. */
+	for (i = 0; i < vsp1->info->wpf_count; ++i) {
+		struct vsp1_rwpf *wpf = vsp1->wpf[i];
+		struct vsp1_pipeline *pipe;
+
+		if (wpf == NULL)
+			continue;
+
+		pipe = wpf->entity.pipe;
+		if (pipe == NULL)
+			continue;
+
+		spin_lock_irqsave(&pipe->irqlock, flags);
+		if (vsp1_pipeline_ready(pipe))
+			vsp1_video_pipeline_run(pipe);
+		spin_unlock_irqrestore(&pipe->irqlock, flags);
+	}
+}
+
+/* -----------------------------------------------------------------------------
  * Initialization and Cleanup
  */
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 75a5a65c66fe..f3cf5e2fdf5a 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -51,6 +51,9 @@ static inline struct vsp1_video *to_vsp1_video(struct video_device *vdev)
 	return container_of(vdev, struct vsp1_video, video);
 }
 
+void vsp1_video_suspend(struct vsp1_device *vsp1);
+void vsp1_video_resume(struct vsp1_device *vsp1);
+
 struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 				     struct vsp1_rwpf *rwpf);
 void vsp1_video_cleanup(struct vsp1_video *video);
-- 
git-series 0.9.1
