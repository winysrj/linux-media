Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54331 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751926AbeDEJSj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:39 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 05/15] v4l: vsp1: Share duplicated DRM pipeline configuration code
Date: Thu,  5 Apr 2018 12:18:30 +0300
Message-Id: <20180405091840.30728-6-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the duplicated DRM pipeline configuration code to a function and
call it from vsp1_du_setup_lif() and vsp1_du_atomic_flush().

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 95 +++++++++++++++-------------------
 1 file changed, 43 insertions(+), 52 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index e210917fdc3f..9a043a915c0b 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -42,6 +42,47 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
 		drm_pipe->du_complete(drm_pipe->du_private, completed);
 }
 
+/* -----------------------------------------------------------------------------
+ * Pipeline Configuration
+ */
+
+/* Configure all entities in the pipeline. */
+static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_entity *entity;
+	struct vsp1_entity *next;
+	struct vsp1_dl_list *dl;
+
+	dl = vsp1_dl_list_get(pipe->output->dlm);
+
+	list_for_each_entry_safe(entity, next, &pipe->entities, list_pipe) {
+		/* Disconnect unused RPFs from the pipeline. */
+		if (entity->type == VSP1_ENTITY_RPF &&
+		    !pipe->inputs[entity->index]) {
+			vsp1_dl_list_write(dl, entity->route->reg,
+					   VI6_DPR_NODE_UNUSED);
+
+			entity->pipe = NULL;
+			list_del(&entity->list_pipe);
+
+			continue;
+		}
+
+		vsp1_entity_route_setup(entity, pipe, dl);
+
+		if (entity->ops->configure) {
+			entity->ops->configure(entity, pipe, dl,
+					       VSP1_ENTITY_PARAMS_INIT);
+			entity->ops->configure(entity, pipe, dl,
+					       VSP1_ENTITY_PARAMS_RUNTIME);
+			entity->ops->configure(entity, pipe, dl,
+					       VSP1_ENTITY_PARAMS_PARTITION);
+		}
+	}
+
+	vsp1_dl_list_commit(dl);
+}
+
 /* -----------------------------------------------------------------------------
  * DU Driver API
  */
@@ -85,9 +126,6 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 	struct vsp1_drm_pipeline *drm_pipe;
 	struct vsp1_pipeline *pipe;
 	struct vsp1_bru *bru;
-	struct vsp1_entity *entity;
-	struct vsp1_entity *next;
-	struct vsp1_dl_list *dl;
 	struct v4l2_subdev_format format;
 	unsigned long flags;
 	unsigned int i;
@@ -239,22 +277,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 	vsp1_write(vsp1, VI6_DISP_IRQ_ENB, 0);
 
 	/* Configure all entities in the pipeline. */
-	dl = vsp1_dl_list_get(pipe->output->dlm);
-
-	list_for_each_entry_safe(entity, next, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe, dl);
-
-		if (entity->ops->configure) {
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_INIT);
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_RUNTIME);
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_PARTITION);
-		}
-	}
-
-	vsp1_dl_list_commit(dl);
+	vsp1_du_pipeline_configure(pipe);
 
 	/* Start the pipeline. */
 	spin_lock_irqsave(&pipe->irqlock, flags);
@@ -490,15 +513,9 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 	struct vsp1_pipeline *pipe = &drm_pipe->pipe;
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
 	struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
-	struct vsp1_entity *entity;
-	struct vsp1_entity *next;
-	struct vsp1_dl_list *dl;
 	unsigned int i;
 	int ret;
 
-	/* Prepare the display list. */
-	dl = vsp1_dl_list_get(pipe->output->dlm);
-
 	/* Count the number of enabled inputs and sort them by Z-order. */
 	pipe->num_inputs = 0;
 
@@ -557,33 +574,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 				__func__, rpf->entity.index);
 	}
 
-	/* Configure all entities in the pipeline. */
-	list_for_each_entry_safe(entity, next, &pipe->entities, list_pipe) {
-		/* Disconnect unused RPFs from the pipeline. */
-		if (entity->type == VSP1_ENTITY_RPF &&
-		    !pipe->inputs[entity->index]) {
-			vsp1_dl_list_write(dl, entity->route->reg,
-					   VI6_DPR_NODE_UNUSED);
-
-			entity->pipe = NULL;
-			list_del(&entity->list_pipe);
-
-			continue;
-		}
-
-		vsp1_entity_route_setup(entity, pipe, dl);
-
-		if (entity->ops->configure) {
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_INIT);
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_RUNTIME);
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_PARTITION);
-		}
-	}
-
-	vsp1_dl_list_commit(dl);
+	vsp1_du_pipeline_configure(pipe);
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
 
-- 
Regards,

Laurent Pinchart
