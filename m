Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751664AbdCAPtK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Mar 2017 10:49:10 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH 3/3] drm: rcar-du: Register a completion callback with VSP1
Date: Wed,  1 Mar 2017 13:12:56 +0000
Message-Id: <b2e74113040a80c99151c392b1d42ea604b8ca1f.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.79abe454b4a405227fcacc23f1b6ba624ee99cf0.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.79abe454b4a405227fcacc23f1b6ba624ee99cf0.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.79abe454b4a405227fcacc23f1b6ba624ee99cf0.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.79abe454b4a405227fcacc23f1b6ba624ee99cf0.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updating the state in a running VSP1 requires two interrupts from the
VSP. Initially, the updated state will be committed - but only after the
VSP1 has completed processing it's current frame will the new state be
taken into account. As such, the committed state will only be 'completed'
after an extra frame completion interrupt.

Track this delay, by passing the frame flip event through the VSP
module; It will be returned only when the frame has completed and can be
returned to the caller.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c |  8 +++++-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  1 +-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 34 ++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 7391dd95c733..0a824633a012 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -328,7 +328,7 @@ static bool rcar_du_crtc_page_flip_pending(struct rcar_du_crtc *rcrtc)
 	bool pending;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
-	pending = rcrtc->event != NULL;
+	pending = (rcrtc->event != NULL) || (rcrtc->pending != NULL);
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 
 	return pending;
@@ -578,6 +578,12 @@ static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
 	rcar_du_crtc_write(rcrtc, DSRCR, status & DSRCR_MASK);
 
 	if (status & DSSR_FRM) {
+
+		if (rcrtc->pending) {
+			trace_printk("VBlank loss due to VSP Overrun\n");
+			return IRQ_HANDLED;
+		}
+
 		drm_crtc_handle_vblank(&rcrtc->crtc);
 		rcar_du_crtc_finish_page_flip(rcrtc);
 		ret = IRQ_HANDLED;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
index a7194812997e..8374a858446a 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
@@ -46,6 +46,7 @@ struct rcar_du_crtc {
 	bool started;
 
 	struct drm_pending_vblank_event *event;
+	struct drm_pending_vblank_event *pending;
 	wait_queue_head_t flip_wait;
 
 	unsigned int outputs;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 71e70e1e0881..408375aff1a0 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -28,6 +28,26 @@
 #include "rcar_du_kms.h"
 #include "rcar_du_vsp.h"
 
+static void rcar_du_vsp_complete(void *private, void *data)
+{
+	struct rcar_du_crtc *crtc = (struct rcar_du_crtc *)private;
+	struct drm_device *dev = crtc->crtc.dev;
+	struct drm_pending_vblank_event *event;
+	bool match;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	event = crtc->event;
+	crtc->event = data;
+	match = (crtc->event == crtc->pending);
+	crtc->pending = NULL;
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	/* Safety checks */
+	WARN(event, "Event lost by VSP completion callback\n");
+	WARN(!match, "Stored pending event, does not match completion\n");
+}
+
 void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
 {
 	const struct drm_display_mode *mode = &crtc->crtc.state->adjusted_mode;
@@ -66,6 +86,8 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
 	 */
 	crtc->group->need_restart = true;
 
+	vsp1_du_register_callback(crtc->vsp->vsp, rcar_du_vsp_complete, crtc);
+
 	vsp1_du_setup_lif(crtc->vsp->vsp, mode->hdisplay, mode->vdisplay);
 }
 
@@ -81,7 +103,17 @@ void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
 
 void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
 {
-	vsp1_du_atomic_flush(crtc->vsp->vsp, NULL);
+	struct drm_device *dev = crtc->crtc.dev;
+	struct drm_pending_vblank_event *event;
+	unsigned long flags;
+
+	/* Move the event to the VSP, track it locally as 'pending' */
+	spin_lock_irqsave(&dev->event_lock, flags);
+	event = crtc->pending = crtc->event;
+	crtc->event = NULL;
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	vsp1_du_atomic_flush(crtc->vsp->vsp, event);
 }
 
 /* Keep the two tables in sync. */
-- 
git-series 0.9.1
