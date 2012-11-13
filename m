Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52877 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2KMLyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 06:54:15 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] sh_vou: Move from videobuf to videobuf2
Date: Tue, 13 Nov 2012 12:55:06 +0100
Message-Id: <1352807706-11984-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/Kconfig  |    2 +-
 drivers/media/platform/sh_vou.c |  281 ++++++++++++++-------------------------
 2 files changed, 103 insertions(+), 180 deletions(-)

The patch has been compile-tested only as I lack test hardware. Consequently
that of, I haven't been able to verify whether sh_vou_stop_streaming() needs
to wait until the active buffer completes.

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 181c768..c53a9ff 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -37,7 +37,7 @@ config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on MEDIA_CAMERA_SUPPORT
 	depends on VIDEO_DEV && ARCH_SHMOBILE
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_CONTIG
 	help
 	  Support for the Video Output Unit (VOU) on SuperH SoCs.
 
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index b65e2c0..795cd76 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -27,7 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mediabus.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/videobuf2-dma-contig.h>
 
 /* Mirror addresses are not available for all registers */
 #define VOUER	0
@@ -60,6 +60,11 @@ enum sh_vou_status {
 #define VOU_MAX_IMAGE_WIDTH	720
 #define VOU_MAX_IMAGE_HEIGHT	576
 
+struct sh_vou_buffer {
+	struct vb2_buffer buf;
+	struct list_head queue;
+};
+
 struct sh_vou_device {
 	struct v4l2_device v4l2_dev;
 	struct video_device *vdev;
@@ -73,13 +78,11 @@ struct sh_vou_device {
 	struct list_head queue;
 	v4l2_std_id std;
 	int pix_idx;
-	struct videobuf_buffer *active;
+	struct sh_vou_buffer *active;
 	enum sh_vou_status status;
 	struct mutex fop_lock;
-};
-
-struct sh_vou_file {
-	struct videobuf_queue vbq;
+	struct vb2_queue vbq;
+	void *alloc_ctx;
 };
 
 /* Register access routines for sides A, B and mirror addresses */
@@ -178,11 +181,11 @@ static struct sh_vou_fmt vou_fmt[] = {
 };
 
 static void sh_vou_schedule_next(struct sh_vou_device *vou_dev,
-				 struct videobuf_buffer *vb)
+				 struct vb2_buffer *vb)
 {
 	dma_addr_t addr1, addr2;
 
-	addr1 = videobuf_to_dma_contig(vb);
+	addr1 = vb2_dma_contig_plane_dma_addr(vb, 0);
 	switch (vou_dev->pix.pixelformat) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV16:
@@ -197,7 +200,7 @@ static void sh_vou_schedule_next(struct sh_vou_device *vou_dev,
 }
 
 static void sh_vou_stream_start(struct sh_vou_device *vou_dev,
-				struct videobuf_buffer *vb)
+				struct vb2_buffer *vb)
 {
 	unsigned int row_coeff;
 #ifdef __LITTLE_ENDIAN
@@ -226,111 +229,79 @@ static void sh_vou_stream_start(struct sh_vou_device *vou_dev,
 	sh_vou_schedule_next(vou_dev, vb);
 }
 
-static void free_buffer(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-	BUG_ON(in_interrupt());
-
-	/* Wait until this buffer is no longer in STATE_QUEUED or STATE_ACTIVE */
-	videobuf_waiton(vq, vb, 0, 0);
-	videobuf_dma_contig_free(vq, vb);
-	vb->state = VIDEOBUF_NEEDS_INIT;
-}
-
 /* Locking: caller holds fop_lock mutex */
-static int sh_vou_buf_setup(struct videobuf_queue *vq, unsigned int *count,
-			    unsigned int *size)
+static int sh_vou_queue_setup(struct vb2_queue *q,
+			      const struct v4l2_format *fmt,
+			      unsigned int *nbuffers, unsigned int *nplanes,
+			      unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct video_device *vdev = vq->priv_data;
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = vb2_get_drv_priv(q);
 
-	*size = vou_fmt[vou_dev->pix_idx].bpp * vou_dev->pix.width *
-		vou_dev->pix.height / 8;
+	sizes[0] = vou_fmt[vou_dev->pix_idx].bpp * vou_dev->pix.width *
+		   vou_dev->pix.height / 8;
 
-	if (*count < 2)
-		*count = 2;
+	if (*nbuffers < 2)
+		*nbuffers = 2;
 
-	/* Taking into account maximum frame size, *count will stay >= 2 */
-	if (PAGE_ALIGN(*size) * *count > 4 * 1024 * 1024)
-		*count = 4 * 1024 * 1024 / PAGE_ALIGN(*size);
+	/* Taking into account maximum frame size, *nbuffers will stay >= 2 */
+	if (PAGE_ALIGN(sizes[0]) * *nbuffers > 4 * 1024 * 1024)
+		*nbuffers = 4 * 1024 * 1024 / PAGE_ALIGN(sizes[0]);
 
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): count=%d, size=%d\n", __func__,
-		*count, *size);
+	*nplanes = 1;
+	alloc_ctxs[0] = vou_dev->alloc_ctx;
+
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): nbuffers=%d, size=%d\n", __func__,
+		*nbuffers, sizes[0]);
 
 	return 0;
 }
 
 /* Locking: caller holds fop_lock mutex */
