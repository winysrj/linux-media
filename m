Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47233 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826Ab1JXPlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 11:41:35 -0400
Received: from localhost.localdomain (unknown [85.13.70.251])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 52F5435B77
	for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 15:41:33 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] uvcvideo: Use videobuf2-vmalloc
Date: Mon, 24 Oct 2011 17:42:04 +0200
Message-Id: <1319470924-15703-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1319470924-15703-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1319470924-15703-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the current video buffers queue implementation with
videobuf2-vmalloc.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/Kconfig     |    1 +
 drivers/media/video/uvc/uvc_queue.c |  556 +++++++++--------------------------
 drivers/media/video/uvc/uvc_v4l2.c  |   19 +-
 drivers/media/video/uvc/uvc_video.c |    9 +-
 drivers/media/video/uvc/uvcvideo.h  |   33 +--
 5 files changed, 161 insertions(+), 457 deletions(-)

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
diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index 0fbb04b..a5122a1 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/list.h>
@@ -19,7 +20,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <linux/atomic.h>
+#include <media/videobuf2-vmalloc.h>
 
 #include "uvcvideo.h"
 
@@ -29,470 +30,199 @@
  * Video queues is initialized by uvc_queue_init(). The function performs
  * basic initialization of the uvc_video_queue struct and never fails.
  *
- * Video buffer allocation and freeing are performed by uvc_alloc_buffers and
- * uvc_free_buffers respectively. The former acquires the video queue lock,
- * while the later must be called with the lock held (so that allocation can
- * free previously allocated buffers). Trying to free buffers that are mapped
- * to user space will return -EBUSY.
- *
- * Video buffers are managed using two queues. However, unlike most USB video
- * drivers that use an in queue and an out queue, we use a main queue to hold
- * all queued buffers (both 'empty' and 'done' buffers), and an irq queue to
- * hold empty buffers. This design (copied from video-buf) minimizes locking
- * in interrupt, as only one queue is shared between interrupt and user
- * contexts.
- *
- * Use cases
- * ---------
- *
- * Unless stated otherwise, all operations that modify the irq buffers queue
- * are protected by the irq spinlock.
- *
- * 1. The user queues the buffers, starts streaming and dequeues a buffer.
- *
- *    The buffers are added to the main and irq queues. Both operations are
- *    protected by the queue lock, and the later is protected by the irq
- *    spinlock as well.
- *
- *    The completion handler fetches a buffer from the irq queue and fills it
- *    with video data. If no buffer is available (irq queue empty), the handler
- *    returns immediately.
- *
- *    When the buffer is full, the completion handler removes it from the irq
- *    queue, marks it as done (UVC_BUF_STATE_DONE) and wakes its wait queue.
- *    At that point, any process waiting on the buffer will be woken up. If a
- *    process tries to dequeue a buffer after it has been marked done, the
- *    dequeing will succeed immediately.
- *
- * 2. Buffers are queued, user is waiting on a buffer and the device gets
- *    disconnected.
- *
- *    When the device is disconnected, the kernel calls the completion handler
- *    with an appropriate status code. The handler marks all buffers in the
- *    irq queue as being erroneous (UVC_BUF_STATE_ERROR) and wakes them up so
- *    that any process waiting on a buffer gets woken up.
- *
- *    Waking up up the first buffer on the irq list is not enough, as the
- *    process waiting on the buffer might restart the dequeue operation
- *    immediately.
- *
+ * Video buffers are managed by videobuf2. The driver uses a mutex to protect
+ * the videobuf2 queue operations by serializing calls to videobuf2 and a
+ * spinlock to protect the IRQ queue that holds the buffers to be processed by
+ * the driver.
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
+			   unsigned int *nplanes, unsigned int sizes[],
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
-		uvc_queue_cancel(queue, 0);
-		INIT_LIST_HEAD(&queue->mainqueue);
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
-
-	mutex_lock(&queue->mutex);
-	ret = __uvc_free_buffers(queue);
-	mutex_unlock(&queue->mutex);
-
-	return ret;
-}
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 
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
-{
-	unsigned int bufsize = PAGE_ALIGN(buflength);
-	unsigned int i;
-	void *mem = NULL;
-	int ret;
+	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
+		return -EINVAL;
+	}
 
-	if (nbuffers > UVC_MAX_VIDEO_BUFFERS)
-		nbuffers = UVC_MAX_VIDEO_BUFFERS;
+	if (unlikely(queue->flags & UVC_QUEUE_DISCONNECTED))
+		return -ENODEV;
 
-	mutex_lock(&queue->mutex);
+	buf->state = UVC_BUF_STATE_QUEUED;
+	buf->error = 0;
+	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->length = vb2_plane_size(vb, 0);
+	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		buf->bytesused = 0;
+	else
+		buf->bytesused = vb2_get_plane_payload(vb, 0);
 
-	if ((ret = __uvc_free_buffers(queue)) < 0)
-		goto done;
+	return 0;
+}
 
