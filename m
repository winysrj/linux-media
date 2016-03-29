Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:55133 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbcC2Sf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 14:35:29 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2] media: platform: pxa_camera: convert to vb2
Date: Tue, 29 Mar 2016 20:35:15 +0200
Message-Id: <1459276515-1165-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert pxa_camera from videobuf to videobuf2.

As the soc_camera was already compatible with videobuf2, the port is
quite straightforward.

The special case of this code in which the vb2 to prepare is "too
big" in terms of size for the new capture format, the pxa_camera will
fail.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
Since v1: took into account Hans's comments
	  renamed all vb2 functions to pxac_vb2_*()
---
 drivers/media/platform/soc_camera/Kconfig      |   4 +-
 drivers/media/platform/soc_camera/pxa_camera.c | 576 ++++++++++++-------------
 2 files changed, 266 insertions(+), 314 deletions(-)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index e5e2d6cf6638..39fd9f2d3ca8 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -28,8 +28,8 @@ config VIDEO_MX3
 
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && PXA27x && SOC_CAMERA
-	select VIDEOBUF_DMA_SG
+	depends on VIDEO_DEV && PXA27x && SOC_CAMERA && HAS_DMA
+	select VIDEOBUF2_DMA_SG
 	select SG_SPLIT
 	---help---
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 2aaf4a8f71a0..b8dd878e98d6 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -34,7 +34,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf2-dma-sg.h>
 #include <media/soc_camera.h>
 #include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-of.h>
@@ -180,13 +180,16 @@ enum pxa_camera_active_dma {
 /* buffer for one video frame */
 struct pxa_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer		vb;
+	struct vb2_v4l2_buffer		vbuf;
+	struct list_head		queue;
 	u32	code;
+	int				nb_planes;
 	/* our descriptor lists for Y, U and V channels */
 	struct dma_async_tx_descriptor	*descs[3];
 	dma_cookie_t			cookie[3];
 	struct scatterlist		*sg[3];
 	int				sg_len[3];
+	size_t				plane_sizes[3];
 	int				inwork;
 	enum pxa_camera_active_dma	active_dma;
 };
@@ -222,6 +225,8 @@ struct pxa_camera_dev {
 	struct tasklet_struct	task_eof;
 
 	u32			save_cicr[5];
+
+	void			*alloc_ctx;
 };
 
 struct pxa_cam {
@@ -230,59 +235,19 @@ struct pxa_cam {
 
 static const char *pxa_cam_driver_description = "PXA_Camera";
 
-static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
-
 /*
  *  Videobuf operations
  */
-static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
-			      unsigned int *size)
+static struct pxa_buffer *vb2_to_pxa_buffer(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
-
-	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, *size);
-
-	*size = icd->sizeimage;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
-	if (0 == *count)
-		*count = 32;
-	if (*size * *count > vid_limit * 1024 * 1024)
-		*count = (vid_limit * 1024 * 1024) / *size;
-
-	return 0;
+	return container_of(vbuf, struct pxa_buffer, vbuf);
 }
 
-static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
+static struct device *pcdev_to_dev(struct pxa_camera_dev *pcdev)
 {
-	struct soc_camera_device *icd = vq->priv_data;
-	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
-	int i;
-
-	BUG_ON(in_interrupt());
-
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		&buf->vb, buf->vb.baddr, buf->vb.bsize);
-
-	/*
-	 * This waits until this buffer is out of danger, i.e., until it is no
-	 * longer in STATE_QUEUED or STATE_ACTIVE
-	 */
-	videobuf_waiton(vq, &buf->vb, 0, 0);
-
-	for (i = 0; i < 3 && buf->descs[i]; i++) {
-		dmaengine_desc_free(buf->descs[i]);
-		kfree(buf->sg[i]);
-		buf->descs[i] = NULL;
-		buf->sg[i] = NULL;
-		buf->sg_len[i] = 0;
-	}
-	videobuf_dma_unmap(vq->dev, dma);
-	videobuf_dma_free(dma);
-
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
-
-	dev_dbg(icd->parent, "%s end (vb=0x%p) 0x%08lx %d\n", __func__,
-		&buf->vb, buf->vb.baddr, buf->vb.bsize);
+	return pcdev->soc_host.v4l2_dev.dev;
 }
 
 static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
