Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36999 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754091AbdJIKTp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:45 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 20/24] media: vb2-core: document remaining functions
Date: Mon,  9 Oct 2017 07:19:26 -0300
Message-Id: <3d1223ad9906e93104341eaa478909acb63de080.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several VB2 core functions that aren't documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/videobuf2-core.h | 54 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index e145f1475ffe..ce795cd0a7cc 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -786,7 +786,28 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
 int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 		   bool nonblocking);
 
+/**
+ * vb2_core_streamon() - Implements VB2 stream ON logic
+ *
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue
+ * @type:	type of the queue to be started.
+ *		For V4L2, this is defined by &enum v4l2_buf_type type.
+ *
+ * Should be called from &v4l2_ioctl_ops->vidioc_streamon ioctl handler of
+ * a driver.
+ */
 int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
+
+/**
+ * vb2_core_streamoff() - Implements VB2 stream OFF logic
+ *
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue
+ * @type:	type of the queue to be started.
+ *		For V4L2, this is defined by &enum v4l2_buf_type type.
+ *
+ * Should be called from &v4l2_ioctl_ops->vidioc_streamon ioctl handler of
+ * a driver.
+ */
 int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
 
 /**
@@ -874,6 +895,21 @@ void vb2_queue_error(struct vb2_queue *q);
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
 
 #ifndef CONFIG_MMU
+/**
+ * vb2_get_unmapped_area - map video buffers into application address space.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @addr:	memory address.
+ * @len:	buffer size.
+ * @pgoff:	page offset.
+ * @flags:	memory flags.
+ *
+ * This function is used in noMMU platforms to propose address mapping
+ * for a given buffer. It's intended to be used as a handler for the
+ * &file_operations->get_unmapped_area operation.
+ *
+ * This is called by the mmap() syscall routines will call this
+ * to get a proposed address for the mapping, when ``!CONFIG_MMU``.
+ */
 unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 				    unsigned long addr,
 				    unsigned long len,
@@ -882,7 +918,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 #endif
 
 /**
- * vb2_core_poll() - implements poll userspace operation.
+ * vb2_core_poll() - implements poll syscall() logic.
  * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  * @file:	&struct file argument passed to the poll
  *		file operation handler.
@@ -902,8 +938,24 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
 			   poll_table *wait);
 
+/**
+ * vb2_read() - implements read() syscall logic.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @data:	pointed to target userspace buffer
+ * @count:	number of bytes to read
+ * @ppos:	file handle position tracking pointer
+ * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
+ */
 size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
+/**
+ * vb2_read() - implements write() syscall logic.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @data:	pointed to target userspace buffer
+ * @count:	number of bytes to write
+ * @ppos:	file handle position tracking pointer
+ * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
+ */
 size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
 
-- 
2.13.6
