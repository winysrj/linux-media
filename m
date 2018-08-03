Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50436 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbeHCNdl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 09:33:41 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v6 11/11] drm: rcar-du: Support interlaced video output through vsp1
Date: Fri,  3 Aug 2018 12:37:30 +0100
Message-Id: <0f577cb70843db00eb62b790c807bfdab59951ea.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Use the newly exposed VSP1 interface to enable interlaced frame support
through the VSP1 LIF pipelines.

The DSMR register is updated to set the ODEV flag on interlaced
pipelines, thus defining an interlaced stream as having the ODD field
located in the second half (BOTTOM) of the frame buffer.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v5
 - Fix commit title
 - Document change to DSMR
 - Configure through vsp1_du_setup_lif(), rather than
   vsp1_du_atomic_update()

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 1 +
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 15dc9caa128b..b52b3e817b93 100644
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
index 72eebeda518e..a042f116731b 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -52,6 +52,7 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
 	struct vsp1_du_lif_config cfg = {
 		.width = mode->hdisplay,
 		.height = mode->vdisplay,
+		.interlaced = mode->flags & DRM_MODE_FLAG_INTERLACE,
 		.callback = rcar_du_vsp_complete,
 		.callback_data = crtc,
 	};
-- 
git-series 0.9.1
