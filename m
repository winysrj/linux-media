Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48305 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbcBHLoV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:44:21 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 33/35] v4l: vsp1: Implement atomic update for the DRM driver
Date: Mon,  8 Feb 2016 13:44:03 +0200
Message-Id: <1454931845-23864-34-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two API functions named vsp1_du_atomic_begin() and
vsp1_du_atomic_flush() to signal the start and end of an atomic update.
The vsp1_du_setup_rpf() function is renamed to vsp1_du_atomic_update()
for consistency.

With this new API, the driver will reprogram all modified inputs
atomically before restarting the video stream.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 70 +++++++++++++++++++++++++---------
 drivers/media/platform/vsp1/vsp1_drm.h |  7 ++++
 include/media/vsp1.h                   |  9 +++--
 3 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index a918bb4ab46c..8c76086caa67 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -254,7 +254,26 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
 
 /**
- * vsp1_du_setup_rpf - Setup one RPF input of the VSP pipeline
+ * vsp1_du_atomic_begin - Prepare for an atomic update
+ * @dev: the VSP device
+ */
+void vsp1_du_atomic_begin(struct device *dev)
+{
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+
+	vsp1->drm->num_inputs = pipe->num_inputs;
+	vsp1->drm->update = false;
+
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+}
+EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
+
+/**
+ * vsp1_du_atomic_update - Setup one RPF input of the VSP pipeline
  * @dev: the VSP device
  * @rpf_index: index of the RPF to setup (0-based)
  * @pixelformat: V4L2 pixel format for the RPF memory input
@@ -288,10 +307,10 @@ EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
  *
  * Return 0 on success or a negative error code on failure.
  */
-int vsp1_du_setup_rpf(struct device *dev, unsigned int rpf_index,
-		      u32 pixelformat, unsigned int pitch,
-		      dma_addr_t mem[2], const struct v4l2_rect *src,
-		      const struct v4l2_rect *dst)
+int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
+			  u32 pixelformat, unsigned int pitch,
+			  dma_addr_t mem[2], const struct v4l2_rect *src,
+			  const struct v4l2_rect *dst)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
@@ -301,7 +320,6 @@ int vsp1_du_setup_rpf(struct device *dev, unsigned int rpf_index,
 	struct vsp1_rwpf_memory memory;
 	struct vsp1_rwpf *rpf;
 	unsigned long flags;
-	bool start_stop = false;
 	int ret;
 
 	if (rpf_index >= vsp1->pdata.rpf_count)
@@ -322,16 +340,11 @@ int vsp1_du_setup_rpf(struct device *dev, unsigned int rpf_index,
 			vsp1->bru->inputs[rpf_index].rpf = NULL;
 			pipe->inputs[rpf_index] = NULL;
 
-			vsp1->drm->update = true;
-			start_stop = --pipe->num_inputs == 0;
+			pipe->num_inputs--;
 		}
 
 		spin_unlock_irqrestore(&pipe->irqlock, flags);
 
-		/* Stop the pipeline if we're the last user. */
-		if (start_stop)
-			vsp1_pipeline_stop(pipe);
-
 		return 0;
 	}
 
@@ -459,19 +472,42 @@ int vsp1_du_setup_rpf(struct device *dev, unsigned int rpf_index,
 	if (!pipe->inputs[rpf->entity.index]) {
 		vsp1->bru->inputs[rpf_index].rpf = rpf;
 		pipe->inputs[rpf->entity.index] = rpf;
-		start_stop = pipe->num_inputs++ == 0;
+		pipe->num_inputs++;
 	}
 
-	/* Start the pipeline if it's currently stopped. */
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vsp1_du_atomic_update);
+
+/**
+ * vsp1_du_atomic_flush - Commit an atomic update
+ * @dev: the VSP device
+ */
+void vsp1_du_atomic_flush(struct device *dev)
+{
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
+	unsigned long flags;
+	bool stop = false;
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+
 	vsp1->drm->update = true;
-	if (start_stop)
+
+	/* Start or stop the pipeline if needed. */
+	if (!vsp1->drm->num_inputs && pipe->num_inputs)
 		vsp1_drm_pipeline_run(pipe);
+	else if (vsp1->drm->num_inputs && !pipe->num_inputs)
+		stop = true;
 
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 
-	return 0;
+	if (stop)
+		vsp1_pipeline_stop(pipe);
 }
-EXPORT_SYMBOL_GPL(vsp1_du_setup_rpf);
+EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
 
 /* -----------------------------------------------------------------------------
  * Initialization
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index 2ad320ab1e45..25d7f017feb4 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -15,8 +15,15 @@
 
 #include "vsp1_pipe.h"
 
+/**
+ * vsp1_drm - State for the API exposed to the DRM driver
+ * @pipe: the VSP1 pipeline used for display
+ * @num_inputs: number of active pipeline inputs at the beginning of an update
+ * @update: the pipeline configuration has been updated
+ */
 struct vsp1_drm {
 	struct vsp1_pipeline pipe;
+	unsigned int num_inputs;
 	bool update;
 };
 
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 2c1aea7066be..cc541753896f 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -23,8 +23,11 @@ int vsp1_du_init(struct device *dev);
 int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		      unsigned int height);
 
-int vsp1_du_setup_rpf(struct device *dev, unsigned int rpf, u32 pixelformat,
-		      unsigned int pitch, dma_addr_t mem[2],
-		      const struct v4l2_rect *src, const struct v4l2_rect *dst);
+int vsp1_du_atomic_begin(struct device *dev);
+int vsp1_du_atomic_update(struct device *dev, unsigned int rpf, u32 pixelformat,
+			  unsigned int pitch, dma_addr_t mem[2],
+			  const struct v4l2_rect *src,
+			  const struct v4l2_rect *dst);
+int vsp1_du_atomic_flush(struct device *dev);
 
 #endif /* __MEDIA_VSP1_H__ */
-- 
2.4.10

