Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35898 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbcDWXtz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 19:49:55 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH 12/13] drm: rcar-du: Add Z-order support for VSP planes
Date: Sun, 24 Apr 2016 02:49:59 +0300
Message-Id: <1461455400-28767-13-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the Z-order of VSP planes configurable through the zpos property,
exactly as for the native DU planes.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 11 ++++++++---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h |  2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

Cc: dri-devel@lists.freedesktop.org

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 8c89a6401542..4927fb3b8554 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -152,7 +152,7 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 		.pixelformat = 0,
 		.pitch = fb->pitches[0],
 		.alpha = state->alpha,
-		.zpos = 0,
+		.zpos = state->zpos,
 	};
 	unsigned int i;
 
@@ -180,8 +180,6 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 		}
 	}
 
-	WARN_ON(!cfg.pixelformat);
-
 	vsp1_du_atomic_update(plane->vsp->vsp, plane->index, &cfg);
 }
 
@@ -269,6 +267,7 @@ static void rcar_du_vsp_plane_reset(struct drm_plane *plane)
 		return;
 
 	state->alpha = 255;
+	state->zpos = plane->type == DRM_PLANE_TYPE_PRIMARY ? 0 : 1;
 
 	plane->state = &state->state;
 	plane->state->plane = plane;
@@ -283,6 +282,8 @@ static int rcar_du_vsp_plane_atomic_set_property(struct drm_plane *plane,
 
 	if (property == rcdu->props.alpha)
 		rstate->alpha = val;
+	else if (property == rcdu->props.zpos)
+		rstate->zpos = val;
 	else
 		return -EINVAL;
 
@@ -299,6 +300,8 @@ static int rcar_du_vsp_plane_atomic_get_property(struct drm_plane *plane,
 
 	if (property == rcdu->props.alpha)
 		*val = rstate->alpha;
+	else if (property == rcdu->props.zpos)
+		*val = rstate->zpos;
 	else
 		return -EINVAL;
 
@@ -378,6 +381,8 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp)
 
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

