Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53685 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdLCK5p (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 05:57:45 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 9/9] drm: rcar-du: Add support for CRC computation
Date: Sun,  3 Dec 2017 12:57:35 +0200
Message-Id: <20171203105735.10529-10-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement CRC computation configuration and reporting through the DRM
debugfs-based CRC API. The CRC source can be configured to any input
plane or the pipeline output.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 148 +++++++++++++++++++++++++++++++--
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  19 +++++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |   7 ++
 3 files changed, 168 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 5685d5af6998..b65750096090 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -650,6 +650,52 @@ static const struct drm_crtc_helper_funcs crtc_helper_funcs = {
 	.atomic_disable = rcar_du_crtc_atomic_disable,
 };
 
+static struct drm_crtc_state *
+rcar_du_crtc_atomic_duplicate_state(struct drm_crtc *crtc)
+{
+	struct rcar_du_crtc_state *state;
+	struct rcar_du_crtc_state *copy;
+
+	if (WARN_ON(!crtc->state))
+		return NULL;
+
+	state = to_rcar_crtc_state(crtc->state);
+	copy = kmemdup(state, sizeof(*state), GFP_KERNEL);
+	if (copy == NULL)
+		return NULL;
+
+	__drm_atomic_helper_crtc_duplicate_state(crtc, &copy->state);
+
+	return &copy->state;
+}
+
+static void rcar_du_crtc_atomic_destroy_state(struct drm_crtc *crtc,
+					      struct drm_crtc_state *state)
+{
+	__drm_atomic_helper_crtc_destroy_state(state);
+	kfree(to_rcar_crtc_state(state));
+}
+
+static void rcar_du_crtc_reset(struct drm_crtc *crtc)
+{
+	struct rcar_du_crtc_state *state;
+
+	if (crtc->state) {
+		rcar_du_crtc_atomic_destroy_state(crtc, crtc->state);
+		crtc->state = NULL;
+	}
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (state == NULL)
+		return;
+
+	state->crc.source = VSP1_DU_CRC_NONE;
+	state->crc.index = 0;
+
+	crtc->state = &state->state;
+	crtc->state->crtc = crtc;
+}
+
 static int rcar_du_crtc_enable_vblank(struct drm_crtc *crtc)
 {
 	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
@@ -669,15 +715,103 @@ static void rcar_du_crtc_disable_vblank(struct drm_crtc *crtc)
 	rcrtc->vblank_enable = false;
 }
 
