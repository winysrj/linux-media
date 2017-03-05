Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752425AbdCEQAO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Mar 2017 11:00:14 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 1/3] v4l: vsp1: Postpone frame end handling in event of display list race
Date: Sun,  5 Mar 2017 16:00:02 +0000
Message-Id: <b3bc755c2c88ce4e81e16f47f6f34de1fca79e28.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.8e2f9686131cb2299b859f056e902b4208061a4e.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.8e2f9686131cb2299b859f056e902b4208061a4e.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.8e2f9686131cb2299b859f056e902b4208061a4e.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.8e2f9686131cb2299b859f056e902b4208061a4e.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we try to commit the display list while an update is pending, we have
missed our opportunity. The display list manager will hold the commit
until the next interrupt.

In this event, we skip the pipeline completion callback handler so that
the pipeline will not mistakenly report frame completion to the user.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c   | 19 +++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_dl.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c | 13 ++++++++++++-
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index b9e5027778ff..f449ca689554 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -562,9 +562,19 @@ void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm)
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
 
@@ -576,8 +586,10 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
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
@@ -597,6 +609,7 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	if (dlm->queued) {
 		dlm->active = dlm->queued;
 		dlm->queued = NULL;
+		completed = true;
 	}
 
 	/*
@@ -619,6 +632,8 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 
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
index 35364f594e19..d15327701ad8 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -304,10 +304,21 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
 
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
 
 	if (pipe->frame_end)
 		pipe->frame_end(pipe);
-- 
git-series 0.9.1
