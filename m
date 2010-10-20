Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30588 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114Ab0JTGl3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 02:41:29 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LAK00B5XT90QA@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 07:41:25 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LAK005HLT8ZLV@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 07:41:24 +0100 (BST)
Date: Wed, 20 Oct 2010 08:41:12 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6/7] v4l: vivi: port to videobuf2
In-reply-to: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com
Message-id: <1287556873-23179-7-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Pawel Osciak <p.osciak@samsung.com>

Make vivi use videobuf2 in place of videobuf.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/Kconfig |    2 +-
 drivers/media/video/vivi.c  |  348 +++++++++++++++++++++++--------------------
 2 files changed, 186 insertions(+), 164 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 2143112..4dd14c2 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -557,7 +557,7 @@ config VIDEO_VIVI
 	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
 	depends on (FRAMEBUFFER_CONSOLE || STI_CONSOLE) && FONTS
 	select FONT_8x16
-	select VIDEOBUF_VMALLOC
+	select VIDEOBUF2_VMALLOC
 	default n
 	---help---
 	  Enables a virtual video driver. This device shows a color bar
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index e17b6fe..662de4f 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -7,6 +7,9 @@
  *      John Sokol <sokol--a.t--videotechnology.com>
  *      http://v4l.videotechnology.com/
  *
+ *      Conversion to videobuf2 by Pawel Osciak & Marek Szyprowski
+ *      Copyright (c) 2010 Samsung Electronics
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the BSD Licence, GNU General Public License
  * as published by the Free Software Foundation; either version 2 of the
@@ -23,10 +26,8 @@
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 #include <linux/kthread.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
 #include <linux/freezer.h>
-#endif
-#include <media/videobuf-vmalloc.h>
+#include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
@@ -42,7 +43,7 @@
 #define MAX_HEIGHT 1200
 
 #define VIVI_MAJOR_VERSION 0
-#define VIVI_MINOR_VERSION 7
+#define VIVI_MINOR_VERSION 8
 #define VIVI_RELEASE 0
 #define VIVI_VERSION \
 	KERNEL_VERSION(VIVI_MAJOR_VERSION, VIVI_MINOR_VERSION, VIVI_RELEASE)
@@ -70,6 +71,9 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
 /* Global font descriptor */
 static const u8 *font8x16;
 
+/* Videobuf2 allocator/memory handler context */
+static struct vb2_alloc_ctx *alloc_ctx;
+
 #define dprintk(dev, level, fmt, arg...) \
 	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
 
@@ -133,16 +137,11 @@ static struct vivi_fmt *get_format(struct v4l2_format *f)
 	return &formats[k];
 }
 
-struct sg_to_addr {
-	int pos;
-	struct scatterlist *sg;
-};
-
 /* buffer for one video frame */
 struct vivi_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
-
+	struct vb2_buffer	vb;
+	struct list_head	list;
 	struct vivi_fmt        *fmt;
 };
 
@@ -190,9 +189,11 @@ struct vivi_dev {
 	/* video capture */
 	struct vivi_fmt            *fmt;
 	unsigned int               width, height;
-	struct videobuf_queue      vb_vidq;
+	struct vb2_queue	   vb_vidq;
+	enum v4l2_field		   field;
+	unsigned int		   field_count;
 
-	unsigned long 		   generating;
+	atomic_t		   open_count;
 	u8 			   bars[9][3];
 	u8 			   line[MAX_WIDTH * 4];
 };
@@ -443,10 +444,10 @@ static void gen_text(struct vivi_dev *dev, char *basep,
 
 static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 {
-	int hmax = buf->vb.height;
-	int wmax = buf->vb.width;
+	int wmax = dev->width;
+	int hmax = dev->height;
 	struct timeval ts;
-	void *vbuf = videobuf_to_vmalloc(&buf->vb);
+	void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
 	unsigned ms;
 	char str[100];
 	int h, line = 1;
@@ -483,11 +484,11 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 
 	dev->mv_count += 2;
 
-	/* Advice that buffer was filled */
-	buf->vb.field_count++;
+	buf->vb.v4l2_buf.field = dev->field;
+	dev->field_count++;
+	buf->vb.v4l2_buf.sequence = dev->field_count >> 1;
 	do_gettimeofday(&ts);
-	buf->vb.ts = ts;
-	buf->vb.state = VIDEOBUF_DONE;
+	buf->vb.v4l2_buf.timestamp = ts;
 }
 
 static void vivi_thread_tick(struct vivi_dev *dev)
@@ -504,23 +505,21 @@ static void vivi_thread_tick(struct vivi_dev *dev)
 		goto unlock;
 	}
 
