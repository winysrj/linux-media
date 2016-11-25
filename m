Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:51202 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932635AbcKYQtd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 11:49:33 -0500
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, daniel@ffwll.ch, gustavo@padovan.org,
        laurent.pinchart@ideasonboard.com, eric@anholt.net,
        ville.syrjala@linux.intel.com, liviu.dudau@arm.com
Subject: [PATCH 6/6] drm: mali-dp: Add writeback connector
Date: Fri, 25 Nov 2016 16:49:04 +0000
Message-Id: <1480092544-1725-7-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mali-DP has a memory writeback engine which can be used to write the
composition result to a memory buffer. Expose this functionality as a
DRM writeback connector on supported hardware.

Changes since v1:
 Daniel Vetter:
 - Don't require a modeset when writeback routing changes
 - Make writeback connector always disconnected

Changes since v2:
 - Rebase onto new drm_writeback_connector
 - Add reset callback, allocating subclassed state
 Daniel Vetter:
 - Squash out-fence support into this commit
 Gustavo Padovan:
 - Don't signal fence directly from driver (and drop malidp_mw_job)

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/arm/Makefile      |    1 +
 drivers/gpu/drm/arm/malidp_crtc.c |   21 +++
 drivers/gpu/drm/arm/malidp_drv.c  |   25 +++-
 drivers/gpu/drm/arm/malidp_drv.h  |    3 +
 drivers/gpu/drm/arm/malidp_hw.c   |    7 +-
 drivers/gpu/drm/arm/malidp_mw.c   |  278 +++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/arm/malidp_mw.h   |   18 +++
 7 files changed, 348 insertions(+), 5 deletions(-)
 create mode 100644 drivers/gpu/drm/arm/malidp_mw.c
 create mode 100644 drivers/gpu/drm/arm/malidp_mw.h

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
index 08e6a71..5413a5a 100644
--- a/drivers/gpu/drm/arm/malidp_crtc.c
+++ b/drivers/gpu/drm/arm/malidp_crtc.c
@@ -68,6 +68,18 @@ static void malidp_crtc_enable(struct drm_crtc *crtc)
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
+	if (hwdev->disable_memwrite) {
+		DRM_DEV_DEBUG_DRIVER(crtc->dev->dev, "Disable memwrite\n");
+		hwdev->disable_memwrite(hwdev);
+	}
 	hwdev->leave_config_mode(hwdev);
 	drm_crtc_vblank_on(crtc);
 }
@@ -157,6 +169,15 @@ static int malidp_crtc_atomic_check(struct drm_crtc *crtc,
 		}
 	}
 