@@ -312,31 +277,26 @@ static void pxa_camera_dma_irq_v(void *data)
 /**
  * pxa_init_dma_channel - init dma descriptors
  * @pcdev: pxa camera device
- * @buf: pxa buffer to find pxa dma channel
+ * @vb: videobuffer2 buffer
  * @dma: dma video buffer
  * @channel: dma channel (0 => 'Y', 1 => 'U', 2 => 'V')
  * @cibr: camera Receive Buffer Register
- * @size: bytes to transfer
- * @offset: offset in videobuffer of the first byte to transfer
  *
  * Prepares the pxa dma descriptors to transfer one camera channel.
  *
  * Returns 0 if success or -ENOMEM if no memory is available
  */
 static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
-				struct pxa_buffer *buf,
-				struct videobuf_dmabuf *dma, int channel,
-				int cibr, int size, int offset)
+				struct pxa_buffer *buf, int channel,
+				struct scatterlist *sg, int sglen)
 {
 	struct dma_chan *dma_chan = pcdev->dma_chans[channel];
-	struct scatterlist *sg = buf->sg[channel];
-	int sglen = buf->sg_len[channel];
 	struct dma_async_tx_descriptor *tx;
 
 	tx = dmaengine_prep_slave_sg(dma_chan, sg, sglen, DMA_DEV_TO_MEM,
 				     DMA_PREP_INTERRUPT | DMA_CTRL_REUSE);
 	if (!tx) {
-		dev_err(pcdev->soc_host.v4l2_dev.dev,
+		dev_err(pcdev_to_dev(pcdev),
 			"dmaengine_prep_slave_sg failed\n");
 		goto fail;
 	}
@@ -357,11 +317,9 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 	buf->descs[channel] = tx;
 	return 0;
 fail:
-	kfree(sg);
-
-	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
-		"%s (vb=0x%p) dma_tx=%p\n",
-		__func__, &buf->vb, tx);
+	dev_dbg(pcdev_to_dev(pcdev),
+		"%s (vb=%p) dma_tx=%p\n",
+		__func__, buf, tx);
 
 	return -ENOMEM;
 }
@@ -374,129 +332,6 @@ static void pxa_videobuf_set_actdma(struct pxa_camera_dev *pcdev,
 		buf->active_dma |= DMA_U | DMA_V;
 }
 
