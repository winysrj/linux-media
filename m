Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58095 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759651AbbKTRLr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 12:11:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Geunyoung Kim <nenggun.kim@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv11 09/15] media: videobuf2: Move vb2_fileio_data and vb2_thread to core part
Date: Fri, 20 Nov 2015 17:45:42 +0100
Message-Id: <1448037948-36820-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Junghak Sung <jh1009.sung@samsung.com>

Move things related with vb2 file I/O and vb2_thread without doing any
functional changes. After that, videobuf2-internal.h is removed because
it is not necessary any more.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c     | 770 ++++++++++++++++++++++++++-
 drivers/media/v4l2-core/videobuf2-internal.h | 161 ------
 drivers/media/v4l2-core/videobuf2-v4l2.c     | 623 +---------------------
 include/media/videobuf2-core.h               |  43 ++
 include/media/videobuf2-v4l2.h               |  38 +-
 5 files changed, 817 insertions(+), 818 deletions(-)
 delete mode 100644 drivers/media/v4l2-core/videobuf2-internal.h

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index bd96fb8..d7e0ab3 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -28,11 +28,155 @@
 
 #include <trace/events/vb2.h>
 
-#include "videobuf2-internal.h"
+static int debug;
+module_param(debug, int, 0644);
 
-int vb2_debug;
-EXPORT_SYMBOL_GPL(vb2_debug);
-module_param_named(debug, vb2_debug, int, 0644);
+#define dprintk(level, fmt, arg...)					      \
+	do {								      \
+		if (debug >= level)					      \
+			pr_info("vb2-core: %s: " fmt, __func__, ## arg); \
+	} while (0)
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+
+/*
+ * If advanced debugging is on, then count how often each op is called
+ * successfully, which can either be per-buffer or per-queue.
+ *
+ * This makes it easy to check that the 'init' and 'cleanup'
+ * (and variations thereof) stay balanced.
+ */
+
+#define log_memop(vb, op)						\
+	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
+		(vb)->vb2_queue, (vb)->index, #op,			\
+		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
+
+#define call_memop(vb, op, args...)					\
+({									\
+	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	int err;							\
+									\
+	log_memop(vb, op);						\
+	err = _q->mem_ops->op ? _q->mem_ops->op(args) : 0;		\
+	if (!err)							\
+		(vb)->cnt_mem_ ## op++;					\
+	err;								\
+})
+
+#define call_ptr_memop(vb, op, args...)					\
+({									\
+	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	void *ptr;							\
+									\
+	log_memop(vb, op);						\
+	ptr = _q->mem_ops->op ? _q->mem_ops->op(args) : NULL;		\
+	if (!IS_ERR_OR_NULL(ptr))					\
+		(vb)->cnt_mem_ ## op++;					\
+	ptr;								\
+})
+
+#define call_void_memop(vb, op, args...)				\
+({									\
+	struct vb2_queue *_q = (vb)->vb2_queue;				\
+									\
+	log_memop(vb, op);						\
+	if (_q->mem_ops->op)						\
+		_q->mem_ops->op(args);					\
+	(vb)->cnt_mem_ ## op++;						\
+})
+
+#define log_qop(q, op)							\
+	dprintk(2, "call_qop(%p, %s)%s\n", q, #op,			\
+		(q)->ops->op ? "" : " (nop)")
+
+#define call_qop(q, op, args...)					\
+({									\
+	int err;							\
+									\
+	log_qop(q, op);							\
+	err = (q)->ops->op ? (q)->ops->op(args) : 0;			\
+	if (!err)							\
+		(q)->cnt_ ## op++;					\
+	err;								\
+})
+
+#define call_void_qop(q, op, args...)					\
+({									\
+	log_qop(q, op);							\
+	if ((q)->ops->op)						\
+		(q)->ops->op(args);					\
+	(q)->cnt_ ## op++;						\
+})
+
+#define log_vb_qop(vb, op, args...)					\
+	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
+		(vb)->vb2_queue, (vb)->index, #op,			\
+		(vb)->vb2_queue->ops->op ? "" : " (nop)")
+
+#define call_vb_qop(vb, op, args...)					\
+({									\
+	int err;							\
+									\
+	log_vb_qop(vb, op);						\
+	err = (vb)->vb2_queue->ops->op ?				\
+		(vb)->vb2_queue->ops->op(args) : 0;			\
+	if (!err)							\
+		(vb)->cnt_ ## op++;					\
+	err;								\
+})
+
+#define call_void_vb_qop(vb, op, args...)				\
+({									\
+	log_vb_qop(vb, op);						\
+	if ((vb)->vb2_queue->ops->op)					\
+		(vb)->vb2_queue->ops->op(args);				\
+	(vb)->cnt_ ## op++;						\
+})
+
+#else
+
+#define call_memop(vb, op, args...)					\
+	((vb)->vb2_queue->mem_ops->op ?					\
+		(vb)->vb2_queue->mem_ops->op(args) : 0)
+
+#define call_ptr_memop(vb, op, args...)					\
+	((vb)->vb2_queue->mem_ops->op ?					\
+		(vb)->vb2_queue->mem_ops->op(args) : NULL)
+
+#define call_void_memop(vb, op, args...)				\
+	do {								\
+		if ((vb)->vb2_queue->mem_ops->op)			\
+			(vb)->vb2_queue->mem_ops->op(args);		\
+	} while (0)
+
+#define call_qop(q, op, args...)					\
+	((q)->ops->op ? (q)->ops->op(args) : 0)
+
+#define call_void_qop(q, op, args...)					\
+	do {								\
+		if ((q)->ops->op)					\
+			(q)->ops->op(args);				\
+	} while (0)
+
+#define call_vb_qop(vb, op, args...)					\
+	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
+
+#define call_void_vb_qop(vb, op, args...)				\
+	do {								\
+		if ((vb)->vb2_queue->ops->op)				\
+			(vb)->vb2_queue->ops->op(args);			\
+	} while (0)
+
+#endif
+
+#define call_bufop(q, op, args...)					\
+({									\
+	int ret = 0;							\
+	if (q && q->buf_ops && q->buf_ops->op)				\
+		ret = q->buf_ops->op(args);				\
+	ret;								\
+})
 
 static void __vb2_queue_cancel(struct vb2_queue *q);
 static void __enqueue_in_driver(struct vb2_buffer *vb);
@@ -330,7 +474,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 		bool unbalanced = q->cnt_start_streaming != q->cnt_stop_streaming ||
 				  q->cnt_wait_prepare != q->cnt_wait_finish;
 
