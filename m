Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46337 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732383AbeHGUW1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 16:22:27 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 2/2] drm/tegra: plane: Add generic colorkey properties for older Tegra's
Date: Tue,  7 Aug 2018 20:22:02 +0300
Message-Id: <20180807172202.1961-3-digetx@gmail.com>
In-Reply-To: <20180807172202.1961-1-digetx@gmail.com>
References: <20180807172202.1961-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the starter a minimal color keying support is implemented, which is
enough to provide userspace like Opentegra Xorg driver with ability to
support color keying by the XVideo extension. Blending controls interface
changed on newer Tegra's, this patch provides color keying support for
Tegra20/30/114 only.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/gpu/drm/tegra/dc.c    |  25 ++++++
 drivers/gpu/drm/tegra/dc.h    |   7 ++
 drivers/gpu/drm/tegra/plane.c | 156 ++++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 965088afcfad..7e90df036c48 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -162,6 +162,7 @@ static void tegra_plane_setup_blending_legacy(struct tegra_plane *plane)
 	u32 foreground = BLEND_WEIGHT1(255) | BLEND_WEIGHT0(255) |
 			 BLEND_COLOR_KEY_NONE;
 	u32 blendnokey = BLEND_WEIGHT1(255) | BLEND_WEIGHT0(255);
+	enum drm_plane_colorkey_mode mode;
 	struct tegra_plane_state *state;
 	u32 blending[2];
 	unsigned int i;
@@ -171,7 +172,15 @@ static void tegra_plane_setup_blending_legacy(struct tegra_plane *plane)
 	tegra_plane_writel(plane, foreground, DC_WIN_BLEND_1WIN);
 
 	state = to_tegra_plane_state(plane->base.state);
+	mode = plane->base.state->colorkey.mode;
 
