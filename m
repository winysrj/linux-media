Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:35606 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753019AbcJKOyp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 10:54:45 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        liviu.dudau@arm.com, robdclark@gmail.com, hverkuil@xs4all.nl,
        eric@anholt.net, ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: [RFC PATCH 11/11] drm: mali-dp: Add writeback connector
Date: Tue, 11 Oct 2016 15:54:08 +0100
Message-Id: <1476197648-24918-12-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mali-DP has a memory writeback engine which can be used to write the
composition result to a memory buffer.
Expose this functionality as a DRM writeback connector on supported
hardware.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/arm/Makefile      |    1 +
 drivers/gpu/drm/arm/malidp_crtc.c |   10 ++
 drivers/gpu/drm/arm/malidp_drv.c  |   25 +++-
 drivers/gpu/drm/arm/malidp_drv.h  |    5 +
 drivers/gpu/drm/arm/malidp_mw.c   |  268 +++++++++++++++++++++++++++++++++++++
 5 files changed, 305 insertions(+), 4 deletions(-)
 create mode 100644 drivers/gpu/drm/arm/malidp_mw.c

diff --git a/drivers/gpu/drm/arm/Makefile b/drivers/gpu/drm/arm/Makefile
index bb8b158..3bf31d1 100644
--- a/drivers/gpu/drm/arm/Makefile
+++ b/drivers/gpu/drm/arm/Makefile
@@ -1,4 +1,5 @@
 hdlcd-y := hdlcd_drv.o hdlcd_crtc.o
 obj-$(CONFIG_DRM_HDLCD)	+= hdlcd.o
 mali-dp-y := malidp_drv.o malidp_hw.o malidp_planes.o malidp_crtc.o
+mali-dp-y += malidp_mw.o
 obj-$(CONFIG_DRM_MALI_DISPLAY)	+= mali-dp.o
diff --git a/drivers/gpu/drm/arm/malidp_crtc.c b/drivers/gpu/drm/arm/malidp_crtc.c
index 08e6a71..98ddcea 100644
--- a/drivers/gpu/drm/arm/malidp_crtc.c
+++ b/drivers/gpu/drm/arm/malidp_crtc.c
@@ -68,6 +68,16 @@ static void malidp_crtc_enable(struct drm_crtc *crtc)
 	clk_set_rate(hwdev->pxlclk, crtc->state->adjusted_mode.crtc_clock * 1000);
 
 	hwdev->modeset(hwdev, &vm);
+	/*
+	 * We should always disable the memory write when leaving config mode,
+	 * otherwise the hardware will start writing right away - possibly with
+	 * a stale config, and definitely before we've had a chance to configure
+	 * the planes.
+	 * If the memory write needs to be enabled, that will get taken care
+	 * of later during the atomic commit
+	 */
+	if (hwdev->disable_memwrite)
+		hwdev->disable_memwrite(hwdev);
 	hwdev->leave_config_mode(hwdev);
 	drm_crtc_vblank_on(crtc);
 }
diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index 62a29f6..e20266e 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -91,7 +91,16 @@ static void malidp_atomic_commit_tail(struct drm_atomic_state *state)
 	struct drm_device *drm = state->dev;
 
 	drm_atomic_helper_commit_modeset_disables(drm, state);
+
 	drm_atomic_helper_commit_modeset_enables(drm, state);
+
+	/*
+	 * The order here is important. We must configure memory-write after
+	 * the CRTC is already enabled, so that its configuration update is
+	 * gated on the next CVAL.
+	 */
+	malidp_mw_atomic_commit(drm, state);
+
 	drm_atomic_helper_commit_planes(drm, state,
 					DRM_PLANE_COMMIT_ACTIVE_ONLY);
 
@@ -148,12 +157,20 @@ static int malidp_init(struct drm_device *drm)
 	drm->mode_config.helper_private = &malidp_mode_config_helpers;
 
 	ret = malidp_crtc_init(drm);