-		if (unbalanced || vb2_debug) {
+		if (unbalanced || debug) {
 			pr_info("vb2: counters for queue %p:%s\n", q,
 				unbalanced ? " UNBALANCED!" : "");
 			pr_info("vb2:     setup: %u start_streaming: %u stop_streaming: %u\n",
@@ -356,7 +500,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 				  vb->cnt_buf_prepare != vb->cnt_buf_finish ||
 				  vb->cnt_buf_init != vb->cnt_buf_cleanup;
 
-		if (unbalanced || vb2_debug) {
+		if (unbalanced || debug) {
 			pr_info("vb2:   counters for queue %p, buffer %d:%s\n",
 				q, buffer, unbalanced ? " UNBALANCED!" : "");
 			pr_info("vb2:     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
@@ -2086,6 +2230,8 @@ int vb2_core_queue_init(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_core_queue_init);
 
+static int __vb2_init_fileio(struct vb2_queue *q, int read);
+static int __vb2_cleanup_fileio(struct vb2_queue *q);
 /**
  * vb2_core_queue_release() - stop streaming, release the queue and free memory
  * @q:		videobuf2 queue
@@ -2096,6 +2242,7 @@ EXPORT_SYMBOL_GPL(vb2_core_queue_init);
  */
 void vb2_core_queue_release(struct vb2_queue *q)
 {
+	__vb2_cleanup_fileio(q);
 	__vb2_queue_cancel(q);
 	mutex_lock(&q->mmap_lock);
 	__vb2_queue_free(q, q->num_buffers);
@@ -2103,6 +2250,617 @@ void vb2_core_queue_release(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_core_queue_release);
 
+/**
+ * vb2_core_poll() - implements poll userspace operation
+ * @q:		videobuf2 queue
+ * @file:	file argument passed to the poll file operation handler
+ * @wait:	wait argument passed to the poll file operation handler
+ *
+ * This function implements poll file operation handler for a driver.
+ * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
+ * be informed that the file descriptor of a video device is available for
+ * reading.
+ * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
+ * will be reported as available for writing.
+ *
+ * The return values from this function are intended to be directly returned
+ * from poll handler in driver.
+ */
+unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
+		poll_table *wait)
+{
+	unsigned long req_events = poll_requested_events(wait);
+	struct vb2_buffer *vb = NULL;
+	unsigned long flags;
+
+	if (!q->is_output && !(req_events & (POLLIN | POLLRDNORM)))
+		return 0;
+	if (q->is_output && !(req_events & (POLLOUT | POLLWRNORM)))
+		return 0;
+
+	/*
+	 * Start file I/O emulator only if streaming API has not been used yet.
+	 */
+	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
+		if (!q->is_output && (q->io_modes & VB2_READ) &&
+				(req_events & (POLLIN | POLLRDNORM))) {
+			if (__vb2_init_fileio(q, 1))
+				return POLLERR;
+		}
+		if (q->is_output && (q->io_modes & VB2_WRITE) &&
+				(req_events & (POLLOUT | POLLWRNORM))) {
+			if (__vb2_init_fileio(q, 0))
+				return POLLERR;
+			/*
+			 * Write to OUTPUT queue can be done immediately.
+			 */
+			return POLLOUT | POLLWRNORM;
+		}
+	}
+
+	/*
+	 * There is nothing to wait for if the queue isn't streaming, or if the
+	 * error flag is set.
+	 */
+	if (!vb2_is_streaming(q) || q->error)
+		return POLLERR;
+
+	/*
+	 * For output streams you can call write() as long as there are fewer
+	 * buffers queued than there are buffers available.
+	 */
+	if (q->is_output && q->fileio && q->queued_count < q->num_buffers)
+		return POLLOUT | POLLWRNORM;
+
+	if (list_empty(&q->done_list)) {
+		/*
+		 * If the last buffer was dequeued from a capture queue,
+		 * return immediately. DQBUF will return -EPIPE.
+		 */
+		if (q->last_buffer_dequeued)
+			return POLLIN | POLLRDNORM;
+
+		poll_wait(file, &q->done_wq, wait);
+	}
+
+	/*
+	 * Take first buffer available for dequeuing.
+	 */
+	spin_lock_irqsave(&q->done_lock, flags);
+	if (!list_empty(&q->done_list))
+		vb = list_first_entry(&q->done_list, struct vb2_buffer,
+					done_entry);
+	spin_unlock_irqrestore(&q->done_lock, flags);
+
+	if (vb && (vb->state == VB2_BUF_STATE_DONE
+			|| vb->state == VB2_BUF_STATE_ERROR)) {
+		return (q->is_output) ?
+				POLLOUT | POLLWRNORM :
+				POLLIN | POLLRDNORM;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_core_poll);
+
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
+ * @cur_index:	the index of the buffer currently being read from or
+ *		written to. If equal to q->num_buffers then a new buffer
+ *		must be dequeued.
+ * @initial_index: in the read() case all buffers are queued up immediately
+ *		in __vb2_init_fileio() and __vb2_perform_fileio() just cycles
+ *		buffers. However, in the write() case no buffers are initially
+ *		queued, instead whenever a buffer is full it is queued up by
+ *		__vb2_perform_fileio(). Only once all available buffers have
+ *		been queued up will __vb2_perform_fileio() start to dequeue
+ *		buffers. This means that initially __vb2_perform_fileio()
+ *		needs to know what buffer index to use when it is queuing up
+ *		the buffers for the first time. That initial index is stored
+ *		in this field. Once it is equal to q->num_buffers all
+ *		available buffers have been queued and __vb2_perform_fileio()
+ *		should start the normal dequeue/queue cycle.
+ *
+ * vb2 provides a compatibility layer and emulator of file io (read and
+ * write) calls on top of streaming API. For proper operation it required
+ * this structure to save the driver state between each call of the read
+ * or write function.
+ */
+struct vb2_fileio_data {
+	unsigned int count;
+	unsigned int type;
+	unsigned int memory;
+	struct vb2_buffer *b;
+	struct vb2_fileio_buf bufs[VB2_MAX_FRAME];
+	unsigned int cur_index;
+	unsigned int initial_index;
+	unsigned int q_count;
+	unsigned int dq_count;
+	unsigned read_once:1;
+	unsigned write_immediately:1;
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
+	if (WARN_ON((read && !(q->io_modes & VB2_READ)) ||
+		    (!read && !(q->io_modes & VB2_WRITE))))
+		return -EINVAL;
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
+	dprintk(3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d\n",
+		(read) ? "read" : "write", count, q->fileio_read_once,
+		q->fileio_write_immediately);
+
+	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
+	if (fileio == NULL)
+		return -ENOMEM;
+
+	fileio->b = kzalloc(q->buf_struct_size, GFP_KERNEL);
+	if (fileio->b == NULL)
+		return -ENOMEM;
+
+	fileio->read_once = q->fileio_read_once;
+	fileio->write_immediately = q->fileio_write_immediately;
+
+	/*
+	 * Request buffers and use MMAP type to force driver
+	 * to allocate buffers by itself.
+	 */
+	fileio->count = count;
+	fileio->memory = VB2_MEMORY_MMAP;
+	fileio->type = q->type;
+	q->fileio = fileio;
+	ret = vb2_core_reqbufs(q, fileio->memory, &fileio->count);
+	if (ret)
+		goto err_kfree;
+
+	/*
+	 * Check if plane_count is correct
+	 * (multiplane buffers are not supported).
+	 */
+	if (q->bufs[0]->num_planes != 1) {
+		ret = -EBUSY;
+		goto err_reqbufs;
+	}
+
+	/*
+	 * Get kernel address of each buffer.
+	 */
+	for (i = 0; i < q->num_buffers; i++) {
+		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
+		if (fileio->bufs[i].vaddr == NULL) {
+			ret = -EINVAL;
+			goto err_reqbufs;
+		}
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
+			struct vb2_buffer *b = fileio->b;
+
+			memset(b, 0, q->buf_struct_size);
+			b->type = q->type;
+			b->memory = q->memory;
+			b->index = i;
+			ret = vb2_core_qbuf(q, i, b);
+			if (ret)
+				goto err_reqbufs;
+			fileio->bufs[i].queued = 1;
+		}
+		/*
+		 * All buffers have been queued, so mark that by setting
+		 * initial_index to q->num_buffers
+		 */
+		fileio->initial_index = q->num_buffers;
+		fileio->cur_index = q->num_buffers;
+	}
+
+	/*
+	 * Start streaming.
+	 */
+	ret = vb2_core_streamon(q, q->type);
+	if (ret)
+		goto err_reqbufs;
+
+	return ret;
+
+err_reqbufs:
+	fileio->count = 0;
+	vb2_core_reqbufs(q, fileio->memory, &fileio->count);
+
+err_kfree:
+	q->fileio = NULL;
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
+		vb2_core_streamoff(q, q->type);
+		q->fileio = NULL;
+		fileio->count = 0;
+		vb2_core_reqbufs(q, fileio->memory, &fileio->count);
+		kfree(fileio->b);
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
+	bool is_multiplanar = q->is_multiplanar;
+	/*
+	 * When using write() to write data to an output video node the vb2 core
+	 * should copy timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
+	 * else is able to provide this information with the write() operation.
+	 */
+	bool copy_timestamp = !read && q->copy_timestamp;
+	int ret, index;
+
+	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
+		read ? "read" : "write", (long)*ppos, count,
+		nonblock ? "non" : "");
+
+	if (!data)
+		return -EINVAL;
+
+	/*
+	 * Initialize emulator on first call.
+	 */
+	if (!vb2_fileio_is_active(q)) {
+		ret = __vb2_init_fileio(q, read);
+		dprintk(3, "vb2_init_fileio result: %d\n", ret);
+		if (ret)
+			return ret;
+	}
+	fileio = q->fileio;
+
+	/*
+	 * Check if we need to dequeue the buffer.
+	 */
+	index = fileio->cur_index;
+	if (index >= q->num_buffers) {
+		struct vb2_buffer *b = fileio->b;
+
+		/*
+		 * Call vb2_dqbuf to get buffer back.
+		 */
+		memset(b, 0, q->buf_struct_size);
+		b->type = q->type;
+		b->memory = q->memory;
+		ret = vb2_core_dqbuf(q, b, nonblock);
+		dprintk(5, "vb2_dqbuf result: %d\n", ret);
+		if (ret)
+			return ret;
+		fileio->dq_count += 1;
+
+		fileio->cur_index = index = b->index;
+		buf = &fileio->bufs[index];
+
+		/*
+		 * Get number of bytes filled by the driver
+		 */
+		buf->pos = 0;
+		buf->queued = 0;
+		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
+				 : vb2_plane_size(q->bufs[index], 0);
+		/* Compensate for data_offset on read in the multiplanar case. */
+		if (is_multiplanar && read &&
+				b->planes[0].data_offset < buf->size) {
+			buf->pos = b->planes[0].data_offset;
+			buf->size -= buf->pos;
+		}
+	} else {
+		buf = &fileio->bufs[index];
+	}
+
+	/*
+	 * Limit count on last few bytes of the buffer.
+	 */
+	if (buf->pos + count > buf->size) {
+		count = buf->size - buf->pos;
+		dprintk(5, "reducing read count: %zd\n", count);
+	}
+
+	/*
+	 * Transfer data to userspace.
+	 */
+	dprintk(3, "copying %zd bytes - buffer %d, offset %u\n",
+		count, index, buf->pos);
+	if (read)
+		ret = copy_to_user(data, buf->vaddr + buf->pos, count);
+	else
+		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
+	if (ret) {
+		dprintk(3, "error copying data\n");
+		return -EFAULT;
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
+	if (buf->pos == buf->size || (!read && fileio->write_immediately)) {
+		struct vb2_buffer *b = fileio->b;
+
+		/*
+		 * Check if this is the last buffer to read.
+		 */
+		if (read && fileio->read_once && fileio->dq_count == 1) {
+			dprintk(3, "read limit reached\n");
+			return __vb2_cleanup_fileio(q);
+		}
+
+		/*
+		 * Call vb2_qbuf and give buffer to the driver.
+		 */
+		memset(b, 0, q->buf_struct_size);
+		b->type = q->type;
+		b->memory = q->memory;
+		b->index = index;
+		b->planes[0].bytesused = buf->pos;
+
+		if (copy_timestamp)
+			b->timestamp = ktime_get_ns();
+		ret = vb2_core_qbuf(q, index, b);
+		dprintk(5, "vb2_dbuf result: %d\n", ret);
+		if (ret)
+			return ret;
+
+		/*
+		 * Buffer has been queued, update the status
+		 */
+		buf->pos = 0;
+		buf->queued = 1;
+		buf->size = vb2_plane_size(q->bufs[index], 0);
+		fileio->q_count += 1;
+		/*
+		 * If we are queuing up buffers for the first time, then
+		 * increase initial_index by one.
+		 */
+		if (fileio->initial_index < q->num_buffers)
+			fileio->initial_index++;
+		/*
+		 * The next buffer to use is either a buffer that's going to be
+		 * queued for the first time (initial_index < q->num_buffers)
+		 * or it is equal to q->num_buffers, meaning that the next
+		 * time we need to dequeue a buffer since we've now queued up
+		 * all the 'first time' buffers.
+		 */
+		fileio->cur_index = fileio->initial_index;
+	}
+
+	/*
+	 * Return proper number of bytes processed.
+	 */
+	if (ret == 0)
+		ret = count;
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
+size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
+		loff_t *ppos, int nonblocking)
+{
+	return __vb2_perform_fileio(q, (char __user *) data, count,
+							ppos, nonblocking, 0);
+}
+EXPORT_SYMBOL_GPL(vb2_write);
+
+struct vb2_threadio_data {
+	struct task_struct *thread;
+	vb2_thread_fnc fnc;
+	void *priv;
+	bool stop;
+};
+
+static int vb2_thread(void *data)
+{
+	struct vb2_queue *q = data;
+	struct vb2_threadio_data *threadio = q->threadio;
+	struct vb2_fileio_data *fileio = q->fileio;
+	bool copy_timestamp = false;
+	int prequeue = 0;
+	int index = 0;
+	int ret = 0;
+
+	if (q->is_output) {
+		prequeue = q->num_buffers;
+		copy_timestamp = q->copy_timestamp;
+	}
+
+	set_freezable();
+
+	for (;;) {
+		struct vb2_buffer *vb;
+		struct vb2_buffer *b = fileio->b;
+
+		/*
+		 * Call vb2_dqbuf to get buffer back.
+		 */
+		memset(b, 0, q->buf_struct_size);
+		b->type = q->type;
+		b->memory = q->memory;
+		if (prequeue) {
+			b->index = index++;
+			prequeue--;
+		} else {
+			call_void_qop(q, wait_finish, q);
+			if (!threadio->stop)
+				ret = vb2_core_dqbuf(q, b, 0);
+			call_void_qop(q, wait_prepare, q);
+			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
+		}
+		if (ret || threadio->stop)
+			break;
+		try_to_freeze();
+
+		vb = q->bufs[b->index];
+		if (b->state == VB2_BUF_STATE_DONE)
+			if (threadio->fnc(vb, threadio->priv))
+				break;
+		call_void_qop(q, wait_finish, q);
+		if (copy_timestamp)
+			b->timestamp = ktime_get_ns();;
+		if (!threadio->stop)
+			ret = vb2_core_qbuf(q, b->index, b);
+		call_void_qop(q, wait_prepare, q);
+		if (ret || threadio->stop)
+			break;
+	}
+
+	/* Hmm, linux becomes *very* unhappy without this ... */
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
+	return 0;
+}
+
+/*
+ * This function should not be used for anything else but the videobuf2-dvb
+ * support. If you think you have another good use-case for this, then please
+ * contact the linux-media mailinglist first.
+ */
+int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
+		     const char *thread_name)
+{
+	struct vb2_threadio_data *threadio;
+	int ret = 0;
+
+	if (q->threadio)
+		return -EBUSY;
+	if (vb2_is_busy(q))
+		return -EBUSY;
+	if (WARN_ON(q->fileio))
+		return -EBUSY;
+
+	threadio = kzalloc(sizeof(*threadio), GFP_KERNEL);
+	if (threadio == NULL)
+		return -ENOMEM;
+	threadio->fnc = fnc;
+	threadio->priv = priv;
+
+	ret = __vb2_init_fileio(q, !q->is_output);
+	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
+	if (ret)
+		goto nomem;
+	q->threadio = threadio;
+	threadio->thread = kthread_run(vb2_thread, q, "vb2-%s", thread_name);
+	if (IS_ERR(threadio->thread)) {
+		ret = PTR_ERR(threadio->thread);
+		threadio->thread = NULL;
+		goto nothread;
+	}
+	return 0;
+
+nothread:
+	__vb2_cleanup_fileio(q);
+nomem:
+	kfree(threadio);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vb2_thread_start);
+
+int vb2_thread_stop(struct vb2_queue *q)
+{
+	struct vb2_threadio_data *threadio = q->threadio;
+	int err;
+
+	if (threadio == NULL)
+		return 0;
+	threadio->stop = true;
+	/* Wake up all pending sleeps in the thread */
+	vb2_queue_error(q);
+	err = kthread_stop(threadio->thread);
+	__vb2_cleanup_fileio(q);
+	threadio->thread = NULL;
+	kfree(threadio);
+	q->threadio = NULL;
+	return err;
+}
+EXPORT_SYMBOL_GPL(vb2_thread_stop);
+
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/v4l2-core/videobuf2-internal.h b/drivers/media/v4l2-core/videobuf2-internal.h
deleted file mode 100644
index 79018c7..0000000
--- a/drivers/media/v4l2-core/videobuf2-internal.h
+++ /dev/null
@@ -1,161 +0,0 @@
-#ifndef _MEDIA_VIDEOBUF2_INTERNAL_H
-#define _MEDIA_VIDEOBUF2_INTERNAL_H
-
-#include <linux/err.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <media/videobuf2-core.h>
-
-extern int vb2_debug;
-
-#define dprintk(level, fmt, arg...)					      \
-	do {								      \
-		if (vb2_debug >= level)					      \
-			pr_info("vb2: %s: " fmt, __func__, ## arg); \
-	} while (0)
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-
-/*
- * If advanced debugging is on, then count how often each op is called
- * successfully, which can either be per-buffer or per-queue.
- *
- * This makes it easy to check that the 'init' and 'cleanup'
- * (and variations thereof) stay balanced.
- */
-
-#define log_memop(vb, op)						\
-	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->index, #op,			\
-		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
-
-#define call_memop(vb, op, args...)					\
-({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
-	int err;							\
-									\
-	log_memop(vb, op);						\
-	err = _q->mem_ops->op ? _q->mem_ops->op(args) : 0;		\
-	if (!err)							\
-		(vb)->cnt_mem_ ## op++;					\
-	err;								\
-})
-
-#define call_ptr_memop(vb, op, args...)					\
-({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
-	void *ptr;							\
-									\
-	log_memop(vb, op);						\
-	ptr = _q->mem_ops->op ? _q->mem_ops->op(args) : NULL;		\
-	if (!IS_ERR_OR_NULL(ptr))					\
-		(vb)->cnt_mem_ ## op++;					\
-	ptr;								\
-})
-
-#define call_void_memop(vb, op, args...)				\
-({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
-									\
-	log_memop(vb, op);						\
-	if (_q->mem_ops->op)						\
-		_q->mem_ops->op(args);					\
-	(vb)->cnt_mem_ ## op++;						\
-})
-
-#define log_qop(q, op)							\
-	dprintk(2, "call_qop(%p, %s)%s\n", q, #op,			\
-		(q)->ops->op ? "" : " (nop)")
-
-#define call_qop(q, op, args...)					\
-({									\
-	int err;							\
-									\
-	log_qop(q, op);							\
-	err = (q)->ops->op ? (q)->ops->op(args) : 0;			\
-	if (!err)							\
-		(q)->cnt_ ## op++;					\
-	err;								\
-})
-
-#define call_void_qop(q, op, args...)					\
-({									\
-	log_qop(q, op);							\
-	if ((q)->ops->op)						\
-		(q)->ops->op(args);					\
-	(q)->cnt_ ## op++;						\
-})
-
-#define log_vb_qop(vb, op, args...)					\
-	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->index, #op,			\
-		(vb)->vb2_queue->ops->op ? "" : " (nop)")
-
-#define call_vb_qop(vb, op, args...)					\
-({									\
-	int err;							\
-									\
-	log_vb_qop(vb, op);						\
-	err = (vb)->vb2_queue->ops->op ?				\
-		(vb)->vb2_queue->ops->op(args) : 0;			\
-	if (!err)							\
-		(vb)->cnt_ ## op++;					\
-	err;								\
-})
-
-#define call_void_vb_qop(vb, op, args...)				\
-({									\
-	log_vb_qop(vb, op);						\
-	if ((vb)->vb2_queue->ops->op)					\
-		(vb)->vb2_queue->ops->op(args);				\
-	(vb)->cnt_ ## op++;						\
-})
-
-#else
-
-#define call_memop(vb, op, args...)					\
-	((vb)->vb2_queue->mem_ops->op ?					\
-		(vb)->vb2_queue->mem_ops->op(args) : 0)
-
-#define call_ptr_memop(vb, op, args...)					\
-	((vb)->vb2_queue->mem_ops->op ?					\
-		(vb)->vb2_queue->mem_ops->op(args) : NULL)
-
-#define call_void_memop(vb, op, args...)				\
-	do {								\
-		if ((vb)->vb2_queue->mem_ops->op)			\
-			(vb)->vb2_queue->mem_ops->op(args);		\
-	} while (0)
-
-#define call_qop(q, op, args...)					\
-	((q)->ops->op ? (q)->ops->op(args) : 0)
-
-#define call_void_qop(q, op, args...)					\
-	do {								\
-		if ((q)->ops->op)					\
-			(q)->ops->op(args);				\
-	} while (0)
-
-#define call_vb_qop(vb, op, args...)					\
-	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
-
-#define call_void_vb_qop(vb, op, args...)				\
-	do {								\
-		if ((vb)->vb2_queue->ops->op)				\
-			(vb)->vb2_queue->ops->op(args);			\
-	} while (0)
-
-#endif
-
-#define call_bufop(q, op, args...)					\
-({									\
-	int ret = 0;							\
-	if (q && q->buf_ops && q->buf_ops->op)				\
-		ret = q->buf_ops->op(args);				\
-	ret;								\
-})
-
-bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
-int vb2_verify_memory_type(struct vb2_queue *q,
-		enum vb2_memory memory, unsigned int type);
-#endif /* _MEDIA_VIDEOBUF2_INTERNAL_H */
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 9dff50f..f17b9cf 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -31,7 +31,14 @@
 
 #include <media/videobuf2-v4l2.h>
 
-#include "videobuf2-internal.h"
+static int debug;
+module_param(debug, int, 0644);
+
+#define dprintk(level, fmt, arg...)					      \
+	do {								      \
+		if (debug >= level)					      \
+			pr_info("vb2-v4l2: %s: " fmt, __func__, ## arg); \
+	} while (0)
 
 /* Flags that are set by the vb2 core */
 #define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
@@ -765,9 +772,6 @@ int vb2_queue_init(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_queue_init);
 
-static int __vb2_init_fileio(struct vb2_queue *q, int read);
-static int __vb2_cleanup_fileio(struct vb2_queue *q);
-
 /**
  * vb2_queue_release() - stop streaming, release the queue and free memory
  * @q:		videobuf2 queue
@@ -778,103 +782,11 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
  */
 void vb2_queue_release(struct vb2_queue *q)
 {
-	__vb2_cleanup_fileio(q);
 	vb2_core_queue_release(q);
 }
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
 /**
- * vb2_core_poll() - implements poll userspace operation
- * @q:		videobuf2 queue
- * @file:	file argument passed to the poll file operation handler
- * @wait:	wait argument passed to the poll file operation handler
- *
- * This function implements poll file operation handler for a driver.
- * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
- * be informed that the file descriptor of a video device is available for
- * reading.
- * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
- * will be reported as available for writing.
- *
- * The return values from this function are intended to be directly returned
- * from poll handler in driver.
- */
-unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
-		poll_table *wait)
-{
-	unsigned long req_events = poll_requested_events(wait);
-	struct vb2_buffer *vb = NULL;
-	unsigned long flags;
-
-	if (!q->is_output && !(req_events & (POLLIN | POLLRDNORM)))
-		return 0;
-	if (q->is_output && !(req_events & (POLLOUT | POLLWRNORM)))
-		return 0;
-
-	/*
-	 * Start file I/O emulator only if streaming API has not been used yet.
-	 */
-	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
-		if (!q->is_output && (q->io_modes & VB2_READ) &&
-				(req_events & (POLLIN | POLLRDNORM))) {
-			if (__vb2_init_fileio(q, 1))
-				return POLLERR;
-		}
-		if (q->is_output && (q->io_modes & VB2_WRITE) &&
-				(req_events & (POLLOUT | POLLWRNORM))) {
-			if (__vb2_init_fileio(q, 0))
-				return POLLERR;
-			/*
-			 * Write to OUTPUT queue can be done immediately.
-			 */
-			return POLLOUT | POLLWRNORM;
-		}
-	}
-
-	/*
-	 * There is nothing to wait for if the queue isn't streaming, or if the
-	 * error flag is set.
-	 */
-	if (!vb2_is_streaming(q) || q->error)
-		return POLLERR;
-
-	/*
-	 * For output streams you can call write() as long as there are fewer
-	 * buffers queued than there are buffers available.
-	 */
-	if (q->is_output && q->fileio && q->queued_count < q->num_buffers)
-		return POLLOUT | POLLWRNORM;
-
-	if (list_empty(&q->done_list)) {
-		/*
-		 * If the last buffer was dequeued from a capture queue,
-		 * return immediately. DQBUF will return -EPIPE.
-		 */
-		if (q->last_buffer_dequeued)
-			return POLLIN | POLLRDNORM;
-
-		poll_wait(file, &q->done_wq, wait);
-	}
-
-	/*
-	 * Take first buffer available for dequeuing.
-	 */
-	spin_lock_irqsave(&q->done_lock, flags);
-	if (!list_empty(&q->done_list))
-		vb = list_first_entry(&q->done_list, struct vb2_buffer,
-					done_entry);
-	spin_unlock_irqrestore(&q->done_lock, flags);
-
-	if (vb && (vb->state == VB2_BUF_STATE_DONE
-			|| vb->state == VB2_BUF_STATE_ERROR)) {
-		return (q->is_output) ?
-				POLLOUT | POLLWRNORM :
-				POLLIN | POLLRDNORM;
-	}
-	return 0;
-}
-
-/**
  * vb2_poll() - implements poll userspace operation
  * @q:		videobuf2 queue
  * @file:	file argument passed to the poll file operation handler
@@ -920,525 +832,6 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 }
 EXPORT_SYMBOL_GPL(vb2_poll);
 
-/**
- * struct vb2_fileio_buf - buffer context used by file io emulator
- *
- * vb2 provides a compatibility layer and emulator of file io (read and
- * write) calls on top of streaming API. This structure is used for
- * tracking context related to the buffers.
- */
-struct vb2_fileio_buf {
-	void *vaddr;
-	unsigned int size;
-	unsigned int pos;
-	unsigned int queued:1;
-};
-
-/**
- * struct vb2_fileio_data - queue context used by file io emulator
- *
- * @cur_index:	the index of the buffer currently being read from or
- *		written to. If equal to q->num_buffers then a new buffer
- *		must be dequeued.
- * @initial_index: in the read() case all buffers are queued up immediately
- *		in __vb2_init_fileio() and __vb2_perform_fileio() just cycles
- *		buffers. However, in the write() case no buffers are initially
- *		queued, instead whenever a buffer is full it is queued up by
- *		__vb2_perform_fileio(). Only once all available buffers have
- *		been queued up will __vb2_perform_fileio() start to dequeue
- *		buffers. This means that initially __vb2_perform_fileio()
- *		needs to know what buffer index to use when it is queuing up
- *		the buffers for the first time. That initial index is stored
- *		in this field. Once it is equal to q->num_buffers all
- *		available buffers have been queued and __vb2_perform_fileio()
- *		should start the normal dequeue/queue cycle.
- *
- * vb2 provides a compatibility layer and emulator of file io (read and
- * write) calls on top of streaming API. For proper operation it required
- * this structure to save the driver state between each call of the read
- * or write function.
- */
-struct vb2_fileio_data {
-	unsigned int count;
-	unsigned int type;
-	unsigned int memory;
-	struct vb2_buffer *b;
-	struct vb2_fileio_buf bufs[VB2_MAX_FRAME];
-	unsigned int cur_index;
-	unsigned int initial_index;
-	unsigned int q_count;
-	unsigned int dq_count;
-	unsigned read_once:1;
-	unsigned write_immediately:1;
-};
-
-/**
- * __vb2_init_fileio() - initialize file io emulator
- * @q:		videobuf2 queue
- * @read:	mode selector (1 means read, 0 means write)
- */
-static int __vb2_init_fileio(struct vb2_queue *q, int read)
-{
-	struct vb2_fileio_data *fileio;
-	int i, ret;
-	unsigned int count = 0;
-
-	/*
-	 * Sanity check
-	 */
-	if (WARN_ON((read && !(q->io_modes & VB2_READ)) ||
-		    (!read && !(q->io_modes & VB2_WRITE))))
-		return -EINVAL;
-
-	/*
-	 * Check if device supports mapping buffers to kernel virtual space.
-	 */
-	if (!q->mem_ops->vaddr)
-		return -EBUSY;
-
-	/*
-	 * Check if streaming api has not been already activated.
-	 */
-	if (q->streaming || q->num_buffers > 0)
-		return -EBUSY;
-
-	/*
-	 * Start with count 1, driver can increase it in queue_setup()
-	 */
-	count = 1;
-
-	dprintk(3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d\n",
-		(read) ? "read" : "write", count, q->fileio_read_once,
-		q->fileio_write_immediately);
-
-	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
-	if (fileio == NULL)
-		return -ENOMEM;
-
-	fileio->b = kzalloc(q->buf_struct_size, GFP_KERNEL);
-	if (fileio->b == NULL)
-		return -ENOMEM;
-
-	fileio->read_once = q->fileio_read_once;
-	fileio->write_immediately = q->fileio_write_immediately;
-
-	/*
-	 * Request buffers and use MMAP type to force driver
-	 * to allocate buffers by itself.
-	 */
-	fileio->count = count;
-	fileio->memory = VB2_MEMORY_MMAP;
-	fileio->type = q->type;
-	q->fileio = fileio;
-	ret = vb2_core_reqbufs(q, fileio->memory, &fileio->count);
-	if (ret)
-		goto err_kfree;
-
-	/*
-	 * Check if plane_count is correct
-	 * (multiplane buffers are not supported).
-	 */
-	if (q->bufs[0]->num_planes != 1) {
-		ret = -EBUSY;
-		goto err_reqbufs;
-	}
-
-	/*
-	 * Get kernel address of each buffer.
-	 */
-	for (i = 0; i < q->num_buffers; i++) {
-		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
-		if (fileio->bufs[i].vaddr == NULL) {
-			ret = -EINVAL;
-			goto err_reqbufs;
-		}
-		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
-	}
-
-	/*
-	 * Read mode requires pre queuing of all buffers.
-	 */
-	if (read) {
-		/*
-		 * Queue all buffers.
-		 */
-		for (i = 0; i < q->num_buffers; i++) {
-			struct vb2_buffer *b = fileio->b;
-
-			memset(b, 0, q->buf_struct_size);
-			b->type = q->type;
-			b->memory = q->memory;
-			b->index = i;
-			ret = vb2_core_qbuf(q, i, b);
-			if (ret)
-				goto err_reqbufs;
-			fileio->bufs[i].queued = 1;
-		}
-		/*
-		 * All buffers have been queued, so mark that by setting
-		 * initial_index to q->num_buffers
-		 */
-		fileio->initial_index = q->num_buffers;
-		fileio->cur_index = q->num_buffers;
-	}
-
-	/*
-	 * Start streaming.
-	 */
-	ret = vb2_core_streamon(q, q->type);
-	if (ret)
-		goto err_reqbufs;
-
-	return ret;
-
-err_reqbufs:
-	fileio->count = 0;
-	vb2_core_reqbufs(q, fileio->memory, &fileio->count);
-
-err_kfree:
-	q->fileio = NULL;
-	kfree(fileio);
-	return ret;
-}
-
-/**
- * __vb2_cleanup_fileio() - free resourced used by file io emulator
- * @q:		videobuf2 queue
- */
-static int __vb2_cleanup_fileio(struct vb2_queue *q)
-{
-	struct vb2_fileio_data *fileio = q->fileio;
-
-	if (fileio) {
-		vb2_core_streamoff(q, q->type);
-		q->fileio = NULL;
-		fileio->count = 0;
-		vb2_core_reqbufs(q, fileio->memory, &fileio->count);
-		kfree(fileio->b);
-		kfree(fileio);
-		dprintk(3, "file io emulator closed\n");
-	}
-	return 0;
-}
-
-/**
- * __vb2_perform_fileio() - perform a single file io (read or write) operation
- * @q:		videobuf2 queue
- * @data:	pointed to target userspace buffer
- * @count:	number of bytes to read or write
- * @ppos:	file handle position tracking pointer
- * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
- * @read:	access mode selector (1 means read, 0 means write)
- */
-static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
-		loff_t *ppos, int nonblock, int read)
-{
-	struct vb2_fileio_data *fileio;
-	struct vb2_fileio_buf *buf;
-	bool is_multiplanar = q->is_multiplanar;
-	/*
-	 * When using write() to write data to an output video node the vb2 core
-	 * should copy timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
-	 * else is able to provide this information with the write() operation.
-	 */
-	bool copy_timestamp = !read && q->copy_timestamp;
-	int ret, index;
-
-	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
-		read ? "read" : "write", (long)*ppos, count,
-		nonblock ? "non" : "");
-
-	if (!data)
-		return -EINVAL;
-
-	/*
-	 * Initialize emulator on first call.
-	 */
-	if (!vb2_fileio_is_active(q)) {
-		ret = __vb2_init_fileio(q, read);
-		dprintk(3, "vb2_init_fileio result: %d\n", ret);
-		if (ret)
-			return ret;
-	}
-	fileio = q->fileio;
-
-	/*
-	 * Check if we need to dequeue the buffer.
-	 */
-	index = fileio->cur_index;
-	if (index >= q->num_buffers) {
-		struct vb2_buffer *b = fileio->b;
-
-		/*
-		 * Call vb2_dqbuf to get buffer back.
-		 */
-		memset(b, 0, q->buf_struct_size);
-		b->type = q->type;
-		b->memory = q->memory;
-		ret = vb2_core_dqbuf(q, b, nonblock);
-		dprintk(5, "vb2_dqbuf result: %d\n", ret);
-		if (ret)
-			return ret;
-		fileio->dq_count += 1;
-
-		fileio->cur_index = index = b->index;
-		buf = &fileio->bufs[index];
-
-		/*
-		 * Get number of bytes filled by the driver
-		 */
-		buf->pos = 0;
-		buf->queued = 0;
-		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
-				 : vb2_plane_size(q->bufs[index], 0);
-		/* Compensate for data_offset on read in the multiplanar case. */
-		if (is_multiplanar && read &&
-				b->planes[0].data_offset < buf->size) {
-			buf->pos = b->planes[0].data_offset;
-			buf->size -= buf->pos;
-		}
-	} else {
-		buf = &fileio->bufs[index];
-	}
-
-	/*
-	 * Limit count on last few bytes of the buffer.
-	 */
-	if (buf->pos + count > buf->size) {
-		count = buf->size - buf->pos;
-		dprintk(5, "reducing read count: %zd\n", count);
-	}
-
-	/*
-	 * Transfer data to userspace.
-	 */
-	dprintk(3, "copying %zd bytes - buffer %d, offset %u\n",
-		count, index, buf->pos);
-	if (read)
-		ret = copy_to_user(data, buf->vaddr + buf->pos, count);
-	else
-		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
-	if (ret) {
-		dprintk(3, "error copying data\n");
-		return -EFAULT;
-	}
-
-	/*
-	 * Update counters.
-	 */
-	buf->pos += count;
-	*ppos += count;
-
-	/*
-	 * Queue next buffer if required.
-	 */
-	if (buf->pos == buf->size || (!read && fileio->write_immediately)) {
-		struct vb2_buffer *b = fileio->b;
-
-		/*
-		 * Check if this is the last buffer to read.
-		 */
-		if (read && fileio->read_once && fileio->dq_count == 1) {
-			dprintk(3, "read limit reached\n");
-			return __vb2_cleanup_fileio(q);
-		}
-
-		/*
-		 * Call vb2_qbuf and give buffer to the driver.
-		 */
-		memset(b, 0, q->buf_struct_size);
-		b->type = q->type;
-		b->memory = q->memory;
-		b->index = index;
-		b->planes[0].bytesused = buf->pos;
-
-		if (copy_timestamp)
-			b->timestamp = ktime_get_ns();
-		ret = vb2_core_qbuf(q, index, b);
-		dprintk(5, "vb2_dbuf result: %d\n", ret);
-		if (ret)
-			return ret;
-
-		/*
-		 * Buffer has been queued, update the status
-		 */
-		buf->pos = 0;
-		buf->queued = 1;
-		buf->size = vb2_plane_size(q->bufs[index], 0);
-		fileio->q_count += 1;
-		/*
-		 * If we are queuing up buffers for the first time, then
-		 * increase initial_index by one.
-		 */
-		if (fileio->initial_index < q->num_buffers)
-			fileio->initial_index++;
-		/*
-		 * The next buffer to use is either a buffer that's going to be
-		 * queued for the first time (initial_index < q->num_buffers)
-		 * or it is equal to q->num_buffers, meaning that the next
-		 * time we need to dequeue a buffer since we've now queued up
-		 * all the 'first time' buffers.
-		 */
-		fileio->cur_index = fileio->initial_index;
-	}
-
-	/*
-	 * Return proper number of bytes processed.
-	 */
-	if (ret == 0)
-		ret = count;
-	return ret;
-}
-
-size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
-		loff_t *ppos, int nonblocking)
-{
-	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 1);
-}
-EXPORT_SYMBOL_GPL(vb2_read);
-
-size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
-		loff_t *ppos, int nonblocking)
-{
-	return __vb2_perform_fileio(q, (char __user *) data, count,
-							ppos, nonblocking, 0);
-}
-EXPORT_SYMBOL_GPL(vb2_write);
-
-struct vb2_threadio_data {
-	struct task_struct *thread;
-	vb2_thread_fnc fnc;
-	void *priv;
-	bool stop;
-};
-
-static int vb2_thread(void *data)
-{
-	struct vb2_queue *q = data;
-	struct vb2_threadio_data *threadio = q->threadio;
-	struct vb2_fileio_data *fileio = q->fileio;
-	bool copy_timestamp = false;
-	int prequeue = 0;
-	int index = 0;
-	int ret = 0;
-
-	if (q->is_output) {
-		prequeue = q->num_buffers;
-		copy_timestamp = q->copy_timestamp;
-	}
-
-	set_freezable();
-
-	for (;;) {
-		struct vb2_buffer *vb;
-		struct vb2_buffer *b = fileio->b;
-
-		/*
-		 * Call vb2_dqbuf to get buffer back.
-		 */
-		memset(b, 0, q->buf_struct_size);
-		b->type = q->type;
-		b->memory = q->memory;
-		if (prequeue) {
-			b->index = index++;
-			prequeue--;
-		} else {
-			call_void_qop(q, wait_finish, q);
-			if (!threadio->stop)
-				ret = vb2_core_dqbuf(q, b, 0);
-			call_void_qop(q, wait_prepare, q);
-			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
-		}
-		if (ret || threadio->stop)
-			break;
-		try_to_freeze();
-
-		vb = q->bufs[b->index];
-		if (b->state == VB2_BUF_STATE_DONE)
-			if (threadio->fnc(vb, threadio->priv))
-				break;
-		call_void_qop(q, wait_finish, q);
-		if (copy_timestamp)
-			b->timestamp = ktime_get_ns();
-		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, b->index, b);
-		call_void_qop(q, wait_prepare, q);
-		if (ret || threadio->stop)
-			break;
-	}
-
-	/* Hmm, linux becomes *very* unhappy without this ... */
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule();
-	}
-	return 0;
-}
-
-/*
- * This function should not be used for anything else but the videobuf2-dvb
- * support. If you think you have another good use-case for this, then please
- * contact the linux-media mailinglist first.
- */
-int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
-		     const char *thread_name)
-{
-	struct vb2_threadio_data *threadio;
-	int ret = 0;
-
-	if (q->threadio)
-		return -EBUSY;
-	if (vb2_is_busy(q))
-		return -EBUSY;
-	if (WARN_ON(q->fileio))
-		return -EBUSY;
-
-	threadio = kzalloc(sizeof(*threadio), GFP_KERNEL);
-	if (threadio == NULL)
-		return -ENOMEM;
-	threadio->fnc = fnc;
-	threadio->priv = priv;
-
-	ret = __vb2_init_fileio(q, !q->is_output);
-	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
-	if (ret)
-		goto nomem;
-	q->threadio = threadio;
-	threadio->thread = kthread_run(vb2_thread, q, "vb2-%s", thread_name);
-	if (IS_ERR(threadio->thread)) {
-		ret = PTR_ERR(threadio->thread);
-		threadio->thread = NULL;
-		goto nothread;
-	}
-	return 0;
-
-nothread:
-	__vb2_cleanup_fileio(q);
-nomem:
-	kfree(threadio);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(vb2_thread_start);
-
-int vb2_thread_stop(struct vb2_queue *q)
-{
-	struct vb2_threadio_data *threadio = q->threadio;
-	int err;
-
-	if (threadio == NULL)
-		return 0;
-	threadio->stop = true;
-	/* Wake up all pending sleeps in the thread */
-	vb2_queue_error(q);
-	err = kthread_stop(threadio->thread);
-	__vb2_cleanup_fileio(q);
-	threadio->thread = NULL;
-	kfree(threadio);
-	q->threadio = NULL;
-	return err;
-}
-EXPORT_SYMBOL_GPL(vb2_thread_stop);
-
 /*
  * The following functions are not part of the vb2 core API, but are helper
  * functions that plug into struct v4l2_ioctl_ops, struct v4l2_file_operations
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 67da143..cc94c9d 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -541,6 +541,42 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 				    unsigned long pgoff,
 				    unsigned long flags);
 #endif
+unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
+		poll_table *wait);
+size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblock);
+size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
+		loff_t *ppos, int nonblock);
+
+/*
+ * vb2_thread_fnc - callback function for use with vb2_thread
+ *
+ * This is called whenever a buffer is dequeued in the thread.
+ */
+typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
+
+/**
+ * vb2_thread_start() - start a thread for the given queue.
+ * @q:		videobuf queue
+ * @fnc:	callback function
+ * @priv:	priv pointer passed to the callback function
+ * @thread_name:the name of the thread. This will be prefixed with "vb2-".
+ *
+ * This starts a thread that will queue and dequeue until an error occurs
+ * or @vb2_thread_stop is called.
+ *
+ * This function should not be used for anything else but the videobuf2-dvb
+ * support. If you think you have another good use-case for this, then please
+ * contact the linux-media mailinglist first.
+ */
+int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
+		     const char *thread_name);
+
+/**
+ * vb2_thread_stop() - stop the thread for the given queue.
+ * @q:		videobuf queue
+ */
+int vb2_thread_stop(struct vb2_queue *q);
 
 /**
  * vb2_is_streaming() - return streaming status of the queue
@@ -645,4 +681,11 @@ static inline void vb2_clear_last_buffer_dequeued(struct vb2_queue *q)
 	q->last_buffer_dequeued = false;
 }
 
+/*
+ * The following functions are not part of the vb2 core API, but are useful
+ * functions for videobuf2-*.
+ */
+bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
+int vb2_verify_memory_type(struct vb2_queue *q,
+		enum vb2_memory memory, unsigned int type);
 #endif /* _MEDIA_VIDEOBUF2_CORE_H */
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 110062e..3cc836f 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -63,42 +63,8 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
 
 int __must_check vb2_queue_init(struct vb2_queue *q);
 void vb2_queue_release(struct vb2_queue *q);
-
-unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
-size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
-		loff_t *ppos, int nonblock);
-size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
-		loff_t *ppos, int nonblock);
-
-/*
- * vb2_thread_fnc - callback function for use with vb2_thread
- *
- * This is called whenever a buffer is dequeued in the thread.
- */
-typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
-
-/**
- * vb2_thread_start() - start a thread for the given queue.
- * @q:		videobuf queue
- * @fnc:	callback function
- * @priv:	priv pointer passed to the callback function
- * @thread_name:the name of the thread. This will be prefixed with "vb2-".
- *
- * This starts a thread that will queue and dequeue until an error occurs
- * or @vb2_thread_stop is called.
- *
- * This function should not be used for anything else but the videobuf2-dvb
- * support. If you think you have another good use-case for this, then please
- * contact the linux-media mailinglist first.
- */
-int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
-		     const char *thread_name);
-
-/**
- * vb2_thread_stop() - stop the thread for the given queue.
- * @q:		videobuf queue
- */
-int vb2_thread_stop(struct vb2_queue *q);
+unsigned int vb2_poll(struct vb2_queue *q, struct file *file,
+		poll_table *wait);
 
 /*
  * The following functions are not part of the vb2 core API, but are simple
-- 
2.6.2

