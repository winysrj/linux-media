Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54480 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbeD1UuV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 16:50:21 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@gmail.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v3 5/8] v4l: vsp1: Extend the DU API to support CRC computation
Date: Sat, 28 Apr 2018 23:50:24 +0300
Message-Id: <20180428205027.18025-6-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180428205027.18025-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180428205027.18025-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a parameter (in the form of a structure to ease future API
extensions) to the VSP atomic flush handler to pass CRC source
configuration, and pass the CRC value to the completion callback.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
Changes since v2:

- Name the CRC computation configuration parameters structure
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  6 ++++--
 drivers/media/platform/vsp1/vsp1_drm.c |  6 ++++--
 drivers/media/platform/vsp1/vsp1_drm.h |  2 +-
 include/media/vsp1.h                   | 35 ++++++++++++++++++++++++++++++++--
 4 files changed, 42 insertions(+), 7 deletions(-)

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
index 2b29a83dceb9..5fc31578f9b0 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -36,7 +36,7 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
 	bool complete = completion == VSP1_DL_FRAME_END_COMPLETED;
 
 	if (drm_pipe->du_complete)
-		drm_pipe->du_complete(drm_pipe->du_private, complete);
+		drm_pipe->du_complete(drm_pipe->du_private, complete, 0);
 
 	if (completion & VSP1_DL_FRAME_END_INTERNAL) {
 		drm_pipe->force_brx_release = false;
@@ -739,8 +739,10 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_update);
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
index f4af1b2b12d6..e5b88b28806c 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -35,7 +35,7 @@ struct vsp1_drm_pipeline {
 	wait_queue_head_t wait_queue;
 
 	/* Frame synchronisation */
-	void (*du_complete)(void *, bool);
+	void (*du_complete)(void *data, bool completed, u32 crc);
 	void *du_private;
 };
 
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index ff7ef894465d..678c24de1ac6 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -34,7 +34,7 @@ struct vsp1_du_lif_config {
 	unsigned int width;
 	unsigned int height;
 
-	void (*callback)(void *, bool);
+	void (*callback)(void *data, bool completed, u32 crc);
 	void *callback_data;
 };
 
@@ -61,11 +61,42 @@ struct vsp1_du_atomic_config {
 	unsigned int zpos;
 };
 
+/**
+ * enum vsp1_du_crc_source - Source used for CRC calculation
+ * @VSP1_DU_CRC_NONE: CRC calculation disabled
+ * @VSP1_DU_CRC_PLANE: Perform CRC calculation on an input plane
+ * @VSP1_DU_CRC_OUTPUT: Perform CRC calculation on the composed output
+ */
+enum vsp1_du_crc_source {
+	VSP1_DU_CRC_NONE,
+	VSP1_DU_CRC_PLANE,
+	VSP1_DU_CRC_OUTPUT,
+};
+
+/**
+ * struct vsp1_du_crc_config - VSP CRC computation configuration parameters
+ * @source: source for CRC calculation
+ * @index: index of the CRC source plane (when source is set to plane)
+ */
+struct vsp1_du_crc_config {
+	enum vsp1_du_crc_source source;
+	unsigned int index;
+};
+
+/**
+ * struct vsp1_du_atomic_pipe_config - VSP atomic pipe configuration parameters
+ * @crc: CRC computation configuration
+ */
+struct vsp1_du_atomic_pipe_config {
+	struct vsp1_du_crc_config crc;
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
