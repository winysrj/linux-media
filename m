Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49543 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbdG2VIw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Jul 2017 17:08:52 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 4/4] drm: rcar-du: Repair vblank for DRM page flips using the VSP
Date: Sun, 30 Jul 2017 00:08:55 +0300
Message-Id: <20170729210855.9187-5-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170729210855.9187-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170729210855.9187-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The driver recently switched from handling page flip completion in the
DU vertical blanking handler to the VSP frame end handler to fix a race
condition. This unfortunately resulted in incorrect timestamps in the
vertical blanking events sent to userspace as vertical blanking is now
handled after sending the event.

To fix this we must reverse the order of the two operations. The easiest
way is to handle vertical blanking in the VSP frame end handler before
sending the event. The VSP frame end interrupt occurs approximately 50µs
earlier than the DU frame end interrupt, but this should not cause any
undue harm.

As we need to handle vertical blanking even when page flip completion is
delayed, the VSP driver now needs to call the frame end completion
callback unconditionally, with a new argument to report whether page
flip has completed.

With this new scheme the DU vertical blanking interrupt isn't needed
anymore, so we can stop enabling it.

Fixes: d503a43ac06a ("drm: rcar-du: Register a completion callback with VSP1")
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
Changes compared to v2:

- Enable the VBK interrupt when using the VSP as patch 3/4 now needs it

Changes compared to v1:

- Don't enable the VBK interrupt when using the VSP
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c   |  8 +++++---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h   |  2 ++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c    |  8 ++++++--
 drivers/media/platform/vsp1/vsp1_drm.c   |  5 +++--
 drivers/media/platform/vsp1/vsp1_drm.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c  | 20 ++++++++++----------
 drivers/media/platform/vsp1/vsp1_pipe.h  |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c |  6 +++++-
 include/media/vsp1.h                     |  2 +-
 9 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 6e5bd0b92dfa..301ea1a8018e 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -690,6 +690,7 @@ static int rcar_du_crtc_enable_vblank(struct drm_crtc *crtc)
 
 	rcar_du_crtc_write(rcrtc, DSRCR, DSRCR_VBCL);
 	rcar_du_crtc_set(rcrtc, DIER, DIER_VBE);
+	rcrtc->vblank_enable = true;
 
 	return 0;
 }
@@ -699,6 +700,7 @@ static void rcar_du_crtc_disable_vblank(struct drm_crtc *crtc)
 	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
 
 	rcar_du_crtc_clr(rcrtc, DIER, DIER_VBE);
+	rcrtc->vblank_enable = false;
 }
 
 static const struct drm_crtc_funcs crtc_funcs = {
@@ -743,10 +745,10 @@ static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
 	spin_unlock(&rcrtc->vblank_lock);
 
 	if (status & DSSR_VBK) {
-		drm_crtc_handle_vblank(&rcrtc->crtc);
-
-		if (rcdu->info->gen < 3)
+		if (rcdu->info->gen < 3) {
+			drm_crtc_handle_vblank(&rcrtc->crtc);
 			rcar_du_crtc_finish_page_flip(rcrtc);
+		}
 
 		ret = IRQ_HANDLED;
 	}
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
index 065b91f5b1d9..fdc2bf99bda1 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
@@ -32,6 +32,7 @@ struct rcar_du_vsp;
  * @mmio_offset: offset of the CRTC registers in the DU MMIO block
  * @index: CRTC software and hardware index
  * @initialized: whether the CRTC has been initialized and clocks enabled
+ * @vblank_enable: whether vblank events are enabled on this CRTC
  * @event: event to post when the pending page flip completes
  * @flip_wait: wait queue used to signal page flip completion
  * @vblank_lock: protects vblank_wait and vblank_count
@@ -51,6 +52,7 @@ struct rcar_du_crtc {
 	unsigned int index;
 	bool initialized;
 
+	bool vblank_enable;
 	struct drm_pending_vblank_event *event;
 	wait_queue_head_t flip_wait;
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index e43b065e141a..6de6be3d9090 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -31,11 +31,15 @@
 #include "rcar_du_kms.h"
 #include "rcar_du_vsp.h"
 
-static void rcar_du_vsp_complete(void *private)
+static void rcar_du_vsp_complete(void *private, bool completed)
 {
 	struct rcar_du_crtc *crtc = private;
 
-	rcar_du_crtc_finish_page_flip(crtc);
+	if (crtc->vblank_enable)
+		drm_crtc_handle_vblank(&crtc->crtc);
+
+	if (completed)
+		rcar_du_crtc_finish_page_flip(crtc);
 }
 
 void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 7791d7b5a743..4dfbeac8f42c 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -32,12 +32,13 @@
  * Interrupt Handling
  */
 
-static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe)
+static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
+				       bool completed)
 {
 	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
 
 	if (drm_pipe->du_complete)
-		drm_pipe->du_complete(drm_pipe->du_private);
+		drm_pipe->du_complete(drm_pipe->du_private, completed);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index fca553ddd184..1cd9db785bf7 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -29,7 +29,7 @@ struct vsp1_drm_pipeline {
 	bool enabled;
 
 	/* Frame synchronisation */
-	void (*du_complete)(void *);
+	void (*du_complete)(void *, bool);
 	void *du_private;
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 9bb961298af2..4f4b732df84b 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -335,16 +335,12 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	if (pipe == NULL)
 		return;
 
+	/*
+	 * If the DL commit raced with the frame end interrupt, the commit ends
+	 * up being postponed by one frame. @completed represents whether the
+	 * active frame was finished or postponed.
+	 */
 	completed = vsp1_dlm_irq_frame_end(pipe->output->dlm);
-	if (!completed) {
-		/*
-		 * If the DL commit raced with the frame end interrupt, the
-		 * commit ends up being postponed by one frame. Return
-		 * immediately without calling the pipeline's frame end handler
-		 * or incrementing the sequence number.
-		 */
-		return;
-	}
 
 	if (pipe->hgo)
 		vsp1_hgo_frame_end(pipe->hgo);
@@ -352,8 +348,12 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	if (pipe->hgt)
 		vsp1_hgt_frame_end(pipe->hgt);
 
+	/*
+	 * Regardless of frame completion we still need to notify the pipe
+	 * frame_end to account for vblank events.
+	 */
 	if (pipe->frame_end)
-		pipe->frame_end(pipe);
+		pipe->frame_end(pipe, completed);
 
 	pipe->sequence++;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 91a784a13422..c5d01a365370 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -91,7 +91,7 @@ struct vsp1_pipeline {
 	enum vsp1_pipeline_state state;
 	wait_queue_head_t wq;
 
-	void (*frame_end)(struct vsp1_pipeline *pipe);
+	void (*frame_end)(struct vsp1_pipeline *pipe, bool completed);
 
 	struct mutex lock;
 	struct kref kref;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 84139affb871..e9f5dcb8fae5 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -440,13 +440,17 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 	vsp1_pipeline_run(pipe);
 }
 
-static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
+static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe,
+					  bool completed)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	enum vsp1_pipeline_state state;
 	unsigned long flags;
 	unsigned int i;
 
+	/* M2M Pipelines should never call here with an incomplete frame. */
+	WARN_ON_ONCE(!completed);
+
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
 	/* Complete buffers on all video nodes. */
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index c8fc868fb0f2..68a8abe4fac5 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -34,7 +34,7 @@ struct vsp1_du_lif_config {
 	unsigned int width;
 	unsigned int height;
 
-	void (*callback)(void *);
+	void (*callback)(void *, bool);
 	void *callback_data;
 };
 
-- 
Regards,

Laurent Pinchart
