Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34136 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbeFCWCV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Jun 2018 18:02:21 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 2/2] drm/tegra: plane: Implement generic colorkey property for older Tegra's
Date: Mon,  4 Jun 2018 01:00:59 +0300
Message-Id: <20180603220059.17670-3-digetx@gmail.com>
In-Reply-To: <20180603220059.17670-1-digetx@gmail.com>
References: <20180603220059.17670-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the starter a minimal color keying support is implemented, which is
enough to provide userspace like Opentegra Xorg driver with ability to
support color keying by the XVideo extension.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/gpu/drm/tegra/dc.c    |  25 +++++++++
 drivers/gpu/drm/tegra/dc.h    |   7 +++
 drivers/gpu/drm/tegra/plane.c | 102 ++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index c3afe7b2237e..685a0fedb01d 100644
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
+	if (mode == DRM_PLANE_COLORKEY_MODE_FOREGROUND_CLIP) {
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
+				BIT(DRM_PLANE_COLORKEY_MODE_FOREGROUND_CLIP));
+
 	return &plane->base;
 }
 
@@ -1077,6 +1091,11 @@ static struct drm_plane *tegra_dc_overlay_plane_create(struct drm_device *drm,
 		dev_err(dc->dev, "failed to create rotation property: %d\n",
 			err);
 
+	if (dc->soc->has_legacy_blending)
+		drm_plane_create_colorkey_properties(&plane->base,
+				BIT(DRM_PLANE_COLORKEY_MODE_DISABLED) |
+				BIT(DRM_PLANE_COLORKEY_MODE_FOREGROUND_CLIP));
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
index d068e8aa3553..b8f05fd6ffcc 100644
--- a/drivers/gpu/drm/tegra/plane.c
+++ b/drivers/gpu/drm/tegra/plane.c
@@ -465,6 +465,104 @@ static int tegra_plane_setup_transparency(struct tegra_plane *tegra,
 	return 0;
 }
 
+static u32 tegra_plane_convert_colorkey_format(u64 value)
+{
+	/* convert ARGB16161616 to ARGB8888 */
+	u16 a = (value >> 48) & 0xFFFF;
+	u16 r = (value >> 32) & 0xFFFF;
+	u16 g = (value >> 16) & 0xFFFF;
+	u16 b = (value >>  0) & 0xFFFF;
+
+	a = min_t(u16, 0xff, a / 256);
+	r = min_t(u16, 0xff, r / 256);
+	g = min_t(u16, 0xff, g / 256);
+	b = min_t(u16, 0xff, b / 256);
+
+	return (a << 24) | (r << 16) | (g << 8) | b;
+}
+
+static bool tegra_plane_format_invalid_for_colorkey(
+						struct drm_plane_state *state)
+{
+	/*
+	 * Older Tegra's do not support alpha channel matching. It should
+	 * be possible to support certain cases where planes format has alpha
+	 * channel, but for simplicity these cases currently are unsupported.
+	 */
+	if (state->fb && __drm_format_has_alpha(state->fb->format->format))
+		return true;
+
+	return false;
+}
+
+static int tegra_plane_setup_colorkey(struct tegra_plane *tegra,
+				      struct tegra_plane_state *tegra_state)
+{
+	enum drm_plane_colorkey_mode mode;
+	struct drm_plane_state *old_plane;
+	struct drm_crtc_state *crtc_state;
+	struct tegra_dc_state *dc_state;
+	struct drm_plane_state *state;
+	u64 min, max;
+
+	mode = tegra_state->base.colorkey.mode;
+	min = tegra_state->base.colorkey.min;
+	max = tegra_state->base.colorkey.max;
+
+	/* no need to proceed if color keying is disabled */
+	if (mode == DRM_PLANE_COLORKEY_MODE_DISABLED)
+		return 0;
+
+	state = &tegra_state->base;
+	old_plane = drm_atomic_get_old_plane_state(state->state, &tegra->base);
+
+	/*
+	 * Currently color keying implemented for the middle plane only
+	 * to simplify things.
+	 */
+	if (state->normalized_zpos != 1) {
+		/* foreground-clip has no effect when applied to bottom plane */
+		if (state->normalized_zpos == 0)
+			return 0;
+
+		return -EINVAL;
+	}
+
+	/*
+	 * There is no need to proceed, adding CRTC and other planes to
+	 * the atomic update, if color keying state is unchanged.
+	 */
+	if (old_plane &&
+	    old_plane->colorkey.mode == mode &&
+	    old_plane->colorkey.min == min &&
+	    old_plane->colorkey.max == max)
+		return 0;
+
+	/* convert color key values to HW format */
+	min = tegra_plane_convert_colorkey_format(min);
+	max = tegra_plane_convert_colorkey_format(max);
+
+	/* validate planes format */
+	if (tegra_plane_format_invalid_for_colorkey(state))
+		return -EINVAL;
+
+	/*
+	 * Tegra's HW stores color key values within CRTC, hence adjust
+	 * planes CRTC atomic state.
+	 */
+	crtc_state = drm_atomic_get_crtc_state(state->state, state->crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
+	dc_state = to_dc_state(crtc_state);
+
+	/* update CRTC's color key state */
+	dc_state->ckey.min = min;
+	dc_state->ckey.max = max;
+
+	return 0;
+}
+
 int tegra_plane_setup_legacy_state(struct tegra_plane *tegra,
 				   struct tegra_plane_state *state)
 {
@@ -478,5 +576,9 @@ int tegra_plane_setup_legacy_state(struct tegra_plane *tegra,
 	if (err < 0)
 		return err;
 
+	err = tegra_plane_setup_colorkey(tegra, state);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
-- 
2.17.0
