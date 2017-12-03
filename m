Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53684 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbdLCK5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 05:57:42 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 6/9] v4l: vsp1: Extend the DU API to support CRC computation
Date: Sun,  3 Dec 2017 12:57:32 +0200
Message-Id: <20171203105735.10529-7-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a parameter (in the form of a structure to ease future API
extensions) to the VSP atomic flush handler to pass CRC source
configuration, and pass the CRC value to the completion callback.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  6 ++++--
 drivers/media/platform/vsp1/vsp1_drm.c |  6 ++++--
 drivers/media/platform/vsp1/vsp1_drm.h |  2 +-
 include/media/vsp1.h                   | 29 +++++++++++++++++++++++++++--
 4 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 2c260c33840b..bdcec201591f 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -31,7 +31,7 @@
 #include "rcar_du_kms.h"
 #include "rcar_du_vsp.h"
 
-static void rcar_du_vsp_complete(void *private, bool completed)
+static void rcar_du_vsp_complete(void *private, bool completed, u32 crc)
 {
 	struct rcar_du_crtc *crtc = private;
 
@@ -102,7 +102,9 @@ void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
 
 void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
 {
-	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe);
+	struct vsp1_du_atomic_pipe_config cfg = { { 0, } };
+
+	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
 }
 
 /* Keep the two tables in sync. */
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 0fe541084f5c..97d2be3b0023 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -38,7 +38,7 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
 	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
 
 	if (drm_pipe->du_complete)
-		drm_pipe->du_complete(drm_pipe->du_private, completed);
+		drm_pipe->du_complete(drm_pipe->du_private, completed, 0);
 }
 
 /* -----------------------------------------------------------------------------
@@ -505,8 +505,10 @@ static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
  * vsp1_du_atomic_flush - Commit an atomic update
  * @dev: the VSP device
  * @pipe_index: the DRM pipeline index
+ * @cfg: atomic pipe configuration
  */
-void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
+void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
+			  const struct vsp1_du_atomic_pipe_config *cfg)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index 1cd9db785bf7..c6515272da7d 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -29,7 +29,7 @@ struct vsp1_drm_pipeline {
 	bool enabled;
 
 	/* Frame synchronisation */
-	void (*du_complete)(void *, bool);
+	void (*du_complete)(void *data, bool completed, u32 crc);
 	void *du_private;
 };
 
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 7850f96fb708..89af1606ecb3 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -34,7 +34,7 @@ struct vsp1_du_lif_config {
 	unsigned int width;
 	unsigned int height;
 
-	void (*callback)(void *, bool);
+	void (*callback)(void *data, bool completed, u32 crc);
 	void *callback_data;
 };
 
@@ -61,11 +61,36 @@ struct vsp1_du_atomic_config {
 	unsigned int zpos;
 };
 
+/**
+ * enum vsp1_du_crc_source - Source used for CRC calculation
+ * @VSP1_DU_CRC_NONE: CRC calculation disabled
+ * @VSP_DU_CRC_PLANE: Perform CRC calculation on an input plane
+ * @VSP_DU_CRC_OUTPUT: Perform CRC calculation on the composed output
+ */
+enum vsp1_du_crc_source {
+	VSP1_DU_CRC_NONE,
+	VSP1_DU_CRC_PLANE,
+	VSP1_DU_CRC_OUTPUT,
+};
+
+/**
+ * struct vsp1_du_atomic_pipe_config - VSP atomic pipe configuration parameters
+ * @crc.source: source for CRC calculation
+ * @crc.index: index of the CRC source plane (when crc.source is set to plane)
+ */
+struct vsp1_du_atomic_pipe_config {
+	struct  {
+		enum vsp1_du_crc_source source;
+		unsigned int index;
+	} crc;
+};
+
 void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index);
 int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 			  unsigned int rpf,
 			  const struct vsp1_du_atomic_config *cfg);
-void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index);
+void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
+			  const struct vsp1_du_atomic_pipe_config *cfg);
 int vsp1_du_map_sg(struct device *dev, struct sg_table *sgt);
 void vsp1_du_unmap_sg(struct device *dev, struct sg_table *sgt);
 
-- 
Regards,

Laurent Pinchart
