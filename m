Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208EFC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB4CC217F5
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="D+BVEftB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfCMAGE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:06:04 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42062 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfCMAGE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:06:04 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 532429DB;
        Wed, 13 Mar 2019 01:05:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435556;
        bh=5Z3dpsejGTz8S+a8mM0R8dn4eid4C5zk9I3mQoIghr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+BVEftBOGHKQyz/KZwjjr7sMZvma4+QN8/v4Fs+DUJM6e85yUJvfuZB+iVNRn5xR
         nzSJGqIVXT0UOTLT5gkutdkUkkIBBwmkGrQ/qHbkJFoHfItRoBvNV7qXZPRWMA6qht
         SXOCQ6ZL20RERs10mmutWcxs8DnJjnwrG8H8s8Lw=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 18/18] drm: rcar-du: Add writeback support for R-Car Gen3
Date:   Wed, 13 Mar 2019 02:05:32 +0200
Message-Id: <20190313000532.7087-19-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Implement writeback support for R-Car Gen3 by exposing writeback
connectors. Behind the scene the calls are forwarded to the VSP
backend.

Using writeback connectors will allow implemented writeback support for
R-Car Gen2 with a consistent API if desired.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
Changes since v5:

- Skip writeback connector when configuring output routing
- Implement writeback connector atomic state operations
---
 drivers/gpu/drm/rcar-du/Kconfig             |   4 +
 drivers/gpu/drm/rcar-du/Makefile            |   3 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c      |   7 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h      |   7 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c       |  12 +
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c       |   5 +
 drivers/gpu/drm/rcar-du/rcar_du_writeback.c | 243 ++++++++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_writeback.h |  39 ++++
 8 files changed, 317 insertions(+), 3 deletions(-)
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_writeback.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_writeback.h

diff --git a/drivers/gpu/drm/rcar-du/Kconfig b/drivers/gpu/drm/rcar-du/Kconfig
index 7c36e2777a15..1529849e217e 100644
--- a/drivers/gpu/drm/rcar-du/Kconfig
+++ b/drivers/gpu/drm/rcar-du/Kconfig
@@ -36,3 +36,7 @@ config DRM_RCAR_VSP
 	depends on VIDEO_RENESAS_VSP1=y || (VIDEO_RENESAS_VSP1 && DRM_RCAR_DU=m)
 	help
 	  Enable support to expose the R-Car VSP Compositor as KMS planes.
+
+config DRM_RCAR_WRITEBACK
+	bool
+	default y if ARM64
diff --git a/drivers/gpu/drm/rcar-du/Makefile b/drivers/gpu/drm/rcar-du/Makefile
index 2a3b8d7972b5..6c2ed9c46467 100644
--- a/drivers/gpu/drm/rcar-du/Makefile
+++ b/drivers/gpu/drm/rcar-du/Makefile
@@ -4,7 +4,7 @@ rcar-du-drm-y := rcar_du_crtc.o \
 		 rcar_du_encoder.o \
 		 rcar_du_group.o \
 		 rcar_du_kms.o \
-		 rcar_du_plane.o
+		 rcar_du_plane.o \
 
 rcar-du-drm-$(CONFIG_DRM_RCAR_LVDS)	+= rcar_du_of.o \
 					   rcar_du_of_lvds_r8a7790.dtb.o \
@@ -13,6 +13,7 @@ rcar-du-drm-$(CONFIG_DRM_RCAR_LVDS)	+= rcar_du_of.o \
 					   rcar_du_of_lvds_r8a7795.dtb.o \
 					   rcar_du_of_lvds_r8a7796.dtb.o
 rcar-du-drm-$(CONFIG_DRM_RCAR_VSP)	+= rcar_du_vsp.o
