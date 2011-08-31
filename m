Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab1HaSCx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 14:02:53 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 8/9 v6] V4L: mx3-camera: prepare to support multi-size buffers
Date: Wed, 31 Aug 2011 20:02:47 +0200
Message-Id: <1314813768-27752-9-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare the mx3_camera driver to support the new VIDIOC_CREATE_BUFS and
VIDIOC_PREPARE_BUF ioctl()s. The .queue_setup() vb2 operation must be
able to handle buffer sizes, provided by the caller, and the
.buf_prepare() operation must not use the currently configured frame
format for its operation, which makes it superfluous for this driver.
Its functionality is moved into .buf_queue().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---

v6: Handle the case of VIDIOC_CREATE_BUFS, when vb2 creates fewer buffers, than
    requested by the user, correctly

 drivers/media/video/mx3_camera.c |  159 ++++++++++++++++++++------------------
 1 files changed, 83 insertions(+), 76 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 6bfbce9..a85283a 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -114,6 +114,7 @@ struct mx3_camera_dev {
 	struct list_head	capture;
 	spinlock_t		lock;		/* Protects video buffer lists */
 	struct mx3_camera_buffer *active;
+	size_t			buf_total;
 	struct vb2_alloc_ctx	*alloc_ctx;
 	enum v4l2_field		field;
 	int			sequence;
@@ -198,73 +199,44 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
-
-	if (bytes_per_line < 0)
-		return bytes_per_line;
+	int bytes_per_line;
+	unsigned int height;
 
 	if (!mx3_cam->idmac_channel[0])
 		return -EINVAL;
 
-	*num_planes = 1;
-
-	mx3_cam->sequence = 0;
-	sizes[0] = bytes_per_line * icd->user_height;
-	alloc_ctxs[0] = mx3_cam->alloc_ctx;
-
-	if (!*count)
-		*count = 32;
-
-	if (sizes[0] * *count > MAX_VIDEO_MEM * 1024 * 1024)
-		*count = MAX_VIDEO_MEM * 1024 * 1024 / sizes[0];
-
-	return 0;
-}
-
-static int mx3_videobuf_prepare(struct vb2_buffer *vb)
-{
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
-	struct scatterlist *sg;
-	struct mx3_camera_buffer *buf;
-	size_t new_size;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+	if (fmt) {
+		const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
+								fmt->fmt.pix.pixelformat);
+		bytes_per_line = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
+							 xlate->host_fmt);
+		height = fmt->fmt.pix.height;
+	} else {
+		/* Called from VIDIOC_REQBUFS or in compatibility mode */
+		bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 						icd->current_fmt->host_fmt);
-
+		height = icd->user_height;
+	}
 	if (bytes_per_line < 0)
 		return bytes_per_line;
 
-	buf = to_mx3_vb(vb);
-	sg = &buf->sg;
-
-	new_size = bytes_per_line * icd->user_height;
-
-	if (vb2_plane_size(vb, 0) < new_size) {
-		dev_err(icd->parent, "Buffer too small (%lu < %zu)\n",
-			vb2_plane_size(vb, 0), new_size);
-		return -ENOBUFS;
-	}
+	sizes[0] = bytes_per_line * height;
 
-	if (buf->state == CSI_BUF_NEEDS_INIT) {
-		sg_dma_address(sg)	= vb2_dma_contig_plane_paddr(vb, 0);
-		sg_dma_len(sg)		= new_size;
+	alloc_ctxs[0] = mx3_cam->alloc_ctx;
 
-		buf->txd = ichan->dma_chan.device->device_prep_slave_sg(
-			&ichan->dma_chan, sg, 1, DMA_FROM_DEVICE,
-			DMA_PREP_INTERRUPT);
-		if (!buf->txd)
-			return -EIO;
+	if (!vq->num_buffers)
+		mx3_cam->sequence = 0;
 
-		buf->txd->callback_param	= buf->txd;
-		buf->txd->callback		= mx3_cam_dma_done;
+	if (!*count)
+		*count = 2;
 
-		buf->state = CSI_BUF_PREPARED;
-	}
+	/* If *num_planes != 0, we have already verified *count. */
+	if (!*num_planes &&
+	    sizes[0] * *count + mx3_cam->buf_total > MAX_VIDEO_MEM * 1024 * 1024)
+		*count = (MAX_VIDEO_MEM * 1024 * 1024 - mx3_cam->buf_total) /
+			sizes[0];
 
-	vb2_set_plane_payload(vb, 0, new_size);
+	*num_planes = 1;
 
 	return 0;
 }
@@ -288,28 +260,58 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
-	struct dma_async_tx_descriptor *txd = buf->txd;
-	struct idmac_channel *ichan = to_idmac_chan(txd->chan);
+	struct scatterlist *sg = &buf->sg;
+	struct dma_async_tx_descriptor *txd;
+	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
 	struct idmac_video_param *video = &ichan->params.video;
-	dma_cookie_t cookie;
-	u32 fourcc = icd->current_fmt->host_fmt->fourcc;
+	const struct soc_mbus_pixelfmt *host_fmt = icd->current_fmt->host_fmt;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width, host_fmt);
 	unsigned long flags;