-/*
- * Please check the DMA prepared buffer structure in :
- *   Documentation/video4linux/pxa_camera.txt
- * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
- * modification while DMA chain is running will work anyway.
- */
-static int pxa_videobuf_prepare(struct videobuf_queue *vq,
-		struct videobuf_buffer *vb, enum v4l2_field field)
-{
-	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
-	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
-	int ret;
-	int size_y, size_u = 0, size_v = 0;
-	size_t sizes[3];
-
-	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
-
-	/* Added list head initialization on alloc */
-	WARN_ON(!list_empty(&vb->queue));
-
-#ifdef DEBUG
-	/*
-	 * This can be useful if you want to see if we actually fill
-	 * the buffer with something
-	 */
-	memset((void *)vb->baddr, 0xaa, vb->bsize);
-#endif
-
-	BUG_ON(NULL == icd->current_fmt);
-
-	/*
-	 * I think, in buf_prepare you only have to protect global data,
-	 * the actual buffer is yours
-	 */
-	buf->inwork = 1;
-
-	if (buf->code	!= icd->current_fmt->code ||
-	    vb->width	!= icd->user_width ||
-	    vb->height	!= icd->user_height ||
-	    vb->field	!= field) {
-		buf->code	= icd->current_fmt->code;
-		vb->width	= icd->user_width;
-		vb->height	= icd->user_height;
-		vb->field	= field;
-		vb->state	= VIDEOBUF_NEEDS_INIT;
-	}
-
-	vb->size = icd->sizeimage;
-	if (0 != vb->baddr && vb->bsize < vb->size) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		int size = vb->size;
-		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret)
-			goto out;
-
-		if (pcdev->channels == 3) {
-			size_y = size / 2;
-			size_u = size_v = size / 4;
-		} else {
-			size_y = size;
-		}
-
-		sizes[0] = size_y;
-		sizes[1] = size_u;
-		sizes[2] = size_v;
-		ret = sg_split(dma->sglist, dma->sglen, 0, pcdev->channels,
-			       sizes, buf->sg, buf->sg_len, GFP_KERNEL);
-		if (ret < 0) {
-			dev_err(dev, "sg_split failed: %d\n", ret);
-			goto fail;
-		}
-
-		/* init DMA for Y channel */
-		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0,
-					   size_y, 0);
-		if (ret) {
-			dev_err(dev, "DMA initialization for Y/RGB failed\n");
-			goto fail;
-		}
-
-		/* init DMA for U channel */
-		if (size_u)
-			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, CIBR1,
-						   size_u, size_y);
-		if (ret) {
-			dev_err(dev, "DMA initialization for U failed\n");
-			goto fail;
-		}
-
-		/* init DMA for V channel */
-		if (size_v)
-			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, CIBR2,
-						   size_v, size_y + size_u);
-		if (ret) {
-			dev_err(dev, "DMA initialization for V failed\n");
-			goto fail;
-		}
-
-		vb->state = VIDEOBUF_PREPARED;
-	}
-
-	buf->inwork = 0;
-	pxa_videobuf_set_actdma(pcdev, buf);
-
-	return 0;
-
-fail:
-	free_buffer(vq, buf);
-out:
-	buf->inwork = 0;
-	return ret;
-}
-
 /**
  * pxa_dma_start_channels - start DMA channel for active buffer
  * @pcdev: pxa camera device
@@ -512,7 +347,7 @@ static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
 	active = pcdev->active;
 
 	for (i = 0; i < pcdev->channels; i++) {
-		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+		dev_dbg(pcdev_to_dev(pcdev),
 			"%s (channel=%d)\n", __func__, i);
 		dma_async_issue_pending(pcdev->dma_chans[i]);
 	}
@@ -523,7 +358,7 @@ static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
 	int i;
 
 	for (i = 0; i < pcdev->channels; i++) {
-		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+		dev_dbg(pcdev_to_dev(pcdev),
 			"%s (channel=%d)\n", __func__, i);
 		dmaengine_terminate_all(pcdev->dma_chans[i]);
 	}
@@ -536,7 +371,7 @@ static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
 
 	for (i = 0; i < pcdev->channels; i++) {
 		buf->cookie[i] = dmaengine_submit(buf->descs[i]);
-		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+		dev_dbg(pcdev_to_dev(pcdev),
 			"%s (channel=%d) : submit vb=%p cookie=%d\n",
 			__func__, i, buf, buf->descs[i]->cookie);
 	}
@@ -554,7 +389,7 @@ static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
 {
 	unsigned long cicr0;
 
-	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s\n", __func__);
+	dev_dbg(pcdev_to_dev(pcdev), "%s\n", __func__);
 	__raw_writel(__raw_readl(pcdev->base + CISR), pcdev->base + CISR);
 	/* Enable End-Of-Frame Interrupt */
 	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
@@ -572,72 +407,20 @@ static void pxa_camera_stop_capture(struct pxa_camera_dev *pcdev)
 	__raw_writel(cicr0, pcdev->base + CICR0);
 
 	pcdev->active = NULL;
