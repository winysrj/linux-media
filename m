Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34727 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdIABu5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 21:50:57 -0400
Received: by mail-qt0-f194.google.com with SMTP id v20so1015418qtg.1
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 18:50:57 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v2 03/14] [media] vb2: add in-fence support to QBUF
Date: Thu, 31 Aug 2017 22:50:30 -0300
Message-Id: <20170901015041.7757-4-gustavo@padovan.org>
In-Reply-To: <20170901015041.7757-1-gustavo@padovan.org>
References: <20170901015041.7757-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Receive in-fence from userspace and add support for waiting on them
before queueing the buffer to the driver. Buffers are only queued
to the driver once they are ready. A buffer is ready when its
in-fence signals.

v4:
	- Add a comment about dma_fence_add_callback() not returning a
	error (Hans)
	- Call dma_fence_put(vb->in_fence) if fence signaled (Hans)
	- select SYNC_FILE under config VIDEOBUF2_CORE (Hans)
	- Move dma_fence_is_signaled() check to __enqueue_in_driver() (Hans)
	- Remove list_for_each_entry() in __vb2_core_qbuf() (Hans)
	-  Remove if (vb->state != VB2_BUF_STATE_QUEUED) from
	vb2_start_streaming() (Hans)
	- set IN_FENCE flags on __fill_v4l2_buffer (Hans)
	- Queue buffers to the driver as soon as they are ready (Hans)
	- call fill_user_buffer() after queuing the buffer (Hans)
	- add err: label to clean up fence
	- add dma_fence_wait() before calling vb2_start_streaming()

v3:	- document fence parameter
	- remove ternary if at vb2_qbuf() return (Mauro)
	- do not change if conditions behaviour (Mauro)

v2:
	- fix vb2_queue_or_prepare_buf() ret check
	- remove check for VB2_MEMORY_DMABUF only (Javier)
	- check num of ready buffers to start streaming
	- when queueing, start from the first ready buffer
	- handle queue cancel

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/Kconfig          |   1 +
 drivers/media/v4l2-core/videobuf2-core.c | 103 +++++++++++++++++++++++++++----
 drivers/media/v4l2-core/videobuf2-v4l2.c |  27 +++++++-
 include/media/videobuf2-core.h           |   8 ++-
 4 files changed, 124 insertions(+), 15 deletions(-)

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index a35c33686abf..3f988c407c80 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -83,6 +83,7 @@ config VIDEOBUF_DVB
 # Used by drivers that need Videobuf2 modules
 config VIDEOBUF2_CORE
 	select DMA_SHARED_BUFFER
+	select SYNC_FILE
 	tristate
 
 config VIDEOBUF2_MEMOPS
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 60f8b582396a..b19c1bc4b083 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1222,6 +1222,9 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 
+	if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
+		return;
+
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->owned_by_drv_count);
 
@@ -1273,6 +1276,20 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 	return 0;
 }
 
