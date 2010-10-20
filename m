Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30588 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab0JTGl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 02:41:28 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LAK00B5XT90QA@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 07:41:24 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LAK005HKT8ZLV@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 07:41:24 +0100 (BST)
Date: Wed, 20 Oct 2010 08:41:11 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5/7] v4l: videobuf2: add read() emulator
In-reply-to: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com
Message-id: <1287556873-23179-6-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a generic read() emulator for videobuf2. It uses MMAP memory type
buffers and generic vb2 calls: req_bufs, qbuf and dqbuf. Video date is
being copied from mmap buffers to userspace with standard copy_to_user()
function. To add read() support to the driver, only one additional
structure should be provides which defines the default number of buffers
used by emulator and detemines the style of read() emulation
('streaming' or 'one shot').

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |  322 ++++++++++++++++++++++++++++++++--
 include/media/videobuf2-core.h       |   21 +++
 2 files changed, 325 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 4a29c49..ab00246 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -471,7 +471,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
  * The return values from this function are intended to be directly returned
  * from vidioc_reqbufs handler in driver.
  */
-int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
+static int __vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
 	unsigned int num_buffers, num_planes;
 	int ret = 0;
@@ -482,8 +482,6 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return -EINVAL;
 	}
 
-	mutex_lock(&q->vb_lock);
-
 	if (req->type != q->type) {
 		dprintk(1, "reqbufs: queue type invalid\n");
 		ret = -EINVAL;
@@ -567,6 +565,15 @@ end:
 	mutex_unlock(&q->vb_lock);
 	return ret;
 }
+
+int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
+{
+	int ret = 0;
+	mutex_lock(&q->vb_lock);
+	ret = (q->read_data) ? -EBUSY : __vb2_reqbufs(q, req);
+	mutex_unlock(&q->vb_lock);
+	return ret;
+}
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
 /**
@@ -821,14 +828,11 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
  * The return values from this function are intended to be directly returned
  * from vidioc_qbuf handler in driver.
  */
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+static int __vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	struct vb2_buffer *vb;
-	int ret;
-
-	mutex_lock(&q->vb_lock);
+	int ret = -EINVAL;
 
-	ret = -EINVAL;
 	if (b->type != q->type) {
 		dprintk(1, "qbuf: invalid buffer type\n");
 		goto done;
@@ -887,6 +891,14 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
 	ret = 0;
 done:
+	return ret;
+}
+
+int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	int ret = 0;
+	mutex_lock(&q->vb_lock);
+	ret = (q->read_data) ? -EBUSY : __vb2_qbuf(q, b);
 	mutex_unlock(&q->vb_lock);
 	return ret;
 }
@@ -996,13 +1008,11 @@ end:
  * The return values from this function are intended to be directly returned
  * from vidioc_dqbuf handler in driver.
  */
-int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+static int __vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
 	struct vb2_buffer *vb = NULL;
 	int ret;
 
-	mutex_lock(&q->vb_lock);
-
 	if (b->type != q->type) {
 		dprintk(1, "dqbuf: invalid buffer type\n");
 		ret = -EINVAL;
@@ -1047,6 +1057,14 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 	vb->state = VB2_BUF_STATE_DEQUEUED;
 
 done:
+	return ret;
+}
+
+int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+{
+	int ret;
+	mutex_lock(&q->vb_lock);
+	ret = (q->read_data) ? -EBUSY : __vb2_dqbuf(q, b, nonblocking);
 	mutex_unlock(&q->vb_lock);
 	return ret;
 }
@@ -1065,13 +1083,11 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
  * The return values from this function are intended to be directly returned
  * from vidioc_streamon handler in the driver.
  */
-int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+static int __vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	struct vb2_buffer *vb;
 	int ret = 0;
 
-	mutex_lock(&q->vb_lock);
-
 	if (type != q->type) {
 		dprintk(1, "streamon: invalid stream type\n");
 		ret = -EINVAL;
@@ -1113,6 +1129,14 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 
 	dprintk(3, "Streamon successful\n");
 done:
+	return ret;
+}
+
+int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+{
+	int ret;
+	mutex_lock(&q->vb_lock);
+	ret = (q->read_data) ? -EBUSY : __vb2_streamon(q, type);
 	mutex_unlock(&q->vb_lock);
 	return ret;
 }
