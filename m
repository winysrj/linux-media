Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbcCYKpN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:45:13 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 51/54] v4l: vsp1: Add Z-order support for DRM pipeline
Date: Fri, 25 Mar 2016 12:44:25 +0200
Message-Id: <1458902668-1141-52-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the Z-order of planes configurable by assigning RPFs to BRU inputs
dynamically based on the Z-order position.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c  | 180 +++++++++++++++++++-------------
 drivers/media/platform/vsp1/vsp1_drm.h  |  12 ++-
 drivers/media/platform/vsp1/vsp1_pipe.c |   1 +
 include/media/vsp1.h                    |  18 +++-
 4 files changed, 130 insertions(+), 81 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 7cde2d970dba..d85cb0e258c9 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -93,6 +93,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		media_entity_pipeline_stop(&pipe->output->entity.subdev.entity);
 
 		for (i = 0; i < bru->entity.source_pad; ++i) {
+			vsp1->drm->inputs[i].enabled = false;
 			bru->inputs[i].rpf = NULL;
 			pipe->inputs[i] = NULL;
 		}
@@ -217,14 +218,9 @@ void vsp1_du_atomic_begin(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
-	unsigned long flags;
-
-	spin_lock_irqsave(&pipe->irqlock, flags);
 
 	vsp1->drm->num_inputs = pipe->num_inputs;
 
-	spin_unlock_irqrestore(&pipe->irqlock, flags);
-
 	/* Prepare the display list. */
 	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
 }
@@ -239,10 +235,12 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
  * @mem: DMA addresses of the memory buffers (one per plane)
  * @src: the source crop rectangle for the RPF
  * @dst: the destination compose rectangle for the BRU input
+ * @zpos: the Z-order position of the input
  *
  * Configure the VSP to perform composition of the image referenced by @mem
  * through RPF @rpf_index, using the @src crop rectangle and the @dst
- * composition rectangle. The Z-order is fixed with RPF 0 at the bottom.
+ * composition rectangle. The Z-order is configurable with higher @zpos values
+ * displayed on top.
  *
  * Image format as stored in memory is expressed as a V4L2 @pixelformat value.
  * As a special case, setting the pixel format to 0 will disable the RPF. The
@@ -260,24 +258,16 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
  *
  * This function isn't reentrant, the caller needs to serialize calls.
  *
- * TODO: Implement Z-order control by decoupling the RPF index from the BRU
- * input index.
- *
  * Return 0 on success or a negative error code on failure.
  */
-int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
-			  u32 pixelformat, unsigned int pitch,
-			  dma_addr_t mem[2], const struct v4l2_rect *src,
-			  const struct v4l2_rect *dst)
+int vsp1_du_atomic_update_ext(struct device *dev, unsigned int rpf_index,
+			      u32 pixelformat, unsigned int pitch,
+			      dma_addr_t mem[2], const struct v4l2_rect *src,
+			      const struct v4l2_rect *dst, unsigned int zpos)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
-	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
 	const struct vsp1_format_info *fmtinfo;
-	struct v4l2_subdev_selection sel;
-	struct v4l2_subdev_format format;
 	struct vsp1_rwpf *rpf;
-	unsigned long flags;
-	int ret;
 
 	if (rpf_index >= vsp1->info->rpf_count)
 		return -EINVAL;
@@ -288,31 +278,20 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 		dev_dbg(vsp1->dev, "%s: RPF%u: disable requested\n", __func__,
 			rpf_index);
 
