Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45432 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbbDMSja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 14:39:30 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-api@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Daniel Vetter <daniel.vetter@intel.com>
Subject: [RFC/PATCH v2 5/5] drm/rcar-du: Restart the DU group when a plane source changes
Date: Mon, 13 Apr 2015 21:39:47 +0300
Message-Id: <1428950387-6913-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1428950387-6913-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1428950387-6913-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Plane sources are configured by the VSPS bit in the PnDDCR4 register.
Although the datasheet states that the bit is updated during vertical
blanking, it seems that updates only occur when the DU group is held in
reset through the DSYSR.DRES bit. Restart the group if the source
changes.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c  | 10 ++++++++--
 drivers/gpu/drm/rcar-du/rcar_du_group.c |  2 ++
 drivers/gpu/drm/rcar-du/rcar_du_plane.c | 22 ++++++++++++++++++++--
 drivers/gpu/drm/rcar-du/rcar_du_plane.h |  1 +
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 7d0b8ef9bea2..969d49ab0d09 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -249,6 +249,8 @@ static void rcar_du_crtc_update_planes(struct rcar_du_crtc *rcrtc)
 		}
 	}
 
+	mutex_lock(&rcrtc->group->lock);
+
 	/* Select display timing and dot clock generator 2 for planes associated
 	 * with superposition controller 2.
 	 */
@@ -260,15 +262,19 @@ static void rcar_du_crtc_update_planes(struct rcar_du_crtc *rcrtc)
 		 * split, or through a module parameter). Flicker would then
 		 * occur only if we need to break the pre-association.
 		 */
-		mutex_lock(&rcrtc->group->lock);
 		if (rcar_du_group_read(rcrtc->group, DPTSR) != dptsr) {
 			rcar_du_group_write(rcrtc->group, DPTSR, dptsr);
 			if (rcrtc->group->used_crtcs)
 				rcar_du_group_restart(rcrtc->group);
 		}
-		mutex_unlock(&rcrtc->group->lock);
 	}
 
+	/* Restart the group if plane sources have changed. */
+	if (rcrtc->group->planes.need_restart)
+		rcar_du_group_restart(rcrtc->group);
+
+	mutex_unlock(&rcrtc->group->lock);
+
 	rcar_du_group_write(rcrtc->group, rcrtc->index % 2 ? DS2PR : DS1PR,
 			    dspr);
 }
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_group.c b/drivers/gpu/drm/rcar-du/rcar_du_group.c
index 71f50bf45581..101997e6e531 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_group.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_group.c
@@ -154,6 +154,8 @@ void rcar_du_group_start_stop(struct rcar_du_group *rgrp, bool start)
 
 void rcar_du_group_restart(struct rcar_du_group *rgrp)
 {
+	rgrp->planes.need_restart = false;
+
 	__rcar_du_group_start_stop(rgrp, false);
 	__rcar_du_group_start_stop(rgrp, true);
 }
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.c b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
index 07802639ac99..0bf2aaaf91e6 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_plane.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
@@ -357,9 +357,27 @@ static void rcar_du_plane_atomic_update(struct drm_plane *plane,
 					struct drm_plane_state *old_state)
 {
 	struct rcar_du_plane *rplane = to_rcar_plane(plane);
+	struct rcar_du_plane_state *old_rstate;
+	struct rcar_du_plane_state *new_rstate;
 
-	if (plane->state->crtc)
-		rcar_du_plane_setup(rplane);
+	if (!plane->state->crtc)
+		return;
+
+	rcar_du_plane_setup(rplane);
+
+	/* Check whether the source has changed from memory to live source or
+	 * from live source to memory. The source has been configured by the
+	 * VSPS bit in the PnDDCR4 register. Although the datasheet states that
+	 * the bit is updated during vertical blanking, it seems that updates
+	 * only occur when the DU group is held in reset through the DSYSR.DRES
+	 * bit. We thus need to restart the group if the source changes.
+	 */
+	old_rstate = to_rcar_du_plane_state(old_state);
+	new_rstate = to_rcar_du_plane_state(plane->state);
+
+	if ((old_rstate->source == RCAR_DU_PLANE_MEMORY) !=
+	    (new_rstate->source == RCAR_DU_PLANE_MEMORY))
+		rplane->group->planes.need_restart = true;
 }
 
 static const struct drm_plane_helper_funcs rcar_du_plane_helper_funcs = {
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.h b/drivers/gpu/drm/rcar-du/rcar_du_plane.h
index 9a6132899d59..694b44c151b6 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_plane.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.h
@@ -47,6 +47,7 @@ static inline struct rcar_du_plane *to_rcar_plane(struct drm_plane *plane)
 
 struct rcar_du_planes {
 	struct rcar_du_plane planes[RCAR_DU_NUM_KMS_PLANES];
+	bool need_restart;
 
 	struct drm_property *alpha;
 	struct drm_property *colorkey;
-- 
2.0.5

