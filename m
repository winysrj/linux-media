Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752444AbdHNPNu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 11:13:50 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 7/8] v4l: vsp1: Move video configuration to a cached dlb
Date: Mon, 14 Aug 2017 16:13:30 +0100
Message-Id: <f72d5230fa26bc11849e02950d1ad6e6e6f34130.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We are now able to configure a pipeline directly into a local display
list body. Take advantage of this fact, and create a cacheable body to
store the configuration of the pipeline in the video object.

vsp1_video_pipeline_run() is now the last user of the pipe->dl object.
Convert this function to use the cached video->config body and obtain a
local display list reference.

Attach the video->config body to the display list when needed before
committing to hardware.

The pipe object is marked as un-configured when entering a suspend. This
ensures that upon resume, where the hardware is reset - our cached
configuration will be re-attached to the next committed DL.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---

Our video DL usage now looks like the below output:

dl->body0 contains our disposable runtime configuration. Max 41.
dl_child->body0 is our partition specific configuration. Max 12.
dl->fragments shows our constant configuration and LUTs.

  These two are LUT/CLU:
     * dl->fragments[x]->num_entries 256 / max 256
     * dl->fragments[x]->num_entries 4914 / max 4914

Which shows that our 'constant' configuration cache is currently
utilised to a maximum of 64 entries.

trace-cmd report | \
    grep max | sed 's/.*vsp1_dl_list_commit://g' | sort | uniq;

  dl->body0->num_entries 13 / max 128
  dl->body0->num_entries 14 / max 128
  dl->body0->num_entries 16 / max 128
  dl->body0->num_entries 20 / max 128
  dl->body0->num_entries 27 / max 128
  dl->body0->num_entries 34 / max 128
  dl->body0->num_entries 41 / max 128
  dl_child->body0->num_entries 10 / max 128
  dl_child->body0->num_entries 12 / max 128
  dl->fragments[x]->num_entries 15 / max 128
  dl->fragments[x]->num_entries 16 / max 128
  dl->fragments[x]->num_entries 17 / max 128
  dl->fragments[x]->num_entries 18 / max 128
  dl->fragments[x]->num_entries 20 / max 128
  dl->fragments[x]->num_entries 21 / max 128
  dl->fragments[x]->num_entries 256 / max 256
  dl->fragments[x]->num_entries 31 / max 128
  dl->fragments[x]->num_entries 32 / max 128
  dl->fragments[x]->num_entries 39 / max 128
  dl->fragments[x]->num_entries 40 / max 128
  dl->fragments[x]->num_entries 47 / max 128
  dl->fragments[x]->num_entries 48 / max 128
  dl->fragments[x]->num_entries 4914 / max 4914
  dl->fragments[x]->num_entries 55 / max 128
  dl->fragments[x]->num_entries 56 / max 128
  dl->fragments[x]->num_entries 63 / max 128
  dl->fragments[x]->num_entries 64 / max 128
---
 drivers/media/platform/vsp1/vsp1_pipe.c  |  4 +-
 drivers/media/platform/vsp1/vsp1_pipe.h  |  4 +-
 drivers/media/platform/vsp1/vsp1_video.c | 67 ++++++++++++++++---------
 drivers/media/platform/vsp1/vsp1_video.h |  2 +-
 4 files changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 5012643583b6..7d1f7ba43060 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -249,6 +249,7 @@ void vsp1_pipeline_run(struct vsp1_pipeline *pipe)
 		vsp1_write(vsp1, VI6_CMD(pipe->output->entity.index),
 			   VI6_CMD_STRCMD);
 		pipe->state = VSP1_PIPELINE_RUNNING;
+		pipe->configured = true;
 	}
 
 	pipe->buffers_ready = 0;
@@ -430,6 +431,9 @@ void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
 		spin_lock_irqsave(&pipe->irqlock, flags);
 		if (pipe->state == VSP1_PIPELINE_RUNNING)
 			pipe->state = VSP1_PIPELINE_STOPPING;
