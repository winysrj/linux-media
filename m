Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33917 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbcFPRWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 13:22:23 -0400
From: Janusz Krzysztofik <jmkrzyszt@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Lindgren <tony@atomide.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-omap@vger.kernel.org,
	Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [RFC] [PATCH 2/3] staging: media: omap1: convert to videobuf2
Date: Thu, 16 Jun 2016 19:21:33 +0200
Message-Id: <1466097694-8660-3-git-send-email-jmkrzyszt@gmail.com>
In-Reply-To: <1466097694-8660-1-git-send-email-jmkrzyszt@gmail.com>
References: <1466097694-8660-1-git-send-email-jmkrzyszt@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Created and tested on Amstrad Delta on top of Linux-4.7-rc3 with
"staging: media: omap1: drop videobuf-dma-sg mode" applied.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
---
 drivers/staging/media/omap1/Kconfig        |   2 +-
 drivers/staging/media/omap1/omap1_camera.c | 363 ++++++++++++-----------------
 2 files changed, 151 insertions(+), 214 deletions(-)

diff --git a/drivers/staging/media/omap1/Kconfig b/drivers/staging/media/omap1/Kconfig
index e2a39f5..12f1d7a 100644
--- a/drivers/staging/media/omap1/Kconfig
+++ b/drivers/staging/media/omap1/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_OMAP1
 	depends on VIDEO_DEV && SOC_CAMERA
 	depends on ARCH_OMAP1
 	depends on HAS_DMA
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for the TI OMAP1 camera interface
 
diff --git a/drivers/staging/media/omap1/omap1_camera.c b/drivers/staging/media/omap1/omap1_camera.c
index 37ef4da..3761660 100644
--- a/drivers/staging/media/omap1/omap1_camera.c
+++ b/drivers/staging/media/omap1/omap1_camera.c
@@ -1,7 +1,7 @@
 /*
  * V4L2 SoC Camera driver for OMAP1 Camera Interface
  *
- * Copyright (C) 2010, Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
+ * Copyright (C) 2010, 2016 Janusz Krzysztofik <jmkrzyszt@gmail.com>
  *
  * Based on V4L2 Driver for i.MXL/i.MXL camera (CSI) host
  * Copyright (C) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
@@ -31,13 +31,13 @@
 #include <linux/platform_data/media/omap1_camera.h>
 #include <media/soc_camera.h>
 #include <media/drv-intf/soc_mediabus.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/videobuf2-dma-contig.h>
 
 #include <linux/omap-dma.h>
 
 
 #define DRIVER_NAME		"omap1-camera"
-#define DRIVER_VERSION		"0.0.3"
+#define DRIVER_VERSION		"0.0.4"
 
 #define OMAP_DMA_CAMERA_IF_RX		20
 
@@ -134,9 +134,8 @@
 
 /* buffer for one video frame */
 struct omap1_cam_buf {
-	struct videobuf_buffer		vb;
-	u32				code;
-	int				inwork;
+	struct vb2_v4l2_buffer		vb;
+	struct list_head		queue;
 };
 
 struct omap1_cam_dev {
@@ -161,10 +160,18 @@ struct omap1_cam_dev {
 	struct omap1_cam_buf		*active;
 	struct omap1_cam_buf		*ready;
 
+	struct vb2_alloc_ctx		*alloc_ctx;
+	int				sequence;
+
 	u32				reg_cache[0];
 };
 
 
+static struct omap1_cam_buf *vb2_to_omap1_cam_buf(struct vb2_v4l2_buffer *vbuf)
+{
+	return container_of(vbuf, struct omap1_cam_buf, vb);
+}
+
 static void cam_write(struct omap1_cam_dev *pcdev, u16 reg, u32 val)
 {
 	pcdev->reg_cache[reg / sizeof(u32)] = val;
@@ -187,92 +194,59 @@ static u32 cam_read(struct omap1_cam_dev *pcdev, u16 reg, bool from_cache)
 /*
  *  Videobuf operations
  */
-static int omap1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
-		unsigned int *size)
+
+static int omap1_videobuf_setup(struct vb2_queue *vq, unsigned int *count,
+				unsigned int *num_planes, unsigned int sizes[],
+				void *alloc_ctxs[])
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	unsigned int size = icd->sizeimage;
+
+	pcdev->sequence = 0;
 
-	*size = icd->sizeimage;
+	*num_planes = 1;
+	sizes[0] = size;
+	alloc_ctxs[0] = pcdev->alloc_ctx;
 
 	if (!*count || *count < OMAP1_CAMERA_MIN_BUF_COUNT)
 		*count = OMAP1_CAMERA_MIN_BUF_COUNT;
 
-	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
-		*count = (MAX_VIDEO_MEM * 1024 * 1024) / *size;
+	if (size * *count > MAX_VIDEO_MEM * 1024 * 1024)
+		*count = (MAX_VIDEO_MEM * 1024 * 1024) / size;
 
 	dev_dbg(icd->parent,
-			"%s: count=%d, size=%d\n", __func__, *count, *size);
+			"%s: count=%u, size=%u\n", __func__, *count, size);
 
 	return 0;
 }
 
