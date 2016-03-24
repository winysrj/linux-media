Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbcCXX2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:14 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 24/51] v4l: vsp1: Use display lists with the userspace API
Date: Fri, 25 Mar 2016 01:27:20 +0200
Message-Id: <1458862067-19525-25-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't restrict display list usage to the DRM pipeline, use them
unconditionally. This prepares the driver to support the request API.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c     |  11 +--
 drivers/media/platform/vsp1/vsp1_drm.c    |  23 ++---
 drivers/media/platform/vsp1/vsp1_entity.c |   5 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |  33 +------
 drivers/media/platform/vsp1/vsp1_rpf.c    |   9 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c   |  26 ------
 drivers/media/platform/vsp1/vsp1_rwpf.h   |  18 ++--
 drivers/media/platform/vsp1/vsp1_video.c  | 145 +++++++++++++++++++++---------
 drivers/media/platform/vsp1/vsp1_wpf.c    |  18 ++--
 9 files changed, 142 insertions(+), 146 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 596f6a67f1bb..5a24d494059b 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -312,14 +312,15 @@ done:
 /* Hardware Setup */
 void vsp1_dlm_setup(struct vsp1_device *vsp1)
 {
-	u32 ctrl = (256 << VI6_DL_CTRL_AR_WAIT_SHIFT);
+	u32 ctrl = (256 << VI6_DL_CTRL_AR_WAIT_SHIFT)
+		 | VI6_DL_CTRL_DC2 | VI6_DL_CTRL_DC1 | VI6_DL_CTRL_DC0
+		 | VI6_DL_CTRL_DLE;
 
-	/* The DRM pipeline operates with header-less display lists in
-	 * Continuous Frame Mode.
+	/* The DRM pipeline operates with display lists in Continuous Frame
+	 * Mode, all other pipelines use manual start.
 	 */
 	if (vsp1->drm)
-		ctrl |= VI6_DL_CTRL_DC2 | VI6_DL_CTRL_DC1 | VI6_DL_CTRL_DC0
-		     |  VI6_DL_CTRL_DLE | VI6_DL_CTRL_CFM0 | VI6_DL_CTRL_NH0;
+		ctrl |= VI6_DL_CTRL_CFM0 | VI6_DL_CTRL_NH0;
 
 	vsp1_write(vsp1, VI6_DL_CTRL, ctrl);
 	vsp1_write(vsp1, VI6_DL_SWAP, VI6_DL_SWAP_LWS);
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 96ad8072d5d6..a73018c9e8b5 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -36,11 +36,6 @@ void vsp1_drm_display_start(struct vsp1_device *vsp1)
 	vsp1_dlm_irq_display_start(vsp1->drm->pipe.output->dlm);
 }
 
-void vsp1_drm_frame_end(struct vsp1_pipeline *pipe)
-{
-	vsp1_dlm_irq_frame_end(pipe->output->dlm);
-}
-
 /* -----------------------------------------------------------------------------
  * DU Driver API
  */
@@ -280,7 +275,6 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 	const struct vsp1_format_info *fmtinfo;
 	struct v4l2_subdev_selection sel;
 	struct v4l2_subdev_format format;
-	struct vsp1_rwpf_memory memory;
 	struct vsp1_rwpf *rpf;
 	unsigned long flags;
 	int ret;
@@ -420,15 +414,12 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 	rpf->location.left = dst->left;
 	rpf->location.top = dst->top;
 
-	/* Set the memory buffer address but don't apply the values to the
+	/* Cache the memory buffer address but don't apply the values to the
 	 * hardware as the crop offsets haven't been computed yet.
 	 */
-	memory.num_planes = fmtinfo->planes;
-	memory.addr[0] = mem[0];
-	memory.addr[1] = mem[1];
-	memory.addr[2] = 0;
-
-	vsp1_rwpf_set_memory(rpf, &memory, false);
+	rpf->mem.addr[0] = mem[0];
+	rpf->mem.addr[1] = mem[1];
+	rpf->mem.addr[2] = 0;
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
@@ -482,14 +473,17 @@ void vsp1_du_atomic_flush(struct device *dev)
 				entity->subdev.name);
 			return;
 		}
+
+		if (entity->type == VSP1_ENTITY_RPF)
+			vsp1_rwpf_set_memory(to_rwpf(&entity->subdev));
 	}
 
 	vsp1_dl_list_commit(pipe->dl);
 	pipe->dl = NULL;
 