-	buf = list_entry(dma_q->active.next,
-			 struct vivi_buffer, vb.queue);
-
-	/* Nobody is waiting on this buffer, return */
-	if (!waitqueue_active(&buf->vb.done))
+	/* If nobody is waiting for a buffer, return */
+	if (!vb2_has_consumers(&dev->vb_vidq))
 		goto unlock;
 
-	list_del(&buf->vb.queue);
+	buf = list_entry(dma_q->active.next, struct vivi_buffer, list);
+	list_del(&buf->list);
 
-	do_gettimeofday(&buf->vb.ts);
+	do_gettimeofday(&buf->vb.v4l2_buf.timestamp);
 
 	/* Fill buffer */
 	vivi_fillbuff(dev, buf);
 	dprintk(dev, 1, "filled buffer %p\n", buf);
 
-	wake_up(&buf->vb.done);
-	dprintk(dev, 2, "[%p/%d] wakeup\n", buf, buf->vb. i);
+	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
 unlock:
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
@@ -571,17 +570,12 @@ static int vivi_thread(void *data)
 	return 0;
 }
 
-static void vivi_start_generating(struct file *file)
+static int vivi_start_generating(struct vivi_dev *dev)
 {
-	struct vivi_dev *dev = video_drvdata(file);
 	struct vivi_dmaqueue *dma_q = &dev->vidq;
 
 	dprintk(dev, 1, "%s\n", __func__);
 
-	if (test_and_set_bit(0, &dev->generating))
-		return;
-	file->private_data = dev;
-
 	/* Resets frame counters */
 	dev->ms = 0;
 	dev->mv_count = 0;
@@ -593,146 +587,182 @@ static void vivi_start_generating(struct file *file)
 
 	if (IS_ERR(dma_q->kthread)) {
 		v4l2_err(&dev->v4l2_dev, "kernel_thread() failed\n");
-		clear_bit(0, &dev->generating);
-		return;
+		return PTR_ERR(dma_q->kthread);
 	}
 	/* Wakes thread */
 	wake_up_interruptible(&dma_q->wq);
 
 	dprintk(dev, 1, "returning from %s\n", __func__);
+	return 0;
 }
 
-static void vivi_stop_generating(struct file *file)
+static void vivi_stop_generating(struct vivi_dev *dev)
 {
-	struct vivi_dev *dev = video_drvdata(file);
 	struct vivi_dmaqueue *dma_q = &dev->vidq;
 
 	dprintk(dev, 1, "%s\n", __func__);
 
-	if (!file->private_data)
-		return;
-	if (!test_and_clear_bit(0, &dev->generating))
-		return;
-
 	/* shutdown control thread */
 	if (dma_q->kthread) {
 		kthread_stop(dma_q->kthread);
 		dma_q->kthread = NULL;
 	}
-	videobuf_stop(&dev->vb_vidq);
-	videobuf_mmap_free(&dev->vb_vidq);
-}
 
