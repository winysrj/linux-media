Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47094 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2AZMEr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 07:04:47 -0500
Received: by wgbgn7 with SMTP id gn7so739873wgb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 04:04:45 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, s.hauer@pengutronix.de, baruch@tkos.co.il,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 1/4] media i.MX27 camera: migrate driver to videobuf2
Date: Thu, 26 Jan 2012 13:04:29 +0100
Message-Id: <1327579472-31597-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 Changes since v1:
 - mx27 code doesn't use states.
 - number of states reduced to the ones used by mx25.
 - Fix incorrect if which broke mx25 support.
 - Minor fixes.

---
 drivers/media/video/mx2_camera.c |  298 ++++++++++++++++----------------------
 1 files changed, 127 insertions(+), 171 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index ca76dd2..898f98f 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2008, Sascha Hauer, Pengutronix
  * Copyright (C) 2010, Baruch Siach, Orex Computed Radiography
+ * Copyright (C) 2012, Javier Martin, Vista Silicon S.L.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -30,8 +31,8 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
-#include <media/videobuf-core.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
 
@@ -223,6 +224,22 @@ struct mx2_fmt_cfg {
 	struct mx2_prp_cfg		cfg;
 };
 
+enum mx2_buffer_state {
+	MX2_STATE_QUEUED,
+	MX2_STATE_ACTIVE,
+	MX2_STATE_DONE,
+};
+
+/* buffer for one video frame */
+struct mx2_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_buffer		vb;
+	struct list_head		queue;
+	enum mx2_buffer_state		state;
+
+	int bufnum;
+};
+
 struct mx2_camera_dev {
 	struct device		*dev;
 	struct soc_camera_host	soc_host;
@@ -256,16 +273,7 @@ struct mx2_camera_dev {
 	size_t			discard_size;
 	struct mx2_fmt_cfg	*emma_prp;
 	u32			frame_count;
-};
-
-/* buffer for one video frame */
-struct mx2_buffer {
-	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer		vb;
-
-	enum v4l2_mbus_pixelcode	code;
-
-	int bufnum;
+	struct vb2_alloc_ctx	*alloc_ctx;
 };
 
 static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
@@ -407,7 +415,7 @@ static irqreturn_t mx27_camera_irq(int irq_csi, void *data)
 static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
 		int state)
 {
-	struct videobuf_buffer *vb;
+	struct vb2_buffer *vb;
 	struct mx2_buffer *buf;
 	struct mx2_buffer **fb_active = fb == 1 ? &pcdev->fb1_active :
 		&pcdev->fb2_active;
@@ -420,25 +428,24 @@ static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
 		goto out;
 
 	vb = &(*fb_active)->vb;
-	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
+	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%p %lu\n", __func__,
+		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
-	vb->state = state;
-	do_gettimeofday(&vb->ts);
-	vb->field_count++;
-
-	wake_up(&vb->done);
+	do_gettimeofday(&vb->v4l2_buf.timestamp);
+	vb->v4l2_buf.sequence++;
+	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 
 	if (list_empty(&pcdev->capture)) {
 		buf = NULL;
 		writel(0, pcdev->base_csi + fb_reg);
 	} else {
 		buf = list_entry(pcdev->capture.next, struct mx2_buffer,
-				vb.queue);
+				queue);
 		vb = &buf->vb;
-		list_del(&vb->queue);
-		vb->state = VIDEOBUF_ACTIVE;
-		writel(videobuf_to_dma_contig(vb), pcdev->base_csi + fb_reg);
+		list_del(&buf->queue);
+		buf->state = MX2_STATE_ACTIVE;
+		writel(vb2_dma_contig_plane_dma_addr(vb, 0),
+		       pcdev->base_csi + fb_reg);
 	}
 
 	*fb_active = buf;
@@ -453,9 +460,9 @@ static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
 	u32 status = readl(pcdev->base_csi + CSISR);
 
 	if (status & CSISR_DMA_TSF_FB1_INT)
-		mx25_camera_frame_done(pcdev, 1, VIDEOBUF_DONE);
+		mx25_camera_frame_done(pcdev, 1, MX2_STATE_DONE);
 	else if (status & CSISR_DMA_TSF_FB2_INT)
-		mx25_camera_frame_done(pcdev, 2, VIDEOBUF_DONE);
+		mx25_camera_frame_done(pcdev, 2, MX2_STATE_DONE);
 
 	/* FIXME: handle CSISR_RFF_OR_INT */
 
@@ -467,59 +474,50 @@ static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
 /*
  *  Videobuf operations
  */