+	/* Start or stop the pipeline if needed. */
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
-	/* Start or stop the pipeline if needed. */
 	if (!vsp1->drm->num_inputs && pipe->num_inputs) {
 		vsp1_write(vsp1, VI6_DISP_IRQ_STA, 0);
 		vsp1_write(vsp1, VI6_DISP_IRQ_ENB, VI6_DISP_IRQ_ENB_DSTE);
@@ -569,7 +563,6 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 	pipe = &vsp1->drm->pipe;
 
 	vsp1_pipeline_init(pipe);
-	pipe->frame_end = vsp1_drm_frame_end;
 
 	/* The DRM pipeline is static, add entities manually. */
 	for (i = 0; i < vsp1->info->rpf_count; ++i) {
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index be67727f6f78..7b2301dbd584 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -27,10 +27,7 @@ void vsp1_mod_write(struct vsp1_entity *e, u32 reg, u32 data)
 {
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&e->subdev.entity);
 
-	if (pipe->dl)
-		vsp1_dl_list_write(pipe->dl, reg, data);
-	else
-		vsp1_write(e->vsp1, reg, data);
+	vsp1_dl_list_write(pipe->dl, reg, data);
 }
 
 void vsp1_entity_route_setup(struct vsp1_entity *source)
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index a9a754e17e8d..3311db18f40b 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -273,42 +273,13 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
 
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
-	enum vsp1_pipeline_state state;
-	unsigned long flags;
-
 	if (pipe == NULL)
 		return;
 
-	/* Signal frame end to the pipeline handler. */
+	vsp1_dlm_irq_frame_end(pipe->output->dlm);
+
 	if (pipe->frame_end)
 		pipe->frame_end(pipe);
-
-	spin_lock_irqsave(&pipe->irqlock, flags);
-
-	state = pipe->state;
-
-	/* When using display lists in continuous frame mode the pipeline is
-	 * automatically restarted by the hardware.
-	 */
-	if (pipe->lif)
-		goto done;
-
-	pipe->state = VSP1_PIPELINE_STOPPED;
-
-	/* If a stop has been requested, mark the pipeline as stopped and
-	 * return.
-	 */
-	if (state == VSP1_PIPELINE_STOPPING) {
-		wake_up(&pipe->wq);
-		goto done;
-	}
-
-	/* Restart the pipeline if ready. */
-	if (vsp1_pipeline_ready(pipe))
-		vsp1_pipeline_run(pipe);
-
-done:
-	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
 /*
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 9857d633f61e..1bbb8d8f9bcb 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -78,9 +78,6 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_PSTRIDE, pstride);
 
-	/* Now that the offsets have been computed program the DMA addresses. */
-	rpf->ops->set_memory(rpf);
-
 	/* Format */
 	infmt = VI6_RPF_INFMT_CIPM
 	      | (fmtinfo->hwfmt << VI6_RPF_INFMT_RDFMT_SHIFT);
@@ -150,11 +147,11 @@ static struct v4l2_subdev_ops rpf_ops = {
 static void rpf_set_memory(struct vsp1_rwpf *rpf)
 {
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
-		       rpf->buf_addr[0] + rpf->offsets[0]);
+		       rpf->mem.addr[0] + rpf->offsets[0]);
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
-		       rpf->buf_addr[1] + rpf->offsets[1]);
+		       rpf->mem.addr[1] + rpf->offsets[1]);
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
-		       rpf->buf_addr[2] + rpf->offsets[1]);
+		       rpf->mem.addr[2] + rpf->offsets[1]);
 }
 
 static const struct vsp1_rwpf_operations rpf_vdev_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 0924079b920c..38893ab06cd9 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -269,29 +269,3 @@ int vsp1_rwpf_init_ctrls(struct vsp1_rwpf *rwpf)
 
 	return rwpf->ctrls.error;
 }
-
-/* -----------------------------------------------------------------------------
- * Buffers
- */
-
-/**
- * vsp1_rwpf_set_memory - Configure DMA addresses for a [RW]PF
- * @rwpf: the [RW]PF instance
- * @mem: DMA memory addresses
- * @apply: whether to apply the configuration to the hardware
- *
- * This function stores the DMA addresses for all planes in the rwpf instance
- * and optionally applies the configuration to hardware registers if the apply
- * argument is set to true.
- */
-void vsp1_rwpf_set_memory(struct vsp1_rwpf *rwpf, struct vsp1_rwpf_memory *mem,
-			  bool apply)
-{
-	unsigned int i;
-
-	for (i = 0; i < 3; ++i)
-		rwpf->buf_addr[i] = mem->addr[i];
-
-	if (apply)
-		rwpf->ops->set_memory(rwpf);
-}
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 57f15d45f8bb..2bbcc331959b 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -29,15 +29,13 @@ struct vsp1_rwpf;
 struct vsp1_video;
 
 struct vsp1_rwpf_memory {
-	unsigned int num_planes;
 	dma_addr_t addr[3];
-	unsigned int length[3];
 };
 
 /**
  * struct vsp1_rwpf_operations - RPF and WPF operations
  * @set_memory: Setup memory buffer access. This operation applies the settings
- *		stored in the rwpf buf_addr field to the hardware.
+ *		stored in the rwpf mem field to the hardware.
  */
 struct vsp1_rwpf_operations {
 	void (*set_memory)(struct vsp1_rwpf *rwpf);
@@ -65,7 +63,7 @@ struct vsp1_rwpf {
 	unsigned int alpha;
 
 	unsigned int offsets[2];
-	dma_addr_t buf_addr[3];
+	struct vsp1_rwpf_memory mem;
 
 	struct vsp1_dl_manager *dlm;
 };
@@ -99,7 +97,15 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 			    struct v4l2_subdev_pad_config *cfg,
 			    struct v4l2_subdev_selection *sel);
 