-static int vivi_is_generating(struct vivi_dev *dev)
-{
-	return test_bit(0, &dev->generating);
+	/*
+	 * Typical driver might need to wait here until dma engine stops.
+	 * In this case we can abort imiedetly, so it's just a noop.
+	 */
+
+	/* Release all active buffers */
+	while (!list_empty(&dma_q->active)) {
+		struct vivi_buffer *buf;
+		buf = list_entry(dma_q->active.next, struct vivi_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
+	}
 }
-
 /* ------------------------------------------------------------------
 	Videobuf operations
    ------------------------------------------------------------------*/
-static int
-buffer_setup(struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
+static int queue_negotiate(struct vb2_queue *vq, unsigned int *num_buffers,
+				unsigned int *num_planes)
 {
-	struct vivi_dev *dev = vq->priv_data;
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
 
-	*size = dev->width * dev->height * 2;
+	size = dev->width * dev->height * 2;
 
-	if (0 == *count)
-		*count = 32;
+	if (0 == *num_buffers)
+		*num_buffers = 32;
 
-	while (*size * *count > vid_limit * 1024 * 1024)
-		(*count)--;
+	while (size * *num_buffers > vid_limit * 1024 * 1024)
+		(*num_buffers)--;
 
-	dprintk(dev, 1, "%s, count=%d, size=%d\n", __func__,
-		*count, *size);
+	*num_planes = 1;
+
+	dprintk(dev, 1, "%s, count=%d, size=%ld\n", __func__,
+		*num_buffers, size);
 
 	return 0;
 }
 
-static void free_buffer(struct videobuf_queue *vq, struct vivi_buffer *buf)
+static int plane_setup(struct vb2_queue *vq, unsigned int plane_no,
+			unsigned long *plane_size)
 {
-	struct vivi_dev *dev = vq->priv_data;
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+
+	if (plane_no > 0)
+		return -EINVAL;
 
-	dprintk(dev, 1, "%s, state: %i\n", __func__, buf->vb.state);
+	*plane_size = dev->width * dev->height * 2;
 
-	videobuf_vmalloc_free(&buf->vb);
-	dprintk(dev, 1, "free_buffer: freed\n");
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+	dprintk(dev, 1, "%s: plane: %d, size: %ld\n",
+			__func__, plane_no, *plane_size);
+
+	return 0;
 }
 
-static int
-buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
-						enum v4l2_field field)
+static int buffer_init(struct vb2_buffer *vb)
 {
-	struct vivi_dev *dev = vq->priv_data;
+	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+
+	BUG_ON(NULL == dev->fmt);
+
+	/*
+	 * This callback is called once per buffer, after its allocation.
+	 *
+	 * Vivi does not allow changing format during streaming, but it is
+	 * possible to do so when streaming is paused (i.e. in streamoff state).
+	 * Buffers however are not freed when going into streamoff and so
+	 * buffer size verification has to be done in buffer_prepare, on each
+	 * qbuf.
+	 * It would be best to move verification code here to buf_init and
+	 * s_fmt though.
+	 */
+
+	return 0;
+}
+
+static int buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct vivi_buffer *buf = container_of(vb, struct vivi_buffer, vb);
-	int rc;
+	unsigned long size;
 
-	dprintk(dev, 1, "%s, field=%d\n", __func__, field);
+	dprintk(dev, 1, "%s, field=%d\n", __func__, vb->v4l2_buf.field);
 
 	BUG_ON(NULL == dev->fmt);
 
+	/*
+	 * Theses properties only change when queue is idle, see s_fmt.
+	 * The below checks should not be performed here, on each
+	 * buffer_prepare (i.e. on each qbuf). Most of the code in this function
+	 * should thus be moved to buffer_init and s_fmt.
+	 */
 	if (dev->width  < 48 || dev->width  > MAX_WIDTH ||
 	    dev->height < 32 || dev->height > MAX_HEIGHT)
 		return -EINVAL;
 
-	buf->vb.size = dev->width * dev->height * 2;
-	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size)
+	size = dev->width * dev->height * 2;
+	if (vb2_plane_size(vb, 0) < size) {
+		dprintk(dev, 1, "%s data will not fit into plane (%lu < %lu)\n",
+				__func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(&buf->vb, 0, size);
 
-	/* These properties only change when queue is idle, see s_fmt */
-	buf->fmt       = dev->fmt;
-	buf->vb.width  = dev->width;
-	buf->vb.height = dev->height;
-	buf->vb.field  = field;
+	buf->fmt = dev->fmt;
 
 	precalculate_bars(dev);
 	precalculate_line(dev);
 
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		rc = videobuf_iolock(vq, &buf->vb, NULL);
-		if (rc < 0)
-			goto fail;
-	}
-
-	buf->vb.state = VIDEOBUF_PREPARED;
 	return 0;
-
-fail:
-	free_buffer(vq, buf);
-	return rc;
 }
 
-static void
-buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+static void buffer_queue(struct vb2_buffer *vb)
 {
-	struct vivi_dev *dev = vq->priv_data;
+	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct vivi_buffer *buf = container_of(vb, struct vivi_buffer, vb);
 	struct vivi_dmaqueue *vidq = &dev->vidq;
+	unsigned long flags = 0;
 
 	dprintk(dev, 1, "%s\n", __func__);
 
-	buf->vb.state = VIDEOBUF_QUEUED;
-	list_add_tail(&buf->vb.queue, &vidq->active);
+	spin_lock_irqsave(&dev->slock, flags);
+	list_add_tail(&buf->list, &vidq->active);
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static void buffer_release(struct videobuf_queue *vq,
-			   struct videobuf_buffer *vb)
+static int start_streaming(struct vb2_queue *vq)
 {
-	struct vivi_dev *dev = vq->priv_data;
-	struct vivi_buffer *buf  = container_of(vb, struct vivi_buffer, vb);
-
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
 	dprintk(dev, 1, "%s\n", __func__);
+	return vivi_start_generating(dev);
+}
 
-	free_buffer(vq, buf);
+/* abort streaming and wait for last buffer */
+static int stop_streaming(struct vb2_queue *vq)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+	dprintk(dev, 1, "%s\n", __func__);
+	vivi_stop_generating(dev);
+	return 0;
 }
 
