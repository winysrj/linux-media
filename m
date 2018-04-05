Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54331 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751977AbeDEJSp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:45 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 13/15] v4l: vsp1: Assign BRU and BRS to pipelines dynamically
Date: Thu,  5 Apr 2018 12:18:38 +0300
Message-Id: <20180405091840.30728-14-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSPDL variant drives two DU channels through two LIF and two
blenders, BRU and BRS. The DU channels thus share the five available
VSPDL inputs and expose them as five KMS planes.

The current implementation assigns the BRS to the second LIF and thus
artificially limits the number of planes for the second display channel
to two at most.

Lift this artificial limitation by assigning the BRU and BRS to the
display pipelines on demand based on the number of planes used by each
pipeline. When a display pipeline needs more than two inputs and the BRU
is already in use by the other pipeline, this requires reconfiguring the
other pipeline to free the BRU before processing, which can result in
frame drop on both pipelines.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 161 +++++++++++++++++++++++++++------
 drivers/media/platform/vsp1/vsp1_drm.h |   9 ++
 2 files changed, 144 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index a9c53892a9ea..f82f83b6d4ff 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -37,10 +37,15 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
 				       unsigned int completion)
 {
 	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
+	bool complete = completion == VSP1_DL_FRAME_END_COMPLETED;
 
 	if (drm_pipe->du_complete)
-		drm_pipe->du_complete(drm_pipe->du_private,
-				      completion & VSP1_DL_FRAME_END_COMPLETED);
+		drm_pipe->du_complete(drm_pipe->du_private, complete);
+
+	if (completion & VSP1_DL_FRAME_END_INTERNAL) {
+		drm_pipe->force_bru_release = false;
+		wake_up(&drm_pipe->wait_queue);
+	}
 }
 
 /* -----------------------------------------------------------------------------
@@ -150,6 +155,10 @@ static int vsp1_du_pipeline_setup_rpf(struct vsp1_device *vsp1,
 }
 
 /* Setup the BRU source pad. */
+static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
+					 struct vsp1_pipeline *pipe);
+static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe);
+
 static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
 				      struct vsp1_pipeline *pipe)
 {
@@ -157,8 +166,93 @@ static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
+	struct vsp1_entity *bru;
 	int ret;
 
+	/*
+	 * Pick a BRU:
+	 * - If we need more than two inputs, use the main BRU.
+	 * - Otherwise, if we are not forced to release our BRU, keep it.
+	 * - Else, use any free BRU (randomly starting with the main BRU).
+	 */
+	if (pipe->num_inputs > 2)
+		bru = &vsp1->bru->entity;
+	else if (pipe->bru && !drm_pipe->force_bru_release)
+		bru = pipe->bru;
+	else if (!vsp1->bru->entity.pipe)
+		bru = &vsp1->bru->entity;
+	else
+		bru = &vsp1->brs->entity;
+
+	/* Switch BRU if needed. */
+	if (bru != pipe->bru) {
+		struct vsp1_entity *released_bru = NULL;
+
+		/* Release our BRU if we have one. */
+		if (pipe->bru) {
+			/*
+			 * The BRU might be acquired by the other pipeline in
+			 * the next step. We must thus remove it from the list
+			 * of entities for this pipeline. The other pipeline's
+			 * hardware configuration will reconfigure the BRU
+			 * routing.
+			 *
+			 * However, if the other pipeline doesn't acquire our
+			 * BRU, we need to keep it in the list, otherwise the
+			 * hardware configuration step won't disconnect it from
+			 * the pipeline. To solve this, store the released BRU
+			 * pointer to add it back to the list of entities later
+			 * if it isn't acquired by the other pipeline.
+			 */
+			released_bru = pipe->bru;
+
+			list_del(&pipe->bru->list_pipe);
+			pipe->bru->sink = NULL;
+			pipe->bru->pipe = NULL;
+			pipe->bru = NULL;
+		}
+
+		/*
+		 * If the BRU we need is in use, force the owner pipeline to
+		 * switch to the other BRU and wait until the switch completes.
+		 */
+		if (bru->pipe) {
+			struct vsp1_drm_pipeline *owner_pipe;
+
+			owner_pipe = to_vsp1_drm_pipeline(bru->pipe);
+			owner_pipe->force_bru_release = true;
+
+			vsp1_du_pipeline_setup_inputs(vsp1, &owner_pipe->pipe);
+			vsp1_du_pipeline_configure(&owner_pipe->pipe);
+
+			ret = wait_event_timeout(owner_pipe->wait_queue,
+						 !owner_pipe->force_bru_release,
+						 msecs_to_jiffies(500));
+			if (ret == 0)
+				dev_warn(vsp1->dev,
+					 "DRM pipeline %u reconfiguration timeout\n",
+					 owner_pipe->pipe.lif->index);
+		}
+
+		/*
+		 * If the BRU we have released previously hasn't been acquired
+		 * by the other pipeline, add it back to the entities list (with
+		 * the pipe pointer NULL) to let vsp1_du_pipeline_configure()
+		 * disconnect it from the hardware pipeline.
+		 */
+		if (released_bru && !released_bru->pipe)
+			list_add_tail(&released_bru->list_pipe,
+				      &pipe->entities);
+
+		/* Add the BRU to the pipeline. */
+		pipe->bru = bru;
+		pipe->bru->pipe = pipe;
+		pipe->bru->sink = &pipe->output->entity;
+		pipe->bru->sink_pad = 0;
+
+		list_add_tail(&pipe->bru->list_pipe, &pipe->entities);
+	}
+
 	/*
 	 * Configure the format on the BRU source and verify that it matches the
 	 * requested format. We don't set the media bus code as it is configured
@@ -198,7 +292,7 @@ static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
 					 struct vsp1_pipeline *pipe)
 {
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
-	struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
+	struct vsp1_bru *bru;
 	unsigned int i;
 	int ret;
 
@@ -209,15 +303,6 @@ static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
 		struct vsp1_rwpf *rpf = vsp1->rpf[i];
 		unsigned int j;
 
-		/*
-		 * Make sure we don't accept more inputs than the hardware can
-		 * handle. This is a temporary fix to avoid display stall, we
-		 * need to instead allocate the BRU or BRS to display pipelines
-		 * dynamically based on the number of planes they each use.
-		 */
-		if (pipe->num_inputs >= pipe->bru->source_pad)
-			pipe->inputs[i] = NULL;
-
 		if (!pipe->inputs[i])
 			continue;
 
@@ -243,6 +328,8 @@ static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
 		return ret;
 	}
 
