Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:33815 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759324Ab2FAJjg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jun 2012 05:39:36 -0400
From: Bhupesh Sharma <bhupesh.sharma@st.com>
To: <laurent.pinchart@ideasonboard.com>, <linux-usb@vger.kernel.org>
Cc: <balbi@ti.com>, <linux-media@vger.kernel.org>,
	<gregkh@linuxfoundation.org>,
	Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework
Date: Fri, 1 Jun 2012 15:08:57 +0530
Message-ID: <243660e539dcccd868c641188faef26d83c2b894.1338543124.git.bhupesh.sharma@st.com>
In-Reply-To: <cover.1338543124.git.bhupesh.sharma@st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch reworks the videobuffer management logic present in the UVC
webcam gadget and ports it to use the "more apt" videobuf2 framework for
video buffer management.

To support routing video data captured from a real V4L2 video capture
device with a "zero copy" operation on videobuffers (as they pass from the V4L2
domain to UVC domain via a user-space application), we need to support USER_PTR
IO method at the UVC gadget side.

So the V4L2 capture device driver can still continue to use MMAO IO method
and now the user-space application can just pass a pointer to the video buffers
being DeQueued from the V4L2 device side while Queueing them at the UVC gadget
end. This ensures that we have a "zero-copy" design as the videobuffers pass
from the V4L2 capture device to the UVC gadget.

Note that there will still be a need to apply UVC specific payload headers
on top of each UVC payload data, which will still require a copy operation
to be performed in the 'encode' routines of the UVC gadget.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
---
 drivers/usb/gadget/Kconfig     |    1 +
 drivers/usb/gadget/uvc_queue.c |  524 +++++++++++-----------------------------
 drivers/usb/gadget/uvc_queue.h |   25 +--
 drivers/usb/gadget/uvc_v4l2.c  |   35 ++--
 drivers/usb/gadget/uvc_video.c |   17 +-
 5 files changed, 184 insertions(+), 418 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 1f93861..5a351f8 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -967,6 +967,7 @@ endif
 config USB_G_WEBCAM
 	tristate "USB Webcam Gadget"
 	depends on VIDEO_DEV
+	select VIDEOBUF2_VMALLOC
 	help
 	  The Webcam Gadget acts as a composite USB Audio and Video Class
 	  device. It provides a userspace API to process UVC control requests
diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index 0cdf89d..907ece8 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -10,6 +10,7 @@
  *	(at your option) any later version.
  */
 
+#include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/list.h>
@@ -18,7 +19,8 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <linux/atomic.h>
+
+#include <media/videobuf2-vmalloc.h>
 
 #include "uvc.h"
 
@@ -28,271 +30,156 @@
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
- *    queue, marks it as ready (UVC_BUF_STATE_DONE) and wakes its wait queue.
- *    At that point, any process waiting on the buffer will be woken up. If a
- *    process tries to dequeue a buffer after it has been marked ready, the
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
 
-static void
-uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type)
-{
-	mutex_init(&queue->mutex);
-	spin_lock_init(&queue->irqlock);
-	INIT_LIST_HEAD(&queue->mainqueue);
-	INIT_LIST_HEAD(&queue->irqqueue);
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
-static int uvc_free_buffers(struct uvc_video_queue *queue)
+
+static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
 {
-	unsigned int i;
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
+	struct uvc_video *video =
+			container_of(queue, struct uvc_video, queue);
 
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
+	sizes[0] = video->imagesize;
 
 	return 0;
 }
 
-/*
- * Allocate the video buffers.
- *
- * Pages are reserved to make sure they will not be swapped, as they will be
- * filled in the URB completion handler.
- *
- * Buffers will be individually mapped, so they must all be page aligned.
- */
-static int
-uvc_alloc_buffers(struct uvc_video_queue *queue, unsigned int nbuffers,
-		  unsigned int buflength)
+static int uvc_buffer_prepare(struct vb2_buffer *vb)
 {
-	unsigned int bufsize = PAGE_ALIGN(buflength);
-	unsigned int i;
-	void *mem = NULL;
-	int ret;
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 
-	if (nbuffers > UVC_MAX_VIDEO_BUFFERS)
-		nbuffers = UVC_MAX_VIDEO_BUFFERS;
+	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+			vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
+		return -EINVAL;
+	}
 
-	mutex_lock(&queue->mutex);
+	if (unlikely(queue->flags & UVC_QUEUE_DISCONNECTED))
+		return -ENODEV;
 
-	if ((ret = uvc_free_buffers(queue)) < 0)
-		goto done;
+	buf->state = UVC_BUF_STATE_QUEUED;
+	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->length = vb2_plane_size(vb, 0);
+	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		buf->bytesused = 0;
+	else
+		buf->bytesused = vb2_get_plane_payload(vb, 0);
 
-	/* Bail out if no buffers should be allocated. */
-	if (nbuffers == 0)
-		goto done;
+	return 0;
+}
 