+
+		/* After a suspend, the hardware will be reset */
+		pipe->configured = false;
 		spin_unlock_irqrestore(&pipe->irqlock, flags);
 	}
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 90d29492b9b9..e7ad6211b4d0 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -90,6 +90,7 @@ struct vsp1_partition {
  * @irqlock: protects the pipeline state
  * @state: current state
  * @wq: wait queue to wait for state change completion
+ * @configured: flag determining if the hardware has run since reset
  * @frame_end: frame end interrupt handler
  * @lock: protects the pipeline use count and stream count
  * @kref: pipeline reference count
@@ -117,6 +118,7 @@ struct vsp1_pipeline {
 	spinlock_t irqlock;
 	enum vsp1_pipeline_state state;
 	wait_queue_head_t wq;
+	bool configured;
 
 	void (*frame_end)(struct vsp1_pipeline *pipe, bool completed);
 
@@ -143,8 +145,6 @@ struct vsp1_pipeline {
 	 */
 	struct list_head entities;
 
-	struct vsp1_dl_list *dl;
-
 	unsigned int partitions;
 	struct vsp1_partition *partition;
 	struct vsp1_partition *part_table;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 7e825f3360bf..42b70b8465ba 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -394,37 +394,43 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+	struct vsp1_video *video = pipe->output->video;
 	unsigned int partition;
+	struct vsp1_dl_list *dl;
+
+	dl = vsp1_dl_list_get(pipe->output->dlm);
 
-	if (!pipe->dl)
-		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
+	/* Attach our pipe configuration to fully initialise the hardware */
+	if (!pipe->configured) {
+		vsp1_dl_list_add_fragment(dl, video->pipe_config);
+		pipe->configured = true;
+	}
 
 	/* Run the first partition */
-	vsp1_video_pipeline_run_partition(pipe, pipe->dl, 0);
+	vsp1_video_pipeline_run_partition(pipe, dl, 0);
 
 	/* Process consecutive partitions as necessary */
 	for (partition = 1; partition < pipe->partitions; ++partition) {
-		struct vsp1_dl_list *dl;
+		struct vsp1_dl_list *dl_child;
 
-		dl = vsp1_dl_list_get(pipe->output->dlm);
+		dl_child = vsp1_dl_list_get(pipe->output->dlm);
 
 		/*
 		 * An incomplete chain will still function, but output only
 		 * the partitions that had a dl available. The frame end
 		 * interrupt will be marked on the last dl in the chain.
 		 */
-		if (!dl) {
+		if (!dl_child) {
 			dev_err(vsp1->dev, "Failed to obtain a dl list. Frame will be incomplete\n");
 			break;
 		}
 
-		vsp1_video_pipeline_run_partition(pipe, dl, partition);
-		vsp1_dl_list_add_chain(pipe->dl, dl);
+		vsp1_video_pipeline_run_partition(pipe, dl_child, partition);
+		vsp1_dl_list_add_chain(dl, dl_child);
 	}
 
 	/* Complete, and commit the head display list. */
-	vsp1_dl_list_commit(pipe->dl);
-	pipe->dl = NULL;
+	vsp1_dl_list_commit(dl);
 
 	vsp1_pipeline_run(pipe);
 }
@@ -790,8 +796,8 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 
 static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 {
+	struct vsp1_video *video = pipe->output->video;
 	struct vsp1_entity *entity;
-	struct vsp1_dl_body *dlb;
 	int ret;
 
 	/* Determine this pipelines sizes for image partitioning support. */
@@ -799,14 +805,6 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	if (ret < 0)
 		return ret;
 
-	/* Prepare the display list. */
-	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
-	if (!pipe->dl)
-		return -ENOMEM;
-
-	/* Retrieve the default DLB from the list */
-	dlb = vsp1_dl_list_get_body(pipe->dl);
-
 	if (pipe->uds) {
 		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
 
@@ -828,11 +826,20 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 		}
 	}
 
+	/* Obtain a clean body from our pool */
+	video->pipe_config = vsp1_dl_fragment_get(video->dlbs);
+	if (!video->pipe_config)
+		return -ENOMEM;
+
+	/* Configure the entities into our cached pipe configuration */
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe, dlb);
-		vsp1_entity_prepare(entity, pipe, dlb);
+		vsp1_entity_route_setup(entity, pipe, video->pipe_config);
+		vsp1_entity_prepare(entity, pipe, video->pipe_config);
 	}
 
+	/* Ensure that our cached configuration is updated in the next DL */
+	pipe->configured = false;
+
 	return 0;
 }
 
@@ -842,6 +849,9 @@ static void vsp1_video_cleanup_pipeline(struct vsp1_pipeline *pipe)
 	struct vsp1_vb2_buffer *buffer;
 	unsigned long flags;
 
+	/* Release any cached configuration */
+	vsp1_dl_fragment_put(video->pipe_config);
+
 	/* Remove all buffers from the IRQ queue. */
 	spin_lock_irqsave(&video->irqlock, flags);
 	list_for_each_entry(buffer, &video->irqqueue, queue)
@@ -918,9 +928,6 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 		ret = vsp1_pipeline_stop(pipe);
 		if (ret == -ETIMEDOUT)
 			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
-
-		vsp1_dl_list_put(pipe->dl);
-		pipe->dl = NULL;
 	}
 	mutex_unlock(&pipe->lock);
 
@@ -1240,6 +1247,16 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 		goto error;
 	}
 
+	/*
+	 * Create a fragment pool to cache the constant configuration of the
+	 * pipeline object
+	 */
+	video->dlbs = vsp1_dl_fragment_pool_alloc(vsp1, 2, 128, 0);
+	if (!video->dlbs) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
 	return video;
 
 error:
@@ -1249,6 +1266,8 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 
 void vsp1_video_cleanup(struct vsp1_video *video)
 {
+	vsp1_dl_fragment_pool_free(video->dlbs);
+
 	if (video_is_registered(&video->video))
 		video_unregister_device(&video->video);
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 50ea7f02205f..2499d3d792b4 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -43,6 +43,8 @@ struct vsp1_video {
 
 	struct mutex lock;
 
+	struct vsp1_dl_fragment_pool *dlbs;
+	struct vsp1_dl_body *pipe_config;
 	unsigned int pipe_index;
 
 	struct vb2_queue queue;
-- 
git-series 0.9.1
