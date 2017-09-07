Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36643 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932316AbdIGSnb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 14:43:31 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v3 15/15] [media] vb2: add out-fence support to QBUF
Date: Thu,  7 Sep 2017 15:42:26 -0300
Message-Id: <20170907184226.27482-16-gustavo@padovan.org>
In-Reply-To: <20170907184226.27482-1-gustavo@padovan.org>
References: <20170907184226.27482-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
an out_fence and sent to userspace on the V4L2_EVENT_BUF_QUEUED when
the buffer is queued to the driver.

The out fence fd returned references the next buffer to be queued to the
driver and not the buffer in the actual QBUF call. So there a list in
videobuf2 core to keep track of the sync_file and fence created and assign
them to buffers when they are queued to the V4L2 driver.

The fence is signaled on buffer_done(), when the job on the buffer is
finished.

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
 drivers/media/v4l2-core/videobuf2-core.c | 51 ++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c | 24 ++++++++++++++-
 include/media/videobuf2-core.h           | 11 +++++++
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 34adf1916194..ab58170776bc 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -25,6 +25,7 @@
 #include <linux/kthread.h>
 #include <linux/sync_file.h>
 #include <linux/dma-fence.h>
+#include <linux/fdtable.h>
 
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-fence.h>
@@ -353,6 +354,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			vb->planes[plane].length = plane_sizes[plane];
 			vb->planes[plane].min_length = plane_sizes[plane];
 		}
+		vb->out_fence_fd = -1;
 		q->bufs[vb->index] = vb;
 
 		/* Allocate video buffer memory for the MMAP type */
@@ -933,10 +935,24 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	case VB2_BUF_STATE_QUEUED:
 		return;
 	case VB2_BUF_STATE_REQUEUEING:
+		/*
+		 * Explicit synchronization requires ordered queues for now,
+		 * so WARN_ON if we are requeuing on an ordered queue.
+		 */
+		if (vb->out_fence)
+			WARN_ON_ONCE(q->ordered);
+
 		if (q->start_streaming_called)
 			__enqueue_in_driver(vb);
 		return;
 	default:
+		if (state == VB2_BUF_STATE_ERROR)
+			dma_fence_set_error(vb->out_fence, -ENOENT);
+		dma_fence_signal(vb->out_fence);
+		dma_fence_put(vb->out_fence);
+		vb->out_fence = NULL;
+		vb->out_fence_fd = -1;
+
 		/* Inform any processes that may be waiting for buffers */
 		wake_up(&q->done_wq);
 		break;
@@ -1224,10 +1240,21 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 static void __enqueue_in_driver(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_fence *fence;
 
 	if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
 		return;
 
+	spin_lock(&q->out_fence_lock);
+	fence = list_first_entry(&q->out_fence_list, struct vb2_fence, entry);
+	if (fence) {
+		vb->out_fence = dma_fence_get(fence->out_fence);
+		vb->out_fence_fd = fence->out_fence_fd;
+		list_del(&fence->entry);
+		kfree(fence);
+	}
+	spin_unlock(&q->out_fence_lock);
+
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->owned_by_drv_count);
 
@@ -1348,6 +1375,8 @@ int vb2_setup_out_fence(struct vb2_queue *q)
 	list_add_tail(&fence->entry, &q->out_fence_list);
 	spin_unlock(&q->out_fence_lock);
 
+	fence->files = current->files;
+
 	return 0;
 
 err_fence:
@@ -1450,6 +1479,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 		  struct dma_fence *fence)
 {
 	struct vb2_buffer *vb;
+	struct vb2_fence *vb2_fence;
 	int ret;
 
 	vb = q->bufs[index];
@@ -1513,6 +1543,15 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 			goto err;
 	}
 
+	spin_lock(&q->out_fence_lock);
+	vb2_fence = list_last_entry(&q->out_fence_list, struct vb2_fence,
+				     entry);
+	spin_unlock(&q->out_fence_lock);
+	if (vb2_fence)
+		fd_install(vb2_fence->out_fence_fd,
+			   vb2_fence->sync_file->file);
+
+
 	/*
 	 * For explicit synchronization: If the fence didn't signal
 	 * yet we setup a callback to queue the buffer once the fence
@@ -1760,6 +1799,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 {
 	unsigned int i;
 	struct vb2_buffer *vb;
+	struct vb2_fence *fence, *tmp;
 
 	/*
 	 * Tell driver to stop all transactions and release all queued
@@ -1790,6 +1830,14 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 		}
 	}
 
+	spin_lock(&q->out_fence_lock);
+	list_for_each_entry_safe(fence, tmp, &q->out_fence_list, entry) {
+		close_fd(fence->files, fence->out_fence_fd);
+		list_del(&fence->entry);
+		kfree(fence);
+	}
+	spin_unlock(&q->out_fence_lock);
+
 	q->streaming = 0;
 	q->start_streaming_called = 0;
 	q->queued_count = 0;
@@ -1804,6 +1852,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 * has not already dequeued before initiating cancel.
 	 */
 	INIT_LIST_HEAD(&q->done_list);
