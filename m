Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35030 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754732AbdCFOm3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 09:42:29 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Dave Airlie <airlied@redhat.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2] v4l: vsp1: Adapt vsp1_du_setup_lif() interface to use a structure
Date: Mon,  6 Mar 2017 16:43:01 +0200
Message-Id: <20170306144301.10626-1-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170303173054.13397-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170303173054.13397-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The interface to configure the LIF in the VSP1 requires adapting the
function prototype for any changes. This makes extending the interface
difficult.

Change the function prototype to pass a structure which can be easily
extended.

This changes the means of disabling the pipeline, by now passing a NULL
configuration rather than passing either a 0 width or height.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
[Fixed kerneldoc, made vsp1_du_setup_lif() cfg argument const]
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  8 ++++++--
 drivers/media/platform/vsp1/vsp1_drm.c | 33 ++++++++++++++++-----------------
 include/media/vsp1.h                   | 13 +++++++++++--
 3 files changed, 33 insertions(+), 21 deletions(-)

Changes since v1:

- Rebased on top of v4.11-rc1
- Added kerneldoc for the vsp1_du_lif_config structure

This patch unfortunately has to span two subsystems, and could thus be painful
to get merged during the v4.12 merge window due to the high risk of conflict
with other VSP1 and DUs driver patches.

Mauro, if that's fine with you, Dave has given me his Ack to get this merged
through your tree in v4.11-rc2 to ease the merge of all patches I have queued
for v4.12.

As it never hurts to say it, I've fully retested the patch by itself on top of
v4.11-rc1 without the rest of the series it was part of.

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 83ebd162f3ef..22da2d671297 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -32,6 +32,10 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
 {
 	const struct drm_display_mode *mode = &crtc->crtc.state->adjusted_mode;
 	struct rcar_du_device *rcdu = crtc->group->dev;
+	struct vsp1_du_lif_config cfg = {
+		.width = mode->hdisplay,
+		.height = mode->vdisplay,
+	};
 	struct rcar_du_plane_state state = {
 		.state = {
 			.crtc = &crtc->crtc,
@@ -66,12 +70,12 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
 	 */
 	crtc->group->need_restart = true;
 
-	vsp1_du_setup_lif(crtc->vsp->vsp, mode->hdisplay, mode->vdisplay);
+	vsp1_du_setup_lif(crtc->vsp->vsp, &cfg);
 }
 
 void rcar_du_vsp_disable(struct rcar_du_crtc *crtc)
 {
-	vsp1_du_setup_lif(crtc->vsp->vsp, 0, 0);
+	vsp1_du_setup_lif(crtc->vsp->vsp, NULL);
 }
 
 void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index b4b583f7137a..b4c0f10fc3b0 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -54,12 +54,11 @@ EXPORT_SYMBOL_GPL(vsp1_du_init);
 /**
  * vsp1_du_setup_lif - Setup the output part of the VSP pipeline
  * @dev: the VSP device
- * @width: output frame width in pixels
- * @height: output frame height in pixels
+ * @cfg: the LIF configuration
  *
- * Configure the output part of VSP DRM pipeline for the given frame @width and
- * @height. This sets up formats on the BRU source pad, the WPF0 sink and source
- * pads, and the LIF sink pad.
+ * Configure the output part of VSP DRM pipeline for the given frame @cfg.width
+ * and @cfg.height. This sets up formats on the BRU source pad, the WPF0 sink
+ * and source pads, and the LIF sink pad.
  *
  * As the media bus code on the BRU source pad is conditioned by the
  * configuration of the BRU sink 0 pad, we also set up the formats on all BRU
@@ -69,8 +68,7 @@ EXPORT_SYMBOL_GPL(vsp1_du_init);
  *
  * Return 0 on success or a negative error code on failure.
  */
-int vsp1_du_setup_lif(struct device *dev, unsigned int width,
-		      unsigned int height)
+int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
@@ -79,11 +77,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 	unsigned int i;
 	int ret;
 
-	dev_dbg(vsp1->dev, "%s: configuring LIF with format %ux%u\n",
-		__func__, width, height);
-
-	if (width == 0 || height == 0) {
-		/* Zero width or height means the CRTC is being disabled, stop
+	if (!cfg) {
+		/* NULL configuration means the CRTC is being disabled, stop
 		 * the pipeline and turn the light off.
 		 */
 		ret = vsp1_pipeline_stop(pipe);
@@ -108,6 +103,9 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		return 0;
 	}
 
+	dev_dbg(vsp1->dev, "%s: configuring LIF with format %ux%u\n",
+		__func__, cfg->width, cfg->height);
+
 	/* Configure the format at the BRU sinks and propagate it through the
 	 * pipeline.
 	 */
@@ -117,8 +115,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 	for (i = 0; i < bru->entity.source_pad; ++i) {
 		format.pad = i;
 
-		format.format.width = width;
-		format.format.height = height;
+		format.format.width = cfg->width;
+		format.format.height = cfg->height;
 		format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
 		format.format.field = V4L2_FIELD_NONE;
 
@@ -133,8 +131,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 	}
 
 	format.pad = bru->entity.source_pad;
-	format.format.width = width;
-	format.format.height = height;
+	format.format.width = cfg->width;
+	format.format.height = cfg->height;
 	format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
 	format.format.field = V4L2_FIELD_NONE;
 
@@ -180,7 +178,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 	/* Verify that the format at the output of the pipeline matches the
 	 * requested frame size and media bus code.
 	 */
-	if (format.format.width != width || format.format.height != height ||
+	if (format.format.width != cfg->width ||
+	    format.format.height != cfg->height ||
 	    format.format.code != MEDIA_BUS_FMT_ARGB8888_1X32) {
 		dev_dbg(vsp1->dev, "%s: format mismatch\n", __func__);
 		return -EPIPE;
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 458b400373d4..38aac554dbba 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -20,8 +20,17 @@ struct device;
 
 int vsp1_du_init(struct device *dev);
 
-int vsp1_du_setup_lif(struct device *dev, unsigned int width,
-		      unsigned int height);
+/**
+ * struct vsp1_du_lif_config - VSP LIF configuration
+ * @width: output frame width
+ * @height: output frame height
+ */
+struct vsp1_du_lif_config {
+	unsigned int width;
+	unsigned int height;
+};
+
+int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg);
 
 struct vsp1_du_atomic_config {
 	u32 pixelformat;
-- 
Regards,

Laurent Pinchart