-void vsp1_rwpf_set_memory(struct vsp1_rwpf *rwpf, struct vsp1_rwpf_memory *mem,
-			  bool apply);
+/**
+ * vsp1_rwpf_set_memory - Configure DMA addresses for a [RW]PF
+ * @rwpf: the [RW]PF instance
+ *
+ * This function applies the cached memory buffer address to the hardware.
+ */
+static inline void vsp1_rwpf_set_memory(struct vsp1_rwpf *rwpf)
+{
+	rwpf->ops->set_memory(rwpf);
+}
 
 #endif /* __VSP1_RWPF_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 96b04fcd33ae..7cb270f57f62 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -29,6 +29,7 @@
 
 #include "vsp1.h"
 #include "vsp1_bru.h"
+#include "vsp1_dl.h"
 #include "vsp1_entity.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
@@ -424,7 +425,7 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 	done->buf.vb2_buf.timestamp = ktime_get_ns();
 	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
 		vb2_set_plane_payload(&done->buf.vb2_buf, i,
-				      done->mem.length[i]);
+				      vb2_plane_size(&done->buf.vb2_buf, i));
 	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
 	return next;
@@ -443,15 +444,41 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
-	vsp1_rwpf_set_memory(video->rwpf, &buf->mem, true);
+	video->rwpf->mem = buf->mem;
 	pipe->buffers_ready |= 1 << video->pipe_index;
 
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
+static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+	unsigned int i;
+
+	if (!pipe->dl)
+		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
+
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
+		struct vsp1_rwpf *rwpf = pipe->inputs[i];
+
+		if (rwpf)
+			vsp1_rwpf_set_memory(rwpf);
+	}
+
+	if (!pipe->lif)
+		vsp1_rwpf_set_memory(pipe->output);
+
+	vsp1_dl_list_commit(pipe->dl);
+	pipe->dl = NULL;
+
+	vsp1_pipeline_run(pipe);
+}
+
 static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+	enum vsp1_pipeline_state state;
+	unsigned long flags;
 	unsigned int i;
 
 	/* Complete buffers on all video nodes. */
@@ -462,8 +489,22 @@ static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
 		vsp1_video_frame_end(pipe, pipe->inputs[i]);
 	}
 
