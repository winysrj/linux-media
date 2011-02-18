Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:50572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab1BRINp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 03:13:45 -0500
Date: Fri, 18 Feb 2011 09:13:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/4] V4L: mx3_camera: convert to videobuf2
In-Reply-To: <Pine.LNX.4.64.1102180857360.1851@axis700.grange>
Message-ID: <Pine.LNX.4.64.1102180906500.1851@axis700.grange>
References: <Pine.LNX.4.64.1102180857360.1851@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Now that soc-camera supports videobuf API v1 and v2, camera-host drivers
can be converted to videobuf2 individually. This patch converts the
mx3_camera driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This one is also on git.linuxtv.org already.

 drivers/media/video/mx3_camera.c |  342 ++++++++++++++++----------------------
 1 files changed, 143 insertions(+), 199 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index b9cb4a4..d61ff0d 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -21,7 +21,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/videobuf2-dma-contig.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
 
@@ -62,10 +62,16 @@
 
 #define MAX_VIDEO_MEM 16
 
+enum csi_buffer_state {
+	CSI_BUF_NEEDS_INIT,
+	CSI_BUF_PREPARED,
+};
+
 struct mx3_camera_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer			vb;
-	enum v4l2_mbus_pixelcode		code;
+	struct vb2_buffer			vb;
+	enum csi_buffer_state			state;
+	struct list_head			queue;
 
 	/* One descriptot per scatterlist (per frame) */
 	struct dma_async_tx_descriptor		*txd;
@@ -108,6 +114,9 @@ struct mx3_camera_dev {
 	struct list_head	capture;
 	spinlock_t		lock;		/* Protects video buffer lists */
 	struct mx3_camera_buffer *active;
+	struct vb2_alloc_ctx	*alloc_ctx;
+	enum v4l2_field		field;
+	int			sequence;
 
 	/* IDMAC / dmaengine interface */
 	struct idmac_channel	*idmac_channel[1];	/* We need one channel */
@@ -130,6 +139,11 @@ static void csi_reg_write(struct mx3_camera_dev *mx3, u32 value, off_t reg)
 	__raw_writel(value, mx3->base + reg);
 }
 
+static struct mx3_camera_buffer *to_mx3_vb(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct mx3_camera_buffer, vb);
+}
+
 /* Called from the IPU IDMAC ISR */
 static void mx3_cam_dma_done(void *arg)
 {
@@ -137,20 +151,20 @@ static void mx3_cam_dma_done(void *arg)
 	struct dma_chan *chan = desc->txd.chan;
 	struct idmac_channel *ichannel = to_idmac_chan(chan);
 	struct mx3_camera_dev *mx3_cam = ichannel->client;
-	struct videobuf_buffer *vb;
 
 	dev_dbg(chan->device->dev, "callback cookie %d, active DMA 0x%08x\n",
 		desc->txd.cookie, mx3_cam->active ? sg_dma_address(&mx3_cam->active->sg) : 0);
 
 	spin_lock(&mx3_cam->lock);
 	if (mx3_cam->active) {
-		vb = &mx3_cam->active->vb;
-
-		list_del_init(&vb->queue);
-		vb->state = VIDEOBUF_DONE;
-		do_gettimeofday(&vb->ts);
-		vb->field_count++;
-		wake_up(&vb->done);
+		struct vb2_buffer *vb = &mx3_cam->active->vb;
+		struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+
+		list_del_init(&buf->queue);
+		do_gettimeofday(&vb->v4l2_buf.timestamp);
+		vb->v4l2_buf.field = mx3_cam->field;
+		vb->v4l2_buf.sequence = mx3_cam->sequence++;
+		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 	}
 
 	if (list_empty(&mx3_cam->capture)) {
@@ -165,38 +179,10 @@ static void mx3_cam_dma_done(void *arg)
 	}
 
 	mx3_cam->active = list_entry(mx3_cam->capture.next,
-				     struct mx3_camera_buffer, vb.queue);
-	mx3_cam->active->vb.state = VIDEOBUF_ACTIVE;
+				     struct mx3_camera_buffer, queue);
 	spin_unlock(&mx3_cam->lock);
 }
 
