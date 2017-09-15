Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdIOQmR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 12:42:17 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v1 3/3] drm: rcar-du: Remove unused CRTC suspend/resume functions
Date: Fri, 15 Sep 2017 17:42:07 +0100
Message-Id: <588e2797c3b8c0b966afb549e658e3cd0652a734.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An early implementation of suspend-resume helpers are available in the
CRTC module, however they are unused and no longer needed.

With suspend and resume handled by the core DRM atomic helpers, we can
remove the unused functions.

CC: dri-devel@lists.freedesktop.org

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 35 +---------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 301ea1a8018e..b492063a6e1f 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -557,41 +557,6 @@ static void rcar_du_crtc_stop(struct rcar_du_crtc *rcrtc)
 	rcar_du_group_start_stop(rcrtc->group, false);
 }
 
-void rcar_du_crtc_suspend(struct rcar_du_crtc *rcrtc)
-{
-	if (rcar_du_has(rcrtc->group->dev, RCAR_DU_FEATURE_VSP1_SOURCE))
-		rcar_du_vsp_disable(rcrtc);
-
-	rcar_du_crtc_stop(rcrtc);
-	rcar_du_crtc_put(rcrtc);
-}
-
-void rcar_du_crtc_resume(struct rcar_du_crtc *rcrtc)
-{
-	unsigned int i;
-
-	if (!rcrtc->crtc.state->active)
-		return;
-
-	rcar_du_crtc_get(rcrtc);
-	rcar_du_crtc_setup(rcrtc);
-
-	/* Commit the planes state. */
-	if (!rcar_du_has(rcrtc->group->dev, RCAR_DU_FEATURE_VSP1_SOURCE)) {
-		for (i = 0; i < rcrtc->group->num_planes; ++i) {
-			struct rcar_du_plane *plane = &rcrtc->group->planes[i];
-
-			if (plane->plane.state->crtc != &rcrtc->crtc)
-				continue;
-
-			rcar_du_plane_setup(plane);
-		}
-	}
-
-	rcar_du_crtc_update_planes(rcrtc);
-	rcar_du_crtc_start(rcrtc);
-}
-
 /* -----------------------------------------------------------------------------
  * CRTC Functions
  */
-- 
git-series 0.9.1