+	/* setup color keying */
+	if (mode == DRM_PLANE_COLORKEY_MODE_TRANSPARENT) {
+		/* color key matched areas are transparent */
+		foreground = background[0] | BLEND_COLOR_KEY_0;
+	}
+
+	/* setup alpha blending */
 	if (state->opaque) {
 		/*
 		 * Since custom fix-weight blending isn't utilized and weight
@@ -792,6 +801,11 @@ static struct drm_plane *tegra_primary_plane_create(struct drm_device *drm,
 		dev_err(dc->dev, "failed to create rotation property: %d\n",
 			err);
 
+	if (dc->soc->has_legacy_blending)
+		drm_plane_create_colorkey_properties(&plane->base,
+				BIT(DRM_PLANE_COLORKEY_MODE_DISABLED) |
+				BIT(DRM_PLANE_COLORKEY_MODE_TRANSPARENT));
+
 	return &plane->base;
 }
 
@@ -1077,6 +1091,11 @@ static struct drm_plane *tegra_dc_overlay_plane_create(struct drm_device *drm,
 		dev_err(dc->dev, "failed to create rotation property: %d\n",
 			err);
 
+	if (dc->soc->has_legacy_blending)
+		drm_plane_create_colorkey_properties(&plane->base,
+				BIT(DRM_PLANE_COLORKEY_MODE_DISABLED) |
+				BIT(DRM_PLANE_COLORKEY_MODE_TRANSPARENT));
+
 	return &plane->base;
 }
 
@@ -1187,6 +1206,7 @@ tegra_crtc_atomic_duplicate_state(struct drm_crtc *crtc)
 	copy->pclk = state->pclk;
 	copy->div = state->div;
 	copy->planes = state->planes;
+	copy->ckey = state->ckey;
 
 	return &copy->base;
 }
@@ -1917,6 +1937,11 @@ static void tegra_crtc_atomic_flush(struct drm_crtc *crtc,
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	u32 value;
 
+	if (dc->soc->has_legacy_blending) {
+		tegra_dc_writel(dc, state->ckey.min, DC_DISP_COLOR_KEY0_LOWER);
+		tegra_dc_writel(dc, state->ckey.max, DC_DISP_COLOR_KEY0_UPPER);
+	}
+
 	value = state->planes << 8 | GENERAL_UPDATE;
 	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
 	value = tegra_dc_readl(dc, DC_CMD_STATE_CONTROL);
diff --git a/drivers/gpu/drm/tegra/dc.h b/drivers/gpu/drm/tegra/dc.h
index e96f582ca692..14ed31f0ff37 100644
--- a/drivers/gpu/drm/tegra/dc.h
+++ b/drivers/gpu/drm/tegra/dc.h
@@ -18,6 +18,11 @@
 
 struct tegra_output;
 
+struct tegra_dc_color_key_state {
+	u32 min;
+	u32 max;
+};
+
 struct tegra_dc_state {
 	struct drm_crtc_state base;
 
@@ -26,6 +31,8 @@ struct tegra_dc_state {
 	unsigned int div;
 
 	u32 planes;
+
+	struct tegra_dc_color_key_state ckey;
 };
 
 static inline struct tegra_dc_state *to_dc_state(struct drm_crtc_state *state)
diff --git a/drivers/gpu/drm/tegra/plane.c b/drivers/gpu/drm/tegra/plane.c
index d068e8aa3553..0823deef8d03 100644
--- a/drivers/gpu/drm/tegra/plane.c
+++ b/drivers/gpu/drm/tegra/plane.c
@@ -465,6 +465,158 @@ static int tegra_plane_setup_transparency(struct tegra_plane *tegra,
 	return 0;
 }
 
+static u32 tegra_plane_colorkey_to_hw_format(u64 drm_ckey64)
+{
+	/* convert ARGB16161616 to ARGB8888 */
+	u8 a = drm_colorkey_extract_component(drm_ckey64, alpha, 8);
+	u8 r = drm_colorkey_extract_component(drm_ckey64, red, 8);
+	u8 g = drm_colorkey_extract_component(drm_ckey64, green, 8);
+	u8 b = drm_colorkey_extract_component(drm_ckey64, blue, 8);
+
+	return (a << 24) | (r << 16) | (g << 8) | b;
+}
+
+static bool tegra_plane_format_valid_for_colorkey(struct drm_plane_state *state)
+{
+	struct tegra_plane_state *tegra_state = to_tegra_plane_state(state);
+
+	/*
+	 * Tegra20 does not support alpha channel matching. Newer Tegra's
+	 * support the alpha matching, but it is not implemented yet.
+	 *
+	 * Formats other than XRGB8888 haven't been tested much, hence they
+	 * are not supported for now.
+	 */
+	switch (tegra_state->format) {
+	case WIN_COLOR_DEPTH_R8G8B8X8:
+	case WIN_COLOR_DEPTH_B8G8R8X8:
+		break;
+
+	default:
+		return false;
+	};
+
+	return true;
+}
+
+static int tegra_plane_setup_colorkey(struct tegra_plane *tegra,
+				      struct tegra_plane_state *tegra_state)
+{
+	enum drm_plane_colorkey_mode mode;
+	struct drm_crtc_state *crtc_state;
+	struct tegra_dc_state *dc_state;
+	struct drm_plane_state *state;
+	struct drm_plane_state *old;
+	struct drm_plane_state *new;
+	struct drm_plane *plane;
+	unsigned int normalized_zpos;
+	u32 min_hw, max_hw, mask_hw;
+	u32 plane_mask;
+	u64 min, max;
+	u64 mask;
+
+	normalized_zpos = tegra_state->base.normalized_zpos;
+	plane_mask = tegra_state->base.colorkey.plane_mask;
+	mode = tegra_state->base.colorkey.mode;
+	mask = tegra_state->base.colorkey.mask;
+	min = tegra_state->base.colorkey.min;
+	max = tegra_state->base.colorkey.max;
+
+	/* convert color key values to HW format */
+	mask_hw = tegra_plane_colorkey_to_hw_format(mask);
+	min_hw = tegra_plane_colorkey_to_hw_format(min);
+	max_hw = tegra_plane_colorkey_to_hw_format(max);
+
+	state = &tegra_state->base;
+	old = drm_atomic_get_old_plane_state(state->state, &tegra->base);
+
+	/* no need to proceed if color keying state is unchanged */
+	if (old->colorkey.plane_mask == plane_mask &&
+	    old->colorkey.mask == mask &&
+	    old->colorkey.mode == mode &&
+	    old->colorkey.min == min &&
+	    old->colorkey.max == max &&
+	    old->crtc)
+	{
+		if (mode == DRM_PLANE_COLORKEY_MODE_DISABLED)
+			return 0;
+
+		crtc_state = drm_atomic_get_crtc_state(state->state,
+						       state->crtc);
+		if (IS_ERR(crtc_state))
+			return PTR_ERR(crtc_state);
+
+		if (!crtc_state->zpos_changed) {
+			dc_state = to_dc_state(crtc_state);
+
+			if (dc_state->ckey.min == min_hw &&
+			    dc_state->ckey.max == max_hw)
+				return 0;
+		}
+	}
+
+	/*
+	 * Currently color keying is implemented for the middle plane
+	 * only (source and destination) to simplify things, validate planes
+	 * position and mask.
+	 */
+	if (state->fb && mode != DRM_PLANE_COLORKEY_MODE_DISABLED) {
+		/*
+		 * Tegra does not support color key masking, note that alpha
+		 * channel mask is ignored because only opaque formats are
+		 * currently supported.
+		 */
+		if ((mask_hw & 0xffffff) != 0xffffff)
+			return -EINVAL;
+
+		drm_for_each_plane_mask(plane, tegra->base.dev, plane_mask) {
+			struct tegra_plane *p = to_tegra_plane(plane);
+
+			/* HW can't access planes on a different CRTC */
+			if (p->dc != tegra->dc)
+				return -EINVAL;
+
+			new = drm_atomic_get_plane_state(state->state, plane);
+			if (IS_ERR(new))
+				return PTR_ERR(new);
+
+			/* don't care about disabled plane */
+			if (!new->fb)
+				continue;
+
+			if (!tegra_plane_format_valid_for_colorkey(new))
+				return -EINVAL;
+
+			/* middle plane sourcing itself */
+			if (new->normalized_zpos == 1 &&
+			    normalized_zpos == 1)
+				continue;
+
+			return -EINVAL;
+		}
+	}
+
+	/* only middle plane affects the color key state, see comment above */
+	if (normalized_zpos != 1)
+		return 0;
+
+	/*
+	 * Tegra's HW has color key values stored within CRTC, hence adjust
+	 * planes CRTC atomic state.
+	 */
+	crtc_state = drm_atomic_get_crtc_state(state->state, state->crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
+	dc_state = to_dc_state(crtc_state);
+
+	/* update CRTC's color key state */
+	dc_state->ckey.min = min_hw;
+	dc_state->ckey.max = max_hw;
+
+	return 0;
+}
+
 int tegra_plane_setup_legacy_state(struct tegra_plane *tegra,
 				   struct tegra_plane_state *state)
 {
@@ -478,5 +630,9 @@ int tegra_plane_setup_legacy_state(struct tegra_plane *tegra,
 	if (err < 0)
 		return err;
 
+	err = tegra_plane_setup_colorkey(tegra, state);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
-- 
2.18.0
