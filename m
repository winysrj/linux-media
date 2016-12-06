Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753002AbcLFJfg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 04:35:36 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 3/4] v4l: vsp1: Use local display lists and remove global pipe->dl
Date: Tue,  6 Dec 2016 09:35:12 +0000
Message-Id: <1481016913-30608-4-git-send-email-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <1481016913-30608-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1481016913-30608-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The usage of pipe->dl is susceptible to races, and it is redundant to
keep this pointer in a larger scoped context.

Now that the calling order of vsp1_video_setup_pipeline() has been
adapted, it is possible to remove the pipe->dl and pass the variable as
required.

Currently the pipe->dl is set during the atomic begin hook, but it is
not utilised until the flush. Moving this should do no harm.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c   | 20 +++++++-------
 drivers/media/platform/vsp1/vsp1_pipe.h  |  2 --
 drivers/media/platform/vsp1/vsp1_video.c | 45 ++++++++++++++------------------
 3 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index cd209dccff1b..bf735e85b597 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -220,9 +220,6 @@ void vsp1_du_atomic_begin(struct device *dev)
 	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
 
 	vsp1->drm->num_inputs = pipe->num_inputs;
-
-	/* Prepare the display list. */
-	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
 
@@ -426,10 +423,14 @@ void vsp1_du_atomic_flush(struct device *dev)
 	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
 	struct vsp1_entity *entity;
+	struct vsp1_dl_list *dl;
 	unsigned long flags;
 	unsigned int i;
 	int ret;
 
+	/* Prepare the display list. */
+	dl = vsp1_dl_list_get(pipe->output->dlm);
+
 	/* Count the number of enabled inputs and sort them by Z-order. */
 	pipe->num_inputs = 0;
 
@@ -484,26 +485,25 @@ void vsp1_du_atomic_flush(struct device *dev)
 			struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 
 			if (!pipe->inputs[rpf->entity.index]) {
-				vsp1_dl_list_write(pipe->dl, entity->route->reg,
+				vsp1_dl_list_write(dl, entity->route->reg,
 						   VI6_DPR_NODE_UNUSED);
 				continue;
 			}
 		}
 
-		vsp1_entity_route_setup(entity, pipe->dl);
+		vsp1_entity_route_setup(entity, dl);
 
 		if (entity->ops->configure) {
-			entity->ops->configure(entity, pipe, pipe->dl,
+			entity->ops->configure(entity, pipe, dl,
 					       VSP1_ENTITY_PARAMS_INIT);
-			entity->ops->configure(entity, pipe, pipe->dl,
+			entity->ops->configure(entity, pipe, dl,
 					       VSP1_ENTITY_PARAMS_RUNTIME);
-			entity->ops->configure(entity, pipe, pipe->dl,
+			entity->ops->configure(entity, pipe, dl,
 					       VSP1_ENTITY_PARAMS_PARTITION);
 		}
 	}
 
-	vsp1_dl_list_commit(pipe->dl);
-	pipe->dl = NULL;
+	vsp1_dl_list_commit(dl);
 
 	/* Start or stop the pipeline if needed. */
 	if (!vsp1->drm->num_inputs && pipe->num_inputs) {
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 0743b9fcb655..98980c85081f 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -108,8 +108,6 @@ struct vsp1_pipeline {
 
 	struct list_head entities;
 
-	struct vsp1_dl_list *dl;
-
 	unsigned int div_size;
 	unsigned int partitions;
 	struct v4l2_rect partition;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 7ff9f4c19ff0..9619ed4dda7c 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -350,18 +350,14 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
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
 
@@ -381,10 +377,10 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	}
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe->dl);
+		vsp1_entity_route_setup(entity, dl);
 
 		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl,
+			entity->ops->configure(entity, pipe, dl,
 					       VSP1_ENTITY_PARAMS_INIT);
 	}
 
@@ -412,12 +408,16 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	struct vsp1_entity *entity;
+	struct vsp1_dl_list *dl;
 
-	if (!pipe->configured)
-		vsp1_video_setup_pipeline(pipe);
+	dl = vsp1_dl_list_get(pipe->output->dlm);
+	if (!dl) {
+		dev_err(vsp1->dev, "Failed to obtain a dl list\n");
+		return;
+	}
 
-	if (!pipe->dl)
-		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
+	if (!pipe->configured)
+		vsp1_video_setup_pipeline(pipe, dl);
 
 	/*
 	 * Start with the runtime parameters as the configure operation can
@@ -426,45 +426,43 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
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
 
@@ -835,9 +833,6 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 		ret = vsp1_pipeline_stop(pipe);
 		if (ret == -ETIMEDOUT)
 			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
-
-		vsp1_dl_list_put(pipe->dl);
-		pipe->dl = NULL;
 	}
 	mutex_unlock(&pipe->lock);
 
-- 
2.7.4