-static const struct drm_crtc_funcs crtc_funcs = {
-	.reset = drm_atomic_helper_crtc_reset,
+static int rcar_du_crtc_set_crc_source(struct drm_crtc *crtc,
+				       const char *source_name,
+				       size_t *values_cnt)
+{
+	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
+	struct drm_modeset_acquire_ctx ctx;
+	struct drm_crtc_state *crtc_state;
+	struct drm_atomic_state *state;
+	enum vsp1_du_crc_source source;
+	unsigned int index;
+	int ret;
+
+	/*
+	 * Parse the source name. Supported values are "plane%u" to compute the
+	 * CRC on an input plane (%u is the plane index), and "auto" to compute
+	 * the CRC on the composer (VSP) output.
+	 */
+	if (!source_name) {
+		source = VSP1_DU_CRC_NONE;
+	} else if (!strcmp(source_name, "auto")) {
+		source = VSP1_DU_CRC_OUTPUT;
+	} else if (strstarts(source_name, "plane")) {
+		source = VSP1_DU_CRC_PLANE;
+
+		ret = kstrtouint(source_name + strlen("plane"), 10, &index);
+		if (ret < 0)
+			return ret;
+
+		if (index >= rcrtc->vsp->num_planes)
+			return -EINVAL;
+	} else {
+		return -EINVAL;
+	}
+
+	*values_cnt = 1;
+
+	/* Perform an atomic commit to set the CRC source. */
+	drm_modeset_acquire_init(&ctx, 0);
+
+	state = drm_atomic_state_alloc(crtc->dev);
+	if (!state) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	state->acquire_ctx = &ctx;
+
+retry:
+	crtc_state = drm_atomic_get_crtc_state(state, crtc);
+	if (!IS_ERR(crtc_state)) {
+		struct rcar_du_crtc_state *rcrtc_state;
+
+		rcrtc_state = to_rcar_crtc_state(crtc_state);
+		rcrtc_state->crc.source = source;
+		rcrtc_state->crc.index = index;
+
+		ret = drm_atomic_commit(state);
+	} else {
+		ret = PTR_ERR(crtc_state);
+	}
+
+	if (ret == -EDEADLK) {
+		drm_atomic_state_clear(state);
+		drm_modeset_backoff(&ctx);
+		goto retry;
+	}
+
+	drm_atomic_state_put(state);
+
+unlock:
+	drm_modeset_drop_locks(&ctx);
+	drm_modeset_acquire_fini(&ctx);
+
+	return 0;
+}
+
+static const struct drm_crtc_funcs crtc_funcs_gen2 = {
+	.reset = rcar_du_crtc_reset,
+	.destroy = drm_crtc_cleanup,
+	.set_config = drm_atomic_helper_set_config,
+	.page_flip = drm_atomic_helper_page_flip,
+	.atomic_duplicate_state = rcar_du_crtc_atomic_duplicate_state,
+	.atomic_destroy_state = rcar_du_crtc_atomic_destroy_state,
+	.enable_vblank = rcar_du_crtc_enable_vblank,
+	.disable_vblank = rcar_du_crtc_disable_vblank,
+};
+
+static const struct drm_crtc_funcs crtc_funcs_gen3 = {
+	.reset = rcar_du_crtc_reset,
 	.destroy = drm_crtc_cleanup,
 	.set_config = drm_atomic_helper_set_config,
 	.page_flip = drm_atomic_helper_page_flip,
-	.atomic_duplicate_state = drm_atomic_helper_crtc_duplicate_state,
-	.atomic_destroy_state = drm_atomic_helper_crtc_destroy_state,
+	.atomic_duplicate_state = rcar_du_crtc_atomic_duplicate_state,
+	.atomic_destroy_state = rcar_du_crtc_atomic_destroy_state,
 	.enable_vblank = rcar_du_crtc_enable_vblank,
 	.disable_vblank = rcar_du_crtc_disable_vblank,
+	.set_crc_source = rcar_du_crtc_set_crc_source,
 };
 
 /* -----------------------------------------------------------------------------
@@ -780,8 +914,10 @@ int rcar_du_crtc_create(struct rcar_du_group *rgrp, unsigned int index)
 	else
 		primary = &rgrp->planes[index % 2].plane;
 
-	ret = drm_crtc_init_with_planes(rcdu->ddev, crtc, primary,
-					NULL, &crtc_funcs, NULL);
+	ret = drm_crtc_init_with_planes(rcdu->ddev, crtc, primary, NULL,
+					rcdu->info->gen <= 2 ?
+					&crtc_funcs_gen2 : &crtc_funcs_gen3,
+					NULL);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
index fdc2bf99bda1..518ee2c60eb8 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
@@ -21,6 +21,8 @@
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
 
+#include <media/vsp1.h>
+
 struct rcar_du_group;
 struct rcar_du_vsp;
 
@@ -69,6 +71,23 @@ struct rcar_du_crtc {
 
 #define to_rcar_crtc(c)	container_of(c, struct rcar_du_crtc, crtc)
 
+/**
+ * struct rcar_du_crtc_state - Driver-specific CRTC state
+ * @state: base DRM CRTC state
+ * @crc.source: source for CRC calculation
+ * @crc.index: index of the CRC source plane (when crc.source is set to plane)
+ */
+struct rcar_du_crtc_state {
+	struct drm_crtc_state state;
+
+	struct {
+		enum vsp1_du_crc_source source;
+		unsigned int index;
+	} crc;
+};
+
+#define to_rcar_crtc_state(s) container_of(s, struct rcar_du_crtc_state, state)
+
 enum rcar_du_output {
 	RCAR_DU_OUTPUT_DPAD0,
 	RCAR_DU_OUTPUT_DPAD1,
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index bdcec201591f..ce19b883ad16 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -40,6 +40,8 @@ static void rcar_du_vsp_complete(void *private, bool completed, u32 crc)
 
 	if (completed)
 		rcar_du_crtc_finish_page_flip(crtc);
+
+	drm_crtc_add_crc_entry(&crtc->crtc, false, 0, &crc);
 }
 
 void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
@@ -103,6 +105,11 @@ void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
 void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
 {
 	struct vsp1_du_atomic_pipe_config cfg = { { 0, } };
+	struct rcar_du_crtc_state *state;
+
+	state = to_rcar_crtc_state(crtc->crtc.state);
+	cfg.crc.source = state->crc.source;
+	cfg.crc.index = state->crc.index;
 
 	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
 }
-- 
Regards,

Laurent Pinchart