@@ -1161,12 +1185,10 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
  * The return values from this function are intended to be directly returned
  * from vidioc_streamoff handler in the driver
  */
-int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+static int __vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	int ret = 0;
 
-	mutex_lock(&q->vb_lock);
-
 	if (type != q->type) {
 		dprintk(1, "streamoff: invalid stream type\n");
 		ret = -EINVAL;
@@ -1187,6 +1209,14 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 
 	dprintk(3, "Streamoff successful\n");
 end:
+	return ret;
+}
+
+int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+{
+	int ret;
+	mutex_lock(&q->vb_lock);
+	ret = (q->read_data) ? -EBUSY : __vb2_streamoff(q, type);
 	mutex_unlock(&q->vb_lock);
 	return ret;
 }
@@ -1311,6 +1341,9 @@ bool vb2_has_consumers(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_has_consumers);
 
+static int __vb2_init_read(struct vb2_queue *q);
+static int __vb2_cleanup_read(struct vb2_queue *q);
+
 /**
  * vb2_poll() - implements poll userspace operation
  * @q:		videobuf2 queue
@@ -1336,6 +1369,15 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	mutex_lock(&q->vb_lock);
 
 	/*
+	 * Start read() emulator if streaming api has not been used yet.
+	 */
+	if (q->num_buffers == 0 && q->read_data == NULL && q->read_ctx) {
+		ret = __vb2_init_read(q);
+		if (ret)
+			goto end;
+	}
+
+	/*
 	 * There is nothing to wait for if no buffers have already been queued.
 	 */
 	if (list_empty(&q->queued_list)) {
@@ -1378,12 +1420,15 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  *		the given context will be used for memory allocation on all
  *		planes and buffers; it is possible to assign different contexts
  *		per plane, use vb2_set_alloc_ctx() for that
+ * @read_ctx:	parameters for read() api to be used; can be NULL if no read
+ *		callback is used
  * @type:	queue type
  * @drv_priv:	driver private data, may be NULL; it can be used by driver in
  *		driver-specific callbacks when issued
  */
 int vb2_queue_init(struct vb2_queue *q, const struct vb2_ops *ops,
 			const struct vb2_alloc_ctx *alloc_ctx,
+			const struct vb2_read_ctx *read_ctx,
 			enum v4l2_buf_type type, void *drv_priv)
 {
 	unsigned int i;
@@ -1403,6 +1448,7 @@ int vb2_queue_init(struct vb2_queue *q, const struct vb2_ops *ops,
 	for (i = 0; i < VIDEO_MAX_PLANES; ++i)
 		q->alloc_ctx[i] = alloc_ctx;
 
+	q->read_ctx = read_ctx;
 	q->type = type;
 	q->drv_priv = drv_priv;
 
@@ -1428,6 +1474,7 @@ void vb2_queue_release(struct vb2_queue *q)
 {
 	mutex_lock(&q->vb_lock);
 
+	__vb2_cleanup_read(q);
 	__vb2_queue_cancel(q);
 	__vb2_queue_free(q);
 
@@ -1435,6 +1482,245 @@ void vb2_queue_release(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
+/**
+ * struct vb2_read_data - internal structure used by read() emulator
+ *
+ * vb2 provides a compatibility layer and emulator of read() calls on top
+ * of streaming api. For proper operation it required this structure to
+ * save the driver state between each call of the read function.
+ */
+struct vb2_read_data {
+	struct v4l2_requestbuffers req;
+	struct v4l2_buffer b;
+	void *buff_vaddr[VIDEO_MAX_FRAME];
+	unsigned cur_offset;
+	unsigned cur_bufsize;
+	unsigned read_offset;
+	int cur_buffer;
+	int buffer_count;
+};
+
+/**
+ * __vb2_init_read() - initialize read() emulator
+ * @q:		videobuf2 queue
+ */
+static int __vb2_init_read(struct vb2_queue *q)
+{
+	struct vb2_read_data *rd;
+	int i, ret;
+
+	if (!q->read_ctx)
+		BUG();
+
+	/*
+	 * Check if device supports mapping buffers to kernel virtual space
+	 */
+	if (!q->alloc_ctx[0]->mem_ops->vaddr)
+		return -EBUSY;
+
+	/*
+	 * Check if steaming api has not been already activated.
+	 */
+	if (q->streaming || q->num_buffers > 0)
+		return -EBUSY;
+
+	/*
+	 * Basic checks done, lets try to set up read emulator
+	 */
+	dprintk(3, "setting up read() emulator\n");
+
+	q->read_data = kmalloc(sizeof(struct vb2_read_data), GFP_KERNEL);
+	if (q->read_data == NULL)
+		return -ENOMEM;
+
+	memset(q->read_data, 0, sizeof(*q->read_data));
+	rd = q->read_data;
+
+	/*
+	 * Request buffers and use MMAP type to force driver
+	 * to allocate buffers by itself.
+	 */
+	rd->req.count = q->read_ctx->num_bufs;
+	rd->req.memory = V4L2_MEMORY_MMAP;
+	rd->req.type = q->type;
+	ret = __vb2_reqbufs(q, &rd->req);
+	if (ret)
+		goto err_kfree;
+
+	/*
+	 * Check if plane_count is correct
+	 * (multiplane buffers are not supported).
+	 */
+	if (q->bufs[0]->num_planes != 1) {
+		rd->req.count = 0;
+		ret = -EBUSY;
+		goto err_reqbufs;
+	}
+
+	/*
+	 * Get kernel address of each buffer.
+	 */
+	for (i = 0; i < q->num_buffers; i++)
+		rd->buff_vaddr[i] = vb2_plane_vaddr(q->bufs[i], 0);
+
+	/*
+	 * Queue all buffers.
+	 */
+	for (i = 0; i < q->num_buffers; i++) {
+		memset(&rd->b, 0, sizeof(rd->b));
+		rd->b.type = q->type;
+		rd->b.memory = q->memory;
+		rd->b.index = i;
+		ret = __vb2_qbuf(q, &rd->b);
+		if (ret)
+			goto err_reqbufs;
+	}
+
+	/*
+	 * Start streaming.
+	 */
+	ret = __vb2_streamon(q, q->type);
+	if (ret)
+		goto err_reqbufs;
+
+	return ret;
+
+err_reqbufs:
+	__vb2_reqbufs(q, &rd->req);
+
+err_kfree:
+	kfree(q->read_data);
+	return ret;
+}
+
+/**
+ * __vb2_cleanup_read() - free resourced used by read() emulator
+ * @q:		videobuf2 queue
+ */
+static int __vb2_cleanup_read(struct vb2_queue *q)
+{
+	struct vb2_read_data *rd = q->read_data;
+	if (rd) {
+		__vb2_streamoff(q, q->type);
+		rd->req.count = 0;
+		__vb2_reqbufs(q, &rd->req);
+		kfree(rd);
+		q->read_data = NULL;
+		dprintk(3, "read() emulator released\n");
+	}
+	return 0;
+}
+
+size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblocking)
+{
+	struct vb2_read_data *rd;
+	int ret;
+
+	dprintk(3, "read: offset %ld, count %d, %sblocking\n", (long)*ppos,
+		count, nonblocking ? "non" : "");
+
+	if (!data)
+		return -EINVAL;
+
+	mutex_lock(&q->vb_lock);
+
+	/*
+	 * Initialize emulator on first read() call.
+	 */
+	if (!q->read_data) {
+		ret = __vb2_init_read(q);
+		dprintk(3, "read: vb2_init_read result: %d\n", ret);
+		if (ret)
+			goto end;
+	}
+
+	rd = q->read_data;
+
+	/*
+	 * Current buffer is empty...
+	 */
+	if (rd->cur_offset == 0 && rd->cur_bufsize == 0) {
+		/*
+		 * ... check if this was the last buffer to read.
+		 */
+		if (q->read_ctx->read_once &&
+		    rd->buffer_count == q->read_ctx->num_bufs) {
+			ret = __vb2_cleanup_read(q);
+			goto end;
+		}
+
+		/*
+		 * ... or call vb2_dqbuf to get next buffer with data.
+		 */
+		memset(&rd->b, 0, sizeof(rd->b));
+		rd->b.type = q->type;
+		rd->b.memory = q->memory;
+		rd->b.index = rd->cur_buffer;
+		ret = __vb2_dqbuf(q, &rd->b, nonblocking);
+		dprintk(5, "read: vb2_dqbuf result: %d\n", ret);
+		if (ret)
+			goto end;
+		rd->buffer_count += 1;
+		rd->cur_bufsize = rd->b.length;
+	}
+
+	/*
+	 * Limit count on last few bytes of the buffer.
+	 */
+	if (count + rd->cur_offset > rd->cur_bufsize) {
+		count = rd->cur_bufsize - rd->cur_offset;
+		dprintk(5, "reducing read count: %d\n", count);
+	}
+
+	/*
+	 * Transfer data to userspace.
+	 */
+	dprintk(3, "read: copying %d data from buffer %d (offset %d bytes)\n",
+		count, rd->cur_buffer, rd->cur_offset);
+	if (copy_to_user(data,
+			 rd->buff_vaddr[rd->cur_buffer] + rd->cur_offset,
+			 count)) {
+		dprintk(3, "read: error copying data\n");
+		ret = -EFAULT;
+		goto end;
+	}
+
+	/*
+	 * Update counters.
+	 */
+	rd->cur_offset += count;
+	rd->read_offset += count;
+	*ppos += count;
+
+	/*
+	 * Queue next buffer if required.
+	 */
+	if (rd->cur_offset == rd->cur_bufsize) {
+		memset(&rd->b, 0, sizeof(rd->b));
+		rd->b.type = q->type;
+		rd->b.memory = q->memory;
+		rd->b.index = rd->cur_buffer;
+		ret = __vb2_qbuf(q, &rd->b);
+		dprintk(5, "read: vb2_dbuf result: %d\n", ret);
+		if (ret)
+			goto end;
+		rd->cur_buffer = (rd->cur_buffer + 1) % q->num_buffers;
+		rd->cur_offset = 0;
+		rd->cur_bufsize = 0;
+	}
+
+	/*
+	 * Return proper number of bytes read.
+	 */
+	if (ret == 0)
+		ret = count;
+end:
+	mutex_unlock(&q->vb_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vb2_read);
+
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
-MODULE_AUTHOR("Pawel Osciak");
+MODULE_AUTHOR("Pawel Osciak, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 76d0b4e..8c1ce06 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -18,6 +18,7 @@
 #include <linux/poll.h>
 
 struct vb2_alloc_ctx;
+struct vb2_read_data;
 
 /**
  * struct vb2_mem_ops - memory handling/memory allocator operations
@@ -210,6 +211,18 @@ struct vb2_ops {
 };
 
 /**
+ * struct vb2_read_ctx - defaults for read() callback emulator
+ *
+ * @num_bufs:	number of buffers used by the emulator
+ * @read_once:	determines weather read emulator return EOF after processing
+ *		@num_bufs or queues buffer again for new data
+ */
+struct vb2_read_ctx {
+	int	num_bufs;
+	int	read_once;
+};
+
+/**
  * struct vb2_queue - a videobuf queue
  *
  * @type:	current queue type
@@ -227,6 +240,8 @@ struct vb2_ops {
  * @streaming:	current streaming state
  * @userptr_supported: true if queue supports USERPTR types
  * @mmap_supported: true if queue supports MMAP types
+ * @read_ctx:	defaults for read() emulator, can be NULL
+ * @read_data:	read() emulator internal data, used only if emulator is active
  */
 struct vb2_queue {
 	enum v4l2_buf_type		type;
@@ -250,6 +265,9 @@ struct vb2_queue {
 	int				streaming:1;
 	int				userptr_supported:1;
 	int				mmap_supported:1;
+
+	const struct vb2_read_ctx	*read_ctx;
+	struct vb2_read_data		*read_data;
 };
 
 void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
@@ -262,6 +280,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
 
 int vb2_queue_init(struct vb2_queue *q, const struct vb2_ops *ops,
 			const struct vb2_alloc_ctx *alloc_ctx,
+			const struct vb2_read_ctx *read_ctx,
 			enum v4l2_buf_type type, void *drv_priv);
 void vb2_queue_release(struct vb2_queue *q);
 
@@ -273,6 +292,8 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
 
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
+size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblocking);
 
 /**
  * vb2_is_streaming() - return streaming status of the queue
-- 
1.7.1.569.g6f426

