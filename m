Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15650 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab0L1RDZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:03:25 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 28 Dec 2010 18:03:09 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 04/15] [media] s5p-fimc: Porting to videobuf 2
In-reply-to: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293555798-31578-5-git-send-email-s.nawrocki@samsung.com>
References: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Porting to videobuf 2 and minor cleanup.
Separate videobuf_queue_ops are are created for m2m
and capture video nodes.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig                 |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |  249 ++++++++++++++++++++++++---
 drivers/media/video/s5p-fimc/fimc-core.c    |  216 +++++++++++------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   48 ++---
 4 files changed, 349 insertions(+), 166 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 38fc077..819bb94 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1002,7 +1002,7 @@ config VIDEO_MEM2MEM_TESTDEV
 config  VIDEO_SAMSUNG_S5P_FIMC
 	tristate "Samsung S5P FIMC (video postprocessor) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
 	  This is a v4l2 driver for the S5P camera interface
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 2f50080..f829844 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -27,8 +27,8 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mem2mem.h>
-#include <media/videobuf-core.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
 
 #include "fimc-core.h"
 
@@ -141,7 +141,7 @@ static int fimc_isp_subdev_init(struct fimc_dev *fimc, int index)
  * Locking: The caller holds fimc->slock spinlock.
  */
 int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
-			     struct fimc_vid_buffer *fimc_vb)
+			   struct fimc_vid_buffer *fimc_vb)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_ctx *ctx = cap->ctx;
@@ -149,7 +149,7 @@ int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
 
 	BUG_ON(!fimc || !fimc_vb);
 
-	ret = fimc_prepare_addr(ctx, fimc_vb, &ctx->d_frame,
+	ret = fimc_prepare_addr(ctx, &fimc_vb->vb, &ctx->d_frame,
 				&fimc_vb->paddr);
 	if (ret)
 		return ret;
@@ -205,6 +205,206 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 	return 0;
 }
 
