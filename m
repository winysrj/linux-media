Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39754 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab0KUUcw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 15:32:52 -0500
Received: from localhost.localdomain (unknown [91.178.49.10])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5C33035CA7
	for <linux-media@vger.kernel.org>; Sun, 21 Nov 2010 20:32:51 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] uvcvideo: Move mmap() handler to uvc_queue.c
Date: Sun, 21 Nov 2010 21:32:51 +0100
Message-Id: <1290371573-14907-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The mmap() implementation belongs to the video buffers queue, move it
there.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_queue.c |   76 +++++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvc_v4l2.c  |   67 +------------------------------
 drivers/media/video/uvc/uvcvideo.h  |    2 +
 3 files changed, 79 insertions(+), 66 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index 32c1822..f14581b 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -380,6 +380,82 @@ done:
 }
 
 /*
+ * VMA operations.
+ */
+static void uvc_vm_open(struct vm_area_struct *vma)
+{
+	struct uvc_buffer *buffer = vma->vm_private_data;
+	buffer->vma_use_count++;
+}
+
+static void uvc_vm_close(struct vm_area_struct *vma)
+{
+	struct uvc_buffer *buffer = vma->vm_private_data;
+	buffer->vma_use_count--;
+}
+
+static const struct vm_operations_struct uvc_vm_ops = {
+	.open		= uvc_vm_open,
+	.close		= uvc_vm_close,
+};
+
+/*
+ * Memory-map a video buffer.
+ *
+ * This function implements video buffers memory mapping and is intended to be
+ * used by the device mmap handler.
+ */
+int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
+{
+	struct uvc_buffer *uninitialized_var(buffer);
+	struct page *page;
+	unsigned long addr, start, size;
+	unsigned int i;
+	int ret = 0;
+
+	start = vma->vm_start;
+	size = vma->vm_end - vma->vm_start;
+
+	mutex_lock(&queue->mutex);
+
+	for (i = 0; i < queue->count; ++i) {
+		buffer = &queue->buffer[i];
+		if ((buffer->buf.m.offset >> PAGE_SHIFT) == vma->vm_pgoff)
+			break;
+	}
+
+	if (i == queue->count || size != queue->buf_size) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/*
+	 * VM_IO marks the area as being an mmaped region for I/O to a
+	 * device. It also prevents the region from being core dumped.
+	 */
+	vma->vm_flags |= VM_IO;
+
+	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
+	while (size > 0) {
+		page = vmalloc_to_page((void *)addr);
+		if ((ret = vm_insert_page(vma, start, page)) < 0)
+			goto done;
+
+		start += PAGE_SIZE;
+		addr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+
+	vma->vm_ops = &uvc_vm_ops;
+	vma->vm_private_data = buffer;
+	uvc_vm_open(vma);
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+/*
  * Poll the video queue.
  *
  * This function implements video queue polling and is intended to be used by
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 0fd9848b..07dd235 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1032,79 +1032,14 @@ static ssize_t uvc_v4l2_read(struct file *file, char __user *data,
 	return -EINVAL;
 }
 
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
-}
-
-static const struct vm_operations_struct uvc_vm_ops = {
-	.open		= uvc_vm_open,
-	.close		= uvc_vm_close,
-};
-
 static int uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct uvc_fh *handle = file->private_data;
 	struct uvc_streaming *stream = handle->stream;
-	struct uvc_video_queue *queue = &stream->queue;
-	struct uvc_buffer *uninitialized_var(buffer);
-	struct page *page;
-	unsigned long addr, start, size;
-	unsigned int i;
-	int ret = 0;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_mmap\n");
 
-	start = vma->vm_start;
-	size = vma->vm_end - vma->vm_start;
-
-	mutex_lock(&queue->mutex);
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
-	mutex_unlock(&queue->mutex);
-	return ret;
+	return uvc_queue_mmap(&stream->queue, vma);
 }
 
 static unsigned int uvc_v4l2_poll(struct file *file, poll_table *wait)
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 4520924..ea893bc 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -574,6 +574,8 @@ extern int uvc_queue_enable(struct uvc_video_queue *queue, int enable);
 extern void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect);
 extern struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		struct uvc_buffer *buf);
+extern int uvc_queue_mmap(struct uvc_video_queue *queue,
+		struct vm_area_struct *vma);
 extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
 		struct file *file, poll_table *wait);
 extern int uvc_queue_allocated(struct uvc_video_queue *queue);
-- 
1.7.2.2

