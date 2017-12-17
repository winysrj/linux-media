Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50492 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756922AbdLQARW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 19:17:22 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH/RFC 2/4] drm: rcar-du: Use standard colorkey properties
Date: Sun, 17 Dec 2017 02:17:22 +0200
Message-Id: <20171217001724.1348-3-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that KMS has standard color keying properties, instantiate them for
all the non-primary planes. This replaces the custom colorkey field in
the driver plane state structure. The custom colorkey property is kept
to ensure backward-compatibility, but now implemented as an alias for
the standard colorkey.mode, colorkey.min and colorkey.max properties.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_plane.c | 60 +++++++++++++++++++++++----------
 drivers/gpu/drm/rcar-du/rcar_du_plane.h |  2 --
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c   |  1 -
 3 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.c b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
index 4a3d16cf3ed6..b3b43c280ead 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_plane.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
@@ -432,7 +432,7 @@ static void rcar_du_plane_setup_mode(struct rcar_du_group *rgrp,
 	 * PnMR_SPIM_TP_OFF bit set in their pnmr field, disabling color keying
 	 * automatically.
 	 */
-	if ((state->colorkey & RCAR_DU_COLORKEY_MASK) == RCAR_DU_COLORKEY_NONE)
+	if (state->state.colorkey.mode == 0)
 		pnmr |= PnMR_SPIM_TP_OFF;
 
 	/* For packed YUV formats we need to select the U/V order. */
@@ -441,26 +441,30 @@ static void rcar_du_plane_setup_mode(struct rcar_du_group *rgrp,
 
 	rcar_du_plane_write(rgrp, index, PnMR, pnmr);
 
+	colorkey = ((state->state.colorkey.min >> 24) & 0x00ff0000)
+		 | ((state->state.colorkey.min >> 16) & 0x0000ff00)
+		 | ((state->state.colorkey.min >>  8) & 0x000000ff);
+
 	switch (state->format->fourcc) {
 	case DRM_FORMAT_RGB565:
-		colorkey = ((state->colorkey & 0xf80000) >> 8)
-			 | ((state->colorkey & 0x00fc00) >> 5)
-			 | ((state->colorkey & 0x0000f8) >> 3);
+		colorkey = ((colorkey & 0xf80000) >> 8)
+			 | ((colorkey & 0x00fc00) >> 5)
+			 | ((colorkey & 0x0000f8) >> 3);
 		rcar_du_plane_write(rgrp, index, PnTC2R, colorkey);
 		break;
 
 	case DRM_FORMAT_ARGB1555:
 	case DRM_FORMAT_XRGB1555:
-		colorkey = ((state->colorkey & 0xf80000) >> 9)
-			 | ((state->colorkey & 0x00f800) >> 6)
-			 | ((state->colorkey & 0x0000f8) >> 3);
+		colorkey = ((colorkey & 0xf80000) >> 9)
+			 | ((colorkey & 0x00f800) >> 6)
+			 | ((colorkey & 0x0000f8) >> 3);
 		rcar_du_plane_write(rgrp, index, PnTC2R, colorkey);
 		break;
 
 	case DRM_FORMAT_XRGB8888:
 	case DRM_FORMAT_ARGB8888:
 		rcar_du_plane_write(rgrp, index, PnTC3R,
-				    PnTC3R_CODE | (state->colorkey & 0xffffff));
+				    PnTC3R_CODE | colorkey);
 		break;
 	}
 }
