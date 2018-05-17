Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50652 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752539AbeEQRYO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 13:24:14 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v10 8/8] media: vsp1: Move video configuration to a cached dlb
Date: Thu, 17 May 2018 18:24:01 +0100
Message-Id: <3d2f6f2901b04db73a9c2f8189b97079b2a55371.1526577622.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.e217e37c63010c4a78c4022a30a389e5d7627919.1526577622.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.e217e37c63010c4a78c4022a30a389e5d7627919.1526577622.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.e217e37c63010c4a78c4022a30a389e5d7627919.1526577622.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.e217e37c63010c4a78c4022a30a389e5d7627919.1526577622.git-series.kieran.bingham+renesas@ideasonboard.com>
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

The pipe object is marked as un-configured when resuming from a suspend.
This ensures that when the hardware is reset - our cached configuration
will be re-attached to the next committed DL.

Our video DL usage now looks like the below output:

dl->body0 contains our disposable runtime configuration. Max 41.
dl_child->body0 is our partition specific configuration. Max 12.
dl->bodies shows our constant configuration and LUTs.

  These two are LUT/CLU:
     * dl->bodies[x]->num_entries 256 / max 256
     * dl->bodies[x]->num_entries 4914 / max 4914

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
  dl->bodies[x]->num_entries 15 / max 128
  dl->bodies[x]->num_entries 16 / max 128
  dl->bodies[x]->num_entries 17 / max 128
  dl->bodies[x]->num_entries 18 / max 128
  dl->bodies[x]->num_entries 20 / max 128
  dl->bodies[x]->num_entries 21 / max 128
  dl->bodies[x]->num_entries 256 / max 256
  dl->bodies[x]->num_entries 31 / max 128
  dl->bodies[x]->num_entries 32 / max 128
  dl->bodies[x]->num_entries 39 / max 128
  dl->bodies[x]->num_entries 40 / max 128
  dl->bodies[x]->num_entries 47 / max 128
  dl->bodies[x]->num_entries 48 / max 128
  dl->bodies[x]->num_entries 4914 / max 4914
  dl->bodies[x]->num_entries 55 / max 128
  dl->bodies[x]->num_entries 56 / max 128
  dl->bodies[x]->num_entries 63 / max 128
  dl->bodies[x]->num_entries 64 / max 128

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
v10:
 - Removed pipe->configured flag, and use
   pipe->state == VSP1_PIPELINE_STOPPED instead.

v8:
 - Fix comments
 - Rename video->pipe_config -> video->stream_config

v4:
 - Adjust pipe configured flag to be reset on resume rather than suspend
 - rename dl_child, dl_next

