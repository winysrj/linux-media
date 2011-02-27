Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34574 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1B0SMa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 13:12:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com, hverkuil@xs4all.nl
Subject: [RFC/PATCH 2/2] uvcvideo: Use videobuf2
Date: Sun, 27 Feb 2011 19:12:33 +0100
Message-Id: <1298830353-9797-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Replace the uvcvideo buffer queue implementation by videobuf2.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/Kconfig      |    1 +
 drivers/media/video/uvc/uvc_isight.c |   10 +-
 drivers/media/video/uvc/uvc_queue.c  |  494 ++++++++++------------------------
 drivers/media/video/uvc/uvc_v4l2.c   |   19 +--
 drivers/media/video/uvc/uvc_video.c  |   30 +-
 drivers/usb/gadget/uvc.h             |    2 +-
 include/linux/uvcvideo.h             |   37 ++--
 7 files changed, 176 insertions(+), 417 deletions(-)

diff --git a/drivers/media/video/uvc/Kconfig b/drivers/media/video/uvc/Kconfig
index 2956a76..6c197da 100644
--- a/drivers/media/video/uvc/Kconfig
+++ b/drivers/media/video/uvc/Kconfig
@@ -1,5 +1,6 @@
 config USB_VIDEO_CLASS
 	tristate "USB Video Class (UVC)"
+	select VIDEOBUF2_VMALLOC
 	---help---
 	  Support for the USB Video Class (UVC).  Currently only video
 	  input devices, such as webcams, are supported.
diff --git a/drivers/media/video/uvc/uvc_isight.c b/drivers/media/video/uvc/uvc_isight.c
index 8217c5d..eaa5df0 100644
--- a/drivers/media/video/uvc/uvc_isight.c
+++ b/drivers/media/video/uvc/uvc_isight.c
@@ -73,7 +73,7 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
 	 * Empty buffers (bytesused == 0) don't trigger end of frame detection
 	 * as it doesn't make sense to return an empty buffer.
 	 */
