Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1669 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3CBXp4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 14/20] solo6x10: convert the display node to vb2.
Date: Sun,  3 Mar 2013 00:45:30 +0100
Message-Id: <2c040286ce32378cf47118f6d138ee42d74f0669.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As a consequence the ioctl op has been replaced by unlocked_ioctl.

Since we are now using the core lock the locking scheme has been
simplified as well.

The main reason for converting this driver to vb2 was that the locking
scheme in v4l2.c was hopeless. It was easier to just convert the driver
then to try and salvage a threading and videobuf nightmare.

The videobuf2 framework is far, far superior compared to the old videobuf.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/Kconfig    |    1 -
 drivers/staging/media/solo6x10/solo6x10.h |    4 +-
 drivers/staging/media/solo6x10/v4l2.c     |  281 ++++++++++-------------------
 3 files changed, 95 insertions(+), 191 deletions(-)

diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
index f93b4ca..de50fc8 100644
--- a/drivers/staging/media/solo6x10/Kconfig
+++ b/drivers/staging/media/solo6x10/Kconfig
@@ -1,7 +1,6 @@
 config SOLO6X10
 	tristate "Softlogic 6x10 MPEG codec cards"
 	depends on PCI && VIDEO_DEV && SND && I2C
-	select VIDEOBUF_DMA_SG
 	select VIDEOBUF2_DMA_SG
 	select SND_PCM
 	---help---
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 05c9840..facd395 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -35,7 +35,6 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/videobuf-core.h>
 #include <media/videobuf2-core.h>
 #include "registers.h"
 
