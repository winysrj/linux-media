Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752049AbdEIMhx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 08:37:53 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v5 2/2] v4l: vsp1: Repair suspend resume operations for video pipelines
Date: Tue,  9 May 2017 13:37:31 +0100
Message-Id: <24697ebba024a6375ff2e793203296c70112537e.1494328856.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7da7d07a321ae8bff8445a8dd714d9a61a3ee71b.1494328856.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7da7d07a321ae8bff8445a8dd714d9a61a3ee71b.1494328856.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7da7d07a321ae8bff8445a8dd714d9a61a3ee71b.1494328856.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7da7d07a321ae8bff8445a8dd714d9a61a3ee71b.1494328856.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a suspend/resume action is taken, the pipeline is reset and never
reconfigured.

To correct this, we establish a new flag pipe->configured and utilise
this to establish when we write a full configuration set to the current
display list.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---

Laurent,

Pasting your previous comments on this patch for convenience:

> As discussed face to face, I think a better approach would be to cache the 
> display list instead of recomputing it a resume time. However, given that this 
> will require more work, I could be convinced to merge this patch in the 
> meantime. Let's check in a couple of weeks whether we will have moved forward 
> with display list caching in time for v4.12, and merge this patch otherwise.
> Your previous 

I agree that this could be cached - but that would be a larger development
reworking all of the display list handling. As such I think this patch still
provides progression, and we can rework if necessary when we have looked at
list reuse in more detail.

As I have just re-discovered - this patch requires the DRM/DU to be disabled
as that does not yet support suspend/resume on that side - (Another topic to
be revisited)

--
Kieran


 drivers/media/platform/vsp1/vsp1_drv.c   |  4 ++-
 drivers/media/platform/vsp1/vsp1_pipe.c  |  1 +-
 drivers/media/platform/vsp1/vsp1_pipe.h  |  4 +-
 drivers/media/platform/vsp1/vsp1_video.c | 56 ++++++++++---------------
 4 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 048446af5ae7..a77c40c2a39a 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -463,6 +463,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 int vsp1_reset_wpf(struct vsp1_device *vsp1, unsigned int index)
 {
+	struct vsp1_rwpf *wpf = vsp1->wpf[index];
 	unsigned int timeout;
 	u32 status;
 
@@ -479,6 +480,9 @@ int vsp1_reset_wpf(struct vsp1_device *vsp1, unsigned int index)
 		usleep_range(1000, 2000);
 	}
 
+	if (wpf->pipe)
+		wpf->pipe->configured = false;
+
 	if (!timeout) {
 		dev_err(vsp1->dev, "failed to reset wpf.%u\n", index);
 		return -ETIMEDOUT;
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index edebf3fa926f..11b2dbf8f322 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -238,6 +238,7 @@ void vsp1_pipeline_init(struct vsp1_pipeline *pipe)
 
 	INIT_LIST_HEAD(&pipe->entities);
 	pipe->state = VSP1_PIPELINE_STOPPED;
+	pipe->configured = false;
 }
 
 /* Must be called with the pipe irqlock held. */
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 91a784a13422..f715d2ba1044 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -62,6 +62,7 @@ enum vsp1_pipeline_state {
  * @pipe: the media pipeline
  * @irqlock: protects the pipeline state
  * @state: current state
+ * @configured: true if the pipeline has been set up for video streaming
  * @wq: wait queue to wait for state change completion
  * @frame_end: frame end interrupt handler
  * @lock: protects the pipeline use count and stream count
@@ -89,6 +90,7 @@ struct vsp1_pipeline {
 
 	spinlock_t irqlock;
 	enum vsp1_pipeline_state state;
+	bool configured;
 	wait_queue_head_t wq;
 
 	void (*frame_end)(struct vsp1_pipeline *pipe);
@@ -111,8 +113,6 @@ struct vsp1_pipeline {
 
 	struct list_head entities;
 
-	struct vsp1_dl_list *dl;
-
 	unsigned int div_size;
 	unsigned int partitions;
 	struct v4l2_rect partition;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 3e9919c613fe..226e6e0b23aa 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -368,18 +368,14 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 	pipe->buffers_ready |= 1 << video->pipe_index;
 }
 
-static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
+static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe,
+				     struct vsp1_dl_list *dl)
 {
 	struct vsp1_entity *entity;
 
 	/* Determine this pipelines sizes for image partitioning support. */
 	vsp1_video_pipeline_setup_partitions(pipe);
 
-	/* Prepare the display list. */
-	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
-	if (!pipe->dl)
-		return -ENOMEM;
-
 	if (pipe->uds) {
 		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
 
@@ -399,13 +395,15 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	}
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe, pipe->dl);
+		vsp1_entity_route_setup(entity, pipe, dl);
 
 		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl,
+			entity->ops->configure(entity, pipe, dl,
 					       VSP1_ENTITY_PARAMS_INIT);
 	}
 