-	if (is_header && buf->buf.bytesused != 0) {
+	if (is_header && buf->bytesused != 0) {
 		buf->state = UVC_BUF_STATE_DONE;
 		return -EAGAIN;
 	}
@@ -82,13 +82,13 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
 	 * contain no data.
 	 */
 	if (!is_header) {
-		maxlen = buf->buf.length - buf->buf.bytesused;
-		mem = queue->mem + buf->buf.m.offset + buf->buf.bytesused;
+		maxlen = buf->length - buf->bytesused;
+		mem = buf->mem + buf->bytesused;
 		nbytes = min(len, maxlen);
 		memcpy(mem, data, nbytes);
-		buf->buf.bytesused += nbytes;
+		buf->bytesused += nbytes;
 
-		if (len > maxlen || buf->buf.bytesused == buf->buf.length) {
+		if (len > maxlen || buf->bytesused == buf->length) {
 			uvc_trace(UVC_TRACE_FRAME, "Frame complete "
 				  "(overflow).\n");
 			buf->state = UVC_BUF_STATE_DONE;
diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index 36f3c58..cb73b08 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -20,6 +20,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
+#include <media/videobuf2-vmalloc.h>
 #include <asm/atomic.h>
 
 /* ------------------------------------------------------------------------
@@ -68,7 +69,7 @@
  *
  *    When the device is disconnected, the kernel calls the completion handler
  *    with an appropriate status code. The handler marks all buffers in the
- *    irq queue as being erroneous (UVC_BUF_STATE_ERROR) and wakes them up so
+ *    irq queue as being erroneous (UVC_BUF_STATE_ERROR) and completes them so
  *    that any process waiting on a buffer gets woken up.
  *
  *    Waking up up the first buffer on the irq list is not enough, as the
@@ -77,414 +78,192 @@
  *
  */
 
-void uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
-		    int drop_corrupted)
-{
-	mutex_init(&queue->mutex);
-	spin_lock_init(&queue->irqlock);
-	INIT_LIST_HEAD(&queue->mainqueue);
-	INIT_LIST_HEAD(&queue->irqqueue);
-	queue->flags = drop_corrupted ? UVC_QUEUE_DROP_CORRUPTED : 0;
-	queue->type = type;
-}
-
-/*
- * Free the video buffers.
- *
- * This function must be called with the queue lock held.
+/* -----------------------------------------------------------------------------
+ * videobuf2 queue operations
  */
-static int __uvc_free_buffers(struct uvc_video_queue *queue)
+
+static int uvc_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
+			   unsigned int *nplanes, unsigned long sizes[],
+			   void *alloc_ctxs[])
 {
-	unsigned int i;
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
+	struct uvc_streaming *stream =
+			container_of(queue, struct uvc_streaming, queue);
 
-	for (i = 0; i < queue->count; ++i) {
-		if (queue->buffer[i].vma_use_count != 0)
-			return -EBUSY;
-	}
+	if (*nbuffers > UVC_MAX_VIDEO_BUFFERS)
+		*nbuffers = UVC_MAX_VIDEO_BUFFERS;
 
-	if (queue->count) {
-		vfree(queue->mem);
-		queue->count = 0;
-	}
+	*nplanes = 1;
+
+	sizes[0] = stream->ctrl.dwMaxVideoFrameSize;
 
 	return 0;
 }
 
-int uvc_free_buffers(struct uvc_video_queue *queue)
+static int uvc_buffer_prepare(struct vb2_buffer *vb)
 {
-	int ret;
+	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 
-	mutex_lock(&queue->mutex);
-	ret = __uvc_free_buffers(queue);
-	mutex_unlock(&queue->mutex);
+	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
+		return -EINVAL;
+	}
 
-	return ret;
+	buf->state = UVC_BUF_STATE_QUEUED;
+	buf->error = 0;
+	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->length = vb2_plane_size(vb, 0);
+	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		buf->bytesused = 0;
+	else
+		buf->bytesused = vb2_get_plane_payload(vb, 0);
+
+	return 0;
 }
 
-/*
- * Allocate the video buffers.
- *
- * Pages are reserved to make sure they will not be swapped, as they will be
- * filled in the URB completion handler.
- *
- * Buffers will be individually mapped, so they must all be page aligned.
- */
-int uvc_alloc_buffers(struct uvc_video_queue *queue, unsigned int nbuffers,
-		unsigned int buflength)
+static int uvc_buffer_queue(struct vb2_buffer *vb)
 {
-	unsigned int bufsize = PAGE_ALIGN(buflength);
-	unsigned int i;
-	void *mem = NULL;
-	int ret;
-
-	if (nbuffers > UVC_MAX_VIDEO_BUFFERS)
-		nbuffers = UVC_MAX_VIDEO_BUFFERS;
-
-	mutex_lock(&queue->mutex);
-
-	if ((ret = __uvc_free_buffers(queue)) < 0)
-		goto done;
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	unsigned long flags;
+	int ret = 0;
 
-	/* Bail out if no buffers should be allocated. */
-	if (nbuffers == 0)
+	spin_lock_irqsave(&queue->irqlock, flags);
+	if (queue->flags & UVC_QUEUE_DISCONNECTED) {
+		ret = -ENODEV;
 		goto done;
-
-	/* Decrement the number of buffers until allocation succeeds. */
-	for (; nbuffers > 0; --nbuffers) {
-		mem = vmalloc_32(nbuffers * bufsize);
-		if (mem != NULL)
-			break;
 	}
 
-	if (mem == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	list_add_tail(&buf->queue, &queue->irqqueue);
+done:
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+	return ret;
+}
 
-	for (i = 0; i < nbuffers; ++i) {
-		memset(&queue->buffer[i], 0, sizeof queue->buffer[i]);
-		queue->buffer[i].buf.index = i;
-		queue->buffer[i].buf.m.offset = i * bufsize;
-		queue->buffer[i].buf.length = buflength;
-		queue->buffer[i].buf.type = queue->type;
-		queue->buffer[i].buf.field = V4L2_FIELD_NONE;
-		queue->buffer[i].buf.memory = V4L2_MEMORY_MMAP;
-		queue->buffer[i].buf.flags = 0;
-		init_waitqueue_head(&queue->buffer[i].wait);
-	}
+static struct vb2_ops uvc_queue_qops = {
+	.queue_setup = uvc_queue_setup,
+	.buf_prepare = uvc_buffer_prepare,
+	.buf_queue = uvc_buffer_queue,
+};
 
-	queue->mem = mem;
-	queue->count = nbuffers;
-	queue->buf_size = bufsize;
-	ret = nbuffers;
+void uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
+		    int drop_corrupted)
+{
+	queue->queue.type = type;
+	queue->queue.io_modes = VB2_MMAP;
+	queue->queue.drv_priv = queue;
+	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
+	queue->queue.ops = &uvc_queue_qops;
+	queue->queue.mem_ops = &vb2_vmalloc_memops;
+	vb2_queue_init(&queue->queue);
 
-done:
-	mutex_unlock(&queue->mutex);
-	return ret;
+	mutex_init(&queue->mutex);
+	spin_lock_init(&queue->irqlock);
+	INIT_LIST_HEAD(&queue->irqqueue);
+	queue->flags = drop_corrupted ? UVC_QUEUE_DROP_CORRUPTED : 0;
 }
 
-/*
- * Check if buffers have been allocated.
+/* -----------------------------------------------------------------------------
+ * V4L2 queue operations
  */
-int uvc_queue_allocated(struct uvc_video_queue *queue)
+
+int uvc_alloc_buffers(struct uvc_video_queue *queue,
+		struct v4l2_requestbuffers *rb, unsigned int buflength)
 {
-	int allocated;
+	int ret;
 
 	mutex_lock(&queue->mutex);
-	allocated = queue->count != 0;
+	ret = vb2_reqbufs(&queue->queue, rb);
 	mutex_unlock(&queue->mutex);
 
-	return allocated;
+	return ret ? ret : rb->count;
 }
 
-static void __uvc_query_buffer(struct uvc_buffer *buf,
-		struct v4l2_buffer *v4l2_buf)
+void uvc_free_buffers(struct uvc_video_queue *queue)
 {
-	memcpy(v4l2_buf, &buf->buf, sizeof *v4l2_buf);
-
-	if (buf->vma_use_count)
-		v4l2_buf->flags |= V4L2_BUF_FLAG_MAPPED;
-
-	switch (buf->state) {
-	case UVC_BUF_STATE_ERROR:
-	case UVC_BUF_STATE_DONE:
-		v4l2_buf->flags |= V4L2_BUF_FLAG_DONE;
-		break;
-	case UVC_BUF_STATE_QUEUED:
-	case UVC_BUF_STATE_ACTIVE:
-	case UVC_BUF_STATE_READY:
-		v4l2_buf->flags |= V4L2_BUF_FLAG_QUEUED;
-		break;
-	case UVC_BUF_STATE_IDLE:
-	default:
-		break;
-	}
+	vb2_queue_release(&queue->queue);
 }
 
-int uvc_query_buffer(struct uvc_video_queue *queue,
-		struct v4l2_buffer *v4l2_buf)
+int uvc_query_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 {
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&queue->mutex);
-	if (v4l2_buf->index >= queue->count) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	__uvc_query_buffer(&queue->buffer[v4l2_buf->index], v4l2_buf);
-
-done:
+	ret = vb2_querybuf(&queue->queue, buf);
 	mutex_unlock(&queue->mutex);
+
 	return ret;
 }
 
-/*
- * Queue a video buffer. Attempting to queue a buffer that has already been
- * queued will return -EINVAL.
- */
-int uvc_queue_buffer(struct uvc_video_queue *queue,
-	struct v4l2_buffer *v4l2_buf)
+int uvc_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 {
-	struct uvc_buffer *buf;
-	unsigned long flags;
-	int ret = 0;
-
-	uvc_trace(UVC_TRACE_CAPTURE, "Queuing buffer %u.\n", v4l2_buf->index);
-
-	if (v4l2_buf->type != queue->type ||
-	    v4l2_buf->memory != V4L2_MEMORY_MMAP) {
-		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer type (%u) "
-			"and/or memory (%u).\n", v4l2_buf->type,
-			v4l2_buf->memory);
-		return -EINVAL;
-	}
+	int ret;
 
+	uvc_printk(KERN_INFO, "-> qbuf\n");
 	mutex_lock(&queue->mutex);
-	if (v4l2_buf->index >= queue->count) {
-		uvc_trace(UVC_TRACE_CAPTURE, "[E] Out of range index.\n");
-		ret = -EINVAL;
-		goto done;
-	}
-
-	buf = &queue->buffer[v4l2_buf->index];
-	if (buf->state != UVC_BUF_STATE_IDLE) {
-		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer state "
-			"(%u).\n", buf->state);
-		ret = -EINVAL;
-		goto done;
-	}
-
-	if (v4l2_buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    v4l2_buf->bytesused > buf->buf.length) {
-		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
-		ret = -EINVAL;
-		goto done;
-	}
-
-	spin_lock_irqsave(&queue->irqlock, flags);
-	if (queue->flags & UVC_QUEUE_DISCONNECTED) {
-		spin_unlock_irqrestore(&queue->irqlock, flags);
-		ret = -ENODEV;
-		goto done;
-	}
-	buf->state = UVC_BUF_STATE_QUEUED;
-	if (v4l2_buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		buf->buf.bytesused = 0;
-	else
-		buf->buf.bytesused = v4l2_buf->bytesused;
-
-	list_add_tail(&buf->stream, &queue->mainqueue);
-	list_add_tail(&buf->queue, &queue->irqqueue);
-	spin_unlock_irqrestore(&queue->irqlock, flags);
-
-done:
+	ret = vb2_qbuf(&queue->queue, buf);
 	mutex_unlock(&queue->mutex);
-	return ret;
-}
-
-static int uvc_queue_waiton(struct uvc_buffer *buf, int nonblocking)
-{
-	if (nonblocking) {
-		return (buf->state != UVC_BUF_STATE_QUEUED &&
-			buf->state != UVC_BUF_STATE_ACTIVE &&
-			buf->state != UVC_BUF_STATE_READY)
-			? 0 : -EAGAIN;
-	}
+	uvc_printk(KERN_INFO, "<- qbuf %d\n", ret);
 
-	return wait_event_interruptible(buf->wait,
-		buf->state != UVC_BUF_STATE_QUEUED &&
-		buf->state != UVC_BUF_STATE_ACTIVE &&
-		buf->state != UVC_BUF_STATE_READY);
+	return ret;
 }
 
