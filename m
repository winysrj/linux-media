Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45429 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbbDMSj2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 14:39:28 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-api@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Daniel Vetter <daniel.vetter@intel.com>
Subject: [RFC/PATCH v2 4/5] drm/rcar-du: Add VSP1 live source support
Date: Mon, 13 Apr 2015 21:39:46 +0300
Message-Id: <1428950387-6913-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1428950387-6913-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1428950387-6913-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register live sources for VSPD0 and VSPD1 and configure the plane source
at plane setup time to source frames from memory or from the VSP1.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_drv.c   |   6 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.h   |   3 +
 drivers/gpu/drm/rcar-du/rcar_du_group.c |  19 ++--
 drivers/gpu/drm/rcar-du/rcar_du_group.h |   2 +
 drivers/gpu/drm/rcar-du/rcar_du_kms.c   |  92 ++++++++++++++++-
 drivers/gpu/drm/rcar-du/rcar_du_kms.h   |   3 +
 drivers/gpu/drm/rcar-du/rcar_du_plane.c | 168 +++++++++++++++++++++++++-------
 drivers/gpu/drm/rcar-du/rcar_du_plane.h |   3 +
 drivers/gpu/drm/rcar-du/rcar_du_regs.h  |   1 +
 9 files changed, 246 insertions(+), 51 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index da1216a73969..e16a912327b7 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -58,7 +58,8 @@ static const struct rcar_du_device_info rcar_du_r8a7779_info = {
 
 static const struct rcar_du_device_info rcar_du_r8a7790_info = {
 	.features = RCAR_DU_FEATURE_CRTC_IRQ_CLOCK
-		  | RCAR_DU_FEATURE_EXT_CTRL_REGS,
+		  | RCAR_DU_FEATURE_EXT_CTRL_REGS
+		  | RCAR_DU_FEATURE_VSP1_SOURCE,
 	.quirks = RCAR_DU_QUIRK_ALIGN_128B | RCAR_DU_QUIRK_LVDS_LANES,
 	.num_crtcs = 3,
 	.routes = {
@@ -86,7 +87,8 @@ static const struct rcar_du_device_info rcar_du_r8a7790_info = {
 
 static const struct rcar_du_device_info rcar_du_r8a7791_info = {
 	.features = RCAR_DU_FEATURE_CRTC_IRQ_CLOCK
-		  | RCAR_DU_FEATURE_EXT_CTRL_REGS,
+		  | RCAR_DU_FEATURE_EXT_CTRL_REGS
+		  | RCAR_DU_FEATURE_VSP1_SOURCE,
 	.num_crtcs = 2,
 	.routes = {
 		/* R8A7791 has one RGB output, one LVDS output and one
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.h b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
index c7c538dd2e68..b5be16053e71 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
@@ -29,6 +29,7 @@ struct rcar_du_lvdsenc;
 
 #define RCAR_DU_FEATURE_CRTC_IRQ_CLOCK	(1 << 0)	/* Per-CRTC IRQ and clock */
 #define RCAR_DU_FEATURE_EXT_CTRL_REGS	(1 << 1)	/* Has extended control registers */
+#define RCAR_DU_FEATURE_VSP1_SOURCE	(1 << 2)	/* Has inputs from VSP1 */
 
 #define RCAR_DU_QUIRK_ALIGN_128B	(1 << 0)	/* Align pitches to 128 bytes */
 #define RCAR_DU_QUIRK_LVDS_LANES	(1 << 1)	/* LVDS lanes 1 and 3 inverted */
@@ -84,6 +85,8 @@ struct rcar_du_device {
 	struct rcar_du_group groups[RCAR_DU_MAX_GROUPS];
 
 	unsigned int dpad0_source;
+	unsigned int vspd1_sink;
+
 	struct rcar_du_lvdsenc *lvds[RCAR_DU_MAX_LVDS];
 
 	struct {
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_group.c b/drivers/gpu/drm/rcar-du/rcar_du_group.c
index 1bdc0ee0c248..71f50bf45581 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_group.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_group.c
@@ -49,10 +49,13 @@ static void rcar_du_group_setup_defr8(struct rcar_du_group *rgrp)
 	u32 defr8 = DEFR8_CODE | DEFR8_DEFE8;
 
 	/* The DEFR8 register for the first group also controls RGB output
-	 * routing to DPAD0
+	 * routing to DPAD0 and VSPD1 routing to DU0/1/2.
 	 */
-	if (rgrp->index == 0)
+	if (rgrp->index == 0) {
 		defr8 |= DEFR8_DRGBS_DU(rgrp->dev->dpad0_source);
+		if (rgrp->dev->vspd1_sink == 2)
+			defr8 |= DEFR8_VSCS;
+	}
 
 	rcar_du_group_write(rgrp, DEFR8, defr8);
 }
@@ -155,17 +158,17 @@ void rcar_du_group_restart(struct rcar_du_group *rgrp)
 	__rcar_du_group_start_stop(rgrp, true);
 }
 
-static int rcar_du_set_dpad0_routing(struct rcar_du_device *rcdu)
+int rcar_du_set_dpad0_vsp1_routing(struct rcar_du_device *rcdu)
 {
 	int ret;
 
 	if (!rcar_du_has(rcdu, RCAR_DU_FEATURE_EXT_CTRL_REGS))
 		return 0;
 
-	/* RGB output routing to DPAD0 is configured in the DEFR8 register of
-	 * the first group. As this function can be called with the DU0 and DU1
-	 * CRTCs disabled, we need to enable the first group clock before
-	 * accessing the register.
+	/* RGB output routing to DPAD0 and VSP1D routing to DU0/1/2 are
+	 * configured in the DEFR8 register of the first group. As this function
+	 * can be called with the DU0 and DU1 CRTCs disabled, we need to enable
+	 * the first group clock before accessing the register.
 	 */
 	ret = clk_prepare_enable(rcdu->crtcs[0].clock);
 	if (ret < 0)
@@ -196,5 +199,5 @@ int rcar_du_group_set_routing(struct rcar_du_group *rgrp)
 
 	rcar_du_group_write(rgrp, DORCR, dorcr);
 
-	return rcar_du_set_dpad0_routing(rgrp->dev);
+	return rcar_du_set_dpad0_vsp1_routing(rgrp->dev);
 }
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_group.h b/drivers/gpu/drm/rcar-du/rcar_du_group.h
index ed36433fbe84..3fdf77171034 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_group.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_group.h
@@ -52,4 +52,6 @@ void rcar_du_group_start_stop(struct rcar_du_group *rgrp, bool start);
 void rcar_du_group_restart(struct rcar_du_group *rgrp);
 int rcar_du_group_set_routing(struct rcar_du_group *rgrp);
 
+int rcar_du_set_dpad0_vsp1_routing(struct rcar_du_device *rcdu);
+
 #endif /* __RCAR_DU_GROUP_H__ */
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index 17f89bfca8f8..da22392cf379 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -134,6 +134,73 @@ int rcar_du_dumb_create(struct drm_file *file, struct drm_device *dev,
 	return drm_gem_cma_dumb_create_internal(file, dev, args);
 }
 
+struct rcar_du_live_framebuffer {
+	struct drm_framebuffer fb;
+	struct drm_live_source *src;
+};
+
+#define to_live_fb(fb) container_of(fb, struct rcar_du_live_framebuffer, fb)
+
+struct drm_live_source *rcar_du_live_fb_source(struct drm_framebuffer *fb)
+{
+	return fb->flags & DRM_MODE_FB_LIVE_SOURCE ? to_live_fb(fb)->src : NULL;
+}
+
+static void rcar_du_live_fb_destroy(struct drm_framebuffer *fb)
+{
+	struct rcar_du_live_framebuffer *live_fb = to_live_fb(fb);
+
+	drm_framebuffer_cleanup(fb);
+	kfree(live_fb);
+}
+
+static int rcar_du_live_fb_create_handle(struct drm_framebuffer *fb,
+	struct drm_file *file_priv, unsigned int *handle)
+{
+	*handle = 0;
+	return 0;
+}
+
+static struct drm_framebuffer_funcs rcar_du_live_fb_funcs = {
+	.destroy	= rcar_du_live_fb_destroy,
+	.create_handle	= rcar_du_live_fb_create_handle,
+};
+
+static struct drm_framebuffer *
+rcar_du_live_fb_create(struct drm_device *dev, struct drm_file *file_priv,
+		       struct drm_mode_fb_cmd2 *mode_cmd)
+{
+	struct rcar_du_live_framebuffer *fb;
+	struct drm_mode_object *obj;
+	struct drm_live_source *src;
+	int ret;
+
+	obj = drm_mode_object_find(dev, mode_cmd->handles[0],
+				   DRM_MODE_OBJECT_LIVE_SOURCE);
+	if (!obj)
+		return ERR_PTR(-EINVAL);
+
+	src = obj_to_live_source(obj);
+
+	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
+	if (!fb)
+		return ERR_PTR(-ENOMEM);
+
+	drm_helper_mode_fill_fb_struct(&fb->fb, mode_cmd);
+
+	fb->src = src;
+
+	ret = drm_framebuffer_init(dev, &fb->fb, &rcar_du_live_fb_funcs);
+	if (ret) {
+		dev_err(dev->dev, "Failed to initialize framebuffer: %d\n",
+			ret);
+		kfree(fb);
+		return ERR_PTR(ret);
+	}
+
+	return &fb->fb;
+}
+
 static struct drm_framebuffer *
 rcar_du_fb_create(struct drm_device *dev, struct drm_file *file_priv,
 		  struct drm_mode_fb_cmd2 *mode_cmd)
@@ -144,6 +211,9 @@ rcar_du_fb_create(struct drm_device *dev, struct drm_file *file_priv,
 	unsigned int align;
 	unsigned int bpp;
 
+	if (mode_cmd->flags & DRM_MODE_FB_LIVE_SOURCE)
+		return rcar_du_live_fb_create(dev, file_priv, mode_cmd);
+
 	format = rcar_du_format_info(mode_cmd->pixel_format);
 	if (format == NULL) {
 		dev_dbg(dev->dev, "unsupported pixel format %08x\n",
@@ -217,17 +287,25 @@ static void rcar_du_output_poll_changed(struct drm_device *dev)
  */
 
 static bool rcar_du_plane_needs_realloc(struct rcar_du_plane *plane,
-					struct rcar_du_plane_state *state)
+					struct rcar_du_plane_state *new_state)
 {
-	const struct rcar_du_format_info *cur_format;
+	struct rcar_du_plane_state *cur_state;
 
-	cur_format = to_rcar_du_plane_state(plane->plane.state)->format;
+	cur_state = to_rcar_du_plane_state(plane->plane.state);
 
 	/* Lowering the number of planes doesn't strictly require reallocation
 	 * as the extra hardware plane will be freed when committing, but doing
 	 * so could lead to more fragmentation.
 	 */
-	return !cur_format || cur_format->planes != state->format->planes;
+	if (!cur_state->format ||
+	    cur_state->format->planes != new_state->format->planes)
+		return true;
+
+	/* Reallocate hardware planes if the source has changed. */
+	if (cur_state->source != new_state->source)
+		return true;
+
+	return false;
 }
 
 static unsigned int rcar_du_plane_hwmask(struct rcar_du_plane_state *state)
@@ -776,6 +854,12 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu)
 
 	drm_mode_config_reset(dev);
 
+	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_VSP1_SOURCE)) {
+		ret = rcar_du_vsp1_sources_init(rcdu);
+		if (ret < 0)
+			return ret;
+	}
+
 	drm_kms_helper_poll_init(dev);
 
 	if (dev->mode_config.num_connector) {
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.h b/drivers/gpu/drm/rcar-du/rcar_du_kms.h
index 07951d5fe38b..b3c736f46231 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.h
@@ -18,6 +18,7 @@
 
 struct drm_file;
 struct drm_device;
+struct drm_live_source;
 struct drm_mode_create_dumb;
 struct rcar_du_device;
 
@@ -36,4 +37,6 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu);
 int rcar_du_dumb_create(struct drm_file *file, struct drm_device *dev,
 			struct drm_mode_create_dumb *args);
 
+struct drm_live_source *rcar_du_live_fb_source(struct drm_framebuffer *fb);
+
 #endif /* __RCAR_DU_KMS_H__ */
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.c b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
index 80e4dba78aef..07802639ac99 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_plane.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
@@ -20,21 +20,84 @@
 #include <drm/drm_plane_helper.h>
 
 #include "rcar_du_drv.h"
+#include "rcar_du_group.h"
 #include "rcar_du_kms.h"
 #include "rcar_du_plane.h"
 #include "rcar_du_regs.h"
 
-#define RCAR_DU_COLORKEY_NONE		(0 << 24)
-#define RCAR_DU_COLORKEY_SOURCE		(1 << 24)
-#define RCAR_DU_COLORKEY_MASK		(1 << 24)
+/* -----------------------------------------------------------------------------
+ * Live Sources
+ */
+
+struct rcar_du_vsp1_source {
+	struct drm_live_source base;
+
+	enum rcar_du_plane_source source;
+};
+
+static inline struct rcar_du_vsp1_source *
+to_rcar_vsp1_source(struct drm_live_source *src)
+{
+	return container_of(src, struct rcar_du_vsp1_source, base);
+}
+
+static const struct drm_live_source_funcs rcar_du_live_source_funcs = {
+	.destroy = drm_live_source_cleanup,
+};
+
+static const uint32_t source_formats[] = {
+	DRM_FORMAT_XRGB8888,
+};
 
-static u32 rcar_du_plane_read(struct rcar_du_group *rgrp,
-			      unsigned int index, u32 reg)
+int rcar_du_vsp1_sources_init(struct rcar_du_device *rcdu)
 {
-	return rcar_du_read(rgrp->dev,
-			    rgrp->mmio_offset + index * PLANE_OFF + reg);
+	static const struct {
+		enum rcar_du_plane_source source;
+		unsigned int planes;
+	} sources[] = {
+		{ RCAR_DU_PLANE_VSPD0, BIT(RCAR_DU_NUM_KMS_PLANES - 1) },
+		{ RCAR_DU_PLANE_VSPD1, BIT(RCAR_DU_NUM_KMS_PLANES - 2) |
+				       BIT(2 * RCAR_DU_NUM_KMS_PLANES - 1) },
+	};
+	unsigned int planes_mask;
+	unsigned int num_planes;
+	unsigned int i;
+
+	num_planes = RCAR_DU_NUM_KMS_PLANES * DIV_ROUND_UP(rcdu->num_crtcs, 2);
+	planes_mask = (1 << num_planes) - 1;
+
+	for (i = 0; i < ARRAY_SIZE(sources); ++i) {
+		struct rcar_du_vsp1_source *src;
+		char name[6];
+		int ret;
+
+		src = devm_kzalloc(rcdu->dev, sizeof(*src), GFP_KERNEL);
+		if (src == NULL)
+			return -ENOMEM;
+
+		src->source = sources[i].source;
+
+		sprintf(name, "vspd%u", i);
+		ret = drm_live_source_init(rcdu->ddev, &src->base, name,
+					   sources[i].planes & planes_mask,
+					   source_formats,
+					   ARRAY_SIZE(source_formats),
+					   &rcar_du_live_source_funcs);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
 }
 
+/* -----------------------------------------------------------------------------
+ * Planes
+ */
+
+#define RCAR_DU_COLORKEY_NONE		(0 << 24)
+#define RCAR_DU_COLORKEY_SOURCE		(1 << 24)
+#define RCAR_DU_COLORKEY_MASK		(1 << 24)
+
 static void rcar_du_plane_write(struct rcar_du_group *rgrp,
 				unsigned int index, u32 reg, u32 data)
 {
@@ -42,34 +105,47 @@ static void rcar_du_plane_write(struct rcar_du_group *rgrp,
 		      data);
 }
 
-static void rcar_du_plane_setup_fb(struct rcar_du_plane *plane)
+static void rcar_du_plane_setup_scanout(struct rcar_du_plane *plane)
 {
 	struct rcar_du_plane_state *state =
 		to_rcar_du_plane_state(plane->plane.state);
-	struct drm_framebuffer *fb = plane->plane.state->fb;
 	struct rcar_du_group *rgrp = plane->group;
 	unsigned int src_x = state->state.src_x >> 16;
 	unsigned int src_y = state->state.src_y >> 16;
 	unsigned int index = state->hwindex;
-	struct drm_gem_cma_object *gem;
+	unsigned int pitch;
 	bool interlaced;
-	u32 mwr;
+	u32 dma[2];
 
 	interlaced = state->state.crtc->state->adjusted_mode.flags
 		   & DRM_MODE_FLAG_INTERLACE;
 
+	if (state->source == RCAR_DU_PLANE_MEMORY) {
+		struct drm_framebuffer *fb = state->state.fb;
+		struct drm_gem_cma_object *gem;
+		unsigned int i;
+
+		if (state->format->planes == 2)
+			pitch = fb->pitches[0];
+		else
+			pitch = fb->pitches[0] * 8 / state->format->bpp;
+
+		for (i = 0; i < state->format->planes; ++i) {
+			gem = drm_fb_cma_get_gem_obj(fb, i);
+			dma[i] = gem->paddr + fb->offsets[i];
+		}
+	} else {
+		pitch = state->state.src_w >> 16;
+		dma[0] = 0;
+		dma[1] = 0;
+	}
+
 	/* Memory pitch (expressed in pixels). Must be doubled for interlaced
 	 * operation with 32bpp formats.
 	 */
-	if (state->format->planes == 2)
-		mwr = fb->pitches[0];
-	else
-		mwr = fb->pitches[0] * 8 / state->format->bpp;
-
-	if (interlaced && state->format->bpp == 32)
-		mwr *= 2;
-
-	rcar_du_plane_write(rgrp, index, PnMWR, mwr);
+	rcar_du_plane_write(rgrp, index, PnMWR,
+			    (interlaced && state->format->bpp == 32) ?
+			    pitch * 2 : pitch);
 
 	/* The Y position is expressed in raster line units and must be doubled
 	 * for 32bpp formats, according to the R8A7790 datasheet. No mention of
@@ -87,21 +163,18 @@ static void rcar_du_plane_setup_fb(struct rcar_du_plane *plane)
 	rcar_du_plane_write(rgrp, index, PnSPYR, src_y *
 			    (!interlaced && state->format->bpp == 32 ? 2 : 1));
 
-	gem = drm_fb_cma_get_gem_obj(fb, 0);
-	rcar_du_plane_write(rgrp, index, PnDSA0R, gem->paddr + fb->offsets[0]);
+	rcar_du_plane_write(rgrp, index, PnDSA0R, dma[0]);
 
 	if (state->format->planes == 2) {
 		index = (index + 1) % 8;
 
-		rcar_du_plane_write(rgrp, index, PnMWR, fb->pitches[0]);
+		rcar_du_plane_write(rgrp, index, PnMWR, pitch);
 
 		rcar_du_plane_write(rgrp, index, PnSPXR, src_x);
 		rcar_du_plane_write(rgrp, index, PnSPYR, src_y *
 				    (state->format->bpp == 16 ? 2 : 1) / 2);
 
-		gem = drm_fb_cma_get_gem_obj(fb, 1);
-		rcar_du_plane_write(rgrp, index, PnDSA0R,
-				    gem->paddr + fb->offsets[1]);
+		rcar_du_plane_write(rgrp, index, PnDSA0R, dma[1]);
 	}
 }
 
@@ -168,8 +241,8 @@ static void rcar_du_plane_setup_mode(struct rcar_du_plane *plane,
 	}
 }
 
-static void __rcar_du_plane_setup(struct rcar_du_plane *plane,
-				  unsigned int index)
+static void rcar_du_plane_setup_format(struct rcar_du_plane *plane,
+				       unsigned int index)
 {
 	struct rcar_du_plane_state *state =
 		to_rcar_du_plane_state(plane->plane.state);
@@ -182,10 +255,6 @@ static void __rcar_du_plane_setup(struct rcar_du_plane *plane,
 	 * The data format is selected by the DDDF field in PnMR and the EDF
 	 * field in DDCR4.
 	 */
-	ddcr4 = rcar_du_plane_read(rgrp, index, PnDDCR4);
-	ddcr4 &= ~PnDDCR4_EDF_MASK;
-	ddcr4 |= state->format->edf | PnDDCR4_CODE;
-
 	rcar_du_plane_setup_mode(plane, index);
 
 	if (state->format->planes == 2) {
@@ -204,6 +273,11 @@ static void __rcar_du_plane_setup(struct rcar_du_plane *plane,
 	}
 
 	rcar_du_plane_write(rgrp, index, PnDDCR2, ddcr2);
+
+	ddcr4 = state->format->edf | PnDDCR4_CODE;
+	if (state->source != RCAR_DU_PLANE_MEMORY)
+		ddcr4 |= PnDDCR4_VSPS;
+
 	rcar_du_plane_write(rgrp, index, PnDDCR4, ddcr4);
 
 	/* Destination position and size */
@@ -224,11 +298,21 @@ void rcar_du_plane_setup(struct rcar_du_plane *plane)
 	struct rcar_du_plane_state *state =
 		to_rcar_du_plane_state(plane->plane.state);
 
-	__rcar_du_plane_setup(plane, state->hwindex);
+	rcar_du_plane_setup_format(plane, state->hwindex);
 	if (state->format->planes == 2)
-		__rcar_du_plane_setup(plane, (state->hwindex + 1) % 8);
+		rcar_du_plane_setup_format(plane, (state->hwindex + 1) % 8);
+
+	rcar_du_plane_setup_scanout(plane);
 
-	rcar_du_plane_setup_fb(plane);
+	if (state->source == RCAR_DU_PLANE_VSPD1) {
+		unsigned int vspd1_sink = plane->group->index ? 2 : 0;
+		struct rcar_du_device *rcdu = plane->group->dev;
+
+		if (rcdu->vspd1_sink != vspd1_sink) {
+			rcdu->vspd1_sink = vspd1_sink;
+			rcar_du_set_dpad0_vsp1_routing(rcdu);
+		}
+	}
 }
 
 static int rcar_du_plane_atomic_check(struct drm_plane *plane,
@@ -237,6 +321,7 @@ static int rcar_du_plane_atomic_check(struct drm_plane *plane,
 	struct rcar_du_plane_state *rstate = to_rcar_du_plane_state(state);
 	struct rcar_du_plane *rplane = to_rcar_plane(plane);
 	struct rcar_du_device *rcdu = rplane->group->dev;
+	uint32_t pixel_format;
 
 	if (!state->fb || !state->crtc) {
 		rstate->format = NULL;
@@ -249,13 +334,22 @@ static int rcar_du_plane_atomic_check(struct drm_plane *plane,
 		return -EINVAL;
 	}
 
-	rstate->format = rcar_du_format_info(state->fb->pixel_format);
+	pixel_format = state->fb->pixel_format;
+	rstate->format = rcar_du_format_info(pixel_format);
 	if (rstate->format == NULL) {
 		dev_dbg(rcdu->dev, "%s: unsupported format %08x\n", __func__,
-			state->fb->pixel_format);
+			pixel_format);
 		return -EINVAL;
 	}
 
+	if (state->fb->flags & DRM_MODE_FB_LIVE_SOURCE) {
+		struct drm_live_source *src = rcar_du_live_fb_source(state->fb);
+
+		rstate->source = to_rcar_vsp1_source(src)->source;
+	} else {
+		rstate->source = RCAR_DU_PLANE_MEMORY;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.h b/drivers/gpu/drm/rcar-du/rcar_du_plane.h
index 81c2d361a94f..9a6132899d59 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_plane.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.h
@@ -17,6 +17,7 @@
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
 
+struct rcar_du_device;
 struct rcar_du_format_info;
 struct rcar_du_group;
 
@@ -70,6 +71,8 @@ to_rcar_du_plane_state(struct drm_plane_state *state)
 	return container_of(state, struct rcar_du_plane_state, state);
 }
 
+int rcar_du_vsp1_sources_init(struct rcar_du_device *rcdu);
+
 int rcar_du_planes_init(struct rcar_du_group *rgrp);
 
 void rcar_du_plane_setup(struct rcar_du_plane *plane);
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_regs.h b/drivers/gpu/drm/rcar-du/rcar_du_regs.h
index 70fcbc471ebd..ac9c3e511e79 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_regs.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_regs.h
@@ -389,6 +389,7 @@
 
 #define PnDDCR4			0x00190
 #define PnDDCR4_CODE		(0x7766 << 16)
+#define PnDDCR4_VSPS		(1 << 13)
 #define PnDDCR4_SDFS_RGB	(0 << 4)
 #define PnDDCR4_SDFS_YC		(5 << 4)
 #define PnDDCR4_SDFS_MASK	(7 << 4)
-- 
2.0.5

