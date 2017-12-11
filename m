Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:42921 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752574AbdLKS2O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 13:28:14 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v6 5/6] [media] vb2: add out-fence support to QBUF
Date: Mon, 11 Dec 2017 16:27:40 -0200
Message-Id: <20171211182741.29712-6-gustavo@padovan.org>
In-Reply-To: <20171211182741.29712-1-gustavo@padovan.org>
References: <20171211182741.29712-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
an out_fence and send its fd to userspace on the fence_fd field as a
return arg for the QBUF call.

The fence is signaled on buffer_done(), when the job on the buffer is
finished.

v7:
	- merge patch that add the infrastructure to out-fences into
	this one (Alex Courbot)
	- Do not install the fd if there is no fence. (Alex Courbot)
	- do not report error on requeueing, just WARN_ON_ONCE() (Hans)

v6
	- get rid of the V4L2_EVENT_OUT_FENCE event. We always keep the
	ordering in vb2 for queueing in the driver, so the event is not
	necessary anymore and the out_fence_fd is sent back to userspace
	on QBUF call return arg
	- do not allow requeueing with out-fences, instead mark the buffer
	with an error and wake up to userspace.
	- send the out_fence_fd back to userspace on the fence_fd field

v5:
	- delay fd_install to DQ_EVENT (Hans)
	- if queue is fully ordered send OUT_FENCE event right away
	(Brian)
	- rename 'q->ordered' to 'q->ordered_in_driver'
	- merge change to implement OUT_FENCE event here

v4:
	- return the out_fence_fd in the BUF_QUEUED event(Hans)

v3:	- add WARN_ON_ONCE(q->ordered) on requeueing (Hans)
	- set the OUT_FENCE flag if there is a fence pending (Hans)
	- call fd_install() after vb2_core_qbuf() (Hans)
	- clean up fence if vb2_core_qbuf() fails (Hans)
	- add list to store sync_file and fence for the next queued buffer

v2: check if the queue is ordered.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 99 +++++++++++++++++++++++++++++---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 29 +++++++++-
 include/media/videobuf2-core.h           | 22 +++++++
 3 files changed, 139 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 520aa3c7d9f0..cbe115f00736 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -23,6 +23,7 @@
 #include <linux/sched.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/sync_file.h>
 
 #include <media/videobuf2-core.h>
 #include <media/v4l2-mc.h>
@@ -351,6 +352,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			vb->planes[plane].length = plane_sizes[plane];
 			vb->planes[plane].min_length = plane_sizes[plane];
 		}
+		vb->out_fence_fd = -1;
 		q->bufs[vb->index] = vb;
 
 		/* Allocate video buffer memory for the MMAP type */
@@ -931,10 +933,20 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	case VB2_BUF_STATE_QUEUED:
 		break;
 	case VB2_BUF_STATE_REQUEUEING:
+		/* Requeuing with explicit synchronization, spit warning */
+		WARN_ON_ONCE(vb->out_fence);
+
 		if (q->start_streaming_called)
 			__enqueue_in_driver(vb);
-		return;
+		break;
 	default:
+		if (state == VB2_BUF_STATE_ERROR)
+			dma_fence_set_error(vb->out_fence, -EFAULT);
+		dma_fence_signal(vb->out_fence);
+		dma_fence_put(vb->out_fence);
+		vb->out_fence = NULL;
+		vb->out_fence_fd = -1;
+
 		/* Inform any processes that may be waiting for buffers */
 		wake_up(&q->done_wq);
 		break;
@@ -1330,6 +1342,65 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
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
+int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index)
+{
+	struct vb2_buffer *vb;
+	u64 context;
+
+	vb = q->bufs[index];
+
+	vb->out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
+
+	if (call_qop(q, is_unordered, q))
+		context = dma_fence_context_alloc(1);
+	else
+		context = q->out_fence_context;
+
+	vb->out_fence = kzalloc(sizeof(*vb->out_fence), GFP_KERNEL);
+	if (!vb->out_fence)
+		return -ENOMEM;
+
+	dma_fence_init(vb->out_fence, &vb2_fence_ops, &q->out_fence_lock,
+		       context, 1);
+	if (!vb->out_fence) {
+		put_unused_fd(vb->out_fence_fd);
+		return -ENOMEM;
+	}
+
+	vb->sync_file = sync_file_create(vb->out_fence);
+	if (!vb->sync_file) {
+		put_unused_fd(vb->out_fence_fd);
+		dma_fence_put(vb->out_fence);
+		vb->out_fence = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_setup_out_fence);
+
 /*
  * vb2_start_streaming() - Attempt to start streaming.
  * @q:		videobuf2 queue
@@ -1469,18 +1540,16 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 	if (vb->in_fence) {
 		ret = dma_fence_add_callback(vb->in_fence, &vb->fence_cb,
 					     vb2_qbuf_fence_cb);
-		if (ret == -EINVAL) {
+		/* is the fence signaled? */
+		if (ret == -ENOENT) {
+			dma_fence_put(vb->in_fence);
+			vb->in_fence = NULL;
+		} else if (ret) {
 			spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
 			goto err;
-		} else if (!ret) {
-			goto fill;
 		}
-
-		dma_fence_put(vb->in_fence);
-		vb->in_fence = NULL;
 	}
 
