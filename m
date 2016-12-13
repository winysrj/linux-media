Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941212AbcLMSDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 13:03:45 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCHv3 2/4] v4l: vsp1: Refactor video pipeline configuration
Date: Tue, 13 Dec 2016 17:59:42 +0000
Message-Id: <1481651984-7687-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With multiple inputs through the BRU it is feasible for the streams to
race each other at stream-on. In the case of the video pipelines, this
can present two serious issues.

 1) A null-dereference if the pipe->dl is committed at the same time as
    the vsp1_video_setup_pipeline() is processing

 2) A hardware hang, where a display list is committed without having
    called vsp1_video_setup_pipeline() first

Along side these race conditions, the work done by
vsp1_video_setup_pipeline() is undone by the re-initialisation during a
suspend resume cycle, and an active pipeline does not attempt to
reconfigure the correct routing and init parameters for the entities.

To repair all of these issues, we can move the call to a conditional
inside vsp1_video_pipeline_run() and ensure that this can only be called
on the last stream which calls into vsp1_video_start_streaming()

As a convenient side effect of this, by specifying that the
configuration has been lost during suspend/resume actions - the
vsp1_video_pipeline_run() call can re-initialise pipelines when
necessary thus repairing resume actions for active m2m pipelines.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v3:
 - Move 'flag reset' to be inside the vsp1_reset_wpf() function call
 - Tidy up the wpf->pipe reference for the configured flag

 drivers/media/platform/vsp1/vsp1_drv.c   |  4 ++++
 drivers/media/platform/vsp1/vsp1_pipe.c  |  1 +
 drivers/media/platform/vsp1/vsp1_pipe.h  |  2 ++
 drivers/media/platform/vsp1/vsp1_video.c | 20 +++++++++-----------
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 57c713a4e1df..1dc3726c4e83 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -413,6 +413,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 int vsp1_reset_wpf(struct vsp1_device *vsp1, unsigned int index)
 {
+	struct vsp1_rwpf *wpf = vsp1->wpf[index];
 	unsigned int timeout;
 	u32 status;
 
@@ -429,6 +430,9 @@ int vsp1_reset_wpf(struct vsp1_device *vsp1, unsigned int index)
 		usleep_range(1000, 2000);
 	}
 
+	if (wpf->pipe)
+		wpf->pipe->configured = false;
+
 	if (!timeout) {
 		dev_err(vsp1->dev, "failed to reset wpf.%u\n", index);
 		return -ETIMEDOUT;
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 756ca4ea7668..7ddf862ee403 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -208,6 +208,7 @@ void vsp1_pipeline_init(struct vsp1_pipeline *pipe)
 
 	INIT_LIST_HEAD(&pipe->entities);
 	pipe->state = VSP1_PIPELINE_STOPPED;
+	pipe->configured = false;
 }
 
 /* Must be called with the pipe irqlock held. */
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index ac4ad2655551..0743b9fcb655 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -61,6 +61,7 @@ enum vsp1_pipeline_state {
  * @pipe: the media pipeline
  * @irqlock: protects the pipeline state
  * @state: current state
+ * @configured: determines routing configuration active on cell.
  * @wq: wait queue to wait for state change completion
  * @frame_end: frame end interrupt handler
  * @lock: protects the pipeline use count and stream count
@@ -86,6 +87,7 @@ struct vsp1_pipeline {
 
 	spinlock_t irqlock;
 	enum vsp1_pipeline_state state;
+	bool configured;
 	wait_queue_head_t wq;
 
 	void (*frame_end)(struct vsp1_pipeline *pipe);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 44b687c0b8df..7ff9f4c19ff0 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -388,6 +388,8 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 					       VSP1_ENTITY_PARAMS_INIT);
 	}
 
+	pipe->configured = true;
+
 	return 0;
 }
 
@@ -411,6 +413,9 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	struct vsp1_entity *entity;
 
+	if (!pipe->configured)
+		vsp1_video_setup_pipeline(pipe);
+
 	if (!pipe->dl)
 		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
 
@@ -793,25 +798,18 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
 	struct vsp1_pipeline *pipe = video->rwpf->pipe;
 	unsigned long flags;
-	int ret;
 
 	mutex_lock(&pipe->lock);
 	if (pipe->stream_count == pipe->num_inputs) {
-		ret = vsp1_video_setup_pipeline(pipe);
-		if (ret < 0) {
-			mutex_unlock(&pipe->lock);
-			return ret;
-		}
+		spin_lock_irqsave(&pipe->irqlock, flags);
+		if (vsp1_pipeline_ready(pipe))
+			vsp1_video_pipeline_run(pipe);
+		spin_unlock_irqrestore(&pipe->irqlock, flags);
 	}
 
 	pipe->stream_count++;
 	mutex_unlock(&pipe->lock);
 
-	spin_lock_irqsave(&pipe->irqlock, flags);
-	if (vsp1_pipeline_ready(pipe))
-		vsp1_video_pipeline_run(pipe);
-	spin_unlock_irqrestore(&pipe->irqlock, flags);
-
 	return 0;
 }
 
-- 
2.7.4