-	/* Decrement the number of buffers until allocation succeeds. */
-	for (; nbuffers > 0; --nbuffers) {
-		mem = vmalloc_32(nbuffers * bufsize);
-		if (mem != NULL)
-			break;
-	}
+static void uvc_buffer_queue(struct vb2_buffer *vb)
+{
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	unsigned long flags;
 
-	if (mem == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	spin_lock_irqsave(&queue->irqlock, flags);
 
-	for (i = 0; i < nbuffers; ++i) {
-		memset(&queue->buffer[i], 0, sizeof queue->buffer[i]);
-		queue->buffer[i].buf.index = i;
-		queue->buffer[i].buf.m.offset = i * bufsize;
-		queue->buffer[i].buf.length = buflength;
-		queue->buffer[i].buf.type = queue->type;
-		queue->buffer[i].buf.sequence = 0;
-		queue->buffer[i].buf.field = V4L2_FIELD_NONE;
-		queue->buffer[i].buf.memory = V4L2_MEMORY_MMAP;
-		queue->buffer[i].buf.flags = 0;
-		init_waitqueue_head(&queue->buffer[i].wait);
+	if (likely(!(queue->flags & UVC_QUEUE_DISCONNECTED))) {
+		list_add_tail(&buf->queue, &queue->irqqueue);
+	} else {
+		/* If the device is disconnected return the buffer to userspace
+		 * directly. The next QBUF call will fail with -ENODEV.
+		 */
+		buf->state = UVC_BUF_STATE_ERROR;
+		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
 	}
 
-	queue->mem = mem;
-	queue->count = nbuffers;
-	queue->buf_size = bufsize;
-	ret = nbuffers;
-
-done:
-	mutex_unlock(&queue->mutex);
-	return ret;
+	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
-static void __uvc_query_buffer(struct uvc_buffer *buf,
-		struct v4l2_buffer *v4l2_buf)
+static struct vb2_ops uvc_queue_qops = {
+	.queue_setup = uvc_queue_setup,
+	.buf_prepare = uvc_buffer_prepare,
+	.buf_queue = uvc_buffer_queue,
+};
+
+static
+void uvc_queue_init(struct uvc_video_queue *queue,
+				enum v4l2_buf_type type)
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
-		v4l2_buf->flags |= V4L2_BUF_FLAG_QUEUED;
-		break;
-	case UVC_BUF_STATE_IDLE:
-	default:
-		break;
-	}
+	mutex_init(&queue->mutex);
+	spin_lock_init(&queue->irqlock);
+	INIT_LIST_HEAD(&queue->irqqueue);
+	queue->queue.type = type;
+	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
+	queue->queue.drv_priv = queue;
+	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
+	queue->queue.ops = &uvc_queue_qops;
+	queue->queue.mem_ops = &vb2_vmalloc_memops;
+	vb2_queue_init(&queue->queue);
 }
 
-static int
-uvc_query_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *v4l2_buf)
+/*
+ * Free the video buffers.
+ */
+static void uvc_free_buffers(struct uvc_video_queue *queue)
 {
-	int ret = 0;
-
 	mutex_lock(&queue->mutex);
-	if (v4l2_buf->index >= queue->count) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	__uvc_query_buffer(&queue->buffer[v4l2_buf->index], v4l2_buf);
-
-done:
+	vb2_queue_release(&queue->queue);
 	mutex_unlock(&queue->mutex);
-	return ret;
 }
 
 /*
- * Queue a video buffer. Attempting to queue a buffer that has already been
- * queued will return -EINVAL.
+ * Allocate the video buffers.
  */