+	dma_cookie_t cookie;
+	size_t new_size;
+
+	BUG_ON(bytes_per_line <= 0);
+
+	new_size = bytes_per_line * icd->user_height;
+
+	if (vb2_plane_size(vb, 0) < new_size) {
+		dev_err(icd->parent, "Buffer #%d too small (%lu < %zu)\n",
+			vb->v4l2_buf.index, vb2_plane_size(vb, 0), new_size);
+		goto error;
+	}
+
+	if (buf->state == CSI_BUF_NEEDS_INIT) {
+		sg_dma_address(sg)	= vb2_dma_contig_plane_paddr(vb, 0);
+		sg_dma_len(sg)		= new_size;
+
+		txd = ichan->dma_chan.device->device_prep_slave_sg(
+			&ichan->dma_chan, sg, 1, DMA_FROM_DEVICE,
+			DMA_PREP_INTERRUPT);
+		if (!txd)
+			goto error;
+
+		txd->callback_param	= txd;
+		txd->callback		= mx3_cam_dma_done;
+
+		buf->state		= CSI_BUF_PREPARED;
+		buf->txd		= txd;
+	} else {
+		txd = buf->txd;
+	}
+
+	vb2_set_plane_payload(vb, 0, new_size);
 
 	/* This is the configuration of one sg-element */
-	video->out_pixel_fmt	= fourcc_to_ipu_pix(fourcc);
+	video->out_pixel_fmt = fourcc_to_ipu_pix(host_fmt->fourcc);
 
 	if (video->out_pixel_fmt == IPU_PIX_FMT_GENERIC) {
 		/*
-		 * If the IPU DMA channel is configured to transport
-		 * generic 8-bit data, we have to set up correctly the
-		 * geometry parameters upon the current pixel format.
-		 * So, since the DMA horizontal parameters are expressed
-		 * in bytes not pixels, convert these in the right unit.
+		 * If the IPU DMA channel is configured to transfer generic
+		 * 8-bit data, we have to set up the geometry parameters
+		 * correctly, according to the current pixel format. The DMA
+		 * horizontal parameters in this case are expressed in bytes,
+		 * not in pixels.
 		 */
-		int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
-		BUG_ON(bytes_per_line <= 0);
-
 		video->out_width	= bytes_per_line;
 		video->out_height	= icd->user_height;
 		video->out_stride	= bytes_per_line;
@@ -353,6 +355,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 		mx3_cam->active = NULL;
 
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
+error:
 	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 }
 
@@ -386,17 +389,24 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)
 	}
 
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
+
+	mx3_cam->buf_total -= vb2_plane_size(vb, 0);
 }
 
 static int mx3_videobuf_init(struct vb2_buffer *vb)
 {
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+
 	/* This is for locking debugging only */
 	INIT_LIST_HEAD(&buf->queue);
 	sg_init_table(&buf->sg, 1);
 
 	buf->state = CSI_BUF_NEEDS_INIT;
-	buf->txd = NULL;
+
+	mx3_cam->buf_total += vb2_plane_size(vb, 0);
 
 	return 0;
 }
@@ -407,13 +417,12 @@ static int mx3_stop_streaming(struct vb2_queue *q)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
-	struct dma_chan *chan;
 	struct mx3_camera_buffer *buf, *tmp;
 	unsigned long flags;
 
 	if (ichan) {
-		chan = &ichan->dma_chan;
-		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+		struct dma_chan *chan = &ichan->dma_chan;
+		chan->device->device_control(chan, DMA_PAUSE, 0);
 	}
 
 	spin_lock_irqsave(&mx3_cam->lock, flags);
@@ -421,8 +430,8 @@ static int mx3_stop_streaming(struct vb2_queue *q)
 	mx3_cam->active = NULL;
 
 	list_for_each_entry_safe(buf, tmp, &mx3_cam->capture, queue) {
-		buf->state = CSI_BUF_NEEDS_INIT;
 		list_del_init(&buf->queue);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
@@ -432,7 +441,6 @@ static int mx3_stop_streaming(struct vb2_queue *q)
 
 static struct vb2_ops mx3_videobuf_ops = {
 	.queue_setup	= mx3_videobuf_setup,
-	.buf_prepare	= mx3_videobuf_prepare,
 	.buf_queue	= mx3_videobuf_queue,
 	.buf_cleanup	= mx3_videobuf_release,
 	.buf_init	= mx3_videobuf_init,
@@ -516,6 +524,7 @@ static int mx3_camera_add_device(struct soc_camera_device *icd)
 
 	mx3_camera_activate(mx3_cam, icd);
 
+	mx3_cam->buf_total = 0;
 	mx3_cam->icd = icd;
 
 	dev_info(icd->parent, "MX3 Camera driver attached to camera %d\n",
@@ -1263,8 +1272,6 @@ static int __devexit mx3_camera_remove(struct platform_device *pdev)
 
 	dmaengine_put();
 
-	dev_info(&pdev->dev, "i.MX3x Camera driver unloaded\n");
-
 	return 0;
 }
 
-- 
1.7.2.5

