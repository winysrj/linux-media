Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761843AbdAFMQY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jan 2017 07:16:24 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 4/4] v4l: vsp1: Remove redundant pipe->dl usage from drm
Date: Fri,  6 Jan 2017 12:15:31 +0000
Message-Id: <920ab93c049e3887510ee030082dc81e64bd760c.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4df11e0fa078e5cc8bc8f668951249cca0fd3d7f.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4df11e0fa078e5cc8bc8f668951249cca0fd3d7f.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4df11e0fa078e5cc8bc8f668951249cca0fd3d7f.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4df11e0fa078e5cc8bc8f668951249cca0fd3d7f.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pipe->dl is used only inside vsp1_du_atomic_flush(), and can be
obtained and stored locally to simplify the code.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c  | 20 ++++++++++----------
 drivers/media/platform/vsp1/vsp1_pipe.h |  2 --
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index b4b583f7137a..d7ec980300dd 100644
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
index fff122b4874d..e59bef2653f6 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -108,8 +108,6 @@ struct vsp1_pipeline {
 
 	struct list_head entities;
 
-	struct vsp1_dl_list *dl;
-
 	unsigned int div_size;
 	unsigned int partitions;
 	struct v4l2_rect partition;
-- 
git-series 0.9.1
