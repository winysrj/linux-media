Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:38356 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751177AbeEVIOz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 04:14:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 2/5] gspca: convert to vb2
Date: Tue, 22 May 2018 10:14:48 +0200
Message-Id: <20180522081451.94794-3-hverkuil@xs4all.nl>
In-Reply-To: <20180522081451.94794-1-hverkuil@xs4all.nl>
References: <20180522081451.94794-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/gspca/Kconfig            |   1 +
 drivers/media/usb/gspca/gspca.c            | 906 ++++-----------------
 drivers/media/usb/gspca/gspca.h            |  38 +-
 drivers/media/usb/gspca/m5602/m5602_core.c |   4 +-
 drivers/media/usb/gspca/vc032x.c           |   2 +-
 5 files changed, 182 insertions(+), 769 deletions(-)

diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index bc9a439745aa..d3b6665c342d 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -2,6 +2,7 @@ menuconfig USB_GSPCA
 	tristate "GSPCA based webcams"
 	depends on VIDEO_V4L2
 	depends on INPUT || INPUT=n
+	select VIDEOBUF2_VMALLOC
 	default m
 	---help---
 	  Say Y here if you want to enable selecting webcams based
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index d29773b8f696..ff229d3aae0f 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -82,32 +82,6 @@ static void PDEBUG_MODE(struct gspca_dev *gspca_dev, int debug, char *txt,
 #define GSPCA_MEMORY_NO 0	/* V4L2_MEMORY_xxx starts from 1 */
 #define GSPCA_MEMORY_READ 7
 
-#define BUF_ALL_FLAGS (V4L2_BUF_FLAG_QUEUED | V4L2_BUF_FLAG_DONE)
-
-/*
- * VMA operations.
- */
-static void gspca_vm_open(struct vm_area_struct *vma)
-{
-	struct gspca_frame *frame = vma->vm_private_data;
-
-	frame->vma_use_count++;
-	frame->v4l2_buf.flags |= V4L2_BUF_FLAG_MAPPED;
-}
-
-static void gspca_vm_close(struct vm_area_struct *vma)
-{
-	struct gspca_frame *frame = vma->vm_private_data;
-
-	if (--frame->vma_use_count <= 0)
-		frame->v4l2_buf.flags &= ~V4L2_BUF_FLAG_MAPPED;
-}
-
-static const struct vm_operations_struct gspca_vm_ops = {
-	.open		= gspca_vm_open,
-	.close		= gspca_vm_close,
-};
-
 /*
  * Input and interrupt endpoint handling functions
  */
@@ -356,7 +330,7 @@ static void isoc_irq(struct urb *urb)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
 
 	gspca_dbg(gspca_dev, D_PACK, "isoc irq\n");
-	if (!gspca_dev->streaming)
+	if (!vb2_start_streaming_called(&gspca_dev->queue))
 		return;
 	fill_frame(gspca_dev, urb);
 }
@@ -370,7 +344,7 @@ static void bulk_irq(struct urb *urb)
 	int st;
 
 	gspca_dbg(gspca_dev, D_PACK, "bulk irq\n");