+static int start_streaming(struct vb2_queue *q)
+{
+	struct fimc_ctx *ctx = q->drv_priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct s3c_fimc_isp_info *isp_info;
+	int ret;
+
+	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
+	if (ret && ret != -ENOIOCTLCMD)
+		return ret;
+
+	ret = fimc_prepare_config(ctx, ctx->state);
+	if (ret)
+		return ret;
+
+	isp_info = fimc->pdata->isp_info[fimc->vid_cap.input_index];
+	fimc_hw_set_camera_type(fimc, isp_info);
+	fimc_hw_set_camera_source(fimc, isp_info);
+	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
+
+	if (ctx->state & FIMC_PARAMS) {
+		ret = fimc_set_scaler_info(ctx);
+		if (ret) {
+			err("Scaler setup error");
+			return ret;
+		}
+		fimc_hw_set_input_path(ctx);
+		fimc_hw_set_scaler(ctx);
+		fimc_hw_set_target_format(ctx);
+		fimc_hw_set_rotation(ctx);
+		fimc_hw_set_effect(ctx);
+	}
+
+	fimc_hw_set_output_path(ctx);
+	fimc_hw_set_out_dma(ctx);
+
+	INIT_LIST_HEAD(&fimc->vid_cap.pending_buf_q);
+	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
+	fimc->vid_cap.active_buf_cnt = 0;
+	fimc->vid_cap.frame_count = 0;
+	fimc->vid_cap.buf_index = fimc_hw_get_frame_index(fimc);
+
+	set_bit(ST_CAPT_PEND, &fimc->state);
+
+	return 0;
+}
+
+static int stop_streaming(struct vb2_queue *q)
+{
+	struct fimc_ctx *ctx = q->drv_priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	if (!fimc_capture_running(fimc) && !fimc_capture_pending(fimc)) {
+		spin_unlock_irqrestore(&fimc->slock, flags);
+		return -EINVAL;
+	}
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	return fimc_stop_capture(fimc);
+}
+
+static unsigned int get_plane_size(struct fimc_frame *frame, unsigned int plane)
+{
+	unsigned long size = 0;
+
+	if (!frame || plane > frame->fmt->buff_cnt - 1)
+		return 0;
+
+	if (1 == frame->fmt->planes_cnt) {
+		size = (frame->width * frame->height * frame->fmt->depth) >> 3;
+	} else if (frame->fmt->planes_cnt <= 3) {
+		switch (plane) {
+		case 0:
+			size = frame->width * frame->height;
+			break;
+		case 1:
+		case 2:
+			if (S5P_FIMC_YCBCR420 == frame->fmt->color
+				&& 2 != frame->fmt->planes_cnt)
+				size = (frame->width * frame->height) >> 2;
+			else /* 422 */
+				size = (frame->width * frame->height) >> 1;
+			break;
+		}
+	} else {
+		size = 0;
+	}
+
+	return size;
+}
+
+static int queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
+		       unsigned int *num_planes, unsigned long sizes[],
+		       void *allocators[])
+{
+	struct fimc_ctx *ctx = vq->drv_priv;
+	struct fimc_fmt *fmt =	fmt = ctx->d_frame.fmt;
+	struct fimc_frame *frame;
+
+	if (!fmt)
+		return -EINVAL;
+
+	*num_planes = fmt->buff_cnt;
+
+	dbg("%s, buffer count=%d, plane count=%d",
+	    __func__, *num_buffers, *num_planes);
+	
+	frame = ctx_get_frame(ctx, vq->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	sizes[0] = get_plane_size(frame, 0);
+	allocators[0] = ctx->fimc_dev->alloc_ctx;
+
+	return -EINVAL;
+}
+
+static int buffer_init(struct vb2_buffer *vb)
+{
+	/* TODO: */
+	return 0;
+}
+
+static int buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct fimc_ctx *ctx = vq->drv_priv;
+	struct v4l2_device *v4l2_dev = &ctx->fimc_dev->m2m.v4l2_dev;
+	struct fimc_frame *frame;
+	unsigned long size;
+	int i;
+
+	frame = ctx_get_frame(ctx, vq->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	for (i = 0; i < frame->fmt->buff_cnt; i++) {
+		size = get_plane_size(frame, i);
+
+		if (vb2_plane_size(vb, i) < size) {
+			v4l2_err(v4l2_dev, "User buffer too small (%ld < %ld)\n",
+				 vb2_plane_size(vb, i), size);
+			return -EINVAL;
+		}
+
+		vb2_set_plane_payload(vb, i, size);
+	}
+
+	return 0;
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_vid_buffer *buf
+		= container_of(vb, struct fimc_vid_buffer, vb);
+	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	fimc_vid_cap_buf_queue(fimc, buf);
+
+	dbg("active_buf_cnt: %d", fimc->vid_cap.active_buf_cnt);
+
+	if (vid_cap->active_buf_cnt >= vid_cap->reqbufs_count ||
+	   vid_cap->active_buf_cnt >= FIMC_MAX_OUT_BUFS) {
+		if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state)) {
+			fimc_activate_capture(ctx);
+			dbg("");
+		}
+	}
+	spin_unlock_irqrestore(&fimc->slock, flags);
+}
+
+static void fimc_lock(struct vb2_queue *vq)
+{
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_lock(&ctx->fimc_dev->lock);
+}
+
+static void fimc_unlock(struct vb2_queue *vq)
+{
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_unlock(&ctx->fimc_dev->lock);
+}
+
+static struct vb2_ops fimc_capture_qops = {
+	.queue_setup		= queue_setup,
+	.buf_prepare		= buffer_prepare,
+	.buf_queue		= buffer_queue,
+	.buf_init		= buffer_init,
+	.wait_prepare		= fimc_unlock,
+	.wait_finish		= fimc_lock,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+};
+
 static int fimc_capture_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