-static void free_buffer(struct videobuf_queue *vq, struct mx3_camera_buffer *buf)
-{
-	struct soc_camera_device *icd = vq->priv_data;
-	struct videobuf_buffer *vb = &buf->vb;
-	struct dma_async_tx_descriptor *txd = buf->txd;
-	struct idmac_channel *ichan;
-
-	BUG_ON(in_interrupt());
-
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
-
-	/*
-	 * This waits until this buffer is out of danger, i.e., until it is no
-	 * longer in STATE_QUEUED or STATE_ACTIVE
-	 */
-	videobuf_waiton(vq, vb, 0, 0);
-	if (txd) {
-		ichan = to_idmac_chan(txd->chan);
-		async_tx_ack(txd);
-	}
-	videobuf_dma_contig_free(vq, vb);
-	buf->txd = NULL;
-
-	vb->state = VIDEOBUF_NEEDS_INIT;
-}
-
 /*
  * Videobuf operations
  */
@@ -205,10 +191,11 @@ static void free_buffer(struct videobuf_queue *vq, struct mx3_camera_buffer *buf
  * Calculate the __buffer__ (not data) size and number of buffers.
  * Called with .vb_lock held
  */
-static int mx3_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
-			      unsigned int *size)
+static int mx3_videobuf_setup(struct vb2_queue *vq,
+			unsigned int *count, unsigned int *num_planes,
+			unsigned long sizes[], void *alloc_ctxs[])
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
@@ -220,104 +207,68 @@ static int mx3_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	if (!mx3_cam->idmac_channel[0])
 		return -EINVAL;
 
-	*size = bytes_per_line * icd->user_height;
+	*num_planes = 1;
+
+	mx3_cam->sequence = 0;
+	sizes[0] = bytes_per_line * icd->user_height;
+	alloc_ctxs[0] = mx3_cam->alloc_ctx;
 
 	if (!*count)
 		*count = 32;
 
-	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
-		*count = MAX_VIDEO_MEM * 1024 * 1024 / *size;
+	if (sizes[0] * *count > MAX_VIDEO_MEM * 1024 * 1024)
+		*count = MAX_VIDEO_MEM * 1024 * 1024 / sizes[0];
 
 	return 0;
 }
 
 /* Called with .vb_lock held */
-static int mx3_videobuf_prepare(struct videobuf_queue *vq,
-		struct videobuf_buffer *vb, enum v4l2_field field)
+static int mx3_videobuf_prepare(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct mx3_camera_buffer *buf =
-		container_of(vb, struct mx3_camera_buffer, vb);
+	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
+	struct scatterlist *sg;
+	struct mx3_camera_buffer *buf;
 	size_t new_size;
-	int ret;
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 						icd->current_fmt->host_fmt);
 
 	if (bytes_per_line < 0)
 		return bytes_per_line;
 
-	new_size = bytes_per_line * icd->user_height;
+	buf = to_mx3_vb(vb);
+	sg = &buf->sg;
 
-	/*
-	 * I think, in buf_prepare you only have to protect global data,
-	 * the actual buffer is yours
-	 */
-
-	if (buf->code	!= icd->current_fmt->code ||
-	    vb->width	!= icd->user_width ||
-	    vb->height	!= icd->user_height ||
-	    vb->field	!= field) {
-		buf->code	= icd->current_fmt->code;
-		vb->width	= icd->user_width;
-		vb->height	= icd->user_height;
-		vb->field	= field;
-		if (vb->state != VIDEOBUF_NEEDS_INIT)
-			free_buffer(vq, buf);
-	}
+	new_size = bytes_per_line * icd->user_height;
 