-static struct videobuf_queue_ops vivi_video_qops = {
-	.buf_setup      = buffer_setup,
-	.buf_prepare    = buffer_prepare,
-	.buf_queue      = buffer_queue,
-	.buf_release    = buffer_release,
+static struct vb2_ops vivi_video_qops = {
+	.queue_negotiate	= queue_negotiate,
+	.plane_setup		= plane_setup,
+	.buf_init		= buffer_init,
+	.buf_prepare		= buffer_prepare,
+	.buf_queue		= buffer_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+};
+
+static struct vb2_read_ctx vivi_read_ctx = {
+	.num_bufs		= 2,
 };
 
 /* ------------------------------------------------------------------
@@ -774,7 +804,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
-	f->fmt.pix.field        = dev->vb_vidq.field;
+	f->fmt.pix.field        = dev->field;
 	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * dev->fmt->depth) >> 3;
@@ -820,15 +850,15 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct vivi_dev *dev = video_drvdata(file);
-	struct videobuf_queue *q = &dev->vb_vidq;
+	struct vb2_queue *q = &dev->vb_vidq;
 
 	int ret = vidioc_try_fmt_vid_cap(file, priv, f);
 	if (ret < 0)
 		return ret;
 
-	mutex_lock(&q->vb_lock);
+	vb2_lock(q);
 
-	if (vivi_is_generating(dev)) {
+	if (vb2_is_streaming(q)) {
 		dprintk(dev, 1, "%s device busy\n", __func__);
 		ret = -EBUSY;
 		goto out;
@@ -837,10 +867,10 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->fmt = get_format(f);
 	dev->width = f->fmt.pix.width;
 	dev->height = f->fmt.pix.height;
-	dev->vb_vidq.field = f->fmt.pix.field;
+	dev->field = f->fmt.pix.field;
 	ret = 0;
 out:
-	mutex_unlock(&q->vb_lock);
+	vb2_unlock(q);
 	return ret;
 }
 
@@ -849,66 +879,42 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 {
 	struct vivi_dev *dev = video_drvdata(file);
 
-	return videobuf_reqbufs(&dev->vb_vidq, p);
+	return vb2_reqbufs(&dev->vb_vidq, p);
 }
 
 static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	struct vivi_dev *dev = video_drvdata(file);
 
-	return videobuf_querybuf(&dev->vb_vidq, p);
+	return vb2_querybuf(&dev->vb_vidq, p);
 }
 
 static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	struct vivi_dev *dev = video_drvdata(file);
 
-	return videobuf_qbuf(&dev->vb_vidq, p);
+	return vb2_qbuf(&dev->vb_vidq, p);
 }
 
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	struct vivi_dev *dev = video_drvdata(file);
 
-	return videobuf_dqbuf(&dev->vb_vidq, p,
-				file->f_flags & O_NONBLOCK);
+	return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-static int vidiocgmbuf(struct file *file, void *priv, struct video_mbuf *mbuf)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-
-	return videobuf_cgmbuf(&dev->vb_vidq, mbuf, 8);
-}
-#endif
-
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct vivi_dev *dev = video_drvdata(file);
-	int ret;
-
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	ret = videobuf_streamon(&dev->vb_vidq);
-	if (ret)
-		return ret;
 
-	vivi_start_generating(file);
-	return 0;
+	return vb2_streamon(&dev->vb_vidq, i);
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct vivi_dev *dev = video_drvdata(file);
-	int ret;
 
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	ret = videobuf_streamoff(&dev->vb_vidq);
-	if (!ret)
-		vivi_stop_generating(file);
-	return ret;
+	return vb2_streamoff(&dev->vb_vidq, i);
 }
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
@@ -1031,26 +1037,25 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	File operations for the device
    ------------------------------------------------------------------*/
 
-static ssize_t
-vivi_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
+static int vivi_open(struct file *file)
 {
 	struct vivi_dev *dev = video_drvdata(file);
 
-	vivi_start_generating(file);
-	return videobuf_read_stream(&dev->vb_vidq, data, count, ppos, 0,
-					file->f_flags & O_NONBLOCK);
+	dprintk(dev, 1, "%s, %p\n", __func__, file);
+
+	atomic_inc(&dev->open_count);
+	return 0;
 }
 
 static unsigned int
 vivi_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct vivi_dev *dev = video_drvdata(file);
-	struct videobuf_queue *q = &dev->vb_vidq;
+	struct vb2_queue *q = &dev->vb_vidq;
 
 	dprintk(dev, 1, "%s\n", __func__);
 
-	vivi_start_generating(file);
-	return videobuf_poll_stream(file, q, wait);
+	return vb2_poll(q, file, wait);
 }
 
 static int vivi_close(struct file *file)