-static int sh_vou_buf_prepare(struct videobuf_queue *vq,
-			      struct videobuf_buffer *vb,
-			      enum v4l2_field field)
+static int sh_vou_stop_streaming(struct vb2_queue *q)
 {
-	struct video_device *vdev = vq->priv_data;
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
-	struct v4l2_pix_format *pix = &vou_dev->pix;
-	int bytes_per_line = vou_fmt[vou_dev->pix_idx].bpp * pix->width / 8;
-	int ret;
+	struct sh_vou_device *vou_dev = vb2_get_drv_priv(q);
+	unsigned long flags;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	if (vb->width	!= pix->width ||
-	    vb->height	!= pix->height ||
-	    vb->field	!= pix->field) {
-		vb->width	= pix->width;
-		vb->height	= pix->height;
-		vb->field	= field;
-		if (vb->state != VIDEOBUF_NEEDS_INIT)
-			free_buffer(vq, vb);
-	}
-
-	vb->size = vb->height * bytes_per_line;
-	if (vb->baddr && vb->bsize < vb->size) {
-		/* User buffer too small */
-		dev_warn(vq->dev, "User buffer too small: [%u] @ %lx\n",
-			 vb->bsize, vb->baddr);
-		return -EINVAL;
-	}
+	spin_lock_irqsave(&vou_dev->lock, flags);
 
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret < 0) {
-			dev_warn(vq->dev, "IOLOCK buf-type %d: %d\n",
-				 vb->memory, ret);
-			return ret;
-		}
-		vb->state = VIDEOBUF_PREPARED;
-	}
+	/* disable output */
+	sh_vou_reg_a_set(vou_dev, VOUER, 0, 1);
+	/* ...but the current frame will complete */
+	sh_vou_reg_a_set(vou_dev, VOUIR, 0, 0x30000);
+	vou_dev->active = NULL;
 
-	dev_dbg(vou_dev->v4l2_dev.dev,
-		"%s(): fmt #%d, %u bytes per line, phys 0x%x, type %d, state %d\n",
-		__func__, vou_dev->pix_idx, bytes_per_line,
-		videobuf_to_dma_contig(vb), vb->memory, vb->state);
+	spin_unlock_irqrestore(&vou_dev->lock, flags);
 
 	return 0;
 }
 
 /* Locking: caller holds fop_lock mutex and vq->irqlock spinlock */
