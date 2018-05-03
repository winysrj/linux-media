Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59476 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbeECIow (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 04:44:52 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 11/11] drm: rcar-du: Support interlaced video output through vsp1
Date: Thu,  3 May 2018 09:44:22 +0100
Message-Id: <2ceb322df5029f641ca33f8b9e65d53cefac02f5.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the newly exposed VSP1 interface to enable interlaced frame support
through the VSP1 lif pipelines.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 1 +
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index d71d709fe3d9..206532959ec9 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -289,6 +289,7 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 	/* Signal polarities */
 	value = ((mode->flags & DRM_MODE_FLAG_PVSYNC) ? DSMR_VSL : 0)
 	      | ((mode->flags & DRM_MODE_FLAG_PHSYNC) ? DSMR_HSL : 0)
+	      | ((mode->flags & DRM_MODE_FLAG_INTERLACE) ? DSMR_ODEV : 0)
 	      | DSMR_DIPM_DISP | DSMR_CSPM;
 	rcar_du_crtc_write(rcrtc, DSMR, value);
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index af7822a66dee..c7b37232ee91 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -186,6 +186,9 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 	};
 	unsigned int i;
 
+	cfg.interlaced = !!(plane->plane.state->crtc->mode.flags
+			    & DRM_MODE_FLAG_INTERLACE);
+
 	cfg.src.left = state->state.src.x1 >> 16;
 	cfg.src.top = state->state.src.y1 >> 16;
 	cfg.src.width = drm_rect_width(&state->state.src) >> 16;
-- 
git-series 0.9.1
