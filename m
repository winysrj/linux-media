Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751830AbdF2P6P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 11:58:15 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, laurent.pinchart@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1.1 2/2] drm: rcar-du: Repair vblank for DRM page flips using the VSP1
Date: Thu, 29 Jun 2017 16:58:05 +0100
Message-Id: <6d71aa0796dd8892510d6911a280eba235398ed4.1498751638.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <1f52573cfb6e72b49af7a1071ffe136623fafc75.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <1f52573cfb6e72b49af7a1071ffe136623fafc75.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
In-Reply-To: <cover.22236bc88adc598797b31ea82329ec99304fe34d.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.22236bc88adc598797b31ea82329ec99304fe34d.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent change to the frame completion handling has changed the order
in which the vblank timestamps are updated.

To fix this requires handling the vblank events on the frame end event
which comes from the VSP1 driver on Gen3 instead.

Prevent the CRTC IRQ from being enabled on Gen3 hardware and handle
vblank events through the existing rcar_du_vsp_complete() callback.

The addition of this callback was to provide notification of frame
completions in the event of a race. Further extend the DU callback to
provide notification as to whether the frame was completed or not,
allowing the callback to act as a full vblank interrupt notifier.

The VSP frame end interrupt occurs approximately 50 µs earlier than the
DU frame end interrupt, but this should not cause any undue harm.

Fixes: d503a43ac06a ("drm: rcar-du: Register a completion callback with
VSP1")

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c   | 19 ++++++++++++++++---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h   |  2 ++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c    |  8 ++++++--
 drivers/media/platform/vsp1/vsp1_drm.c   |  5 +++--
 drivers/media/platform/vsp1/vsp1_drm.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c  | 20 ++++++++++----------
 drivers/media/platform/vsp1/vsp1_pipe.h  |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c |  6 +++++-
 include/media/vsp1.h                     |  2 +-
 9 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 9f53a8243941..e6b8eaa13419 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -621,6 +621,7 @@ static int rcar_du_crtc_enable_vblank(struct drm_crtc *crtc)
 
 	rcar_du_crtc_write(rcrtc, DSRCR, DSRCR_VBCL);
 	rcar_du_crtc_set(rcrtc, DIER, DIER_FRE);
+	rcrtc->vblank_enable = true;
 
 	return 0;
 }
@@ -629,6 +630,7 @@ static void rcar_du_crtc_disable_vblank(struct drm_crtc *crtc)
 {
 	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
 
+	rcrtc->vblank_enable = false;
 	rcar_du_crtc_clr(rcrtc, DIER, DIER_FRE);
 }
 
@@ -658,10 +660,12 @@ static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
 	rcar_du_crtc_write(rcrtc, DSRCR, status & DSRCR_MASK);
 
 	if (status & DSSR_FRM) {
+		/*
+		 * Gen 3 vblank and page flips are handled through the VSP
+		 * completion handler
+		 */
 		drm_crtc_handle_vblank(&rcrtc->crtc);
-
-		if (rcdu->info->gen < 3)
-			rcar_du_crtc_finish_page_flip(rcrtc);
+		rcar_du_crtc_finish_page_flip(rcrtc);
 
 		ret = IRQ_HANDLED;
 	}
@@ -735,6 +739,15 @@ int rcar_du_crtc_create(struct rcar_du_group *rgrp, unsigned int index)
 	/* Start with vertical blanking interrupt reporting disabled. */
 	drm_crtc_vblank_off(crtc);
 
+	/*
+	 * DU with a VSP1 source uses the VSP1 frame completion event to handle
+	 * vblanking and page flipping events.
+	 *
+	 * Do not register the IRQ handler in this instance.
+	 */
+	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_VSP1_SOURCE))
+		return 0;
+
 	/* Register the interrupt handler. */
 	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_CRTC_IRQ_CLOCK)) {
 		irq = platform_get_irq(pdev, index);
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
index b199ed5adf36..cf5fcc3a3418 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
@@ -31,6 +31,7 @@ struct rcar_du_vsp;
  * @mmio_offset: offset of the CRTC registers in the DU MMIO block
  * @index: CRTC software and hardware index
  * @started: whether the CRTC has been started and is running
+ * @vblank_enable: whether vblank events are enabled on this CRTC
  * @event: event to post when the pending page flip completes
  * @flip_wait: wait queue used to signal page flip completion
  * @outputs: bitmask of the outputs (enum rcar_du_output) driven by this CRTC
@@ -45,6 +46,7 @@ struct rcar_du_crtc {
 	unsigned int index;
 	bool started;
 
+	bool vblank_enable;
 	struct drm_pending_vblank_event *event;
 	wait_queue_head_t flip_wait;
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index f870445ebc8d..9144d3d50067 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -30,11 +30,15 @@
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
index 9377aafa8996..5fb9bdcda980 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -37,12 +37,13 @@ void vsp1_drm_display_start(struct vsp1_device *vsp1)
 	vsp1_dlm_irq_display_start(vsp1->drm->pipe.output->dlm);
 }
 
-static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe)
+static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
+				       bool completed)
 {
 	struct vsp1_drm *drm = to_vsp1_drm(pipe);
 
 	if (drm->du_complete)
-		drm->du_complete(drm->du_private);
+		drm->du_complete(drm->du_private, completed);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index e9f80727ff92..5c1db38cf9c0 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -37,7 +37,7 @@ struct vsp1_drm {
 	} inputs[VSP1_MAX_RPF];
 
 	/* Frame synchronisation */
-	void (*du_complete)(void *);
+	void (*du_complete)(void *, bool);
 	void *du_private;
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index e817623b84e0..662d253fab40 100644
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
index 5af3486afe07..eaa1564224c1 100644
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
 
+	/* M2M Pipelines should never call here with an incomplete frame */
+	WARN_ON_ONCE(!completed);
+
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
 	/* Complete buffers on all video nodes. */
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index c837383b2013..5c90c7775d58 100644
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
git-series 0.9.1