-	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s\n", __func__);
-}
-
-/* Called under spinlock_irqsave(&pcdev->lock, ...) */
-static void pxa_videobuf_queue(struct videobuf_queue *vq,
-			       struct videobuf_buffer *vb)
-{
-	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
-
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d active=%p\n",
-		__func__, vb, vb->baddr, vb->bsize, pcdev->active);
-
-	list_add_tail(&vb->queue, &pcdev->capture);
-
-	vb->state = VIDEOBUF_ACTIVE;
-	pxa_dma_add_tail_buf(pcdev, buf);
-
-	if (!pcdev->active)
-		pxa_camera_start_capture(pcdev);
-}
-
-static void pxa_videobuf_release(struct videobuf_queue *vq,
-				 struct videobuf_buffer *vb)
-{
-	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
-#ifdef DEBUG
-	struct soc_camera_device *icd = vq->priv_data;
-	struct device *dev = icd->parent;
-
-	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
-
-	switch (vb->state) {
-	case VIDEOBUF_ACTIVE:
-		dev_dbg(dev, "%s (active)\n", __func__);
-		break;
-	case VIDEOBUF_QUEUED:
-		dev_dbg(dev, "%s (queued)\n", __func__);
-		break;
-	case VIDEOBUF_PREPARED:
-		dev_dbg(dev, "%s (prepared)\n", __func__);
-		break;
-	default:
-		dev_dbg(dev, "%s (unknown)\n", __func__);
-		break;
-	}
-#endif
-
-	free_buffer(vq, buf);
+	dev_dbg(pcdev_to_dev(pcdev), "%s\n", __func__);
 }
 
 static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