v3:
 - 's/fragment/body/', 's/fragments/bodies/'
 - video dlb cache allocation increased from 2 to 3 dlbs

 drivers/media/platform/vsp1/vsp1_pipe.h  |  3 +-
 drivers/media/platform/vsp1/vsp1_video.c | 67 +++++++++++++++----------
 drivers/media/platform/vsp1/vsp1_video.h |  2 +-
 3 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index e00010693eef..be6ecab3cbed 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -102,7 +102,6 @@ struct vsp1_partition {
  * @uds: UDS entity, if present
  * @uds_input: entity at the input of the UDS, if the UDS is present
  * @entities: list of entities in the pipeline
- * @dl: display list associated with the pipeline
  * @partitions: The number of partitions used to process one frame
  * @partition: The current partition for configuration to process
  * @part_table: The pre-calculated partitions used by the pipeline
@@ -139,8 +138,6 @@ struct vsp1_pipeline {
 	 */
 	struct list_head entities;
 
-	struct vsp1_dl_list *dl;
-
 	unsigned int partitions;
 	struct vsp1_partition *partition;
 	struct vsp1_partition *part_table;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 72f29773eb1c..f2bc26d28396 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -390,44 +390,48 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+	struct vsp1_video *video = pipe->output->video;
 	struct vsp1_entity *entity;
 	struct vsp1_dl_body *dlb;
+	struct vsp1_dl_list *dl;
 	unsigned int partition;
 
-	if (!pipe->dl)
-		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
+	dl = vsp1_dl_list_get(pipe->output->dlm);
+
+	/* Attach our pipe configuration to fully initialise the hardware. */
+	if (pipe->state == VSP1_PIPELINE_STOPPED)
+		vsp1_dl_list_add_body(dl, video->stream_config);
 
-	dlb = vsp1_dl_list_get_body0(pipe->dl);
+	dlb = vsp1_dl_list_get_body0(dl);
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe)
-		vsp1_entity_configure_frame(entity, pipe, pipe->dl, dlb);
+		vsp1_entity_configure_frame(entity, pipe, dl, dlb);
 
 	/* Run the first partition. */
-	vsp1_video_pipeline_run_partition(pipe, pipe->dl, 0);
+	vsp1_video_pipeline_run_partition(pipe, dl, 0);
 
 	/* Process consecutive partitions as necessary. */
 	for (partition = 1; partition < pipe->partitions; ++partition) {
-		struct vsp1_dl_list *dl;
+		struct vsp1_dl_list *dl_next;
 
-		dl = vsp1_dl_list_get(pipe->output->dlm);
+		dl_next = vsp1_dl_list_get(pipe->output->dlm);
 
 		/*
 		 * An incomplete chain will still function, but output only
 		 * the partitions that had a dl available. The frame end
 		 * interrupt will be marked on the last dl in the chain.
 		 */
-		if (!dl) {
+		if (!dl_next) {
 			dev_err(vsp1->dev, "Failed to obtain a dl list. Frame will be incomplete\n");
 			break;
 		}
 
-		vsp1_video_pipeline_run_partition(pipe, dl, partition);
-		vsp1_dl_list_add_chain(pipe->dl, dl);
+		vsp1_video_pipeline_run_partition(pipe, dl_next, partition);
+		vsp1_dl_list_add_chain(dl, dl_next);
 	}
 
 	/* Complete, and commit the head display list. */
-	vsp1_dl_list_commit(pipe->dl, false);
-	pipe->dl = NULL;
+	vsp1_dl_list_commit(dl, false);
 
 	vsp1_pipeline_run(pipe);
 }
@@ -790,8 +794,8 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 
 static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 {
+	struct vsp1_video *video = pipe->output->video;
 	struct vsp1_entity *entity;
-	struct vsp1_dl_body *dlb;
 	int ret;
 
 	/* Determine this pipelines sizes for image partitioning support. */
@@ -799,14 +803,6 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	if (ret < 0)
 		return ret;
 
-	/* Prepare the display list. */
-	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
-	if (!pipe->dl)
-		return -ENOMEM;
-
-	/* Retrieve the default DLB from the list. */
-	dlb = vsp1_dl_list_get_body0(pipe->dl);
-
 	if (pipe->uds) {
 		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
 
@@ -828,9 +824,16 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 		}
 	}
 
+	/* Obtain a clean body from our pool. */
+	video->stream_config = vsp1_dl_body_get(video->dlbs);
+	if (!video->stream_config)
+		return -ENOMEM;
+
+	/* Configure the entities into our cached pipe configuration. */
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe, dlb);
-		vsp1_entity_configure_stream(entity, pipe, dlb);
+		vsp1_entity_route_setup(entity, pipe, video->stream_config);
+		vsp1_entity_configure_stream(entity, pipe,
+					     video->stream_config);
 	}
 
 	return 0;
@@ -842,6 +845,9 @@ static void vsp1_video_cleanup_pipeline(struct vsp1_pipeline *pipe)
 	struct vsp1_vb2_buffer *buffer;
 	unsigned long flags;
 
+	/* Release any cached configuration. */
+	vsp1_dl_body_put(video->stream_config);
+
 	/* Remove all buffers from the IRQ queue. */
 	spin_lock_irqsave(&video->irqlock, flags);
 	list_for_each_entry(buffer, &video->irqqueue, queue)
@@ -918,9 +924,6 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 		ret = vsp1_pipeline_stop(pipe);
 		if (ret == -ETIMEDOUT)
 			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
-
-		vsp1_dl_list_put(pipe->dl);
-		pipe->dl = NULL;
 	}
 	mutex_unlock(&pipe->lock);
 
@@ -1240,6 +1243,16 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 		goto error;
 	}
 
+	/*
+	 * Utilise a body pool to cache the constant configuration of the
+	 * pipeline object.
+	 */
+	video->dlbs = vsp1_dl_body_pool_create(vsp1, 3, 128, 0);
+	if (!video->dlbs) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
 	return video;
 
 error:
@@ -1249,6 +1262,8 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 
 void vsp1_video_cleanup(struct vsp1_video *video)
 {
+	vsp1_dl_body_pool_destroy(video->dlbs);
+
 	if (video_is_registered(&video->video))
 		video_unregister_device(&video->video);
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 75a5a65c66fe..77bbfb4a5b54 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -39,6 +39,8 @@ struct vsp1_video {
 
 	struct mutex lock;
 
+	struct vsp1_dl_body_pool *dlbs;
+	struct vsp1_dl_body *stream_config;
 	unsigned int pipe_index;
 
 	struct vb2_queue queue;
-- 
git-series 0.9.1