-	/* Bail out if no buffers should be allocated. */
-	if (nbuffers == 0)
-		goto done;
+static void uvc_buffer_queue(struct vb2_buffer *vb)
+{
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	unsigned long flags;
 
-	/* Decrement the number of buffers until allocation succeeds. */
-	for (; nbuffers > 0; --nbuffers) {
-		mem = vmalloc_32(nbuffers * bufsize);
-		if (mem != NULL)
-			break;
+	spin_lock_irqsave(&queue->irqlock, flags);
+	if (likely(!(queue->flags & UVC_QUEUE_DISCONNECTED))) {
+		list_add_tail(&buf->queue, &queue->irqqueue);
+	} else {
+		/* If the device is disconnected return the buffer to userspace
+		 * directly. The next QBUF call will fail with -ENODEV.
+		 */
+		buf->state = UVC_BUF_STATE_ERROR;
+		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
 	}
 
-	if (mem == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	spin_unlock_irqrestore(&queue->irqlock, flags);
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
-
-		queue->buffer[i].mem = queue->mem + i * bufsize;
-		queue->buffer[i].length = buflength;
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
+	mutex_lock(&queue->mutex);
+	vb2_queue_release(&queue->queue);
+	mutex_unlock(&queue->mutex);
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
-		buf->bytesused = 0;
-	else
-		buf->bytesused = v4l2_buf->bytesused;
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
 
-static int uvc_queue_waiton(struct uvc_buffer *buf, int nonblocking)
-{
-	if (nonblocking) {
-		return (buf->state != UVC_BUF_STATE_QUEUED &&
-			buf->state != UVC_BUF_STATE_ACTIVE &&
-			buf->state != UVC_BUF_STATE_READY)
-			? 0 : -EAGAIN;
-	}
-
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
 
-/*
- * VMA operations.
- */
-static void uvc_vm_open(struct vm_area_struct *vma)
-{
-	struct uvc_buffer *buffer = vma->vm_private_data;
-	buffer->vma_use_count++;
-}
-
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
-	if (i == queue->count || PAGE_ALIGN(size) != queue->buf_size) {
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
-	addr = (unsigned long)buffer->mem;
-#ifdef CONFIG_MMU
-	while (size > 0) {
-		page = vmalloc_to_page((void *)addr);
-		if ((ret = vm_insert_page(vma, start, page)) < 0)
-			goto done;
-
-		start += PAGE_SIZE;
-		addr += PAGE_SIZE;
-		size -= PAGE_SIZE;
-	}
-#endif
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
+	mutex_lock(&queue->mutex);
+	ret = vb2_poll(&queue->queue, file, wait);
 	mutex_unlock(&queue->mutex);
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
 
 #ifndef CONFIG_MMU
@@ -543,27 +273,24 @@ done:
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
@@ -594,12 +321,12 @@ void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 				       queue);
 		list_del(&buf->queue);
 		buf->state = UVC_BUF_STATE_ERROR;
-		wake_up(&buf->wait);
+		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
 	}
 	/* This must be protected by the irqlock spinlock to avoid race
-	 * conditions between uvc_queue_buffer and the disconnection event that
+	 * conditions between uvc_buffer_queue and the disconnection event that
 	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not
-	 * blindly replace this logic by checking for the UVC_DEV_DISCONNECTED
+	 * blindly replace this logic by checking for the UVC_QUEUE_DISCONNECTED
 	 * state outside the queue code.
 	 */
 	if (disconnect)
@@ -616,15 +343,12 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
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
-	buf->buf.bytesused = buf->bytesused;
 	if (!list_empty(&queue->irqqueue))
 		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
 					   queue);
@@ -632,7 +356,9 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
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
index dadf11f..9d57fbb 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -513,10 +513,7 @@ static int uvc_v4l2_release(struct file *file)
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
@@ -914,18 +911,11 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
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
@@ -934,18 +924,13 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
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
index 00fe749..2995f26 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -467,9 +467,10 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
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
@@ -728,7 +729,7 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
 		if (buf->bytesused == stream->queue.buf_used) {
 			stream->queue.buf_used = 0;
 			buf->state = UVC_BUF_STATE_READY;
-			buf->buf.sequence = ++stream->sequence;
+			buf->buf.v4l2_buf.sequence = ++stream->sequence;
 			uvc_queue_next_buffer(&stream->queue, buf);
 			stream->last_fid ^= UVC_STREAM_FID;
 		}
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 55f9171..842682d 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -13,6 +13,7 @@
 #include <linux/videodev2.h>
 #include <media/media-device.h>
 #include <media/v4l2-device.h>
+#include <media/videobuf2-core.h>
 
 /* --------------------------------------------------------------------------
  * UVC constants
@@ -319,13 +320,9 @@ enum uvc_buffer_state {
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
 
@@ -334,24 +331,17 @@ struct uvc_buffer {
 	unsigned int bytesused;
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
 
@@ -391,6 +381,7 @@ struct uvc_streaming {
 	 */
 	struct mutex mutex;
 
+	/* Buffers queue. */
 	unsigned int frozen : 1;
 	struct uvc_video_queue queue;
 	void (*decode) (struct urb *urb, struct uvc_streaming *video,
@@ -520,8 +511,8 @@ extern struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
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
@@ -543,7 +534,7 @@ extern unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
 extern int uvc_queue_allocated(struct uvc_video_queue *queue);
 static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
 {
-	return queue->flags & UVC_QUEUE_STREAMING;
+	return vb2_is_streaming(&queue->queue);
 }
 
 /* V4L2 interface */
-- 
1.7.3.4