-fill:
 	/*
 	 * If already streaming and there is no fence to wait on
 	 * give the buffer to driver for processing.
@@ -1515,6 +1584,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 	if (pb)
 		call_void_bufop(q, fill_user_buffer, vb, pb);
 
+	if (vb->out_fence) {
+		fd_install(vb->out_fence_fd, vb->sync_file->file);
+		vb->sync_file = NULL;
+	}
+
 	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
 	return 0;
 
@@ -1780,6 +1854,12 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	}
 
 	/*
+	 * Renew out-fence context.
+	 */
+	if (!call_qop(q, is_unordered, q))
+		q->out_fence_context = dma_fence_context_alloc(1);
+
+	/*
 	 * Remove all buffers from videobuf's list...
 	 */
 	INIT_LIST_HEAD(&q->queued_list);
@@ -2111,6 +2191,9 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	spin_lock_init(&q->done_lock);
 	mutex_init(&q->mmap_lock);
 	init_waitqueue_head(&q->done_wq);
+	if (!call_qop(q, is_unordered, q))
+		q->out_fence_context = dma_fence_context_alloc(1);
+	spin_lock_init(&q->out_fence_lock);
 
 	if (q->buf_struct_size == 0)
 		q->buf_struct_size = sizeof(struct vb2_buffer);
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index fa1df42d7250..20b902cfe11a 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -179,12 +179,16 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 		return -EINVAL;
 	}
 
-	if ((b->fence_fd != 0 && b->fence_fd != -1) &&
-	    !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
+	if (b->fence_fd > 0 && !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
 		dprintk(1, "%s: fence_fd set without IN_FENCE flag\n", opname);
 		return -EINVAL;
 	}
 
+	if (b->fence_fd == -1 && (b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
+		dprintk(1, "%s: IN_FENCE flag set but no fence_fd\n", opname);
+		return -EINVAL;
+	}
+
 	return __verify_planes_array(q->bufs[b->index], b);
 }
 
@@ -212,7 +216,13 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->sequence = vbuf->sequence;
 	b->reserved = 0;
 
-	b->fence_fd = -1;
+	if (vb->out_fence) {
+		b->flags |= V4L2_BUF_FLAG_OUT_FENCE;
+		b->fence_fd = vb->out_fence_fd;
+	} else {
+		b->fence_fd = -1;
+	}
+
 	if (vb->in_fence)
 		b->flags |= V4L2_BUF_FLAG_IN_FENCE;
 	else
@@ -489,6 +499,10 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	ret = __verify_planes_array(vb, b);
 	if (!ret)
 		vb2_core_querybuf(q, b->index, b);
+
+	/* Do not return the out-fence fd on querybuf */
+	if (vb->out_fence)
+		b->fence_fd = -1;
 	return ret;
 }
 EXPORT_SYMBOL(vb2_querybuf);
@@ -593,6 +607,15 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		}
 	}
 
+	if (b->flags & V4L2_BUF_FLAG_OUT_FENCE) {
+		ret = vb2_setup_out_fence(q, b->index);
+		if (ret) {
+			dprintk(1, "failed to set up out-fence\n");
+			dma_fence_put(fence);
+			return ret;
+		}
+	}
+
 	return vb2_core_qbuf(q, b->index, b, fence);
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 3c7683630b89..66291c631cd6 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -259,6 +259,10 @@ struct vb2_buffer {
 	 *			using the buffer (queueing to the driver)
 	 * fence_cb:		fence callback information
 	 * fence_cb_lock:	protect callback signal/remove
+	 * out_fence_fd:	the out_fence_fd to be shared with userspace.
+	 * out_fence:		the out-fence associated with the buffer once
+	 *			it is queued to the driver.
+	 * sync_file:		the sync file to wrap the out fence
 	 */
 	enum vb2_buffer_state	state;
 
@@ -269,6 +273,10 @@ struct vb2_buffer {
 	struct dma_fence_cb	fence_cb;
 	spinlock_t              fence_cb_lock;
 
+	int			out_fence_fd;
+	struct dma_fence	*out_fence;
+	struct sync_file	*sync_file;
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these buffer-related ops are
@@ -512,6 +520,7 @@ struct vb2_buf_ops {
  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
  *		last decoded buffer was already dequeued. Set for capture queues
  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
+ * @out_fence_context: the fence context for the out fences
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
  */
@@ -565,6 +574,9 @@ struct vb2_queue {
 	unsigned int			copy_timestamp:1;
 	unsigned int			last_buffer_dequeued:1;
 
+	u64				out_fence_context;
+	spinlock_t			out_fence_lock;
+
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
 
@@ -735,6 +747,16 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
 
 /**
+ * vb2_setup_out_fence() - setup new out-fence
+ * @q:		The vb2_queue where to setup it
+ * @index:	index of the buffer
+ *
+ * Setup the file descriptor, the fence and the sync_file for the next
+ * buffer to be queued and add everything to the tail of the q->out_fence_list.
+ */
+int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index);
+
+/**
  * vb2_core_qbuf() - Queue a buffer from userspace
  *
  * @q:		videobuf2 queue
-- 
2.13.6