-		spin_lock_irqsave(&pipe->irqlock, flags);
-
-		if (pipe->inputs[rpf_index]) {
-			/* Remove the RPF from the pipeline if it was previously
-			 * enabled.
-			 */
-			vsp1->bru->inputs[rpf_index].rpf = NULL;
-			pipe->inputs[rpf_index] = NULL;
-
-			pipe->num_inputs--;
-		}
-
-		spin_unlock_irqrestore(&pipe->irqlock, flags);
-
+		vsp1->drm->inputs[rpf_index].enabled = false;
 		return 0;
 	}
 
 	dev_dbg(vsp1->dev,
-		"%s: RPF%u: (%u,%u)/%ux%u -> (%u,%u)/%ux%u (%08x), pitch %u dma { %pad, %pad }\n",
+		"%s: RPF%u: (%u,%u)/%ux%u -> (%u,%u)/%ux%u (%08x), pitch %u dma { %pad, %pad } zpos %u\n",
 		__func__, rpf_index,
 		src->left, src->top, src->width, src->height,
 		dst->left, dst->top, dst->width, dst->height,
-		pixelformat, pitch, &mem[0], &mem[1]);
+		pixelformat, pitch, &mem[0], &mem[1], zpos);
 
-	/* Set the stride at the RPF input. */
+	/* Store the format, stride, memory buffer address, crop and compose
+	 * rectangles and Z-order position and for the input.
+	 */
 	fmtinfo = vsp1_get_format_info(pixelformat);
 	if (!fmtinfo) {
 		dev_dbg(vsp1->dev, "Unsupport pixel format %08x for RPF\n",
@@ -325,15 +304,38 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 	rpf->format.plane_fmt[0].bytesperline = pitch;
 	rpf->format.plane_fmt[1].bytesperline = pitch;
 
+	rpf->mem.addr[0] = mem[0];
+	rpf->mem.addr[1] = mem[1];
+	rpf->mem.addr[2] = 0;
+
+	vsp1->drm->inputs[rpf_index].crop = *src;
+	vsp1->drm->inputs[rpf_index].compose = *dst;
+	vsp1->drm->inputs[rpf_index].zpos = zpos;
+	vsp1->drm->inputs[rpf_index].enabled = true;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vsp1_du_atomic_update_ext);
+
+static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
+				  struct vsp1_rwpf *rpf, unsigned int bru_input)
+{
+	struct v4l2_subdev_selection sel;
+	struct v4l2_subdev_format format;
+	const struct v4l2_rect *crop;
+	int ret;
+
 	/* Configure the format on the RPF sink pad and propagate it up to the
 	 * BRU sink pad.
 	 */
+	crop = &vsp1->drm->inputs[rpf->entity.index].crop;
+
 	memset(&format, 0, sizeof(format));
 	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	format.pad = RWPF_PAD_SINK;
-	format.format.width = src->width + src->left;
-	format.format.height = src->height + src->top;
-	format.format.code = fmtinfo->mbus;
+	format.format.width = crop->width + crop->left;
+	format.format.height = crop->height + crop->top;
+	format.format.code = rpf->fmtinfo->mbus;
 	format.format.field = V4L2_FIELD_NONE;
 
 	ret = v4l2_subdev_call(&rpf->entity.subdev, pad, set_fmt, NULL,
@@ -350,7 +352,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 	sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	sel.pad = RWPF_PAD_SINK;
 	sel.target = V4L2_SEL_TGT_CROP;
-	sel.r = *src;
+	sel.r = *crop;
 
 	ret = v4l2_subdev_call(&rpf->entity.subdev, pad, set_selection, NULL,
 			       &sel);
@@ -385,7 +387,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 		return ret;
 
 	/* BRU sink, propagate the format from the RPF source. */
-	format.pad = rpf->entity.index;
+	format.pad = bru_input;
 
 	ret = v4l2_subdev_call(&vsp1->bru->entity.subdev, pad, set_fmt, NULL,
 			       &format);
@@ -396,9 +398,9 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 		__func__, format.format.width, format.format.height,
 		format.format.code, format.pad);
 
-	sel.pad = rpf->entity.index;
+	sel.pad = bru_input;
 	sel.target = V4L2_SEL_TGT_COMPOSE;
-	sel.r = *dst;
+	sel.r = vsp1->drm->inputs[rpf->entity.index].compose;
 
 	ret = v4l2_subdev_call(&vsp1->bru->entity.subdev, pad, set_selection,
 			       NULL, &sel);
@@ -410,32 +412,13 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 		__func__, sel.r.left, sel.r.top, sel.r.width, sel.r.height,
 		sel.pad);
 
