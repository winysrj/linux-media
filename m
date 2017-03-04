Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751571AbdCDCCP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 21:02:15 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 2/3] v4l: vsp1: Postpone page flip in event of display list race
Date: Sat,  4 Mar 2017 02:01:18 +0000
Message-Id: <7b4ce1b20550d8651feceacf638ffc46be7400f7.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we try to commit the display list while an update is pending, we have
missed our opportunity. The display list manager will hold the commit
until the next interrupt.

In this event, we inform the vsp1 completion callback handler so that
the du will not perform a page flip out of turn.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c   |  9 +++++++--
 drivers/media/platform/vsp1/vsp1_dl.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_drm.c  |  4 +++-
 drivers/media/platform/vsp1/vsp1_pipe.c |  6 +++++-
 drivers/media/platform/vsp1/vsp1_pipe.h |  2 ++
 5 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index ad545aff4e35..f8e8c90f22bc 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -557,9 +557,10 @@ void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm)
 	spin_unlock(&dlm->lock);
 }
 
-void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
+int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 {
 	struct vsp1_device *vsp1 = dlm->vsp1;
+	int ret = 0;
 
 	spin_lock(&dlm->lock);
 
@@ -578,8 +579,10 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	 * before interrupt processing. The hardware hasn't taken the update
 	 * into account yet, we'll thus skip one frame and retry.
 	 */
-	if (vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD)
+	if (vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD) {
+		ret = -EBUSY;
 		goto done;
+	}
 
 	/* The device starts processing the queued display list right after the
 	 * frame end interrupt. The display list thus becomes active.
@@ -606,6 +609,8 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 
 done:
 	spin_unlock(&dlm->lock);
+
+	return ret;
 }
 
 /* Hardware Setup */
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 7131aa3c5978..c772a1d92513 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -28,7 +28,7 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
 void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
 void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm);
-void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
+int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
 
 struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
 void vsp1_dl_list_put(struct vsp1_dl_list *dl);
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 85e5ebca82a5..6f2dd42ca01b 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -40,10 +40,12 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_drm *drm = to_vsp1_drm(pipe);
 
-	if (drm->du_complete && drm->du_pending) {
+	if (drm->du_complete && drm->du_pending && !pipe->dl_postponed) {
 		drm->du_complete(drm->du_private);
 		drm->du_pending = false;
 	}
+
+	pipe->dl_postponed = false;
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 280ba0804699..3c5aae8767dd 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -297,10 +297,14 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
 
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
+	int ret;
+
 	if (pipe == NULL)
 		return;
 
-	vsp1_dlm_irq_frame_end(pipe->output->dlm);
+	ret = vsp1_dlm_irq_frame_end(pipe->output->dlm);
+	if (ret)
+		pipe->dl_postponed = true;
 
 	if (pipe->frame_end)
 		pipe->frame_end(pipe);
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index ac4ad2655551..65cc8fb76662 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -77,6 +77,7 @@ enum vsp1_pipeline_state {
  * @uds_input: entity at the input of the UDS, if the UDS is present
  * @entities: list of entities in the pipeline
  * @dl: display list associated with the pipeline
+ * @dl_postponed: identifies if the dl commit was caught by a race condition
  * @div_size: The maximum allowed partition size for the pipeline
  * @partitions: The number of partitions used to process one frame
  * @current_partition: The partition number currently being configured
@@ -107,6 +108,7 @@ struct vsp1_pipeline {
 	struct list_head entities;
 
 	struct vsp1_dl_list *dl;
+	bool dl_postponed;
 
 	unsigned int div_size;
 	unsigned int partitions;
-- 
git-series 0.9.1
