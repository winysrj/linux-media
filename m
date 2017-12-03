Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53684 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdLCK5o (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 05:57:44 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 8/9] v4l: vsp1: Integrate DISCOM in display pipeline
Date: Sun,  3 Dec 2017 12:57:34 +0200
Message-Id: <20171203105735.10529-9-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
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
---
 drivers/media/platform/vsp1/vsp1_drm.c | 113 +++++++++++++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_drm.h |  12 ++++
 2 files changed, 121 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 97d2be3b0023..bcf30c25ccb3 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -26,6 +26,7 @@
 #include "vsp1_lif.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
+#include "vsp1_uif.h"
 
 
 /* -----------------------------------------------------------------------------
@@ -36,9 +37,15 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
 				       bool completed)
 {
 	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
+	u32 crc = 0;
 
-	if (drm_pipe->du_complete)
-		drm_pipe->du_complete(drm_pipe->du_private, completed, 0);
+	if (!drm_pipe->du_complete)
+		return;
+
+	if (drm_pipe->uif)
+		crc = vsp1_uif_get_crc(to_uif(&drm_pipe->uif->subdev));
+
+	drm_pipe->du_complete(drm_pipe->du_private, completed, crc);
 }
 
 /* -----------------------------------------------------------------------------
@@ -393,9 +400,67 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_update);
 
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
+	int ret;
+
+	if (uif) {
+		struct v4l2_subdev_format format;
+
+		prev->sink = uif;
+		prev->sink_pad = UIF_PAD_SINK;
+
+		memset(&format, 0, sizeof(format));
+		format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		format.pad = prev_pad;
+
+		ret = v4l2_subdev_call(&prev->subdev, pad, get_fmt, NULL,
+				       &format);
+		if (ret < 0)
+			return ret;
+
+		format.pad = UIF_PAD_SINK;
+
+		ret = v4l2_subdev_call(&uif->subdev, pad, set_fmt, NULL,
+				       &format);
+		if (ret < 0)
+			return ret;
+
+		dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on UIF sink\n",
+			__func__, format.format.width, format.format.height,
+			format.format.code);
+
+		/*
+		 * The UIF doesn't mangle the format between its sink and
+		 * source pads, so there is no need to retrieve the format on
+		 * its source pad.
+		 */
+
+		uif->sink = next;
+		uif->sink_pad = next_pad;
+
+		list_add_tail(&uif->list_pipe, &pipe->entities);
+	} else {
+		prev->sink = next;
+		prev->sink_pad = next_pad;
+	}
+
+	return 0;
+}
+
 static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
 				  struct vsp1_pipeline *pipe,
-				  struct vsp1_rwpf *rpf, unsigned int bru_input)
+				  struct vsp1_rwpf *rpf,
+				  struct vsp1_entity *uif,
+				  unsigned int bru_input)
 {
 	struct v4l2_subdev_selection sel;
 	struct v4l2_subdev_format format;
@@ -468,6 +533,12 @@ static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
 	if (ret < 0)
 		return ret;
 
+	/* Insert and configure the UIF if available. */
+	ret = vsp1_du_insert_uif(vsp1, pipe, uif, &rpf->entity, RWPF_PAD_SOURCE,
+				 pipe->bru, bru_input);
+	if (ret < 0)
+		return ret;
+
 	/* BRU sink, propagate the format from the RPF source. */
 	format.pad = bru_input;
 
@@ -517,6 +588,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
 	struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
 	struct vsp1_entity *entity;
 	struct vsp1_entity *next;
+	struct vsp1_entity *uif;
 	struct vsp1_dl_list *dl;
 	const char *bru_name;
 	unsigned int i;
@@ -556,6 +628,12 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
 		inputs[j] = rpf;
 	}
 
