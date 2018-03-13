Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41778 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932498AbeCMSF7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:05:59 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 11/11] drm: rcar-du: Support interlaced video output through vsp1
Date: Tue, 13 Mar 2018 19:05:27 +0100
Message-Id: <334f0b14fde0ddcfd02a12c41878a1b792221e4d.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index 5685d5af6998..9854d9deb944 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -248,6 +248,7 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 	/* Signal polarities */
 	value = ((mode->flags & DRM_MODE_FLAG_PVSYNC) ? DSMR_VSL : 0)
 	      | ((mode->flags & DRM_MODE_FLAG_PHSYNC) ? DSMR_HSL : 0)
+	      | ((mode->flags & DRM_MODE_FLAG_INTERLACE) ? DSMR_ODEV : 0)
 	      | DSMR_DIPM_DISP | DSMR_CSPM;
 	rcar_du_crtc_write(rcrtc, DSMR, value);
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 2c260c33840b..5e47daef8bd2 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -178,6 +178,9 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
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
