Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:63970 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab1A2Rbr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jan 2011 12:31:47 -0500
Date: Sat, 29 Jan 2011 18:30:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Baruch Siach <baruch@tkos.co.il>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [PATCH/RFC 3/3 v2] V4L: sh_mobile_ceu_camera: convert to videobuf2
In-Reply-To: <Pine.LNX.4.64.1101290152070.19247@axis700.grange>
Message-ID: <Pine.LNX.4.64.1101291827260.26696@axis700.grange>
References: <Pine.LNX.4.64.1101290113500.19247@axis700.grange>
 <Pine.LNX.4.64.1101290152070.19247@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Convert the sh_mobile_ceu_camera driver to the videobuf2 API.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v2:

1. adjusted to v2 of the "vb2 for soc-camera" patch
2. fixed a this-certainly-will-work-too-don't-have-to-retest screw-up

 drivers/media/video/Kconfig                |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c |  251 ++++++++++++----------------
 2 files changed, 105 insertions(+), 148 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f26aa3e..e392192 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -877,7 +877,7 @@ config VIDEO_SH_MOBILE_CSI2
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for the SuperH Mobile CEU Interface
 
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 954222b..5a8d942 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -38,7 +38,7 @@
 #include <media/v4l2-dev.h>
 #include <media/soc_camera.h>
 #include <media/sh_mobile_ceu.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-mediabus.h>
 #include <media/soc_mediabus.h>
 
@@ -87,7 +87,8 @@
 
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
-	struct videobuf_buffer vb; /* v4l buffer must be first */
+	struct vb2_buffer vb; /* v4l buffer must be first */
+	struct list_head queue;
 	enum v4l2_mbus_pixelcode code;
 };
 
@@ -102,13 +103,15 @@ struct sh_mobile_ceu_dev {
 	/* lock used to protect videobuf */
 	spinlock_t lock;
 	struct list_head capture;
-	struct videobuf_buffer *active;
+	struct vb2_buffer *active;
+	struct vb2_alloc_ctx *alloc_ctx;
 
 	struct sh_mobile_ceu_info *pdata;
 
 	u32 cflcr;
 
 	enum v4l2_field field;
+	int sequence;
 
 	unsigned int image_mode:1;
 	unsigned int is_16bit:1;
@@ -133,6 +136,11 @@ struct sh_mobile_ceu_cam {
 	enum v4l2_mbus_pixelcode code;
 };
 
+static struct sh_mobile_ceu_buffer *to_ceu_vb(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct sh_mobile_ceu_buffer, vb);
+}
+
 static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
 {
 	unsigned long flags;
@@ -205,11 +213,11 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
 /*
  *  Videobuf operations
  */
-static int sh_mobile_ceu_videobuf_setup(struct videobuf_queue *vq,
-					unsigned int *count,
-					unsigned int *size)
+static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
+			unsigned int *count, unsigned int *num_planes,
+			unsigned long sizes[], void *alloc_ctxs[])
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
@@ -218,39 +226,25 @@ static int sh_mobile_ceu_videobuf_setup(struct videobuf_queue *vq,
 	if (bytes_per_line < 0)
 		return bytes_per_line;
 
-	*size = bytes_per_line * icd->user_height;
+	*num_planes = 1;
 
-	if (0 == *count)
+	pcdev->sequence = 0;
+	sizes[0] = bytes_per_line * icd->user_height;
+	alloc_ctxs[0] = pcdev->alloc_ctx;
+
+	if (!*count)
 		*count = 2;
 
 	if (pcdev->video_limit) {
-		if (PAGE_ALIGN(*size) * *count > pcdev->video_limit)
-			*count = pcdev->video_limit / PAGE_ALIGN(*size);
+		if (PAGE_ALIGN(sizes[0]) * *count > pcdev->video_limit)
+			*count = pcdev->video_limit / PAGE_ALIGN(sizes[0]);
 	}
 
-	dev_dbg(icd->dev.parent, "count=%d, size=%d\n", *count, *size);
+	dev_dbg(icd->dev.parent, "count=%d, size=%lu\n", *count, sizes[0]);
 
 	return 0;
 }
 