@@ -575,6 +579,9 @@ int __rcar_du_plane_atomic_check(struct drm_plane *plane,
 	struct drm_rect clip;
 	int ret;
 
+	if (state->colorkey.min != state->colorkey.max)
+		return -EINVAL;
+
 	if (!state->crtc) {
 		/*
 		 * The visible field is not reset by the DRM core but only
@@ -699,7 +706,6 @@ static void rcar_du_plane_reset(struct drm_plane *plane)
 	state->hwindex = -1;
 	state->source = RCAR_DU_PLANE_MEMORY;
 	state->alpha = 255;
-	state->colorkey = RCAR_DU_COLORKEY_NONE;
 	state->state.zpos = plane->type == DRM_PLANE_TYPE_PRIMARY ? 0 : 1;
 
 	plane->state = &state->state;
@@ -714,12 +720,17 @@ static int rcar_du_plane_atomic_set_property(struct drm_plane *plane,
 	struct rcar_du_plane_state *rstate = to_rcar_plane_state(state);
 	struct rcar_du_device *rcdu = to_rcar_plane(plane)->group->dev;
 
-	if (property == rcdu->props.alpha)
+	if (property == rcdu->props.alpha) {
 		rstate->alpha = val;
-	else if (property == rcdu->props.colorkey)
-		rstate->colorkey = val;
-	else
+	} else if (property == rcdu->props.colorkey) {
+		state->colorkey.mode = val & RCAR_DU_COLORKEY_MASK ? 1 : 0;
+		state->colorkey.min = ((val & 0x00ff0000) << 24)
+				    | ((val & 0x0000ff00) << 16)
+				    | ((val & 0x000000ff) << 8);
+		state->colorkey.max = state->colorkey.min;
+	} else {
 		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -732,12 +743,18 @@ static int rcar_du_plane_atomic_get_property(struct drm_plane *plane,
 		container_of(state, const struct rcar_du_plane_state, state);
 	struct rcar_du_device *rcdu = to_rcar_plane(plane)->group->dev;
 
-	if (property == rcdu->props.alpha)
+	if (property == rcdu->props.alpha) {
 		*val = rstate->alpha;
-	else if (property == rcdu->props.colorkey)
-		*val = rstate->colorkey;
-	else
+	} else if (property == rcdu->props.colorkey) {
+		u32 colorkey = ((state->colorkey.min >> 24) & 0x00ff0000)
+			     | ((state->colorkey.min >> 16) & 0x0000ff00)
+			     | ((state->colorkey.min >>  8) & 0x000000ff);
+
+		*val = colorkey | (state->colorkey.mode ?
+			RCAR_DU_COLORKEY_SOURCE : RCAR_DU_COLORKEY_NONE);
+	} else {
 		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -766,6 +783,11 @@ static const uint32_t formats[] = {
 	DRM_FORMAT_NV16,
 };
 
+static const struct drm_prop_enum_list colorkey_modes[] = {
+	{ 0, "disabled" },
+	{ 1, "source" },
+};
+
 int rcar_du_planes_init(struct rcar_du_group *rgrp)
 {
 	struct rcar_du_device *rcdu = rgrp->dev;
@@ -808,6 +830,10 @@ int rcar_du_planes_init(struct rcar_du_group *rgrp)
 					   rcdu->props.colorkey,
 					   RCAR_DU_COLORKEY_NONE);
 		drm_plane_create_zpos_property(&plane->plane, 1, 1, 7);
+		drm_plane_create_colorkey_properties(&plane->plane,
+						     colorkey_modes,
+						     ARRAY_SIZE(colorkey_modes),
+						     false);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.h b/drivers/gpu/drm/rcar-du/rcar_du_plane.h
index 890321b4665d..d8baf12cc716 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_plane.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.h
@@ -51,7 +51,6 @@ static inline struct rcar_du_plane *to_rcar_plane(struct drm_plane *plane)
  * @format: information about the pixel format used by the plane
  * @hwindex: 0-based hardware plane index, -1 means unused
  * @alpha: value of the plane alpha property
- * @colorkey: value of the plane colorkey property
  */
 struct rcar_du_plane_state {
 	struct drm_plane_state state;
@@ -61,7 +60,6 @@ struct rcar_du_plane_state {
 	enum rcar_du_plane_source source;
 
 	unsigned int alpha;
-	unsigned int colorkey;
 };
 
 static inline struct rcar_du_plane_state *
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 2c260c33840b..882d1f7a328b 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -68,7 +68,6 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
 		.format = rcar_du_format_info(DRM_FORMAT_ARGB8888),
 		.source = RCAR_DU_PLANE_VSPD1,
 		.alpha = 255,
-		.colorkey = 0,
 	};
 
 	if (rcdu->info->gen >= 3)
-- 
Regards,

Laurent Pinchart
