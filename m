Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52954 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbcFTTNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:13:53 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 20/24] v4l: vsp1: Simplify alpha propagation
Date: Mon, 20 Jun 2016 22:10:38 +0300
Message-Id: <1466449842-29502-21-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need to walk the pipeline when propagating the alpha value as
all the information needed for propagation is already available from the
pipeline structure.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.c | 42 +++++++--------------------------
 drivers/media/platform/vsp1/vsp1_pipe.h |  4 +---
 drivers/media/platform/vsp1/vsp1_rpf.c  |  2 +-
 drivers/media/platform/vsp1/vsp1_uds.c  |  4 +++-
 drivers/media/platform/vsp1/vsp1_uds.h  |  2 +-
 5 files changed, 14 insertions(+), 40 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index b695bee9e55c..0dd7c163c8d5 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -317,46 +317,20 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
  * to be scaled, we disable alpha scaling when the UDS input has a fixed alpha
  * value. The UDS then outputs a fixed alpha value which needs to be programmed
  * from the input RPF alpha.
- *
- * This function can only be called from a subdev s_stream handler as it
- * requires a valid display list context.
  */
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
-				   struct vsp1_entity *input,
-				   struct vsp1_dl_list *dl,
-				   unsigned int alpha)
+				   struct vsp1_dl_list *dl, unsigned int alpha)
 {
-	struct vsp1_entity *entity;
-	struct media_pad *pad;
+	if (!pipe->uds)
+		return;
 
-	/* The alpha value doesn't need to be propagated to the HGO, use
-	 * vsp1_entity_remote_pad() to traverse the graph.
+	/* The BRU background color has a fixed alpha value set to 255, the
+	 * output alpha value is thus always equal to 255.
 	 */
+	if (pipe->uds_input->type == VSP1_ENTITY_BRU)
+		alpha = 255;
 
-	pad = vsp1_entity_remote_pad(&input->pads[RWPF_PAD_SOURCE]);
-
-	while (pad) {
-		if (!is_media_entity_v4l2_subdev(pad->entity))
-			break;
-
-		entity = to_vsp1_entity(media_entity_to_v4l2_subdev(pad->entity));
-
-		/* The BRU background color has a fixed alpha value set to 255,
-		 * the output alpha value is thus always equal to 255.
-		 */
-		if (entity->type == VSP1_ENTITY_BRU)
-			alpha = 255;
-
-		if (entity->type == VSP1_ENTITY_UDS) {
-			struct vsp1_uds *uds = to_uds(&entity->subdev);
-
-			vsp1_uds_set_alpha(uds, dl, alpha);
-			break;
-		}
-
-		pad = &entity->pads[entity->source_pad];
-		pad = vsp1_entity_remote_pad(pad);
-	}
+	vsp1_uds_set_alpha(pipe->uds, dl, alpha);
 }
 
 void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 2cbf1a5ea1fb..bd42effe405e 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -119,9 +119,7 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe);
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
-				   struct vsp1_entity *input,
-				   struct vsp1_dl_list *dl,
-				   unsigned int alpha);
+				   struct vsp1_dl_list *dl, unsigned int alpha);
 
 void vsp1_pipelines_suspend(struct vsp1_device *vsp1);
 void vsp1_pipelines_resume(struct vsp1_device *vsp1);
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index bcfa5bce12fb..2a734b131110 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -206,7 +206,7 @@ static void rpf_configure(struct vsp1_entity *entity,
 		vsp1_rpf_write(rpf, dl, VI6_RPF_MULT_ALPHA, mult);
 	}
 
-	vsp1_pipeline_propagate_alpha(pipe, &rpf->entity, dl, rpf->alpha);
+	vsp1_pipeline_propagate_alpha(pipe, dl, rpf->alpha);
 
 	vsp1_rpf_write(rpf, dl, VI6_RPF_MSK_CTRL, 0);
 	vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index e916f454e3a4..5291f8b36688 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -40,9 +40,11 @@ static inline void vsp1_uds_write(struct vsp1_uds *uds, struct vsp1_dl_list *dl,
  * Scaling Computation
  */
 
-void vsp1_uds_set_alpha(struct vsp1_uds *uds, struct vsp1_dl_list *dl,
+void vsp1_uds_set_alpha(struct vsp1_entity *entity, struct vsp1_dl_list *dl,
 			unsigned int alpha)
 {
+	struct vsp1_uds *uds = to_uds(&entity->subdev);
+
 	vsp1_uds_write(uds, dl, VI6_UDS_ALPVAL,
 		       alpha << VI6_UDS_ALPVAL_VAL0_SHIFT);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_uds.h b/drivers/media/platform/vsp1/vsp1_uds.h
index 5c8cbfcad4cc..7bf3cdcffc65 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.h
+++ b/drivers/media/platform/vsp1/vsp1_uds.h
@@ -35,7 +35,7 @@ static inline struct vsp1_uds *to_uds(struct v4l2_subdev *subdev)
 
 struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index);
 
-void vsp1_uds_set_alpha(struct vsp1_uds *uds, struct vsp1_dl_list *dl,
+void vsp1_uds_set_alpha(struct vsp1_entity *uds, struct vsp1_dl_list *dl,
 			unsigned int alpha);
 
 #endif /* __VSP1_UDS_H__ */
-- 
Regards,

Laurent Pinchart

