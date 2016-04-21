Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33558 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbcDUBOE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 21:14:04 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	David Airlie <airlied@linux.ie>
Subject: [PATCH 1/2] drm: rcar-du: Add Z-order support for VSP planes
Date: Thu, 21 Apr 2016 04:14:12 +0300
Message-Id: <1461201253-12170-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461201253-12170-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461201253-12170-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the Z-order of VSP planes configurable through the zpos property,
exactly as for the native DU planes.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 16 ++++++++++++----
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h |  2 ++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index de7ef041182b..62e9619eaea4 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -180,8 +180,9 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 
 	WARN_ON(!pixelformat);
 
-	vsp1_du_atomic_update(plane->vsp->vsp, plane->index, pixelformat,
-			      fb->pitches[0], paddr, &src, &dst);
+	vsp1_du_atomic_update_zpos(plane->vsp->vsp, plane->index, pixelformat,
+				   fb->pitches[0], paddr, &src, &dst,
+				   state->zpos);
 }
 
 static int rcar_du_vsp_plane_atomic_check(struct drm_plane *plane,
@@ -220,8 +221,8 @@ static void rcar_du_vsp_plane_atomic_update(struct drm_plane *plane,
 	if (plane->state->crtc)
 		rcar_du_vsp_plane_setup(rplane);
 	else
-		vsp1_du_atomic_update(rplane->vsp->vsp, rplane->index, 0, 0, 0,
-				      NULL, NULL);
+		vsp1_du_atomic_update_zpos(rplane->vsp->vsp, rplane->index,
+					   0, 0, 0, NULL, NULL, 0);
 }
 
 static const struct drm_plane_helper_funcs rcar_du_vsp_plane_helper_funcs = {
@@ -269,6 +270,7 @@ static void rcar_du_vsp_plane_reset(struct drm_plane *plane)
 		return;
 
 	state->alpha = 255;
+	state->zpos = plane->type == DRM_PLANE_TYPE_PRIMARY ? 0 : 1;
 
 	plane->state = &state->state;
 	plane->state->plane = plane;
@@ -283,6 +285,8 @@ static int rcar_du_vsp_plane_atomic_set_property(struct drm_plane *plane,
 
 	if (property == rcdu->props.alpha)
 		rstate->alpha = val;
+	else if (property == rcdu->props.zpos)
+		rstate->zpos = val;
 	else
 		return -EINVAL;
 
@@ -299,6 +303,8 @@ static int rcar_du_vsp_plane_atomic_get_property(struct drm_plane *plane,
 
 	if (property == rcdu->props.alpha)
 		*val = rstate->alpha;
+	else if (property == rcdu->props.zpos)
+		*val = rstate->zpos;
 	else
 		return -EINVAL;
 
@@ -378,6 +384,8 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp)
 
 		drm_object_attach_property(&plane->plane.base,
 					   rcdu->props.alpha, 255);
+		drm_object_attach_property(&plane->plane.base,
+					   rcdu->props.zpos, 1);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
index df3bf3805c69..510dcc9c6816 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
@@ -44,6 +44,7 @@ static inline struct rcar_du_vsp_plane *to_rcar_vsp_plane(struct drm_plane *p)
  * @state: base DRM plane state
  * @format: information about the pixel format used by the plane
  * @alpha: value of the plane alpha property
+ * @zpos: value of the plane zpos property
  */
 struct rcar_du_vsp_plane_state {
 	struct drm_plane_state state;
@@ -51,6 +52,7 @@ struct rcar_du_vsp_plane_state {
 	const struct rcar_du_format_info *format;
 
 	unsigned int alpha;
+	unsigned int zpos;
 };
 
 static inline struct rcar_du_vsp_plane_state *
-- 
2.7.3