@@ -244,9 +444,8 @@ static int fimc_capture_close(struct file *file)
 
 	if (--fimc->vid_cap.refcnt == 0) {
 		fimc_stop_capture(fimc);
+		vb2_queue_release(&fimc->vid_cap.vbq);
 
-		videobuf_stop(&fimc->vid_cap.vbq);
-		videobuf_mmap_free(&fimc->vid_cap.vbq);
 
 		v4l2_err(&fimc->vid_cap.v4l2_dev, "releasing ISP\n");
 		v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
@@ -262,13 +461,12 @@ static unsigned int fimc_capture_poll(struct file *file,
 {
 	struct fimc_ctx *ctx = file->private_data;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	int ret;
 
 	if (mutex_lock_interruptible(&fimc->lock))
 		return POLLERR;
 
-	ret = videobuf_poll_stream(file, &cap->vbq, wait);
+	ret = vb2_poll(&fimc->vid_cap.vbq, file, wait);
 	mutex_unlock(&fimc->lock);
 
 	return ret;
@@ -278,13 +476,12 @@ static int fimc_capture_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct fimc_ctx *ctx = file->private_data;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	int ret;
 
 	if (mutex_lock_interruptible(&fimc->lock))
 		return -ERESTARTSYS;
 
-	ret = videobuf_mmap_mapper(&cap->vbq, vma);
+	ret = vb2_mmap(&fimc->vid_cap.vbq, vma);
 	mutex_unlock(&fimc->lock);
 
 	return ret;
@@ -470,7 +667,7 @@ static int fimc_cap_g_input(struct file *file, void *priv,
 }
 
 static int fimc_cap_streamon(struct file *file, void *priv,
-			   enum v4l2_buf_type type)
+			     enum v4l2_buf_type type)
 {
 	struct s3c_fimc_isp_info *isp_info;
 	struct fimc_ctx *ctx = priv;
@@ -525,7 +722,7 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	fimc->vid_cap.buf_index = fimc_hw_get_frame_index(fimc);
 
 	set_bit(ST_CAPT_PEND, &fimc->state);
-	ret = videobuf_streamon(&fimc->vid_cap.vbq);
+	ret = vb2_streamon(&fimc->vid_cap.vbq, type);
 
 s_unlock:
 	mutex_unlock(&fimc->lock);
@@ -533,7 +730,7 @@ s_unlock:
 }
 
 static int fimc_cap_streamoff(struct file *file, void *priv,
-			    enum v4l2_buf_type type)
+			      enum v4l2_buf_type type)
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
@@ -553,7 +750,8 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 		return -ERESTARTSYS;
 
 	fimc_stop_capture(fimc);
-	ret = videobuf_streamoff(&cap->vbq);
+	ret = vb2_streamoff(&cap->vbq, type);
+
 	mutex_unlock(&fimc->lock);
 	return ret;
 }
