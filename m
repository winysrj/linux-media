Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934745AbdEVOTd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 10:19:33 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com
Subject: [PATCH v3 5/5] drm: rcar-du: Map memory through the VSP device
Date: Mon, 22 May 2017 15:19:22 +0100
Message-Id: <53c58c67d65aae3070966cd408d4f141ee66f786.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

For planes handled by a VSP instance, map the framebuffer memory through
the VSP to ensure proper IOMMU handling.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
[Kieran: Fix infinite loop on fail]
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 74 +++++++++++++++++++++++++---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h |  2 +-
 2 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index b0ff304ce3dc..7f8b03fc2b69 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -19,7 +19,9 @@
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_plane_helper.h>
 
+#include <linux/dma-mapping.h>
 #include <linux/of_platform.h>
+#include <linux/scatterlist.h>
 #include <linux/videodev2.h>
 
 #include <media/vsp1.h>
@@ -170,12 +172,9 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 	cfg.dst.width = state->state.crtc_w;
 	cfg.dst.height = state->state.crtc_h;
 
-	for (i = 0; i < state->format->planes; ++i) {
-		struct drm_gem_cma_object *gem;
-
-		gem = drm_fb_cma_get_gem_obj(fb, i);
-		cfg.mem[i] = gem->paddr + fb->offsets[i];
-	}
+	for (i = 0; i < state->format->planes; ++i)
+		cfg.mem[i] = sg_dma_address(state->sg_tables[i].sgl)
+			   + fb->offsets[i];
 
 	for (i = 0; i < ARRAY_SIZE(formats_kms); ++i) {
 		if (formats_kms[i] == state->format->fourcc) {
@@ -187,6 +186,67 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 	vsp1_du_atomic_update(plane->vsp->vsp, plane->index, &cfg);
 }
 
+static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
+					struct drm_plane_state *state)
+{
+	struct rcar_du_vsp_plane_state *rstate = to_rcar_vsp_plane_state(state);
+	struct rcar_du_vsp *vsp = to_rcar_vsp_plane(plane)->vsp;
+	struct rcar_du_device *rcdu = vsp->dev;
+	unsigned int i;
+	int ret;
+
+	if (!state->fb)
+		return 0;
+
+	for (i = 0; i < rstate->format->planes; ++i) {
+		struct drm_gem_cma_object *gem =
+			drm_fb_cma_get_gem_obj(state->fb, i);
+		struct sg_table *sgt = &rstate->sg_tables[i];
+
+		ret = dma_get_sgtable(rcdu->dev, sgt, gem->vaddr, gem->paddr,
+				      gem->base.size);
+		if (ret)
+			goto fail;
+
+		ret = vsp1_du_map_sg(vsp->vsp, sgt);
+		if (!ret) {
+			sg_free_table(sgt);
+			ret = -ENOMEM;
+			goto fail;
+		}
+	}
+
+	return 0;
+
+fail:
+	while (i--) {
+		struct sg_table *sgt = &rstate->sg_tables[i];
+
+		vsp1_du_unmap_sg(vsp->vsp, sgt);
+		sg_free_table(sgt);
+	}
+
+	return ret;
+}
+
+static void rcar_du_vsp_plane_cleanup_fb(struct drm_plane *plane,
+					 struct drm_plane_state *state)
+{
+	struct rcar_du_vsp_plane_state *rstate = to_rcar_vsp_plane_state(state);
+	struct rcar_du_vsp *vsp = to_rcar_vsp_plane(plane)->vsp;
+	unsigned int i;
+
+	if (!state->fb)
+		return;
+
+	for (i = 0; i < rstate->format->planes; ++i) {
+		struct sg_table *sgt = &rstate->sg_tables[i];
+
+		vsp1_du_unmap_sg(vsp->vsp, sgt);
+		sg_free_table(sgt);
+	}
+}
+
 static int rcar_du_vsp_plane_atomic_check(struct drm_plane *plane,
 					  struct drm_plane_state *state)
 {
@@ -227,6 +287,8 @@ static void rcar_du_vsp_plane_atomic_update(struct drm_plane *plane,
 }
 
 static const struct drm_plane_helper_funcs rcar_du_vsp_plane_helper_funcs = {
+	.prepare_fb = rcar_du_vsp_plane_prepare_fb,
+	.cleanup_fb = rcar_du_vsp_plane_cleanup_fb,
 	.atomic_check = rcar_du_vsp_plane_atomic_check,
 	.atomic_update = rcar_du_vsp_plane_atomic_update,
 };
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
index f1d0f1824528..8861661590ff 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
@@ -43,6 +43,7 @@ static inline struct rcar_du_vsp_plane *to_rcar_vsp_plane(struct drm_plane *p)
  * struct rcar_du_vsp_plane_state - Driver-specific plane state
  * @state: base DRM plane state
  * @format: information about the pixel format used by the plane
+ * @sg_tables: scatter-gather tables for the frame buffer memory
  * @alpha: value of the plane alpha property
  * @zpos: value of the plane zpos property
  */
@@ -50,6 +51,7 @@ struct rcar_du_vsp_plane_state {
 	struct drm_plane_state state;
 
 	const struct rcar_du_format_info *format;
+	struct sg_table sg_tables[3];
 
 	unsigned int alpha;
 	unsigned int zpos;
-- 
git-series 0.9.1