-/*
- * Dequeue a video buffer. If nonblocking is false, block until a buffer is
- * available.
- */
-int uvc_dequeue_buffer(struct uvc_video_queue *queue,
-		struct v4l2_buffer *v4l2_buf, int nonblocking)
+int uvc_dequeue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf,
+		       int nonblocking)
 {
-	struct uvc_buffer *buf;
-	int ret = 0;
-
-	if (v4l2_buf->type != queue->type ||
-	    v4l2_buf->memory != V4L2_MEMORY_MMAP) {
-		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer type (%u) "
-			"and/or memory (%u).\n", v4l2_buf->type,
-			v4l2_buf->memory);
-		return -EINVAL;
-	}
+	int ret;
 
+	uvc_printk(KERN_INFO, "-> dqbuf\n");
 	mutex_lock(&queue->mutex);
-	if (list_empty(&queue->mainqueue)) {
-		uvc_trace(UVC_TRACE_CAPTURE, "[E] Empty buffer queue.\n");
-		ret = -EINVAL;
-		goto done;
-	}
-
-	buf = list_first_entry(&queue->mainqueue, struct uvc_buffer, stream);
-	if ((ret = uvc_queue_waiton(buf, nonblocking)) < 0)
-		goto done;
-
-	uvc_trace(UVC_TRACE_CAPTURE, "Dequeuing buffer %u (%u, %u bytes).\n",
-		buf->buf.index, buf->state, buf->buf.bytesused);
-
-	switch (buf->state) {
-	case UVC_BUF_STATE_ERROR:
-		uvc_trace(UVC_TRACE_CAPTURE, "[W] Corrupted data "
-			"(transmission error).\n");
-		ret = -EIO;
-	case UVC_BUF_STATE_DONE:
-		buf->state = UVC_BUF_STATE_IDLE;
-		break;
-
-	case UVC_BUF_STATE_IDLE:
-	case UVC_BUF_STATE_QUEUED:
-	case UVC_BUF_STATE_ACTIVE:
-	case UVC_BUF_STATE_READY:
-	default:
-		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer state %u "
-			"(driver bug?).\n", buf->state);
-		ret = -EINVAL;
-		goto done;
-	}
-
-	list_del(&buf->stream);
-	__uvc_query_buffer(buf, v4l2_buf);
-
-done:
+	ret = vb2_dqbuf(&queue->queue, buf, nonblocking);
 	mutex_unlock(&queue->mutex);
