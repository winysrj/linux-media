Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54480 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbeD1UuW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 16:50:22 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@gmail.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v3 7/8] v4l: vsp1: Integrate DISCOM in display pipeline
Date: Sat, 28 Apr 2018 23:50:26 +0300
Message-Id: <20180428205027.18025-8-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180428205027.18025-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180428205027.18025-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DISCOM is used to compute CRCs on display frames. Integrate it in
the display pipeline at the output of the blending unit to process
output frames.

Computing CRCs on input frames is possible by positioning the DISCOM at
a different point in the pipeline. This use case isn't supported at the
moment and could be implemented by extending the API between the VSP1
and DU drivers if needed.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
Changes since v2:

- Reduce indentation in vsp1_du_insert_uif()
- Use vsp1_du_crc_config structure in vsp1_drm_pipeline
---
 drivers/media/platform/vsp1/vsp1_drm.c | 115 ++++++++++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_drm.h |   7 ++
 2 files changed, 119 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 5fc31578f9b0..08667e3640b2 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -22,6 +22,7 @@
 #include "vsp1_lif.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
+#include "vsp1_uif.h"
 
 #define BRX_NAME(e)	(e)->type == VSP1_ENTITY_BRU ? "BRU" : "BRS"
 
@@ -35,8 +36,13 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
 	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
 	bool complete = completion == VSP1_DL_FRAME_END_COMPLETED;
 
-	if (drm_pipe->du_complete)
-		drm_pipe->du_complete(drm_pipe->du_private, complete, 0);
+	if (drm_pipe->du_complete) {
+		struct vsp1_entity *uif = drm_pipe->uif;
+		u32 crc;
+
+		crc = uif ? vsp1_uif_get_crc(to_uif(&uif->subdev)) : 0;
+		drm_pipe->du_complete(drm_pipe->du_private, complete, crc);
+	}
 
 	if (completion & VSP1_DL_FRAME_END_INTERNAL) {
 		drm_pipe->force_brx_release = false;
@@ -48,10 +54,66 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
  * Pipeline Configuration
  */
 
+/*
+ * Insert the UIF in the pipeline between the prev and next entities. If no UIF
+ * is available connect the two entities directly.
+ */
+static int vsp1_du_insert_uif(struct vsp1_device *vsp1,
+			      struct vsp1_pipeline *pipe,
+			      struct vsp1_entity *uif,
+			      struct vsp1_entity *prev, unsigned int prev_pad,
+			      struct vsp1_entity *next, unsigned int next_pad)
+{
+	struct v4l2_subdev_format format;
+	int ret;
+
+	if (!uif) {
+		/*
+		 * If there's no UIF to bee inserted connected the previous and
+		 * next entities directly.
+		 */
+		prev->sink = next;
+		prev->sink_pad = next_pad;
+		return 0;
+	}
+
+	prev->sink = uif;
+	prev->sink_pad = UIF_PAD_SINK;
+
+	memset(&format, 0, sizeof(format));
+	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.pad = prev_pad;
+
+	ret = v4l2_subdev_call(&prev->subdev, pad, get_fmt, NULL, &format);
+	if (ret < 0)
+		return ret;
+
+	format.pad = UIF_PAD_SINK;
+
+	ret = v4l2_subdev_call(&uif->subdev, pad, set_fmt, NULL, &format);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on UIF sink\n",
+		__func__, format.format.width, format.format.height,
+		format.format.code);
+
+	/*
+	 * The UIF doesn't mangle the format between its sink and source pads,
+	 * so there is no need to retrieve the format on its source pad.
+	 */
+
+	uif->sink = next;
+	uif->sink_pad = next_pad;
+
+	return 0;
+}
+
 /* Setup one RPF and the connected BRx sink pad. */
 static int vsp1_du_pipeline_setup_rpf(struct vsp1_device *vsp1,
 				      struct vsp1_pipeline *pipe,
 				      struct vsp1_rwpf *rpf,
+				      struct vsp1_entity *uif,
 				      unsigned int brx_input)
 {
 	struct v4l2_subdev_selection sel;
@@ -122,6 +184,12 @@ static int vsp1_du_pipeline_setup_rpf(struct vsp1_device *vsp1,
 	if (ret < 0)
 		return ret;
 
+	/* Insert and configure the UIF if available. */
+	ret = vsp1_du_insert_uif(vsp1, pipe, uif, &rpf->entity, RWPF_PAD_SOURCE,
+				 pipe->brx, brx_input);
+	if (ret < 0)
+		return ret;
+
 	/* BRx sink, propagate the format from the RPF source. */
 	format.pad = brx_input;
 
@@ -297,7 +365,10 @@ static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
 static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
 					struct vsp1_pipeline *pipe)
 {
+	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
+	struct vsp1_entity *uif;
+	bool use_uif = false;
 	struct vsp1_brx *brx;
 	unsigned int i;
 	int ret;
@@ -358,7 +429,11 @@ static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
 		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to %s:%u\n",
 			__func__, rpf->entity.index, BRX_NAME(pipe->brx), i);
 
-		ret = vsp1_du_pipeline_setup_rpf(vsp1, pipe, rpf, i);
+		uif = drm_pipe->crc.source == VSP1_DU_CRC_PLANE &&
+		      drm_pipe->crc.index == i ? drm_pipe->uif : NULL;
+		if (uif)
+			use_uif = true;
+		ret = vsp1_du_pipeline_setup_rpf(vsp1, pipe, rpf, uif, i);
 		if (ret < 0) {
 			dev_err(vsp1->dev,
 				"%s: failed to setup RPF.%u\n",
@@ -367,6 +442,31 @@ static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
 		}
 	}
 
+	/* Insert and configure the UIF at the BRx output if available. */
+	uif = drm_pipe->crc.source == VSP1_DU_CRC_OUTPUT ? drm_pipe->uif : NULL;
+	if (uif)
+		use_uif = true;
+	ret = vsp1_du_insert_uif(vsp1, pipe, uif,
+				 pipe->brx, pipe->brx->source_pad,
+				 &pipe->output->entity, 0);
+	if (ret < 0)
+		dev_err(vsp1->dev, "%s: failed to setup UIF after %s\n",
+			__func__, BRX_NAME(pipe->brx));
+
+	/*
+	 * If the UIF is not in use schedule it for removal by setting its pipe
+	 * pointer to NULL, vsp1_du_pipeline_configure() will remove it from the
+	 * hardware pipeline and from the pipeline's list of entities. Otherwise
+	 * make sure it is present in the pipeline's list of entities if it
+	 * wasn't already.
+	 */
+	if (!use_uif) {
+		drm_pipe->uif->pipe = NULL;
+	} else if (!drm_pipe->uif->pipe) {
+		drm_pipe->uif->pipe = pipe;
+		list_add_tail(&drm_pipe->uif->list_pipe, &pipe->entities);
+	}
+
 	return 0;
 }
 