-static int mx2_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
-			      unsigned int *size)
+static int mx2_videobuf_setup(struct vb2_queue *vq,
+			const struct v4l2_format *fmt,
+			unsigned int *count, unsigned int *num_planes,
+			unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mx2_camera_dev *pcdev = ici->priv;
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 			icd->current_fmt->host_fmt);
 
-	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, *size);
+	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, sizes[0]);
+
+	/* TODO: support for VIDIOC_CREATE_BUFS not ready */
+	if (fmt != NULL)
+		return -EINVAL;
 
 	if (bytes_per_line < 0)
 		return bytes_per_line;
 
-	*size = bytes_per_line * icd->user_height;
+	alloc_ctxs[0] = pcdev->alloc_ctx;
+
+	sizes[0] = bytes_per_line * icd->user_height;
 
 	if (0 == *count)
 		*count = 32;
-	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
-		*count = (MAX_VIDEO_MEM * 1024 * 1024) / *size;
-
-	return 0;
-}
-
-static void free_buffer(struct videobuf_queue *vq, struct mx2_buffer *buf)
-{
-	struct soc_camera_device *icd = vq->priv_data;
-	struct videobuf_buffer *vb = &buf->vb;
-
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
-
-	/*
-	 * This waits until this buffer is out of danger, i.e., until it is no
-	 * longer in state VIDEOBUF_QUEUED or VIDEOBUF_ACTIVE
-	 */
-	videobuf_waiton(vq, vb, 0, 0);
+	if (!*num_planes &&
+	    sizes[0] * *count > MAX_VIDEO_MEM * 1024 * 1024)
+		*count = (MAX_VIDEO_MEM * 1024 * 1024) / sizes[0];
 
-	videobuf_dma_contig_free(vq, vb);
-	dev_dbg(icd->parent, "%s freed\n", __func__);
+	*num_planes = 1;
 
-	vb->state = VIDEOBUF_NEEDS_INIT;
+	return 0;
 }
 
-static int mx2_videobuf_prepare(struct videobuf_queue *vq,
-		struct videobuf_buffer *vb, enum v4l2_field field)
+static int mx2_videobuf_prepare(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
-	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 			icd->current_fmt->host_fmt);
 	int ret = 0;
 
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
+		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
 	if (bytes_per_line < 0)
 		return bytes_per_line;
@@ -529,59 +527,39 @@ static int mx2_videobuf_prepare(struct videobuf_queue *vq,
 	 * This can be useful if you want to see if we actually fill
 	 * the buffer with something
 	 */
-	memset((void *)vb->baddr, 0xaa, vb->bsize);
+	memset((void *)vb2_plane_vaddr(vb, 0),
+	       0xaa, vb2_get_plane_payload(vb, 0));
 #endif
 
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
-	vb->size = bytes_per_line * vb->height;
-	if (vb->baddr && vb->bsize < vb->size) {
+	vb2_set_plane_payload(vb, 0, bytes_per_line * icd->user_height);
+	if (vb2_plane_vaddr(vb, 0) &&
+	    vb2_get_plane_payload(vb, 0) < vb2_plane_size(vb, 0)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret)
-			goto fail;
-
-		vb->state = VIDEOBUF_PREPARED;
-	}
-
 	return 0;
 
-fail:
-	free_buffer(vq, buf);
 out:
 	return ret;
 }
 
