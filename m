Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44450 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753422AbeEURCV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:02:21 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v10 13/16] vb2: add out-fence support to QBUF
Date: Mon, 21 May 2018 13:59:43 -0300
Message-Id: <20180521165946.11778-14-ezequiel@collabora.com>
In-Reply-To: <20180521165946.11778-1-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
an out_fence and send its fd to userspace in the fence_fd field as a
return arg for the QBUF call.

The fence is signaled on buffer_done(), when the job on the buffer is
finished.

v12: - Pass the fence_fd in vb2_qbuf for clarity.
     - Increase fence seqno if fence context if shared
     - Check get_unused_fd return

v11: - Return fence_fd to userpace only in the QBUF ioctl.
     - Rework implementation to avoid storing the sync_file
       as state, which is not really needed.

v10: - use -EIO for fence error (Hans Verkuil)
     - add comment around fence context creation (Hans Verkuil)

v9: - remove in-fences changes from this patch (Alex Courbot)
    - improve fence context creation (Hans Verkuil)
    - clean up out fences if vb2_core_qbuf() fails (Hans Verkuil)

v8: - return 0 as fence_fd if OUT_FENCE flag not used (Mauro)
    - fix crash when checking not using fences in vb2_buffer_done()

v7: - merge patch that add the infrastructure to out-fences into
      this one (Alex Courbot)
    - Do not install the fd if there is no fence. (Alex Courbot)
    - do not report error on requeueing, just WARN_ON_ONCE() (Hans)

v6: - get rid of the V4L2_EVENT_OUT_FENCE event. We always keep the
      ordering in vb2 for queueing in the driver, so the event is not
      necessary anymore and the out_fence_fd is sent back to userspace
      on QBUF call return arg
    - do not allow requeueing with out-fences, instead mark the buffer
      with an error and wake up to userspace.
    - send the out_fence_fd back to userspace on the fence_fd field

v5: - delay fd_install to DQ_EVENT (Hans)
    - if queue is fully ordered send OUT_FENCE event right away
      (Brian)
    - rename 'q->ordered' to 'q->ordered_in_driver'
    - merge change to implement OUT_FENCE event here

v4: - return the out_fence_fd in the BUF_QUEUED event(Hans)

v3: - add WARN_ON_ONCE(q->ordered) on requeueing (Hans)
    - set the OUT_FENCE flag if there is a fence pending (Hans)
    - call fd_install() after vb2_core_qbuf() (Hans)
    - clean up fence if vb2_core_qbuf() fails (Hans)
    - add list to store sync_file and fence for the next queued buffer

v2: check if the queue is ordered.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 113 +++++++++++++++++++++++-
 drivers/media/common/videobuf2/videobuf2-v4l2.c |  10 ++-
 drivers/media/dvb-core/dvb_vb2.c                |   2 +-
 include/media/videobuf2-core.h                  |  20 ++++-
 4 files changed, 136 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 86b5ebe25263..edc2fdaf56de 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/sync_file.h>
 
 #include <media/videobuf2-core.h>
 #include <media/v4l2-ioctl.h>
@@ -380,6 +381,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			vb->planes[plane].length = plane_sizes[plane];
 			vb->planes[plane].min_length = plane_sizes[plane];
 		}
+		vb->out_fence_fd = -1;
 		q->bufs[vb->index] = vb;
 
 		/* Allocate video buffer memory for the MMAP type */
@@ -976,10 +978,22 @@ static void vb2_process_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state
 	case VB2_BUF_STATE_QUEUED:
 		return;
 	case VB2_BUF_STATE_REQUEUEING:
+		/* Requeuing with explicit synchronization, spit warning */
+		WARN_ON_ONCE(vb->out_fence);
+
 		if (q->start_streaming_called)
 			__enqueue_in_driver(vb);
 		return;
 	default:
+		if (vb->out_fence) {
+			if (state == VB2_BUF_STATE_ERROR)
+				dma_fence_set_error(vb->out_fence, -EIO);
+			dma_fence_signal(vb->out_fence);
+			dma_fence_put(vb->out_fence);
+			vb->out_fence = NULL;
+			vb->out_fence_fd = -1;
+		}
+
 		/* Inform any processes that may be waiting for buffers */
 		wake_up(&q->done_wq);
 		break;