-static int
-uvc_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *v4l2_buf)
+static int uvc_alloc_buffers(struct uvc_video_queue *queue,
+				struct v4l2_requestbuffers *rb)
 {
-	struct uvc_buffer *buf;
-	unsigned long flags;
-	int ret = 0;
-
-	uvc_trace(UVC_TRACE_CAPTURE, "Queuing buffer %u.\n", v4l2_buf->index);
+	int ret;
 
-	if (v4l2_buf->type != queue->type ||
-	    v4l2_buf->memory != V4L2_MEMORY_MMAP) {
-		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer type (%u) "
-			"and/or memory (%u).\n", v4l2_buf->type,
-			v4l2_buf->memory);
-		return -EINVAL;
-	}
+	/*
+	 * we can support a max of UVC_MAX_VIDEO_BUFFERS video buffers
+	 */
+	if (rb->count > UVC_MAX_VIDEO_BUFFERS)
+		rb->count = UVC_MAX_VIDEO_BUFFERS;
 
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
-	if (v4l2_buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		buf->buf.bytesused = 0;
-	else
-		buf->buf.bytesused = v4l2_buf->bytesused;
-
-	spin_lock_irqsave(&queue->irqlock, flags);
-	if (queue->flags & UVC_QUEUE_DISCONNECTED) {
-		spin_unlock_irqrestore(&queue->irqlock, flags);
-		ret = -ENODEV;
-		goto done;
-	}
-	buf->state = UVC_BUF_STATE_QUEUED;
+	ret = vb2_reqbufs(&queue->queue, rb);
+	mutex_unlock(&queue->mutex);
 
-	ret = (queue->flags & UVC_QUEUE_PAUSED) != 0;
-	queue->flags &= ~UVC_QUEUE_PAUSED;
+	return ret ? ret : rb->count;
+}
 
-	list_add_tail(&buf->stream, &queue->mainqueue);
-	list_add_tail(&buf->queue, &queue->irqqueue);
-	spin_unlock_irqrestore(&queue->irqlock, flags);
+static int uvc_query_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *buf)
+{
+	int ret;
 
-done:
+	mutex_lock(&queue->mutex);
+	ret = vb2_querybuf(&queue->queue, buf);
 	mutex_unlock(&queue->mutex);
+
 	return ret;
 }
 
-static int uvc_queue_waiton(struct uvc_buffer *buf, int nonblocking)
+static int
+uvc_queue_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *buf)
 {
-	if (nonblocking) {
-		return (buf->state != UVC_BUF_STATE_QUEUED &&
-			buf->state != UVC_BUF_STATE_ACTIVE)
-			? 0 : -EAGAIN;
-	}
+	int ret;
+
+	mutex_lock(&queue->mutex);
+	ret = vb2_qbuf(&queue->queue, buf);
+	mutex_unlock(&queue->mutex);
 
-	return wait_event_interruptible(buf->wait,
-		buf->state != UVC_BUF_STATE_QUEUED &&
-		buf->state != UVC_BUF_STATE_ACTIVE);
+	return ret;
 }
 
 /*
@@ -300,58 +187,15 @@ static int uvc_queue_waiton(struct uvc_buffer *buf, int nonblocking)
  * available.
  */
 static int
-uvc_dequeue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *v4l2_buf,
-		   int nonblocking)
+uvc_dequeue_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *buf, int nonblocking)
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
+
 	return ret;
 }
 
@@ -362,102 +206,27 @@ done:
  * the device poll handler.
  */
 static unsigned int
-uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
-	       poll_table *wait)
+uvc_queue_poll(struct uvc_video_queue *queue,
+			struct file *file, poll_table *wait)
 {
-	struct uvc_buffer *buf;
-	unsigned int mask = 0;
+	unsigned int ret;
 
 	mutex_lock(&queue->mutex);
-	if (list_empty(&queue->mainqueue))
-		goto done;
-
-	buf = list_first_entry(&queue->mainqueue, struct uvc_buffer, stream);
-
-	poll_wait(file, &buf->wait, wait);
-	if (buf->state == UVC_BUF_STATE_DONE ||
-	    buf->state == UVC_BUF_STATE_ERROR)
-		mask |= POLLOUT | POLLWRNORM;
-
-done:
+	ret = vb2_poll(&queue->queue, file, wait);
 	mutex_unlock(&queue->mutex);
-	return mask;
-}
 