-	if (!gspca_dev->streaming)
+	if (!vb2_start_streaming_called(&gspca_dev->queue))
 		return;
 	switch (urb->status) {
 	case 0:
@@ -417,25 +391,24 @@ void gspca_frame_add(struct gspca_dev *gspca_dev,
 			const u8 *data,
 			int len)
 {
-	struct gspca_frame *frame;
-	int i, j;
+	struct gspca_buffer *buf;
+	unsigned long flags;
 
 	gspca_dbg(gspca_dev, D_PACK, "add t:%d l:%d\n",	packet_type, len);
 
-	if (packet_type == FIRST_PACKET) {
-		i = atomic_read(&gspca_dev->fr_i);
+	spin_lock_irqsave(&gspca_dev->qlock, flags);
+	buf = list_first_entry_or_null(&gspca_dev->buf_list,
+				       typeof(*buf), list);
+	spin_unlock_irqrestore(&gspca_dev->qlock, flags);
 
-		/* if there are no queued buffer, discard the whole frame */
-		if (i == atomic_read(&gspca_dev->fr_q)) {
+	if (packet_type == FIRST_PACKET) {
+		/* if there is no queued buffer, discard the whole frame */
+		if (!buf) {
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			gspca_dev->sequence++;
 			return;
 		}
-		j = gspca_dev->fr_queue[i];
-		frame = &gspca_dev->frame[j];
-		v4l2_get_timestamp(&frame->v4l2_buf.timestamp);
-		frame->v4l2_buf.sequence = gspca_dev->sequence++;
-		gspca_dev->image = frame->data;
+		gspca_dev->image = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 		gspca_dev->image_len = 0;
 	} else {
 		switch (gspca_dev->last_packet_type) {
@@ -453,10 +426,10 @@ void gspca_frame_add(struct gspca_dev *gspca_dev,
 
 	/* append the packet to the frame buffer */
 	if (len > 0) {
-		if (gspca_dev->image_len + len > gspca_dev->frsz) {
+		if (gspca_dev->image_len + len > gspca_dev->pixfmt.sizeimage) {
 			gspca_err(gspca_dev, "frame overflow %d > %d\n",
 				  gspca_dev->image_len + len,
-				  gspca_dev->frsz);
+				  gspca_dev->pixfmt.sizeimage);
 			packet_type = DISCARD_PACKET;
 		} else {
 /* !! image is NULL only when last pkt is LAST or DISCARD
@@ -476,80 +449,23 @@ void gspca_frame_add(struct gspca_dev *gspca_dev,
 	 * next first packet, wake up the application and advance
 	 * in the queue */
 	if (packet_type == LAST_PACKET) {
-		i = atomic_read(&gspca_dev->fr_i);
-		j = gspca_dev->fr_queue[i];
-		frame = &gspca_dev->frame[j];
-		frame->v4l2_buf.bytesused = gspca_dev->image_len;
-		frame->v4l2_buf.flags = (frame->v4l2_buf.flags
-					 | V4L2_BUF_FLAG_DONE)
-					& ~V4L2_BUF_FLAG_QUEUED;
-		i = (i + 1) % GSPCA_MAX_FRAMES;
-		atomic_set(&gspca_dev->fr_i, i);
-		wake_up_interruptible(&gspca_dev->wq);	/* event = new frame */
+		spin_lock_irqsave(&gspca_dev->qlock, flags);
+		list_del(&buf->list);
+		spin_unlock_irqrestore(&gspca_dev->qlock, flags);
+		buf->vb.vb2_buf.timestamp = ktime_get_ns();
+		vb2_set_plane_payload(&buf->vb.vb2_buf, 0,
+				      gspca_dev->image_len);
+		buf->vb.sequence = gspca_dev->sequence++;
+		buf->vb.field = V4L2_FIELD_NONE;
 		gspca_dbg(gspca_dev, D_FRAM, "frame complete len:%d\n",
-			  frame->v4l2_buf.bytesused);
+			  gspca_dev->image_len);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 		gspca_dev->image = NULL;
 		gspca_dev->image_len = 0;
 	}
 }
 EXPORT_SYMBOL(gspca_frame_add);
 
-static int frame_alloc(struct gspca_dev *gspca_dev, struct file *file,
-			enum v4l2_memory memory, unsigned int count)
-{
-	struct gspca_frame *frame;
-	unsigned int frsz;
-	int i;
-
-	frsz = gspca_dev->pixfmt.sizeimage;
-	gspca_dbg(gspca_dev, D_STREAM, "frame alloc frsz: %d\n", frsz);
-	frsz = PAGE_ALIGN(frsz);
-	if (count >= GSPCA_MAX_FRAMES)
-		count = GSPCA_MAX_FRAMES - 1;
-	gspca_dev->frbuf = vmalloc_32(frsz * count);
-	if (!gspca_dev->frbuf) {
-		pr_err("frame alloc failed\n");
-		return -ENOMEM;
-	}
-	gspca_dev->capt_file = file;
-	gspca_dev->memory = memory;
-	gspca_dev->frsz = frsz;
-	gspca_dev->nframes = count;
-	for (i = 0; i < count; i++) {
-		frame = &gspca_dev->frame[i];
-		frame->v4l2_buf.index = i;
-		frame->v4l2_buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		frame->v4l2_buf.flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-		frame->v4l2_buf.field = V4L2_FIELD_NONE;
-		frame->v4l2_buf.length = frsz;
-		frame->v4l2_buf.memory = memory;
-		frame->v4l2_buf.sequence = 0;
-		frame->data = gspca_dev->frbuf + i * frsz;
-		frame->v4l2_buf.m.offset = i * frsz;
-	}
-	atomic_set(&gspca_dev->fr_q, 0);
-	atomic_set(&gspca_dev->fr_i, 0);
-	gspca_dev->fr_o = 0;
-	return 0;
-}
-
-static void frame_free(struct gspca_dev *gspca_dev)
-{
-	int i;
-
-	gspca_dbg(gspca_dev, D_STREAM, "frame free\n");
-	if (gspca_dev->frbuf != NULL) {
-		vfree(gspca_dev->frbuf);
-		gspca_dev->frbuf = NULL;
-		for (i = 0; i < gspca_dev->nframes; i++)
-			gspca_dev->frame[i].data = NULL;
-	}
-	gspca_dev->nframes = 0;
-	gspca_dev->frsz = 0;
-	gspca_dev->capt_file = NULL;
-	gspca_dev->memory = GSPCA_MEMORY_NO;
-}
-
 static void destroy_urbs(struct gspca_dev *gspca_dev)
 {
 	struct urb *urb;
@@ -583,22 +499,6 @@ static int gspca_set_alt0(struct gspca_dev *gspca_dev)
 	return ret;
 }
 
-/* Note: both the queue and the usb locks should be held when calling this */
-static void gspca_stream_off(struct gspca_dev *gspca_dev)
-{
-	gspca_dev->streaming = 0;
-	gspca_dev->usb_err = 0;
-	if (gspca_dev->sd_desc->stopN)
-		gspca_dev->sd_desc->stopN(gspca_dev);
-	destroy_urbs(gspca_dev);
-	gspca_input_destroy_urb(gspca_dev);
-	gspca_set_alt0(gspca_dev);
-	gspca_input_create_urb(gspca_dev);
-	if (gspca_dev->sd_desc->stop0)
-		gspca_dev->sd_desc->stop0(gspca_dev);
-	gspca_dbg(gspca_dev, D_STREAM, "stream off OK\n");
-}
-
 /*
  * look for an input transfer endpoint in an alternate setting.
  *
@@ -829,6 +729,23 @@ static int create_urbs(struct gspca_dev *gspca_dev,
 	return 0;
 }
 
+/* Note: both the queue and the usb locks should be held when calling this */
+static void gspca_stream_off(struct gspca_dev *gspca_dev)
+{
+	gspca_dev->streaming = false;
+	gspca_dev->usb_err = 0;
+	if (gspca_dev->sd_desc->stopN)
+		gspca_dev->sd_desc->stopN(gspca_dev);
+	destroy_urbs(gspca_dev);
+	gspca_input_destroy_urb(gspca_dev);
+	gspca_set_alt0(gspca_dev);
+	if (gspca_dev->present)
+		gspca_input_create_urb(gspca_dev);
+	if (gspca_dev->sd_desc->stop0)
+		gspca_dev->sd_desc->stop0(gspca_dev);
+	gspca_dbg(gspca_dev, D_STREAM, "stream off OK\n");
+}
+
 /*
  * start the USB transfer
  */
@@ -844,7 +761,6 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 	gspca_dev->image = NULL;
 	gspca_dev->image_len = 0;
 	gspca_dev->last_packet_type = DISCARD_PACKET;
-	gspca_dev->sequence = 0;
 
 	gspca_dev->usb_err = 0;
 
@@ -924,8 +840,8 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 			destroy_urbs(gspca_dev);
 			goto out;
 		}
-		gspca_dev->streaming = 1;
 		v4l2_ctrl_handler_setup(gspca_dev->vdev.ctrl_handler);
+		gspca_dev->streaming = true;
 
 		/* some bulk transfers are started by the subdriver */
 		if (gspca_dev->cam.bulk && gspca_dev->cam.bulk_nurbs == 0)
@@ -1165,11 +1081,9 @@ static int vidioc_try_fmt_vid_cap(struct file *file,
 			      struct v4l2_format *fmt)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int ret;
 
-	ret = try_fmt_vid_cap(gspca_dev, fmt);
-	if (ret < 0)
-		return ret;
+	if (try_fmt_vid_cap(gspca_dev, fmt) < 0)
+		return -EINVAL;
 	return 0;
 }
 
@@ -1177,36 +1091,22 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			    struct v4l2_format *fmt)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
-		return -ERESTARTSYS;
+	int mode;
 
-	ret = try_fmt_vid_cap(gspca_dev, fmt);
-	if (ret < 0)
-		goto out;
+	if (vb2_is_busy(&gspca_dev->queue))
+		return -EBUSY;
 
-	if (gspca_dev->nframes != 0
-	    && fmt->fmt.pix.sizeimage > gspca_dev->frsz) {
-		ret = -EINVAL;
-		goto out;
-	}
+	mode = try_fmt_vid_cap(gspca_dev, fmt);
+	if (mode < 0)
+		return -EINVAL;
 
-	if (gspca_dev->streaming) {
-		ret = -EBUSY;
-		goto out;
-	}
-	gspca_dev->curr_mode = ret;
+	gspca_dev->curr_mode = mode;
 	if (gspca_dev->sd_desc->try_fmt)
 		/* subdriver try_fmt can modify format parameters */
 		gspca_dev->pixfmt = fmt->fmt.pix;
 	else
-		gspca_dev->pixfmt = gspca_dev->cam.cam_mode[ret];
-
-	ret = 0;
-out:
-	mutex_unlock(&gspca_dev->queue_lock);
-	return ret;
+		gspca_dev->pixfmt = gspca_dev->cam.cam_mode[mode];
+	return 0;
 }
 
 static int vidioc_enum_framesizes(struct file *file, void *priv,
@@ -1281,53 +1181,6 @@ static void gspca_release(struct v4l2_device *v4l2_device)
 	kfree(gspca_dev);
 }
 
-static int dev_open(struct file *file)
-{
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int ret;
-
-	gspca_dbg(gspca_dev, D_STREAM, "[%s] open\n", current->comm);
-
-	/* protect the subdriver against rmmod */
-	if (!try_module_get(gspca_dev->module))
-		return -ENODEV;
-
-	ret = v4l2_fh_open(file);
-	if (ret)
-		module_put(gspca_dev->module);
-	return ret;
-}
-
-static int dev_close(struct file *file)
-{
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-
-	gspca_dbg(gspca_dev, D_STREAM, "[%s] close\n", current->comm);
-
-	/* Needed for gspca_stream_off, always lock before queue_lock! */
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
-
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock)) {
-		mutex_unlock(&gspca_dev->usb_lock);
-		return -ERESTARTSYS;
-	}
-
-	/* if the file did the capture, free the streaming resources */
-	if (gspca_dev->capt_file == file) {
-		if (gspca_dev->streaming)
-			gspca_stream_off(gspca_dev);
-		frame_free(gspca_dev);
-	}
-	module_put(gspca_dev->module);
-	mutex_unlock(&gspca_dev->queue_lock);
-	mutex_unlock(&gspca_dev->usb_lock);
-
-	gspca_dbg(gspca_dev, D_STREAM, "close done\n");
-
-	return v4l2_fh_release(file);
-}
-
 static int vidioc_querycap(struct file *file, void  *priv,
 			   struct v4l2_capability *cap)
 {
@@ -1377,167 +1230,9 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	if (i > 0)
 		return -EINVAL;
-	return (0);
-}
-
-static int vidioc_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *rb)
-{
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int i, ret = 0, streaming;
-
-	i = rb->memory;			/* (avoid compilation warning) */
-	switch (i) {
-	case GSPCA_MEMORY_READ:			/* (internal call) */
-	case V4L2_MEMORY_MMAP:
-	case V4L2_MEMORY_USERPTR:
-		break;
-	default:
-		return -EINVAL;
-	}
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
-		return -ERESTARTSYS;
-
-	if (gspca_dev->memory != GSPCA_MEMORY_NO
-	    && gspca_dev->memory != GSPCA_MEMORY_READ
-	    && gspca_dev->memory != rb->memory) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	/* only one file may do the capture */
-	if (gspca_dev->capt_file != NULL
-	    && gspca_dev->capt_file != file) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	/* if allocated, the buffers must not be mapped */
-	for (i = 0; i < gspca_dev->nframes; i++) {
-		if (gspca_dev->frame[i].vma_use_count) {
-			ret = -EBUSY;
-			goto out;
-		}
-	}
-
-	/* stop streaming */
-	streaming = gspca_dev->streaming;
-	if (streaming) {
-		gspca_stream_off(gspca_dev);
-
-		/* Don't restart the stream when switching from read
-		 * to mmap mode */
-		if (gspca_dev->memory == GSPCA_MEMORY_READ)
-			streaming = 0;
-	}
-
-	/* free the previous allocated buffers, if any */
-	if (gspca_dev->nframes != 0)
-		frame_free(gspca_dev);
-	if (rb->count == 0)			/* unrequest */
-		goto out;
-	ret = frame_alloc(gspca_dev, file, rb->memory, rb->count);
-	if (ret == 0) {
-		rb->count = gspca_dev->nframes;
-		if (streaming)
-			ret = gspca_init_transfer(gspca_dev);
-	}
-out:
-	mutex_unlock(&gspca_dev->queue_lock);
-	gspca_dbg(gspca_dev, D_STREAM, "reqbufs st:%d c:%d\n", ret, rb->count);
-	return ret;
-}
-
-static int vidioc_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *v4l2_buf)
-{
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-	struct gspca_frame *frame;
-
-	if (v4l2_buf->index >= gspca_dev->nframes)
-		return -EINVAL;
-
-	frame = &gspca_dev->frame[v4l2_buf->index];
-	memcpy(v4l2_buf, &frame->v4l2_buf, sizeof *v4l2_buf);
 	return 0;
 }
 
