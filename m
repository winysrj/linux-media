Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751601AbdCDCCP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 21:02:15 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 3/3] drm: rcar-du: Register a completion callback with VSP1
Date: Sat,  4 Mar 2017 02:01:19 +0000
Message-Id: <bbd6cfc198254a60d7369c0101ab027bb7b56946.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently we process page flip events on every display interrupt,
however this does not take into consideration the processing time needed
by the VSP1 utilised in the pipeline.

Register a callback with the VSP driver to obtain completion events, and
track them so that we only perform page flips when the full display
pipeline has completed for the frame.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v2:
 - Commit message completely re-worded for patch re-work.
 - drm_crtc_handle_vblank() re-instated in event of rcrtc->pending
 - removed passing of unnecessary 'data' through callbacks
 - perform page flips from the VSP completion handler
 - add locking around pending flags

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 10 +++++++--
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  2 ++-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 29 +++++++++++++++++++++++++++-
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 7391dd95c733..b7ff00bb45de 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -299,7 +299,7 @@ static void rcar_du_crtc_update_planes(struct rcar_du_crtc *rcrtc)
  * Page Flip
  */
 
-static void rcar_du_crtc_finish_page_flip(struct rcar_du_crtc *rcrtc)
+void rcar_du_crtc_finish_page_flip(struct rcar_du_crtc *rcrtc)
 {
 	struct drm_pending_vblank_event *event;
 	struct drm_device *dev = rcrtc->crtc.dev;
@@ -328,7 +328,7 @@ static bool rcar_du_crtc_page_flip_pending(struct rcar_du_crtc *rcrtc)
 	bool pending;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
-	pending = rcrtc->event != NULL;
+	pending = (rcrtc->event != NULL) || (rcrtc->pending);
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 
 	return pending;
@@ -579,6 +579,12 @@ static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
 
 	if (status & DSSR_FRM) {
 		drm_crtc_handle_vblank(&rcrtc->crtc);
+
+		if (rcrtc->pending) {
+			trace_printk("VBlank loss due to VSP Overrun\n");
+			return IRQ_HANDLED;
+		}
+
 		rcar_du_crtc_finish_page_flip(rcrtc);
 		ret = IRQ_HANDLED;
 	}
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
index a7194812997e..b73ec6de7af4 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
@@ -47,6 +47,7 @@ struct rcar_du_crtc {
 
 	struct drm_pending_vblank_event *event;
 	wait_queue_head_t flip_wait;
+	bool pending;
 
 	unsigned int outputs;
 
@@ -71,5 +72,6 @@ void rcar_du_crtc_resume(struct rcar_du_crtc *rcrtc);
 
 void rcar_du_crtc_route_output(struct drm_crtc *crtc,
 			       enum rcar_du_output output);
+void rcar_du_crtc_finish_page_flip(struct rcar_du_crtc *rcrtc);
 
 #endif /* __RCAR_DU_CRTC_H__ */
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index b0ff304ce3dc..1fcd311badb1 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -28,6 +28,22 @@
 #include "rcar_du_kms.h"
 #include "rcar_du_vsp.h"
 
+static void rcar_du_vsp_complete(void *private)
+{
+	struct rcar_du_crtc *crtc = (struct rcar_du_crtc *)private;
+	struct drm_device *dev = crtc->crtc.dev;
+	unsigned long flags;
+	bool pending;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	pending = crtc->pending;
+	crtc->pending = false;
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	if (pending)
+		rcar_du_crtc_finish_page_flip(crtc);
+}
+
 void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
 {
 	const struct drm_display_mode *mode = &crtc->crtc.state->adjusted_mode;
@@ -35,6 +51,8 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
 	struct vsp1_du_lif_config cfg = {
 		.width = mode->hdisplay,
 		.height = mode->vdisplay,
+		.callback = rcar_du_vsp_complete,
+		.callback_data = crtc,
 	};
 	struct rcar_du_plane_state state = {
 		.state = {
@@ -85,6 +103,17 @@ void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
 
 void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
 {
+	struct drm_device *dev = crtc->crtc.dev;
+	unsigned long flags;
+	bool pending;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	pending = crtc->pending;
+	crtc->pending = true;
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	WARN_ON(pending);
+
 	vsp1_du_atomic_flush(crtc->vsp->vsp);
 }
 
-- 
git-series 0.9.1
