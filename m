Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33190 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751675AbdIABva (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 21:51:30 -0400
Received: by mail-qk0-f194.google.com with SMTP id k126so1008349qkb.0
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 18:51:29 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v2 13/14] [media] vb2: add out-fence support to QBUF
Date: Thu, 31 Aug 2017 22:50:40 -0300
Message-Id: <20170901015041.7757-14-gustavo@padovan.org>
In-Reply-To: <20170901015041.7757-1-gustavo@padovan.org>
References: <20170901015041.7757-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
an out_fence and return it to userspace on the fence_fd field.

The out fence fd returned references the next buffer to be queued to the
driver and not the buffer in the actual QBUF call. So there a list in
videobuf2 core to keep track of the sync_file and fence created and assign
them to buffers when they are queued to the V4L2 driver.

The fence is signaled on buffer_done(), when the job on the buffer is
finished.

v3:	- add WARN_ON_ONCE(q->ordered) on requeueing (Hans)
	- set the OUT_FENCE flag if there is a fence pending (Hans)
	- call fd_install() after vb2_core_qbuf() (Hans)
	- clean up fence if vb2_core_qbuf() fails (Hans)
	- add list to store sync_file and fence for the next queued buffer

v2: check if the queue is ordered.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 85 ++++++++++++++++++++++++++++----
 drivers/media/v4l2-core/videobuf2-v4l2.c | 13 ++++-
 include/media/videobuf2-core.h           | 17 ++++++-
 3 files changed, 104 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 2b9ba3dc23f0..07493c846a8d 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -353,6 +353,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			vb->planes[plane].length = plane_sizes[plane];
 			vb->planes[plane].min_length = plane_sizes[plane];
 		}
+		vb->out_fence_fd = -1;
 		q->bufs[vb->index] = vb;
 
 		/* Allocate video buffer memory for the MMAP type */
@@ -933,10 +934,22 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
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
+		dma_fence_signal(vb->out_fence);
+		dma_fence_put(vb->out_fence);
+		vb->out_fence = NULL;
+		vb->out_fence_fd = -1;
+
 		/* Inform any processes that may be waiting for buffers */
 		wake_up(&q->done_wq);
 		break;
@@ -1224,10 +1237,20 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
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
+		list_del(&fence->entry);
+		kfree(fence);
+	}
+	spin_unlock(&q->out_fence_lock);
+
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->owned_by_drv_count);
 
@@ -1323,25 +1346,36 @@ EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index)
 {
 	struct vb2_buffer *vb = q->bufs[index];
+	struct vb2_fence *fence;
 
 	vb->out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
 	if (vb->out_fence_fd < 0)
 		return vb->out_fence_fd;
 
-	vb->out_fence = vb2_fence_alloc();
-	if (!vb->out_fence)
-		goto err;
+	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
+	if (!fence)
+		goto err_fd;
 
-	vb->sync_file = sync_file_create(vb->out_fence);
-	if (!vb->sync_file) {
-		dma_fence_put(vb->out_fence);
-		vb->out_fence = NULL;
-		goto err;
+	fence->out_fence = vb2_fence_alloc();
+	if (!fence->out_fence)
+		goto err_fence;
+
+	fence->sync_file = sync_file_create(fence->out_fence);
+	if (!fence->sync_file) {
+		dma_fence_put(fence->out_fence);
+		goto err_fence;
 	}
 
+	spin_lock(&q->out_fence_lock);
+	list_add_tail(&fence->entry, &q->out_fence_list);
+	spin_unlock(&q->out_fence_lock);
+
 	return 0;
 
-err:
+err_fence:
+	kfree(fence);
+
+err_fd:
 	put_unused_fd(vb->out_fence_fd);
 	vb->out_fence_fd = -1;
 	return -ENOMEM;
@@ -1425,6 +1459,7 @@ static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 		  struct dma_fence *fence)
 {
+	struct vb2_fence *vb2_fence;
 	struct vb2_buffer *vb;
 	int ret;
 
@@ -1506,6 +1541,16 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 		vb->in_fence = NULL;
 	}
 
+	if (vb->out_fence_fd >= 0) {
+		spin_lock(&q->out_fence_lock);
+		vb2_fence = list_last_entry(&q->out_fence_list,
+					    struct vb2_fence, entry);
+		spin_unlock(&q->out_fence_lock);
+		fd_install(vb->out_fence_fd, vb2_fence->sync_file->file);
+
+		vb2_fence->sync_file = NULL;
+	}
+
 fill:
 	if (q->start_streaming_called && !vb->in_fence)
 		__enqueue_in_driver(vb);
@@ -1523,6 +1568,17 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 		vb->in_fence = NULL;
 	}
 
