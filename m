Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:38561 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdEDKxk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 06:53:40 -0400
From: agheorghe <Alexandru_Gheorghe@mentor.com>
To: <Alexandru_Gheorghe@mentor.com>,
        <laurent.pinchart@ideasonboard.com>,
        <linux-renesas-soc@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] drm: rcar-du: Add support for colorkey alpha blending
Date: Thu, 4 May 2017 13:53:33 +0300
Message-ID: <1493895213-12573-3-git-send-email-Alexandru_Gheorghe@mentor.com>
In-Reply-To: <1493895213-12573-1-git-send-email-Alexandru_Gheorghe@mentor.com>
References: <1493895213-12573-1-git-send-email-Alexandru_Gheorghe@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two new plane properties colorkey and colorkey_alpha for rcar gen3.
* colorkey:
	- used for specifying the color on which the filtering is done.
	- bits 0 to 23 are interpreted as RGB888 format, in case we are
	  dealing with an YCbCr format, only the Y componenet is
	  compared and it is represented by the G bits from RGB888
	  format.
	- bit 24 tells if it is enabled or not.
* colorkey_alpha:
	- the alpha to be set for matching pixels, in case it is
	  missing the pixels will be made transparent

Signed-off-by: agheorghe <Alexandru_Gheorghe@mentor.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_drv.h   |  1 +
 drivers/gpu/drm/rcar-du/rcar_du_kms.c   |  8 ++++++++
 drivers/gpu/drm/rcar-du/rcar_du_plane.c |  3 ---
 drivers/gpu/drm/rcar-du/rcar_du_plane.h |  6 ++++++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c   | 22 ++++++++++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h   |  5 +++++
 6 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.h b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
index 91e8fc5..1cb92e3 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
@@ -98,6 +98,7 @@ struct rcar_du_device {
 	struct {
 		struct drm_property *alpha;
 		struct drm_property *colorkey;
+		struct drm_property *colorkey_alpha;
 	} props;
 
 	unsigned int dpad0_source;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index 1cc88ed..a733fa2 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -630,6 +630,14 @@ static int rcar_du_properties_init(struct rcar_du_device *rcdu)
 	if (rcdu->props.colorkey == NULL)
 		return -ENOMEM;
 
+	if (rcdu->info->gen == 3) {
+		rcdu->props.colorkey_alpha =
+			drm_property_create_range(rcdu->ddev, 0,
+						  "colorkey_alpha", 0, 255);
+		if (!rcdu->props.colorkey_alpha)
+			return -ENOMEM;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.c b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
index e408aa3..df689c4 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_plane.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
@@ -307,9 +307,6 @@ int rcar_du_atomic_check_planes(struct drm_device *dev,
  * Plane Setup
  */
 
-#define RCAR_DU_COLORKEY_NONE		(0 << 24)
-#define RCAR_DU_COLORKEY_SOURCE		(1 << 24)
-#define RCAR_DU_COLORKEY_MASK		(1 << 24)
 
 static void rcar_du_plane_write(struct rcar_du_group *rgrp,
 				unsigned int index, u32 reg, u32 data)
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.h b/drivers/gpu/drm/rcar-du/rcar_du_plane.h
index c1de338..9e7c3b6 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_plane.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.h
@@ -49,6 +49,12 @@ static inline struct rcar_du_plane *to_rcar_plane(struct drm_plane *plane)
 	return container_of(plane, struct rcar_du_plane, plane);
 }
 
+#define RCAR_DU_COLORKEY_NONE		(0 << 24)
+#define RCAR_DU_COLORKEY_MASK		BIT(24)
+#define RCAR_DU_COLORKEY_EN_MASK	RCAR_DU_COLORKEY_MASK
+#define RCAR_DU_COLORKEY_COLOR_MASK	0xFFFFFF
+#define RCAR_DU_COLORKEY_ALPHA_MASK	0xFF
+
 /**
  * struct rcar_du_plane_state - Driver-specific plane state
  * @state: base DRM plane state
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 4b460d4..b223be1 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -180,6 +180,11 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 		.pitch = fb->pitches[0],
 		.alpha = state->alpha,
 		.zpos = state->state.zpos,
+		.colorkey = state->colorkey & RCAR_DU_COLORKEY_COLOR_MASK,
+		.colorkey_en =
+			((state->colorkey & RCAR_DU_COLORKEY_EN_MASK) != 0),
+		.colorkey_alpha =
+			(state->colorkey_alpha & RCAR_DU_COLORKEY_ALPHA_MASK),
 	};
 	unsigned int i;
 
@@ -379,6 +384,8 @@ static void rcar_du_vsp_plane_reset(struct drm_plane *plane)
 		return;
 
 	state->alpha = 255;
+	state->colorkey = RCAR_DU_COLORKEY_NONE;
+	state->colorkey_alpha = 0;
 	state->state.zpos = plane->type == DRM_PLANE_TYPE_PRIMARY ? 0 : 1;
 
 	plane->state = &state->state;
@@ -394,6 +401,10 @@ static int rcar_du_vsp_plane_atomic_set_property(struct drm_plane *plane,
 
 	if (property == rcdu->props.alpha)
 		rstate->alpha = val;
+	else if (property == rcdu->props.colorkey)
+		rstate->colorkey = val;
+	else if (property == rcdu->props.colorkey_alpha)
+		rstate->colorkey_alpha = val;
 	else
 		return -EINVAL;
 
@@ -410,6 +421,10 @@ static int rcar_du_vsp_plane_atomic_get_property(struct drm_plane *plane,
 
 	if (property == rcdu->props.alpha)
 		*val = rstate->alpha;
+	else if (property == rcdu->props.colorkey)
+		*val = rstate->colorkey;
+	else if (property == rcdu->props.colorkey_alpha)
+		*val = rstate->colorkey_alpha;
 	else
 		return -EINVAL;
 
@@ -633,6 +648,13 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp)
 
 		drm_object_attach_property(&plane->plane.base,
 					   rcdu->props.alpha, 255);
+		drm_object_attach_property(&plane->plane.base,
+					   rcdu->props.colorkey,
+					   RCAR_DU_COLORKEY_NONE);
+		if (rcdu->props.colorkey_alpha)
+			drm_object_attach_property(&plane->plane.base,
+						   rcdu->props.colorkey_alpha,
+						   0);
 		drm_plane_create_zpos_property(&plane->plane, 1, 1,
 					       vsp->num_planes - 1);
 	}
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
index 3fd9cef..1543503 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
@@ -47,6 +47,9 @@ static inline struct rcar_du_vsp_plane *to_rcar_vsp_plane(struct drm_plane *p)
  * @sg_tables: scatter-gather tables for the frame buffer memory
  * @alpha: value of the plane alpha property
  * @zpos: value of the plane zpos property
+ * @colorkey: value of the color for which to apply colorkey_alpha, bit 24
+ * tells if it is enabled or not
+ * @colorkey_alpha: alpha to be used for pixels with color equal to colorkey
  */
 struct rcar_du_vsp_plane_state {
 	struct drm_plane_state state;
@@ -56,6 +59,8 @@ struct rcar_du_vsp_plane_state {
 
 	unsigned int alpha;
 	unsigned int zpos;
+	u32 colorkey;
+	u32 colorkey_alpha;
 };
 
 static inline struct rcar_du_vsp_plane_state *
-- 
1.9.1