-	if (!pipe->lif)
-		vsp1_video_frame_end(pipe, pipe->output);
+	vsp1_video_frame_end(pipe, pipe->output);
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+
+	state = pipe->state;
+	pipe->state = VSP1_PIPELINE_STOPPED;
+
+	/* If a stop has been requested, mark the pipeline as stopped and
+	 * return. Otherwise restart the pipeline if ready.
+	 */
+	if (state == VSP1_PIPELINE_STOPPING)
+		wake_up(&pipe->wq);
+	else if (vsp1_pipeline_ready(pipe))
+		vsp1_video_pipeline_run(pipe);
+
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
 /* -----------------------------------------------------------------------------
@@ -512,20 +553,15 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 	if (vb->num_planes < format->num_planes)
 		return -EINVAL;
 
-	buf->mem.num_planes = vb->num_planes;
-
 	for (i = 0; i < vb->num_planes; ++i) {
 		buf->mem.addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
-		buf->mem.length[i] = vb2_plane_size(vb, i);
 
-		if (buf->mem.length[i] < format->plane_fmt[i].sizeimage)
+		if (vb2_plane_size(vb, i) < format->plane_fmt[i].sizeimage)
 			return -EINVAL;
 	}
 
-	for ( ; i < 3; ++i) {
+	for ( ; i < 3; ++i)
 		buf->mem.addr[i] = 0;
-		buf->mem.length[i] = 0;
-	}
 
 	return 0;
 }
@@ -549,54 +585,74 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
-	vsp1_rwpf_set_memory(video->rwpf, &buf->mem, true);
+	video->rwpf->mem = buf->mem;
 	pipe->buffers_ready |= 1 << video->pipe_index;
 
 	if (vb2_is_streaming(&video->queue) &&
 	    vsp1_pipeline_ready(pipe))
-		vsp1_pipeline_run(pipe);
+		vsp1_video_pipeline_run(pipe);
 
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
+static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_entity *entity;
+	int ret;
+
+	/* Prepare the display list. */
+	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
+	if (!pipe->dl)
+		return -ENOMEM;
+
+	if (pipe->uds) {
+		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
+
+		/* If a BRU is present in the pipeline before the UDS, the alpha
+		 * component doesn't need to be scaled as the BRU output alpha
+		 * value is fixed to 255. Otherwise we need to scale the alpha
+		 * component only when available at the input RPF.
+		 */
+		if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
+			uds->scale_alpha = false;
+		} else {
+			struct vsp1_rwpf *rpf =
+				to_rwpf(&pipe->uds_input->subdev);
+
+			uds->scale_alpha = rpf->fmtinfo->alpha;
+		}
+	}
+
+	list_for_each_entry(entity, &pipe->entities, list_pipe) {
+		vsp1_entity_route_setup(entity);
+
+		ret = v4l2_subdev_call(&entity->subdev, video, s_stream, 1);
+		if (ret < 0)
+			goto error;
+	}
+
+	return 0;
+
+error:
+	vsp1_dl_list_put(pipe->dl);
+	pipe->dl = NULL;
+
+	return ret;
+}
+
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
-	struct vsp1_entity *entity;
 	unsigned long flags;
 	int ret;
 
 	mutex_lock(&pipe->lock);
 	if (pipe->stream_count == pipe->num_inputs) {
-		if (pipe->uds) {
-			struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
-
-			/* If a BRU is present in the pipeline before the UDS,
-			 * the alpha component doesn't need to be scaled as the
-			 * BRU output alpha value is fixed to 255. Otherwise we
-			 * need to scale the alpha component only when available
-			 * at the input RPF.
-			 */
-			if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
-				uds->scale_alpha = false;
-			} else {
-				struct vsp1_rwpf *rpf =
-					to_rwpf(&pipe->uds_input->subdev);
-
-				uds->scale_alpha = rpf->fmtinfo->alpha;
-			}
-		}
-
-		list_for_each_entry(entity, &pipe->entities, list_pipe) {
-			vsp1_entity_route_setup(entity);
-
-			ret = v4l2_subdev_call(&entity->subdev, video,
-					       s_stream, 1);
-			if (ret < 0) {
-				mutex_unlock(&pipe->lock);
-				return ret;
-			}
+		ret = vsp1_video_setup_pipeline(pipe);
+		if (ret < 0) {
+			mutex_unlock(&pipe->lock);
+			return ret;
 		}
 	}
 
@@ -605,7 +661,7 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 	if (vsp1_pipeline_ready(pipe))
-		vsp1_pipeline_run(pipe);
+		vsp1_video_pipeline_run(pipe);
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 
 	return 0;
@@ -625,6 +681,9 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 		ret = vsp1_pipeline_stop(pipe);
 		if (ret == -ETIMEDOUT)
 			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
+
+		vsp1_dl_list_put(pipe->dl);
+		pipe->dl = NULL;
 	}
 	mutex_unlock(&pipe->lock);
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index d82502681bc3..08c8fce23098 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -157,9 +157,9 @@ static struct v4l2_subdev_ops wpf_ops = {
 
 static void wpf_set_memory(struct vsp1_rwpf *wpf)
 {
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, wpf->buf_addr[0]);
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, wpf->buf_addr[1]);
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, wpf->buf_addr[2]);
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, wpf->mem.addr[0]);
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, wpf->mem.addr[1]);
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, wpf->mem.addr[2]);
 }
 
 static const struct vsp1_rwpf_operations wpf_vdev_ops = {
@@ -200,13 +200,11 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the display list manager if the WPF is used for display */
-	if ((vsp1->info->features & VSP1_HAS_LIF) && index == 0) {
-		wpf->dlm = vsp1_dlm_create(vsp1, index, 4);
-		if (!wpf->dlm) {
-			ret = -ENOMEM;
-			goto error;
-		}
+	/* Initialize the display list manager. */
+	wpf->dlm = vsp1_dlm_create(vsp1, index, 4);
+	if (!wpf->dlm) {
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	/* Initialize the V4L2 subdev. */
-- 
2.7.3

