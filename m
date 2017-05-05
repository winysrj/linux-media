Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752901AbdEEPVZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 11:21:25 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, mchehab@kernel.org
Cc: kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v4 1/4] drm: rcar-du: Arm the page flip event after queuing the page flip
Date: Fri,  5 May 2017 16:21:07 +0100
Message-Id: <41efc7efede2bab8a87ac6fd036222c32deab931.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The page flip event is armed in the atomic begin handler, creating a
race condition with the frame end interrupt that could send the event
before the atomic operation actually completes. To avoid that, arm the
event in the atomic flush handler after queuing the page flip.

This change doesn't fully close the race window, as the frame end
interrupt could be generated before the page flip is committed to
hardware but only handled after the event is armed. However, the race
window is now much smaller.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 4ed6f2340af0..5f0664bcd12d 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -581,17 +581,6 @@ static void rcar_du_crtc_atomic_begin(struct drm_crtc *crtc,
 				      struct drm_crtc_state *old_crtc_state)
 {
 	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
-	struct drm_device *dev = rcrtc->crtc.dev;
-	unsigned long flags;
-
-	if (crtc->state->event) {
-		WARN_ON(drm_crtc_vblank_get(crtc) != 0);
-
-		spin_lock_irqsave(&dev->event_lock, flags);
-		rcrtc->event = crtc->state->event;
-		crtc->state->event = NULL;
-		spin_unlock_irqrestore(&dev->event_lock, flags);
-	}
 
 	if (rcar_du_has(rcrtc->group->dev, RCAR_DU_FEATURE_VSP1_SOURCE))
 		rcar_du_vsp_atomic_begin(rcrtc);
@@ -601,9 +590,20 @@ static void rcar_du_crtc_atomic_flush(struct drm_crtc *crtc,
 				      struct drm_crtc_state *old_crtc_state)
 {
 	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
+	struct drm_device *dev = rcrtc->crtc.dev;
+	unsigned long flags;
 
 	rcar_du_crtc_update_planes(rcrtc);
 
+	if (crtc->state->event) {
+		WARN_ON(drm_crtc_vblank_get(crtc) != 0);
+
+		spin_lock_irqsave(&dev->event_lock, flags);
+		rcrtc->event = crtc->state->event;
+		crtc->state->event = NULL;
+		spin_unlock_irqrestore(&dev->event_lock, flags);
+	}
+
 	if (rcar_du_has(rcrtc->group->dev, RCAR_DU_FEATURE_VSP1_SOURCE))
 		rcar_du_vsp_atomic_flush(rcrtc);
 }
-- 
git-series 0.9.1
