Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:41994 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934113AbeEIKiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 06:38:00 -0400
Date: Wed, 9 May 2018 11:37:56 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, kernel@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v9 12/15] vb2: add out-fence support to QBUF
Message-ID: <20180509103756.GD39838@e107564-lin.cambridge.arm.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
 <20180504200612.8763-13-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20180504200612.8763-13-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, May 04, 2018 at 05:06:09PM -0300, Ezequiel Garcia wrote:
>From: Gustavo Padovan <gustavo.padovan@collabora.com>
>
>If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
>an out_fence and send its fd to userspace in the fence_fd field as a
>return arg for the QBUF call.
>
>The fence is signaled on buffer_done(), when the job on the buffer is
>finished.
>
>v11: - Return fence_fd to userpace only in the QBUF ioctl.
>     - Rework implementation to avoid storing the sync_file
>       as state, which is not really needed.
>
>v10: - use -EIO for fence error (Hans Verkuil)
>     - add comment around fence context creation (Hans Verkuil)
>
>v9: - remove in-fences changes from this patch (Alex Courbot)
>    - improve fence context creation (Hans Verkuil)
>    - clean up out fences if vb2_core_qbuf() fails (Hans Verkuil)
>
>v8: - return 0 as fence_fd if OUT_FENCE flag not used (Mauro)
>    - fix crash when checking not using fences in vb2_buffer_done()
>
>v7: - merge patch that add the infrastructure to out-fences into
>      this one (Alex Courbot)
>    - Do not install the fd if there is no fence. (Alex Courbot)
>    - do not report error on requeueing, just WARN_ON_ONCE() (Hans)
>
>v6: - get rid of the V4L2_EVENT_OUT_FENCE event. We always keep the
>      ordering in vb2 for queueing in the driver, so the event is not
>      necessary anymore and the out_fence_fd is sent back to userspace
>      on QBUF call return arg
>    - do not allow requeueing with out-fences, instead mark the buffer
>      with an error and wake up to userspace.
>    - send the out_fence_fd back to userspace on the fence_fd field
>
>v5: - delay fd_install to DQ_EVENT (Hans)
>    - if queue is fully ordered send OUT_FENCE event right away
>      (Brian)
>    - rename 'q->ordered' to 'q->ordered_in_driver'
>    - merge change to implement OUT_FENCE event here
>
>v4: - return the out_fence_fd in the BUF_QUEUED event(Hans)
>
>v3: - add WARN_ON_ONCE(q->ordered) on requeueing (Hans)
>    - set the OUT_FENCE flag if there is a fence pending (Hans)
>    - call fd_install() after vb2_core_qbuf() (Hans)
>    - clean up fence if vb2_core_qbuf() fails (Hans)
>    - add list to store sync_file and fence for the next queued buffer
>
>v2: check if the queue is ordered.
>
>Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
>Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
>---
> drivers/media/common/videobuf2/videobuf2-core.c | 95 +++++++++++++++++++++++--
> drivers/media/common/videobuf2/videobuf2-v4l2.c | 22 +++++-
> drivers/media/dvb-core/dvb_vb2.c                |  2 +-
> include/media/videobuf2-core.h                  | 16 ++++-
> 4 files changed, 127 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
>index 996b99497a98..0f7306a04db7 100644
>--- a/drivers/media/common/videobuf2/videobuf2-core.c
>+++ b/drivers/media/common/videobuf2/videobuf2-core.c
>@@ -25,6 +25,7 @@
> #include <linux/sched.h>
> #include <linux/freezer.h>
> #include <linux/kthread.h>
>+#include <linux/sync_file.h>
>
> #include <media/videobuf2-core.h>
> #include <media/v4l2-mc.h>
>@@ -357,6 +358,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
> 			vb->planes[plane].length = plane_sizes[plane];
> 			vb->planes[plane].min_length = plane_sizes[plane];
> 		}
>+		vb->out_fence_fd = -1;
> 		q->bufs[vb->index] = vb;
>
> 		/* Allocate video buffer memory for the MMAP type */
>@@ -948,10 +950,22 @@ static void vb2_process_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state
> 	case VB2_BUF_STATE_QUEUED:
> 		return;
> 	case VB2_BUF_STATE_REQUEUEING:
>+		/* Requeuing with explicit synchronization, spit warning */
>+		WARN_ON_ONCE(vb->out_fence);
>+
> 		if (q->start_streaming_called)
> 			__enqueue_in_driver(vb);
> 		return;
> 	default:
>+		if (vb->out_fence) {
>+			if (state == VB2_BUF_STATE_ERROR)
>+				dma_fence_set_error(vb->out_fence, -EIO);
>+			dma_fence_signal(vb->out_fence);
>+			dma_fence_put(vb->out_fence);
>+			vb->out_fence = NULL;
>+			vb->out_fence_fd = -1;
>+		}
>+
> 		/* Inform any processes that may be waiting for buffers */
> 		wake_up(&q->done_wq);
> 		break;
>@@ -1367,6 +1381,68 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
> }
> EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
>
>+static inline const char *vb2_fence_get_driver_name(struct dma_fence *fence)
>+{
>+	return "vb2_fence";
>+}
>+
>+static inline const char *vb2_fence_get_timeline_name(struct dma_fence *fence)
>+{
>+	return "vb2_fence_timeline";
>+}
>+
>+static inline bool vb2_fence_enable_signaling(struct dma_fence *fence)
>+{
>+	return true;
>+}
>+
>+static const struct dma_fence_ops vb2_fence_ops = {
>+	.get_driver_name = vb2_fence_get_driver_name,
>+	.get_timeline_name = vb2_fence_get_timeline_name,
>+	.enable_signaling = vb2_fence_enable_signaling,
>+	.wait = dma_fence_default_wait,
>+};
>+
>+static int vb2_setup_out_fence(struct vb2_queue *q, struct vb2_buffer *vb)
>+{
>+	struct sync_file *sync_file;
>+	int ret;
>+
>+	vb->out_fence_fd = get_unused_fd_flags(O_CLOEXEC);

I think you should check the return value here. fd_install() doesn't
seem to do any validation. Best case you hit a BUG_ON(), worst case
you trash something random :-(

>+
>+	/*
>+	 * The same context can be used only if the queue is ordered,
>+	 * so if the queue is ordered create one when the queueing start,
>+	 * otherwise create one for every buffer
>+	 */
>+	if (q->unordered || !q->queueing_started)
>+		q->out_fence_context = dma_fence_context_alloc(1);

Isn't queueing_started always true here? Seems to be set in
vb2_core_qbuf() unconditionally, before vb2_setup_out_fence() is
called.

>+
>+	vb->out_fence = kzalloc(sizeof(*vb->out_fence), GFP_KERNEL);
>+	if (!vb->out_fence) {
>+		ret = -ENOMEM;
>+		goto err_put_fd;
>+	}
>+	dma_fence_init(vb->out_fence, &vb2_fence_ops, &q->out_fence_lock,
>+		       q->out_fence_context, 1);

If the context is shared, we should increment the seqno for every
fence.

Cheers,
-Brian

>+
>+	sync_file = sync_file_create(vb->out_fence);
>+	if (!sync_file) {
>+		ret = -ENOMEM;
>+		goto err_free_fence;
>+	}
>+	fd_install(vb->out_fence_fd, sync_file->file);
>+	return 0;
>+
>+err_free_fence:
>+	dma_fence_put(vb->out_fence);
>+	vb->out_fence = NULL;
>+err_put_fd:
>+	put_unused_fd(vb->out_fence_fd);
>+	vb->out_fence_fd = -1;
>+	return ret;
>+}
>+
> /*
>  * vb2_start_streaming() - Attempt to start streaming.
>  * @q:		videobuf2 queue
>@@ -1463,7 +1539,7 @@ static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
> }
>
> int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>-		  struct dma_fence *in_fence)
>+		  struct dma_fence *in_fence, bool out_fence)
> {
> 	struct vb2_buffer *vb;
> 	unsigned long flags;
>@@ -1496,6 +1572,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> 	list_add_tail(&vb->queued_entry, &q->queued_list);
> 	q->queued_count++;
> 	q->waiting_for_buffers = false;
>+	q->queueing_started = 1;
> 	vb->state = VB2_BUF_STATE_QUEUED;
> 	vb->in_fence = in_fence;
>
>@@ -1555,6 +1632,14 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>
> 	spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
>
>+	if (out_fence) {
>+		ret = vb2_setup_out_fence(q, vb);
>+		if (ret) {
>+			dprintk(1, "failed to set up out-fence\n");
>+			goto err;
>+		}
>+	}
>+
> 	/* Fill buffer information for the userspace */
> 	if (pb)
> 		call_void_bufop(q, fill_user_buffer, vb, pb);
>@@ -1818,6 +1903,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
> 	q->start_streaming_called = 0;
> 	q->queued_count = 0;
> 	q->error = 0;
>+	q->queueing_started = 0;
>
> 	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> 		spin_lock_irqsave(&vb->fence_cb_lock, flags);
>@@ -2170,6 +2256,7 @@ int vb2_core_queue_init(struct vb2_queue *q)
> 	spin_lock_init(&q->done_lock);
> 	mutex_init(&q->mmap_lock);
> 	init_waitqueue_head(&q->done_wq);
>+	spin_lock_init(&q->out_fence_lock);
>
> 	q->memory = VB2_MEMORY_UNKNOWN;
>
>@@ -2421,7 +2508,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
> 		 * Queue all buffers.
> 		 */
> 		for (i = 0; i < q->num_buffers; i++) {
>-			ret = vb2_core_qbuf(q, i, NULL, NULL);
>+			ret = vb2_core_qbuf(q, i, NULL, NULL, false);
> 			if (ret)
> 				goto err_reqbufs;
> 			fileio->bufs[i].queued = 1;
>@@ -2600,7 +2687,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>
> 		if (copy_timestamp)
> 			b->timestamp = ktime_get_ns();
>-		ret = vb2_core_qbuf(q, index, NULL, NULL);
>+		ret = vb2_core_qbuf(q, index, NULL, NULL, false);
> 		dprintk(5, "vb2_dbuf result: %d\n", ret);
> 		if (ret)
> 			return ret;
>@@ -2703,7 +2790,7 @@ static int vb2_thread(void *data)
> 		if (copy_timestamp)
> 			vb->timestamp = ktime_get_ns();
> 		if (!threadio->stop)
>-			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
>+			ret = vb2_core_qbuf(q, vb->index, NULL, NULL, false);
> 		call_void_qop(q, wait_prepare, q);
> 		if (ret || threadio->stop)
> 			break;
>diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>index 74d7062e5285..41a88839683e 100644
>--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>@@ -217,7 +217,11 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
> 	b->sequence = vbuf->sequence;
> 	b->reserved = 0;
>
>-	b->fence_fd = 0;
>+	if (b->flags & V4L2_BUF_FLAG_OUT_FENCE)
>+		b->fence_fd = vb->out_fence_fd;
>+	else
>+		b->fence_fd = 0;
>+
> 	if (vb->in_fence)
> 		b->flags |= V4L2_BUF_FLAG_IN_FENCE;
> 	else
>@@ -496,6 +500,13 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
> 	ret = __verify_planes_array(vb, b);
> 	if (!ret)
> 		vb2_core_querybuf(q, b->index, b);
>+
>+	/*
>+	 * Can't return a fence fd, because it only
>+	 * makes sense on the process that queued the buffer.
>+	 */
>+	if (b->flags & (V4L2_BUF_FLAG_IN_FENCE | V4L2_BUF_FLAG_OUT_FENCE))
>+		b->fence_fd = -1;
> 	return ret;
> }
> EXPORT_SYMBOL(vb2_querybuf);
>@@ -600,7 +611,8 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> 		}
> 	}
>
>-	return vb2_core_qbuf(q, b->index, b, in_fence);
>+	return vb2_core_qbuf(q, b->index, b, in_fence,
>+			     b->flags & V4L2_BUF_FLAG_OUT_FENCE);
> }
> EXPORT_SYMBOL_GPL(vb2_qbuf);
>
>@@ -626,6 +638,12 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
> 	 */
> 	b->flags &= ~V4L2_BUF_FLAG_DONE;
>
>+	/*
>+	 * Can't return a fence fd, because it only
>+	 * makes sense on the process that queued the buffer.
>+	 */
>+	if (b->flags & (V4L2_BUF_FLAG_IN_FENCE | V4L2_BUF_FLAG_OUT_FENCE))
>+		b->fence_fd = -1;
> 	return ret;
> }
> EXPORT_SYMBOL_GPL(vb2_dqbuf);
>diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
>index 7da53f10db1a..053803c9ff45 100644
>--- a/drivers/media/dvb-core/dvb_vb2.c
>+++ b/drivers/media/dvb-core/dvb_vb2.c
>@@ -385,7 +385,7 @@ int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
> {
> 	int ret;
>
>-	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b, NULL);
>+	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b, NULL, false);
> 	if (ret) {
> 		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,
> 			b->index, ret);
>diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>index 28ce8f66882e..794140fcb5cf 100644
>--- a/include/media/videobuf2-core.h
>+++ b/include/media/videobuf2-core.h
>@@ -260,6 +260,9 @@ struct vb2_buffer {
> 	 *			using the buffer (queueing to the driver)
> 	 * fence_cb:		fence callback information
> 	 * fence_cb_lock:	protect callback signal/remove
>+	 * out_fence_fd:	the out_fence_fd to be shared with userspace.
>+	 * out_fence:		the out-fence associated with the buffer once
>+	 *			it is queued to the driver.
> 	 */
> 	enum vb2_buffer_state	state;
>
>@@ -271,6 +274,9 @@ struct vb2_buffer {
> 	struct dma_fence_cb	fence_cb;
> 	spinlock_t              fence_cb_lock;
>
>+	int			out_fence_fd;
>+	struct dma_fence	*out_fence;
>+
> #ifdef CONFIG_VIDEO_ADV_DEBUG
> 	/*
> 	 * Counters for how often these buffer-related ops are
>@@ -533,6 +539,9 @@ struct vb2_buf_ops {
>  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
>  *		last decoded buffer was already dequeued. Set for capture queues
>  *		when a buffer with the %V4L2_BUF_FLAG_LAST is dequeued.
>+ * @queueing_started: if queueing has started. Currently used to determine
>+ *		if an out_fence_context is needed.
>+ * @out_fence_context: the fence context for the out fences
>  * @fileio:	file io emulator internal data, used only if emulator is active
>  * @threadio:	thread io internal data, used only if thread is active
>  */
>@@ -586,6 +595,10 @@ struct vb2_queue {
> 	unsigned int			is_output:1;
> 	unsigned int			copy_timestamp:1;
> 	unsigned int			last_buffer_dequeued:1;
>+	unsigned int			queueing_started:1;
>+
>+	u64				out_fence_context;
>+	spinlock_t			out_fence_lock;
>
> 	struct vb2_fileio_data		*fileio;
> 	struct vb2_threadio_data	*threadio;
>@@ -784,6 +797,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
>  * @pb:		buffer structure passed from userspace to
>  *		v4l2_ioctl_ops->vidioc_qbuf handler in driver
>  * @in_fence:	in-fence to wait on before queueing the buffer
>+ * @out_fence:	create an out-fence as a part of the queue operation
>  *
>  * Videobuf2 core helper to implement VIDIOC_QBUF() operation. It is called
>  * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
>@@ -799,7 +813,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
>  * Return: returns zero on success; an error code otherwise.
>  */
> int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>-		  struct dma_fence *in_fence);
>+		  struct dma_fence *in_fence, bool out_fence);
>
> /**
>  * vb2_core_dqbuf() - Dequeue a buffer to the userspace
>-- 
>2.16.3
>
