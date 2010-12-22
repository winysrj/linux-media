Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20598 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0LVOab (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 09:30:31 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LDU00AIG2YTJP70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 14:30:29 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDU003JN2YSWR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 14:30:29 +0000 (GMT)
Date: Wed, 22 Dec 2010 15:30:16 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 12/13] v4l: videobuf2: add read() and write() emulator
In-reply-to: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	andrzej.p@samsung.com
Message-id: <1293028217-23151-3-git-send-email-m.szyprowski@samsung.com>
References: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Add a generic file io (read and write) emulator for videobuf2. It uses
MMAP memory type buffers and generic vb2 calls: req_bufs, qbuf and
dqbuf. Video date is being copied from mmap buffers to userspace with
standard copy_to_user() function. To add support for file io the driver
needs to provide an additional callback - read_setup or write_setup. It
should provide the default number of buffers used by emulator and flags.

With these flags one can detemine the style of read() or write()
emulation. By default 'streaming' style is used. With
VB2_FILEIO_READ_ONCE flag one can select 'one shot' mode for read()
emulator. With VB2_FILEIO_WRITE_IMMEDIATE flag one can select immediate
conversion of write calls to qbuf for write() emulator, so the vb2 will
not wait until each buffer is filled completely before queueing it to
the driver.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |  399 ++++++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h       |    9 +
 2 files changed, 408 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index b856bd1..094ac6b 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -453,6 +453,11 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	unsigned long plane_sizes[VIDEO_MAX_PLANES];
 	int ret = 0;
 