@@ -259,8 +258,9 @@ struct solo_dev {
 	int			g723_hw_idx;
 
 	/* Buffer handling */
-	struct videobuf_queue	vidq;
+	struct vb2_queue	vidq;
 	struct task_struct      *kthread;
+	struct mutex		lock;
 	spinlock_t		slock;
 	int			old_write;
 	struct list_head	vidq_active;
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index ea9bda0..8900015 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -24,7 +24,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-event.h>
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf2-dma-sg.h>
 #include "solo6x10.h"
 #include "tw28.h"
 
@@ -228,9 +228,9 @@ static int disp_push_desc(struct solo_dev *solo_dev, dma_addr_t dma_addr,
 }
 
 static void solo_fillbuf(struct solo_dev *solo_dev,
-			 struct videobuf_buffer *vb)
+			 struct vb2_buffer *vb)
 {
-	struct videobuf_dmabuf *vbuf;
+	struct vb2_dma_sg_desc *vbuf;
 	unsigned int fdma_addr;
 	int error = 1;
 	int i;
@@ -238,7 +238,7 @@ static void solo_fillbuf(struct solo_dev *solo_dev,
 	dma_addr_t sg_dma;
 	int sg_size_left;
 
-	vbuf = videobuf_to_dma(vb);
+	vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	if (!vbuf)
 		goto finish_buf;
 
@@ -246,9 +246,9 @@ static void solo_fillbuf(struct solo_dev *solo_dev,
 		int i;
 
 		/* Just blit to the entire sg list, ignoring size */
-		for_each_sg(vbuf->sglist, sg, vbuf->sglen, i) {
+		for (sg = vbuf->sglist; sg; sg = sg_next(sg)) {
 			void *p = sg_virt(sg);
-			size_t len = sg_dma_len(sg);
+			size_t len = sg->length;
 
 			for (i = 0; i < len; i += 2) {
 				((u8 *)p)[i] = 0x80;
@@ -261,6 +261,8 @@ static void solo_fillbuf(struct solo_dev *solo_dev,
 	}
 
 	disp_reset_desc(solo_dev);
+        dma_map_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+                        DMA_FROM_DEVICE);
 	sg = vbuf->sglist;
 	sg_dma = sg_dma_address(sg);
 	sg_size_left = sg_dma_len(sg);
@@ -326,25 +328,25 @@ static void solo_fillbuf(struct solo_dev *solo_dev,
 	}
 
 	error = disp_flush_descs(solo_dev);
+        dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
+                        DMA_FROM_DEVICE);
 
 finish_buf:
-	if (error) {
-		vb->state = VIDEOBUF_ERROR;
-	} else {
-		vb->size = solo_vlines(solo_dev) * solo_bytesperline(solo_dev);
-		vb->state = VIDEOBUF_DONE;
-		vb->field_count++;
-		do_gettimeofday(&vb->ts);
+	if (!error) {
+		vb2_set_plane_payload(vb, 0,
+			solo_vlines(solo_dev) * solo_bytesperline(solo_dev));
+		vb->v4l2_buf.sequence++;
+		do_gettimeofday(&vb->v4l2_buf.timestamp);
 	}
 
-	wake_up(&vb->done);
+	vb2_buffer_done(vb, error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 	return;
 }
 
 static void solo_thread_try(struct solo_dev *solo_dev)
 {
-	struct videobuf_buffer *vb;
+	struct solo_vb2_buf *vb;
 	unsigned int cur_write;
 
 	for (;;) {
@@ -353,11 +355,11 @@ static void solo_thread_try(struct solo_dev *solo_dev)
 		if (list_empty(&solo_dev->vidq_active))
 			break;
 
-		vb = list_first_entry(&solo_dev->vidq_active, struct videobuf_buffer,
-				      queue);
+		vb = list_first_entry(&solo_dev->vidq_active, struct solo_vb2_buf,
+				      list);
 
-		if (!waitqueue_active(&vb->done))
-			break;
+		//if (!waitqueue_active(&vb->done))
+		//	break;
 
 		cur_write = SOLO_VI_STATUS0_PAGE(solo_reg_read(solo_dev,
 						 SOLO_VI_STATUS0));
@@ -365,11 +367,11 @@ static void solo_thread_try(struct solo_dev *solo_dev)
 			break;
 
 		solo_dev->old_write = cur_write;
-		list_del(&vb->queue);
+		list_del(&vb->list);
 
 		spin_unlock(&solo_dev->slock);
 
-		solo_fillbuf(solo_dev, vb);
+		solo_fillbuf(solo_dev, &vb->vb);
 	}
 
 	assert_spin_locked(&solo_dev->slock);
@@ -412,114 +414,59 @@ static void solo_stop_thread(struct solo_dev *solo_dev)
 	}
 }
 
-static int solo_buf_setup(struct videobuf_queue *vq, unsigned int *count,
-			  unsigned int *size)
+static int solo_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct solo_dev *solo_dev = vq->priv_data;
+	struct solo_dev *solo_dev = vb2_get_drv_priv(q);
 
-	*size = solo_image_size(solo_dev);
+	sizes[0] = solo_image_size(solo_dev);
+	*num_planes = 1;
 
-	if (*count < MIN_VID_BUFFERS)
-		*count = MIN_VID_BUFFERS;
+	if (*num_buffers < MIN_VID_BUFFERS)
+		*num_buffers = MIN_VID_BUFFERS;
 
 	return 0;
 }
 
-static int solo_buf_prepare(struct videobuf_queue *vq,
-			    struct videobuf_buffer *vb, enum v4l2_field field)
+static int solo_start_streaming(struct vb2_queue *q, unsigned int count)
 {
-	struct solo_dev *solo_dev = vq->priv_data;
-
-	vb->size = solo_image_size(solo_dev);
-	if (vb->baddr != 0 && vb->bsize < vb->size)
-		return -EINVAL;
+	struct solo_dev *solo_dev = vb2_get_drv_priv(q);
 
-	/* XXX: These properties only change when queue is idle */
-	vb->width  = solo_dev->video_hsize;
-	vb->height = solo_vlines(solo_dev);
-	vb->bytesperline = solo_bytesperline(solo_dev);
-	vb->field  = field;
-
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		int rc = videobuf_iolock(vq, vb, NULL);
-		if (rc < 0) {
-			struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-			videobuf_dma_unmap(vq->dev, dma);
-			videobuf_dma_free(dma);
-			vb->state = VIDEOBUF_NEEDS_INIT;
-			return rc;
-		}
-	}
-	vb->state = VIDEOBUF_PREPARED;
-
-	return 0;
+	return solo_start_thread(solo_dev);
 }
 
-static void solo_buf_queue(struct videobuf_queue *vq,
-			   struct videobuf_buffer *vb)
+static int solo_stop_streaming(struct vb2_queue *q)
 {
-	struct solo_dev *solo_dev = vq->priv_data;
+	struct solo_dev *solo_dev = vb2_get_drv_priv(q);
 
-	vb->state = VIDEOBUF_QUEUED;
-	list_add_tail(&vb->queue, &solo_dev->vidq_active);
-	wake_up_interruptible(&solo_dev->disp_thread_wait);
+	solo_stop_thread(solo_dev);
+	INIT_LIST_HEAD(&solo_dev->vidq_active);
+	return 0;
 }
 
-static void solo_buf_release(struct videobuf_queue *vq,
-			     struct videobuf_buffer *vb)
+static void solo_buf_queue(struct vb2_buffer *vb)
 {
-	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct solo_dev *solo_dev = vb2_get_drv_priv(vq);
+	struct solo_vb2_buf *solo_vb =
+		container_of(vb, struct solo_vb2_buf, vb);
 
-	videobuf_dma_unmap(vq->dev, dma);
-	videobuf_dma_free(dma);
-	vb->state = VIDEOBUF_NEEDS_INIT;
+	spin_lock(&solo_dev->slock);
+	list_add_tail(&solo_vb->list, &solo_dev->vidq_active);
+	spin_unlock(&solo_dev->slock);
+	wake_up_interruptible(&solo_dev->disp_thread_wait);
 }
 
-static struct videobuf_queue_ops solo_video_qops = {
-	.buf_setup	= solo_buf_setup,
-	.buf_prepare	= solo_buf_prepare,
+static struct vb2_ops solo_video_qops = {
+	.queue_setup	= solo_queue_setup,
 	.buf_queue	= solo_buf_queue,
-	.buf_release	= solo_buf_release,
+	.start_streaming = solo_start_streaming,
+	.stop_streaming = solo_stop_streaming,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
 };
 
-static unsigned int solo_v4l2_poll(struct file *file,
-				   struct poll_table_struct *wait)
-{
-	struct solo_dev *solo_dev = video_drvdata(file);
-	unsigned long req_events = poll_requested_events(wait);
-	unsigned res = v4l2_ctrl_poll(file, wait);
-
-	if (!(req_events & (POLLIN | POLLRDNORM)))
-		return res;
-	return res | videobuf_poll_stream(file, &solo_dev->vidq, wait);
-}
-
-static int solo_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct solo_dev *solo_dev = video_drvdata(file);
-
-	return videobuf_mmap_mapper(&solo_dev->vidq, vma);
-}
-
-static ssize_t solo_v4l2_read(struct file *file, char __user *data,
-			      size_t count, loff_t *ppos)
-{
-	struct solo_dev *solo_dev = video_drvdata(file);
-
-	return videobuf_read_stream(&solo_dev->vidq, data, count, ppos, 0,
-				    file->f_flags & O_NONBLOCK);
-}
-
-static int solo_v4l2_release(struct file *file)
-{
-	struct solo_dev *solo_dev = video_drvdata(file);
-
-	videobuf_stop(&solo_dev->vidq);
-	videobuf_mmap_free(&solo_dev->vidq);
-	solo_stop_thread(solo_dev);
-	return v4l2_fh_release(file);
-}
-
 static int solo_querycap(struct file *file, void  *priv,
 			 struct v4l2_capability *cap)
 {
@@ -642,7 +589,7 @@ static int solo_set_fmt_cap(struct file *file, void *priv,
 {
 	struct solo_dev *solo_dev = video_drvdata(file);
 
-	if (videobuf_queue_is_busy(&solo_dev->vidq))
+	if (vb2_is_busy(&solo_dev->vidq))
 		return -EBUSY;
 
 	/* For right now, if it doesn't match our running config,
@@ -668,60 +615,6 @@ static int solo_get_fmt_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int solo_reqbufs(struct file *file, void *priv,
-			struct v4l2_requestbuffers *req)
-{
-	struct solo_dev *solo_dev = video_drvdata(file);
-
-	return videobuf_reqbufs(&solo_dev->vidq, req);
-}
-
-static int solo_querybuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct solo_dev *solo_dev = video_drvdata(file);
-
-	return videobuf_querybuf(&solo_dev->vidq, buf);
-}
-
-static int solo_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct solo_dev *solo_dev = video_drvdata(file);
-
-	return videobuf_qbuf(&solo_dev->vidq, buf);
-}
-
-static int solo_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct solo_dev *solo_dev = video_drvdata(file);
-
-	return videobuf_dqbuf(&solo_dev->vidq, buf, file->f_flags & O_NONBLOCK);
-}
-
-static int solo_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct solo_dev *solo_dev = video_drvdata(file);
-	int ret;
-
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	ret = solo_start_thread(solo_dev);
-	if (ret)
-		return ret;
-
-	return videobuf_streamon(&solo_dev->vidq);
-}
-
-static int solo_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct solo_dev *solo_dev = video_drvdata(file);
-
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	return videobuf_streamoff(&solo_dev->vidq);
-}
-
 static int solo_s_std(struct file *file, void *priv, v4l2_std_id *i)
 {
 	return 0;
@@ -759,11 +652,11 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 static const struct v4l2_file_operations solo_v4l2_fops = {
 	.owner			= THIS_MODULE,
 	.open			= v4l2_fh_open,
-	.release		= solo_v4l2_release,
-	.read			= solo_v4l2_read,
-	.poll			= solo_v4l2_poll,
-	.mmap			= solo_v4l2_mmap,
-	.ioctl			= video_ioctl2,
+	.release		= vb2_fop_release,
+	.read			= vb2_fop_read,
+	.poll			= vb2_fop_poll,
+	.mmap			= vb2_fop_mmap,
+	.unlocked_ioctl		= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops solo_v4l2_ioctl_ops = {
@@ -779,12 +672,12 @@ static const struct v4l2_ioctl_ops solo_v4l2_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap		= solo_set_fmt_cap,
 	.vidioc_g_fmt_vid_cap		= solo_get_fmt_cap,
 	/* Streaming I/O */
-	.vidioc_reqbufs			= solo_reqbufs,
-	.vidioc_querybuf		= solo_querybuf,
-	.vidioc_qbuf			= solo_qbuf,
-	.vidioc_dqbuf			= solo_dqbuf,
-	.vidioc_streamon		= solo_streamon,
-	.vidioc_streamoff		= solo_streamoff,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
 	/* Logging and events */
 	.vidioc_log_status		= v4l2_ctrl_log_status,
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
@@ -821,6 +714,9 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 	int i;
 
 	init_waitqueue_head(&solo_dev->disp_thread_wait);
+	spin_lock_init(&solo_dev->slock);
+	mutex_init(&solo_dev->lock);
+	INIT_LIST_HEAD(&solo_dev->vidq_active);
 
 	solo_dev->vfd = video_device_alloc();
 	if (!solo_dev->vfd)
@@ -828,22 +724,29 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 
 	*solo_dev->vfd = solo_v4l2_template;
 	solo_dev->vfd->v4l2_dev = &solo_dev->v4l2_dev;
+	solo_dev->vfd->queue = &solo_dev->vidq;
+	solo_dev->vfd->lock = &solo_dev->lock;
 	v4l2_ctrl_handler_init(&solo_dev->disp_hdl, 1);
 	v4l2_ctrl_new_custom(&solo_dev->disp_hdl, &solo_motion_trace_ctrl, NULL);
-	if (solo_dev->disp_hdl.error)
-		return solo_dev->disp_hdl.error;
+	if (solo_dev->disp_hdl.error) {
+		ret = solo_dev->disp_hdl.error;
+		goto fail;
+	}
 	solo_dev->vfd->ctrl_handler = &solo_dev->disp_hdl;
 	set_bit(V4L2_FL_USE_FH_PRIO, &solo_dev->vfd->flags);
 	video_set_drvdata(solo_dev->vfd, solo_dev);
 
-	spin_lock_init(&solo_dev->slock);
-	INIT_LIST_HEAD(&solo_dev->vidq_active);
-
-	videobuf_queue_sg_init(&solo_dev->vidq, &solo_video_qops,
-			       &solo_dev->pdev->dev, &solo_dev->slock,
-			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			       V4L2_FIELD_INTERLACED,
-			       sizeof(struct videobuf_buffer), solo_dev, NULL);
+	solo_dev->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	solo_dev->vidq.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	solo_dev->vidq.ops = &solo_video_qops;
+	solo_dev->vidq.mem_ops = &vb2_dma_sg_memops;
+	solo_dev->vidq.drv_priv = solo_dev;
+	solo_dev->vidq.gfp_flags = __GFP_DMA32;
+	solo_dev->vidq.buf_struct_size = sizeof(struct solo_vb2_buf);
+	solo_dev->vidq.lock = &solo_dev->lock;
+	ret = vb2_queue_init(&solo_dev->vidq);
+	if (ret < 0)
+		goto fail;
 
 	/* Cycle all the channels and clear */
 	for (i = 0; i < solo_dev->nr_chans; i++) {
@@ -860,11 +763,8 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 	solo_irq_on(solo_dev, SOLO_IRQ_VIDEO_IN);
 
 	ret = video_register_device(solo_dev->vfd, VFL_TYPE_GRABBER, video_nr);
-	if (ret < 0) {
-		video_device_release(solo_dev->vfd);
-		solo_dev->vfd = NULL;
-		return ret;
-	}
+	if (ret < 0)
+		goto fail;
 
 	snprintf(solo_dev->vfd->name, sizeof(solo_dev->vfd->name), "%s (%i)",
 		 SOLO6X10_NAME, solo_dev->vfd->num);
@@ -877,6 +777,11 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 		 solo_dev->nr_chans, solo_dev->nr_ext);
 
 	return 0;
+
+fail:
+	video_device_release(solo_dev->vfd);
+	solo_dev->vfd = NULL;
+	return ret;
 }
 
 void solo_v4l2_exit(struct solo_dev *solo_dev)
-- 
1.7.10.4