-/*
- * VMA operations.
- */
-static void uvc_vm_open(struct vm_area_struct *vma)
-{
-	struct uvc_buffer *buffer = vma->vm_private_data;
-	buffer->vma_use_count++;
+	return ret;
 }
 
-static void uvc_vm_close(struct vm_area_struct *vma)
+static int uvc_queue_mmap(struct uvc_video_queue *queue,
+				struct vm_area_struct *vma)
 {
-	struct uvc_buffer *buffer = vma->vm_private_data;
-	buffer->vma_use_count--;
-}
-
-static struct vm_operations_struct uvc_vm_ops = {
-	.open		= uvc_vm_open,
-	.close		= uvc_vm_close,
-};
-
-/*
- * Memory-map a buffer.
- *
- * This function implements video buffer memory mapping and is intended to be
- * used by the device mmap handler.
- */
-static int
-uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
-{
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
-
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
-
-	vma->vm_ops = &uvc_vm_ops;
-	vma->vm_private_data = buffer;
-	uvc_vm_open(vma);
-
-done:
+	ret = vb2_mmap(&queue->queue, vma);
 	mutex_unlock(&queue->mutex);
+
 	return ret;
 }
 
@@ -481,10 +250,10 @@ static void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 	spin_lock_irqsave(&queue->irqlock, flags);
 	while (!list_empty(&queue->irqqueue)) {
 		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
-				       queue);
+					queue);
 		list_del(&buf->queue);
 		buf->state = UVC_BUF_STATE_ERROR;
-		wake_up(&buf->wait);
+		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
 	}
 	/* This must be protected by the irqlock spinlock to avoid race
 	 * conditions between uvc_queue_buffer and the disconnection event that
@@ -516,26 +285,28 @@ static void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
  */
 static int uvc_queue_enable(struct uvc_video_queue *queue, int enable)
 {
-	unsigned int i;
+	unsigned long flags;
 	int ret = 0;
 
 	mutex_lock(&queue->mutex);
 	if (enable) {
-		if (uvc_queue_streaming(queue)) {
-			ret = -EBUSY;
+		ret = vb2_streamon(&queue->queue, queue->queue.type);
+		if (ret < 0)
 			goto done;
-		}
-		queue->sequence = 0;
-		queue->flags |= UVC_QUEUE_STREAMING;
+
 		queue->buf_used = 0;
+		queue->flags |= UVC_QUEUE_STREAMING;
 	} else {
-		uvc_queue_cancel(queue, 0);
-		INIT_LIST_HEAD(&queue->mainqueue);
-
-		for (i = 0; i < queue->count; ++i)
-			queue->buffer[i].state = UVC_BUF_STATE_IDLE;
-
-		queue->flags &= ~UVC_QUEUE_STREAMING;
+		if (uvc_queue_streaming(queue)) {
+			ret = vb2_streamoff(&queue->queue, queue->queue.type);
+			if (ret < 0)
+				goto done;
+
+			spin_lock_irqsave(&queue->irqlock, flags);
+			INIT_LIST_HEAD(&queue->irqqueue);
+			queue->flags &= ~UVC_QUEUE_STREAMING;
+			spin_unlock_irqrestore(&queue->irqlock, flags);
+		}
 	}
 
 done:
@@ -543,30 +314,29 @@ done:
 	return ret;
 }
 
-/* called with queue->irqlock held.. */
+/* called with &queue_irqlock held.. */
 static struct uvc_buffer *
 uvc_queue_next_buffer(struct uvc_video_queue *queue, struct uvc_buffer *buf)
 {
 	struct uvc_buffer *nextbuf;
 
 	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
-	    buf->buf.length != buf->buf.bytesused) {
+			buf->length != buf->bytesused) {
 		buf->state = UVC_BUF_STATE_QUEUED;
-		buf->buf.bytesused = 0;
+		vb2_set_plane_payload(&buf->buf, 0, 0);
 		return buf;
 	}
 
 	list_del(&buf->queue);
 	if (!list_empty(&queue->irqqueue))
 		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
-					   queue);
+						queue);
 	else
 		nextbuf = NULL;
 
-	buf->buf.sequence = queue->sequence++;
-	do_gettimeofday(&buf->buf.timestamp);
+	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
+	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
 