-	/* Store the BRU input pad number in the RPF. */
-	rpf->bru_input = rpf->entity.index;
-
-	/* Cache the memory buffer address but don't apply the values to the
-	 * hardware as the crop offsets haven't been computed yet.
-	 */
-	rpf->mem.addr[0] = mem[0];
-	rpf->mem.addr[1] = mem[1];
-	rpf->mem.addr[2] = 0;
-
-	spin_lock_irqsave(&pipe->irqlock, flags);
-
-	/* If the RPF was previously stopped set the BRU input to the RPF and
-	 * store the RPF in the pipeline inputs array.
-	 */
-	if (!pipe->inputs[rpf->entity.index]) {
-		vsp1->bru->inputs[rpf_index].rpf = rpf;
-		pipe->inputs[rpf->entity.index] = rpf;
-		pipe->num_inputs++;
-	}
-
-	spin_unlock_irqrestore(&pipe->irqlock, flags);
-
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vsp1_du_atomic_update);
+
+static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
+{
+	return vsp1->drm->inputs[rpf->entity.index].zpos;
+}
 
 /**
  * vsp1_du_atomic_flush - Commit an atomic update
@@ -445,10 +428,60 @@ void vsp1_du_atomic_flush(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
+	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
 	struct vsp1_entity *entity;
 	unsigned long flags;
-	bool stop = false;
+	unsigned int i;
+	int ret;
+
+	/* Count the number of enabled inputs and sort them by Z-order. */
+	pipe->num_inputs = 0;
+
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
+		struct vsp1_rwpf *rpf = vsp1->rpf[i];
+		unsigned int j;
+
+		if (!vsp1->drm->inputs[i].enabled) {
+			pipe->inputs[i] = NULL;
+			continue;
+		}
+
+		pipe->inputs[i] = rpf;
+
+		/* Insert the RPF in the sorted RPFs array. */
+		for (j = pipe->num_inputs++; j > 0; --j) {
+			if (rpf_zpos(vsp1, inputs[j-1]) <= rpf_zpos(vsp1, rpf))
+				break;
+			inputs[j] = inputs[j-1];
+		}
 
