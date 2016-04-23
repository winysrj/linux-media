Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35897 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbcDWXty (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 19:49:54 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH 11/13] drm: rcar-du: Add alpha support for VSP planes
Date: Sun, 24 Apr 2016 02:49:58 +0300
Message-Id: <1461455400-28767-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the global alpha multiplier of VSP planes configurable through the
alpha property, exactly as for the native DU planes.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 38 +++++++++++++++++------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

Cc: dri-devel@lists.freedesktop.org

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index de7ef041182b..8c89a6401542 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -148,40 +148,41 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 	struct rcar_du_vsp_plane_state *state =
 		to_rcar_vsp_plane_state(plane->plane.state);
 	struct drm_framebuffer *fb = plane->plane.state->fb;
-	struct v4l2_rect src;
-	struct v4l2_rect dst;
-	dma_addr_t paddr[2] = { 0, };
-	u32 pixelformat = 0;
+	struct vsp1_du_atomic_config cfg = {
+		.pixelformat = 0,
+		.pitch = fb->pitches[0],
+		.alpha = state->alpha,
+		.zpos = 0,
+	};
 	unsigned int i;
 
-	src.left = state->state.src_x >> 16;
-	src.top = state->state.src_y >> 16;
-	src.width = state->state.src_w >> 16;
-	src.height = state->state.src_h >> 16;
+	cfg.src.left = state->state.src_x >> 16;
+	cfg.src.top = state->state.src_y >> 16;
+	cfg.src.width = state->state.src_w >> 16;
+	cfg.src.height = state->state.src_h >> 16;
 
-	dst.left = state->state.crtc_x;
-	dst.top = state->state.crtc_y;
-	dst.width = state->state.crtc_w;
-	dst.height = state->state.crtc_h;
+	cfg.dst.left = state->state.crtc_x;
+	cfg.dst.top = state->state.crtc_y;
+	cfg.dst.width = state->state.crtc_w;
+	cfg.dst.height = state->state.crtc_h;
 
 	for (i = 0; i < state->format->planes; ++i) {
 		struct drm_gem_cma_object *gem;
 
 		gem = drm_fb_cma_get_gem_obj(fb, i);
-		paddr[i] = gem->paddr + fb->offsets[i];
+		cfg.mem[i] = gem->paddr + fb->offsets[i];
 	}
 
 	for (i = 0; i < ARRAY_SIZE(formats_kms); ++i) {
 		if (formats_kms[i] == state->format->fourcc) {
-			pixelformat = formats_v4l2[i];
+			cfg.pixelformat = formats_v4l2[i];
 			break;
 		}
 	}
 
-	WARN_ON(!pixelformat);
+	WARN_ON(!cfg.pixelformat);
 
-	vsp1_du_atomic_update(plane->vsp->vsp, plane->index, pixelformat,
-			      fb->pitches[0], paddr, &src, &dst);
+	vsp1_du_atomic_update(plane->vsp->vsp, plane->index, &cfg);
 }
 
 static int rcar_du_vsp_plane_atomic_check(struct drm_plane *plane,
@@ -220,8 +221,7 @@ static void rcar_du_vsp_plane_atomic_update(struct drm_plane *plane,
 	if (plane->state->crtc)
 		rcar_du_vsp_plane_setup(rplane);
 	else
-		vsp1_du_atomic_update(rplane->vsp->vsp, rplane->index, 0, 0, 0,
-				      NULL, NULL);
+		vsp1_du_atomic_update(rplane->vsp->vsp, rplane->index, NULL);
 }
 
 static const struct drm_plane_helper_funcs rcar_du_vsp_plane_helper_funcs = {
-- 
2.7.3