-			      struct videobuf_buffer *vb,
 			      struct pxa_buffer *buf)
 {
+	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
+
 	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
-	list_del_init(&vb->queue);
-	vb->state = VIDEOBUF_DONE;
-	v4l2_get_timestamp(&vb->ts);
-	vb->field_count++;
-	wake_up(&vb->done);
-	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s dequeud buffer (vb=0x%p)\n",
-		__func__, vb);
+	list_del_init(&buf->queue);
+	vb->timestamp = ktime_get_ns();
+	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+	dev_dbg(pcdev_to_dev(pcdev), "%s dequeud buffer (buf=0x%p)\n",
+		__func__, buf);
 
 	if (list_empty(&pcdev->capture)) {
 		pxa_camera_stop_capture(pcdev);
@@ -645,7 +428,7 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 	}
 
 	pcdev->active = list_entry(pcdev->capture.next,
-				   struct pxa_buffer, vb.queue);
+				   struct pxa_buffer, queue);
 }
 
 /**
@@ -670,7 +453,7 @@ static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev,
 {
 	bool is_dma_stopped = last_submitted != last_issued;
 
-	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+	dev_dbg(pcdev_to_dev(pcdev),
 		"%s : top queued buffer=%p, is_dma_stopped=%d\n",
 		__func__, pcdev->active, is_dma_stopped);
 
@@ -681,12 +464,11 @@ static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev,
 static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
 			       enum pxa_camera_active_dma act_dma)
 {
-	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
+	struct device *dev = pcdev_to_dev(pcdev);
 	struct pxa_buffer *buf, *last_buf;
 	unsigned long flags;
 	u32 camera_status, overrun;
 	int chan;
-	struct videobuf_buffer *vb;
 	enum dma_status last_status;
 	dma_cookie_t last_issued;
 
@@ -714,9 +496,8 @@ static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
 	if (!pcdev->active)
 		goto out;
 
-	vb = &pcdev->active->vb;
-	buf = container_of(vb, struct pxa_buffer, vb);
-	WARN_ON(buf->inwork || list_empty(&vb->queue));
+	buf = pcdev->active;
+	WARN_ON(buf->inwork || list_empty(&buf->queue));
 
 	/*
 	 * It's normal if the last frame creates an overrun, as there
@@ -734,7 +515,7 @@ static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
 		break;
 	}
 	last_buf = list_entry(pcdev->capture.prev,
-			      struct pxa_buffer, vb.queue);
+			      struct pxa_buffer, queue);
 	last_status = dma_async_is_tx_complete(pcdev->dma_chans[chan],
 					       last_buf->cookie[chan],
 					       NULL, &last_issued);
@@ -743,14 +524,14 @@ static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
 		dev_dbg(dev, "FIFO overrun! CISR: %x\n",
 			camera_status);
 		pxa_camera_stop_capture(pcdev);
-		list_for_each_entry(buf, &pcdev->capture, vb.queue)
+		list_for_each_entry(buf, &pcdev->capture, queue)
 			pxa_dma_add_tail_buf(pcdev, buf);
 		pxa_camera_start_capture(pcdev);
 		goto out;
 	}
 	buf->active_dma &= ~act_dma;
 	if (!buf->active_dma) {
-		pxa_camera_wakeup(pcdev, vb, buf);
+		pxa_camera_wakeup(pcdev, buf);
 		pxa_camera_check_link_miss(pcdev, last_buf->cookie[chan],
 					   last_issued);
 	}
@@ -759,26 +540,226 @@ out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
-static struct videobuf_queue_ops pxa_videobuf_ops = {
-	.buf_setup      = pxa_videobuf_setup,
-	.buf_prepare    = pxa_videobuf_prepare,
-	.buf_queue      = pxa_videobuf_queue,
-	.buf_release    = pxa_videobuf_release,
+static void pxa_buffer_cleanup(struct pxa_buffer *buf)
+{
+	int i;
+
+	for (i = 0; i < 3 && buf->descs[i]; i++) {
+		dmaengine_desc_free(buf->descs[i]);
+		kfree(buf->sg[i]);
+		buf->descs[i] = NULL;
+		buf->sg[i] = NULL;
+		buf->sg_len[i] = 0;
+		buf->plane_sizes[i] = 0;
+	}
+	buf->nb_planes = 0;
+}
+
+static int pxa_buffer_init(struct pxa_camera_dev *pcdev,
+			   struct pxa_buffer *buf)
+{
+	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+	int nb_channels = pcdev->channels;
+	int i, ret = 0;
+	unsigned long size = vb2_plane_size(vb, 0);
+
+	switch (nb_channels) {
+	case 1:
+		buf->plane_sizes[0] = size;
+		break;
+	case 3:
+		buf->plane_sizes[0] = size / 2;
+		buf->plane_sizes[1] = size / 4;
+		buf->plane_sizes[2] = size / 4;
+		break;
+	default:
+		return -EINVAL;
+	};
+	buf->nb_planes = nb_channels;
+
+	ret = sg_split(sgt->sgl, sgt->nents, 0, nb_channels,
+		       buf->plane_sizes, buf->sg, buf->sg_len, GFP_KERNEL);
+	if (ret < 0) {
+		dev_err(pcdev_to_dev(pcdev),
+			"sg_split failed: %d\n", ret);
+		return ret;
+	}
+	for (i = 0; i < nb_channels; i++) {
+		ret = pxa_init_dma_channel(pcdev, buf, i,
+					   buf->sg[i], buf->sg_len[i]);
+		if (ret) {
+			pxa_buffer_cleanup(buf);
+			return ret;
+		}
+	}
+	INIT_LIST_HEAD(&buf->queue);
+
+	return ret;
+}
+
+static void pxac_vb2_cleanup(struct vb2_buffer *vb)
+{
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vb=%p)\n", __func__, vb);
+	pxa_buffer_cleanup(buf);
+}
+
+static void pxac_vb2_queue(struct vb2_buffer *vb)
+{
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vb=%p) nb_channels=%d size=%lu active=%p\n",
+		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0),
+		pcdev->active);
+
+	list_add_tail(&buf->queue, &pcdev->capture);
+
+	pxa_dma_add_tail_buf(pcdev, buf);
+
+	if (!pcdev->active)
+		pxa_camera_start_capture(pcdev);
+}
+
+/*
+ * Please check the DMA prepared buffer structure in :
+ *   Documentation/video4linux/pxa_camera.txt
+ * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
+ * modification while DMA chain is running will work anyway.
+ */
+static int pxac_vb2_prepare(struct vb2_buffer *vb)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	int ret = 0;
+
+	switch (pcdev->channels) {
+	case 1:
+	case 3:
+		vb2_set_plane_payload(vb, 0, icd->sizeimage);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s (vb=%p) nb_channels=%d size=%lu\n",
+		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0));
+
+	WARN_ON(!icd->current_fmt);
+
+#ifdef DEBUG
+	/*
+	 * This can be useful if you want to see if we actually fill
+	 * the buffer with something
+	 */
+	for (i = 0; i < vb->num_planes; i++)
+		memset((void *)vb2_plane_vaddr(vb, i),
+		       0xaa, vb2_get_plane_payload(vb, i));
+#endif
+
+	/*
+	 * I think, in buf_prepare you only have to protect global data,
+	 * the actual buffer is yours
+	 */
+	buf->inwork = 0;
+	pxa_videobuf_set_actdma(pcdev, buf);
+
+	return ret;
+}
+
+static int pxac_vb2_init(struct vb2_buffer *vb)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(nb_channels=%d)\n",
+		__func__, pcdev->channels);
+
+	return pxa_buffer_init(pcdev, buf);
+}
+
+static int pxac_vb2_queue_setup(struct vb2_queue *vq,
+				unsigned int *nbufs,
+				unsigned int *num_planes, unsigned int sizes[],
+				void *alloc_ctxs[])
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
+	int size = icd->sizeimage;
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vq=%p nbufs=%d num_planes=%d size=%d)\n",
+		__func__, vq, *nbufs, *num_planes, size);
+	/*
+	 * Called from VIDIOC_REQBUFS or in compatibility mode For YUV422P
+	 * format, even if there are 3 planes Y, U and V, we reply there is only
+	 * one plane, containing Y, U and V data, one after the other.
+	 */
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*num_planes = 1;
+	switch (pcdev->channels) {
+	case 1:
+	case 3:
+		sizes[0] = size;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	alloc_ctxs[0] = pcdev->alloc_ctx;
+	if (!*nbufs)
+		*nbufs = 1;
+
+	return 0;
+}
+
+static void pxac_vb2_stop_streaming(struct vb2_queue *vq)
+{
+	vb2_wait_for_all_buffers(vq);
+}
+
+static struct vb2_ops pxac_vb2_ops = {
+	.queue_setup		= pxac_vb2_queue_setup,
+	.buf_init		= pxac_vb2_init,
+	.buf_prepare		= pxac_vb2_prepare,
+	.buf_queue		= pxac_vb2_queue,
+	.buf_cleanup		= pxac_vb2_cleanup,
+	.stop_streaming		= pxac_vb2_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
-static void pxa_camera_init_videobuf(struct videobuf_queue *q,
-			      struct soc_camera_device *icd)
+static int pxa_camera_init_videobuf2(struct vb2_queue *vq,
+				     struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
+	int ret;
 
-	/*
-	 * We must pass NULL as dev pointer, then all pci_* dma operations
-	 * transform to normal dma_* ones.
-	 */
-	videobuf_queue_sg_init(q, &pxa_videobuf_ops, NULL, &pcdev->lock,
-				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct pxa_buffer), icd, &ici->host_lock);
+	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	vq->drv_priv = pcdev;
+	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	vq->buf_struct_size = sizeof(struct pxa_buffer);
+
+	vq->ops = &pxac_vb2_ops;
+	vq->mem_ops = &vb2_dma_sg_memops;
+
+	ret = vb2_queue_init(vq);
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "vb2_queue_init(vq=%p): %d\n", vq, ret);
+
+	return ret;
 }
 
 static u32 mclk_get_divisor(struct platform_device *pdev,
@@ -860,9 +841,8 @@ static void pxa_camera_eof(unsigned long arg)
 	struct pxa_camera_dev *pcdev = (struct pxa_camera_dev *)arg;
 	unsigned long cifr;
 	struct pxa_buffer *buf;
-	struct videobuf_buffer *vb;
 
-	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+	dev_dbg(pcdev_to_dev(pcdev),
 		"Camera interrupt status 0x%x\n",
 		__raw_readl(pcdev->base + CISR));
 
@@ -871,9 +851,8 @@ static void pxa_camera_eof(unsigned long arg)
 	__raw_writel(cifr, pcdev->base + CIFR);
 
 	pcdev->active = list_first_entry(&pcdev->capture,
-					 struct pxa_buffer, vb.queue);
-	vb = &pcdev->active->vb;
-	buf = container_of(vb, struct pxa_buffer, vb);
+					 struct pxa_buffer, queue);
+	buf = pcdev->active;
 	pxa_videobuf_set_actdma(pcdev, buf);
 
 	pxa_dma_start_channels(pcdev);