@@ -572,7 +770,7 @@ static int fimc_cap_reqbufs(struct file *file, void *priv,
 	if (mutex_lock_interruptible(&fimc->lock))
 		return -ERESTARTSYS;
 
-	ret = videobuf_reqbufs(&cap->vbq, reqbufs);
+	ret = vb2_reqbufs(&cap->vbq, reqbufs);
 	if (!ret)
 		cap->reqbufs_count = reqbufs->count;
 
@@ -589,7 +787,7 @@ static int fimc_cap_querybuf(struct file *file, void *priv,
 	if (fimc_capture_active(ctx->fimc_dev))
 		return -EBUSY;
 
-	return videobuf_querybuf(&cap->vbq, buf);
+	return vb2_querybuf(&cap->vbq, buf);
 }
 
 static int fimc_cap_qbuf(struct file *file, void *priv,
@@ -603,7 +801,7 @@ static int fimc_cap_qbuf(struct file *file, void *priv,
 	if (mutex_lock_interruptible(&fimc->lock))
 		return -ERESTARTSYS;
 
-	ret = videobuf_qbuf(&cap->vbq, buf);
+	ret = vb2_qbuf(&cap->vbq, buf);
 
 	mutex_unlock(&fimc->lock);
 	return ret;
@@ -618,7 +816,7 @@ static int fimc_cap_dqbuf(struct file *file, void *priv,
 	if (mutex_lock_interruptible(&ctx->fimc_dev->lock))
 		return -ERESTARTSYS;
 
-	ret = videobuf_dqbuf(&ctx->fimc_dev->vid_cap.vbq, buf,
+	ret = vb2_dqbuf(&ctx->fimc_dev->vid_cap.vbq, buf,
 		file->f_flags & O_NONBLOCK);
 
 	mutex_unlock(&ctx->fimc_dev->lock);
@@ -777,6 +975,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	struct fimc_vid_cap *vid_cap;
 	struct fimc_ctx *ctx;
 	struct v4l2_format f;
+	struct vb2_queue *q;
 	int ret;
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
@@ -827,10 +1026,16 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	spin_lock_init(&ctx->slock);
 	vid_cap->ctx = ctx;
 
-	videobuf_queue_dma_contig_init(&vid_cap->vbq, &fimc_qops,
-		vid_cap->v4l2_dev.dev, &fimc->irqlock,
-		V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-		sizeof(struct fimc_vid_buffer), (void *)ctx, NULL);
+	q = &fimc->vid_cap.vbq;
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = fimc->vid_cap.ctx;
+	q->ops = &fimc_capture_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct fimc_vid_buffer);
+
+	vb2_queue_init(q);
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret) {
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 817aa66..65d25b3 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -25,7 +25,8 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
 
 #include "fimc-core.h"
 
@@ -283,7 +284,7 @@ static void fimc_capture_handler(struct fimc_dev *fimc)
 
 	if (!list_empty(&cap->active_buf_q)) {
 		v_buf = active_queue_pop(cap);
-		fimc_buf_finish(fimc, v_buf);
+		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
 	}
 
 	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
@@ -300,10 +301,6 @@ static void fimc_capture_handler(struct fimc_dev *fimc)
 		dbg("hw ptr: %d, sw ptr: %d",
 		    fimc_hw_get_frame_index(fimc), cap->buf_index);
 
-		spin_lock(&fimc->irqlock);
-		v_buf->vb.state = VIDEOBUF_ACTIVE;
-		spin_unlock(&fimc->irqlock);
-
 		/* Move the buffer to the capture active queue */
 		active_queue_add(cap, v_buf);
 
@@ -324,8 +321,6 @@ static void fimc_capture_handler(struct fimc_dev *fimc)
 
 static irqreturn_t fimc_isr(int irq, void *priv)
 {
-	struct fimc_vid_buffer *src_buf, *dst_buf;
-	struct fimc_ctx *ctx;
 	struct fimc_dev *fimc = priv;
 
 	BUG_ON(!fimc);
@@ -334,17 +329,17 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 	spin_lock(&fimc->slock);
 
 	if (test_and_clear_bit(ST_M2M_PEND, &fimc->state)) {
-		ctx = v4l2_m2m_get_curr_priv(fimc->m2m.m2m_dev);
+		struct vb2_buffer *src_vb, *dst_vb;
+		struct fimc_ctx *ctx = v4l2_m2m_get_curr_priv(fimc->m2m.m2m_dev);
+
 		if (!ctx || !ctx->m2m_ctx)
 			goto isr_unlock;
-		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
-		if (src_buf && dst_buf) {
-			spin_lock(&fimc->irqlock);
-			src_buf->vb.state = dst_buf->vb.state = VIDEOBUF_DONE;
-			wake_up(&src_buf->vb.done);
-			wake_up(&dst_buf->vb.done);
-			spin_unlock(&fimc->irqlock);
+
+		src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+		if (src_vb && dst_vb) {
+			v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
+			v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
 			v4l2_m2m_job_finish(fimc->m2m.m2m_dev, ctx->m2m_ctx);
 		}
 		goto isr_unlock;
@@ -365,13 +360,13 @@ isr_unlock:
 }
 
 /* The color format (planes_cnt, buff_cnt) must be already configured. */
-int fimc_prepare_addr(struct fimc_ctx *ctx, struct fimc_vid_buffer *buf,
+int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr)
 {
 	int ret = 0;
 	u32 pix_size;
 
-	if (buf == NULL || frame == NULL)
+	if (vb == NULL || frame == NULL)
 		return -EINVAL;
 
 	pix_size = frame->width * frame->height;
@@ -381,7 +376,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct fimc_vid_buffer *buf,
 		frame->size, pix_size);
 
 	if (frame->fmt->buff_cnt == 1) {
-		paddr->y = videobuf_to_dma_contig(&buf->vb);
+		paddr->y = vb2_dma_contig_plane_paddr(vb, 0);
 		switch (frame->fmt->planes_cnt) {
 		case 1:
 			paddr->cb = 0;
@@ -499,7 +494,7 @@ static void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
 {
 	struct fimc_frame *s_frame, *d_frame;
-	struct fimc_vid_buffer *buf = NULL;
+	struct vb2_buffer *vb = NULL;
 	int ret = 0;
 
 	s_frame = &ctx->s_frame;
@@ -522,15 +517,15 @@ int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
 	ctx->scaler.enabled = 1;
 
 	if (flags & FIMC_SRC_ADDR) {
-		buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-		ret = fimc_prepare_addr(ctx, buf, s_frame, &s_frame->paddr);
+		vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+		ret = fimc_prepare_addr(ctx, vb, s_frame, &s_frame->paddr);
 		if (ret)
 			return ret;
 	}
 
 	if (flags & FIMC_DST_ADDR) {
-		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-		ret = fimc_prepare_addr(ctx, buf, d_frame, &d_frame->paddr);
+		vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+		ret = fimc_prepare_addr(ctx, vb, d_frame, &d_frame->paddr);
 	}
 
 	return ret;
@@ -587,7 +582,8 @@ static void fimc_dma_run(void *priv)
 
 	fimc_activate_capture(ctx);
 
-	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP);
+	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP |
+		       FIMC_SRC_FMT | FIMC_DST_FMT);
 	fimc_hw_activate_input_dma(fimc, true);
 
 dma_unlock:
@@ -599,106 +595,72 @@ static void fimc_job_abort(void *priv)
 	/* Nothing done in job_abort. */
 }
 
-static void fimc_buf_release(struct videobuf_queue *vq,
-				    struct videobuf_buffer *vb)
+static int fimc_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
+		       unsigned int *num_planes, unsigned long sizes[],
+		       void *allocators[])
 {
-	videobuf_dma_contig_free(vq, vb);
-	vb->state = VIDEOBUF_NEEDS_INIT;
-}
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
+	struct fimc_frame *fr;
 
-static int fimc_buf_setup(struct videobuf_queue *vq, unsigned int *count,
-				unsigned int *size)
-{
-	struct fimc_ctx *ctx = vq->priv_data;
-	struct fimc_frame *frame;
+	fr = ctx_get_frame(ctx, vq->type);
+	if (IS_ERR(fr))
+		return PTR_ERR(fr);
 
-	frame = ctx_get_frame(ctx, vq->type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
+	*num_planes = 1;
+
+	sizes[0] = (fr->width * fr->height * fr->fmt->depth) >> 3;
+	allocators[0] = ctx->fimc_dev->alloc_ctx;
 
-	*size = (frame->width * frame->height * frame->fmt->depth) >> 3;
-	if (0 == *count)
-		*count = 1;
 	return 0;
 }
 
-static int fimc_buf_prepare(struct videobuf_queue *vq,
-		struct videobuf_buffer *vb, enum v4l2_field field)
+static int fimc_buf_prepare(struct vb2_buffer *vb)
 {
-	struct fimc_ctx *ctx = vq->priv_data;
-	struct v4l2_device *v4l2_dev = &ctx->fimc_dev->m2m.v4l2_dev;
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct fimc_frame *frame;
-	int ret;
 
-	frame = ctx_get_frame(ctx, vq->type);
+	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
-	if (vb->baddr) {
-		if (vb->bsize < frame->size) {
-			v4l2_err(v4l2_dev,
-				"User-provided buffer too small (%d < %d)\n",
-				 vb->bsize, frame->size);
-			WARN_ON(1);
-			return -EINVAL;
-		}
-	} else if (vb->state != VIDEOBUF_NEEDS_INIT
-		   && vb->bsize < frame->size) {
+	if (vb2_plane_size(vb, 0) < frame->size) {
+		dbg("%s data will not fit into plane (%lu < %lu)\n",
+				__func__, vb2_plane_size(vb, 0), (long)frame->size);
 		return -EINVAL;
 	}
 
-	vb->width       = frame->width;
-	vb->height      = frame->height;
-	vb->bytesperline = (frame->width * frame->fmt->depth) >> 3;
-	vb->size        = frame->size;
-	vb->field       = field;
-
-	if (VIDEOBUF_NEEDS_INIT == vb->state) {
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret) {
-			v4l2_err(v4l2_dev, "Iolock failed\n");
-			fimc_buf_release(vq, vb);
-			return ret;
-		}
-	}
-	vb->state = VIDEOBUF_PREPARED;
-
+	vb2_set_plane_payload(vb, 0, frame->size);
 	return 0;
 }
 
-static void fimc_buf_queue(struct videobuf_queue *vq,
-				  struct videobuf_buffer *vb)
+static void fimc_buf_queue(struct vb2_buffer *vb)
 {
-	struct fimc_ctx *ctx = vq->priv_data;
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_vid_cap *cap = &fimc->vid_cap;
-	unsigned long flags;
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
 	dbg("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
 
-	if ((ctx->state & FIMC_CTX_M2M) && ctx->m2m_ctx) {
-		v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
-	} else if (ctx->state & FIMC_CTX_CAP) {
-		spin_lock_irqsave(&fimc->slock, flags);
-		fimc_vid_cap_buf_queue(fimc, (struct fimc_vid_buffer *)vb);
+	if (ctx->m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+}
 
-		dbg("fimc->cap.active_buf_cnt: %d",
-		    fimc->vid_cap.active_buf_cnt);
+static void fimc_lock(struct vb2_queue *vq)
+{
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_lock(&ctx->fimc_dev->lock);
+}
 
-		if (cap->active_buf_cnt >= cap->reqbufs_count ||
-		   cap->active_buf_cnt >= FIMC_MAX_OUT_BUFS) {
-			if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
-				fimc_activate_capture(ctx);
-		}
-		spin_unlock_irqrestore(&fimc->slock, flags);
-	}
+static void fimc_unlock(struct vb2_queue *vq)
+{
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_unlock(&ctx->fimc_dev->lock);
 }
 
-struct videobuf_queue_ops fimc_qops = {
-	.buf_setup	= fimc_buf_setup,
-	.buf_prepare	= fimc_buf_prepare,
-	.buf_queue	= fimc_buf_queue,
-	.buf_release	= fimc_buf_release,
+struct vb2_ops fimc_qops = {
+	.queue_setup	 = fimc_queue_setup,
+	.buf_prepare	 = fimc_buf_prepare,
+	.buf_queue	 = fimc_buf_queue,
+	.wait_prepare	 = fimc_unlock,
+	.wait_finish	 = fimc_lock,
 };
 
 static int fimc_m2m_querycap(struct file *file, void *priv,
@@ -867,7 +829,7 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct v4l2_device *v4l2_dev = &fimc->m2m.v4l2_dev;
-	struct videobuf_queue *vq;
+	struct vb2_queue *vq;
 	struct fimc_frame *frame;
 	struct v4l2_pix_format *pix;
 	unsigned long flags;
@@ -881,9 +843,8 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		return -ERESTARTSYS;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-	mutex_lock(&vq->vb_lock);
 
-	if (videobuf_queue_is_busy(vq)) {
+	if (vb2_is_streaming(vq)) {
 		v4l2_err(v4l2_dev, "%s: queue (%d) busy\n", __func__, f->type);
 		ret = -EBUSY;
 		goto sf_out;
@@ -921,7 +882,6 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	frame->offs_h	= 0;
 	frame->offs_v	= 0;
 	frame->size	= (pix->width * pix->height * frame->fmt->depth) >> 3;
-	vq->field	= pix->field;
 
 	spin_lock_irqsave(&ctx->slock, flags);
 	ctx->state |= FIMC_PARAMS;
@@ -930,7 +890,6 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
 
 sf_out:
-	mutex_unlock(&vq->vb_lock);
 	mutex_unlock(&fimc->lock);
 	return ret;
 }
@@ -968,6 +927,11 @@ static int fimc_m2m_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
 {
 	struct fimc_ctx *ctx = priv;
+
+	/* The source and target color format need to be set */
+	if (~ctx->state & (FIMC_DST_FMT | FIMC_SRC_FMT))
+		return -EINVAL;
+
 	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
 }
 
@@ -1301,16 +1265,32 @@ static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 
 };
 
-static void queue_init(void *priv, struct videobuf_queue *vq,
-		       enum v4l2_buf_type type)
+static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
 {
 	struct fimc_ctx *ctx = priv;
-	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->drv_priv = ctx;
+	src_vq->ops = &fimc_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 
-	videobuf_queue_dma_contig_init(vq, &fimc_qops,
-		&fimc->pdev->dev,
-		&fimc->irqlock, type, V4L2_FIELD_NONE,
-		sizeof(struct fimc_vid_buffer), priv, NULL);
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->drv_priv = ctx;
+	dst_vq->ops = &fimc_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	return vb2_queue_init(dst_vq);
 }
 
 static int fimc_m2m_open(struct file *file)
@@ -1355,7 +1335,7 @@ static int fimc_m2m_open(struct file *file)
 	ctx->out_path = FIMC_DMA;
 	spin_lock_init(&ctx->slock);
 
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(ctx, fimc->m2m.m2m_dev, queue_init);
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
 		err = PTR_ERR(ctx->m2m_ctx);
 		kfree(ctx);
@@ -1415,7 +1395,6 @@ static struct v4l2_m2m_ops m2m_ops = {
 	.job_abort	= fimc_job_abort,
 };
 
-
 static int fimc_register_m2m_device(struct fimc_dev *fimc)
 {
 	struct video_device *vfd;
@@ -1548,7 +1527,6 @@ static int fimc_probe(struct platform_device *pdev)
 	fimc->pdata = pdev->dev.platform_data;
 	fimc->state = ST_IDLE;
 
-	spin_lock_init(&fimc->irqlock);
 	init_waitqueue_head(&fimc->irq_queue);
 	spin_lock_init(&fimc->slock);
 
@@ -1597,6 +1575,13 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
+	/* Initialize contiguous memory allocator */
+	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&fimc->pdev->dev);
+	if (IS_ERR(fimc->alloc_ctx)) {
+		ret = PTR_ERR(fimc->alloc_ctx);
+		goto err_irq;
+	}
+
 	ret = fimc_register_m2m_device(fimc);
 	if (ret)
 		goto err_irq;
@@ -1656,6 +1641,9 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	fimc_unregister_capture_device(fimc);
 
 	fimc_clk_release(fimc);
+
+	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
+
 	iounmap(fimc->regs);
 	release_resource(fimc->regs_res);
 	kfree(fimc->regs_res);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 4f047d35..590fbf2 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -16,7 +16,8 @@
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
-#include <media/videobuf-core.h>
+#include <linux/io.h>
+#include <media/videobuf2-core.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-mediabus.h>
@@ -70,13 +71,6 @@ enum fimc_dev_flags {
 #define fimc_capture_streaming(dev) \
 	test_bit(ST_CAPT_STREAM, &(dev)->state)
 
-#define fimc_buf_finish(dev, vid_buf) do { \
-	spin_lock(&(dev)->irqlock); \
-	(vid_buf)->vb.state = VIDEOBUF_DONE; \
-	spin_unlock(&(dev)->irqlock); \
-	wake_up(&(vid_buf)->vb.done); \
-} while (0)
-
 enum fimc_datapath {
 	FIMC_CAMERA,
 	FIMC_DMA,
@@ -260,7 +254,8 @@ struct fimc_addr {
  * @index: buffer index for the output DMA engine
  */
 struct fimc_vid_buffer {
-	struct videobuf_buffer	vb;
+	struct vb2_buffer	vb;
+	struct list_head	list;
 	struct fimc_addr	paddr;
 	int			index;
 };
@@ -331,13 +326,14 @@ struct fimc_m2m_device {
  */
 struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
+	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		*vfd;
 	struct v4l2_device		v4l2_dev;
-	struct v4l2_subdev		*sd;
+	struct v4l2_subdev		*sd;;
 	struct v4l2_mbus_framefmt	fmt;
 	struct list_head		pending_buf_q;
 	struct list_head		active_buf_q;
-	struct videobuf_queue		vbq;
+	struct vb2_queue		vbq;
 	int				active_buf_cnt;
 	int				buf_index;
 	unsigned int			frame_count;
@@ -417,7 +413,6 @@ struct fimc_ctx;
  * @regs:	the mapped hardware registers
  * @regs_res:	the resource claimed for IO registers
  * @irq:	interrupt number of the FIMC subdevice
- * @irqlock:	spinlock protecting videobuffer queue
  * @irq_queue:
  * @m2m:	memory-to-memory V4L2 device information
  * @vid_cap:	camera capture device information
@@ -434,11 +429,11 @@ struct fimc_dev {
 	void __iomem			*regs;
 	struct resource			*regs_res;
 	int				irq;
-	spinlock_t			irqlock;
 	wait_queue_head_t		irq_queue;
 	struct fimc_m2m_device		m2m;
 	struct fimc_vid_cap		vid_cap;
 	unsigned long			state;
+	struct vb2_alloc_ctx		*alloc_ctx;
 };
 
 /**
@@ -482,8 +477,6 @@ struct fimc_ctx {
 	struct v4l2_m2m_ctx	*m2m_ctx;
 };
 
-extern struct videobuf_queue_ops fimc_qops;
-
 static inline int tiled_fmt(struct fimc_fmt *fmt)
 {
 	return 0;
@@ -622,7 +615,7 @@ struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
 int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f);
 int fimc_set_scaler_info(struct fimc_ctx *ctx);
 int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
-int fimc_prepare_addr(struct fimc_ctx *ctx, struct fimc_vid_buffer *buf,
+int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr);
 
 /* -----------------------------------------------------*/
@@ -649,28 +642,27 @@ static inline void fimc_deactivate_capture(struct fimc_dev *fimc)
 }
 
 /*
- * Add video buffer to the active buffers queue.
- * The caller holds irqlock spinlock.
+ * Add buf to the capture active buffers queue.
+ * Locking: Need to be called with fimc_dev::slock held.
  */
 static inline void active_queue_add(struct fimc_vid_cap *vid_cap,
-					 struct fimc_vid_buffer *buf)
+				    struct fimc_vid_buffer *buf)
 {
-	buf->vb.state = VIDEOBUF_ACTIVE;
-	list_add_tail(&buf->vb.queue, &vid_cap->active_buf_q);
+	list_add_tail(&buf->list, &vid_cap->active_buf_q);
 	vid_cap->active_buf_cnt++;
 }
 
 /*
  * Pop a video buffer from the capture active buffers queue
- * Locking: Need to be called with dev->slock held.
+ * Locking: Need to be called with fimc_dev::slock held.
  */
 static inline struct fimc_vid_buffer *
 active_queue_pop(struct fimc_vid_cap *vid_cap)
 {
 	struct fimc_vid_buffer *buf;
 	buf = list_entry(vid_cap->active_buf_q.next,
-			 struct fimc_vid_buffer, vb.queue);
-	list_del(&buf->vb.queue);
+			 struct fimc_vid_buffer, list);
+	list_del(&buf->list);
 	vid_cap->active_buf_cnt--;
 	return buf;
 }
@@ -679,8 +671,7 @@ active_queue_pop(struct fimc_vid_cap *vid_cap)
 static inline void fimc_pending_queue_add(struct fimc_vid_cap *vid_cap,
 					  struct fimc_vid_buffer *buf)
 {
-	buf->vb.state = VIDEOBUF_QUEUED;
-	list_add_tail(&buf->vb.queue, &vid_cap->pending_buf_q);
+	list_add_tail(&buf->list, &vid_cap->pending_buf_q);
 }
 
 /* Add video buffer to the capture pending buffers queue */
@@ -689,10 +680,9 @@ pending_queue_pop(struct fimc_vid_cap *vid_cap)
 {
 	struct fimc_vid_buffer *buf;
 	buf = list_entry(vid_cap->pending_buf_q.next,
-			struct fimc_vid_buffer, vb.queue);
-	list_del(&buf->vb.queue);
+			struct fimc_vid_buffer, list);
+	list_del(&buf->list);
 	return buf;
 }
 
-
 #endif /* FIMC_CORE_H_ */
-- 
1.7.2.3