+	bru = to_bru(&pipe->bru->subdev);
+
 	/* Setup the RPF input pipeline for every enabled input. */
 	for (i = 0; i < pipe->bru->source_pad; ++i) {
 		struct vsp1_rwpf *rpf = inputs[i];
@@ -339,6 +426,7 @@ static int vsp1_du_pipeline_setup_output(struct vsp1_device *vsp1,
 /* Configure all entities in the pipeline. */
 static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 {
+	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
 	struct vsp1_entity *entity;
 	struct vsp1_entity *next;
 	struct vsp1_dl_list *dl;
@@ -369,7 +457,7 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 		}
 	}
 
-	vsp1_dl_list_commit(dl, false);
+	vsp1_dl_list_commit(dl, drm_pipe->force_bru_release);
 }
 
 /* -----------------------------------------------------------------------------
@@ -414,7 +502,6 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_drm_pipeline *drm_pipe;
 	struct vsp1_pipeline *pipe;
-	struct vsp1_bru *bru;
 	unsigned long flags;
 	unsigned int i;
 	int ret;
@@ -424,9 +511,14 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 
 	drm_pipe = &vsp1->drm->pipe[pipe_index];
 	pipe = &drm_pipe->pipe;
-	bru = to_bru(&pipe->bru->subdev);
 
 	if (!cfg) {
+		struct vsp1_bru *bru;
+
+		mutex_lock(&vsp1->drm->lock);
+
+		bru = to_bru(&pipe->bru->subdev);
+
 		/*
 		 * NULL configuration means the CRTC is being disabled, stop
 		 * the pipeline and turn the light off.
@@ -456,6 +548,12 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 		drm_pipe->du_complete = NULL;
 		pipe->num_inputs = 0;
 
+		list_del(&pipe->bru->list_pipe);
+		pipe->bru->pipe = NULL;
+		pipe->bru = NULL;
+
+		mutex_unlock(&vsp1->drm->lock);
+
 		vsp1_dlm_reset(pipe->output->dlm);
 		vsp1_device_put(vsp1);
 
@@ -470,19 +568,21 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 	dev_dbg(vsp1->dev, "%s: configuring LIF%u with format %ux%u\n",
 		__func__, pipe_index, cfg->width, cfg->height);
 
+	mutex_lock(&vsp1->drm->lock);
+
 	/* Setup formats through the pipeline. */
 	ret = vsp1_du_pipeline_setup_inputs(vsp1, pipe);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 
 	ret = vsp1_du_pipeline_setup_output(vsp1, pipe);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 
 	/* Enable the VSP1. */
 	ret = vsp1_device_get(vsp1);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 
 	/*
 	 * Register a callback to allow us to notify the DRM driver of frame
@@ -498,6 +598,12 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 	/* Configure all entities in the pipeline. */
 	vsp1_du_pipeline_configure(pipe);
 