-	if (vb->baddr && vb->bsize < new_size) {
-		/* User provided buffer, but it is too small */
-		ret = -ENOMEM;
-		goto out;
+	if (vb2_plane_size(vb, 0) < new_size) {
+		dev_err(icd->dev.parent, "Buffer too small (%lu < %zu)\n",
+			vb2_plane_size(vb, 0), new_size);
+		return -ENOBUFS;
 	}
 
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
-		struct scatterlist *sg = &buf->sg;
-
-		/*
-		 * The total size of video-buffers that will be allocated / mapped.
-		 * *size that we calculated in videobuf_setup gets assigned to
-		 * vb->bsize, and now we use the same calculation to get vb->size.
-		 */
-		vb->size = new_size;
-
-		/* This actually (allocates and) maps buffers */
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret)
-			goto fail;
-
-		/*
-		 * We will have to configure the IDMAC channel. It has two slots
-		 * for DMA buffers, we shall enter the first two buffers there,
-		 * and then submit new buffers in DMA-ready interrupts
-		 */
-		sg_init_table(sg, 1);
-		sg_dma_address(sg)	= videobuf_to_dma_contig(vb);
-		sg_dma_len(sg)		= vb->size;
+	if (buf->state == CSI_BUF_NEEDS_INIT) {
+		sg_dma_address(sg)	= (dma_addr_t)icd->vb2_vidq.mem_ops->cookie(
+			vb->planes[0].mem_priv);
+		sg_dma_len(sg)		= new_size;
 
 		buf->txd = ichan->dma_chan.device->device_prep_slave_sg(
 			&ichan->dma_chan, sg, 1, DMA_FROM_DEVICE,
 			DMA_PREP_INTERRUPT);
-		if (!buf->txd) {
-			ret = -EIO;
-			goto fail;
-		}
+		if (!buf->txd)
+			return -EIO;
 
 		buf->txd->callback_param	= buf->txd;
 		buf->txd->callback		= mx3_cam_dma_done;
 
-		vb->state = VIDEOBUF_PREPARED;
+		buf->state = CSI_BUF_PREPARED;
 	}
 
-	return 0;
+	vb2_set_plane_payload(vb, 0, new_size);
 
-fail:
-	free_buffer(vq, buf);
-out:
-	return ret;
+	return 0;
 }
 
 static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
@@ -338,24 +289,20 @@ static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
 }
 
 /*
- * Called with .vb_lock mutex held and
- * under spinlock_irqsave(&mx3_cam->lock, ...)
+ * Called with .vb_lock mutex held
  */
-static void mx3_videobuf_queue(struct videobuf_queue *vq,
-			       struct videobuf_buffer *vb)
+static void mx3_videobuf_queue(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct mx3_camera_buffer *buf =
-		container_of(vb, struct mx3_camera_buffer, vb);
+	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 	struct dma_async_tx_descriptor *txd = buf->txd;
 	struct idmac_channel *ichan = to_idmac_chan(txd->chan);
 	struct idmac_video_param *video = &ichan->params.video;
 	dma_cookie_t cookie;
 	u32 fourcc = icd->current_fmt->host_fmt->fourcc;
-
-	BUG_ON(!irqs_disabled());
+	unsigned long flags;
 
 	/* This is the configuration of one sg-element */
 	video->out_pixel_fmt	= fourcc_to_ipu_pix(fourcc);
@@ -365,17 +312,15 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 
 #ifdef DEBUG
 	/* helps to see what DMA actually has written */
-	memset((void *)vb->baddr, 0xaa, vb->bsize);
+	if (vb2_plane_vaddr(vb, 0))
+		memset(vb2_plane_vaddr(vb, 0), 0xaa, vb2_get_plane_payload(vb, 0));
 #endif
 
-	list_add_tail(&vb->queue, &mx3_cam->capture);
+	spin_lock_irqsave(&mx3_cam->lock, flags);
+	list_add_tail(&buf->queue, &mx3_cam->capture);
 
-	if (!mx3_cam->active) {
+	if (!mx3_cam->active)
 		mx3_cam->active = buf;
-		vb->state = VIDEOBUF_ACTIVE;
-	} else {
-		vb->state = VIDEOBUF_QUEUED;
-	}
 
 	spin_unlock_irq(&mx3_cam->lock);
 
@@ -383,67 +328,88 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 	dev_dbg(icd->dev.parent, "Submitted cookie %d DMA 0x%08x\n",
 		cookie, sg_dma_address(&buf->sg));
 
-	spin_lock_irq(&mx3_cam->lock);
-
 	if (cookie >= 0)
 		return;
 
-	/* Submit error */
-	vb->state = VIDEOBUF_PREPARED;
+	spin_lock_irq(&mx3_cam->lock);
 
-	list_del_init(&vb->queue);
+	/* Submit error */
+	list_del_init(&buf->queue);
 
 	if (mx3_cam->active == buf)
 		mx3_cam->active = NULL;
+
+	spin_unlock_irqrestore(&mx3_cam->lock, flags);
+	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 }
 
 /* Called with .vb_lock held */