+	if (q->fileio) {
+		dprintk(1, "reqbufs: file io in progress\n");
+		return -EBUSY;
+	}
+
 	if (req->memory != V4L2_MEMORY_MMAP
 			&& req->memory != V4L2_MEMORY_USERPTR) {
 		dprintk(1, "reqbufs: unsupported memory type\n");
@@ -824,6 +829,11 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	struct vb2_buffer *vb;
 	int ret = 0;
 
+	if (q->fileio) {
+		dprintk(1, "qbuf: file io in progress\n");
+		return -EBUSY;
+	}
+
 	if (b->type != q->type) {
 		dprintk(1, "qbuf: invalid buffer type\n");
 		return -EINVAL;
@@ -1028,6 +1038,11 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 	struct vb2_buffer *vb = NULL;
 	int ret;
 
+	if (q->fileio) {
+		dprintk(1, "dqbuf: file io in progress\n");
+		return -EBUSY;
+	}
+
 	if (b->type != q->type) {
 		dprintk(1, "dqbuf: invalid buffer type\n");
 		return -EINVAL;
@@ -1087,6 +1102,11 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	struct vb2_buffer *vb;
 
+	if (q->fileio) {
+		dprintk(1, "streamon: file io in progress\n");
+		return -EBUSY;
+	}
+
 	if (type != q->type) {
 		dprintk(1, "streamon: invalid stream type\n");
 		return -EINVAL;
@@ -1180,6 +1200,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
  */
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
+	if (q->fileio) {
+		dprintk(1, "streamoff: file io in progress\n");
+		return -EBUSY;
+	}
+
 	if (type != q->type) {
 		dprintk(1, "streamoff: invalid stream type\n");
 		return -EINVAL;
@@ -1303,6 +1328,8 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 }
 EXPORT_SYMBOL_GPL(vb2_mmap);
 
+static int __vb2_init_fileio(struct vb2_queue *q, int read);
+static int __vb2_cleanup_fileio(struct vb2_queue *q);
 
 /**
  * vb2_poll() - implements poll userspace operation
@@ -1323,9 +1350,30 @@ EXPORT_SYMBOL_GPL(vb2_mmap);
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
 	unsigned long flags;
+	unsigned int ret;
 	struct vb2_buffer *vb = NULL;
 
 	/*
+	 * Start file io emulator if streaming api has not been used yet.
+	 */
+	if (q->num_buffers == 0 && q->fileio == NULL) {
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
+			ret = __vb2_init_fileio(q, 1);
+			if (ret)
+				return ret;
+		}
+		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
+			ret = __vb2_init_fileio(q, 0);
+			if (ret)
+				return ret;
+			/*
+			 * Write to OUTPUT queue can be done immediately.
+			 */
+			return POLLOUT | POLLWRNORM;
+		}
+	}
+
+	/*
 	 * There is nothing to wait for if no buffers have already been queued.
 	 */
 	if (list_empty(&q->queued_list))
@@ -1395,11 +1443,362 @@ EXPORT_SYMBOL_GPL(vb2_queue_init);
  */
 void vb2_queue_release(struct vb2_queue *q)
 {
+	__vb2_cleanup_fileio(q);
 	__vb2_queue_cancel(q);
 	__vb2_queue_free(q);
 }
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
+/**
+ * struct vb2_fileio_buf - buffer context used by file io emulator
+ *
+ * vb2 provides a compatibility layer and emulator of file io (read and
+ * write) calls on top of streaming API. This structure is used for
+ * tracking context related to the buffers.
+ */
+struct vb2_fileio_buf {
+	void *vaddr;
+	unsigned int size;
+	unsigned int pos;
+	unsigned int queued:1;
+};
+
+/**
+ * struct vb2_fileio_data - queue context used by file io emulator
+ *
+ * vb2 provides a compatibility layer and emulator of file io (read and
+ * write) calls on top of streaming API. For proper operation it required
+ * this structure to save the driver state between each call of the read
+ * or write function.
+ */
+struct vb2_fileio_data {
+	struct v4l2_requestbuffers req;
+	struct v4l2_buffer b;
+	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
+	unsigned int index;
+	unsigned int q_count;
+	unsigned int dq_count;
+	unsigned int flags;
+};
+
+/**
+ * __vb2_init_fileio() - initialize file io emulator
+ * @q:		videobuf2 queue
+ * @read:	mode selector (1 means read, 0 means write)
+ */
+static int __vb2_init_fileio(struct vb2_queue *q, int read)
+{
+	struct vb2_fileio_data *fileio;
+	int i, ret;
+	unsigned int count = 0;
+
+	/*
+	 * Sanity check
+	 */
+	if ((read && !(q->io_modes & VB2_READ)) ||
+	   (!read && !(q->io_modes & VB2_WRITE)))
+		BUG();
+
+	/*
+	 * Check if device supports mapping buffers to kernel virtual space.
+	 */
+	if (!q->mem_ops->vaddr)
+		return -EBUSY;
+
+	/*
+	 * Check if streaming api has not been already activated.
+	 */
+	if (q->streaming || q->num_buffers > 0)
+		return -EBUSY;
+
+	/*
+	 * Start with count 1, driver can increase it in queue_setup()
+	 */
+	count = 1;
+
+	dprintk(3, "setting up file io: mode %s, count %d, flags %08x\n",
+		(read) ? "read" : "write", count, q->io_flags);
+
+	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
+	if (fileio == NULL)
+		return -ENOMEM;
+
+	fileio->flags = q->io_flags;
+
+	/*
+	 * Request buffers and use MMAP type to force driver
+	 * to allocate buffers by itself.
+	 */
+	fileio->req.count = count;
+	fileio->req.memory = V4L2_MEMORY_MMAP;
+	fileio->req.type = q->type;
+	ret = vb2_reqbufs(q, &fileio->req);
+	if (ret)
+		goto err_kfree;
+
+	/*
+	 * Check if plane_count is correct
+	 * (multiplane buffers are not supported).
+	 */
+	if (q->bufs[0]->num_planes != 1) {
+		fileio->req.count = 0;
+		ret = -EBUSY;
+		goto err_reqbufs;
+	}
+
+	/*
+	 * Get kernel address of each buffer.
+	 */
+	for (i = 0; i < q->num_buffers; i++) {
+		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
+		if (fileio->bufs[i].vaddr == NULL)
+			goto err_reqbufs;
+		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
+	}
+
+	/*
+	 * Read mode requires pre queuing of all buffers.
+	 */
+	if (read) {
+		/*
+		 * Queue all buffers.
+		 */
+		for (i = 0; i < q->num_buffers; i++) {
+			struct v4l2_buffer *b = &fileio->b;
+			memset(b, 0, sizeof(*b));
+			b->type = q->type;
+			b->memory = q->memory;
+			b->index = i;
+			ret = vb2_qbuf(q, b);
+			if (ret)
+				goto err_reqbufs;
+			fileio->bufs[i].queued = 1;
+		}
+
+		/*
+		 * Start streaming.
+		 */
+		ret = vb2_streamon(q, q->type);
+		if (ret)
+			goto err_reqbufs;
+	}
+
+	q->fileio = fileio;
+
+	return ret;
+
+err_reqbufs:
+	vb2_reqbufs(q, &fileio->req);
+
+err_kfree:
+	kfree(fileio);
+	return ret;
+}
+
+/**
+ * __vb2_cleanup_fileio() - free resourced used by file io emulator
+ * @q:		videobuf2 queue
+ */
+static int __vb2_cleanup_fileio(struct vb2_queue *q)
+{
+	struct vb2_fileio_data *fileio = q->fileio;
+
+	if (fileio) {
+		/*
+		 * Hack fileio context to enable direct calls to vb2 ioctl
+		 * interface.
+		 */
+		q->fileio = NULL;
+
+		vb2_streamoff(q, q->type);
+		fileio->req.count = 0;
+		vb2_reqbufs(q, &fileio->req);
+		kfree(fileio);
+		dprintk(3, "file io emulator closed\n");
+	}
+	return 0;
+}
+
+/**
+ * __vb2_perform_fileio() - perform a single file io (read or write) operation
+ * @q:		videobuf2 queue
+ * @data:	pointed to target userspace buffer
+ * @count:	number of bytes to read or write
+ * @ppos:	file handle position tracking pointer
+ * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
+ * @read:	access mode selector (1 means read, 0 means write)
+ */
+static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblock, int read)
+{
+	struct vb2_fileio_data *fileio;
+	struct vb2_fileio_buf *buf;
+	int ret, index;
+
+	dprintk(3, "file io: mode %s, offset %ld, count %d, %sblocking\n",
+		read ? "read" : "write", (long)*ppos, count,
+		nonblock ? "non" : "");
+
+	if (!data)
+		return -EINVAL;
+
+	/*
+	 * Initialize emulator on first call.
+	 */
+	if (!q->fileio) {
+		ret = __vb2_init_fileio(q, read);
+		dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
+		if (ret)
+			return ret;
+	}
+	fileio = q->fileio;
+
+	/*
+	 * Hack fileio context to enable direct calls to vb2 ioctl interface.
+	 * The pointer will be restored before returning from this function.
+	 */
+	q->fileio = NULL;
+
+	index = fileio->index;
+	buf = &fileio->bufs[index];
+
+	/*
+	 * Check if we need to dequeue the buffer.
+	 */
+	if (buf->queued) {
+		struct vb2_buffer *vb;
+
+		/*
+		 * Call vb2_dqbuf to get buffer back.
+		 */
+		memset(&fileio->b, 0, sizeof(fileio->b));
+		fileio->b.type = q->type;
+		fileio->b.memory = q->memory;
+		fileio->b.index = index;
+		ret = vb2_dqbuf(q, &fileio->b, nonblock);
+		dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
+		if (ret)
+			goto end;
+		fileio->dq_count += 1;
+
+		/*
+		 * Get number of bytes filled by the driver
+		 */
+		vb = q->bufs[index];
+		buf->size = vb2_get_plane_payload(vb, 0);
+		buf->queued = 0;
+	}
+
+	/*
+	 * Limit count on last few bytes of the buffer.
+	 */
+	if (buf->pos + count > buf->size) {
+		count = buf->size - buf->pos;
+		dprintk(5, "reducing read count: %d\n", count);
+	}
+
+	/*
+	 * Transfer data to userspace.
+	 */
+	dprintk(3, "file io: copying %d bytes - buffer %d, offset %d\n",
+		count, index, buf->pos);
+	if (read)
+		ret = copy_to_user(data, buf->vaddr + buf->pos, count);
+	else
+		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
+	if (ret) {
+		dprintk(3, "file io: error copying data\n");
+		ret = -EFAULT;
+		goto end;
+	}
+
+	/*
+	 * Update counters.
+	 */
+	buf->pos += count;
+	*ppos += count;
+
+	/*
+	 * Queue next buffer if required.
+	 */
+	if (buf->pos == buf->size ||
+	   (!read && (fileio->flags & VB2_FILEIO_WRITE_IMMEDIATELY))) {
+		/*
+		 * Check if this is the last buffer to read.
+		 */
+		if (read && (fileio->flags & VB2_FILEIO_READ_ONCE) &&
+		    fileio->dq_count == 1) {
+			dprintk(3, "file io: read limit reached\n");
+			/*
+			 * Restore fileio pointer and release the context.
+			 */
+			q->fileio = fileio;
+			return __vb2_cleanup_fileio(q);
+		}
+
+		/*
+		 * Call vb2_qbuf and give buffer to the driver.
+		 */
+		memset(&fileio->b, 0, sizeof(fileio->b));
+		fileio->b.type = q->type;
+		fileio->b.memory = q->memory;
+		fileio->b.index = index;
+		fileio->b.bytesused = buf->pos;
+		ret = vb2_qbuf(q, &fileio->b);
+		dprintk(5, "file io: vb2_dbuf result: %d\n", ret);
+		if (ret)
+			goto end;
+
+		/*
+		 * Buffer has been queued, update the status
+		 */
+		buf->pos = 0;
+		buf->queued = 1;
+		buf->size = q->bufs[0]->v4l2_planes[0].length;
+		fileio->q_count += 1;
+
+		/*
+		 * Switch to the next buffer
+		 */
+		fileio->index = (index + 1) % q->num_buffers;
+
+		/*
+		 * Start streaming if required.
+		 */
+		if (!read && !q->streaming) {
+			ret = vb2_streamon(q, q->type);
+			if (ret)
+				goto end;
+		}
+	}
+
+	/*
+	 * Return proper number of bytes processed.
+	 */
+	if (ret == 0)
+		ret = count;
+end:
+	/*
+	 * Restore the fileio context and block vb2 ioctl interface.
+	 */
+	q->fileio = fileio;
+	return ret;
+}
+
+size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblocking)
+{
+	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 1);
+}
+EXPORT_SYMBOL_GPL(vb2_read);
+
+size_t vb2_write(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblocking)
+{
+	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 0);
+}
+EXPORT_SYMBOL_GPL(vb2_write);
+
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 1dafac0..0d71fc5 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -18,6 +18,7 @@
 #include <linux/videodev2.h>
 
 struct vb2_alloc_ctx;
