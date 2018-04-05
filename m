Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54335 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbeDEJSn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:43 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 10/15] v4l: vsp1: Turn frame end completion status into a bitfield
Date: Thu,  5 Apr 2018 12:18:35 +0300
Message-Id: <20180405091840.30728-11-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We will soon need to return more than a boolean completion status from
the vsp1_dlm_irq_frame_end() IRQ handler. Turn the return value into a
bitfield to prepare for that. No functional change is introduced here.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c    | 22 +++++++++++++---------
 drivers/media/platform/vsp1/vsp1_dl.h    |  4 +++-
 drivers/media/platform/vsp1/vsp1_drm.c   |  5 +++--
 drivers/media/platform/vsp1/vsp1_pipe.c  |  8 ++++----
 drivers/media/platform/vsp1/vsp1_pipe.h  |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c |  4 ++--
 6 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 0b86ed01e85d..662fa2a347c9 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -616,14 +616,18 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
  * vsp1_dlm_irq_frame_end - Display list handler for the frame end interrupt
  * @dlm: the display list manager
  *
- * Return true if the previous display list has completed at frame end, or false
- * if it has been delayed by one frame because the display list commit raced
- * with the frame end interrupt. The function always returns true in header mode
- * as display list processing is then not continuous and races never occur.
+ * Return a set of flags that indicates display list completion status.
+ *
+ * The VSP1_DL_FRAME_END_COMPLETED flag indicates that the previous display list
+ * has completed at frame end. If the flag is not returned display list
+ * completion has been delayed by one frame because the display list commit
+ * raced with the frame end interrupt. The function always returns with the flag
+ * set in header mode as display list processing is then not continuous and
+ * races never occur.
  */
-bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
+unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 {
-	bool completed = false;
+	unsigned int flags = 0;
 
 	spin_lock(&dlm->lock);
 
@@ -634,7 +638,7 @@ bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	if (dlm->singleshot) {
 		__vsp1_dl_list_put(dlm->active);
 		dlm->active = NULL;
-		completed = true;
+		flags |= VSP1_DL_FRAME_END_COMPLETED;
 		goto done;
 	}
 
@@ -655,7 +659,7 @@ bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 		__vsp1_dl_list_put(dlm->active);
 		dlm->active = dlm->queued;
 		dlm->queued = NULL;
-		completed = true;
+		flags |= VSP1_DL_FRAME_END_COMPLETED;
 	}
 
 	/*
@@ -672,7 +676,7 @@ bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 done:
 	spin_unlock(&dlm->lock);
 
-	return completed;
+	return flags;
 }
 
 /* Hardware Setup */
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index ee3508172f0a..cbc2fc53e10b 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -20,6 +20,8 @@ struct vsp1_dl_fragment;
 struct vsp1_dl_list;
 struct vsp1_dl_manager;
 
+#define VSP1_DL_FRAME_END_COMPLETED		BIT(0)
+
 void vsp1_dlm_setup(struct vsp1_device *vsp1);
 
 struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
@@ -27,7 +29,7 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 					unsigned int prealloc);
 void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
 void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
-bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
+unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
 
 struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
 void vsp1_dl_list_put(struct vsp1_dl_list *dl);
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index a7cccc9b05ef..541473b1df67 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -34,12 +34,13 @@
  */
 
 static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
-				       bool completed)
+				       unsigned int completion)
 {
 	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
 
 	if (drm_pipe->du_complete)
-		drm_pipe->du_complete(drm_pipe->du_private, completed);
+		drm_pipe->du_complete(drm_pipe->du_private,
+				      completion & VSP1_DL_FRAME_END_COMPLETED);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 99ccbac3256a..1134f14ed4aa 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -315,17 +315,17 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
 
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
-	bool completed;
+	unsigned int flags;
 
 	if (pipe == NULL)
 		return;
 
 	/*
 	 * If the DL commit raced with the frame end interrupt, the commit ends
-	 * up being postponed by one frame. @completed represents whether the
+	 * up being postponed by one frame. The returned flags tell whether the
 	 * active frame was finished or postponed.
 	 */
-	completed = vsp1_dlm_irq_frame_end(pipe->output->dlm);
+	flags = vsp1_dlm_irq_frame_end(pipe->output->dlm);
 
 	if (pipe->hgo)
 		vsp1_hgo_frame_end(pipe->hgo);
@@ -338,7 +338,7 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	 * frame_end to account for vblank events.
 	 */
 	if (pipe->frame_end)
-		pipe->frame_end(pipe, completed);
+		pipe->frame_end(pipe, flags);
 
 	pipe->sequence++;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index dfff9b5685fe..412da67527c0 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -118,7 +118,7 @@ struct vsp1_pipeline {
 	enum vsp1_pipeline_state state;
 	wait_queue_head_t wq;
 
-	void (*frame_end)(struct vsp1_pipeline *pipe, bool completed);
+	void (*frame_end)(struct vsp1_pipeline *pipe, unsigned int completion);
 
 	struct mutex lock;
 	struct kref kref;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index cdd53d6cc408..4152704c2ccb 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -444,7 +444,7 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 }
 
 static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe,
-					  bool completed)
+					  unsigned int completion)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	enum vsp1_pipeline_state state;
@@ -452,7 +452,7 @@ static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe,
 	unsigned int i;
 
 	/* M2M Pipelines should never call here with an incomplete frame. */
-	WARN_ON_ONCE(!completed);
+	WARN_ON_ONCE(!(completion & VSP1_DL_FRAME_END_COMPLETED));
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
-- 
Regards,

Laurent Pinchart