@@ -885,7 +864,7 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	unsigned long status, cicr0;
 
 	status = __raw_readl(pcdev->base + CISR);
-	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+	dev_dbg(pcdev_to_dev(pcdev),
 		"Camera interrupt status 0x%lx\n", status);
 
 	if (!status)
@@ -1489,42 +1468,11 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int pxa_camera_reqbufs(struct soc_camera_device *icd,
-			      struct v4l2_requestbuffers *p)
-{
-	int i;
-
-	/*
-	 * This is for locking debugging only. I removed spinlocks and now I
-	 * check whether .prepare is ever called on a linked buffer, or whether
-	 * a dma IRQ can occur for an in-work or unlinked buffer. Until now
-	 * it hadn't triggered
-	 */
-	for (i = 0; i < p->count; i++) {
-		struct pxa_buffer *buf = container_of(icd->vb_vidq.bufs[i],
-						      struct pxa_buffer, vb);
-		buf->inwork = 0;
-		INIT_LIST_HEAD(&buf->vb.queue);
-	}
-
-	return 0;
-}
-
 static unsigned int pxa_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct pxa_buffer *buf;
-
-	buf = list_entry(icd->vb_vidq.stream.next, struct pxa_buffer,
-			 vb.stream);
-
-	poll_wait(file, &buf->vb.done, pt);
 
