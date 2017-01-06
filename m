Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761818AbdAFMQY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jan 2017 07:16:24 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 2/4] v4l: vsp1: Move vsp1_video_setup_pipeline()
Date: Fri,  6 Jan 2017 12:15:29 +0000
Message-Id: <703b4aa60797b9ce28ed26a0d8b2583a62a181f4.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4df11e0fa078e5cc8bc8f668951249cca0fd3d7f.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4df11e0fa078e5cc8bc8f668951249cca0fd3d7f.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4df11e0fa078e5cc8bc8f668951249cca0fd3d7f.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4df11e0fa078e5cc8bc8f668951249cca0fd3d7f.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the static vsp1_video_setup_pipeline() function in preparation for
the callee updates so that the vsp1_video_pipeline_run() call can
configure pipelines following suspend resume actions.

This commit is just a code move for clarity performing no functional
change.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 82 ++++++++++++-------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index f7dc249eb398..938ecc2766ed 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -355,6 +355,47 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 	pipe->buffers_ready |= 1 << video->pipe_index;
 }
 
+static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_entity *entity;
+
+	/* Determine this pipelines sizes for image partitioning support. */
+	vsp1_video_pipeline_setup_partitions(pipe);
+
+	/* Prepare the display list. */
+	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
+	if (!pipe->dl)
+		return -ENOMEM;
+
+	if (pipe->uds) {
+		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
+
+		/* If a BRU is present in the pipeline before the UDS, the alpha
+		 * component doesn't need to be scaled as the BRU output alpha
+		 * value is fixed to 255. Otherwise we need to scale the alpha
+		 * component only when available at the input RPF.
+		 */
+		if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
+			uds->scale_alpha = false;
+		} else {
+			struct vsp1_rwpf *rpf =
+				to_rwpf(&pipe->uds_input->subdev);
+
+			uds->scale_alpha = rpf->fmtinfo->alpha;
+		}
+	}
+
+	list_for_each_entry(entity, &pipe->entities, list_pipe) {
+		vsp1_entity_route_setup(entity, pipe->dl);
+
+		if (entity->ops->configure)
+			entity->ops->configure(entity, pipe, pipe->dl,
+					       VSP1_ENTITY_PARAMS_INIT);
+	}
+
+	return 0;
+}
+
 static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 					      struct vsp1_dl_list *dl)
 {
@@ -752,47 +793,6 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
-static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
-{
-	struct vsp1_entity *entity;
-
-	/* Determine this pipelines sizes for image partitioning support. */
-	vsp1_video_pipeline_setup_partitions(pipe);
-
-	/* Prepare the display list. */
-	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
-	if (!pipe->dl)
-		return -ENOMEM;
-
-	if (pipe->uds) {
-		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
-
-		/* If a BRU is present in the pipeline before the UDS, the alpha
-		 * component doesn't need to be scaled as the BRU output alpha
-		 * value is fixed to 255. Otherwise we need to scale the alpha
-		 * component only when available at the input RPF.
-		 */
-		if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
-			uds->scale_alpha = false;
-		} else {
-			struct vsp1_rwpf *rpf =
-				to_rwpf(&pipe->uds_input->subdev);
-
-			uds->scale_alpha = rpf->fmtinfo->alpha;
-		}
-	}
-
-	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe->dl);
-
-		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl,
-					       VSP1_ENTITY_PARAMS_INIT);
-	}
-
-	return 0;
-}
-
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
-- 
git-series 0.9.1
