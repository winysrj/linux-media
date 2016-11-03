Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757713AbcKCPGv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 11:06:51 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCHv2] v4l: vsp1: Provide a writeback video device
Date: Thu,  3 Nov 2016 15:06:25 +0000
Message-Id: <1478185585-10607-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the VSP1 is used in an active display pipeline, the output of the
WPF can supply the LIF entity directly and simultaneously write to
memory.

Support this functionality in the VSP1 driver, by extending the WPF
source pads, and establishing a V4L2 video device node connected to the
new source.

The source will be able to perform pixel format conversion, but not
rescaling, and as such the output from the memory node will always be
of the same dimensions as the display output.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---

With the patch "[media] v4l: vsp1: Supply frames to the DU continuously"
reverted, and the other patch from the previous series dropped - this
submission is down to a single patch to implement the writeback device.

This current version limits the output of the video node to match the frames
presented by updates from the CRTC atomic flush events.

The output from the device node can be tested by generating frames on the DRM
pipeline and capturing with yavta:

Terminal 1:
 # kmstest --flip --sync

Terminal 2:
 # yavta -c60 -n8 -f RGB24 -s1024x768 \
	--file=frame-rgb24-1024x768-#.bin /dev/$VIDEO

$VIDEO must be determined for your platform and represents the WPF Video node

Changes since RFC
 - Fix checkpatch.pl warnings
 - Adapt to use a single source pad for the Writeback and LIF
 - Use WPF properties to determine when to create links instead of VSP
 - Remove incorrect vsp1_video_verify_format() changes
 - Spelling and grammar fixes

 drivers/media/platform/vsp1/vsp1.h       |   1 +
 drivers/media/platform/vsp1/vsp1_drm.c   |  19 ++++
 drivers/media/platform/vsp1/vsp1_drv.c   |   5 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h  |   1 +
 drivers/media/platform/vsp1/vsp1_video.c | 150 ++++++++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_video.h |   5 ++
 drivers/media/platform/vsp1/vsp1_wpf.c   |  19 +++-
 7 files changed, 193 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 85387a64179a..a2d462264312 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -54,6 +54,7 @@ struct vsp1_uds;
 #define VSP1_HAS_WPF_HFLIP	(1 << 6)
 #define VSP1_HAS_HGO		(1 << 7)
 #define VSP1_HAS_HGT		(1 << 8)