-	wake_up(&buf->wait);
 	return nextbuf;
 }
 
@@ -576,7 +346,7 @@ static struct uvc_buffer *uvc_queue_head(struct uvc_video_queue *queue)
 
 	if (!list_empty(&queue->irqqueue))
 		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
-				       queue);
+					queue);
 	else
 		queue->flags |= UVC_QUEUE_PAUSED;
 
diff --git a/drivers/usb/gadget/uvc_queue.h b/drivers/usb/gadget/uvc_queue.h
index 1812a8e..47ad0b8 100644
--- a/drivers/usb/gadget/uvc_queue.h
+++ b/drivers/usb/gadget/uvc_queue.h
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/poll.h>
 #include <linux/videodev2.h>
+#include <media/videobuf2-core.h>
 
 /* Maximum frame size in bytes, for sanity checking. */
 #define UVC_MAX_FRAME_SIZE	(16*1024*1024)
@@ -25,14 +26,13 @@ enum uvc_buffer_state {
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
+	void *mem;
+	unsigned int length;
+	unsigned int bytesused;
 };
 
 #define UVC_QUEUE_STREAMING		(1 << 0)
@@ -41,26 +41,21 @@ struct uvc_buffer {
 #define UVC_QUEUE_PAUSED		(1 << 3)
 
 struct uvc_video_queue {
-	enum v4l2_buf_type type;
+	struct vb2_queue queue;
+	struct mutex mutex;	/* Protects queue */
 
-	void *mem;
 	unsigned int flags;
 	__u32 sequence;
 
-	unsigned int count;
-	unsigned int buf_size;
 	unsigned int buf_used;
-	struct uvc_buffer buffer[UVC_MAX_VIDEO_BUFFERS];
-	struct mutex mutex;	/* protects buffers and mainqueue */
-	spinlock_t irqlock;	/* protects irqqueue */
 
-	struct list_head mainqueue;
+	spinlock_t irqlock;	/* Protects irqqueue */
 	struct list_head irqqueue;
 };
 
 static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
 {
-	return queue->flags & UVC_QUEUE_STREAMING;
+	return vb2_is_streaming(&queue->queue);
 }
 
 #endif /* __KERNEL__ */
diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
index f6e083b..9c2b45b 100644
--- a/drivers/usb/gadget/uvc_v4l2.c
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -144,20 +144,23 @@ uvc_v4l2_release(struct file *file)
 	struct uvc_device *uvc = video_get_drvdata(vdev);
 	struct uvc_file_handle *handle = to_uvc_file_handle(file->private_data);
 	struct uvc_video *video = handle->device;
+	int ret;
 
 	uvc_function_disconnect(uvc);
 
-	uvc_video_enable(video, 0);
-	mutex_lock(&video->queue.mutex);
-	if (uvc_free_buffers(&video->queue) < 0)
-		printk(KERN_ERR "uvc_v4l2_release: Unable to free "
-				"buffers.\n");
-	mutex_unlock(&video->queue.mutex);
+	ret = uvc_video_enable(video, 0);
+	if (ret < 0) {
+		printk(KERN_ERR "uvc_v4l2_release: uvc video disable failed\n");
+		return ret;
+	}
+
+	uvc_free_buffers(&video->queue);
 
 	file->private_data = NULL;
 	v4l2_fh_del(&handle->vfh);
 	v4l2_fh_exit(&handle->vfh);
 	kfree(handle);
+
 	return 0;
 }
 
