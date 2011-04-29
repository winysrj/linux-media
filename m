Return-path: <mchehab@pedra>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:56778
	"EHLO CH1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992Ab1D2JyK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 05:54:10 -0400
Received: from mail38-ch1 (localhost.localdomain [127.0.0.1])	by
 mail38-ch1-R.bigfish.com (Postfix) with ESMTP id ECDF6C78583	for
 <linux-media@vger.kernel.org>; Fri, 29 Apr 2011 09:54:08 +0000 (UTC)
Received: from CH1EHSMHS011.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.252])	by mail38-ch1.bigfish.com (Postfix) with ESMTP id 9757736804F
	for <linux-media@vger.kernel.org>; Fri, 29 Apr 2011 09:54:08 +0000 (UTC)
From: Bob Liu <lliubbo@gmail.com>
To: <linux-media@vger.kernel.org>
CC: <dhowells@redhat.com>, <linux-uvc-devel@lists.berlios.de>,
	<mchehab@redhat.com>, <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>,
	<sakari.ailus@maxwell.research.nokia.com>,
	<martin_rubli@logitech.com>, <jarod@redhat.com>, <tj@kernel.org>,
	<arnd@arndb.de>, <fweisbec@gmail.com>, <agust@denx.de>,
	<gregkh@suse.de>, <daniel-gl@gmx.net>, <vapier@gentoo.org>,
	Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 2/2] media:uvc_driver: Add support for NOMMU arch
Date: Fri, 29 Apr 2011 18:11:35 +0800
Message-ID: <1304071895-27898-2-git-send-email-lliubbo@gmail.com>
In-Reply-To: <1304071895-27898-1-git-send-email-lliubbo@gmail.com>
References: <1304071895-27898-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support to uvc driver for NOMMU arch including add function
uvc_queue_get_unmapped_area() and make some changes in uvc_queue_mmap().
So that uvc camera can be used on nommu arch like blackfin.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/media/video/uvc/uvc_queue.c |   34 +++++++++++++++++++++++++++++++++-
 drivers/media/video/uvc/uvc_v4l2.c  |   17 +++++++++++++++++
 drivers/media/video/uvc/uvcvideo.h  |    4 ++++
 3 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index f14581b..109a063 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -424,7 +424,7 @@ int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 			break;
 	}
 
-	if (i == queue->count || size != queue->buf_size) {
+	if (i == queue->count || PAGE_ALIGN(size) != queue->buf_size) {
 		ret = -EINVAL;
 		goto done;
 	}
@@ -436,6 +436,7 @@ int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_IO;
 
 	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
+#ifdef CONFIG_MMU
 	while (size > 0) {
 		page = vmalloc_to_page((void *)addr);
 		if ((ret = vm_insert_page(vma, start, page)) < 0)
@@ -445,6 +446,7 @@ int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 		addr += PAGE_SIZE;
 		size -= PAGE_SIZE;
 	}
+#endif
 
 	vma->vm_ops = &uvc_vm_ops;
 	vma->vm_private_data = buffer;
@@ -488,6 +490,36 @@ done:
 	return mask;
 }
 
+#ifndef CONFIG_MMU
+/*
+ * Get unmapped area.
+ *
+ * NO-MMU arch need this function to make mmap() work correctly.
+ */
+unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
+		unsigned long pgoff)
+{
+	struct uvc_buffer *buffer;
+	unsigned int i;
+	unsigned long ret;
+
+	mutex_lock(&queue->mutex);
+	for (i = 0; i < queue->count; ++i) {
+		buffer = &queue->buffer[i];
+		if ((buffer->buf.m.offset >> PAGE_SHIFT) == pgoff)
+			break;
+	}
+	if (i == queue->count) {
+		ret = -EINVAL;
+		goto done;
+	}
+	ret = (unsigned long)queue->mem + buffer->buf.m.offset;
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+#endif
+
 /*
  * Enable or disable the video buffers queue.
  *
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 9005a8d..d0da5d0 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1081,6 +1081,20 @@ static unsigned int uvc_v4l2_poll(struct file *file, poll_table *wait)
 	return uvc_queue_poll(&stream->queue, file, wait);
 }
 
+#ifndef CONFIG_MMU
+static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags)
+{
+	struct uvc_fh *handle = file->private_data;
+	struct uvc_streaming *stream = handle->stream;
+
+	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_get_unmapped_area\n");
+
+	return uvc_queue_get_unmapped_area(&stream->queue, pgoff);
+}
+#endif
+
 const struct v4l2_file_operations uvc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uvc_v4l2_open,
@@ -1089,5 +1103,8 @@ const struct v4l2_file_operations uvc_fops = {
 	.read		= uvc_v4l2_read,
 	.mmap		= uvc_v4l2_mmap,
 	.poll		= uvc_v4l2_poll,
+#ifndef CONFIG_MMU
+	.get_unmapped_area = uvc_v4l2_get_unmapped_area,
+#endif
 };
 
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 45f01e7..6aa63c0 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -580,6 +580,10 @@ extern int uvc_queue_mmap(struct uvc_video_queue *queue,
 		struct vm_area_struct *vma);
 extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
 		struct file *file, poll_table *wait);
+#ifndef CONFIG_MMU
+extern unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
+		unsigned long pgoff);
+#endif
 extern int uvc_queue_allocated(struct uvc_video_queue *queue);
 static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
 {
-- 
1.6.3.3