-	if (ret) {
-		drm_mode_config_cleanup(drm);
-		return ret;
-	}
+	if (ret)
+		goto crtc_fail;
+
+	ret = malidp_mw_connector_init(drm);
+	if (ret)
+		goto mw_fail;
 
 	return 0;
+
+mw_fail:
+	malidp_de_planes_destroy(drm);
+crtc_fail:
+	drm_mode_config_cleanup(drm);
+	return ret;
 }
 
 static void malidp_fini(struct drm_device *drm)
diff --git a/drivers/gpu/drm/arm/malidp_drv.h b/drivers/gpu/drm/arm/malidp_drv.h
index 9fc8a2e..905c104 100644
--- a/drivers/gpu/drm/arm/malidp_drv.h
+++ b/drivers/gpu/drm/arm/malidp_drv.h
@@ -22,6 +22,8 @@ struct malidp_drm {
 	struct drm_fbdev_cma *fbdev;
 	struct list_head event_list;
 	struct drm_crtc crtc;
+	struct drm_encoder mw_encoder;
+	struct drm_connector mw_connector;
 	wait_queue_head_t wq;
 	atomic_t config_valid;
 };
@@ -50,6 +52,9 @@ struct malidp_plane_state {
 int malidp_de_planes_init(struct drm_device *drm);
 void malidp_de_planes_destroy(struct drm_device *drm);
 int malidp_crtc_init(struct drm_device *drm);
+int malidp_mw_connector_init(struct drm_device *drm);
+void malidp_mw_atomic_commit(struct drm_device *drm,
+			     struct drm_atomic_state *old_state);
 
 /* often used combination of rotational bits */
 #define MALIDP_ROTATED_MASK	(DRM_ROTATE_90 | DRM_ROTATE_270)
diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
new file mode 100644
index 0000000..72df3fd
--- /dev/null
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -0,0 +1,268 @@
+/*
+ * (C) COPYRIGHT 2016 ARM Limited. All rights reserved.
+ * Author: Brian Starkey <brian.starkey@arm.com>
+ *
+ * This program is free software and is provided to you under the terms of the
+ * GNU General Public License version 2 as published by the Free Software
+ * Foundation, and any use by you of this program is subject to the terms
+ * of such GNU licence.
+ *
+ * ARM Mali DP Writeback connector implementation
+ */
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_atomic.h>
+#include <drm/drm_atomic_helper.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+
+#include "malidp_drv.h"
+#include "malidp_hw.h"
+
+#define mw_conn_to_malidp_device(x) container_of(x, struct malidp_drm, mw_connector)
+#define to_mw_state(_state) (struct malidp_mw_connector_state *)(_state)
+
+struct malidp_mw_connector_state {
+	struct drm_connector_state base;
+	dma_addr_t addrs[2];
+	s32 pitches[2];
+	u8 format;
+	u8 n_planes;
+	u8 crtc_active:1;
+};
+
+static int malidp_mw_connector_get_modes(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+
+	return drm_add_modes_noedid(connector, dev->mode_config.max_width,
+				    dev->mode_config.max_height);
+}
+
+static enum drm_mode_status
+malidp_mw_connector_mode_valid(struct drm_connector *connector,
+			       struct drm_display_mode *mode)
+{
+	struct drm_device *dev = connector->dev;
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	int w = mode->hdisplay, h = mode->vdisplay;
+
+	if ((w < mode_config->min_width) || (w > mode_config->max_width))
+		return MODE_BAD_HVALUE;
+
+	if ((h < mode_config->min_height) || (h > mode_config->max_height))
+		return MODE_BAD_VVALUE;
+
+	return MODE_OK;
+}
+
+const struct drm_connector_helper_funcs malidp_mw_connector_helper_funcs = {
+	.get_modes = malidp_mw_connector_get_modes,
+	.mode_valid = malidp_mw_connector_mode_valid,
+};
+
+static enum drm_connector_status
+malidp_mw_connector_detect(struct drm_connector *connector, bool force)
+{
+	return connector_status_connected;
+}
+
+static void malidp_mw_connector_destroy(struct drm_connector *connector)
+{
+	drm_connector_cleanup(connector);
+}
+
+static struct drm_connector_state *
+malidp_mw_connector_duplicate_state(struct drm_connector *connector)
+{
+	struct malidp_mw_connector_state *mw_state, *old_state;
+
+	if (WARN_ON(!connector->state))
+		return NULL;
+
+	mw_state = kmalloc(sizeof(*mw_state), GFP_KERNEL);
+	if (!mw_state)
+		return NULL;
+
+	old_state = (struct malidp_mw_connector_state *)connector->state;
+	memcpy(mw_state, old_state, sizeof(*mw_state));
+	/*
+	 * This duplicates a little memcpy, but it ensures we still do the
+	 * right thing if drm_connector_state changes
+	 */
+	__drm_atomic_helper_connector_duplicate_state(connector, &mw_state->base);
+
+	return &mw_state->base;
+}
+
+static void malidp_mw_connector_destroy_state(struct drm_connector *connector,
+					      struct drm_connector_state *state)
+{
+	struct malidp_mw_connector_state *mw_state =
+		(struct malidp_mw_connector_state *)state;
+
+	__drm_atomic_helper_connector_destroy_state(&mw_state->base);
+	kfree(mw_state);
+}
+
+static const struct drm_connector_funcs malidp_mw_connector_funcs = {
+	.dpms = drm_atomic_helper_connector_dpms,
+	.reset = drm_atomic_helper_connector_reset,
+	.detect = malidp_mw_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = malidp_mw_connector_destroy,
+	.atomic_duplicate_state = malidp_mw_connector_duplicate_state,
+	.atomic_destroy_state = malidp_mw_connector_destroy_state,
+};
+
+static int
+malidp_mw_encoder_atomic_check(struct drm_encoder *encoder,
+			       struct drm_crtc_state *crtc_state,
+			       struct drm_connector_state *conn_state)
+{
+	struct drm_connector *conn = conn_state->connector;
+	struct drm_framebuffer *fb = conn_state->fb;
+	struct malidp_drm *malidp = mw_conn_to_malidp_device(conn);
+	struct malidp_mw_connector_state *mw_state;
+	int i, n_planes;
+
+	mw_state = (struct malidp_mw_connector_state *)conn_state;
+	mw_state->crtc_active = crtc_state->active;
+
+	if (!conn_state->fb)
+		return 0;
+
+	if ((fb->width != crtc_state->mode.hdisplay) ||
+	    (fb->height != crtc_state->mode.vdisplay)) {
+		DRM_DEBUG_KMS("Invalid framebuffer size %ux%u\n",
+				fb->width, fb->height);
+		return -EINVAL;
+	}
+
+	mw_state->format =
+		malidp_hw_get_format_id(&malidp->dev->map, SE_MEMWRITE,
+					fb->pixel_format);
+	if (mw_state->format == MALIDP_INVALID_FORMAT_ID) {
+		char *format_name = drm_get_format_name(fb->pixel_format);
+		DRM_DEBUG_KMS("Invalid pixel format %s\n", format_name);
+		kfree(format_name);
+		return -EINVAL;
+	}
+
+	n_planes = drm_format_num_planes(fb->pixel_format);
+	for (i = 0; i < n_planes; i++) {
+		struct drm_gem_cma_object *obj = drm_fb_cma_get_gem_obj(fb, i);
+		if (!malidp_hw_pitch_valid(malidp->dev, fb->pitches[i])) {
+			DRM_DEBUG_KMS("Invalid pitch %u for plane %d\n",
+				      fb->pitches[i], i);
+			return -EINVAL;
+		}
+		mw_state->pitches[i] = fb->pitches[i];
+		mw_state->addrs[i] = obj->paddr + fb->offsets[i];
+	}
+	mw_state->n_planes = n_planes;
+
+	return 0;
+}
+
+static const struct drm_encoder_helper_funcs malidp_mw_encoder_helper_funcs = {
+	.atomic_check = malidp_mw_encoder_atomic_check,
+};
+
+static void malidp_mw_encoder_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+static const struct drm_encoder_funcs malidp_mw_encoder_funcs = {
+	.destroy = malidp_mw_encoder_destroy,
+};
+
+int malidp_mw_connector_init(struct drm_device *drm)
+{
+	struct malidp_drm *malidp = drm->dev_private;
+	const struct malidp_hw_regmap *map = &malidp->dev->map;
+	u32 *formats;
+	int ret, n, i;
+
+	if (!malidp->dev->enable_memwrite)
+		return 0;
+
+	ret = drm_mode_create_writeback_connector_properties(drm);
+	if (ret)
+		return ret;
+
+	drm_encoder_helper_add(&malidp->mw_encoder, &malidp_mw_encoder_helper_funcs);
+	malidp->mw_encoder.possible_crtcs = 1 << drm_crtc_index(&malidp->crtc);
+	ret = drm_encoder_init(drm, &malidp->mw_encoder, &malidp_mw_encoder_funcs,
+			       DRM_MODE_ENCODER_VIRTUAL, NULL);
+	if (ret)
+		return ret;
+
+	drm_connector_helper_add(&malidp->mw_connector,
+				 &malidp_mw_connector_helper_funcs);
+	malidp->mw_connector.interlace_allowed = 0;
+	ret = drm_connector_init(drm, &malidp->mw_connector,
+				 &malidp_mw_connector_funcs,
+				 DRM_MODE_CONNECTOR_WRITEBACK);
+	if (ret)
+		goto err_encoder;
+
+	ret = drm_mode_connector_attach_encoder(&malidp->mw_connector,
+						&malidp->mw_encoder);
+	if (ret)
+		goto err_connector;
+
+	formats = kcalloc(map->n_pixel_formats, sizeof(*formats), GFP_KERNEL);
+	if (!formats)
+		goto err_connector;
+
+	for (n = 0, i = 0;  i < map->n_pixel_formats; i++) {
+		if (map->pixel_formats[i].layer & SE_MEMWRITE)
+			formats[n++] = map->pixel_formats[i].format;
+	}
+
+	ret = drm_mode_connector_set_writeback_formats(&malidp->mw_connector,
+						       formats, n);
+	kfree(formats);
+	if (ret)
+		goto err_connector;
+
+	return 0;
+
+err_connector:
+	drm_connector_cleanup(&malidp->mw_connector);
+err_encoder:
+	drm_encoder_cleanup(&malidp->mw_encoder);
+	return ret;
+}
+
+void malidp_mw_atomic_commit(struct drm_device *drm,
+			     struct drm_atomic_state *old_state)
+{
+	struct malidp_mw_connector_state *mw_state;
+	struct malidp_drm *malidp = drm->dev_private;
+	struct malidp_hw_device *hwdev = malidp->dev;
+	struct drm_connector *mw_conn = &malidp->mw_connector;
+	struct drm_framebuffer *fb;
+
+	mw_state = to_mw_state(mw_conn->state);
+	if (!mw_state || !mw_state->crtc_active)
+		return;
+
+	if (!mw_state->base.fb) {
+		struct malidp_mw_connector_state *old_mw_state;
+		old_mw_state = to_mw_state(drm_atomic_get_existing_connector_state(old_state,
+										   mw_conn));
+		if (old_mw_state && old_mw_state->base.fb)
+			hwdev->disable_memwrite(hwdev);
+
+		return;
+	}
+
+	fb = mw_state->base.fb;
+	hwdev->enable_memwrite(hwdev, mw_state->addrs, mw_state->pitches,
+			       mw_state->n_planes, fb->width, fb->height,
+			       mw_state->format);
+}
-- 
1.7.9.5