+	/* If only the writeback routing has changed, we don't need a modeset */
+	if (state->connectors_changed) {
+		u32 old_mask = crtc->state->connector_mask;
+		u32 new_mask = state->connector_mask;
+		if ((old_mask ^ new_mask) ==
+		    (1 << drm_connector_index(&malidp->mw_connector.base)))
+			state->connectors_changed = false;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index 32f746e..2d0465b 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -28,6 +28,7 @@
 #include <drm/drm_of.h>
 
 #include "malidp_drv.h"
+#include "malidp_mw.h"
 #include "malidp_regs.h"
 #include "malidp_hw.h"
 
@@ -92,6 +93,14 @@ static void malidp_atomic_commit_tail(struct drm_atomic_state *state)
 
 	drm_atomic_helper_commit_modeset_disables(drm, state);
 	drm_atomic_helper_commit_modeset_enables(drm, state);
+
+	/*
+	 * The order here is important. We must configure memory-write after
+	 * the CRTC is already enabled, so that its configuration update is
+	 * gated on the next CVAL.
+	 */
+	malidp_mw_atomic_commit(drm, state);
+
 	drm_atomic_helper_commit_planes(drm, state, 0);
 
 	malidp_atomic_commit_hw_done(state);
@@ -147,12 +156,20 @@ static int malidp_init(struct drm_device *drm)
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
index 9fc8a2e..8abfa8a 100644
--- a/drivers/gpu/drm/arm/malidp_drv.h
+++ b/drivers/gpu/drm/arm/malidp_drv.h
@@ -13,6 +13,7 @@
 #ifndef __MALIDP_DRV_H__
 #define __MALIDP_DRV_H__
 
+#include <drm/drm_writeback.h>
 #include <linux/mutex.h>
 #include <linux/wait.h>
 #include "malidp_hw.h"
@@ -22,6 +23,8 @@ struct malidp_drm {
 	struct drm_fbdev_cma *fbdev;
 	struct list_head event_list;
 	struct drm_crtc crtc;
+	struct drm_encoder mw_encoder;
+	struct drm_writeback_connector mw_connector;
 	wait_queue_head_t wq;
 	atomic_t config_valid;
 };
diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index be17631..1fee5ee 100644
--- a/drivers/gpu/drm/arm/malidp_hw.c
+++ b/drivers/gpu/drm/arm/malidp_hw.c
@@ -20,6 +20,7 @@
 
 #include "malidp_drv.h"
 #include "malidp_hw.h"
+#include "malidp_mw.h"
 
 static const struct malidp_format_id malidp500_de_formats[] = {
 	/*    fourcc,   layers supporting the format,     internal id  */
@@ -543,6 +544,7 @@ static int malidp650_query_hw(struct malidp_hw_device *hwdev)
 			.se_irq_map = {
 				.irq_mask = MALIDP550_SE_IRQ_EOW |
 					    MALIDP550_SE_IRQ_AXI_ERR,
+				.vsync_irq = MALIDP550_SE_IRQ_EOW,
 			},
 			.dc_irq_map = {
 				.irq_mask = MALIDP550_DC_IRQ_CONF_VALID |
@@ -684,6 +686,7 @@ static irqreturn_t malidp_se_irq(int irq, void *arg)
 	struct drm_device *drm = arg;
 	struct malidp_drm *malidp = drm->dev_private;
 	struct malidp_hw_device *hwdev = malidp->dev;
+	const struct malidp_irq_map *se = &hwdev->map.se_irq_map;
 	u32 status, mask;
 
 	status = malidp_hw_read(hwdev, hwdev->map.se_base + MALIDP_REG_STATUS);
@@ -693,7 +696,9 @@ static irqreturn_t malidp_se_irq(int irq, void *arg)
 	mask = malidp_hw_read(hwdev, hwdev->map.se_base + MALIDP_REG_MASKIRQ);
 	status = malidp_hw_read(hwdev, hwdev->map.se_base + MALIDP_REG_STATUS);
 	status &= mask;
-	/* ToDo: status decoding and firing up of VSYNC and page flip events */
+
+	if (status & se->vsync_irq)
+		drm_writeback_signal_completion(&malidp->mw_connector, 0);
 
 	malidp_hw_clear_irq(hwdev, MALIDP_SE_BLOCK, status);
 
diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
new file mode 100644
index 0000000..40f1137
--- /dev/null
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -0,0 +1,278 @@
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
+#include <drm/drm_atomic.h>
+#include <drm/drm_atomic_helper.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/drmP.h>
+#include <drm/drm_writeback.h>
+
+#include "malidp_drv.h"
+#include "malidp_hw.h"
+#include "malidp_mw.h"
+
+#define to_mw_state(_state) (struct malidp_mw_connector_state *)(_state)
+
+struct malidp_mw_connector_state {
+	struct drm_connector_state base;
+	dma_addr_t addrs[2];
+	s32 pitches[2];
+	u8 format;
+	u8 n_planes;
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
+static void malidp_mw_connector_reset(struct drm_connector *connector)
+{
+	struct malidp_mw_connector_state *mw_state =
+		kzalloc(sizeof(*mw_state), GFP_KERNEL);
+
+	if (connector->state)
+		__drm_atomic_helper_connector_destroy_state(connector->state);
+
+	kfree(connector->state);
+	__drm_atomic_helper_connector_reset(connector, &mw_state->base);
+}
+
+static enum drm_connector_status
+malidp_mw_connector_detect(struct drm_connector *connector, bool force)
+{
+	return connector_status_disconnected;
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
+	struct malidp_mw_connector_state *mw_state;
+
+	if (WARN_ON(!connector->state))
+		return NULL;
+
+	mw_state = kzalloc(sizeof(*mw_state), GFP_KERNEL);
+	if (!mw_state)
+		return NULL;
+
+	/* No need to preserve any of our driver-local data */
+	__drm_atomic_helper_connector_duplicate_state(connector, &mw_state->base);
+
+	return &mw_state->base;
+}
+
+static const struct drm_connector_funcs malidp_mw_connector_funcs = {
+	.dpms = drm_atomic_helper_connector_dpms,
+	.reset = malidp_mw_connector_reset,
+	.detect = malidp_mw_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = malidp_mw_connector_destroy,
+	.atomic_duplicate_state = malidp_mw_connector_duplicate_state,
+	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
+};
+
+static int
+malidp_mw_encoder_atomic_check(struct drm_encoder *encoder,
+			       struct drm_crtc_state *crtc_state,
+			       struct drm_connector_state *conn_state)
+{
+	struct malidp_mw_connector_state *mw_state = to_mw_state(conn_state);
+	struct malidp_drm *malidp = encoder->dev->dev_private;
+	struct drm_framebuffer *fb;
+	int i, n_planes;
+
+	if (!conn_state->writeback_job || !conn_state->writeback_job->fb)
+		return 0;
+
+	fb = conn_state->writeback_job->fb;
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
+		struct drm_format_name_buf format_name;
+
+		DRM_DEBUG_KMS("Invalid pixel format %s\n",
+			      drm_get_format_name(fb->pixel_format, &format_name));
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
+static u32 *get_writeback_formats(struct malidp_drm *malidp, int *n_formats)
+{
+	const struct malidp_hw_regmap *map = &malidp->dev->map;
+	u32 *formats;
+	int n, i;
+
+	formats = kcalloc(map->n_pixel_formats, sizeof(*formats),
+			  GFP_KERNEL);
+	if (!formats)
+		return NULL;
+
+	for (n = 0, i = 0;  i < map->n_pixel_formats; i++) {
+		if (map->pixel_formats[i].layer & SE_MEMWRITE)
+			formats[n++] = map->pixel_formats[i].format;
+	}
+
+	*n_formats = n;
+	return formats;
+}
+
+int malidp_mw_connector_init(struct drm_device *drm)
+{
+	struct malidp_drm *malidp = drm->dev_private;
+	u32 *formats;
+	int ret, n_formats;
+
+	if (!malidp->dev->enable_memwrite)
+		return 0;
+
+	drm_encoder_helper_add(&malidp->mw_encoder, &malidp_mw_encoder_helper_funcs);
+	malidp->mw_encoder.possible_crtcs = 1 << drm_crtc_index(&malidp->crtc);
+	ret = drm_encoder_init(drm, &malidp->mw_encoder, &malidp_mw_encoder_funcs,
+			       DRM_MODE_ENCODER_VIRTUAL, NULL);
+	if (ret)
+		return ret;
+
+	drm_connector_helper_add(&malidp->mw_connector.base,
+				 &malidp_mw_connector_helper_funcs);
+	malidp->mw_connector.base.interlace_allowed = 0;
+
+	formats = get_writeback_formats(malidp, &n_formats);
+	if (!formats) {
+		ret = -ENOMEM;
+		goto err_encoder;
+	}
+
+	ret = drm_writeback_connector_init(drm, &malidp->mw_connector,
+					   &malidp_mw_connector_funcs,
+					   formats, n_formats);
+	kfree(formats);
+	if (ret)
+		goto err_encoder;
+
+	ret = drm_mode_connector_attach_encoder(&malidp->mw_connector.base,
+						&malidp->mw_encoder);
+	if (ret)
+		goto err_connector;
+
+	return 0;
+
+err_connector:
+	drm_connector_cleanup(&malidp->mw_connector.base);
+err_encoder:
+	drm_encoder_cleanup(&malidp->mw_encoder);
+	return ret;
+}
+
+void malidp_mw_atomic_commit(struct drm_device *drm,
+			     struct drm_atomic_state *old_state)
+{
+	struct malidp_drm *malidp = drm->dev_private;
+	struct drm_writeback_connector *mw_conn = &malidp->mw_connector;
+	struct drm_connector_state *conn_state = mw_conn->base.state;
+	struct malidp_hw_device *hwdev = malidp->dev;
+	struct malidp_mw_connector_state *mw_state;
+
+	if (!conn_state)
+		return;
+
+	mw_state = to_mw_state(conn_state);
+
+	if (conn_state->writeback_job && conn_state->writeback_job->fb) {
+		struct drm_framebuffer *fb = conn_state->writeback_job->fb;
+
+		DRM_DEV_DEBUG_DRIVER(drm->dev,
+				     "Enable memwrite %ux%u:%d %pad fmt: %u\n",
+				     fb->width, fb->height,
+				     mw_state->pitches[0],
+				     &mw_state->addrs[0],
+				     mw_state->format);
+
+		drm_writeback_queue_job(mw_conn, conn_state->writeback_job);
+		conn_state->writeback_job = NULL;
+
+		hwdev->enable_memwrite(hwdev, mw_state->addrs,
+				       mw_state->pitches, mw_state->n_planes,
+				       fb->width, fb->height, mw_state->format);
+	} else {
+		DRM_DEV_DEBUG_DRIVER(drm->dev, "Disable memwrite\n");
+		hwdev->disable_memwrite(hwdev);
+	}
+}
diff --git a/drivers/gpu/drm/arm/malidp_mw.h b/drivers/gpu/drm/arm/malidp_mw.h
new file mode 100644
index 0000000..93477ea
--- /dev/null
+++ b/drivers/gpu/drm/arm/malidp_mw.h
@@ -0,0 +1,18 @@
+/*
+ * (C) COPYRIGHT 2016 ARM Limited. All rights reserved.
+ * Author: Brian Starkey <brian.starkey@arm.com>
+ *
+ * This program is free software and is provided to you under the terms of the
+ * GNU General Public License version 2 as published by the Free Software
+ * Foundation, and any use by you of this program is subject to the terms
+ * of such GNU licence.
+ *
+ */
+
+#ifndef __MALIDP_MW_H__
+#define __MALIDP_MW_H__
+
+int malidp_mw_connector_init(struct drm_device *drm);
+void malidp_mw_atomic_commit(struct drm_device *drm,
+			     struct drm_atomic_state *old_state);
+#endif
-- 
1.7.9.5

