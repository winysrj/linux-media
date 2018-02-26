Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54324 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbeBZVoy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 16:44:54 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH 12/15] v4l: vsp1: Generalize detection of entity removal from DRM pipeline
Date: Mon, 26 Feb 2018 23:45:13 +0200
Message-Id: <20180226214516.11559-13-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When disabling a DRM plane, the corresponding RPF is only marked as
removed from the pipeline in the atomic update handler, with the actual
removal happening when configuring the pipeline at atomic commit time.
This is required as the RPF has to be disabled in the hardware, which
can't be done from the atomic update handler.

The current implementation is RPF-specific. Make it independent of the
entity type by using the entity's pipe pointer to mark removal from the
pipeline. This will allow using the mechanism to remove BRU instances.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index d705a6e9fa1d..6c60b72b6f50 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -346,13 +346,12 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 	dl = vsp1_dl_list_get(pipe->output->dlm);
 
 	list_for_each_entry_safe(entity, next, &pipe->entities, list_pipe) {
-		/* Disconnect unused RPFs from the pipeline. */
-		if (entity->type == VSP1_ENTITY_RPF &&
-		    !pipe->inputs[entity->index]) {
+		/* Disconnect unused entities from the pipeline. */
+		if (!entity->pipe) {
 			vsp1_dl_list_write(dl, entity->route->reg,
 					   VI6_DPR_NODE_UNUSED);
 
-			entity->pipe = NULL;
+			entity->sink = NULL;
 			list_del(&entity->list_pipe);
 
 			continue;
@@ -569,10 +568,11 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 			rpf_index);
 
 		/*
-		 * Remove the RPF from the pipe's inputs. The atomic flush
-		 * handler will disable the input and remove the entity from the
-		 * pipe's entities list.
+		 * Remove the RPF from the pipeline's inputs. Keep it in the
+		 * pipeline's entity list to let vsp1_du_pipeline_configure()
+		 * remove it from the hardware pipeline.
 		 */
+		rpf->entity.pipe = NULL;
 		drm_pipe->pipe.inputs[rpf_index] = NULL;
 		return 0;
 	}
-- 
Regards,

Laurent Pinchart