-static void mx3_videobuf_release(struct videobuf_queue *vq,
-				 struct videobuf_buffer *vb)
+static void mx3_videobuf_release(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct mx3_camera_buffer *buf =
-		container_of(vb, struct mx3_camera_buffer, vb);
+	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+	struct dma_async_tx_descriptor *txd = buf->txd;
 	unsigned long flags;
 
 	dev_dbg(icd->dev.parent,
-		"Release%s DMA 0x%08x (state %d), queue %sempty\n",
+		"Release%s DMA 0x%08x, queue %sempty\n",
 		mx3_cam->active == buf ? " active" : "", sg_dma_address(&buf->sg),
-		vb->state, list_empty(&vb->queue) ? "" : "not ");
+		list_empty(&buf->queue) ? "" : "not ");
+
 	spin_lock_irqsave(&mx3_cam->lock, flags);
-	if ((vb->state == VIDEOBUF_ACTIVE || vb->state == VIDEOBUF_QUEUED) &&
-	    !list_empty(&vb->queue)) {
-		vb->state = VIDEOBUF_ERROR;
 
-		list_del_init(&vb->queue);
-		if (mx3_cam->active == buf)
-			mx3_cam->active = NULL;
+	if (mx3_cam->active == buf)
+		mx3_cam->active = NULL;
+
+	/* Doesn't hurt also if the list is empty */
+	list_del_init(&buf->queue);
+	buf->state = CSI_BUF_NEEDS_INIT;
+
+	if (txd) {
+		buf->txd = NULL;
+		if (mx3_cam->idmac_channel[0])
+			async_tx_ack(txd);
 	}
+
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
-	free_buffer(vq, buf);
 }
 
-static struct videobuf_queue_ops mx3_videobuf_ops = {
-	.buf_setup      = mx3_videobuf_setup,
-	.buf_prepare    = mx3_videobuf_prepare,
-	.buf_queue      = mx3_videobuf_queue,
-	.buf_release    = mx3_videobuf_release,
+static int mx3_videobuf_init(struct vb2_buffer *vb)
+{
+	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+	/* This is for locking debugging only */
+	INIT_LIST_HEAD(&buf->queue);
+	sg_init_table(&buf->sg, 1);
+
+	buf->state = CSI_BUF_NEEDS_INIT;
+	buf->txd = NULL;
+
+	return 0;
+}
+
+static struct vb2_ops mx3_videobuf_ops = {
+	.queue_setup	= mx3_videobuf_setup,
+	.buf_prepare	= mx3_videobuf_prepare,
+	.buf_queue	= mx3_videobuf_queue,
+	.buf_cleanup	= mx3_videobuf_release,
+	.buf_init	= mx3_videobuf_init,
+	.wait_prepare	= soc_camera_unlock,
+	.wait_finish	= soc_camera_lock,
 };
 
-static void mx3_camera_init_videobuf(struct videobuf_queue *q,
+static int mx3_camera_init_videobuf(struct vb2_queue *q,
 				     struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct mx3_camera_dev *mx3_cam = ici->priv;
-
-	videobuf_queue_dma_contig_init(q, &mx3_videobuf_ops, icd->dev.parent,
-				       &mx3_cam->lock,
-				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				       V4L2_FIELD_NONE,
-				       sizeof(struct mx3_camera_buffer), icd,
-				       &icd->video_lock);
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = icd;
+	q->ops = &mx3_videobuf_ops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct mx3_camera_buffer);
+
+	return vb2_queue_init(q);
 }
 
 /* First part of ipu_csi_init_interface() */
@@ -538,18 +504,6 @@ static void mx3_camera_remove_device(struct soc_camera_device *icd)
 		 icd->devnum);
 }
 
-static bool channel_change_requested(struct soc_camera_device *icd,
-				     struct v4l2_rect *rect)
-{
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
-
-	/* Do buffers have to be re-allocated or channel re-configured? */
-	return ichan && rect->width * rect->height >
-		icd->user_width * icd->user_height;
-}
-
 static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 			       unsigned char buswidth, unsigned long *flags)
 {
@@ -772,18 +726,6 @@ static int acquire_dma_channel(struct mx3_camera_dev *mx3_cam)
 	struct dma_chan_request rq = {.mx3_cam = mx3_cam,
 				      .id = IDMAC_IC_7};
 
-	if (*ichan) {
-		struct videobuf_buffer *vb, *_vb;
-		dma_release_channel(&(*ichan)->dma_chan);
-		*ichan = NULL;
-		mx3_cam->active = NULL;
-		list_for_each_entry_safe(vb, _vb, &mx3_cam->capture, queue) {
-			list_del_init(&vb->queue);
-			vb->state = VIDEOBUF_ERROR;
-			wake_up(&vb->done);
-		}
-	}
-
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 	dma_cap_set(DMA_PRIVATE, mask);
@@ -843,19 +785,8 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 			return ret;
 	}
 