@@ -1406,6 +1420,76 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 }
 EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
+static inline const char *vb2_fence_get_driver_name(struct dma_fence *fence)
+{
+	return "vb2_fence";
+}
+
+static inline const char *vb2_fence_get_timeline_name(struct dma_fence *fence)
+{
+	return "vb2_fence_timeline";
+}
+
+static inline bool vb2_fence_enable_signaling(struct dma_fence *fence)
+{
+	return true;
+}
+
+static const struct dma_fence_ops vb2_fence_ops = {
+	.get_driver_name = vb2_fence_get_driver_name,
+	.get_timeline_name = vb2_fence_get_timeline_name,
+	.enable_signaling = vb2_fence_enable_signaling,
+	.wait = dma_fence_default_wait,
+};
+
+static int vb2_setup_out_fence(struct vb2_queue *q, struct vb2_buffer *vb)
+{
+	struct sync_file *sync_file;
+	unsigned int seqno;
+	int ret, fd;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	/*
+	 * The same context can be used only if the queue is ordered,
+	 * so if the queue is ordered create one when the queueing start,
+	 * otherwise create one for every buffer
+	 */
+	if (call_qop(q, is_unordered, q)) {
+		q->out_fence_context = dma_fence_context_alloc(1);
+		seqno = 1;
+	} else {
+		seqno = q->out_fence_seqno++;
+	}
+
+	vb->out_fence = kzalloc(sizeof(*vb->out_fence), GFP_KERNEL);
+	if (!vb->out_fence) {
+		ret = -ENOMEM;
+		goto err_put_fd;
+	}
+	dma_fence_init(vb->out_fence, &vb2_fence_ops, &q->out_fence_lock,
+		       q->out_fence_context, seqno);
+
+	sync_file = sync_file_create(vb->out_fence);
+	if (!sync_file) {
+		ret = -ENOMEM;
+		goto err_free_fence;
+	}
+	fd_install(fd, sync_file->file);
+	vb->out_fence_fd = fd;
+	return 0;
+
+err_free_fence:
+	dma_fence_put(vb->out_fence);
+	vb->out_fence = NULL;
+err_put_fd:
+	put_unused_fd(vb->out_fence_fd);
+	vb->out_fence_fd = -1;
+	return ret;
+}
+
 /*
  * vb2_start_streaming() - Attempt to start streaming.
  * @q:		videobuf2 queue
@@ -1508,7 +1592,7 @@ static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
 }
 
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
-		  struct dma_fence *in_fence)
+		  struct dma_fence *in_fence, int *out_fence_fd)
 {
 	struct vb2_buffer *vb;
 	int ret;
@@ -1540,6 +1624,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 	list_add_tail(&vb->queued_entry, &q->queued_list);
 	q->queued_count++;
 	q->waiting_for_buffers = false;
+	q->queueing_started = 1;
 	vb->state = VB2_BUF_STATE_QUEUED;
 
 	if (pb)
@@ -1600,6 +1685,20 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 			goto err_release;
 	}
 
+	if (out_fence_fd) {
+		*out_fence_fd = -1;
+		ret = vb2_setup_out_fence(q, vb);
+		if (ret) {
+			dprintk(1, "failed to set up out-fence\n");
+			goto err_release;
+		}
+
+		/* If we have successfully created an out-fence,
+		 * return its fd.
+		 */
+		*out_fence_fd = vb->out_fence_fd;
+	}
+
 	/* Fill buffer information for userspace */
 	if (pb)
 		call_void_bufop(q, fill_user_buffer, vb, pb);
@@ -1864,6 +1963,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	q->start_streaming_called = 0;
 	q->queued_count = 0;
 	q->error = 0;