-	return ret;
-}
-
-/*
- * VMA operations.
- */
-static void uvc_vm_open(struct vm_area_struct *vma)
-{
-	struct uvc_buffer *buffer = vma->vm_private_data;
-	buffer->vma_use_count++;
-}
+	uvc_printk(KERN_INFO, "<- dqbuf %d (flags %u)\n", ret, buf->flags);
 
-static void uvc_vm_close(struct vm_area_struct *vma)
-{
-	struct uvc_buffer *buffer = vma->vm_private_data;
-	buffer->vma_use_count--;
+	return ret;
 }
 
-static const struct vm_operations_struct uvc_vm_ops = {
-	.open		= uvc_vm_open,
-	.close		= uvc_vm_close,
-};
-
-/*
- * Memory-map a video buffer.
- *
- * This function implements video buffers memory mapping and is intended to be
- * used by the device mmap handler.
- */
 int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 {
-	struct uvc_buffer *uninitialized_var(buffer);
-	struct page *page;
-	unsigned long addr, start, size;
-	unsigned int i;
-	int ret = 0;
-
-	start = vma->vm_start;
-	size = vma->vm_end - vma->vm_start;
+	int ret;
 
 	mutex_lock(&queue->mutex);
+	ret = vb2_mmap(&queue->queue, vma);
+	mutex_unlock(&queue->mutex);
 
-	for (i = 0; i < queue->count; ++i) {
-		buffer = &queue->buffer[i];
-		if ((buffer->buf.m.offset >> PAGE_SHIFT) == vma->vm_pgoff)
-			break;
-	}
-
-	if (i == queue->count || size != queue->buf_size) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	/*
-	 * VM_IO marks the area as being an mmaped region for I/O to a
-	 * device. It also prevents the region from being core dumped.
-	 */
-	vma->vm_flags |= VM_IO;
-
-	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
-	while (size > 0) {
-		page = vmalloc_to_page((void *)addr);
-		if ((ret = vm_insert_page(vma, start, page)) < 0)
-			goto done;
-
-		start += PAGE_SIZE;
-		addr += PAGE_SIZE;
-		size -= PAGE_SIZE;
-	}
+	return ret;
+}
 