+struct vb2_fileio_data;
 
 /**
  * struct vb2_mem_ops - memory handling/memory allocator operations
@@ -54,6 +55,7 @@ struct vb2_alloc_ctx;
  *
  * Required ops for USERPTR types: get_userptr, put_userptr.
  * Required ops for MMAP types: alloc, put, num_users, mmap.
+ * Required ops for read/write access types: alloc, put, num_users, vaddr
  */
 struct vb2_mem_ops {
 	void		*(*alloc)(void *alloc_ctx, unsigned long size);
@@ -249,6 +251,7 @@ struct vb2_ops {
  * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
  * @alloc_ctx:	memory type/allocator-specific contexts for each plane
  * @streaming:	current streaming state
+ * @fileio:	file io emulator internal data, used only if emulator is active
  */
 struct vb2_queue {
 	enum v4l2_buf_type		type;
@@ -275,6 +278,8 @@ struct vb2_queue {
 	void				*alloc_ctx[VIDEO_MAX_PLANES];
 
 	unsigned int			streaming:1;
+
+	struct vb2_fileio_data		*fileio;
 };
 
 void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
@@ -298,6 +303,10 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
 
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
+size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblock);
+size_t vb2_write(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblock);
 
 /**
  * vb2_is_streaming() - return streaming status of the queue
-- 
1.7.1.569.g6f426

