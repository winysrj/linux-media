Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752864AbdEEPVX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 11:21:23 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, mchehab@kernel.org
Cc: kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v4 2/4] v4l: vsp1: Postpone frame end handling in event of display list race
Date: Fri,  5 May 2017 16:21:08 +0100
Message-Id: <e36532f33bed86666e9d7c2c23b7d797860e3457.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we try to commit the display list while an update is pending, we have
missed our opportunity. The display list manager will hold the commit
until the next interrupt.

In this event, we skip the pipeline completion callback handler so that
the pipeline will not mistakenly report frame completion to the user.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c   | 19 +++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_dl.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c | 13 ++++++++++++-
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 7d8f37772b56..85fe2b4ae310 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -561,9 +561,19 @@ void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm)
 	spin_unlock(&dlm->lock);
 }
 
-void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
+/**
+ * vsp1_dlm_irq_frame_end - Display list handler for the frame end interrupt
+ * @dlm: the display list manager
+ *
+ * Return true if the previous display list has completed at frame end, or false
+ * if it has been delayed by one frame because the display list commit raced
+ * with the frame end interrupt. The function always returns true in header mode
+ * as display list processing is then not continuous and races never occur.
+ */
+bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 {
 	struct vsp1_device *vsp1 = dlm->vsp1;
+	bool completed = false;
 
 	spin_lock(&dlm->lock);
 
@@ -575,8 +585,10 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	 * perform any operation as there can't be any new display list queued
 	 * in that case.
 	 */
-	if (dlm->mode == VSP1_DL_MODE_HEADER)
+	if (dlm->mode == VSP1_DL_MODE_HEADER) {
+		completed = true;
 		goto done;
+	}
 
 	/*
 	 * The UPD bit set indicates that the commit operation raced with the
@@ -594,6 +606,7 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	if (dlm->queued) {
 		dlm->active = dlm->queued;
 		dlm->queued = NULL;
+		completed = true;
 	}
 
 	/*
@@ -614,6 +627,8 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 
 done:
 	spin_unlock(&dlm->lock);
+
+	return completed;
 }
 
 /* Hardware Setup */
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 7131aa3c5978..6ec1380a10af 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -28,7 +28,7 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
 void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
 void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm);
-void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
+bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
 
 struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
 void vsp1_dl_list_put(struct vsp1_dl_list *dl);
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index edebf3fa926f..e817623b84e0 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -330,10 +330,21 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
 
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
+	bool completed;
+
 	if (pipe == NULL)
 		return;
 
-	vsp1_dlm_irq_frame_end(pipe->output->dlm);
+	completed = vsp1_dlm_irq_frame_end(pipe->output->dlm);
+	if (!completed) {
+		/*
+		 * If the DL commit raced with the frame end interrupt, the
+		 * commit ends up being postponed by one frame. Return
+		 * immediately without calling the pipeline's frame end handler
+		 * or incrementing the sequence number.
+		 */
+		return;
+	}
 
 	if (pipe->hgo)
 		vsp1_hgo_frame_end(pipe->hgo);
-- 
git-series 0.9.1