+	pipe->configured = true;
+
 	return 0;
 }
 
@@ -428,9 +426,16 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	struct vsp1_entity *entity;
+	struct vsp1_dl_list *dl;
 
-	if (!pipe->dl)
-		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
+	dl = vsp1_dl_list_get(pipe->output->dlm);
+	if (!dl) {
+		dev_err(vsp1->dev, "Failed to obtain a dl list\n");
+		return;
+	}
+
+	if (!pipe->configured)
+		vsp1_video_setup_pipeline(pipe, dl);
 
 	/*
 	 * Start with the runtime parameters as the configure operation can
@@ -439,45 +444,43 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 	 */
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl,
+			entity->ops->configure(entity, pipe, dl,
 					       VSP1_ENTITY_PARAMS_RUNTIME);
 	}
 
 	/* Run the first partition */
 	pipe->current_partition = 0;
-	vsp1_video_pipeline_run_partition(pipe, pipe->dl);
+	vsp1_video_pipeline_run_partition(pipe, dl);
 
 	/* Process consecutive partitions as necessary */
 	for (pipe->current_partition = 1;
 	     pipe->current_partition < pipe->partitions;
 	     pipe->current_partition++) {
-		struct vsp1_dl_list *dl;
+		struct vsp1_dl_list *child;
 
 		/*
 		 * Partition configuration operations will utilise
 		 * the pipe->current_partition variable to determine
 		 * the work they should complete.
 		 */
-		dl = vsp1_dl_list_get(pipe->output->dlm);
+		child = vsp1_dl_list_get(pipe->output->dlm);
 
 		/*
 		 * An incomplete chain will still function, but output only
 		 * the partitions that had a dl available. The frame end
 		 * interrupt will be marked on the last dl in the chain.
 		 */
-		if (!dl) {
+		if (!child) {
 			dev_err(vsp1->dev, "Failed to obtain a dl list. Frame will be incomplete\n");
 			break;
 		}
 
-		vsp1_video_pipeline_run_partition(pipe, dl);
-		vsp1_dl_list_add_chain(pipe->dl, dl);
+		vsp1_video_pipeline_run_partition(pipe, child);
+		vsp1_dl_list_add_chain(dl, child);
 	}
 
 	/* Complete, and commit the head display list. */
-	vsp1_dl_list_commit(pipe->dl);
-	pipe->dl = NULL;
-
+	vsp1_dl_list_commit(dl);
 	vsp1_pipeline_run(pipe);
 }
 
@@ -827,18 +830,10 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct vsp1_pipeline *pipe = video->rwpf->pipe;
 	bool start_pipeline = false;
 	unsigned long flags;
-	int ret;
 
 	mutex_lock(&pipe->lock);
-	if (pipe->stream_count == pipe->num_inputs) {
-		ret = vsp1_video_setup_pipeline(pipe);
-		if (ret < 0) {
-			mutex_unlock(&pipe->lock);
-			return ret;
-		}
-
+	if (pipe->stream_count == pipe->num_inputs)
 		start_pipeline = true;
-	}
 
 	pipe->stream_count++;
 	mutex_unlock(&pipe->lock);
@@ -883,9 +878,6 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 		ret = vsp1_pipeline_stop(pipe);
 		if (ret == -ETIMEDOUT)
 			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
-
-		vsp1_dl_list_put(pipe->dl);
-		pipe->dl = NULL;
 	}
 	mutex_unlock(&pipe->lock);
 
-- 
git-series 0.9.1