-static void free_buffer(struct videobuf_queue *vq, struct omap1_cam_buf *buf)
-{
-	struct videobuf_buffer *vb = &buf->vb;
-
-	BUG_ON(in_interrupt());
-
-	videobuf_waiton(vq, vb, 0, 0);
-
-	videobuf_dma_contig_free(vq, vb);
-
-	vb->state = VIDEOBUF_NEEDS_INIT;
-}
-
-static int omap1_videobuf_prepare(struct videobuf_queue *vq,
-		struct videobuf_buffer *vb, enum v4l2_field field)
+static int omap1_videobuf_prepare(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
-	struct omap1_cam_buf *buf = container_of(vb, struct omap1_cam_buf, vb);
-	int ret;
-
-	WARN_ON(!list_empty(&vb->queue));
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct omap1_cam_buf *buf = vb2_to_omap1_cam_buf(vbuf);
+	unsigned long size = icd->sizeimage;
 
-	BUG_ON(NULL == icd->current_fmt);
+	WARN_ON(!list_empty(&buf->queue));
 
-	buf->inwork = 1;
-
-	if (buf->code != icd->current_fmt->code || vb->field != field ||
-			vb->width  != icd->user_width ||
-			vb->height != icd->user_height) {
-		buf->code  = icd->current_fmt->code;
-		vb->width  = icd->user_width;
-		vb->height = icd->user_height;
-		vb->field  = field;
-		vb->state  = VIDEOBUF_NEEDS_INIT;
-	}
-
-	vb->size = icd->sizeimage;
-
-	if (vb->baddr && vb->bsize < vb->size) {
-		ret = -EINVAL;
-		goto out;
+	if (vb2_plane_size(vb, 0) < size) {
+		dev_err(icd->parent, "Buffer too small (%lu < %lu)\n",
+			vb2_plane_size(vb, 0), size);
+		return -ENOBUFS;
 	}
 
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret)
-			goto fail;
-
-		vb->state = VIDEOBUF_PREPARED;
-	}
-	buf->inwork = 0;
+	vb2_set_plane_payload(vb, 0, size);
 
 	return 0;
-fail:
-	free_buffer(vq, buf);
-out:
-	buf->inwork = 0;
-	return ret;
 }
 
 static void set_dma_dest_params(int dma_ch, struct omap1_cam_buf *buf)
 {
-	dma_addr_t dma_addr;
-	unsigned int block_size;
-
-	dma_addr = videobuf_to_dma_contig(&buf->vb);
-	block_size = buf->vb.size;
+	dma_addr_t dma_addr =
+			vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
+	unsigned int block_size = vb2_plane_size(&buf->vb.vb2_buf, 0);
 
 	omap_set_dma_dest_params(dma_ch,
 		OMAP_DMA_PORT_EMIFF, OMAP_DMA_AMODE_POST_INC, dma_addr, 0, 0);
@@ -295,10 +269,9 @@ static struct omap1_cam_buf *prepare_next_vb(struct omap1_cam_dev *pcdev)
 		if (list_empty(&pcdev->capture))
 			return buf;
 		buf = list_entry(pcdev->capture.next,
-				struct omap1_cam_buf, vb.queue);
-		buf->vb.state = VIDEOBUF_ACTIVE;
+				struct omap1_cam_buf, queue);
 		pcdev->ready = buf;