+rcar-du-drm-$(CONFIG_DRM_RCAR_WRITEBACK) += rcar_du_writeback.o
 
 obj-$(CONFIG_DRM_RCAR_DU)		+= rcar-du-drm.o
 obj-$(CONFIG_DRM_RCAR_DW_HDMI)		+= rcar_dw_hdmi.o
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 96175d48a902..a95cf6bab4e0 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -645,8 +645,13 @@ static int rcar_du_crtc_atomic_check(struct drm_crtc *crtc,
 	rstate->outputs = 0;
 
 	drm_for_each_encoder_mask(encoder, crtc->dev, state->encoder_mask) {
-		struct rcar_du_encoder *renc = to_rcar_encoder(encoder);
+		struct rcar_du_encoder *renc;
 
+		/* Skip the writeback encoder. */
+		if (encoder->encoder_type == DRM_MODE_ENCODER_VIRTUAL)
+			continue;
+
+		renc = to_rcar_encoder(encoder);
 		rstate->outputs |= BIT(renc->output);
 	}
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
index c478953be092..92f7d5f3ff80 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
@@ -15,6 +15,7 @@
 #include <linux/wait.h>
 
 #include <drm/drm_crtc.h>
+#include <drm/drm_writeback.h>
 
 #include <media/vsp1.h>
 
@@ -39,6 +40,7 @@ struct rcar_du_vsp;
  * @group: CRTC group this CRTC belongs to
  * @vsp: VSP feeding video to this CRTC
  * @vsp_pipe: index of the VSP pipeline feeding video to this CRTC
+ * @writeback: the writeback connector
  */
 struct rcar_du_crtc {
 	struct drm_crtc crtc;
@@ -65,9 +67,12 @@ struct rcar_du_crtc {
 
 	const char *const *sources;
 	unsigned int sources_count;
+
+	struct drm_writeback_connector writeback;
 };
 
-#define to_rcar_crtc(c)	container_of(c, struct rcar_du_crtc, crtc)
+#define to_rcar_crtc(c)		container_of(c, struct rcar_du_crtc, crtc)
+#define wb_to_rcar_crtc(c)	container_of(c, struct rcar_du_crtc, writeback)
 
 /**
  * struct rcar_du_crtc_state - Driver-specific CRTC state
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index 999440c7b258..c729f048626e 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -24,6 +24,7 @@
 #include "rcar_du_kms.h"
 #include "rcar_du_regs.h"
 #include "rcar_du_vsp.h"
+#include "rcar_du_writeback.h"
 
 /* -----------------------------------------------------------------------------
  * Format helpers
@@ -662,6 +663,17 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu)
 		encoder->possible_clones = (1 << num_encoders) - 1;
 	}
 
+	/* Create the writeback connectors. */
+	if (rcdu->info->gen >= 3) {
+		for (i = 0; i < rcdu->num_crtcs; ++i) {
+			struct rcar_du_crtc *rcrtc = &rcdu->crtcs[i];
+
+			ret = rcar_du_writeback_init(rcdu, rcrtc);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
 	/*
 	 * Initialize the default DPAD0 source to the index of the first DU
 	 * channel that can be connected to DPAD0. The exact value doesn't
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 0806a69c4679..99ae03a1713a 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -25,6 +25,7 @@
 #include "rcar_du_drv.h"
 #include "rcar_du_kms.h"
 #include "rcar_du_vsp.h"
+#include "rcar_du_writeback.h"
 
 static void rcar_du_vsp_complete(void *private, unsigned int status, u32 crc)
 {
@@ -35,6 +36,8 @@ static void rcar_du_vsp_complete(void *private, unsigned int status, u32 crc)
 
 	if (status & VSP1_DU_STATUS_COMPLETE)
 		rcar_du_crtc_finish_page_flip(crtc);
+	if (status & VSP1_DU_STATUS_WRITEBACK)
+		rcar_du_writeback_complete(crtc);
 
 	drm_crtc_add_crc_entry(&crtc->crtc, false, 0, &crc);
 }
@@ -106,6 +109,8 @@ void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
 	state = to_rcar_crtc_state(crtc->crtc.state);
 	cfg.crc = state->crc;
 
+	rcar_du_writeback_atomic_flush(crtc, &cfg.writeback);
+
 	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
 }
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_writeback.c b/drivers/gpu/drm/rcar-du/rcar_du_writeback.c
new file mode 100644
index 000000000000..cfe18e69c1e7
--- /dev/null
+++ b/drivers/gpu/drm/rcar-du/rcar_du_writeback.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * rcar_du_writeback.c  --  R-Car Display Unit Writeback Support
+ *
+ * Copyright (C) 2019 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ */
+
+#include <drm/drm_atomic_helper.h>
+#include <drm/drm_device.h>
+#include <drm/drm_probe_helper.h>
+#include <drm/drm_writeback.h>
+
+#include "rcar_du_crtc.h"
+#include "rcar_du_drv.h"
+#include "rcar_du_kms.h"
+
+/**
+ * struct rcar_du_wb_conn_state - Driver-specific writeback connector state
+ * @state: base DRM connector state
+ * @format: format of the writeback framebuffer
+ */
+struct rcar_du_wb_conn_state {
+	struct drm_connector_state state;
+	const struct rcar_du_format_info *format;
+};
+
+
+#define to_rcar_wb_conn_state(s) \
+	container_of(s, struct rcar_du_wb_conn_state, state)
+
+/**
+ * struct rcar_du_wb_job - Driver-private data for writeback jobs
+ * @sg_tables: scatter-gather tables for the framebuffer memory
+ */
+struct rcar_du_wb_job {
+	struct sg_table sg_tables[3];
+};
+
+static int rcar_du_wb_conn_get_modes(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+
+	return drm_add_modes_noedid(connector, dev->mode_config.max_width,
+				    dev->mode_config.max_height);
+}
+
+static int rcar_du_wb_prepare_job(struct drm_writeback_connector *connector,
+				  struct drm_writeback_job *job)
+{
+	struct rcar_du_crtc *rcrtc = wb_to_rcar_crtc(connector);
+	struct rcar_du_wb_job *rjob;
+	int ret;
+
+	if (!job->fb)
+		return 0;
+
+	rjob = kzalloc(sizeof(*rjob), GFP_KERNEL);
+	if (!rjob)
+		return -ENOMEM;
+
+	/* Map the framebuffer to the VSP. */
+	ret = rcar_du_vsp_map_fb(rcrtc->vsp, job->fb, rjob->sg_tables);
+	if (ret < 0) {
+		kfree(rjob);
+		return ret;
+	}
+
+	job->priv = rjob;
+	return 0;
+}
+
+static void rcar_du_wb_cleanup_job(struct drm_writeback_connector *connector,
+				   struct drm_writeback_job *job)
+{
+	struct rcar_du_crtc *rcrtc = wb_to_rcar_crtc(connector);
+	struct rcar_du_wb_job *rjob = job->priv;
+
+	if (!job->fb)
+		return;
+
+	rcar_du_vsp_unmap_fb(rcrtc->vsp, job->fb, rjob->sg_tables);
+	kfree(rjob);
+}
+
+static const struct drm_connector_helper_funcs rcar_du_wb_conn_helper_funcs = {
+	.get_modes = rcar_du_wb_conn_get_modes,
+	.prepare_writeback_job = rcar_du_wb_prepare_job,
+	.cleanup_writeback_job = rcar_du_wb_cleanup_job,
+};
+
+static struct drm_connector_state *
+rcar_du_wb_conn_duplicate_state(struct drm_connector *connector)
+{
+	struct rcar_du_wb_conn_state *copy;
+
+	if (WARN_ON(!connector->state))
+		return NULL;
+
+	copy = kzalloc(sizeof(*copy), GFP_KERNEL);
+	if (!copy)
+		return NULL;
+
+	__drm_atomic_helper_connector_duplicate_state(connector, &copy->state);
+
+	return &copy->state;
+}
+
+static void rcar_du_wb_conn_destroy_state(struct drm_connector *connector,
+					  struct drm_connector_state *state)
+{
+	__drm_atomic_helper_connector_destroy_state(state);
+	kfree(to_rcar_wb_conn_state(state));
+}
+
+static void rcar_du_wb_conn_reset(struct drm_connector *connector)
+{
+	struct rcar_du_wb_conn_state *state;
+
+	if (connector->state) {
+		rcar_du_wb_conn_destroy_state(connector, connector->state);
+		connector->state = NULL;
+	}
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (state == NULL)
+		return;
+
+	__drm_atomic_helper_connector_reset(connector, &state->state);
+}
+
+static const struct drm_connector_funcs rcar_du_wb_conn_funcs = {
+	.reset = rcar_du_wb_conn_reset,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = drm_connector_cleanup,
+	.atomic_duplicate_state = rcar_du_wb_conn_duplicate_state,
+	.atomic_destroy_state = rcar_du_wb_conn_destroy_state,
+};
+
+static int rcar_du_wb_enc_atomic_check(struct drm_encoder *encoder,
+				       struct drm_crtc_state *crtc_state,
+				       struct drm_connector_state *conn_state)
+{
+	struct rcar_du_wb_conn_state *wb_state =
+		to_rcar_wb_conn_state(conn_state);
+	const struct drm_display_mode *mode = &crtc_state->mode;
+	struct drm_device *dev = encoder->dev;
+	struct drm_framebuffer *fb;
+
+	if (!conn_state->writeback_job || !conn_state->writeback_job->fb)
+		return 0;
+
+	fb = conn_state->writeback_job->fb;
+
+	/*
+	 * Verify that the framebuffer format is supported and that its size
+	 * matches the current mode.
+	 */
+	if (fb->width != mode->hdisplay || fb->height != mode->vdisplay) {
+		dev_dbg(dev->dev, "%s: invalid framebuffer size %ux%u\n",
+			__func__, fb->width, fb->height);
+		return -EINVAL;
+	}
+
+	wb_state->format = rcar_du_format_info(fb->format->format);
+	if (wb_state->format == NULL) {
+		dev_dbg(dev->dev, "%s: unsupported format %08x\n", __func__,
+			fb->format->format);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct drm_encoder_helper_funcs rcar_du_wb_enc_helper_funcs = {
+	.atomic_check = rcar_du_wb_enc_atomic_check,
+};
+
+/*
+ * Only RGB formats are currently supported as the VSP outputs RGB to the DU
+ * and can't convert to YUV separately for writeback.
+ */
+static const u32 writeback_formats[] = {
+	DRM_FORMAT_RGB332,
+	DRM_FORMAT_ARGB4444,
+	DRM_FORMAT_XRGB4444,
+	DRM_FORMAT_ARGB1555,
+	DRM_FORMAT_XRGB1555,
+	DRM_FORMAT_RGB565,
+	DRM_FORMAT_BGR888,
+	DRM_FORMAT_RGB888,
+	DRM_FORMAT_BGRA8888,
+	DRM_FORMAT_BGRX8888,
+	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_XRGB8888,
+};
+
+int rcar_du_writeback_init(struct rcar_du_device *rcdu,
+			   struct rcar_du_crtc *rcrtc)
+{
+	struct drm_writeback_connector *wb_conn = &rcrtc->writeback;
+
+	wb_conn->encoder.possible_crtcs = 1 << drm_crtc_index(&rcrtc->crtc);
+	drm_connector_helper_add(&wb_conn->base,
+				 &rcar_du_wb_conn_helper_funcs);
+
+	return drm_writeback_connector_init(rcdu->ddev, wb_conn,
+					    &rcar_du_wb_conn_funcs,
+					    &rcar_du_wb_enc_helper_funcs,
+					    writeback_formats,
+					    ARRAY_SIZE(writeback_formats));
+}
+
+void rcar_du_writeback_atomic_flush(struct rcar_du_crtc *rcrtc,
+				    struct vsp1_du_writeback_config *cfg)
+{
+	struct rcar_du_wb_conn_state *wb_state;
+	struct drm_connector_state *state;
+	struct rcar_du_wb_job *rjob;
+	struct drm_framebuffer *fb;
+	unsigned int i;
+
+	state = rcrtc->writeback.base.state;
+	if (!state || !state->writeback_job || !state->writeback_job->fb)
+		return;
+
+	fb = state->writeback_job->fb;
+	rjob = state->writeback_job->priv;
+	wb_state = to_rcar_wb_conn_state(state);
+
+	cfg->pixelformat = wb_state->format->v4l2;
+	cfg->pitch = fb->pitches[0];
+
+	for (i = 0; i < wb_state->format->planes; ++i)
+		cfg->mem[i] = sg_dma_address(rjob->sg_tables[i].sgl)
+			    + fb->offsets[i];
+
+	drm_writeback_queue_job(&rcrtc->writeback, state);
+}
+
+void rcar_du_writeback_complete(struct rcar_du_crtc *rcrtc)
+{
+	drm_writeback_signal_completion(&rcrtc->writeback, 0);
+}
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_writeback.h b/drivers/gpu/drm/rcar-du/rcar_du_writeback.h
new file mode 100644
index 000000000000..d57c5a0bffe3
--- /dev/null
+++ b/drivers/gpu/drm/rcar-du/rcar_du_writeback.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * rcar_du_writeback.h  --  R-Car Display Unit Writeback Support
+ *
+ * Copyright (C) 2019 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ */
+
+#ifndef __RCAR_DU_WRITEBACK_H__
+#define __RCAR_DU_WRITEBACK_H__
+
+#include <drm/drm_plane.h>
+
+struct rcar_du_crtc;
+struct rcar_du_device;
+struct vsp1_du_atomic_pipe_config;
+
+#ifdef CONFIG_DRM_RCAR_WRITEBACK
+int rcar_du_writeback_init(struct rcar_du_device *rcdu,
+			   struct rcar_du_crtc *rcrtc);
+void rcar_du_writeback_atomic_flush(struct rcar_du_crtc *rcrtc,
+				    struct vsp1_du_writeback_config *cfg);
+void rcar_du_writeback_complete(struct rcar_du_crtc *rcrtc);
+#else
+static inline int rcar_du_writeback_init(struct rcar_du_device *rcdu,
+					 struct rcar_du_crtc *rcrtc)
+{
+	return -ENXIO;
+}
+static inline void
+rcar_du_writeback_atomic_flush(struct rcar_du_crtc *rcrtc,
+			       struct vsp1_du_writeback_config *cfg)
+{
+}
+static inline void rcar_du_writeback_complete(struct rcar_du_crtc *rcrtc)
+{
+}
+#endif
+
+#endif /* __RCAR_DU_WRITEBACK_H__ */
-- 
Regards,

Laurent Pinchart