+		inputs[j] = rpf;
+	}
+
+	/* Setup the RPF input pipeline for every enabled input. */
+	for (i = 0; i < vsp1->info->num_bru_inputs; ++i) {
+		struct vsp1_rwpf *rpf = inputs[i];
+
+		if (!rpf) {
+			vsp1->bru->inputs[i].rpf = NULL;
+			continue;
+		}
+
+		vsp1->bru->inputs[i].rpf = rpf;
+		rpf->bru_input = i;
+		rpf->entity.sink_pad = i;
+
+		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to BRU:%u\n",
+			__func__, rpf->entity.index, i);
+
+		ret = vsp1_du_setup_rpf_pipe(vsp1, rpf, i);
+		if (ret < 0)
+			dev_err(vsp1->dev,
+				"%s: failed to setup RPF.%u\n",
+				__func__, rpf->entity.index);
+	}
+
+	/* Configure all entities in the pipeline. */
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		/* Disconnect unused RPFs from the pipeline. */
 		if (entity->type == VSP1_ENTITY_RPF) {
@@ -466,6 +499,9 @@ void vsp1_du_atomic_flush(struct device *dev)
 		if (entity->ops->configure)
 			entity->ops->configure(entity, pipe, pipe->dl);
 
+		/* The memory buffer address must be applied after configuring
+		 * the RPF to make sure the crop offset are computed.
+		 */
 		if (entity->type == VSP1_ENTITY_RPF)
 			vsp1_rwpf_set_memory(to_rwpf(&entity->subdev),
 					     pipe->dl);
@@ -475,19 +511,13 @@ void vsp1_du_atomic_flush(struct device *dev)
 	pipe->dl = NULL;
 
 	/* Start or stop the pipeline if needed. */
-	spin_lock_irqsave(&pipe->irqlock, flags);
-
 	if (!vsp1->drm->num_inputs && pipe->num_inputs) {
 		vsp1_write(vsp1, VI6_DISP_IRQ_STA, 0);
 		vsp1_write(vsp1, VI6_DISP_IRQ_ENB, VI6_DISP_IRQ_ENB_DSTE);
+		spin_lock_irqsave(&pipe->irqlock, flags);
 		vsp1_pipeline_run(pipe);
+		spin_unlock_irqrestore(&pipe->irqlock, flags);
 	} else if (vsp1->drm->num_inputs && !pipe->num_inputs) {
-		stop = true;
-	}
-
-	spin_unlock_irqrestore(&pipe->irqlock, flags);
-
-	if (stop) {
 		vsp1_write(vsp1, VI6_DISP_IRQ_ENB, 0);
 		vsp1_pipeline_stop(pipe);
 	}
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index e9242f2c870e..9e28ab9254ba 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -13,18 +13,26 @@
 #ifndef __VSP1_DRM_H__
 #define __VSP1_DRM_H__
 
+#include <linux/videodev2.h>
+
 #include "vsp1_pipe.h"
 
 /**
  * vsp1_drm - State for the API exposed to the DRM driver
  * @pipe: the VSP1 pipeline used for display
  * @num_inputs: number of active pipeline inputs at the beginning of an update
- * @update: the pipeline configuration has been updated
+ * @planes: source crop rectangle, destination compose rectangle and z-order
+ *	position for every input
  */
 struct vsp1_drm {
 	struct vsp1_pipeline pipe;
 	unsigned int num_inputs;
-	bool update;
+	struct {
+		bool enabled;
+		struct v4l2_rect crop;
+		struct v4l2_rect compose;
+		unsigned int zpos;
+	} inputs[VSP1_MAX_RPF];
 };
 
 int vsp1_drm_init(struct vsp1_device *vsp1);
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 4913b933562c..15e028321fa1 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -200,6 +200,7 @@ void vsp1_pipeline_init(struct vsp1_pipeline *pipe)
 	pipe->state = VSP1_PIPELINE_STOPPED;
 }
 
+/* Must be called with the pipe irqlock held. */
 void vsp1_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index d01f7cb8f691..e54a493bd3ff 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -24,10 +24,20 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		      unsigned int height);
 
 void vsp1_du_atomic_begin(struct device *dev);
-int vsp1_du_atomic_update(struct device *dev, unsigned int rpf, u32 pixelformat,
-			  unsigned int pitch, dma_addr_t mem[2],
-			  const struct v4l2_rect *src,
-			  const struct v4l2_rect *dst);
+int vsp1_du_atomic_update_ext(struct device *dev, unsigned int rpf,
+			      u32 pixelformat, unsigned int pitch,
+			      dma_addr_t mem[2], const struct v4l2_rect *src,
+			      const struct v4l2_rect *dst, unsigned int zpos);
 void vsp1_du_atomic_flush(struct device *dev);
 
+static inline int vsp1_du_atomic_update(struct device *dev,
+					unsigned int rpf_index, u32 pixelformat,
+					unsigned int pitch, dma_addr_t mem[2],
+					const struct v4l2_rect *src,
+					const struct v4l2_rect *dst)
+{
+	return vsp1_du_atomic_update_ext(dev, rpf_index, pixelformat, pitch,
+					 mem, src, dst, 0);
+}
+
 #endif /* __MEDIA_VSP1_H__ */
-- 
2.7.3

