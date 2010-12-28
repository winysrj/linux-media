Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15650 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab0L1RDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:03:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 28 Dec 2010 18:03:07 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 02/15] v4l: mem2mem: port m2m_testdev to vb2
In-reply-to: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293555798-31578-3-git-send-email-s.nawrocki@samsung.com>
References: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch ports mem2mem test device to videobuf2 framework.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/Kconfig           |    2 +-
 drivers/media/video/mem2mem_testdev.c |  227 +++++++++++++++-----------------
 2 files changed, 107 insertions(+), 122 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 8e5116e..38fc077 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -992,7 +992,7 @@ if V4L_MEM2MEM_DRIVERS
 config VIDEO_MEM2MEM_TESTDEV
 	tristate "Virtual test device for mem2mem framework"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	select VIDEOBUF_VMALLOC
+	select VIDEOBUF2_VMALLOC
 	select V4L2_MEM2MEM_DEV
 	default n
 	---help---
diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index c179041..6ab2d4f 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -28,7 +28,7 @@
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf-vmalloc.h>
+#include <media/videobuf2-vmalloc.h>
 
 #define MEM2MEM_TEST_MODULE_NAME "mem2mem-testdev"
 
@@ -201,11 +201,6 @@ struct m2mtest_ctx {
 	struct v4l2_m2m_ctx	*m2m_ctx;
 };
 
-struct m2mtest_buffer {
-	/* vb must be first! */
-	struct videobuf_buffer	vb;
-};
-
 static struct v4l2_queryctrl *get_ctrl(int id)
 {
 	int i;
@@ -219,37 +214,41 @@ static struct v4l2_queryctrl *get_ctrl(int id)
 }
 
 static int device_process(struct m2mtest_ctx *ctx,
-			  struct m2mtest_buffer *in_buf,
-			  struct m2mtest_buffer *out_buf)
+			  struct vb2_buffer *in_vb,
+			  struct vb2_buffer *out_vb)
 {
 	struct m2mtest_dev *dev = ctx->dev;
+	struct m2mtest_q_data *q_data;
 	u8 *p_in, *p_out;
 	int x, y, t, w;
 	int tile_w, bytes_left;
-	struct videobuf_queue *src_q;
-	struct videobuf_queue *dst_q;
+	int width, height, bytesperline;
 
-	src_q = v4l2_m2m_get_src_vq(ctx->m2m_ctx);
-	dst_q = v4l2_m2m_get_dst_vq(ctx->m2m_ctx);
-	p_in = videobuf_queue_to_vaddr(src_q, &in_buf->vb);
-	p_out = videobuf_queue_to_vaddr(dst_q, &out_buf->vb);
+	q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_OUTPUT);
+
+	width	= q_data->width;
+	height	= q_data->height;
+	bytesperline	= (q_data->width * q_data->fmt->depth) >> 3;
+
+	p_in = vb2_plane_vaddr(in_vb, 0);
+	p_out = vb2_plane_vaddr(out_vb, 0);
 	if (!p_in || !p_out) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
 		return -EFAULT;
 	}
 