-		list_del_init(&buf->vb.queue);
+		list_del_init(&buf->queue);
 	}
 
 	/*
@@ -355,17 +328,16 @@ static void disable_capture(struct omap1_cam_dev *pcdev)
 	CAM_WRITE(pcdev, MODE, mode & ~(IRQ_MASK | DMA));
 }
 
-static void omap1_videobuf_queue(struct videobuf_queue *vq,
-						struct videobuf_buffer *vb)
+static void omap1_videobuf_queue(struct vb2_buffer *vb)
 {
-	struct soc_camera_device *icd = vq->priv_data;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
-	struct omap1_cam_buf *buf;
+	struct omap1_cam_buf *buf = vb2_to_omap1_cam_buf(vbuf);
 	u32 mode;
 
-	list_add_tail(&vb->queue, &pcdev->capture);
-	vb->state = VIDEOBUF_QUEUED;
+	list_add_tail(&buf->queue, &pcdev->capture);
 
 	if (pcdev->active) {
 		/*
@@ -397,40 +369,28 @@ static void omap1_videobuf_queue(struct videobuf_queue *vq,
 	start_capture(pcdev);
 }
 
-static void omap1_videobuf_release(struct videobuf_queue *vq,
-				 struct videobuf_buffer *vb)
+static void omap1_videobuf_release(struct vb2_buffer *vb)
 {
-	struct omap1_cam_buf *buf =
-			container_of(vb, struct omap1_cam_buf, vb);
-	struct soc_camera_device *icd = vq->priv_data;
-	struct device *dev = icd->parent;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct omap1_cam_buf *buf = vb2_to_omap1_cam_buf(vbuf);
 
-	switch (vb->state) {
-	case VIDEOBUF_DONE:
-		dev_dbg(dev, "%s (done)\n", __func__);
-		break;
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
-		dev_dbg(dev, "%s (unknown %d)\n", __func__, vb->state);
-		break;
-	}
+	list_del_init(&buf->queue);
+}
 
-	free_buffer(vq, buf);
+static int omap1_videobuf_init(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct omap1_cam_buf *buf = vb2_to_omap1_cam_buf(vbuf);
+
+	INIT_LIST_HEAD(&buf->queue);
+	return 0;
 }
 
 static void videobuf_done(struct omap1_cam_dev *pcdev,
-		enum videobuf_state result)
+		enum vb2_buffer_state result)
 {
 	struct omap1_cam_buf *buf = pcdev->active;
-	struct videobuf_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct device *dev = pcdev->soc_host.icd->parent;
 
 	if (WARN_ON(!buf)) {
@@ -439,74 +399,45 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 		return;
 	}
 
-	if (result == VIDEOBUF_ERROR)
+	if (result == VB2_BUF_STATE_ERROR)
 		suspend_capture(pcdev);
 
 	vb = &buf->vb;
-	if (waitqueue_active(&vb->done)) {
-		if (!pcdev->ready && result != VIDEOBUF_ERROR) {
-			/*
-			 * No next buffer has been entered into the DMA
-			 * programming register set on time (could be done only
-			 * while the previous DMA interurpt was processed, not
-			 * later), so the last DMA block (whole buffer) is
-			 * about to be reused by the just autoreinitialized DMA
-			 * engine, and overwritten with next frame data. Best we
-			 * can do is stopping the capture as soon as possible,
-			 * hopefully before the next frame start.
-			 */
-			suspend_capture(pcdev);
-		}
-		vb->state = result;
-		v4l2_get_timestamp(&vb->ts);
-		if (result != VIDEOBUF_ERROR)
-			vb->field_count++;
-		wake_up(&vb->done);
-
-		/* shift in next buffer */
-		buf = pcdev->ready;
-		pcdev->active = buf;
-		pcdev->ready = NULL;
-
-		if (!buf) {
-			/*
-			 * No next buffer was ready on time (see above), so
-			 * indicate error condition to force capture restart or
-			 * stop, depending on next buffer already queued or not.
-			 */
-			result = VIDEOBUF_ERROR;
-			prepare_next_vb(pcdev);
-
-			buf = pcdev->ready;
-			pcdev->active = buf;
-			pcdev->ready = NULL;
-		}
-	} else if (pcdev->ready) {
+	if (!pcdev->ready && result != VB2_BUF_STATE_ERROR) {
 		/*
-		 * The DMA engine has possibly
-		 * been already autoreinitialized with the preprogrammed
-		 * pcdev->ready buffer.  We can either accept this fact
-		 * and just swap the buffers, or provoke an error condition
-		 * and restart capture.  The former seems less intrusive.
+		 * No next buffer has been entered into the DMA
+		 * programming register set on time (could be done only
+		 * while the previous DMA interurpt was processed, not
+		 * later), so the last DMA block (whole buffer) is
+		 * about to be reused by the just autoreinitialized DMA
+		 * engine, and overwritten with next frame data. Best we
+		 * can do is stopping the capture as soon as possible,
+		 * hopefully before the next frame start.
 		 */
-		dev_dbg(dev, "%s: nobody waiting on videobuf, swap with next\n",
-				__func__);
-		pcdev->active = pcdev->ready;
+		suspend_capture(pcdev);
+	}
+	vb->vb2_buf.timestamp = ktime_get_ns();
+	if (result != VB2_BUF_STATE_ERROR)
+		vb->sequence = pcdev->sequence++;
+	vb2_buffer_done(&vb->vb2_buf, result);
 
-		pcdev->ready = buf;
+	/* shift in next buffer */
+	buf = pcdev->ready;
+	pcdev->active = buf;
+	pcdev->ready = NULL;
 
-		buf = pcdev->active;
-	} else {
+	if (!buf) {
 		/*
-		 * No next buffer has been entered into
-		 * the DMA programming register set on time.
-		 * the DMA engine has already been reinitialized
-		 * with the current buffer. Best we can do
-		 * is not touching it.
+		 * No next buffer was ready on time (see above), so
+		 * indicate error condition to force capture restart or
+		 * stop, depending on next buffer already queued or not.
 		 */
-		dev_dbg(dev,
-			"%s: nobody waiting on videobuf, reuse it\n",
-			__func__);
+		result = VB2_BUF_STATE_ERROR;
+		prepare_next_vb(pcdev);
+
+		buf = pcdev->ready;
+		pcdev->active = buf;
+		pcdev->ready = NULL;
 	}
 
 	if (!buf) {
@@ -523,7 +454,7 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 	 * the DMA still running.
 	 */
 
-	if (result == VIDEOBUF_ERROR) {
+	if (result == VB2_BUF_STATE_ERROR) {
 		dev_dbg(dev, "%s: videobuf error; reset FIFO, restart DMA\n",
 				__func__);
 		start_capture(pcdev);
@@ -537,6 +468,28 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 	prepare_next_vb(pcdev);
 }
 
+static void omap1_stop_streaming(struct vb2_queue *vq)
+{
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	struct omap1_cam_buf *buf, *tmp;
+
+	spin_lock_irq(&pcdev->lock);
+
+	list_for_each_entry_safe(buf, tmp, &pcdev->capture, queue) {
+		list_del_init(&buf->queue);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+	}
+
+	if (pcdev->ready)
+		videobuf_done(pcdev, VB2_BUF_STATE_ERROR);
+	if (pcdev->active)
+		videobuf_done(pcdev, VB2_BUF_STATE_ERROR);
+
+	spin_unlock_irq(&pcdev->lock);
+}
+
 static void dma_isr(int channel, unsigned short status, void *data)
 {
 	struct omap1_cam_dev *pcdev = data;
@@ -559,7 +512,7 @@ static void dma_isr(int channel, unsigned short status, void *data)
 	 * indicated.
 	 */
 	CAM_WRITE(pcdev, MODE, CAM_READ_CACHE(pcdev, MODE) & ~EN_V_DOWN);
-	videobuf_done(pcdev, VIDEOBUF_DONE);
+	videobuf_done(pcdev, VB2_BUF_STATE_DONE);
 
 out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
@@ -622,17 +575,21 @@ static irqreturn_t cam_isr(int irq, void *data)
 		goto out;
 	}
 
-	videobuf_done(pcdev, VIDEOBUF_ERROR);
+	videobuf_done(pcdev, VB2_BUF_STATE_ERROR);
 out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 	return IRQ_HANDLED;
 }
 
-static struct videobuf_queue_ops omap1_videobuf_ops = {
-	.buf_setup	= omap1_videobuf_setup,
+static struct vb2_ops omap1_videobuf_ops = {
+	.queue_setup	= omap1_videobuf_setup,
 	.buf_prepare	= omap1_videobuf_prepare,
 	.buf_queue	= omap1_videobuf_queue,
-	.buf_release	= omap1_videobuf_release,
+	.buf_cleanup	= omap1_videobuf_release,
+	.buf_init	= omap1_videobuf_init,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
+	.stop_streaming	= omap1_stop_streaming,
 };
 
 
@@ -1084,7 +1041,6 @@ static int omap1_cam_try_fmt(struct soc_camera_device *icd,
 	};
 	struct v4l2_mbus_framefmt *mf = &format.format;
 	int ret;
-	/* TODO: limit to mx1 hardware capabilities */
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
@@ -1112,39 +1068,21 @@ static int omap1_cam_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static void omap1_cam_init_videobuf(struct videobuf_queue *q,
-				     struct soc_camera_device *icd)
+static int omap1_cam_init_videobuf(struct vb2_queue *vq,
+				   struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct omap1_cam_dev *pcdev = ici->priv;
-
-	videobuf_queue_dma_contig_init(q, &omap1_videobuf_ops,
-				       icd->parent, &pcdev->lock,
-				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				       V4L2_FIELD_NONE,
-				       sizeof(struct omap1_cam_buf),
-				       icd, &ici->host_lock);
-}
 
-static int omap1_cam_reqbufs(struct soc_camera_device *icd,
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
-		struct omap1_cam_buf *buf = container_of(icd->vb_vidq.bufs[i],
-						      struct omap1_cam_buf, vb);
-		buf->inwork = 0;
-		INIT_LIST_HEAD(&buf->vb.queue);
-	}
+	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vq->io_modes = VB2_MMAP;
+	vq->drv_priv = icd;
+	vq->ops = &omap1_videobuf_ops;
+	vq->mem_ops = &vb2_dma_contig_memops;
+	vq->buf_struct_size = sizeof(struct omap1_cam_buf);
+	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	vq->lock = &ici->host_lock;
 
-	return 0;
+	return vb2_queue_init(vq);
 }
 
 static int omap1_cam_querycap(struct soc_camera_host *ici,
@@ -1240,18 +1178,8 @@ static int omap1_cam_set_bus_param(struct soc_camera_device *icd)
 static unsigned int omap1_cam_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct omap1_cam_buf *buf;
-
-	buf = list_entry(icd->vb_vidq.stream.next, struct omap1_cam_buf,
-			 vb.stream);
-
-	poll_wait(file, &buf->vb.done, pt);
-
-	if (buf->vb.state == VIDEOBUF_DONE ||
-	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN | POLLRDNORM;
 
-	return 0;
+	return vb2_poll(&icd->vb2_vidq, file, pt);
 }
 
 static struct soc_camera_host_ops omap1_host_ops = {
@@ -1264,8 +1192,7 @@ static struct soc_camera_host_ops omap1_host_ops = {
 	.set_crop	= omap1_cam_set_crop,
 	.set_fmt	= omap1_cam_set_fmt,
 	.try_fmt	= omap1_cam_try_fmt,
-	.init_videobuf	= omap1_cam_init_videobuf,
-	.reqbufs	= omap1_cam_reqbufs,
+	.init_videobuf2	= omap1_cam_init_videobuf,
 	.querycap	= omap1_cam_querycap,
 	.set_bus_param	= omap1_cam_set_bus_param,
 	.poll		= omap1_cam_poll,
@@ -1356,6 +1283,12 @@ static int omap1_cam_probe(struct platform_device *pdev)
 		goto exit_free_dma;
 	}
 
+	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(pcdev->alloc_ctx)) {
+		err = PTR_ERR(pcdev->alloc_ctx);
+		goto exit_free_dma;
+	}
+
 	pcdev->soc_host.drv_name	= DRIVER_NAME;
 	pcdev->soc_host.ops		= &omap1_host_ops;
 	pcdev->soc_host.priv		= pcdev;
@@ -1368,12 +1301,14 @@ static int omap1_cam_probe(struct platform_device *pdev)
 		omap1_cam_clock_stop(&pcdev->soc_host);
 	}
 	if (err)
-		return err;
+		goto exit_free_ctx;
 
 	dev_info(&pdev->dev, "OMAP1 Camera Interface driver loaded\n");
 
 	return 0;
 
+exit_free_ctx:
+	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 exit_free_dma:
 	omap_free_dma(pcdev->dma_ch);
 	return err;
@@ -1389,6 +1324,8 @@ static int omap1_cam_remove(struct platform_device *pdev)
 
 	soc_camera_host_unregister(soc_host);
 
+	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
+
 	dev_info(&pdev->dev, "OMAP1 Camera Interface driver unloaded\n");
 
 	return 0;
-- 
2.7.3