-	vma->vm_ops = &uvc_vm_ops;
-	vma->vm_private_data = buffer;
-	uvc_vm_open(vma);
+unsigned int uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
+			    poll_table *wait)
+{
+	unsigned int ret;
 
-done:
+	uvc_printk(KERN_INFO, "-> poll\n");
+	mutex_lock(&queue->mutex);
+	ret = vb2_poll(&queue->queue, file, wait);
 	mutex_unlock(&queue->mutex);
+	uvc_printk(KERN_INFO, "<- poll %d\n", ret);
+
 	return ret;
 }
 
-/*
- * Poll the video queue.
+/* -----------------------------------------------------------------------------
  *
- * This function implements video queue polling and is intended to be used by
- * the device poll handler.
  */
-unsigned int uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
-		poll_table *wait)
+
+/*
+ * Check if buffers have been allocated.
+ */
+int uvc_queue_allocated(struct uvc_video_queue *queue)
 {
-	struct uvc_buffer *buf;
-	unsigned int mask = 0;
+	int allocated;
 
 	mutex_lock(&queue->mutex);
-	if (list_empty(&queue->mainqueue)) {
-		mask |= POLLERR;
-		goto done;
-	}
-	buf = list_first_entry(&queue->mainqueue, struct uvc_buffer, stream);
-
-	poll_wait(file, &buf->wait, wait);
-	if (buf->state == UVC_BUF_STATE_DONE ||
-	    buf->state == UVC_BUF_STATE_ERROR) {
-		if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-			mask |= POLLIN | POLLRDNORM;
-		else
-			mask |= POLLOUT | POLLWRNORM;
-	}
-
-done:
+	allocated = vb2_is_busy(&queue->queue);
 	mutex_unlock(&queue->mutex);
-	return mask;
+
+	return allocated;
 }
 
 /*
@@ -505,27 +284,24 @@ done:
  */
 int uvc_queue_enable(struct uvc_video_queue *queue, int enable)
 {
-	unsigned int i;
-	int ret = 0;
+	unsigned long flags;
+	int ret;
 
 	mutex_lock(&queue->mutex);
 	if (enable) {
-		if (uvc_queue_streaming(queue)) {
-			ret = -EBUSY;
+		ret = vb2_streamon(&queue->queue, queue->queue.type);
+		if (ret < 0)
 			goto done;
-		}
-		queue->flags |= UVC_QUEUE_STREAMING;
+
 		queue->buf_used = 0;
 	} else {
-		uvc_queue_cancel(queue, 0);
-		INIT_LIST_HEAD(&queue->mainqueue);
-
-		for (i = 0; i < queue->count; ++i) {
-			queue->buffer[i].error = 0;
-			queue->buffer[i].state = UVC_BUF_STATE_IDLE;
-		}
+		ret = vb2_streamoff(&queue->queue, queue->queue.type);
+		if (ret < 0)
+			goto done;
 
-		queue->flags &= ~UVC_QUEUE_STREAMING;
+		spin_lock_irqsave(&queue->irqlock, flags);
+		INIT_LIST_HEAD(&queue->irqqueue);
+		spin_unlock_irqrestore(&queue->irqlock, flags);
 	}
 
 done:
@@ -556,7 +332,7 @@ void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 				       queue);
 		list_del(&buf->queue);
 		buf->state = UVC_BUF_STATE_ERROR;