-static void free_buffer(struct videobuf_queue *vq,
-			struct sh_mobile_ceu_buffer *buf)
-{
-	struct soc_camera_device *icd = vq->priv_data;
-	struct device *dev = icd->dev.parent;
-
-	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
-		&buf->vb, buf->vb.baddr, buf->vb.bsize);
-
-	if (in_interrupt())
-		BUG();
-
-	videobuf_waiton(vq, &buf->vb, 0, 0);
-	videobuf_dma_contig_free(vq, &buf->vb);
-	dev_dbg(dev, "%s freed\n", __func__);
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
-}
-
 #define CEU_CETCR_MAGIC 0x0317f313 /* acknowledge magical interrupt sources */
 #define CEU_CETCR_IGRW (1 << 4) /* prohibited register access interrupt bit */
 #define CEU_CEIER_CPEIE (1 << 0) /* one-frame capture end interrupt */
@@ -309,7 +303,10 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		bottom2	= CDBCR;
 	}
 
-	phys_addr_top = videobuf_to_dma_contig(pcdev->active);
+	/* mem_ops->cookie must not be NULL */
+	phys_addr_top = (dma_addr_t)icd->vb2_vidq.mem_ops->cookie(pcdev->
+						active->planes[0].mem_priv);
+
 	ceu_write(pcdev, top1, phys_addr_top);
 	if (V4L2_FIELD_NONE != pcdev->field) {
 		phys_addr_bottom = phys_addr_top + icd->user_width;
@@ -330,87 +327,66 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		}
 	}
 
-	pcdev->active->state = VIDEOBUF_ACTIVE;
 	ceu_write(pcdev, CAPSR, 0x1); /* start capture */
 
 	return ret;
 }
 
-static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
-					  struct videobuf_buffer *vb,
-					  enum v4l2_field field)
+static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
 	struct sh_mobile_ceu_buffer *buf;
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 						icd->current_fmt->host_fmt);
-	int ret;
+	unsigned long size;
 
 	if (bytes_per_line < 0)
 		return bytes_per_line;
 
-	buf = container_of(vb, struct sh_mobile_ceu_buffer, vb);
+	buf = to_ceu_vb(vb);
 
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
-		vb, vb->baddr, vb->bsize);
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
+		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
 	/* Added list head initialization on alloc */
-	WARN_ON(!list_empty(&vb->queue));
+	WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
 
 #ifdef DEBUG
 	/*
 	 * This can be useful if you want to see if we actually fill
 	 * the buffer with something
 	 */
-	memset((void *)vb->baddr, 0xaa, vb->bsize);
+	if (vb2_plane_vaddr(vb, 0))
+		memset(vb2_plane_vaddr(vb, 0), 0xaa, vb2_get_plane_payload(vb, 0));
 #endif
 
 	BUG_ON(NULL == icd->current_fmt);
 
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
+	size = icd->user_height * bytes_per_line;
 
-	vb->size = vb->height * bytes_per_line;
-	if (0 != vb->baddr && vb->bsize < vb->size) {
-		ret = -EINVAL;
-		goto out;
+	if (vb2_plane_size(vb, 0) < size) {
+		dev_err(icd->dev.parent, "Buffer too small (%lu < %lu)\n",
+			vb2_plane_size(vb, 0), size);
+		return -ENOBUFS;
 	}
 
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret)
-			goto fail;
-		vb->state = VIDEOBUF_PREPARED;
-	}
+	vb2_set_plane_payload(vb, 0, size);
 
 	return 0;
-fail:
-	free_buffer(vq, buf);
-out:
-	return ret;
 }
 
 /* Called under spinlock_irqsave(&pcdev->lock, ...) */