+unlock:
+	mutex_unlock(&vsp1->drm->lock);
+
+	if (ret < 0)
+		return ret;
+
 	/* Start the pipeline. */
 	spin_lock_irqsave(&pipe->irqlock, flags);
 	vsp1_pipeline_run(pipe);
@@ -516,6 +622,9 @@ EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
  */
 void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index)
 {
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+
+	mutex_lock(&vsp1->drm->lock);
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
 
@@ -629,6 +738,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 
 	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
 	vsp1_du_pipeline_configure(pipe);
+	mutex_unlock(&vsp1->drm->lock);
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
 
@@ -667,28 +777,26 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 	if (!vsp1->drm)
 		return -ENOMEM;
 
+	mutex_init(&vsp1->drm->lock);
+
 	/* Create one DRM pipeline per LIF. */
 	for (i = 0; i < vsp1->info->lif_count; ++i) {
 		struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[i];
 		struct vsp1_pipeline *pipe = &drm_pipe->pipe;
 
+		init_waitqueue_head(&drm_pipe->wait_queue);
+
 		vsp1_pipeline_init(pipe);
 
 		pipe->frame_end = vsp1_du_pipeline_frame_end;
 
 		/*
-		 * The DRM pipeline is static, add entities manually. The first
-		 * pipeline uses the BRU and the second pipeline the BRS.
+		 * The output side of the DRM pipeline is static, add the
+		 * corresponding entities manually.
 		 */
-		pipe->bru = i == 0 ? &vsp1->bru->entity : &vsp1->brs->entity;
 		pipe->output = vsp1->wpf[i];
 		pipe->lif = &vsp1->lif[i]->entity;
 
-		pipe->bru->pipe = pipe;
-		pipe->bru->sink = &pipe->output->entity;
-		pipe->bru->sink_pad = 0;
-		list_add_tail(&pipe->bru->list_pipe, &pipe->entities);
-
 		pipe->output->entity.pipe = pipe;
 		pipe->output->entity.sink = pipe->lif;
 		pipe->output->entity.sink_pad = 0;
@@ -710,4 +818,5 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 
 void vsp1_drm_cleanup(struct vsp1_device *vsp1)
 {
+	mutex_destroy(&vsp1->drm->lock);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index c8dd75ba01f6..c84bc1c456c0 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -13,7 +13,9 @@
 #ifndef __VSP1_DRM_H__
 #define __VSP1_DRM_H__
 
+#include <linux/mutex.h>
 #include <linux/videodev2.h>
+#include <linux/wait.h>
 
 #include "vsp1_pipe.h"
 
@@ -22,6 +24,8 @@
  * @pipe: the VSP1 pipeline used for display
  * @width: output display width
  * @height: output display height
+ * @force_bru_release: when set, release the BRU during the next reconfiguration
+ * @wait_queue: wait queue to wait for BRU release completion
  * @du_complete: frame completion callback for the DU driver (optional)
  * @du_private: data to be passed to the du_complete callback
  */
@@ -31,6 +35,9 @@ struct vsp1_drm_pipeline {
 	unsigned int width;
 	unsigned int height;
 
+	bool force_bru_release;
+	wait_queue_head_t wait_queue;
+
 	/* Frame synchronisation */
 	void (*du_complete)(void *, bool);
 	void *du_private;
@@ -39,11 +46,13 @@ struct vsp1_drm_pipeline {
 /**
  * vsp1_drm - State for the API exposed to the DRM driver
  * @pipe: the VSP1 DRM pipeline used for display
+ * @lock: protects the BRU and BRS allocation
  * @inputs: source crop rectangle, destination compose rectangle and z-order
  *	position for every input (indexed by RPF index)
  */
 struct vsp1_drm {
 	struct vsp1_drm_pipeline pipe[VSP1_MAX_LIF];
+	struct mutex lock;
 
 	struct {
 		struct v4l2_rect crop;
-- 
Regards,

Laurent Pinchart