@@ -748,6 +848,8 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
 	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
 	struct vsp1_pipeline *pipe = &drm_pipe->pipe;
 
+	drm_pipe->crc = cfg->crc;
+
 	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
 	vsp1_du_pipeline_configure(pipe);
 	mutex_unlock(&vsp1->drm->lock);
@@ -816,6 +918,13 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 
 		pipe->lif->pipe = pipe;
 		list_add_tail(&pipe->lif->list_pipe, &pipe->entities);
+
+		/*
+		 * CRC computation is initially disabled, don't add the UIF to
+		 * the pipeline.
+		 */
+		if (i < vsp1->info->uif_count)
+			drm_pipe->uif = &vsp1->uif[i]->entity;
 	}
 
 	/* Disable all RPFs initially. */
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index e5b88b28806c..8dfd274a59e2 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -13,6 +13,8 @@
 #include <linux/videodev2.h>
 #include <linux/wait.h>
 
+#include <media/vsp1.h>
+
 #include "vsp1_pipe.h"
 
 /**
@@ -22,6 +24,8 @@
  * @height: output display height
  * @force_brx_release: when set, release the BRx during the next reconfiguration
  * @wait_queue: wait queue to wait for BRx release completion
+ * @uif: UIF entity if available for the pipeline
+ * @crc: CRC computation configuration
  * @du_complete: frame completion callback for the DU driver (optional)
  * @du_private: data to be passed to the du_complete callback
  */
@@ -34,6 +38,9 @@ struct vsp1_drm_pipeline {
 	bool force_brx_release;
 	wait_queue_head_t wait_queue;
 
+	struct vsp1_entity *uif;
+	struct vsp1_du_crc_config crc;
+
 	/* Frame synchronisation */
 	void (*du_complete)(void *data, bool completed, u32 crc);
 	void *du_private;
-- 
Regards,

Laurent Pinchart