-		wake_up(&buf->wait);
+		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
 	}
 	/* This must be protected by the irqlock spinlock to avoid race
 	 * conditions between uvc_queue_buffer and the disconnection event that
@@ -564,8 +340,10 @@ void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 	 * blindly replace this logic by checking for the UVC_DEV_DISCONNECTED
 	 * state outside the queue code.
 	 */
-	if (disconnect)
+	if (disconnect) {
+		uvc_printk(KERN_INFO, "disconnected\n");
 		queue->flags |= UVC_QUEUE_DISCONNECTED;
+	}
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
@@ -578,14 +356,12 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 	if ((queue->flags & UVC_QUEUE_DROP_CORRUPTED) && buf->error) {
 		buf->error = 0;
 		buf->state = UVC_BUF_STATE_QUEUED;
-		buf->buf.bytesused = 0;
+		vb2_set_plane_payload(&buf->buf, 0, 0);
 		return buf;
 	}
 
 	spin_lock_irqsave(&queue->irqlock, flags);
 	list_del(&buf->queue);
-	buf->error = 0;
-	buf->state = UVC_BUF_STATE_DONE;
 	if (!list_empty(&queue->irqqueue))
 		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
 					   queue);
@@ -593,7 +369,9 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		nextbuf = NULL;
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
-	wake_up(&buf->wait);
+	buf->state = buf->error ? VB2_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
+	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
+	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
+
 	return nextbuf;
 }
-
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index fa89ebf..428e577 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -519,10 +519,7 @@ static int uvc_v4l2_release(struct file *file)
 	/* Only free resources if this is a privileged handle. */
 	if (uvc_has_privileges(handle)) {
 		uvc_video_enable(stream, 0);
-
-		if (uvc_free_buffers(&stream->queue) < 0)
-			uvc_printk(KERN_ERR, "uvc_v4l2_release: Unable to "
-					"free buffers.\n");
+		uvc_free_buffers(&stream->queue);
 	}
 
 	/* Release the file handle. */
@@ -934,18 +931,11 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	/* Buffers & streaming */
 	case VIDIOC_REQBUFS:
-	{
-		struct v4l2_requestbuffers *rb = arg;
-
-		if (rb->type != stream->type ||
-		    rb->memory != V4L2_MEMORY_MMAP)
-			return -EINVAL;
-
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
 		mutex_lock(&stream->mutex);
-		ret = uvc_alloc_buffers(&stream->queue, rb->count,
+		ret = uvc_alloc_buffers(&stream->queue, arg,
 					stream->ctrl.dwMaxVideoFrameSize);
 		mutex_unlock(&stream->mutex);
 		if (ret < 0)
@@ -954,18 +944,13 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (ret == 0)
 			uvc_dismiss_privileges(handle);
 
-		rb->count = ret;
 		ret = 0;
 		break;
-	}
 
 	case VIDIOC_QUERYBUF:
 	{
 		struct v4l2_buffer *buf = arg;
 
-		if (buf->type != stream->type)
-			return -EINVAL;
-
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 0ea7adf..316f6c8 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -466,9 +466,10 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		else
 			ktime_get_real_ts(&ts);
 
-		buf->buf.sequence = stream->sequence;
-		buf->buf.timestamp.tv_sec = ts.tv_sec;
-		buf->buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+		buf->buf.v4l2_buf.sequence = stream->sequence;
+		buf->buf.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
+		buf->buf.v4l2_buf.timestamp.tv_usec =
+			ts.tv_nsec / NSEC_PER_USEC;
 
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
@@ -489,7 +490,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	 * avoids detecting end of frame conditions at FID toggling if the
 	 * previous payload had the EOF bit set.
 	 */
-	if (fid != stream->last_fid && buf->buf.bytesused != 0) {
+	if (fid != stream->last_fid && buf->bytesused != 0) {
 		uvc_trace(UVC_TRACE_FRAME, "Frame complete (FID bit "
 				"toggled).\n");
 		buf->state = UVC_BUF_STATE_READY;
@@ -504,7 +505,6 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 static void uvc_video_decode_data(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, const __u8 *data, int len)
 {
-	struct uvc_video_queue *queue = &stream->queue;
 	unsigned int maxlen, nbytes;
 	void *mem;
 
@@ -512,11 +512,11 @@ static void uvc_video_decode_data(struct uvc_streaming *stream,
 		return;
 
 	/* Copy the video data to the buffer. */
-	maxlen = buf->buf.length - buf->buf.bytesused;
-	mem = queue->mem + buf->buf.m.offset + buf->buf.bytesused;
+	maxlen = buf->length - buf->bytesused;
+	mem = buf->mem + buf->bytesused;
 	nbytes = min((unsigned int)len, maxlen);
 	memcpy(mem, data, nbytes);
-	buf->buf.bytesused += nbytes;
+	buf->bytesused += nbytes;
 
 	/* Complete the current frame if the buffer size was exceeded. */
 	if (len > maxlen) {
@@ -529,7 +529,7 @@ static void uvc_video_decode_end(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, const __u8 *data, int len)
 {
 	/* Mark the buffer as done if the EOF marker is set. */
-	if (data[1] & UVC_STREAM_EOF && buf->buf.bytesused != 0) {
+	if (data[1] & UVC_STREAM_EOF && buf->bytesused != 0) {
 		uvc_trace(UVC_TRACE_FRAME, "Frame complete (EOF found).\n");
 		if (data[0] == len)
 			uvc_trace(UVC_TRACE_FRAME, "EOF in empty payload.\n");
@@ -567,8 +567,8 @@ static int uvc_video_encode_data(struct uvc_streaming *stream,
 	void *mem;
 
 	/* Copy video data to the URB buffer. */
-	mem = queue->mem + buf->buf.m.offset + queue->buf_used;
-	nbytes = min((unsigned int)len, buf->buf.bytesused - queue->buf_used);
+	mem = buf->mem + queue->buf_used;
+	nbytes = min((unsigned int)len, buf->bytesused - queue->buf_used);
 	nbytes = min(stream->bulk.max_payload_size - stream->bulk.payload_size,
 			nbytes);
 	memcpy(data, mem, nbytes);
@@ -623,7 +623,7 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 			urb->iso_frame_desc[i].actual_length);
 
 		if (buf->state == UVC_BUF_STATE_READY) {
-			if (buf->buf.length != buf->buf.bytesused &&
+			if (buf->length != buf->bytesused &&
 			    !(stream->cur_format->flags &
 			      UVC_FMT_FLAG_COMPRESSED))
 				buf->error = 1;
@@ -723,12 +723,12 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	stream->bulk.payload_size += ret;
 	len -= ret;
 
-	if (buf->buf.bytesused == stream->queue.buf_used ||
+	if (buf->bytesused == stream->queue.buf_used ||
 	    stream->bulk.payload_size == stream->bulk.max_payload_size) {
-		if (buf->buf.bytesused == stream->queue.buf_used) {
+		if (buf->bytesused == stream->queue.buf_used) {
 			stream->queue.buf_used = 0;
 			buf->state = UVC_BUF_STATE_READY;
-			buf->buf.sequence = ++stream->sequence;
+			buf->buf.v4l2_buf.sequence = ++stream->sequence;
 			uvc_queue_next_buffer(&stream->queue, buf);
 			stream->last_fid ^= UVC_STREAM_FID;
 		}
diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
index 5b79194..08bb61b 100644
--- a/drivers/usb/gadget/uvc.h
+++ b/drivers/usb/gadget/uvc.h
@@ -29,7 +29,7 @@
 
 struct uvc_request_data
 {
-	unsigned int length;
+	int length;
 	__u8 data[60];
 };
 
diff --git a/include/linux/uvcvideo.h b/include/linux/uvcvideo.h
index 4b53343..d4b0756 100644
--- a/include/linux/uvcvideo.h
+++ b/include/linux/uvcvideo.h
@@ -93,6 +93,7 @@ struct uvc_xu_control_query {
 
 #include <linux/poll.h>
 #include <linux/usb/video.h>
+#include <media/videobuf2-core.h>
 
 /* --------------------------------------------------------------------------
  * UVC constants
@@ -383,35 +384,28 @@ enum uvc_buffer_state {
 };
 
 struct uvc_buffer {
-	unsigned long vma_use_count;
-	struct list_head stream;
-
-	/* Touched by interrupt handler. */
-	struct v4l2_buffer buf;
+	struct vb2_buffer buf;
 	struct list_head queue;
-	wait_queue_head_t wait;
+
 	enum uvc_buffer_state state;
 	unsigned int error;
+
+	void *mem;
+	unsigned int length;
+	unsigned int bytesused;
 };
 
-#define UVC_QUEUE_STREAMING		(1 << 0)
-#define UVC_QUEUE_DISCONNECTED		(1 << 1)
-#define UVC_QUEUE_DROP_CORRUPTED	(1 << 2)
+#define UVC_QUEUE_DISCONNECTED		(1 << 0)
+#define UVC_QUEUE_DROP_CORRUPTED	(1 << 1)
 
 struct uvc_video_queue {
-	enum v4l2_buf_type type;
+	struct vb2_queue queue;
+	struct mutex mutex;			/* Protects queue */
 
-	void *mem;
 	unsigned int flags;
-
-	unsigned int count;
-	unsigned int buf_size;
 	unsigned int buf_used;
-	struct uvc_buffer buffer[UVC_MAX_VIDEO_BUFFERS];
-	struct mutex mutex;	/* protects buffers and mainqueue */
-	spinlock_t irqlock;	/* protects irqqueue */
 
-	struct list_head mainqueue;
+	spinlock_t irqlock;			/* Protects irqqueue */
 	struct list_head irqqueue;
 };
 
@@ -451,6 +445,7 @@ struct uvc_streaming {
 	 */
 	struct mutex mutex;
 
+	/* Buffers queue. */
 	unsigned int frozen:1;
 	struct uvc_video_queue queue;
 	void (*decode) (struct urb *urb, struct uvc_streaming *video,
@@ -574,8 +569,8 @@ extern struct uvc_driver uvc_driver;
 extern void uvc_queue_init(struct uvc_video_queue *queue,
 		enum v4l2_buf_type type, int drop_corrupted);
 extern int uvc_alloc_buffers(struct uvc_video_queue *queue,
-		unsigned int nbuffers, unsigned int buflength);
-extern int uvc_free_buffers(struct uvc_video_queue *queue);
+		struct v4l2_requestbuffers *rb, unsigned int buflength);
+extern void uvc_free_buffers(struct uvc_video_queue *queue);
 extern int uvc_query_buffer(struct uvc_video_queue *queue,
 		struct v4l2_buffer *v4l2_buf);
 extern int uvc_queue_buffer(struct uvc_video_queue *queue,
@@ -593,7 +588,7 @@ extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
 extern int uvc_queue_allocated(struct uvc_video_queue *queue);
 static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
 {
-	return queue->flags & UVC_QUEUE_STREAMING;
+	return vb2_is_streaming(&queue->queue);
 }
 
 /* V4L2 interface */
-- 
1.7.3.4

