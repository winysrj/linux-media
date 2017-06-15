Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35689 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdFOIX4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 04:23:56 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH 4/6] v4l: vsp1: Add pipe index argument to the VSP-DU API
Date: Thu, 15 Jun 2017 11:24:07 +0300
Message-Id: <20170615082409.9523-5-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the H3 ES2.0 SoC the VSP2-DL instance has two connections to DU
channels that need to be configured independently. Extend the VSP-DU API
with a pipeline index to identify which pipeline the caller wants to
operate on.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  9 +++++----
 drivers/media/platform/vsp1/vsp1_drm.c | 28 +++++++++++++++++++---------
 include/media/vsp1.h                   |  8 +++++---
 3 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index b0ff304ce3dc..1b62b58f11ee 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -70,22 +70,22 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
 	 */
 	crtc->group->need_restart = true;
 
-	vsp1_du_setup_lif(crtc->vsp->vsp, &cfg);
+	vsp1_du_setup_lif(crtc->vsp->vsp, 0, &cfg);
 }
 
 void rcar_du_vsp_disable(struct rcar_du_crtc *crtc)
 {
-	vsp1_du_setup_lif(crtc->vsp->vsp, NULL);
+	vsp1_du_setup_lif(crtc->vsp->vsp, 0, NULL);
 }
 
 void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
 {
-	vsp1_du_atomic_begin(crtc->vsp->vsp);
+	vsp1_du_atomic_begin(crtc->vsp->vsp, 0);
 }
 
 void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
 {
-	vsp1_du_atomic_flush(crtc->vsp->vsp);
+	vsp1_du_atomic_flush(crtc->vsp->vsp, 0);
 }
 
 /* Keep the two tables in sync. */
@@ -153,6 +153,7 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 		to_rcar_vsp_plane_state(plane->plane.state);
 	struct drm_framebuffer *fb = plane->plane.state->fb;
 	struct vsp1_du_atomic_config cfg = {
+		.pipe = 0,
 		.pixelformat = 0,
 		.pitch = fb->pitches[0],
 		.alpha = state->alpha,
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 9d235e830f5a..7699fa787b80 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -54,21 +54,26 @@ EXPORT_SYMBOL_GPL(vsp1_du_init);
 /**
  * vsp1_du_setup_lif - Setup the output part of the VSP pipeline
  * @dev: the VSP device
+ * @pipe_index: the DRM pipeline index
  * @cfg: the LIF configuration
  *
  * Configure the output part of VSP DRM pipeline for the given frame @cfg.width
- * and @cfg.height. This sets up formats on the BRU source pad, the WPF0 sink
- * and source pads, and the LIF sink pad.
+ * and @cfg.height. This sets up formats on the blend unit (BRU or BRS) source
+ * pad, the WPF sink and source pads, and the LIF sink pad.
  *
- * As the media bus code on the BRU source pad is conditioned by the
- * configuration of the BRU sink 0 pad, we also set up the formats on all BRU
+ * The @pipe_index argument selects which DRM pipeline to setup. The number of
+ * available pipelines depend on the VSP instance.
+ *
+ * As the media bus code on the blend unit source pad is conditioned by the
+ * configuration of its sink 0 pad, we also set up the formats on all blend unit
  * sinks, even if the configuration will be overwritten later by
- * vsp1_du_setup_rpf(). This ensures that the BRU configuration is set to a well
- * defined state.
+ * vsp1_du_setup_rpf(). This ensures that the blend unit configuration is set to
+ * a well defined state.
  *
  * Return 0 on success or a negative error code on failure.
  */
-int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg)
+int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
+		      const struct vsp1_du_lif_config *cfg)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
@@ -77,6 +82,9 @@ int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg)
 	unsigned int i;
 	int ret;
 
+	if (pipe_index > 0)
+		return -EINVAL;
+
 	if (!cfg) {
 		/*
 		 * NULL configuration means the CRTC is being disabled, stop
@@ -216,8 +224,9 @@ EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
 /**
  * vsp1_du_atomic_begin - Prepare for an atomic update
  * @dev: the VSP device
+ * @pipe_index: the DRM pipeline index
  */
-void vsp1_du_atomic_begin(struct device *dev)
+void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
@@ -421,8 +430,9 @@ static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
 /**
  * vsp1_du_atomic_flush - Commit an atomic update
  * @dev: the VSP device
+ * @pipe_index: the DRM pipeline index
  */
-void vsp1_du_atomic_flush(struct device *dev)
+void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 38aac554dbba..6db4ae0e7c55 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -30,9 +30,11 @@ struct vsp1_du_lif_config {
 	unsigned int height;
 };
 
-int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg);
+int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
+		      const struct vsp1_du_lif_config *cfg);
 
 struct vsp1_du_atomic_config {
+	unsigned int pipe;
 	u32 pixelformat;
 	unsigned int pitch;
 	dma_addr_t mem[3];
@@ -42,9 +44,9 @@ struct vsp1_du_atomic_config {
 	unsigned int zpos;
 };
 
-void vsp1_du_atomic_begin(struct device *dev);
+void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index);
 int vsp1_du_atomic_update(struct device *dev, unsigned int rpf,
 			  const struct vsp1_du_atomic_config *cfg);
-void vsp1_du_atomic_flush(struct device *dev);
+void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index);
 
 #endif /* __MEDIA_VSP1_H__ */
-- 
Regards,

Laurent Pinchart
