Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:34292 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754022AbcJZI4I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 04:56:08 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFC PATCH v2 6/9] drm: mali-dp: Add writeback connector
Date: Wed, 26 Oct 2016 09:55:05 +0100
Message-Id: <1477472108-27222-7-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mali-DP has a memory writeback engine which can be used to write the
composition result to a memory buffer.
Expose this functionality as a DRM writeback connector on supported
hardware.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/arm/Makefile      |    1 +
 drivers/gpu/drm/arm/malidp_crtc.c |   21 +++
 drivers/gpu/drm/arm/malidp_drv.c  |   28 +++-
 drivers/gpu/drm/arm/malidp_drv.h  |    7 +
 drivers/gpu/drm/arm/malidp_hw.c   |   40 ++++-
 drivers/gpu/drm/arm/malidp_mw.c   |  297 +++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/arm/malidp_mw.h   |   25 ++++
 7 files changed, 413 insertions(+), 6 deletions(-)
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
index 08e6a71..aadc223 100644
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
+		    (1 << drm_connector_index(&malidp->mw_connector)))
+			state->connectors_changed = false;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index f63a4df..cdefbab 100644
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
@@ -357,6 +374,9 @@ static int malidp_bind(struct device *dev)
 	atomic_set(&malidp->config_valid, 0);
 	init_waitqueue_head(&malidp->wq);
 
+	INIT_LIST_HEAD(&malidp->finished_mw_jobs);
+	spin_lock_init(&malidp->mw_lock);
+
 	ret = malidp_init(drm);
 	if (ret < 0)
 		goto init_fail;
diff --git a/drivers/gpu/drm/arm/malidp_drv.h b/drivers/gpu/drm/arm/malidp_drv.h
index 9fc8a2e..0dce0cf 100644
--- a/drivers/gpu/drm/arm/malidp_drv.h
+++ b/drivers/gpu/drm/arm/malidp_drv.h
@@ -22,8 +22,15 @@ struct malidp_drm {
 	struct drm_fbdev_cma *fbdev;
 	struct list_head event_list;
 	struct drm_crtc crtc;
+	struct drm_encoder mw_encoder;
+	struct drm_connector mw_connector;
 	wait_queue_head_t wq;
 	atomic_t config_valid;
+
+	struct malidp_mw_job *current_mw;
+	/* lock for protecting the finished_mw_jobs list */
+	spinlock_t mw_lock;
+	struct list_head finished_mw_jobs;
 };
 
 #define crtc_to_malidp_device(x) container_of(x, struct malidp_drm, crtc)
diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index 5004988..1689547 100644
--- a/drivers/gpu/drm/arm/malidp_hw.c
+++ b/drivers/gpu/drm/arm/malidp_hw.c
@@ -20,6 +20,7 @@
 
 #include "malidp_drv.h"
 #include "malidp_hw.h"
