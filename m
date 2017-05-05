Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752259AbdEEPVg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 11:21:36 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, mchehab@kernel.org
Cc: kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v4 3/4] v4l: vsp1: Extend VSP1 module API to allow DRM callbacks
Date: Fri,  5 May 2017 16:21:09 +0100
Message-Id: <ce57c449dd9f95fedfb998c3b708aeb25eb3e87f.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To be able to perform page flips in DRM without flicker we need to be
able to notify the rcar-du module when the VSP has completed its
processing.

We must not have bidirectional dependencies on the two components to
maintain support for loadable modules, thus we extend the API to allow
a callback to be registered within the VSP DRM interface.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 17 +++++++++++++++++
 drivers/media/platform/vsp1/vsp1_drm.h | 11 +++++++++++
 include/media/vsp1.h                   |  7 +++++++
 3 files changed, 35 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 9d235e830f5a..84d0418660bf 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -36,6 +36,14 @@ void vsp1_drm_display_start(struct vsp1_device *vsp1)
 	vsp1_dlm_irq_display_start(vsp1->drm->pipe.output->dlm);
 }
 
+static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_drm *drm = to_vsp1_drm(pipe);
+
+	if (drm->du_complete)
+		drm->du_complete(drm->du_private);
+}
+
 /* -----------------------------------------------------------------------------
  * DU Driver API
  */
@@ -95,6 +103,7 @@ int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg)
 		}
 
 		pipe->num_inputs = 0;
+		vsp1->drm->du_complete = NULL;
 
 		vsp1_dlm_reset(pipe->output->dlm);
 		vsp1_device_put(vsp1);
@@ -199,6 +208,13 @@ int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg)
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * Register a callback to allow us to notify the DRM driver of frame
+	 * completion events.
+	 */
+	vsp1->drm->du_complete = cfg->callback;
+	vsp1->drm->du_private = cfg->callback_data;
+
 	ret = media_pipeline_start(&pipe->output->entity.subdev.entity,
 					  &pipe->pipe);
 	if (ret < 0) {
@@ -603,6 +619,7 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 	pipe->lif = &vsp1->lif->entity;
 	pipe->output = vsp1->wpf[0];
 	pipe->output->pipe = pipe;
+	pipe->frame_end = vsp1_du_pipeline_frame_end;
 
 	return 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index c8d2f88fc483..e9f80727ff92 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -23,6 +23,8 @@
  * @num_inputs: number of active pipeline inputs at the beginning of an update
  * @inputs: source crop rectangle, destination compose rectangle and z-order
  *	position for every input
+ * @du_complete: frame completion callback for the DU driver (optional)
+ * @du_private: data to be passed to the du_complete callback
  */
 struct vsp1_drm {
 	struct vsp1_pipeline pipe;
@@ -33,8 +35,17 @@ struct vsp1_drm {
 		struct v4l2_rect compose;
 		unsigned int zpos;
 	} inputs[VSP1_MAX_RPF];
+
+	/* Frame synchronisation */
+	void (*du_complete)(void *);
+	void *du_private;
 };
 
+static inline struct vsp1_drm *to_vsp1_drm(struct vsp1_pipeline *pipe)
+{
+	return container_of(pipe, struct vsp1_drm, pipe);
+}
+
 int vsp1_drm_init(struct vsp1_device *vsp1);
 void vsp1_drm_cleanup(struct vsp1_device *vsp1);
 int vsp1_drm_create_links(struct vsp1_device *vsp1);
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 38aac554dbba..c135c47b4641 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -24,10 +24,17 @@ int vsp1_du_init(struct device *dev);
  * struct vsp1_du_lif_config - VSP LIF configuration
  * @width: output frame width
  * @height: output frame height
+ * @callback: frame completion callback function (optional). When a callback
+ *	      is provided, the VSP driver guarantees that it will be called once
+ *	      and only once for each vsp1_du_atomic_flush() call.
+ * @callback_data: data to be passed to the frame completion callback
  */
 struct vsp1_du_lif_config {
 	unsigned int width;
 	unsigned int height;
+
+	void (*callback)(void *);
+	void *callback_data;
 };
 
 int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg);
-- 
git-series 0.9.1