-static void sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
-					 struct videobuf_buffer *vb)
+static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
 
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
-		vb, vb->baddr, vb->bsize);
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
+		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
-	vb->state = VIDEOBUF_QUEUED;
-	list_add_tail(&vb->queue, &pcdev->capture);
+	list_add_tail(&buf->queue, &pcdev->capture);
 
 	if (!pcdev->active) {
 		/*
@@ -423,11 +399,11 @@ static void sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
 	}
 }
 
-static void sh_mobile_ceu_videobuf_release(struct videobuf_queue *vq,
-					   struct videobuf_buffer *vb)
+static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	unsigned long flags;
 
@@ -439,29 +415,35 @@ static void sh_mobile_ceu_videobuf_release(struct videobuf_queue *vq,
 		pcdev->active = NULL;
 	}
 
-	if ((vb->state == VIDEOBUF_ACTIVE || vb->state == VIDEOBUF_QUEUED) &&
-	    !list_empty(&vb->queue)) {
-		vb->state = VIDEOBUF_ERROR;
-		list_del_init(&vb->queue);
-	}
+	/* Doesn't hurt also if the list is empty */
+	list_del_init(&buf->queue);
 
 	spin_unlock_irqrestore(&pcdev->lock, flags);
+}
 
-	free_buffer(vq, container_of(vb, struct sh_mobile_ceu_buffer, vb));
+static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
+{
+	/* This is for locking debugging only */
+	INIT_LIST_HEAD(&to_ceu_vb(vb)->queue);
+	return 0;
 }
 
-static struct videobuf_queue_ops sh_mobile_ceu_videobuf_ops = {
-	.buf_setup      = sh_mobile_ceu_videobuf_setup,
-	.buf_prepare    = sh_mobile_ceu_videobuf_prepare,
-	.buf_queue      = sh_mobile_ceu_videobuf_queue,
-	.buf_release    = sh_mobile_ceu_videobuf_release,
+static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
+	.queue_setup	= sh_mobile_ceu_videobuf_setup,
+	.buf_prepare	= sh_mobile_ceu_videobuf_prepare,
+	.buf_queue	= sh_mobile_ceu_videobuf_queue,
+	.buf_cleanup	= sh_mobile_ceu_videobuf_release,
+	.buf_init	= sh_mobile_ceu_videobuf_init,
+	.wait_prepare	= soc_camera_unlock,
+	.wait_finish	= soc_camera_lock,
 };
 
 static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 {
 	struct sh_mobile_ceu_dev *pcdev = data;
-	struct videobuf_buffer *vb;
+	struct vb2_buffer *vb;
 	unsigned long flags;
+	int ret;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
@@ -470,19 +452,21 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 		/* Stale interrupt from a released buffer */
 		goto out;
 
-	list_del_init(&vb->queue);
+	list_del_init(&to_ceu_vb(vb)->queue);
 
 	if (!list_empty(&pcdev->capture))
-		pcdev->active = list_entry(pcdev->capture.next,
-					   struct videobuf_buffer, queue);
+		pcdev->active = &list_entry(pcdev->capture.next,
+					    struct sh_mobile_ceu_buffer, queue)->vb;
 	else
 		pcdev->active = NULL;
 
-	vb->state = (sh_mobile_ceu_capture(pcdev) < 0) ?
-		VIDEOBUF_ERROR : VIDEOBUF_DONE;
-	do_gettimeofday(&vb->ts);
-	vb->field_count++;
-	wake_up(&vb->done);
+	ret = sh_mobile_ceu_capture(pcdev);
+	do_gettimeofday(&vb->v4l2_buf.timestamp);
+	if (!ret) {
+		vb->v4l2_buf.field = pcdev->field;
+		vb->v4l2_buf.sequence = pcdev->sequence++;
+	}
+	vb2_buffer_done(vb, ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
@@ -529,9 +513,8 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 	/* make sure active buffer is canceled */
 	spin_lock_irqsave(&pcdev->lock, flags);
 	if (pcdev->active) {
-		list_del(&pcdev->active->queue);
-		pcdev->active->state = VIDEOBUF_ERROR;
-		wake_up_all(&pcdev->active->done);
+		list_del_init(&to_ceu_vb(pcdev->active)->queue);
+		vb2_buffer_done(pcdev->active, VB2_BUF_STATE_ERROR);
 		pcdev->active = NULL;
 	}
 	spin_unlock_irqrestore(&pcdev->lock, flags);
@@ -1726,43 +1709,11 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int sh_mobile_ceu_reqbufs(struct soc_camera_device *icd,
-				 struct v4l2_requestbuffers *p)
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
-		struct sh_mobile_ceu_buffer *buf;
-
-		buf = container_of(icd->vb_vidq.bufs[i],
-				   struct sh_mobile_ceu_buffer, vb);
-		INIT_LIST_HEAD(&buf->vb.queue);
-	}
-
-	return 0;
-}
-
 static unsigned int sh_mobile_ceu_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct sh_mobile_ceu_buffer *buf;
 