@@ -1058,10 +1063,11 @@ static int vivi_close(struct file *file)
 	struct video_device  *vdev = video_devdata(file);
 	struct vivi_dev *dev = video_drvdata(file);
 
-	vivi_stop_generating(file);
+	dprintk(dev, 1, "close called (dev=%s), file %p\n",
+		video_device_node_name(vdev), file);
 
-	dprintk(dev, 1, "close called (dev=%s)\n",
-		video_device_node_name(vdev));
+	if (atomic_dec_and_test(&dev->open_count))
+		vb2_queue_release(&dev->vb_vidq);
 	return 0;
 }
 
@@ -1072,7 +1078,7 @@ static int vivi_mmap(struct file *file, struct vm_area_struct *vma)
 
 	dprintk(dev, 1, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
 
-	ret = videobuf_mmap_mapper(&dev->vb_vidq, vma);
+	ret = vb2_mmap(&dev->vb_vidq, vma);
 
 	dprintk(dev, 1, "vma start=0x%08lx, size=%ld, ret=%d\n",
 		(unsigned long)vma->vm_start,
@@ -1081,13 +1087,25 @@ static int vivi_mmap(struct file *file, struct vm_area_struct *vma)
 	return ret;
 }
 
+static ssize_t vivi_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	dprintk(dev, 1, "read called\n");
+
+	return vb2_read(&dev->vb_vidq, buf, count, ppos,
+					file->f_flags & O_NONBLOCK);
+}
+
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
+	.open		= vivi_open,
 	.release        = vivi_close,
-	.read           = vivi_read,
 	.poll		= vivi_poll,
 	.ioctl          = video_ioctl2, /* V4L2 ioctl handler */
 	.mmap           = vivi_mmap,
+	.read           = vivi_read,
 };
 
 static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
@@ -1109,9 +1127,6 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_queryctrl     = vidioc_queryctrl,
 	.vidioc_g_ctrl        = vidioc_g_ctrl,
 	.vidioc_s_ctrl        = vidioc_s_ctrl,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-	.vidiocgmbuf          = vidiocgmbuf,
-#endif
 };
 
 static struct video_device vivi_template = {
@@ -1145,6 +1160,8 @@ static int vivi_release(void)
 		kfree(dev);
 	}
 
+	vb2_vmalloc_cleanup(alloc_ctx);
+
 	return 0;
 }
 
@@ -1173,10 +1190,8 @@ static int __init vivi_create_instance(int inst)
 	dev->saturation = 127;
 	dev->hue = 0;
 
-	videobuf_queue_vmalloc_init(&dev->vb_vidq, &vivi_video_qops,
-			NULL, &dev->slock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			V4L2_FIELD_INTERLACED,
-			sizeof(struct vivi_buffer), dev);
+	vb2_queue_init(&dev->vb_vidq, &vivi_video_qops, alloc_ctx,
+		       &vivi_read_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE, dev);
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
@@ -1238,6 +1253,13 @@ static int __init vivi_init(void)
 	}
 	font8x16 = font->data;
 
+	/* Initialize vmalloc allocator */
+	alloc_ctx = vb2_vmalloc_init();
+	if (IS_ERR(alloc_ctx)) {
+		printk(KERN_ERR "vivi: allocator init failed\n");
+		return PTR_ERR(alloc_ctx);
+	}
+
 	if (n_devs <= 0)
 		n_devs = 1;
 
-- 
1.7.1.569.g6f426