-	if (in_buf->vb.size > out_buf->vb.size) {
+	if (vb2_plane_size(in_vb, 0) > vb2_plane_size(out_vb, 0)) {
 		v4l2_err(&dev->v4l2_dev, "Output buffer is too small\n");
 		return -EINVAL;
 	}
 
-	tile_w = (in_buf->vb.width * (q_data[V4L2_M2M_DST].fmt->depth >> 3))
+	tile_w = (width * (q_data[V4L2_M2M_DST].fmt->depth >> 3))
 		/ MEM2MEM_NUM_TILES;
-	bytes_left = in_buf->vb.bytesperline - tile_w * MEM2MEM_NUM_TILES;
+	bytes_left = bytesperline - tile_w * MEM2MEM_NUM_TILES;
 	w = 0;
 
-	for (y = 0; y < in_buf->vb.height; ++y) {
+	for (y = 0; y < height; ++y) {
 		for (t = 0; t < MEM2MEM_NUM_TILES; ++t) {
 			if (w & 0x1) {
 				for (x = 0; x < tile_w; ++x)
@@ -301,6 +300,21 @@ static void job_abort(void *priv)
 	ctx->aborting = 1;
 }
 
+static void m2mtest_lock(void *priv)
+{
+	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_dev *dev = ctx->dev;
+	mutex_lock(&dev->dev_mutex);
+}
+
+static void m2mtest_unlock(void *priv)
+{
+	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_dev *dev = ctx->dev;
+	mutex_unlock(&dev->dev_mutex);
+}
+
+
 /* device_run() - prepares and starts the device
  *
  * This simulates all the immediate preparations required before starting
@@ -311,7 +325,7 @@ static void device_run(void *priv)
 {
 	struct m2mtest_ctx *ctx = priv;
 	struct m2mtest_dev *dev = ctx->dev;
-	struct m2mtest_buffer *src_buf, *dst_buf;
+	struct vb2_buffer *src_buf, *dst_buf;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
@@ -322,12 +336,11 @@ static void device_run(void *priv)
 	schedule_irq(dev, ctx->transtime);
 }
 
-
 static void device_isr(unsigned long priv)
 {
 	struct m2mtest_dev *m2mtest_dev = (struct m2mtest_dev *)priv;
 	struct m2mtest_ctx *curr_ctx;
-	struct m2mtest_buffer *src_buf, *dst_buf;
+	struct vb2_buffer *src_vb, *dst_vb;
 	unsigned long flags;
 
 	curr_ctx = v4l2_m2m_get_curr_priv(m2mtest_dev->m2m_dev);
@@ -338,31 +351,26 @@ static void device_isr(unsigned long priv)
 		return;
 	}
 
-	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
-	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
+	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
+
 	curr_ctx->num_processed++;
 
+	spin_lock_irqsave(&m2mtest_dev->irqlock, flags);
+	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
+	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
+	spin_unlock_irqrestore(&m2mtest_dev->irqlock, flags);
+
 	if (curr_ctx->num_processed == curr_ctx->translen
 	    || curr_ctx->aborting) {
 		dprintk(curr_ctx->dev, "Finishing transaction\n");
 		curr_ctx->num_processed = 0;
-		spin_lock_irqsave(&m2mtest_dev->irqlock, flags);
-		src_buf->vb.state = dst_buf->vb.state = VIDEOBUF_DONE;
-		wake_up(&src_buf->vb.done);
-		wake_up(&dst_buf->vb.done);
-		spin_unlock_irqrestore(&m2mtest_dev->irqlock, flags);
 		v4l2_m2m_job_finish(m2mtest_dev->m2m_dev, curr_ctx->m2m_ctx);
 	} else {
-		spin_lock_irqsave(&m2mtest_dev->irqlock, flags);
-		src_buf->vb.state = dst_buf->vb.state = VIDEOBUF_DONE;
-		wake_up(&src_buf->vb.done);
-		wake_up(&dst_buf->vb.done);
-		spin_unlock_irqrestore(&m2mtest_dev->irqlock, flags);
 		device_run(curr_ctx);
 	}
 }
 
-
 /*
  * video ioctls
  */
@@ -423,7 +431,7 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 
 static int vidioc_g_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 {
-	struct videobuf_queue *vq;
+	struct vb2_queue *vq;
 	struct m2mtest_q_data *q_data;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
@@ -434,7 +442,7 @@ static int vidioc_g_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 
 	f->fmt.pix.width	= q_data->width;
 	f->fmt.pix.height	= q_data->height;
-	f->fmt.pix.field	= vq->field;
+	f->fmt.pix.field	= V4L2_FIELD_NONE;
 	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
 	f->fmt.pix.bytesperline	= (q_data->width * q_data->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage	= q_data->sizeimage;
@@ -523,7 +531,7 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 {
 	struct m2mtest_q_data *q_data;
-	struct videobuf_queue *vq;
+	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
 	if (!vq)
@@ -533,7 +541,7 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 	if (!q_data)
 		return -EINVAL;
 
-	if (videobuf_queue_is_busy(vq)) {
+	if (vb2_is_busy(vq)) {
 		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
 		return -EBUSY;
 	}
@@ -543,7 +551,6 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 	q_data->height		= f->fmt.pix.height;
 	q_data->sizeimage	= q_data->width * q_data->height
 				* q_data->fmt->depth >> 3;
-	vq->field		= f->fmt.pix.field;
 
 	dprintk(ctx->dev,
 		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
@@ -733,120 +740,94 @@ static const struct v4l2_ioctl_ops m2mtest_ioctl_ops = {
  * Queue operations
  */
 
-static void m2mtest_buf_release(struct videobuf_queue *vq,
-				struct videobuf_buffer *vb)
-{
-	struct m2mtest_ctx *ctx = vq->priv_data;
-
-	dprintk(ctx->dev, "type: %d, index: %d, state: %d\n",
-		vq->type, vb->i, vb->state);
-
-	videobuf_vmalloc_free(vb);
-	vb->state = VIDEOBUF_NEEDS_INIT;
-}
-
-static int m2mtest_buf_setup(struct videobuf_queue *vq, unsigned int *count,
-			  unsigned int *size)
+static int m2mtest_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
+				unsigned int *nplanes, unsigned long sizes[],
+				void *alloc_ctxs[])
 {
-	struct m2mtest_ctx *ctx = vq->priv_data;
+	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vq);
 	struct m2mtest_q_data *q_data;
+	unsigned int size, count = *nbuffers;
 
 	q_data = get_q_data(vq->type);
 
-	*size = q_data->width * q_data->height * q_data->fmt->depth >> 3;
-	dprintk(ctx->dev, "size:%d, w/h %d/%d, depth: %d\n",
-		*size, q_data->width, q_data->height, q_data->fmt->depth);
+	size = q_data->width * q_data->height * q_data->fmt->depth >> 3;
 
-	if (0 == *count)
-		*count = MEM2MEM_DEF_NUM_BUFS;
+	while (size * count > MEM2MEM_VID_MEM_LIMIT)
+		(count)--;
 
-	while (*size * *count > MEM2MEM_VID_MEM_LIMIT)
-		(*count)--;
+	*nplanes = 1;
+	*nbuffers = count;
+	sizes[0] = size;
 
-	v4l2_info(&ctx->dev->v4l2_dev,
-		  "%d buffers of size %d set up.\n", *count, *size);
+	/*
+	 * videobuf2-vmalloc allocator is context-less so no need to set
+	 * alloc_ctxs array.
+	 */
+
+	dprintk(ctx->dev, "get %d buffer(s) of size %d each.\n", count, size);
 
 	return 0;
 }
 
-static int m2mtest_buf_prepare(struct videobuf_queue *vq,
-			       struct videobuf_buffer *vb,
-			       enum v4l2_field field)
+static int m2mtest_buf_prepare(struct vb2_buffer *vb)
 {
-	struct m2mtest_ctx *ctx = vq->priv_data;
+	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct m2mtest_q_data *q_data;
-	int ret;
 
-	dprintk(ctx->dev, "type: %d, index: %d, state: %d\n",
-		vq->type, vb->i, vb->state);
+	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
 
-	q_data = get_q_data(vq->type);
+	q_data = get_q_data(vb->vb2_queue->type);
 
-	if (vb->baddr) {
-		/* User-provided buffer */
-		if (vb->bsize < q_data->sizeimage) {
-			/* Buffer too small to fit a frame */
-			v4l2_err(&ctx->dev->v4l2_dev,
-				 "User-provided buffer too small\n");
-			return -EINVAL;
-		}
-	} else if (vb->state != VIDEOBUF_NEEDS_INIT
-			&& vb->bsize < q_data->sizeimage) {
-		/* We provide the buffer, but it's already been initialized
-		 * and is too small */
+	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
+		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
+				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
 		return -EINVAL;
 	}
 
-	vb->width	= q_data->width;
-	vb->height	= q_data->height;
-	vb->bytesperline = (q_data->width * q_data->fmt->depth) >> 3;
-	vb->size	= q_data->sizeimage;
-	vb->field	= field;
-
-	if (VIDEOBUF_NEEDS_INIT == vb->state) {
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret) {
-			v4l2_err(&ctx->dev->v4l2_dev,
-				 "Iolock failed\n");
-			goto fail;
-		}
-	}
-
-	vb->state = VIDEOBUF_PREPARED;
+	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
 
 	return 0;
-fail:
-	m2mtest_buf_release(vq, vb);
-	return ret;
 }
 
-static void m2mtest_buf_queue(struct videobuf_queue *vq,
-			   struct videobuf_buffer *vb)
+static void m2mtest_buf_queue(struct vb2_buffer *vb)
 {
-	struct m2mtest_ctx *ctx = vq->priv_data;
-
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
+	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
 }
 
-static struct videobuf_queue_ops m2mtest_qops = {
-	.buf_setup	= m2mtest_buf_setup,
-	.buf_prepare	= m2mtest_buf_prepare,
-	.buf_queue	= m2mtest_buf_queue,
-	.buf_release	= m2mtest_buf_release,
+static struct vb2_ops m2mtest_qops = {
+	.queue_setup	 = m2mtest_queue_setup,
+	.buf_prepare	 = m2mtest_buf_prepare,
+	.buf_queue	 = m2mtest_buf_queue,
 };
 
-static void queue_init(void *priv, struct videobuf_queue *vq,
-		       enum v4l2_buf_type type)
+static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
 {
 	struct m2mtest_ctx *ctx = priv;
-	struct m2mtest_dev *dev = ctx->dev;
+	int ret;
 
-	videobuf_queue_vmalloc_init(vq, &m2mtest_qops, dev->v4l2_dev.dev,
-				    &dev->irqlock, type, V4L2_FIELD_NONE,
-				    sizeof(struct m2mtest_buffer), priv,
-				    &dev->dev_mutex);
-}
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->io_modes = VB2_MMAP;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->ops = &m2mtest_qops;
+	src_vq->mem_ops = &vb2_vmalloc_memops;
 
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->io_modes = VB2_MMAP;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops = &m2mtest_qops;
+	dst_vq->mem_ops = &vb2_vmalloc_memops;
+
+	return vb2_queue_init(dst_vq);
+}
 
 /*
  * File operations
@@ -866,7 +847,8 @@ static int m2mtest_open(struct file *file)
 	ctx->transtime = MEM2MEM_DEF_TRANSTIME;
 	ctx->num_processed = 0;
 
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(ctx, dev->m2m_dev, queue_init);
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
+
 	if (IS_ERR(ctx->m2m_ctx)) {
 		int ret = PTR_ERR(ctx->m2m_ctx);
 
@@ -932,6 +914,8 @@ static struct v4l2_m2m_ops m2m_ops = {
 	.device_run	= device_run,
 	.job_ready	= job_ready,
 	.job_abort	= job_abort,
+	.lock		= m2mtest_lock,
+	.unlock		= m2mtest_unlock,
 };
 
 static int m2mtest_probe(struct platform_device *pdev)
@@ -990,6 +974,7 @@ static int m2mtest_probe(struct platform_device *pdev)
 
 	return 0;
 
+	v4l2_m2m_release(dev->m2m_dev);
 err_m2m:
 	video_unregister_device(dev->vfd);
 rel_vdev:
-- 
1.7.2.3