-static void sh_vou_buf_queue(struct videobuf_queue *vq,
-			     struct videobuf_buffer *vb)
+static void sh_vou_buf_queue(struct vb2_buffer *vb)
 {
-	struct video_device *vdev = vq->priv_data;
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct sh_vou_buffer *buf = container_of(vb, struct sh_vou_buffer, buf);
+	unsigned long flags;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	vb->state = VIDEOBUF_QUEUED;
-	list_add_tail(&vb->queue, &vou_dev->queue);
+	spin_lock_irqsave(&vou_dev->lock, flags);
+
+	list_add_tail(&buf->queue, &vou_dev->queue);
 
-	if (vou_dev->status == SH_VOU_RUNNING) {
-		return;
-	} else if (!vou_dev->active) {
-		vou_dev->active = vb;
+	if (vou_dev->status == SH_VOU_RUNNING)
+		goto done;
+
+	if (!vou_dev->active) {
+		vou_dev->active = buf;
 		/* Start from side A: we use mirror addresses, so, set B */
 		sh_vou_reg_a_write(vou_dev, VOURPR, 1);
 		dev_dbg(vou_dev->v4l2_dev.dev, "%s: first buffer status 0x%x\n",
 			__func__, sh_vou_reg_a_read(vou_dev, VOUSTR));
 		sh_vou_schedule_next(vou_dev, vb);
 		/* Only activate VOU after the second buffer */
-	} else if (vou_dev->active->queue.next == &vb->queue) {
+	} else if (vou_dev->active->queue.next == &buf->queue) {
 		/* Second buffer - initialise register side B */
 		sh_vou_reg_a_write(vou_dev, VOURPR, 0);
 		sh_vou_stream_start(vou_dev, vb);
@@ -347,42 +318,17 @@ static void sh_vou_buf_queue(struct videobuf_queue *vq,
 		vou_dev->status = SH_VOU_RUNNING;
 		sh_vou_reg_a_write(vou_dev, VOUER, 0x107);
 	}
-}
-
-static void sh_vou_buf_release(struct videobuf_queue *vq,
-			       struct videobuf_buffer *vb)
-{
-	struct video_device *vdev = vq->priv_data;
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
-	unsigned long flags;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	spin_lock_irqsave(&vou_dev->lock, flags);
-
-	if (vou_dev->active == vb) {
-		/* disable output */
-		sh_vou_reg_a_set(vou_dev, VOUER, 0, 1);
-		/* ...but the current frame will complete */
-		sh_vou_reg_a_set(vou_dev, VOUIR, 0, 0x30000);
-		vou_dev->active = NULL;
-	}
-
-	if ((vb->state == VIDEOBUF_ACTIVE || vb->state == VIDEOBUF_QUEUED)) {
-		vb->state = VIDEOBUF_ERROR;
-		list_del(&vb->queue);
-	}
 
+done:
 	spin_unlock_irqrestore(&vou_dev->lock, flags);
-
-	free_buffer(vq, vb);
 }
 
-static struct videobuf_queue_ops sh_vou_video_qops = {
-	.buf_setup	= sh_vou_buf_setup,
-	.buf_prepare	= sh_vou_buf_prepare,
+static struct vb2_ops sh_vou_video_qops = {
+	.queue_setup	= sh_vou_queue_setup,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
+	.stop_streaming	= sh_vou_stop_streaming,
 	.buf_queue	= sh_vou_buf_queue,
-	.buf_release	= sh_vou_buf_release,
 };
 
 /* Video IOCTLs */
@@ -788,52 +734,47 @@ static int sh_vou_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *req)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	if (req->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
-	return videobuf_reqbufs(&vou_file->vbq, req);
+	return vb2_reqbufs(&vou_dev->vbq, req);
 }
 
 static int sh_vou_querybuf(struct file *file, void *priv,
 			   struct v4l2_buffer *b)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	return videobuf_querybuf(&vou_file->vbq, b);
+	return vb2_querybuf(&vou_dev->vbq, b);
 }
 
 static int sh_vou_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	return videobuf_qbuf(&vou_file->vbq, b);
+	return vb2_qbuf(&vou_dev->vbq, b);
 }
 
 static int sh_vou_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	return videobuf_dqbuf(&vou_file->vbq, b, file->f_flags & O_NONBLOCK);