-static void mx2_videobuf_queue(struct videobuf_queue *vq,
-			       struct videobuf_buffer *vb)
+static void mx2_videobuf_queue(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
 	unsigned long flags;
 
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
+		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
-	vb->state = VIDEOBUF_QUEUED;
-	list_add_tail(&vb->queue, &pcdev->capture);
+	buf->state = MX2_STATE_QUEUED;
+	list_add_tail(&buf->queue, &pcdev->capture);
 
 	if (mx27_camera_emma(pcdev)) {
 		goto out;
@@ -589,20 +567,20 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 		u32 csicr3, dma_inten = 0;
 
 		if (pcdev->fb1_active == NULL) {
-			writel(videobuf_to_dma_contig(vb),
+			writel(vb2_dma_contig_plane_dma_addr(vb, 0),
 					pcdev->base_csi + CSIDMASA_FB1);
 			pcdev->fb1_active = buf;
 			dma_inten = CSICR1_FB1_DMA_INTEN;
 		} else if (pcdev->fb2_active == NULL) {
-			writel(videobuf_to_dma_contig(vb),
+			writel(vb2_dma_contig_plane_dma_addr(vb, 0),
 					pcdev->base_csi + CSIDMASA_FB2);
 			pcdev->fb2_active = buf;
 			dma_inten = CSICR1_FB2_DMA_INTEN;
 		}
 
 		if (dma_inten) {
-			list_del(&vb->queue);
-			vb->state = VIDEOBUF_ACTIVE;
+			list_del(&buf->queue);
+			buf->state = MX2_STATE_ACTIVE;
 
 			csicr3 = readl(pcdev->base_csi + CSICR3);
 
@@ -625,50 +603,36 @@ out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
-static void mx2_videobuf_release(struct videobuf_queue *vq,
-				 struct videobuf_buffer *vb)
+static void mx2_videobuf_release(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
 	unsigned long flags;
 
 #ifdef DEBUG
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
+		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
-	switch (vb->state) {
-	case VIDEOBUF_ACTIVE:
+	switch (buf->state) {
+	case MX2_STATE_ACTIVE:
 		dev_info(icd->parent, "%s (active)\n", __func__);
 		break;
-	case VIDEOBUF_QUEUED:
+	case MX2_STATE_QUEUED:
 		dev_info(icd->parent, "%s (queued)\n", __func__);
 		break;
-	case VIDEOBUF_PREPARED:
-		dev_info(icd->parent, "%s (prepared)\n", __func__);
-		break;
 	default:
 		dev_info(icd->parent, "%s (unknown) %d\n", __func__,
-				vb->state);
+				buf->state);
 		break;
 	}
 #endif
 
-	/*
-	 * Terminate only queued but inactive buffers. Active buffers are
-	 * released when they become inactive after videobuf_waiton().
-	 *
-	 * FIXME: implement forced termination of active buffers for mx27 and
-	 * mx27 eMMA, so that the user won't get stuck in an uninterruptible
-	 * state. This requires a specific handling for each of the these DMA
-	 * types.
-	 */
 	spin_lock_irqsave(&pcdev->lock, flags);
-	if (vb->state == VIDEOBUF_QUEUED) {
-		list_del(&vb->queue);
-		vb->state = VIDEOBUF_ERROR;
-	} else if (cpu_is_mx25() && vb->state == VIDEOBUF_ACTIVE) {
+	if (mx27_camera_emma(pcdev)) {
+		list_del_init(&buf->queue);
+	} else if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
 		if (pcdev->fb1_active == buf) {
 			pcdev->csicr1 &= ~CSICR1_FB1_DMA_INTEN;
 			writel(0, pcdev->base_csi + CSIDMASA_FB1);
@@ -679,30 +643,28 @@ static void mx2_videobuf_release(struct videobuf_queue *vq,
 			pcdev->fb2_active = NULL;
 		}
 		writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
-		vb->state = VIDEOBUF_ERROR;
 	}
 	spin_unlock_irqrestore(&pcdev->lock, flags);
-
-	free_buffer(vq, buf);
 }
 
-static struct videobuf_queue_ops mx2_videobuf_ops = {
-	.buf_setup      = mx2_videobuf_setup,
-	.buf_prepare    = mx2_videobuf_prepare,
-	.buf_queue      = mx2_videobuf_queue,
-	.buf_release    = mx2_videobuf_release,
+static struct vb2_ops mx2_videobuf_ops = {
+	.queue_setup	= mx2_videobuf_setup,
+	.buf_prepare	= mx2_videobuf_prepare,
+	.buf_queue	= mx2_videobuf_queue,
+	.buf_cleanup	= mx2_videobuf_release,
 };
 
-static void mx2_camera_init_videobuf(struct videobuf_queue *q,
+static int mx2_camera_init_videobuf(struct vb2_queue *q,
 			      struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct mx2_camera_dev *pcdev = ici->priv;
-
-	videobuf_queue_dma_contig_init(q, &mx2_videobuf_ops, pcdev->dev,
-			&pcdev->lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			V4L2_FIELD_NONE, sizeof(struct mx2_buffer),
-			icd, &icd->video_lock);
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = icd;
+	q->ops = &mx2_videobuf_ops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct mx2_buffer);
+
+	return vb2_queue_init(q);
 }
 
 #define MX2_BUS_FLAGS	(V4L2_MBUS_MASTER | \
@@ -1135,25 +1097,11 @@ static int mx2_camera_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
-static int mx2_camera_reqbufs(struct soc_camera_device *icd,
-			      struct v4l2_requestbuffers *p)
-{
-	int i;
-
-	for (i = 0; i < p->count; i++) {
-		struct mx2_buffer *buf = container_of(icd->vb_vidq.bufs[i],
-						      struct mx2_buffer, vb);
-		INIT_LIST_HEAD(&buf->vb.queue);
-	}
-
-	return 0;
-}
-
 static unsigned int mx2_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
 
-	return videobuf_poll_stream(file, &icd->vb_vidq, pt);
+	return vb2_poll(&icd->vb2_vidq, file, pt);
 }
 
 static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
@@ -1164,31 +1112,30 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
 	.set_crop	= mx2_camera_set_crop,
 	.get_formats	= mx2_camera_get_formats,
 	.try_fmt	= mx2_camera_try_fmt,
-	.init_videobuf	= mx2_camera_init_videobuf,
-	.reqbufs	= mx2_camera_reqbufs,
+	.init_videobuf2	= mx2_camera_init_videobuf,
 	.poll		= mx2_camera_poll,
 	.querycap	= mx2_camera_querycap,
 	.set_bus_param	= mx2_camera_set_bus_param,
 };
 
 static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
-		int bufnum, int state)
+		int bufnum)
 {
 	u32 imgsize = pcdev->icd->user_height * pcdev->icd->user_width;
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
 	struct mx2_buffer *buf;
-	struct videobuf_buffer *vb;
+	struct vb2_buffer *vb;
 	unsigned long phys;
 
 	if (!list_empty(&pcdev->active_bufs)) {
 		buf = list_entry(pcdev->active_bufs.next,
-			struct mx2_buffer, vb.queue);
+			struct mx2_buffer, queue);
 
 		BUG_ON(buf->bufnum != bufnum);
 
 		vb = &buf->vb;
 #ifdef DEBUG
-		phys = videobuf_to_dma_contig(vb);
+		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
 		if (prp->cfg.channel == 1) {
 			if (readl(pcdev->base_emma + PRP_DEST_RGB1_PTR +
 				4 * bufnum) != phys) {
@@ -1207,16 +1154,15 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 			}
 		}
 #endif
-		dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__, vb,
-				vb->baddr, vb->bsize);
+		dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%p %lu\n", __func__, vb,
+				vb2_plane_vaddr(vb, 0),
+				vb2_get_plane_payload(vb, 0));
 
-		list_del(&vb->queue);
-		vb->state = state;
-		do_gettimeofday(&vb->ts);
-		vb->field_count = pcdev->frame_count * 2;
+		list_del_init(&buf->queue);
+		do_gettimeofday(&vb->v4l2_buf.timestamp);
 		pcdev->frame_count++;
-
-		wake_up(&vb->done);
+		vb->v4l2_buf.sequence = pcdev->frame_count;
+		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 	}
 
 	if (list_empty(&pcdev->capture)) {
@@ -1240,16 +1186,16 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 	}
 
 	buf = list_entry(pcdev->capture.next,
-			struct mx2_buffer, vb.queue);
+			struct mx2_buffer, queue);
 
 	buf->bufnum = !bufnum;
 
 	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
 	vb = &buf->vb;
