Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37344 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032050AbeEZP5r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 May 2018 11:57:47 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 2/2] drm/tegra: plane: Implement generic colorkey property for older Tegra's
Date: Sat, 26 May 2018 18:56:23 +0300
Message-Id: <20180526155623.12610-3-digetx@gmail.com>
In-Reply-To: <20180526155623.12610-1-digetx@gmail.com>
References: <20180526155623.12610-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Color keying allows to draw on top of overlapping planes, like for
example on top of a video plane. Older Tegra's have a limited color
keying capability, such that blending features are reduced when color
keying is enabled. In particular dependent weighting isn't possible,
meaning that cursors plane can't be displayed properly. In most cases
it is more useful to display content on top of video overlay, so
sacrificing mouse cursor in the area of three planes intersection with
colorkey mismatch is a reasonable tradeoff.

This patch implements the generic DRM colorkey property. For the starter
a minimal color keying support is implemented, it is enough to provide
userspace like Opentegra Xorg driver with ability to support color keying
by the XVideo extension.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/gpu/drm/tegra/dc.c    |  31 +++++++
 drivers/gpu/drm/tegra/dc.h    |   7 ++
 drivers/gpu/drm/tegra/plane.c | 147 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tegra/plane.h |   1 +
 4 files changed, 186 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 31e12a9dfcb8..a5add64e40e2 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -172,6 +172,11 @@ static void tegra_plane_setup_blending_legacy(struct tegra_plane *plane)
 
 	state = to_tegra_plane_state(plane->base.state);
 