+	if (vb->out_fence_fd >= 0) {
+		spin_lock(&q->out_fence_lock);
+		vb2_fence = list_last_entry(&q->out_fence_list,
+					    struct vb2_fence, entry);
+		fput(vb2_fence->sync_file->file);
+		list_del(&vb2_fence->entry);
+		kfree(vb2_fence);
+		spin_unlock(&q->out_fence_lock);
+		put_unused_fd(vb->out_fence_fd);
+	}
+
 	return ret;
 
 }
@@ -1736,6 +1792,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 {
 	unsigned int i;
 	struct vb2_buffer *vb;
+	struct vb2_fence *fence, *tmp;
 
 	/*
 	 * Tell driver to stop all transactions and release all queued
@@ -1766,6 +1823,13 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 		}
 	}
 
+	spin_lock(&q->out_fence_lock);
+	list_for_each_entry_safe(fence, tmp, &q->out_fence_list, entry) {
+		list_del(&fence->entry);
+		kfree(fence);
+	}
+	spin_unlock(&q->out_fence_lock);
+
 	q->streaming = 0;
 	q->start_streaming_called = 0;
 	q->queued_count = 0;
@@ -1780,6 +1844,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 * has not already dequeued before initiating cancel.
 	 */
 	INIT_LIST_HEAD(&q->done_list);
+	INIT_LIST_HEAD(&q->out_fence_list);
 	atomic_set(&q->owned_by_drv_count, 0);
 	wake_up_all(&q->done_wq);
 
@@ -2101,6 +2166,8 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
 	spin_lock_init(&q->done_lock);
+	INIT_LIST_HEAD(&q->out_fence_list);
+	spin_lock_init(&q->out_fence_lock);
 	mutex_init(&q->mmap_lock);
 	init_waitqueue_head(&q->done_wq);
 
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 1c93bfedaffc..788372e4d0c9 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -223,7 +223,9 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->sequence = vbuf->sequence;
 	b->reserved = 0;
 
-	b->fence_fd = -1;
+	b->fence_fd = vb->out_fence_fd;
+	if (vb->out_fence_fd)
+		b->flags |= V4L2_BUF_FLAG_OUT_FENCE;
 	if (vb->in_fence)
 		b->flags |= V4L2_BUF_FLAG_IN_FENCE;
 	else
@@ -604,6 +606,15 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
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
index bf2f0499c737..a13a080d6c51 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -265,7 +265,6 @@ struct vb2_buffer {
 	struct dma_fence_cb	fence_cb;
 
 	struct dma_fence	*out_fence;
-	struct sync_file	*sync_file;
 	int			out_fence_fd;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
@@ -428,6 +427,17 @@ struct vb2_buf_ops {
 	void (*buffer_queued)(struct vb2_buffer *vb);
 };
 
+/*
+ * struct vb2_fence - fence related data
+ *
+ * XXX
+ */
+struct vb2_fence {
+	struct dma_fence *out_fence;
+	struct sync_file *sync_file;
+	struct list_head entry;
+};
+
 /**
  * struct vb2_queue - a videobuf queue
  *
@@ -495,6 +505,8 @@ struct vb2_buf_ops {
  * @done_list:	list of buffers ready to be dequeued to userspace
  * @done_lock:	lock to protect done_list list
  * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
+ * @out_fence_list: list of out fences waiting to be assigned to a buffer
+ * @out_fence_lock: lock to protect out_fence_list
  * @alloc_devs:	memory type/allocator-specific per-plane device
  * @streaming:	current streaming state
  * @start_streaming_called: @start_streaming was called successfully and we
@@ -554,6 +566,9 @@ struct vb2_queue {
 	spinlock_t			done_lock;
 	wait_queue_head_t		done_wq;
 
+	struct list_head		out_fence_list;
+	spinlock_t			out_fence_lock;
+
 	struct device			*alloc_devs[VB2_MAX_PLANES];
 
 	unsigned int			streaming:1;
-- 
2.13.5