+#define VSP1_HAS_WPF_WRITEBACK	(1 << 9)
 
 struct vsp1_device_info {
 	u32 version;
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 0daf5f2c06e2..9bb7c1a04157 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -27,6 +27,7 @@
 #include "vsp1_lif.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
+#include "vsp1_video.h"
 
 
 /* -----------------------------------------------------------------------------
@@ -479,6 +480,13 @@ void vsp1_du_atomic_flush(struct device *dev)
 				__func__, rpf->entity.index);
 	}
 
+	/*
+	 * If we have a writeback node attached, we use this opportunity to
+	 * update the video buffers.
+	 */
+	if (pipe->output->video && pipe->output->video->frame_end)
+		pipe->output->video->frame_end(pipe);
+
 	/* Configure all entities in the pipeline. */
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		/* Disconnect unused RPFs from the pipeline. */
@@ -590,6 +598,16 @@ int vsp1_drm_create_links(struct vsp1_device *vsp1)
 	if (ret < 0)
 		return ret;
 
+	if (vsp1->wpf[0]->has_writeback) {
+		/* Connect the video device to the WPF for Writeback support */
+		ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
+				    RWPF_PAD_SOURCE,
+				    &vsp1->wpf[0]->video->video.entity,
+				    0, flags);
+		if (ret < 0)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -620,6 +638,7 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 	pipe->bru = &vsp1->bru->entity;
 	pipe->lif = &vsp1->lif->entity;
 	pipe->output = vsp1->wpf[0];
+	pipe->output->pipe = pipe;
 
 	return 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 3b084976094b..42fa822b38d3 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -408,7 +408,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		vsp1->wpf[i] = wpf;
 		list_add_tail(&wpf->entity.list_dev, &vsp1->entities);
 
-		if (vsp1->info->uapi) {
+		if (vsp1->info->uapi || wpf->has_writeback) {
 			struct vsp1_video *video = vsp1_video_create(vsp1, wpf);
 
 			if (IS_ERR(video)) {
@@ -705,7 +705,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
 		.model = "VSP2-D",
 		.gen = 3,
-		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_WPF_VFLIP,
+		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_WPF_VFLIP
+			  | VSP1_HAS_WPF_WRITEBACK,
 		.rpf_count = 5,
 		.wpf_count = 2,
 		.num_bru_inputs = 5,
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index b4ffc38f48af..7502b467294a 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -53,6 +53,7 @@ struct vsp1_rwpf {
 
 	u32 mult_alpha;
 	u32 outfmt;
+	bool has_writeback;
 
 	struct {
 		spinlock_t lock;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index f10401065cd3..f19d879ce5ee 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -860,6 +860,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	list_for_each_entry(buffer, &video->irqqueue, queue)
 		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	INIT_LIST_HEAD(&video->irqqueue);
+	INIT_LIST_HEAD(&video->wbqueue);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 }
 
@@ -873,6 +874,147 @@ static const struct vb2_ops vsp1_video_queue_qops = {
 	.stop_streaming = vsp1_video_stop_streaming,
 };
 
+
+/* -----------------------------------------------------------------------------
+ * videobuf2 queue operations for writeback nodes
+ */
+
+static void vsp1_video_wb_process_buffer(struct vsp1_video *video)
+{
+	struct vsp1_vb2_buffer *buf;
+	unsigned long flags;
+
+	/*
+	 * Writeback uses a running stream, unlike the M2M interface which
+	 * controls a pipeline process manually though the use of
+	 * vsp1_pipeline_run().
+	 *
+	 * Instead writeback will commence at the next frame interval, and can
+	 * be marked complete at the interval following that. To handle this we
+	 * store the configured buffer as pending until the next callback.
+	 *
+	 * |    |    |    |    |
+	 *  A   |<-->|
+	 *       B   |<-->|
+	 *            C   |<-->| : Only at interrupt C can A be marked done
+	 */
+
+	spin_lock_irqsave(&video->irqlock, flags);
+
+	/* Move the pending image to the active hw queue */
+	if (video->pending) {
+		list_add_tail(&video->pending->queue, &video->irqqueue);
+		video->pending = NULL;
+	}
+
+	buf = list_first_entry_or_null(&video->wbqueue, struct vsp1_vb2_buffer,
+					queue);
+
+	if (buf) {
+		video->rwpf->mem = buf->mem;
+
+		/*
+		 * Store this buffer as pending. It will commence at the next
+		 * frame start interrupt
+		 */
+		video->pending = buf;
+		list_del(&buf->queue);
+	} else {
+		/* Disable writeback with no buffer */
+		video->rwpf->mem = (struct vsp1_rwpf_memory) { 0 };
+	}
+
+	spin_unlock_irqrestore(&video->irqlock, flags);
+}
+
+static void vsp1_video_wb_frame_end(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_video *video = pipe->output->video;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+
+	/* Complete any buffer on the IRQ queue */
+	vsp1_video_complete_buffer(video);
+
+	/* Queue up any buffer from our wb queue, and place on the IRQ queue */
+	vsp1_video_wb_process_buffer(video);
+
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+}
+
+static void vsp1_video_wb_buffer_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
+	struct vsp1_vb2_buffer *buf = to_vsp1_vb2_buffer(vbuf);
+	unsigned long flags;
+
+	spin_lock_irqsave(&video->irqlock, flags);
+	list_add_tail(&buf->queue, &video->wbqueue);
+	spin_unlock_irqrestore(&video->irqlock, flags);
+}
+
+static int vsp1_video_wb_start_streaming(struct vb2_queue *vq,
+		unsigned int count)
+{
+	struct vsp1_video *video = vb2_get_drv_priv(vq);
+	unsigned long flags;
+
+	/* Enable the completion interrupts */
+	spin_lock_irqsave(&video->irqlock, flags);
+	video->frame_end = vsp1_video_wb_frame_end;
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
+	return 0;
+}
+
+static void vsp1_video_wb_stop_streaming(struct vb2_queue *vq)
+{
+	struct vsp1_video *video = vb2_get_drv_priv(vq);
+	struct vsp1_rwpf *rwpf = video->rwpf;
+	struct vsp1_pipeline *pipe = rwpf->pipe;
+	struct vsp1_vb2_buffer *buffer;
+	unsigned long flags;
+
+	/*
+	 * Disable the completion interrupts, and clear the WPF memory to
+	 * prevent writing out frames
+	 */
+	spin_lock_irqsave(&video->irqlock, flags);
+	video->frame_end = NULL;
+	rwpf->mem = (struct vsp1_rwpf_memory) { 0 };
+
+	/* Return all queued buffers to userspace */
+	list_for_each_entry(buffer, &video->wbqueue, queue)
+		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
+	list_for_each_entry(buffer, &video->irqqueue, queue)
+		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
+	if (video->pending) {
+		vb2_buffer_done(&video->pending->buf.vb2_buf,
+				VB2_BUF_STATE_ERROR);
+		video->pending = NULL;
+	}
+
+	INIT_LIST_HEAD(&video->wbqueue);
+	INIT_LIST_HEAD(&video->irqqueue);
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
+	/* Return the reference obtained by vsp1_video_streamon() */
+	vsp1_video_pipeline_put(pipe);
+}
+
+static const struct vb2_ops vsp1_video_wb_queue_qops = {
+	.queue_setup = vsp1_video_queue_setup,
+	.buf_prepare = vsp1_video_buffer_prepare,
+	.buf_queue = vsp1_video_wb_buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = vsp1_video_wb_start_streaming,
+	.stop_streaming = vsp1_video_wb_stop_streaming,
+};
+
+
 /* -----------------------------------------------------------------------------
  * V4L2 ioctls
  */
@@ -1109,6 +1251,8 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 	video->vsp1 = vsp1;
 	video->rwpf = rwpf;
 
+	video->is_writeback = rwpf->has_writeback;
+
 	if (rwpf->entity.type == VSP1_ENTITY_RPF) {
 		direction = "input";
 		video->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
@@ -1124,6 +1268,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 	mutex_init(&video->lock);
 	spin_lock_init(&video->irqlock);
 	INIT_LIST_HEAD(&video->irqqueue);
+	INIT_LIST_HEAD(&video->wbqueue);
 
 	/* Initialize the media entity... */
 	ret = media_entity_pads_init(&video->video.entity, 1, &video->pad);
@@ -1147,12 +1292,15 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 
 	video_set_drvdata(&video->video, video);
 
+	if (video->is_writeback)
+		video->queue.ops = &vsp1_video_wb_queue_qops;
+	else
+		video->queue.ops = &vsp1_video_queue_qops;
 	video->queue.type = video->type;
 	video->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	video->queue.lock = &video->lock;
 	video->queue.drv_priv = video;
 	video->queue.buf_struct_size = sizeof(struct vsp1_vb2_buffer);
-	video->queue.ops = &vsp1_video_queue_qops;
 	video->queue.mem_ops = &vb2_dma_contig_memops;
 	video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	video->queue.dev = video->vsp1->dev;
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 50ea7f02205f..b63e14bbaef0 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -48,6 +48,11 @@ struct vsp1_video {
 	struct vb2_queue queue;
 	spinlock_t irqlock;
 	struct list_head irqqueue;
+
+	bool is_writeback;
+	struct list_head wbqueue;
+	struct vsp1_vb2_buffer *pending;
+	void (*frame_end)(struct vsp1_pipeline *pipe);
 };
 
 static inline struct vsp1_video *to_vsp1_video(struct video_device *vdev)
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 958e7f215a2b..9025e19e169e 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -248,6 +248,8 @@ static void wpf_configure(struct vsp1_entity *entity,
 	u32 outfmt = 0;
 	u32 srcrpf = 0;
 
+	bool writeback = pipe->lif && wpf->mem.addr[0];
+
 	if (params == VSP1_ENTITY_PARAMS_RUNTIME) {
 		const unsigned int mask = BIT(WPF_CTRL_VFLIP)
 					| BIT(WPF_CTRL_HFLIP);
@@ -299,7 +301,14 @@ static void wpf_configure(struct vsp1_entity *entity,
 			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
 			       (height << VI6_WPF_SZCLIP_SIZE_SHIFT));
 
-		if (pipe->lif)
+		vsp1_dl_list_write(dl, VI6_WPF_WRBCK_CTRL, writeback ?
+						VI6_WPF_WRBCK_CTRL_WBMD : 0);
+
+		/*
+		 * Display pipelines with no writeback memory do not configure
+		 * the write out address
+		 */
+		if (pipe->lif && !writeback)
 			return;
 
 		/*
@@ -384,7 +393,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 	}
 
 	/* Format */
-	if (!pipe->lif) {
+	if (!pipe->lif || writeback) {
 		const struct v4l2_pix_format_mplane *format = &wpf->format;
 		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
 
@@ -424,8 +433,6 @@ static void wpf_configure(struct vsp1_entity *entity,
 	vsp1_dl_list_write(dl, VI6_DPR_WPF_FPORCH(wpf->entity.index),
 			   VI6_DPR_WPF_FPORCH_FP_WPFN);
 
-	vsp1_dl_list_write(dl, VI6_WPF_WRBCK_CTRL, 0);
-
 	/* Sources. If the pipeline has a single input and BRU is not used,
 	 * configure it as the master layer. Otherwise configure all
 	 * inputs as sub-layers and select the virtual RPF as the master
@@ -493,6 +500,10 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	wpf->entity.type = VSP1_ENTITY_WPF;
 	wpf->entity.index = index;
 
+	/* WPFs with writeback support can output to the LIF and memory */
+	wpf->has_writeback = (vsp1->info->features & VSP1_HAS_WPF_WRITEBACK)
+			   && index == 0;
+
 	sprintf(name, "wpf.%u", index);
 	ret = vsp1_entity_init(vsp1, &wpf->entity, name, 2, &wpf_ops,
 			       MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER);
-- 
2.7.4