-	if (buf->vb.state == VIDEOBUF_DONE ||
-	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN|POLLRDNORM;
-
-	return 0;
+	return vb2_poll(&icd->vb2_vidq, file, pt);
 }
 
 static int pxa_camera_querycap(struct soc_camera_host *ici,
@@ -1597,8 +1545,7 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.put_formats	= pxa_camera_put_formats,
 	.set_fmt	= pxa_camera_set_fmt,
 	.try_fmt	= pxa_camera_try_fmt,
-	.init_videobuf	= pxa_camera_init_videobuf,
-	.reqbufs	= pxa_camera_reqbufs,
+	.init_videobuf2	= pxa_camera_init_videobuf2,
 	.poll		= pxa_camera_poll,
 	.querycap	= pxa_camera_querycap,
 	.set_bus_param	= pxa_camera_set_bus_param,
@@ -1692,6 +1639,10 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	pcdev->alloc_ctx = vb2_dma_sg_init_ctx(&pdev->dev);
+	if (IS_ERR(pcdev->alloc_ctx))
+		return PTR_ERR(pcdev->alloc_ctx);
+
 	pcdev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pcdev->clk))
 		return PTR_ERR(pcdev->clk);
@@ -1828,6 +1779,7 @@ static int pxa_camera_remove(struct platform_device *pdev)
 	dma_release_channel(pcdev->dma_chans[0]);
 	dma_release_channel(pcdev->dma_chans[1]);
 	dma_release_channel(pcdev->dma_chans[2]);
+	vb2_dma_sg_cleanup_ctx(pcdev->alloc_ctx);
 
 	soc_camera_host_unregister(soc_host);
 
-- 
2.1.4