-	buf = list_entry(icd->vb_vidq.stream.next,
-			 struct sh_mobile_ceu_buffer, vb.stream);
-
-	poll_wait(file, &buf->vb.done, pt);
-
-	if (buf->vb.state == VIDEOBUF_DONE ||
-	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN|POLLRDNORM;
-
-	return 0;
+	return vb2_poll(&icd->vb2_vidq, file, pt);
 }
 
 static int sh_mobile_ceu_querycap(struct soc_camera_host *ici,
@@ -1774,19 +1725,17 @@ static int sh_mobile_ceu_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
-static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
-					struct soc_camera_device *icd)
+static int sh_mobile_ceu_init_videobuf(struct vb2_queue *q,
+				       struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-
-	videobuf_queue_dma_contig_init(q,
-				       &sh_mobile_ceu_videobuf_ops,
-				       icd->dev.parent, &pcdev->lock,
-				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				       pcdev->field,
-				       sizeof(struct sh_mobile_ceu_buffer),
-				       icd, &icd->video_lock);
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = icd;
+	q->ops = &sh_mobile_ceu_videobuf_ops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct sh_mobile_ceu_buffer);
+
+	return vb2_queue_init(q);
 }
 
 static int sh_mobile_ceu_get_ctrl(struct soc_camera_device *icd,
@@ -1850,11 +1799,10 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.try_fmt	= sh_mobile_ceu_try_fmt,
 	.set_ctrl	= sh_mobile_ceu_set_ctrl,
 	.get_ctrl	= sh_mobile_ceu_get_ctrl,
-	.reqbufs	= sh_mobile_ceu_reqbufs,
 	.poll		= sh_mobile_ceu_poll,
 	.querycap	= sh_mobile_ceu_querycap,
 	.set_bus_param	= sh_mobile_ceu_set_bus_param,
-	.init_videobuf	= sh_mobile_ceu_init_videobuf,
+	.init_videobuf2	= sh_mobile_ceu_init_videobuf,
 	.controls	= sh_mobile_ceu_controls,
 	.num_controls	= ARRAY_SIZE(sh_mobile_ceu_controls),
 };
@@ -2005,12 +1953,20 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 		}
 	}
 
+	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(pcdev->alloc_ctx)) {
+		err = PTR_ERR(pcdev->alloc_ctx);
+		goto exit_module_put;
+	}
+
 	err = soc_camera_host_register(&pcdev->ici);
 	if (err)
-		goto exit_module_put;
+		goto exit_free_ctx;
 
 	return 0;
 
+exit_free_ctx:
+	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 exit_module_put:
 	if (csi2 && csi2->driver)
 		module_put(csi2->driver->owner);
@@ -2041,6 +1997,7 @@ static int __devexit sh_mobile_ceu_remove(struct platform_device *pdev)
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
 		dma_release_declared_memory(&pdev->dev);
 	iounmap(pcdev->base);
+	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	if (csi2 && csi2->driver)
 		module_put(csi2->driver->owner);
 	kfree(pcdev);
-- 
1.7.2.3

