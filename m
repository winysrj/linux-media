Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44845 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390003AbeHGUW2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 16:22:28 -0400
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
Subject: [RFC PATCH v4 1/2] drm: Add generic colorkey properties for display planes
Date: Tue,  7 Aug 2018 20:22:01 +0300
Message-Id: <20180807172202.1961-2-digetx@gmail.com>
In-Reply-To: <20180807172202.1961-1-digetx@gmail.com>
References: <20180807172202.1961-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Color keying is the action of replacing pixels matching a given color
(or range of colors) with transparent pixels in an overlay when
performing blitting. Depending on the hardware capabilities, the
matching pixel can either become fully transparent or gain adjustment
of the pixels component values.

Color keying is found in a large number of devices whose capabilities
often differ, but they still have enough common features in range to
standardize color key properties. This commit adds new generic DRM plane
properties related to the color keying, providing initial color keying
support.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/gpu/drm/drm_atomic.c |  20 +++++
 drivers/gpu/drm/drm_blend.c  | 150 +++++++++++++++++++++++++++++++++++
 include/drm/drm_blend.h      |   3 +
 include/drm/drm_plane.h      |  91 +++++++++++++++++++++
 4 files changed, 264 insertions(+)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 3eb061e11e2e..e97364966f6d 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -904,6 +904,16 @@ static int drm_atomic_plane_set_property(struct drm_plane *plane,
 		state->rotation = val;
 	} else if (property == plane->zpos_property) {
 		state->zpos = val;
+	} else if (property == plane->colorkey.plane_mask_property) {
+		state->colorkey.plane_mask = val;
+	} else if (property == plane->colorkey.mode_property) {
+		state->colorkey.mode = val;
+	} else if (property == plane->colorkey.mask_property) {
+		state->colorkey.mask = val;
+	} else if (property == plane->colorkey.min_property) {
+		state->colorkey.min = val;
+	} else if (property == plane->colorkey.max_property) {
+		state->colorkey.max = val;
 	} else if (property == plane->color_encoding_property) {
 		state->color_encoding = val;
 	} else if (property == plane->color_range_property) {
@@ -972,6 +982,16 @@ drm_atomic_plane_get_property(struct drm_plane *plane,
 		*val = state->rotation;
 	} else if (property == plane->zpos_property) {
 		*val = state->zpos;
+	} else if (property == plane->colorkey.plane_mask_property) {
+		*val = state->colorkey.plane_mask;
+	} else if (property == plane->colorkey.mode_property) {
+		*val = state->colorkey.mode;
+	} else if (property == plane->colorkey.mask_property) {
+		*val = state->colorkey.mask;
+	} else if (property == plane->colorkey.min_property) {
+		*val = state->colorkey.min;
+	} else if (property == plane->colorkey.max_property) {
+		*val = state->colorkey.max;
 	} else if (property == plane->color_encoding_property) {
 		*val = state->color_encoding;
 	} else if (property == plane->color_range_property) {
diff --git a/drivers/gpu/drm/drm_blend.c b/drivers/gpu/drm/drm_blend.c
index a16a74d7e15e..13c61dd0d9b7 100644
--- a/drivers/gpu/drm/drm_blend.c
+++ b/drivers/gpu/drm/drm_blend.c
@@ -107,6 +107,11 @@
  *	planes. Without this property the primary plane is always below the cursor
  *	plane, and ordering between all other planes is undefined.
  *
+ * colorkey:
+ *	Color keying is set up with drm_plane_create_colorkey_properties().
+ *	It adds support for actions like replacing a range of colors with a
+ *	transparent color in the plane. Color keying is disabled by default.
+ *
  * Note that all the property extensions described here apply either to the
  * plane or the CRTC (e.g. for the background color, which currently is not
  * exposed and assumed to be black).
@@ -448,3 +453,148 @@ int drm_atomic_normalize_zpos(struct drm_device *dev,
 	return 0;
 }
 EXPORT_SYMBOL(drm_atomic_normalize_zpos);
+
+static const char * const plane_colorkey_mode_name[] = {
+	[DRM_PLANE_COLORKEY_MODE_DISABLED] = "disabled",
+	[DRM_PLANE_COLORKEY_MODE_TRANSPARENT] = "transparent",
+};
+
+/**
+ * drm_plane_create_colorkey_properties - create colorkey properties
+ * @plane: drm plane
+ * @supported_modes: bitmask of supported color keying modes
+ *
+ * This function creates the generic color keying properties and attaches them
+ * to the @plane to enable color keying control for blending operations.
+ *
+ * Glossary:
+ *
+ * Destination plane:
+ *	Plane to which color keying properties are applied, this planes takes
+ *	the effect of color keying operation. The effect is determined by a
+ *	given color keying mode.
+ *
+ * Source plane:
+ *	Pixels of this plane are the source for color key matching operation.
+ *
+ * Color keying is controlled by these properties:
+ *
+ * colorkey.plane_mask:
+ *	The mask property specifies which planes participate in color key
+ *	matching process, these planes are the color key sources.
+ *
+ *	Drivers return an error from their plane atomic check if plane can't be
+ *	handled.
+ *
+ * colorkey.mode:
+ *	The mode is an enumerated property that controls how color keying
+ *	operates.
+ *
+ * colorkey.mask:
+ *	This property specifies the pixel components mask. Unmasked pixel
+ *	components are not participating in the matching. This mask value is
+ *	applied to colorkey.min / max values. The mask value is given in a
+ *	64-bit integer in ARGB16161616 format, where A is the alpha value and
+ *	R, G and B correspond to the color components. Drivers shall convert
+ *	ARGB16161616 value into appropriate format within planes atomic check.
+ *
+ *	Drivers return an error from their plane atomic check if mask can't be
+ *	handled.
+ *
+ * colorkey.min, colorkey.max:
+ *	These two properties specify the colors that are treated as the color
+ *	key. Pixel whose value is in the [min, max] range is the color key
+ *	matching pixel. The minimum and maximum values are expressed as a
+ *	64-bit integer in ARGB16161616 format, where A is the alpha value and
+ *	R, G and B correspond to the color components. Drivers shall convert
+ *	ARGB16161616 value into appropriate format within planes atomic check.
+ *	The converted value shall be *rounded up* to the nearest value.
+ *
+ *	When a single color key is desired instead of a range, userspace shall
+ *	set the min and max properties to the same value.
+ *
+ *	Drivers return an error from their plane atomic check if range can't be
+ *	handled.
+ *
+ * Returns:
+ * Zero on success, negative errno on failure.
+ */
+int drm_plane_create_colorkey_properties(struct drm_plane *plane,
+					 u32 supported_modes)
+{
+	struct drm_prop_enum_list modes_list[DRM_PLANE_COLORKEY_MODES_NUM];
+	struct drm_device *dev = plane->dev;
+	struct drm_property *plane_mask_prop;
+	struct drm_property *mode_prop;
+	struct drm_property *mask_prop;
+	struct drm_property *min_prop;
+	struct drm_property *max_prop;
+	unsigned int modes_num = 0;
+	unsigned int i;
+
+	/* modes are driver-specific, build the list of supported modes */
+	for (i = 0; i < DRM_PLANE_COLORKEY_MODES_NUM; i++) {
+		if (!(supported_modes & BIT(i)))
+			continue;
+
+		modes_list[modes_num].name = plane_colorkey_mode_name[i];
+		modes_list[modes_num].type = i;
+		modes_num++;
+	}
+
+	/* at least one mode should be supported */
+	if (!modes_num)
+		return -EINVAL;
+
+	plane_mask_prop = drm_property_create_range(dev, 0,
+						    "colorkey.plane_mask",
+						    0, U32_MAX);
+	if (!plane_mask_prop)
+		return -ENOMEM;
+
+	mode_prop = drm_property_create_enum(dev, 0, "colorkey.mode",
+					     modes_list, modes_num);
+	if (!mode_prop)
+		goto err_destroy_plane_mask_prop;
+
+	mask_prop = drm_property_create_range(dev, 0, "colorkey.mask",
+					      0, U64_MAX);
+	if (!mask_prop)
+		goto err_destroy_mode_prop;
+
+	min_prop = drm_property_create_range(dev, 0, "colorkey.min",
+					     0, U64_MAX);
+	if (!min_prop)
+		goto err_destroy_mask_prop;
+
+	max_prop = drm_property_create_range(dev, 0, "colorkey.max",
+					     0, U64_MAX);
+	if (!max_prop)
+		goto err_destroy_min_prop;
+
+	drm_object_attach_property(&plane->base, plane_mask_prop, 0);
+	drm_object_attach_property(&plane->base, mode_prop, 0);
+	drm_object_attach_property(&plane->base, mask_prop, 0);
+	drm_object_attach_property(&plane->base, min_prop, 0);
+	drm_object_attach_property(&plane->base, max_prop, 0);
+
+	plane->colorkey.plane_mask_property = plane_mask_prop;
+	plane->colorkey.mode_property = mode_prop;
+	plane->colorkey.mask_property = mask_prop;
+	plane->colorkey.min_property = min_prop;
+	plane->colorkey.max_property = max_prop;
+
+	return 0;
+
+err_destroy_min_prop:
+	drm_property_destroy(dev, min_prop);
+err_destroy_mask_prop:
+	drm_property_destroy(dev, mask_prop);
+err_destroy_mode_prop:
+	drm_property_destroy(dev, mode_prop);
+err_destroy_plane_mask_prop:
+	drm_property_destroy(dev, plane_mask_prop);
+
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(drm_plane_create_colorkey_properties);
diff --git a/include/drm/drm_blend.h b/include/drm/drm_blend.h
index 330c561c4c11..8e80d33b643e 100644
--- a/include/drm/drm_blend.h
+++ b/include/drm/drm_blend.h
@@ -52,4 +52,7 @@ int drm_plane_create_zpos_immutable_property(struct drm_plane *plane,
 					     unsigned int zpos);
 int drm_atomic_normalize_zpos(struct drm_device *dev,
 			      struct drm_atomic_state *state);
+
+int drm_plane_create_colorkey_properties(struct drm_plane *plane,
+					 u32 supported_modes);
 #endif
diff --git a/include/drm/drm_plane.h b/include/drm/drm_plane.h
index 8a152dc16ea5..ab6a91e6b54e 100644
--- a/include/drm/drm_plane.h
+++ b/include/drm/drm_plane.h
@@ -25,6 +25,7 @@
 
 #include <linux/list.h>
 #include <linux/ctype.h>
+#include <linux/kernel.h>
 #include <drm/drm_mode_object.h>
 #include <drm/drm_color_mgmt.h>
 
@@ -32,6 +33,52 @@ struct drm_crtc;
 struct drm_printer;
 struct drm_modeset_acquire_ctx;
 
+/**
+ * enum drm_plane_colorkey_mode - uapi plane colorkey mode enumeration
+ */
+enum drm_plane_colorkey_mode {
+	/**
+	 * @DRM_PLANE_COLORKEY_MODE_DISABLED:
+	 *
+	 * No color matching performed in this mode.
+	 */
+	DRM_PLANE_COLORKEY_MODE_DISABLED,
+
+	/**
+	 * @DRM_PLANE_COLORKEY_MODE_TRANSPARENT:
+	 *
+	 * Destination plane pixels are completely transparent in areas
+	 * where pixels of a source plane are matching a given color key
+	 * range, in other cases pixels of a destination plane are unaffected.
+	 * In areas where two or more source planes overlap, the topmost
+	 * plane takes precedence.
+	 */
+	DRM_PLANE_COLORKEY_MODE_TRANSPARENT,
+
+	/**
+	 * @DRM_PLANE_COLORKEY_MODES_NUM:
+	 *
+	 * Total number of color keying modes.
+	 */
+	DRM_PLANE_COLORKEY_MODES_NUM,
+};
+
+/**
+ * struct drm_plane_colorkey_state - plane color keying state
+ * @mode: color keying mode
+ * @plane_mask: source planes that participate in color key matching
+ * @mask: color key mask (in ARGB16161616 format)
+ * @min: color key range minimum (in ARGB16161616 format)
+ * @max: color key range maximum (in ARGB16161616 format)
+ */
+struct drm_plane_colorkey_state {
+	enum drm_plane_colorkey_mode mode;
+	u64 plane_mask;
+	u64 mask;
+	u64 min;
+	u64 max;
+};
+
 /**
  * struct drm_plane_state - mutable plane state
  *
@@ -148,6 +195,13 @@ struct drm_plane_state {
 	 */
 	unsigned int normalized_zpos;
 
+	/**
+	 * @colorkey:
+	 * Color keying of the plane. See drm_plane_create_colorkey_properties()
+	 * for more details.
+	 */
+	struct drm_plane_colorkey_state colorkey;
+
 	/**
 	 * @color_encoding:
 	 *
@@ -660,6 +714,19 @@ struct drm_plane {
 	 */
 	struct drm_property *rotation_property;
 
+	/**
+	 * @colorkey:
+	 * Optional color keying properties for this plane. See
+	 * drm_plane_create_colorkey_properties().
+	 */
+	struct {
+		struct drm_property *plane_mask_property;
+		struct drm_property *mode_property;
+		struct drm_property *mask_property;
+		struct drm_property *min_property;
+		struct drm_property *max_property;
+	} colorkey;
+
 	/**
 	 * @color_encoding_property:
 	 *
@@ -779,5 +846,29 @@ static inline struct drm_plane *drm_plane_find(struct drm_device *dev,
 #define drm_for_each_plane(plane, dev) \
 	list_for_each_entry(plane, &(dev)->mode_config.plane_list, head)
 
+/**
+ * drm_colorkey_extract_component - get color key component value
+ * @ckey64: 64bit color key value
+ * @comp_name: name of 16bit color component to extract
+ * @nbits: size in bits of extracted component value
+ *
+ * Extract 16bit color component of @ckey64 given by @comp_name (alpha, red,
+ * green or blue) and convert it to an unsigned integer that has bit-width
+ * of @nbits (result is rounded-up).
+ */
+#define drm_colorkey_extract_component(ckey64, comp_name, nbits) \
+	__DRM_CKEY_CLAMP(__DRM_CKEY_CONV(ckey64, comp_name, nbits), nbits)
+
+#define __drm_ckey_alpha_shift	48
+#define __drm_ckey_red_shift	32
+#define __drm_ckey_green_shift	16
+#define __drm_ckey_blue_shift	0
+
+#define __DRM_CKEY_CONV(ckey64, comp_name, nbits) \
+	DIV_ROUND_UP((u16)((ckey64) >> __drm_ckey_ ## comp_name ## _shift), \
+		     1 << (16 - (nbits)))
+
+#define __DRM_CKEY_CLAMP(value, nbits) \
+	min_t(u16, (value), (1 << (nbits)) - 1)
 
 #endif
-- 
2.18.0