-static int vidioc_streamon(struct file *file, void *priv,
-			   enum v4l2_buf_type buf_type)
-{
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int ret;
-
-	if (buf_type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
-		return -ERESTARTSYS;
-
-	/* check the capture file */
-	if (gspca_dev->capt_file != file) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	if (gspca_dev->nframes == 0
-	    || !(gspca_dev->frame[0].v4l2_buf.flags & V4L2_BUF_FLAG_QUEUED)) {
-		ret = -EINVAL;
-		goto out;
-	}
-	if (!gspca_dev->streaming) {
-		ret = gspca_init_transfer(gspca_dev);
-		if (ret < 0)
-			goto out;
-	}
-	PDEBUG_MODE(gspca_dev, D_STREAM, "stream on OK",
-		    gspca_dev->pixfmt.pixelformat,
-		    gspca_dev->pixfmt.width, gspca_dev->pixfmt.height);
-	ret = 0;
-out:
-	mutex_unlock(&gspca_dev->queue_lock);
-	return ret;
-}
-
-static int vidioc_streamoff(struct file *file, void *priv,
-				enum v4l2_buf_type buf_type)
-{
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int i, ret;
-
-	if (buf_type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
-		return -ERESTARTSYS;
-
-	if (!gspca_dev->streaming) {
-		ret = 0;
-		goto out;
-	}
-
-	/* check the capture file */
-	if (gspca_dev->capt_file != file) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	/* stop streaming */
-	gspca_stream_off(gspca_dev);
-	/* In case another thread is waiting in dqbuf */
-	wake_up_interruptible(&gspca_dev->wq);
-
-	/* empty the transfer queues */
-	for (i = 0; i < gspca_dev->nframes; i++)
-		gspca_dev->frame[i].v4l2_buf.flags &= ~BUF_ALL_FLAGS;
-	atomic_set(&gspca_dev->fr_q, 0);
-	atomic_set(&gspca_dev->fr_i, 0);
-	gspca_dev->fr_o = 0;
-	ret = 0;
-out:
-	mutex_unlock(&gspca_dev->queue_lock);
-	return ret;
-}
-
 static int vidioc_g_jpegcomp(struct file *file, void *priv,
 			struct v4l2_jpegcompression *jpegcomp)
 {
@@ -1561,7 +1256,7 @@ static int vidioc_g_parm(struct file *filp, void *priv,
 {
 	struct gspca_dev *gspca_dev = video_drvdata(filp);
 
-	parm->parm.capture.readbuffers = gspca_dev->nbufread;
+	parm->parm.capture.readbuffers = 2;
 
 	if (gspca_dev->sd_desc->get_streamparm) {
 		gspca_dev->usb_err = 0;
@@ -1575,13 +1270,8 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 			struct v4l2_streamparm *parm)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(filp);
-	unsigned int n;
 
-	n = parm->parm.capture.readbuffers;
-	if (n == 0 || n >= GSPCA_MAX_FRAMES)
-		parm->parm.capture.readbuffers = gspca_dev->nbufread;
-	else
-		gspca_dev->nbufread = n;
+	parm->parm.capture.readbuffers = 2;
 
 	if (gspca_dev->sd_desc->set_streamparm) {
 		gspca_dev->usb_err = 0;
@@ -1592,418 +1282,138 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 	return 0;
 }
 
-static int dev_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-	struct gspca_frame *frame;
-	struct page *page;
-	unsigned long addr, start, size;
-	int i, ret;
-
-	start = vma->vm_start;
-	size = vma->vm_end - vma->vm_start;
-	gspca_dbg(gspca_dev, D_STREAM, "mmap start:%08x size:%d\n",
-		  (int) start, (int)size);
-
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
-		return -ERESTARTSYS;
-	if (gspca_dev->capt_file != file) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	frame = NULL;
-	for (i = 0; i < gspca_dev->nframes; ++i) {
-		if (gspca_dev->frame[i].v4l2_buf.memory != V4L2_MEMORY_MMAP) {
-			gspca_dbg(gspca_dev, D_STREAM, "mmap bad memory type\n");
-			break;
-		}
-		if ((gspca_dev->frame[i].v4l2_buf.m.offset >> PAGE_SHIFT)
-						== vma->vm_pgoff) {
-			frame = &gspca_dev->frame[i];
-			break;
-		}
-	}
-	if (frame == NULL) {
-		gspca_dbg(gspca_dev, D_STREAM, "mmap no frame buffer found\n");
-		ret = -EINVAL;
-		goto out;
-	}
-	if (size != frame->v4l2_buf.length) {
-		gspca_dbg(gspca_dev, D_STREAM, "mmap bad size\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/*
-	 * - VM_IO marks the area as being a mmaped region for I/O to a
-	 *   device. It also prevents the region from being core dumped.
-	 */
-	vma->vm_flags |= VM_IO;
-
-	addr = (unsigned long) frame->data;
-	while (size > 0) {
-		page = vmalloc_to_page((void *) addr);
-		ret = vm_insert_page(vma, start, page);
-		if (ret < 0)
-			goto out;
-		start += PAGE_SIZE;
-		addr += PAGE_SIZE;
-		size -= PAGE_SIZE;
-	}
-
-	vma->vm_ops = &gspca_vm_ops;
-	vma->vm_private_data = frame;
-	gspca_vm_open(vma);
-	ret = 0;
-out:
-	mutex_unlock(&gspca_dev->queue_lock);
-	return ret;
-}
-
-static int frame_ready_nolock(struct gspca_dev *gspca_dev, struct file *file,
-				enum v4l2_memory memory)
+static int gspca_queue_setup(struct vb2_queue *vq,
+			     unsigned int *nbuffers, unsigned int *nplanes,
+			     unsigned int sizes[], struct device *alloc_devs[])
 {
-	if (!gspca_dev->present)
-		return -ENODEV;
-	if (gspca_dev->capt_file != file || gspca_dev->memory != memory ||
-			!gspca_dev->streaming)
-		return -EINVAL;
+	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vq);
 
-	/* check if a frame is ready */
-	return gspca_dev->fr_o != atomic_read(&gspca_dev->fr_i);
+	if (*nplanes)
+		return sizes[0] < gspca_dev->pixfmt.sizeimage ? -EINVAL : 0;
+	*nplanes = 1;
+	sizes[0] = gspca_dev->pixfmt.sizeimage;
+	return 0;
 }
 
-static int frame_ready(struct gspca_dev *gspca_dev, struct file *file,
-			enum v4l2_memory memory)
+static int gspca_buffer_prepare(struct vb2_buffer *vb)
 {
-	int ret;
+	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size = gspca_dev->pixfmt.sizeimage;
 
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
-		return -ERESTARTSYS;
-	ret = frame_ready_nolock(gspca_dev, file, memory);
-	mutex_unlock(&gspca_dev->queue_lock);
-	return ret;
+	if (vb2_plane_size(vb, 0) < size) {
+		gspca_err(gspca_dev, "buffer too small (%lu < %lu)\n",
+			 vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+	return 0;
 }
 
-/*
- * dequeue a video buffer
- *
- * If nonblock_ing is false, block until a buffer is available.
- */
-static int vidioc_dqbuf(struct file *file, void *priv,
-			struct v4l2_buffer *v4l2_buf)
+static void gspca_buffer_finish(struct vb2_buffer *vb)
 {
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-	struct gspca_frame *frame;
-	int i, j, ret;
-
-	gspca_dbg(gspca_dev, D_FRAM, "dqbuf\n");
-
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
-		return -ERESTARTSYS;
-
-	for (;;) {
-		ret = frame_ready_nolock(gspca_dev, file, v4l2_buf->memory);
-		if (ret < 0)
-			goto out;
-		if (ret > 0)
-			break;
-
-		mutex_unlock(&gspca_dev->queue_lock);
-
-		if (file->f_flags & O_NONBLOCK)
-			return -EAGAIN;
-
-		/* wait till a frame is ready */
-		ret = wait_event_interruptible_timeout(gspca_dev->wq,
-			frame_ready(gspca_dev, file, v4l2_buf->memory),
-			msecs_to_jiffies(3000));
-		if (ret < 0)
-			return ret;
-		if (ret == 0)
-			return -EIO;
-
-		if (mutex_lock_interruptible(&gspca_dev->queue_lock))
-			return -ERESTARTSYS;
-	}
-
-	i = gspca_dev->fr_o;
-	j = gspca_dev->fr_queue[i];
-	frame = &gspca_dev->frame[j];
+	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vb->vb2_queue);
 
-	gspca_dev->fr_o = (i + 1) % GSPCA_MAX_FRAMES;
-
-	frame->v4l2_buf.flags &= ~V4L2_BUF_FLAG_DONE;
-	memcpy(v4l2_buf, &frame->v4l2_buf, sizeof *v4l2_buf);
-	gspca_dbg(gspca_dev, D_FRAM, "dqbuf %d\n", j);
-	ret = 0;
-
-	if (gspca_dev->memory == V4L2_MEMORY_USERPTR) {
-		if (copy_to_user((__u8 __user *) frame->v4l2_buf.m.userptr,
-				 frame->data,
-				 frame->v4l2_buf.bytesused)) {
-			gspca_err(gspca_dev, "dqbuf cp to user failed\n");
-			ret = -EFAULT;
-		}
-	}
-out:
-	mutex_unlock(&gspca_dev->queue_lock);
-
-	if (ret == 0 && gspca_dev->sd_desc->dq_callback) {
-		mutex_lock(&gspca_dev->usb_lock);
-		gspca_dev->usb_err = 0;
-		if (gspca_dev->present)
-			gspca_dev->sd_desc->dq_callback(gspca_dev);
-		mutex_unlock(&gspca_dev->usb_lock);
-	}
+	if (!gspca_dev->sd_desc->dq_callback)
+		return;
 
-	return ret;
+	gspca_dev->usb_err = 0;
+	if (gspca_dev->present)
+		gspca_dev->sd_desc->dq_callback(gspca_dev);
 }
 
-/*
- * queue a video buffer
- *
- * Attempting to queue a buffer that has already been
- * queued will return -EINVAL.
- */
-static int vidioc_qbuf(struct file *file, void *priv,
-			struct v4l2_buffer *v4l2_buf)
+static void gspca_buffer_queue(struct vb2_buffer *vb)
 {
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-	struct gspca_frame *frame;
-	int i, index, ret;
-
-	gspca_dbg(gspca_dev, D_FRAM, "qbuf %d\n", v4l2_buf->index);
-
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
-		return -ERESTARTSYS;
-
-	index = v4l2_buf->index;
-	if ((unsigned) index >= gspca_dev->nframes) {
-		gspca_dbg(gspca_dev, D_FRAM,
-			  "qbuf idx %d >= %d\n", index, gspca_dev->nframes);
-		ret = -EINVAL;
-		goto out;
-	}
-	if (v4l2_buf->memory != gspca_dev->memory) {
-		gspca_dbg(gspca_dev, D_FRAM, "qbuf bad memory type\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	frame = &gspca_dev->frame[index];
-	if (frame->v4l2_buf.flags & BUF_ALL_FLAGS) {
-		gspca_dbg(gspca_dev, D_FRAM, "qbuf bad state\n");
-		ret = -EINVAL;
-		goto out;
-	}
+	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct gspca_buffer *buf = to_gspca_buffer(vb);
+	unsigned long flags;
 
-	frame->v4l2_buf.flags |= V4L2_BUF_FLAG_QUEUED;
-
-	if (frame->v4l2_buf.memory == V4L2_MEMORY_USERPTR) {
-		frame->v4l2_buf.m.userptr = v4l2_buf->m.userptr;
-		frame->v4l2_buf.length = v4l2_buf->length;
-	}
-
-	/* put the buffer in the 'queued' queue */
-	i = atomic_read(&gspca_dev->fr_q);
-	gspca_dev->fr_queue[i] = index;
-	atomic_set(&gspca_dev->fr_q, (i + 1) % GSPCA_MAX_FRAMES);
-
-	v4l2_buf->flags |= V4L2_BUF_FLAG_QUEUED;
-	v4l2_buf->flags &= ~V4L2_BUF_FLAG_DONE;
-	ret = 0;
-out:
-	mutex_unlock(&gspca_dev->queue_lock);
-	return ret;
+	spin_lock_irqsave(&gspca_dev->qlock, flags);
+	list_add_tail(&buf->list, &gspca_dev->buf_list);
+	spin_unlock_irqrestore(&gspca_dev->qlock, flags);
 }
 
-/*
- * allocate the resources for read()
- */
-static int read_alloc(struct gspca_dev *gspca_dev,
-			struct file *file)
+static void gspca_return_all_buffers(struct gspca_dev *gspca_dev,
+				     enum vb2_buffer_state state)
 {
-	struct v4l2_buffer v4l2_buf;
-	int i, ret;
-
-	gspca_dbg(gspca_dev, D_STREAM, "read alloc\n");
-
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
+	struct gspca_buffer *buf, *node;
+	unsigned long flags;
 
-	if (gspca_dev->nframes == 0) {
-		struct v4l2_requestbuffers rb;
-
-		memset(&rb, 0, sizeof rb);
-		rb.count = gspca_dev->nbufread;
-		rb.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		rb.memory = GSPCA_MEMORY_READ;
-		ret = vidioc_reqbufs(file, gspca_dev, &rb);
-		if (ret != 0) {
-			gspca_dbg(gspca_dev, D_STREAM, "read reqbuf err %d\n",
-				  ret);
-			goto out;
-		}
-		memset(&v4l2_buf, 0, sizeof v4l2_buf);
-		v4l2_buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		v4l2_buf.memory = GSPCA_MEMORY_READ;
-		for (i = 0; i < gspca_dev->nbufread; i++) {
-			v4l2_buf.index = i;
-			ret = vidioc_qbuf(file, gspca_dev, &v4l2_buf);
-			if (ret != 0) {
-				gspca_dbg(gspca_dev, D_STREAM, "read qbuf err: %d\n",
-					  ret);
-				goto out;
-			}
-		}
+	spin_lock_irqsave(&gspca_dev->qlock, flags);
+	list_for_each_entry_safe(buf, node, &gspca_dev->buf_list, list) {
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
+		list_del(&buf->list);
 	}
-
-	/* start streaming */
-	ret = vidioc_streamon(file, gspca_dev, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	if (ret != 0)
-		gspca_dbg(gspca_dev, D_STREAM, "read streamon err %d\n", ret);
-out:
-	mutex_unlock(&gspca_dev->usb_lock);
-	return ret;
+	spin_unlock_irqrestore(&gspca_dev->qlock, flags);
 }
 
-static __poll_t dev_poll(struct file *file, poll_table *wait)
+static int gspca_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-	__poll_t req_events = poll_requested_events(wait);
-	__poll_t ret = 0;
-
-	gspca_dbg(gspca_dev, D_FRAM, "poll\n");
-
-	if (req_events & EPOLLPRI)
-		ret |= v4l2_ctrl_poll(file, wait);
-
-	if (req_events & (EPOLLIN | EPOLLRDNORM)) {
-		/* if reqbufs is not done, the user would use read() */
-		if (gspca_dev->memory == GSPCA_MEMORY_NO) {
-			if (read_alloc(gspca_dev, file) != 0) {
-				ret |= EPOLLERR;
-				goto out;
-			}
-		}
-
-		poll_wait(file, &gspca_dev->wq, wait);
-
-		/* check if an image has been received */
-		if (mutex_lock_interruptible(&gspca_dev->queue_lock) != 0) {
-			ret |= EPOLLERR;
-			goto out;
-		}
-		if (gspca_dev->fr_o != atomic_read(&gspca_dev->fr_i))
-			ret |= EPOLLIN | EPOLLRDNORM;
-		mutex_unlock(&gspca_dev->queue_lock);
-	}
+	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vq);
+	int ret;
 
-out:
-	if (!gspca_dev->present)
-		ret |= EPOLLHUP;
+	gspca_dev->sequence = 0;
 
+	ret = gspca_init_transfer(gspca_dev);
+	if (ret)
+		gspca_return_all_buffers(gspca_dev, VB2_BUF_STATE_QUEUED);
 	return ret;
 }
 
-static ssize_t dev_read(struct file *file, char __user *data,
-		    size_t count, loff_t *ppos)
+static void gspca_stop_streaming(struct vb2_queue *vq)
 {
-	struct gspca_dev *gspca_dev = video_drvdata(file);
-	struct gspca_frame *frame;
-	struct v4l2_buffer v4l2_buf;
-	struct timeval timestamp;
-	int n, ret, ret2;
-
-	gspca_dbg(gspca_dev, D_FRAM, "read (%zd)\n", count);
-	if (gspca_dev->memory == GSPCA_MEMORY_NO) { /* first time ? */
-		ret = read_alloc(gspca_dev, file);
-		if (ret != 0)
-			return ret;
-	}
-
-	/* get a frame */
-	v4l2_get_timestamp(&timestamp);
-	timestamp.tv_sec--;
-	n = 2;
-	for (;;) {
-		memset(&v4l2_buf, 0, sizeof v4l2_buf);
-		v4l2_buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		v4l2_buf.memory = GSPCA_MEMORY_READ;
-		ret = vidioc_dqbuf(file, gspca_dev, &v4l2_buf);
-		if (ret != 0) {
-			gspca_dbg(gspca_dev, D_STREAM, "read dqbuf err %d\n",
-				  ret);
-			return ret;
-		}
+	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vq);
 
-		/* if the process slept for more than 1 second,
-		 * get a newer frame */
-		frame = &gspca_dev->frame[v4l2_buf.index];
-		if (--n < 0)
-			break;			/* avoid infinite loop */
-		if (frame->v4l2_buf.timestamp.tv_sec >= timestamp.tv_sec)
-			break;
-		ret = vidioc_qbuf(file, gspca_dev, &v4l2_buf);
-		if (ret != 0) {
-			gspca_dbg(gspca_dev, D_STREAM, "read qbuf err %d\n",
-				  ret);
-			return ret;
-		}
-	}
+	gspca_stream_off(gspca_dev);
 
-	/* copy the frame */
-	if (count > frame->v4l2_buf.bytesused)
-		count = frame->v4l2_buf.bytesused;
-	ret = copy_to_user(data, frame->data, count);
-	if (ret != 0) {
-		gspca_err(gspca_dev, "read cp to user lack %d / %zd\n",
-			  ret, count);
-		ret = -EFAULT;
-		goto out;
-	}
-	ret = count;
-out:
-	/* in each case, requeue the buffer */
-	ret2 = vidioc_qbuf(file, gspca_dev, &v4l2_buf);
-	if (ret2 != 0)
-		return ret2;
-	return ret;
+	/* Release all active buffers */
+	gspca_return_all_buffers(gspca_dev, VB2_BUF_STATE_ERROR);
 }
 
+static const struct vb2_ops gspca_qops = {
+	.queue_setup		= gspca_queue_setup,
+	.buf_prepare		= gspca_buffer_prepare,
+	.buf_finish		= gspca_buffer_finish,
+	.buf_queue		= gspca_buffer_queue,
+	.start_streaming	= gspca_start_streaming,
+	.stop_streaming		= gspca_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
 static const struct v4l2_file_operations dev_fops = {
 	.owner = THIS_MODULE,
-	.open = dev_open,
-	.release = dev_close,
-	.read = dev_read,
-	.mmap = dev_mmap,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
 	.unlocked_ioctl = video_ioctl2,
-	.poll	= dev_poll,
+	.read = vb2_fop_read,
+	.mmap = vb2_fop_mmap,
+	.poll = vb2_fop_poll,
 };
 
 static const struct v4l2_ioctl_ops dev_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
-	.vidioc_dqbuf		= vidioc_dqbuf,
-	.vidioc_qbuf		= vidioc_qbuf,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
-	.vidioc_streamon	= vidioc_streamon,
 	.vidioc_enum_input	= vidioc_enum_input,
 	.vidioc_g_input		= vidioc_g_input,
 	.vidioc_s_input		= vidioc_s_input,
-	.vidioc_reqbufs		= vidioc_reqbufs,
-	.vidioc_querybuf	= vidioc_querybuf,
-	.vidioc_streamoff	= vidioc_streamoff,
 	.vidioc_g_jpegcomp	= vidioc_g_jpegcomp,
 	.vidioc_s_jpegcomp	= vidioc_s_jpegcomp,
 	.vidioc_g_parm		= vidioc_g_parm,
 	.vidioc_s_parm		= vidioc_s_parm,
 	.vidioc_enum_framesizes = vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
+
+	.vidioc_reqbufs		= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs	= vb2_ioctl_create_bufs,
+	.vidioc_querybuf	= vb2_ioctl_querybuf,
+	.vidioc_qbuf		= vb2_ioctl_qbuf,
+	.vidioc_dqbuf		= vb2_ioctl_dqbuf,
+	.vidioc_expbuf		= vb2_ioctl_expbuf,
+	.vidioc_streamon	= vb2_ioctl_streamon,
+	.vidioc_streamoff	= vb2_ioctl_streamoff,
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_chip_info	= vidioc_g_chip_info,
 	.vidioc_g_register	= vidioc_g_register,
@@ -2034,6 +1444,7 @@ int gspca_dev_probe2(struct usb_interface *intf,
 {
 	struct gspca_dev *gspca_dev;
 	struct usb_device *dev = interface_to_usbdev(intf);
+	struct vb2_queue *q;
 	int ret;
 
 	pr_info("%s-" GSPCA_VERSION " probing %04x:%04x\n",
@@ -2078,20 +1489,37 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	ret = v4l2_device_register(&intf->dev, &gspca_dev->v4l2_dev);
 	if (ret)
 		goto out;
+	gspca_dev->present = true;
 	gspca_dev->sd_desc = sd_desc;
-	gspca_dev->nbufread = 2;
 	gspca_dev->empty_packet = -1;	/* don't check the empty packets */
 	gspca_dev->vdev = gspca_template;
 	gspca_dev->vdev.v4l2_dev = &gspca_dev->v4l2_dev;
 	video_set_drvdata(&gspca_dev->vdev, gspca_dev);
 	gspca_dev->module = module;
-	gspca_dev->present = 1;
 
 	mutex_init(&gspca_dev->usb_lock);
 	gspca_dev->vdev.lock = &gspca_dev->usb_lock;
-	mutex_init(&gspca_dev->queue_lock);
 	init_waitqueue_head(&gspca_dev->wq);
 
+	/* Initialize the vb2 queue */
+	q = &gspca_dev->queue;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+	q->drv_priv = gspca_dev;
+	q->buf_struct_size = sizeof(struct gspca_buffer);
+	q->ops = &gspca_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->min_buffers_needed = 2;
+	q->lock = &gspca_dev->usb_lock;
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto out;
+	gspca_dev->vdev.queue = q;
+
+	INIT_LIST_HEAD(&gspca_dev->buf_list);
+	spin_lock_init(&gspca_dev->qlock);
+
 	/* configure the subdriver and initialize the USB device */
 	ret = sd_desc->config(gspca_dev, id);
 	if (ret < 0)
@@ -2109,14 +1537,6 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	if (ret)
 		goto out;
 
-	/*
-	 * Don't take usb_lock for these ioctls. This improves latency if
-	 * usb_lock is taken for a long time, e.g. when changing a control
-	 * value, and a new frame is ready to be dequeued.
-	 */
-	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_DQBUF);
-	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_QBUF);
-	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_QUERYBUF);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	if (!gspca_dev->sd_desc->get_register)
 		v4l2_disable_ioctl(&gspca_dev->vdev, VIDIOC_DBG_G_REGISTER);
@@ -2198,24 +1618,17 @@ void gspca_disconnect(struct usb_interface *intf)
 		  video_device_node_name(&gspca_dev->vdev));
 
 	mutex_lock(&gspca_dev->usb_lock);
+	gspca_dev->present = false;
 
-	gspca_dev->present = 0;
-	destroy_urbs(gspca_dev);
+	vb2_queue_error(&gspca_dev->queue);
 
 #if IS_ENABLED(CONFIG_INPUT)
-	gspca_input_destroy_urb(gspca_dev);
 	input_dev = gspca_dev->input_dev;
 	if (input_dev) {
 		gspca_dev->input_dev = NULL;
 		input_unregister_device(input_dev);
 	}
 #endif
-	/* Free subdriver's streaming resources / stop sd workqueue(s) */
-	if (gspca_dev->sd_desc->stop0 && gspca_dev->streaming)
-		gspca_dev->sd_desc->stop0(gspca_dev);
-	gspca_dev->streaming = 0;
-	gspca_dev->dev = NULL;
-	wake_up_interruptible(&gspca_dev->wq);
 
 	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
 	video_unregister_device(&gspca_dev->vdev);
@@ -2234,7 +1647,7 @@ int gspca_suspend(struct usb_interface *intf, pm_message_t message)
 
 	gspca_input_destroy_urb(gspca_dev);
 
-	if (!gspca_dev->streaming)
+	if (!vb2_start_streaming_called(&gspca_dev->queue))
 		return 0;
 
 	mutex_lock(&gspca_dev->usb_lock);
@@ -2266,8 +1679,7 @@ int gspca_resume(struct usb_interface *intf)
 	 * only write to the device registers on s_ctrl when streaming ->
 	 * Clear streaming to avoid setting all ctrls twice.
 	 */
-	streaming = gspca_dev->streaming;
-	gspca_dev->streaming = 0;
+	streaming = vb2_start_streaming_called(&gspca_dev->queue);
 	if (streaming)
 		ret = gspca_init_transfer(gspca_dev);
 	else
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index 249cb38a542f..b0ced2e14006 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -9,6 +9,8 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-vmalloc.h>
 #include <linux/mutex.h>
 
 
@@ -138,19 +140,22 @@ enum gspca_packet_type {
 	LAST_PACKET
 };
 
-struct gspca_frame {
-	__u8 *data;			/* frame buffer */
-	int vma_use_count;
-	struct v4l2_buffer v4l2_buf;
+struct gspca_buffer {
+	struct vb2_v4l2_buffer vb;
+	struct list_head list;
 };
 
+static inline struct gspca_buffer *to_gspca_buffer(struct vb2_buffer *vb2)
+{
+	return container_of(vb2, struct gspca_buffer, vb.vb2_buf);
+}
+
 struct gspca_dev {
 	struct video_device vdev;	/* !! must be the first item */
 	struct module *module;		/* subdriver handling the device */
 	struct v4l2_device v4l2_dev;
 	struct usb_device *dev;
-	struct file *capt_file;		/* file doing video capture */
-					/* protected by queue_lock */
+
 #if IS_ENABLED(CONFIG_INPUT)
 	struct input_dev *input_dev;
 	char phys[64];			/* physical device path */
@@ -176,34 +181,29 @@ struct gspca_dev {
 	struct urb *int_urb;
 #endif
 
-	__u8 *frbuf;				/* buffer for nframes */
-	struct gspca_frame frame[GSPCA_MAX_FRAMES];
-	u8 *image;				/* image beeing filled */
-	__u32 frsz;				/* frame size */
+	u8 *image;				/* image being filled */
 	u32 image_len;				/* current length of image */
-	atomic_t fr_q;				/* next frame to queue */
-	atomic_t fr_i;				/* frame being filled */
-	signed char fr_queue[GSPCA_MAX_FRAMES];	/* frame queue */
-	char nframes;				/* number of frames */
-	u8 fr_o;				/* next frame to dequeue */
 	__u8 last_packet_type;
 	__s8 empty_packet;		/* if (-1) don't check empty packets */
-	__u8 streaming;			/* protected by both mutexes (*) */
+	bool streaming;
 
 	__u8 curr_mode;			/* current camera mode */
 	struct v4l2_pix_format pixfmt;	/* current mode parameters */
 	__u32 sequence;			/* frame sequence number */
 
+	struct vb2_queue queue;
+
+	spinlock_t qlock;
+	struct list_head buf_list;
+
 	wait_queue_head_t wq;		/* wait queue */
 	struct mutex usb_lock;		/* usb exchange protection */
-	struct mutex queue_lock;	/* ISOC queue protection */
 	int usb_err;			/* USB error - protected by usb_lock */
 	u16 pkt_size;			/* ISOC packet size */
 #ifdef CONFIG_PM
 	char frozen;			/* suspend - resume */
 #endif
-	char present;			/* device connected */
-	char nbufread;			/* number of buffers for read() */
+	bool present;
 	char memory;			/* memory type (V4L2_MEMORY_xxx) */
 	__u8 iface;			/* USB interface number */
 	__u8 alt;			/* USB alternate setting */
diff --git a/drivers/media/usb/gspca/m5602/m5602_core.c b/drivers/media/usb/gspca/m5602/m5602_core.c
index b83ec4285a0b..30b7cf1feedd 100644
--- a/drivers/media/usb/gspca/m5602/m5602_core.c
+++ b/drivers/media/usb/gspca/m5602/m5602_core.c
@@ -342,7 +342,7 @@ static void m5602_urb_complete(struct gspca_dev *gspca_dev,
 		data += 4;
 		len -= 4;
 
-		if (cur_frame_len + len <= gspca_dev->frsz) {
+		if (cur_frame_len + len <= gspca_dev->pixfmt.sizeimage) {
 			gspca_dbg(gspca_dev, D_FRAM, "Continuing frame %d copying %d bytes\n",
 				  sd->frame_count, len);
 
@@ -351,7 +351,7 @@ static void m5602_urb_complete(struct gspca_dev *gspca_dev,
 		} else {
 			/* Add the remaining data up to frame size */
 			gspca_frame_add(gspca_dev, INTER_PACKET, data,
-				    gspca_dev->frsz - cur_frame_len);
+				gspca_dev->pixfmt.sizeimage - cur_frame_len);
 		}
 	}
 }
diff --git a/drivers/media/usb/gspca/vc032x.c b/drivers/media/usb/gspca/vc032x.c
index 6b11597977c9..52d071659634 100644
--- a/drivers/media/usb/gspca/vc032x.c
+++ b/drivers/media/usb/gspca/vc032x.c
@@ -3642,7 +3642,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 		int size, l;
 
 		l = gspca_dev->image_len;
-		size = gspca_dev->frsz;
+		size = gspca_dev->pixfmt.sizeimage;
 		if (len > size - l)
 			len = size - l;
 	}
-- 
2.17.0