+	/*
+	 * Remove the UIF from the pipeline, it will be inserted only if needed.
+	 */
+	if (drm_pipe->uif && !list_empty(&drm_pipe->uif->list_pipe))
+		list_del_init(&drm_pipe->uif->list_pipe);
+
 	/* Setup the RPF input pipeline for every enabled input. */
 	for (i = 0; i < pipe->bru->source_pad; ++i) {
 		struct vsp1_rwpf *rpf = inputs[i];
@@ -576,13 +654,29 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
 		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to %s:%u\n",
 			__func__, rpf->entity.index, bru_name, i);
 
-		ret = vsp1_du_setup_rpf_pipe(vsp1, pipe, rpf, i);
+		uif = cfg->crc.source == VSP1_DU_CRC_PLANE &&
+		      cfg->crc.index == i ? drm_pipe->uif : NULL;
+		ret = vsp1_du_setup_rpf_pipe(vsp1, pipe, rpf, uif, i);
 		if (ret < 0)
 			dev_err(vsp1->dev,
 				"%s: failed to setup RPF.%u\n",
 				__func__, rpf->entity.index);
 	}
 
+	/* Insert and configure the UIF at the BRU output if available. */
+	uif = cfg->crc.source == VSP1_DU_CRC_OUTPUT ? drm_pipe->uif : NULL;
+	ret = vsp1_du_insert_uif(vsp1, pipe, uif,
+				 pipe->bru, pipe->bru->source_pad,
+				 &pipe->output->entity, 0);
+	if (ret < 0)
+		dev_err(vsp1->dev, "%s: failed to setup UIF after BRU\n",
+			__func__);
+
+	/* Disconnect the UIF if it isn't present in the pipeline. */
+	if (drm_pipe->uif && cfg->crc.source == VSP1_DU_CRC_NONE)
+		vsp1_dl_list_write(dl, drm_pipe->uif->route->reg,
+				   VI6_DPR_NODE_UNUSED);
+
 	/* Configure all entities in the pipeline. */
 	list_for_each_entry_safe(entity, next, &pipe->entities, list_pipe) {
 		/* Disconnect unused RPFs from the pipeline. */
@@ -672,6 +766,17 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 		list_add_tail(&pipe->bru->list_pipe, &pipe->entities);
 		list_add_tail(&pipe->lif->list_pipe, &pipe->entities);
 		list_add_tail(&pipe->output->entity.list_pipe, &pipe->entities);
+
+		/*
+		 * CRC computation is initially disabled, don't add the UIF to
+		 * the pipeline.
+		 */
+		if (i < vsp1->info->uif_count) {
+			drm_pipe->uif = &vsp1->uif[i]->entity;
+			drm_pipe->uif->sink = &pipe->output->entity;
+			drm_pipe->uif->sink_pad = 0;
+			INIT_LIST_HEAD(&drm_pipe->uif->list_pipe);
+		}
 	}
 
 	/* Disable all RPFs initially. */
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index c6515272da7d..aa07c54e6d9f 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -15,12 +15,17 @@
 
 #include <linux/videodev2.h>
 
+#include <media/vsp1.h>
+
 #include "vsp1_pipe.h"
 
 /**
  * vsp1_drm_pipeline - State for the API exposed to the DRM driver
  * @pipe: the VSP1 pipeline used for display
  * @enabled: pipeline state at the beginning of an update
+ * @uif: UIF entity if available for the pipeline
+ * @crc.source: source for CRC calculation
+ * @crc.index: index of the CRC source plane (when crc.source is set to plane)
  * @du_complete: frame completion callback for the DU driver (optional)
  * @du_private: data to be passed to the du_complete callback
  */
@@ -28,6 +33,13 @@ struct vsp1_drm_pipeline {
 	struct vsp1_pipeline pipe;
 	bool enabled;
 
+	struct vsp1_entity *uif;
+
+	struct {
+		enum vsp1_du_crc_source source;
+		unsigned int index;
+	} crc;
+
 	/* Frame synchronisation */
 	void (*du_complete)(void *data, bool completed, u32 crc);
 	void *du_private;
-- 
Regards,

Laurent Pinchart