+static int __get_num_ready_buffers(struct vb2_queue *q)
+{
+	struct vb2_buffer *vb;
+	int ready_count = 0;
+
+	/* count num of buffers ready in front of the queued_list */
+	list_for_each_entry(vb, &q->queued_list, queued_entry) {
+		if (!vb->in_fence || dma_fence_is_signaled(vb->in_fence))
+			ready_count++;
+	}
+
+	return ready_count;
+}
+
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
@@ -1361,7 +1378,19 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
+static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
+{
+	struct vb2_buffer *vb = container_of(cb, struct vb2_buffer, fence_cb);
+
+	dma_fence_put(vb->in_fence);
+	vb->in_fence = NULL;
+
+	if (vb->vb2_queue->start_streaming_called)
+		__enqueue_in_driver(vb);
+}
+
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  struct dma_fence *fence)
 {
 	struct vb2_buffer *vb;
 	int ret;
@@ -1372,16 +1401,18 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	case VB2_BUF_STATE_DEQUEUED:
 		ret = __buf_prepare(vb, pb);
 		if (ret)
-			return ret;
+			goto err;
 		break;
 	case VB2_BUF_STATE_PREPARED:
 		break;
 	case VB2_BUF_STATE_PREPARING:
 		dprintk(1, "buffer still being prepared\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	default:
 		dprintk(1, "invalid buffer state %d\n", vb->state);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	/*
@@ -1392,6 +1423,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	q->queued_count++;
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
+	vb->in_fence = fence;
 
 	if (pb)
 		call_void_bufop(q, copy_timestamp, vb, pb);
@@ -1399,6 +1431,16 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	trace_vb2_qbuf(q, vb);
 
 	/*
+	 * If it is time to call vb2_start_streaming() wait for the fence
+	 * to signal first. Of course, this happens only once per streaming.
+	 * We want to run any step that might fail before we set the callback
+	 * to queue the fence when it signals.
+	 */
+	if (fence && !q->start_streaming_called &&
+	    __get_num_ready_buffers(q) == q->min_buffers_needed - 1)
+		dma_fence_wait(fence, true);
+
+	/*
 	 * If streamon has been called, and we haven't yet called
 	 * start_streaming() since not enough buffers were queued, and
 	 * we now have reached the minimum number of queued buffers,
@@ -1408,20 +1450,48 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	 * If not, the buffer will be given to driver on next streamon.
 	 */
 	if (q->streaming && !q->start_streaming_called &&
-	    q->queued_count >= q->min_buffers_needed) {
+	    __get_num_ready_buffers(q) >= q->min_buffers_needed) {
 		ret = vb2_start_streaming(q);
 		if (ret)
-			return ret;
-	} else if (q->start_streaming_called) {
-		__enqueue_in_driver(vb);
+			goto err;
 	}
 
+	/*
+	 * For explicit synchronization: If the fence didn't signal
+	 * yet we setup a callback to queue the buffer once the fence
+	 * signals, and then, return successfully. But if the fence
+	 * already signaled we lose the reference we held and queue the
+	 * buffer to the driver.
+	 */
+	if (fence) {
+		ret = dma_fence_add_callback(fence, &vb->fence_cb,
+					     vb2_qbuf_fence_cb);
+		if (!ret)
+			goto fill;
+
+		dma_fence_put(fence);
+		vb->in_fence = NULL;
+	}
+
+fill:
+	if (q->start_streaming_called && !vb->in_fence)
+		__enqueue_in_driver(vb);
+
 	/* Fill buffer information for the userspace */
 	if (pb)
 		call_void_bufop(q, fill_user_buffer, vb, pb);
 
 	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
 	return 0;
+
+err:
+	if (vb->in_fence) {
+		dma_fence_put(vb->in_fence);
+		vb->in_fence = NULL;
+	}
+
+	return ret;
+
 }
 EXPORT_SYMBOL_GPL(vb2_core_qbuf);
 
@@ -1632,6 +1702,7 @@ EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
 static void __vb2_queue_cancel(struct vb2_queue *q)
 {
 	unsigned int i;
+	struct vb2_buffer *vb;
 
 	/*
 	 * Tell driver to stop all transactions and release all queued
@@ -1654,6 +1725,14 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
 
+	list_for_each_entry(vb, &q->queued_list, queued_entry) {
+		if (vb->in_fence) {
+			dma_fence_remove_callback(vb->in_fence, &vb->fence_cb);
+			dma_fence_put(vb->in_fence);
+			vb->in_fence = NULL;
+		}
+	}
+
 	q->streaming = 0;
 	q->start_streaming_called = 0;
 	q->queued_count = 0;
@@ -1720,7 +1799,7 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 	 * Tell driver to start streaming provided sufficient buffers
 	 * are available.
 	 */
-	if (q->queued_count >= q->min_buffers_needed) {
+	if (__get_num_ready_buffers(q) >= q->min_buffers_needed) {
 		ret = v4l_vb2q_enable_media_source(q);
 		if (ret)
 			return ret;
@@ -2240,7 +2319,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		 * Queue all buffers.
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
-			ret = vb2_core_qbuf(q, i, NULL);
+			ret = vb2_core_qbuf(q, i, NULL, NULL);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2419,7 +2498,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 
 		if (copy_timestamp)
 			b->timestamp = ktime_get_ns();
-		ret = vb2_core_qbuf(q, index, NULL);
+		ret = vb2_core_qbuf(q, index, NULL, NULL);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -2522,7 +2601,7 @@ static int vb2_thread(void *data)
 		if (copy_timestamp)
 			vb->timestamp = ktime_get_ns();;
 		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, vb->index, NULL);
+			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 110fb45fef6f..8c322cd1b346 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -23,6 +23,7 @@
 #include <linux/sched.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/sync_file.h>
 
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
@@ -178,6 +179,11 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 		return -EINVAL;
 	}
 
+	if ((b->fence_fd != -1) && !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
+		dprintk(1, "%s: fence_fd set without IN_FENCE flag\n", opname);
+		return -EINVAL;
+	}
+
 	return __verify_planes_array(q->bufs[b->index], b);
 }
 
@@ -203,9 +209,14 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->timestamp = ns_to_timeval(vb->timestamp);
 	b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
-	b->fence_fd = -1;
 	b->reserved = 0;
 
+	b->fence_fd = -1;
+	if (vb->in_fence)
+		b->flags |= V4L2_BUF_FLAG_IN_FENCE;
+	else
+		b->flags &= ~V4L2_BUF_FLAG_IN_FENCE;
+
 	if (q->is_multiplanar) {
 		/*
 		 * Fill in plane-related data if userspace provided an array
@@ -560,6 +571,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
+	struct dma_fence *fence = NULL;
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
@@ -568,7 +580,18 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	}
 
 	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-	return ret ? ret : vb2_core_qbuf(q, b->index, b);
+	if (ret)
+		return ret;
+
+	if (b->flags & V4L2_BUF_FLAG_IN_FENCE) {
+		fence = sync_file_get_fence(b->fence_fd);
+		if (!fence) {
+			dprintk(1, "failed to get in-fence from fd\n");
+			return -EINVAL;
+		}
+	}
+
+	return vb2_core_qbuf(q, b->index, b, fence);
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ef9b64398c8c..cad45e49a46d 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/poll.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-fence.h>
 
 #define VB2_MAX_FRAME	(32)
 #define VB2_MAX_PLANES	(8)
@@ -259,6 +260,9 @@ struct vb2_buffer {
 
 	struct list_head	queued_entry;
 	struct list_head	done_entry;
+
+	struct dma_fence	*in_fence;
+	struct dma_fence_cb	fence_cb;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these buffer-related ops are
@@ -726,6 +730,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  * @index:	id number of the buffer
  * @pb:		buffer structure passed from userspace to vidioc_qbuf handler
  *		in driver
+ * @fence:	in-fence to wait on before queueing the buffer
  *
  * Should be called from vidioc_qbuf ioctl handler of a driver.
  * The passed buffer should have been verified.
@@ -740,7 +745,8 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  * The return values from this function are intended to be directly returned
  * from vidioc_qbuf handler in driver.
  */
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  struct dma_fence *fence);
 
 /**
  * vb2_core_dqbuf() - Dequeue a buffer to the userspace
-- 
2.13.5