+	INIT_LIST_HEAD(&q->out_fence_list);
 	atomic_set(&q->owned_by_drv_count, 0);
 	wake_up_all(&q->done_wq);
 
@@ -2125,6 +2174,8 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
 	spin_lock_init(&q->done_lock);
+	INIT_LIST_HEAD(&q->out_fence_list);
+	spin_lock_init(&q->out_fence_lock);
 	mutex_init(&q->mmap_lock);
 	init_waitqueue_head(&q->done_wq);
 
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index bbfcd054e6f6..e1ca48ab5005 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -147,6 +147,7 @@ static void __buffer_queued(struct vb2_buffer *vb)
 	memset(&event, 0, sizeof(event));
 	event.type = V4L2_EVENT_BUF_QUEUED;
 	event.u.buf_queued.index = vb->index;
+	event.u.buf_queued.out_fence_fd = vb->out_fence_fd;
 
 	v4l2_event_queue_fh(fh, &event);
 }
@@ -197,6 +198,12 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 		return -EINVAL;
 	}
 
+	if (!q->ordered && (b->flags & V4L2_BUF_FLAG_OUT_FENCE)) {
+		dprintk(1, "%s: out-fence doesn't work on unordered queues\n",
+			opname);
+		return -EINVAL;
+	}
+
 	return __verify_planes_array(q->bufs[b->index], b);
 }
 
@@ -225,6 +232,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->reserved = 0;
 
 	b->fence_fd = -1;
+	if (vb->out_fence_fd)
+		b->flags |= V4L2_BUF_FLAG_OUT_FENCE;
 	if (vb->in_fence)
 		b->flags |= V4L2_BUF_FLAG_IN_FENCE;
 	else
@@ -605,7 +614,20 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		}
 	}
 
-	return vb2_core_qbuf(q, b->index, b, fence);
+	if (b->flags & V4L2_BUF_FLAG_OUT_FENCE) {
+		ret = vb2_setup_out_fence(q);
+		if (ret) {
+			dprintk(1, "failed to set up out-fence\n");
+			dma_fence_put(fence);
+			return ret;
+		}
+	}
+
+	ret = vb2_core_qbuf(q, b->index, b, fence);
+	if (ret && (b->flags & V4L2_BUF_FLAG_OUT_FENCE))
+		vb2_cleanup_out_fence(q);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 84e5e7216a1e..9ad774f796bb 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -258,6 +258,9 @@ struct vb2_buffer {
 	 * in_fence:		fence receive from vb2 client to wait on before
 	 *			using the buffer (queueing to the driver)
 	 * fence_cb:		fence callback information
+	 * out_fence:		the out-fence associated with the buffer once
+	 *			it is queued to the driver.
+	 * out_fence_fd:	the out_fence_fd to be shared with userspace.
 	 */
 	enum vb2_buffer_state	state;
 
@@ -266,6 +269,9 @@ struct vb2_buffer {
 
 	struct dma_fence	*in_fence;
 	struct dma_fence_cb	fence_cb;
+
+	struct dma_fence	*out_fence;
+	int			out_fence_fd;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these buffer-related ops are
@@ -512,6 +518,8 @@ struct vb2_fence {
  * @done_list:	list of buffers ready to be dequeued to userspace
  * @done_lock:	lock to protect done_list list
  * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
+ * @out_fence_list: list of out fences waiting to be assigned to a buffer
+ * @out_fence_lock: lock to protect out_fence_list
  * @alloc_devs:	memory type/allocator-specific per-plane device
  * @streaming:	current streaming state
  * @start_streaming_called: @start_streaming was called successfully and we
@@ -571,6 +579,9 @@ struct vb2_queue {
 	spinlock_t			done_lock;
 	wait_queue_head_t		done_wq;
 
+	struct list_head		out_fence_list;
+	spinlock_t			out_fence_lock;
+
 	struct device			*alloc_devs[VB2_MAX_PLANES];
 
 	unsigned int			streaming:1;
-- 
2.13.5