+	return vb2_dqbuf(&vou_dev->vbq, b, file->f_flags & O_NONBLOCK);
 }
 
 static int sh_vou_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type buftype)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
 	int ret;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
@@ -844,14 +785,13 @@ static int sh_vou_streamon(struct file *file, void *priv,
 		return ret;
 
 	/* This calls our .buf_queue() (== sh_vou_buf_queue) */
-	return videobuf_streamon(&vou_file->vbq);
+	return vb2_streamon(&vou_dev->vbq, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 }
 
 static int sh_vou_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type buftype)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = priv;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
@@ -859,7 +799,7 @@ static int sh_vou_streamoff(struct file *file, void *priv,
 	 * This calls buf_release from host driver's videobuf_queue_ops for all
 	 * remaining buffers. When the last buffer is freed, stop streaming
 	 */
-	videobuf_streamoff(&vou_file->vbq);
+	vb2_streamoff(&vou_dev->vbq, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video, s_stream, 0);
 
 	return 0;
@@ -1048,7 +988,7 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 {
 	struct sh_vou_device *vou_dev = dev_id;
 	static unsigned long j;
-	struct videobuf_buffer *vb;
+	struct sh_vou_buffer *vb;
 	static int cnt;
 	static int side;
 	u32 irq_status = sh_vou_reg_a_read(vou_dev, VOUIR), masked;
@@ -1086,10 +1026,10 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 	vb = vou_dev->active;
 	list_del(&vb->queue);
 
-	vb->state = VIDEOBUF_DONE;
-	do_gettimeofday(&vb->ts);
-	vb->field_count++;
-	wake_up(&vb->done);
+	do_gettimeofday(&vb->buf.v4l2_buf.timestamp);
+	vb2_set_plane_payload(&vb->buf, 0, 0);
+	vb->buf.v4l2_buf.sequence++;
+	vb2_buffer_done(&vb->buf, VB2_BUF_STATE_DONE);
 
 	if (list_empty(&vou_dev->queue)) {
 		/* Stop VOU */
@@ -1105,12 +1045,13 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 	}
 
 	vou_dev->active = list_entry(vou_dev->queue.next,
-				     struct videobuf_buffer, queue);
+				     struct sh_vou_buffer, queue);
 
 	if (vou_dev->active->queue.next != &vou_dev->queue) {
-		struct videobuf_buffer *new = list_entry(vou_dev->active->queue.next,
-						struct videobuf_buffer, queue);
-		sh_vou_schedule_next(vou_dev, new);
+		struct sh_vou_buffer *new =
+			list_entry(vou_dev->active->queue.next,
+				   struct sh_vou_buffer, queue);
+		sh_vou_schedule_next(vou_dev, &new->buf);
 	}
 
 	spin_unlock(&vou_dev->lock);
@@ -1157,16 +1098,9 @@ static int sh_vou_hw_init(struct sh_vou_device *vou_dev)
 static int sh_vou_open(struct file *file)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = kzalloc(sizeof(struct sh_vou_file),
-					       GFP_KERNEL);
-
-	if (!vou_file)
-		return -ENOMEM;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	file->private_data = vou_file;
-
 	if (mutex_lock_interruptible(&vou_dev->fop_lock))
 		return -ERESTARTSYS;
 	if (atomic_inc_return(&vou_dev->use_count) == 1) {
@@ -1184,12 +1118,6 @@ static int sh_vou_open(struct file *file)
 		}
 	}
 
-	videobuf_queue_dma_contig_init(&vou_file->vbq, &sh_vou_video_qops,
-				       vou_dev->v4l2_dev.dev, &vou_dev->lock,
-				       V4L2_BUF_TYPE_VIDEO_OUTPUT,
-				       V4L2_FIELD_NONE,
-				       sizeof(struct videobuf_buffer),
-				       vou_dev->vdev, &vou_dev->fop_lock);
 	mutex_unlock(&vou_dev->fop_lock);
 
 	return 0;
@@ -1198,7 +1126,6 @@ static int sh_vou_open(struct file *file)
 static int sh_vou_release(struct file *file)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = file->private_data;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