+	q->queueing_started = 0;
 
 	/*
 	 * Remove all buffers from videobuf's list...
@@ -2206,7 +2306,12 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	spin_lock_init(&q->done_lock);
 	mutex_init(&q->mmap_lock);
 	init_waitqueue_head(&q->done_wq);
+	spin_lock_init(&q->out_fence_lock);
 
+	if (!call_qop(q, is_unordered, q)) {
+		q->out_fence_context = dma_fence_context_alloc(1);
+		q->out_fence_seqno = 1;
+	}
 	q->memory = VB2_MEMORY_UNKNOWN;
 
 	if (q->buf_struct_size == 0)
@@ -2457,7 +2562,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		 * Queue all buffers.
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
-			ret = vb2_core_qbuf(q, i, NULL, NULL);
+			ret = vb2_core_qbuf(q, i, NULL, NULL, NULL);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2636,7 +2741,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 
 		if (copy_timestamp)
 			b->timestamp = ktime_get_ns();
-		ret = vb2_core_qbuf(q, index, NULL, NULL);
+		ret = vb2_core_qbuf(q, index, NULL, NULL, NULL);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -2739,7 +2844,7 @@ static int vb2_thread(void *data)
 		if (copy_timestamp)
 			vb->timestamp = ktime_get_ns();
 		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
+			ret = vb2_core_qbuf(q, vb->index, NULL, NULL, NULL);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index ac14cc8ab1c5..b4908d0432c6 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -588,8 +588,9 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
+	bool get_out_fence = b->flags & V4L2_BUF_FLAG_OUT_FENCE;
 	struct dma_fence *in_fence = NULL;
-	int ret;
+	int ret, fence_fd;
 
 	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "file io in progress\n");
@@ -609,7 +610,12 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		}
 	}
 
-	return vb2_core_qbuf(q, b->index, b, in_fence);
+	ret = vb2_core_qbuf(q, b->index, b, in_fence,
+			    get_out_fence ? &fence_fd : NULL);
+	if (ret)
+		return ret;
+	b->fence_fd = fence_fd;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 7da53f10db1a..5c1523a8accc 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -385,7 +385,7 @@ int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 {
 	int ret;
 
-	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b, NULL);
+	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b, NULL, NULL);
 	if (ret) {
 		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,
 			b->index, ret);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ddd555f59dbf..6abe133d1c9a 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -262,6 +262,9 @@ struct vb2_buffer {
 	 *			using the buffer (queueing to the driver)
 	 * fence_cb:		fence callback information
 	 * qbuf_work:		work for deferred qbuf operation
+	 * out_fence_fd:	the out_fence_fd to be shared with userspace.
+	 * out_fence:		the out-fence associated with the buffer once
+	 *			it is queued to the driver.
 	 */
 	struct kref		refcount;
 	enum vb2_buffer_state	state;
@@ -274,6 +277,9 @@ struct vb2_buffer {
 	struct dma_fence_cb	fence_cb;
 	struct work_struct	qbuf_work;
 
+	int			out_fence_fd;
+	struct dma_fence	*out_fence;
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these buffer-related ops are
@@ -550,6 +556,10 @@ struct vb2_buf_ops {
  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
  *		last decoded buffer was already dequeued. Set for capture queues
  *		when a buffer with the %V4L2_BUF_FLAG_LAST is dequeued.
+ * @queueing_started: if queueing has started. Currently used to determine
+ *		if an out_fence_context is needed.
+ * @out_fence_context: the fence context for the out fences
+ * @out_fence_seqno: the fence seqno to use, if the context is shared
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
  */
@@ -602,6 +612,11 @@ struct vb2_queue {
 	unsigned int			is_output:1;
 	unsigned int			copy_timestamp:1;
 	unsigned int			last_buffer_dequeued:1;
+	unsigned int			queueing_started:1;
+
+	u64				out_fence_context;
+	unsigned int			out_fence_seqno;
+	spinlock_t			out_fence_lock;
 
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
@@ -800,7 +815,8 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  * @index:	id number of the buffer
  * @pb:		buffer structure passed from userspace to
  *		v4l2_ioctl_ops->vidioc_qbuf handler in driver
- * @in_fence:	in-fence to wait on before queueing the buffer
+ * @in_fence:	optioanl in-fence to wait on before queueing the buffer
+ * @out_fence_fd: optional pointer to store a newly created out-fence fd
  *
  * Videobuf2 core helper to implement VIDIOC_QBUF() operation. It is called
  * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
@@ -816,7 +832,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  * Return: returns zero on success; an error code otherwise.
  */
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
-		  struct dma_fence *in_fence);
+		  struct dma_fence *in_fence, int *out_fence_fd);
 
 /**
  * vb2_core_dqbuf() - Dequeue a buffer to the userspace
-- 
2.16.3