-	if (mf.width != icd->user_width || mf.height != icd->user_height) {
-		/*
-		 * We now know pixel formats and can decide upon DMA-channel(s)
-		 * So far only direct camera-to-memory is supported
-		 */
-		if (channel_change_requested(icd, rect)) {
-			ret = acquire_dma_channel(mx3_cam);
-			if (ret < 0)
-				return ret;
-		}
-
+	if (mf.width != icd->user_width || mf.height != icd->user_height)
 		configure_geometry(mx3_cam, mf.width, mf.height);
-	}
 
 	dev_dbg(icd->dev.parent, "Sensor cropped %dx%d\n",
 		mf.width, mf.height);
@@ -887,10 +818,6 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	stride_align(&pix->width);
 	dev_dbg(icd->dev.parent, "Set format %dx%d\n", pix->width, pix->height);
 
-	ret = acquire_dma_channel(mx3_cam);
-	if (ret < 0)
-		return ret;
-
 	/*
 	 * Might have to perform a complete interface initialisation like in
 	 * ipu_csi_init_interface() in mxc_v4l2_s_param(). Also consider
@@ -912,9 +839,16 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	if (mf.code != xlate->code)
 		return -EINVAL;
 
+	if (!mx3_cam->idmac_channel[0]) {
+		ret = acquire_dma_channel(mx3_cam);
+		if (ret < 0)
+			return ret;
+	}
+
 	pix->width		= mf.width;
 	pix->height		= mf.height;
 	pix->field		= mf.field;
+	mx3_cam->field		= mf.field;
 	pix->colorspace		= mf.colorspace;
 	icd->current_fmt	= xlate;
 
@@ -991,7 +925,7 @@ static unsigned int mx3_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
 
-	return videobuf_poll_stream(file, &icd->vb_vidq, pt);
+	return vb2_poll(&icd->vb2_vidq, file, pt);
 }
 
 static int mx3_camera_querycap(struct soc_camera_host *ici,
@@ -1165,7 +1099,7 @@ static struct soc_camera_host_ops mx3_soc_camera_host_ops = {
 	.set_fmt	= mx3_camera_set_fmt,
 	.try_fmt	= mx3_camera_try_fmt,
 	.get_formats	= mx3_camera_get_formats,
-	.init_videobuf	= mx3_camera_init_videobuf,
+	.init_videobuf2	= mx3_camera_init_videobuf,
 	.reqbufs	= mx3_camera_reqbufs,
 	.poll		= mx3_camera_poll,
 	.querycap	= mx3_camera_querycap,
@@ -1241,6 +1175,12 @@ static int __devinit mx3_camera_probe(struct platform_device *pdev)
 	soc_host->v4l2_dev.dev	= &pdev->dev;
 	soc_host->nr		= pdev->id;
 
+	mx3_cam->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(mx3_cam->alloc_ctx)) {
+		err = PTR_ERR(mx3_cam->alloc_ctx);
+		goto eallocctx;
+	}
+
 	err = soc_camera_host_register(soc_host);
 	if (err)
 		goto ecamhostreg;
@@ -1251,6 +1191,8 @@ static int __devinit mx3_camera_probe(struct platform_device *pdev)
 	return 0;
 
 ecamhostreg:
+	vb2_dma_contig_cleanup_ctx(mx3_cam->alloc_ctx);
+eallocctx:
 	iounmap(base);
 eioremap:
 	clk_put(mx3_cam->clk);
@@ -1280,6 +1222,8 @@ static int __devexit mx3_camera_remove(struct platform_device *pdev)
 	if (WARN_ON(mx3_cam->idmac_channel[0]))
 		dma_release_channel(&mx3_cam->idmac_channel[0]->dma_chan);
 
+	vb2_dma_contig_cleanup_ctx(mx3_cam->alloc_ctx);
+
 	vfree(mx3_cam);
 
 	dmaengine_put();
-- 
1.7.2.3