+	if (state->ckey_enabled) {
+		background[0] |= BLEND_COLOR_KEY_0;
+		background[2] |= BLEND_COLOR_KEY_0;
+	}
+
 	if (state->opaque) {
 		/*
 		 * Since custom fix-weight blending isn't utilized and weight
@@ -776,6 +781,11 @@ static struct drm_plane *tegra_primary_plane_create(struct drm_device *drm,
 	drm_plane_helper_add(&plane->base, &tegra_plane_helper_funcs);
 	drm_plane_create_zpos_property(&plane->base, plane->index, 0, 255);
 
+	if (dc->soc->has_legacy_blending)
+		drm_plane_create_colorkey_properties(&plane->base,
+					BIT(DRM_PLANE_COLORKEY_MODE_DISABLED) |
+					BIT(DRM_PLANE_COLORKEY_MODE_DST));
+
 	return &plane->base;
 }
 
@@ -1053,6 +1063,11 @@ static struct drm_plane *tegra_dc_overlay_plane_create(struct drm_device *drm,
 	drm_plane_helper_add(&plane->base, &tegra_plane_helper_funcs);
 	drm_plane_create_zpos_property(&plane->base, plane->index, 0, 255);
 
+	if (dc->soc->has_legacy_blending)
+		drm_plane_create_colorkey_properties(&plane->base,
+					BIT(DRM_PLANE_COLORKEY_MODE_DISABLED) |
+					BIT(DRM_PLANE_COLORKEY_MODE_DST));
+
 	return &plane->base;
 }
 
@@ -1153,6 +1168,7 @@ tegra_crtc_atomic_duplicate_state(struct drm_crtc *crtc)
 {
 	struct tegra_dc_state *state = to_dc_state(crtc->state);
 	struct tegra_dc_state *copy;
+	unsigned int i;
 
 	copy = kmalloc(sizeof(*copy), GFP_KERNEL);
 	if (!copy)
@@ -1164,6 +1180,9 @@ tegra_crtc_atomic_duplicate_state(struct drm_crtc *crtc)
 	copy->div = state->div;
 	copy->planes = state->planes;
 
+	for (i = 0; i < 2; i++)
+		copy->ckey[i] = state->ckey[i];
+
 	return &copy->base;
 }
 
@@ -1893,6 +1912,18 @@ static void tegra_crtc_atomic_flush(struct drm_crtc *crtc,
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	u32 value;
 
+	if (dc->soc->has_legacy_blending) {
+		tegra_dc_writel(dc,
+				state->ckey[0].lower, DC_DISP_COLOR_KEY0_LOWER);
+		tegra_dc_writel(dc,
+				state->ckey[0].upper, DC_DISP_COLOR_KEY0_UPPER);
+
+		tegra_dc_writel(dc,
+				state->ckey[1].lower, DC_DISP_COLOR_KEY1_LOWER);
+		tegra_dc_writel(dc,
+				state->ckey[1].upper, DC_DISP_COLOR_KEY1_UPPER);
+	}
+
 	value = state->planes << 8 | GENERAL_UPDATE;
 	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
 	value = tegra_dc_readl(dc, DC_CMD_STATE_CONTROL);
diff --git a/drivers/gpu/drm/tegra/dc.h b/drivers/gpu/drm/tegra/dc.h
index e96f582ca692..8209cb7d598a 100644
--- a/drivers/gpu/drm/tegra/dc.h
+++ b/drivers/gpu/drm/tegra/dc.h
@@ -18,6 +18,11 @@
 
 struct tegra_output;
 
+struct tegra_dc_color_key_state {
+	u32 lower;
+	u32 upper;
+};
+
 struct tegra_dc_state {
 	struct drm_crtc_state base;
 
@@ -26,6 +31,8 @@ struct tegra_dc_state {
 	unsigned int div;
 
 	u32 planes;
+
+	struct tegra_dc_color_key_state ckey[2];
 };
 
 static inline struct tegra_dc_state *to_dc_state(struct drm_crtc_state *state)
diff --git a/drivers/gpu/drm/tegra/plane.c b/drivers/gpu/drm/tegra/plane.c
index 0406c2ef432c..ba08b66d2499 100644
--- a/drivers/gpu/drm/tegra/plane.c
+++ b/drivers/gpu/drm/tegra/plane.c
@@ -57,6 +57,7 @@ tegra_plane_atomic_duplicate_state(struct drm_plane *plane)
 	copy->format = state->format;
 	copy->swap = state->swap;
 	copy->opaque = state->opaque;
+	copy->ckey_enabled = state->ckey_enabled;
 
 	for (i = 0; i < 2; i++)
 		copy->blending[i] = state->blending[i];
@@ -464,6 +465,148 @@ static int tegra_plane_setup_transparency(struct tegra_plane *tegra,
 	return 0;
 }
 
+static int tegra_plane_setup_colorkey(struct tegra_plane *tegra,
+				      struct tegra_plane_state *tegra_state)
+{
+	struct drm_plane_state *state;
+	struct drm_plane_state *new_plane;
+	struct drm_plane_state *old_plane;
+	struct drm_crtc_state *crtc_state;
+	struct drm_crtc_state *new_crtc;
+	struct tegra_dc_state *dc_state;
+	struct drm_plane *plane;
+	unsigned int mode;
+	u32 min, max;
+	u32 format;
+
+	/* at first check if plane has the colorkey property attached */
+	if (!tegra->base.colorkey.mode_property)
+		return 0;
+
+	format = tegra_state->base.colorkey.format;
+	mode = tegra_state->base.colorkey.mode;
+	min = tegra_state->base.colorkey.min;
+	max = tegra_state->base.colorkey.max;
+
+	state = &tegra_state->base;
+	old_plane = drm_atomic_get_old_plane_state(state->state, &tegra->base);
+
+	/* no need to proceed if color keying is (and was) disabled */
+	if (mode == DRM_PLANE_COLORKEY_MODE_DISABLED &&
+		(!old_plane || old_plane->colorkey.mode == mode))
+			return 0;
+
+	/*
+	 * Currently color keying implemented only for the middle plane
+	 * to simplify things, hence check the ordering.
+	 */
+	if (state->normalized_zpos != 1) {
+		if (mode == DRM_PLANE_COLORKEY_MODE_DISABLED)
+			goto update_planes;
+
+		return -EINVAL;
+	}
+
+	/* validate the color key mode */
+	if (mode != DRM_PLANE_COLORKEY_MODE_DST)
+		return -EINVAL;
+
+	/* validate the color key mask */
+	if ((state->colorkey.mask & 0xFFFFFF) != 0xFFFFFF)
+		return -EINVAL;
+
+	/* validate the replacement mask */
+	if (state->colorkey.replacement_mask != 0)
+		return -EINVAL;
+
+	/* validate the color key inversion mode */
+	if (state->colorkey.inverted_match != true)
+		return -EINVAL;
+
+	/*
+	 * There is no need to proceed, adding CRTC and other planes to
+	 * the atomic update, if color key value is unchanged.
+	 */
+	if (old_plane &&
+	    old_plane->colorkey.mode != DRM_PLANE_COLORKEY_MODE_DISABLED &&
+	    old_plane->colorkey.format == format &&
+	    old_plane->colorkey.min == min &&
+	    old_plane->colorkey.max == max)
+		return 0;
+
+	/* validate pixel format and convert color key value if necessary */
+	switch (format) {
+	case DRM_FORMAT_XBGR8888:
+#define XBGR8888_to_XRGB8888(v)	\
+	((((v) & 0xFF0000) >> 16) | ((v) & 0x00FF00) | (((v) & 0x0000FF) << 16))
+
+		min = XBGR8888_to_XRGB8888(min);
+		max = XBGR8888_to_XRGB8888(max);
+		break;
+
+	case DRM_FORMAT_XRGB8888:
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Tegra's HW stores the color key values within CRTC, hence adjust
+	 * planes CRTC atomic state.
+	 */
+	crtc_state = drm_atomic_get_crtc_state(state->state, state->crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
+	new_crtc = drm_atomic_get_new_crtc_state(state->state, state->crtc);
+	if (IS_ERR(new_crtc))
+		return PTR_ERR(new_crtc);
+
+	dc_state = to_dc_state(new_crtc);
+
+	/* update CRTC's color key state */
+	dc_state->ckey[0].lower = min;
+	dc_state->ckey[0].upper = max;
+
+update_planes:
+	/*
+	 * Currently the only supported color keying mode is
+	 * "dst-match-src-replace", i.e. in our case the actual matching
+	 * is performed by the underlying plane. Hence setup the color
+	 * matching for that plane and update other planes by including
+	 * them into the atomic update.
+	 */
+	drm_for_each_plane(plane, tegra->base.dev) {
+		struct tegra_plane *p = to_tegra_plane(plane);
+
+		/* skip this plane and planes on different CRTCs */
+		if (p == tegra || p->dc != tegra->dc)
+			continue;
+
+		state = drm_atomic_get_plane_state(state->state, plane);
+		if (IS_ERR(state))
+			return PTR_ERR(state);
+
+		new_plane = drm_atomic_get_new_plane_state(state->state, plane);
+		tegra_state = to_tegra_plane_state(new_plane);
+
+		/* skip planes hovering this plane */
+		if (new_plane->normalized_zpos > 1) {
+			tegra_state->ckey_enabled = false;
+			continue;
+		}
+
+		/* update planes color keying state */
+		if (mode == DRM_PLANE_COLORKEY_MODE_DISABLED)
+			tegra_state->ckey_enabled = false;
+		else
+			tegra_state->ckey_enabled = true;
+	}
+
+	return 0;
+}
+
 int tegra_plane_setup_legacy_state(struct tegra_plane *tegra,
 				   struct tegra_plane_state *state)
 {
@@ -477,5 +620,9 @@ int tegra_plane_setup_legacy_state(struct tegra_plane *tegra,
 	if (err < 0)
 		return err;
 
+	err = tegra_plane_setup_colorkey(tegra, state);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
diff --git a/drivers/gpu/drm/tegra/plane.h b/drivers/gpu/drm/tegra/plane.h
index 7360ddfafee8..617f57d98135 100644
--- a/drivers/gpu/drm/tegra/plane.h
+++ b/drivers/gpu/drm/tegra/plane.h
@@ -49,6 +49,7 @@ struct tegra_plane_state {
 	/* used for legacy blending support only */
 	struct tegra_plane_legacy_blending_state blending[2];
 	bool opaque;
+	bool ckey_enabled;
 };
 
 static inline struct tegra_plane_state *
-- 
2.17.0