@@ -192,7 +195,7 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	{
 		struct v4l2_format *fmt = arg;
 
-		if (fmt->type != video->queue.type)
+		if (fmt->type != video->queue.queue.type)
 			return -EINVAL;
 
 		return uvc_v4l2_get_format(video, fmt);
@@ -202,7 +205,7 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	{
 		struct v4l2_format *fmt = arg;
 
-		if (fmt->type != video->queue.type)
+		if (fmt->type != video->queue.queue.type)
 			return -EINVAL;
 
 		return uvc_v4l2_set_format(video, fmt);
@@ -213,16 +216,13 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	{
 		struct v4l2_requestbuffers *rb = arg;
 
-		if (rb->type != video->queue.type ||
-		    rb->memory != V4L2_MEMORY_MMAP)
+		if (rb->type != video->queue.queue.type)
 			return -EINVAL;
 
-		ret = uvc_alloc_buffers(&video->queue, rb->count,
-					video->imagesize);
+		ret = uvc_alloc_buffers(&video->queue, rb);
 		if (ret < 0)
 			return ret;
 
-		rb->count = ret;
 		ret = 0;
 		break;
 	}
@@ -231,9 +231,6 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	{
 		struct v4l2_buffer *buf = arg;
 
-		if (buf->type != video->queue.type)
-			return -EINVAL;
-
 		return uvc_query_buffer(&video->queue, buf);
 	}
 
@@ -251,7 +248,7 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	{
 		int *type = arg;
 
-		if (*type != video->queue.type)
+		if (*type != video->queue.queue.type)
 			return -EINVAL;
 
 		return uvc_video_enable(video, 1);
@@ -261,14 +258,14 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	{
 		int *type = arg;
 
-		if (*type != video->queue.type)
+		if (*type != video->queue.queue.type)
 			return -EINVAL;
 
 		return uvc_video_enable(video, 0);
 	}
 
 	/* Events */
-        case VIDIOC_DQEVENT:
+	case VIDIOC_DQEVENT:
 	{
 		struct v4l2_event *event = arg;
 
diff --git a/drivers/usb/gadget/uvc_video.c b/drivers/usb/gadget/uvc_video.c
index b0e53a8..195bbb6 100644
--- a/drivers/usb/gadget/uvc_video.c
+++ b/drivers/usb/gadget/uvc_video.c
@@ -32,7 +32,7 @@ uvc_video_encode_header(struct uvc_video *video, struct uvc_buffer *buf,
 	data[0] = 2;
 	data[1] = UVC_STREAM_EOH | video->fid;
 
-	if (buf->buf.bytesused - video->queue.buf_used <= len - 2)
+	if (buf->bytesused - video->queue.buf_used <= len - 2)
 		data[1] |= UVC_STREAM_EOF;
 
 	return 2;
@@ -47,8 +47,8 @@ uvc_video_encode_data(struct uvc_video *video, struct uvc_buffer *buf,
 	void *mem;
 
 	/* Copy video data to the USB buffer. */
-	mem = queue->mem + buf->buf.m.offset + queue->buf_used;
-	nbytes = min((unsigned int)len, buf->buf.bytesused - queue->buf_used);
+	mem = buf->mem + queue->buf_used;
+	nbytes = min((unsigned int)len, buf->bytesused - queue->buf_used);
 
 	memcpy(data, mem, nbytes);
 	queue->buf_used += nbytes;
@@ -82,7 +82,7 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
 	req->length = video->req_size - len;
 	req->zero = video->payload_size == video->max_payload_size;
 
-	if (buf->buf.bytesused == video->queue.buf_used) {
+	if (buf->bytesused == video->queue.buf_used) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		uvc_queue_next_buffer(&video->queue, buf);
@@ -92,7 +92,7 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
 	}
 
 	if (video->payload_size == video->max_payload_size ||
-	    buf->buf.bytesused == video->queue.buf_used)
+	    buf->bytesused == video->queue.buf_used)
 		video->payload_size = 0;
 }
 
@@ -115,7 +115,7 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
 
 	req->length = video->req_size - len;
 
-	if (buf->buf.bytesused == video->queue.buf_used) {
+	if (buf->bytesused == video->queue.buf_used) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		uvc_queue_next_buffer(&video->queue, buf);
@@ -161,6 +161,7 @@ static void
 uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 {
 	struct uvc_video *video = req->context;
+	struct uvc_video_queue *queue = &video->queue;
 	struct uvc_buffer *buf;
 	unsigned long flags;
 	int ret;
@@ -169,13 +170,15 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 	case 0:
 		break;
 
-	case -ESHUTDOWN:
+	case -ESHUTDOWN:	/* disconnect from host. */
 		printk(KERN_INFO "VS request cancelled.\n");
+		uvc_queue_cancel(queue, 1);
 		goto requeue;
 
 	default:
 		printk(KERN_INFO "VS request completed with status %d.\n",
 			req->status);
+		uvc_queue_cancel(queue, 0);
 		goto requeue;
 	}
 
-- 
1.7.2.2