+#include "malidp_mw.h"
 
 static const struct malidp_format_id malidp500_de_formats[] = {
 	/*    fourcc,   layers supporting the format,     internal id  */
@@ -548,6 +549,7 @@ const struct malidp_hw_device malidp_device[MALIDP_MAX_DEVICES] = {
 			.se_irq_map = {
 				.irq_mask = MALIDP550_SE_IRQ_EOW |
 					    MALIDP550_SE_IRQ_AXI_ERR,
+				.vsync_irq = MALIDP550_SE_IRQ_EOW,
 			},
 			.dc_irq_map = {
 				.irq_mask = MALIDP550_DC_IRQ_CONF_VALID |
@@ -689,7 +691,9 @@ static irqreturn_t malidp_se_irq(int irq, void *arg)
 	struct drm_device *drm = arg;
 	struct malidp_drm *malidp = drm->dev_private;
 	struct malidp_hw_device *hwdev = malidp->dev;
+	const struct malidp_irq_map *se = &hwdev->map.se_irq_map;
 	u32 status, mask;
+	irqreturn_t ret = IRQ_HANDLED;
 
 	status = malidp_hw_read(hwdev, hwdev->map.se_base + MALIDP_REG_STATUS);
 	if (!(status & hwdev->map.se_irq_map.irq_mask))
@@ -698,15 +702,47 @@ static irqreturn_t malidp_se_irq(int irq, void *arg)
 	mask = malidp_hw_read(hwdev, hwdev->map.se_base + MALIDP_REG_MASKIRQ);
 	status = malidp_hw_read(hwdev, hwdev->map.se_base + MALIDP_REG_STATUS);
 	status &= mask;
-	/* ToDo: status decoding and firing up of VSYNC and page flip events */
+
+	if (status & se->vsync_irq) {
+		unsigned long irqflags;
+		/*
+		 * We can't unreference the framebuffer here, so we queue it
+		 * up on our threaded handler.
+		 */
+		spin_lock_irqsave(&malidp->mw_lock, irqflags);
+		list_add_tail(&malidp->current_mw->list,
+			      &malidp->finished_mw_jobs);
+		malidp->current_mw = NULL;
+		spin_unlock_irqrestore(&malidp->mw_lock, irqflags);
+
+		ret = IRQ_WAKE_THREAD;
+	}
 
 	malidp_hw_clear_irq(hwdev, MALIDP_SE_BLOCK, status);
 
-	return IRQ_HANDLED;
+	return ret;
 }
 
 static irqreturn_t malidp_se_irq_thread_handler(int irq, void *arg)
 {
+	struct drm_device *drm = arg;
+	struct malidp_drm *malidp = drm->dev_private;
+	struct list_head finished;
+	struct malidp_mw_job *tmp, *pos;
+	unsigned long irqflags;
+
+	INIT_LIST_HEAD(&finished);
+
+	spin_lock_irqsave(&malidp->mw_lock, irqflags);
+	list_splice_tail_init(&malidp->finished_mw_jobs,
+			      &finished);
+	spin_unlock_irqrestore(&malidp->mw_lock, irqflags);
+
+	list_for_each_entry_safe(pos, tmp, &finished, list) {
+		list_del(&pos->list);
+		malidp_mw_job_cleanup(drm, pos);
+	}
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
new file mode 100644
index 0000000..69e423c
--- /dev/null
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -0,0 +1,297 @@
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
+#define mw_conn_to_malidp_device(x) container_of(x, struct malidp_drm, mw_connector)
+#define to_mw_state(_state) (struct malidp_mw_connector_state *)(_state)
+
+struct malidp_mw_connector_state {
+	struct drm_connector_state base;
+	struct malidp_mw_job *job;
+	dma_addr_t addrs[2];
+	s32 pitches[2];
+	u8 format;
+	u8 n_planes;
+};
+
+void malidp_mw_job_cleanup(struct drm_device *drm,
+				  struct malidp_mw_job *job)
+{
+	DRM_DEV_DEBUG_DRIVER(drm->dev, "MW job cleanup %p\n", job);
+	drm_framebuffer_unreference(job->fb);
+	kfree(job);
+}
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
+static void malidp_mw_connector_destroy_state(struct drm_connector *connector,
+					      struct drm_connector_state *state)
+{
+	struct malidp_mw_connector_state *mw_state = to_mw_state(state);
+
+	__drm_atomic_helper_connector_destroy_state(&mw_state->base);
+	if (mw_state->job)
+		malidp_mw_job_cleanup(connector->dev, mw_state->job);
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
+	mw_state->job = kmalloc(sizeof(*mw_state->job), GFP_KERNEL);
+	if (!mw_state->job)
+		return -ENOMEM;
+
+	DRM_DEV_DEBUG_DRIVER(conn->dev->dev, "MW job create %p\n",
+			     mw_state->job);
+	/* We can take ownership of the framebuffer reference in the job. */
+	mw_state->job->fb = conn_state->fb;
+	conn_state->fb = NULL;
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
+	drm_connector_helper_add(&malidp->mw_connector,
+				 &malidp_mw_connector_helper_funcs);
+	malidp->mw_connector.interlace_allowed = 0;
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
+	ret = drm_mode_connector_attach_encoder(&malidp->mw_connector,
+						&malidp->mw_encoder);
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
+
+	mw_state = to_mw_state(mw_conn->state);
+
+	if (!mw_state)
+		return;
+
+	if (mw_state->job) {
+		struct drm_framebuffer *fb = mw_state->job->fb;
+		DRM_DEV_DEBUG_DRIVER(drm->dev, "Enable memwrite %ux%u:%d %pad fmt: %u\n",
+				     fb->width, fb->height, mw_state->pitches[0],
+				     &mw_state->addrs[0], mw_state->format);
+
+		/* Queue up the job for completion handling */
+		DRM_DEV_DEBUG_DRIVER(drm->dev, "MW job queue %p\n", mw_state->job);
+
+		WARN_ON(malidp->current_mw);
+		malidp->current_mw = mw_state->job;
+		mw_state->job = NULL;
+
+		hwdev->enable_memwrite(hwdev, mw_state->addrs, mw_state->pitches,
+				       mw_state->n_planes, fb->width, fb->height,
+				       mw_state->format);
+	} else {
+		DRM_DEV_DEBUG_DRIVER(drm->dev, "Disable memwrite\n");
+		hwdev->disable_memwrite(hwdev);
+	}
+}
diff --git a/drivers/gpu/drm/arm/malidp_mw.h b/drivers/gpu/drm/arm/malidp_mw.h
new file mode 100644
index 0000000..db7b2b0
--- /dev/null
+++ b/drivers/gpu/drm/arm/malidp_mw.h
@@ -0,0 +1,25 @@
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
+struct malidp_mw_job {
+	struct list_head list;
+	struct drm_framebuffer *fb;
+};
+
+int malidp_mw_connector_init(struct drm_device *drm);
+void malidp_mw_atomic_commit(struct drm_device *drm,
+			     struct drm_atomic_state *old_state);
+void malidp_mw_job_cleanup(struct drm_device *drm,
+				  struct malidp_mw_job *job);
+#endif
-- 
1.7.9.5