@@ -1208,44 +1135,15 @@ static int sh_vou_release(struct file *file)
 		vou_dev->status = SH_VOU_IDLE;
 		sh_vou_reg_a_set(vou_dev, VOUER, 0, 0x101);
 		pm_runtime_put(vou_dev->v4l2_dev.dev);
+		vb2_queue_release(&vou_dev->vbq);
 		mutex_unlock(&vou_dev->fop_lock);
 	}
 
 	file->private_data = NULL;
-	kfree(vou_file);
 
 	return 0;
 }
 
-static int sh_vou_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = file->private_data;
-	int ret;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	if (mutex_lock_interruptible(&vou_dev->fop_lock))
-		return -ERESTARTSYS;
-	ret = videobuf_mmap_mapper(&vou_file->vbq, vma);
-	mutex_unlock(&vou_dev->fop_lock);
-	return ret;
-}
-
-static unsigned int sh_vou_poll(struct file *file, poll_table *wait)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct sh_vou_file *vou_file = file->private_data;
-	unsigned int res;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	mutex_lock(&vou_dev->fop_lock);
-	res = videobuf_poll_stream(file, &vou_file->vbq, wait);
-	mutex_unlock(&vou_dev->fop_lock);
-	return res;
-}
-
 static int sh_vou_g_chip_ident(struct file *file, void *fh,
 				   struct v4l2_dbg_chip_ident *id)
 {
@@ -1302,8 +1200,8 @@ static const struct v4l2_file_operations sh_vou_fops = {
 	.open		= sh_vou_open,
 	.release	= sh_vou_release,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= sh_vou_mmap,
-	.poll		= sh_vou_poll,
+	.mmap		= vb2_fop_mmap,
+	.poll		= vb2_fop_poll,
 };
 
 static const struct video_device sh_vou_video_template = {
@@ -1325,6 +1223,7 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 	struct sh_vou_device *vou_dev;
 	struct resource *reg_res, *region;
 	struct v4l2_subdev *subdev;
+	struct vb2_queue *queue;
 	int irq, ret;
 
 	reg_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1400,6 +1299,7 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 	vdev->v4l2_dev = &vou_dev->v4l2_dev;
 	vdev->release = video_device_release;
 	vdev->lock = &vou_dev->fop_lock;
+	vdev->queue = &vou_dev->vbq;
 
 	vou_dev->vdev = vdev;
 	video_set_drvdata(vdev, vou_dev);
@@ -1424,6 +1324,25 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 		goto ei2cnd;
 	}
 
+	queue = &vou_dev->vbq;
+	queue->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	queue->io_modes = VB2_MMAP | VB2_USERPTR;
+	queue->drv_priv = vou_dev;
+	queue->buf_struct_size = sizeof(struct sh_vou_buffer);
+	queue->ops = &sh_vou_video_qops;
+	queue->mem_ops = &vb2_dma_contig_memops;
+	queue->lock = &vou_dev->fop_lock;
+
+	ret = vb2_queue_init(queue);
+	if (ret < 0)
+		goto evqueue;
+
+	vou_dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(vou_dev->alloc_ctx)) {
+		ret = PTR_ERR(vou_dev->alloc_ctx);
+		goto eallocctx;
+	}
+
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0)
 		goto evregdev;
@@ -1431,6 +1350,9 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 	return 0;
 
 evregdev:
+	vb2_dma_contig_cleanup_ctx(vou_dev->alloc_ctx);
+eallocctx:
+evqueue:
 ei2cnd:
 ereset:
 	i2c_put_adapter(i2c_adap);
@@ -1465,6 +1387,7 @@ static int __devexit sh_vou_remove(struct platform_device *pdev)
 		free_irq(irq, vou_dev);
 	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(vou_dev->vdev);
+	vb2_dma_contig_cleanup_ctx(vou_dev->alloc_ctx);
 	i2c_put_adapter(client->adapter);
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
 	iounmap(vou_dev->base);
-- 
Regards,

Laurent Pinchart