-	vb->state = VIDEOBUF_ACTIVE;
+	buf->state = MX2_STATE_ACTIVE;
 
-	phys = videobuf_to_dma_contig(vb);
+	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
 	if (prp->cfg.channel == 1) {
 		writel(phys, pcdev->base_emma + PRP_DEST_RGB1_PTR + 4 * bufnum);
 	} else {
@@ -1293,14 +1239,14 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 		 * to first
 		 */
 		buf = list_entry(pcdev->active_bufs.next,
-			struct mx2_buffer, vb.queue);
-		mx27_camera_frame_done_emma(pcdev, buf->bufnum, VIDEOBUF_DONE);
+			struct mx2_buffer, queue);
+		mx27_camera_frame_done_emma(pcdev, buf->bufnum);
 		status &= ~(1 << (6 - buf->bufnum)); /* mark processed */
 	}
 	if ((status & (1 << 6)) || (status & (1 << 4)))
-		mx27_camera_frame_done_emma(pcdev, 0, VIDEOBUF_DONE);
+		mx27_camera_frame_done_emma(pcdev, 0);
 	if ((status & (1 << 5)) || (status & (1 << 3)))
-		mx27_camera_frame_done_emma(pcdev, 1, VIDEOBUF_DONE);
+		mx27_camera_frame_done_emma(pcdev, 1);
 
 	writel(status, pcdev->base_emma + PRP_INTRSTATUS);
 
@@ -1461,6 +1407,12 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.priv		= pcdev;
 	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
+
+	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(pcdev->alloc_ctx)) {
+		err = PTR_ERR(pcdev->alloc_ctx);
+		goto eallocctx;
+	}
 	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
 		goto exit_free_emma;
@@ -1471,6 +1423,8 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	return 0;
 
 exit_free_emma:
+	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
+eallocctx:
 	if (mx27_camera_emma(pcdev)) {
 		free_irq(pcdev->irq_emma, pcdev);
 		clk_disable(pcdev->clk_emma);
@@ -1505,6 +1459,8 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 
 	soc_camera_host_unregister(&pcdev->soc_host);
 
+	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
+
 	iounmap(pcdev->base_csi);
 
 	if (mx27_camera_emma(pcdev)) {
-- 
1.7.0.4

