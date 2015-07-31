Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49735 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbbGaIom (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2015 04:44:42 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NSC015LGGAG3U30@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Jul 2015 17:44:40 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, jh1009.sung@samsung.com
Subject: [RFC PATCH v2 4/5] media: videobuf2: Define vb2_buf_type and vb2_memory
Date: Fri, 31 Jul 2015 17:44:36 +0900
Message-id: <1438332277-6542-5-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define enum vb2_buf_type and enum vb2_memory for videobuf2-core. This
change requires translation functions that could covert v4l2-core stuffs
to videobuf2-core stuffs in videobuf2-v4l2.c file.
The v4l2-specific member variables(e.g. type, memory) remains in
struct vb2_queue for backward compatibility and performance of type translation.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |  139 +++++++++++---------
 drivers/media/v4l2-core/videobuf2-v4l2.c |  209 ++++++++++++++++++++----------
 include/media/videobuf2-core.h           |   99 +++++++++++---
 include/media/videobuf2-v4l2.h           |   12 +-
 4 files changed, 299 insertions(+), 160 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 0460a99..7888338 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -26,10 +26,9 @@
 
 #include <media/videobuf2-core.h>
 
-#include <trace/events/v4l2.h>
-
 int vb2_debug;
 module_param_named(debug, vb2_debug, int, 0644);
+EXPORT_SYMBOL_GPL(vb2_debug);
 
 static void __enqueue_in_driver(struct vb2_buffer *vb);
 static void __vb2_queue_cancel(struct vb2_queue *q);
@@ -41,7 +40,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+		VB2_TYPE_IS_OUTPUT(q->vb2_type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
 	int plane;
 
@@ -120,6 +119,7 @@ void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
 	dma_buf_put(p->dbuf);
 	memset(p, 0, sizeof(*p));
 }
+EXPORT_SYMBOL_GPL(__vb2_plane_dmabuf_put);
 
 /**
  * __vb2_buf_dmabuf_put() - release memory associated with
@@ -132,6 +132,7 @@ void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane)
 		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
 }
+EXPORT_SYMBOL_GPL(__vb2_buf_dmabuf_put);
 
 /**
  * __setup_lengths() - setup initial lengths for every plane in
@@ -196,7 +197,7 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
  *
  * Returns the number of buffers successfully allocated.
  */
-static int __vb2_queue_alloc(struct vb2_queue *q, unsigned int memory,
+static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			     unsigned int num_buffers, unsigned int num_planes)
 {
 	unsigned int buffer;
@@ -214,11 +215,11 @@ static int __vb2_queue_alloc(struct vb2_queue *q, unsigned int memory,
 		vb->state = VB2_BUF_STATE_DEQUEUED;
 		vb->vb2_queue = q;
 		vb->num_planes = num_planes;
-		call_bufop(q, init_buffer, vb, memory, q->type,
+		call_bufop(q, init_buffer, vb, memory,
 				q->num_buffers + buffer, num_planes);
 
 		/* Allocate video buffer memory for the MMAP type */
-		if (memory == V4L2_MEMORY_MMAP) {
+		if (memory == VB2_MEMORY_MMAP) {
 			ret = __vb2_buf_mem_alloc(vb);
 			if (ret) {
 				VB2_DEBUG(1, "failed allocating memory for "
@@ -245,7 +246,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, unsigned int memory,
 	}
 
 	__setup_lengths(q, buffer);
-	if (memory == V4L2_MEMORY_MMAP)
+	if (memory == VB2_MEMORY_MMAP)
 		__setup_offsets(q, buffer);
 
 	VB2_DEBUG(1, "allocated %d buffers, %d plane(s) each\n",
@@ -269,9 +270,9 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
 			continue;
 
 		/* Free MMAP buffers or release USERPTR buffers */
-		if (q->memory == V4L2_MEMORY_MMAP)
+		if (q->vb2_memory == VB2_MEMORY_MMAP)
 			__vb2_buf_mem_free(vb);
-		else if (q->memory == V4L2_MEMORY_DMABUF)
+		else if (q->vb2_memory == VB2_MEMORY_DMABUF)
 			__vb2_buf_dmabuf_put(vb);
 		else
 			__vb2_buf_userptr_put(vb);
@@ -388,7 +389,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 
 	q->num_buffers -= buffers;
 	if (!q->num_buffers) {
-		q->memory = 0;
+		q->vb2_memory = 0;
 		INIT_LIST_HEAD(&q->queued_list);
 	}
 	return 0;
@@ -414,6 +415,7 @@ bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 	}
 	return false;
 }
+EXPORT_SYMBOL_GPL(__buffer_in_use);
 
 /**
  * __buffers_in_use() - return true if any buffers on the queue are in use and
@@ -432,7 +434,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
 /**
  * vb2_core_querybuf() - query video buffer information
  * @q:		videobuf queue
- * @type:	enum v4l2_buf_type; buffer type (type == *_MPLANE for
+ * @type:	enum vb2_buf_type; buffer type (type == *_MPLANE for
  *		multiplanar buffers);
  * @index:	id number of the buffer
  * @pb:		private buffer struct passed from userspace to vidioc_querybuf
@@ -445,13 +447,13 @@ static bool __buffers_in_use(struct vb2_queue *q)
  * The return values from this function are intended to be directly returned
  * from vidioc_querybuf handler in driver.
  */
-int vb2_core_querybuf(struct vb2_queue *q, unsigned int type,
+int vb2_core_querybuf(struct vb2_queue *q, enum vb2_buf_type type,
 		unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
 	int ret;
 
-	if (type != q->type) {
+	if (type != q->vb2_type) {
 		VB2_DEBUG(1, "wrong buffer type\n");
 		return -EINVAL;
 	}
@@ -467,6 +469,7 @@ int vb2_core_querybuf(struct vb2_queue *q, unsigned int type,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_core_querybuf);
 
 /**
  * __verify_userptr_ops() - verify that all memory operations required for
@@ -513,15 +516,15 @@ static int __verify_dmabuf_ops(struct vb2_queue *q)
  * passed to a buffer operation are compatible with the queue.
  */
 int __verify_memory_type(struct vb2_queue *q,
-		unsigned int memory, enum v4l2_buf_type type)
+		enum vb2_memory memory, enum vb2_buf_type type)
 {
-	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR &&
-	    memory != V4L2_MEMORY_DMABUF) {
+	if (memory != VB2_MEMORY_MMAP && memory != VB2_MEMORY_USERPTR &&
+	    memory != VB2_MEMORY_DMABUF) {
 		VB2_DEBUG(1, "unsupported memory type\n");
 		return -EINVAL;
 	}
 
-	if (type != q->type) {
+	if (type != q->vb2_type) {
 		VB2_DEBUG(1, "requested type is incorrect\n");
 		return -EINVAL;
 	}
@@ -530,17 +533,17 @@ int __verify_memory_type(struct vb2_queue *q,
 	 * Make sure all the required memory ops for given memory type
 	 * are available.
 	 */
-	if (memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
+	if (memory == VB2_MEMORY_MMAP && __verify_mmap_ops(q)) {
 		VB2_DEBUG(1, "MMAP for current setup unsupported\n");
 		return -EINVAL;
 	}
 
-	if (memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
+	if (memory == VB2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
 		VB2_DEBUG(1, "USERPTR for current setup unsupported\n");
 		return -EINVAL;
 	}
 
-	if (memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
+	if (memory == VB2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
 		VB2_DEBUG(1, "DMABUF for current setup unsupported\n");
 		return -EINVAL;
 	}
@@ -556,7 +559,7 @@ int __verify_memory_type(struct vb2_queue *q,
 	}
 	return 0;
 }
-
+EXPORT_SYMBOL_GPL(__verify_memory_type);
 
 /**
  * vb2_core_reqbufs() - Initiate streaming
@@ -581,7 +584,8 @@ int __verify_memory_type(struct vb2_queue *q,
  * The return values from this function are intended to be directly returned
  * from vidioc_reqbufs handler in driver.
  */
-int vb2_core_reqbufs(struct vb2_queue *q, unsigned int memory, unsigned int *count)
+int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
+		unsigned int *count)
 {
 	unsigned int num_buffers, allocated_buffers, num_planes = 0;
 	int ret;
@@ -591,13 +595,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, unsigned int memory, unsigned int *cou
 		return -EBUSY;
 	}
 
-	if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
+	if (*count == 0 || q->num_buffers != 0 || q->vb2_memory != memory) {
 		/*
 		 * We already have buffers allocated, so first check if they
 		 * are not in use and can be freed.
 		 */
 		mutex_lock(&q->mmap_lock);
-		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
+		if (q->vb2_memory == VB2_MEMORY_MMAP && __buffers_in_use(q)) {
 			mutex_unlock(&q->mmap_lock);
 			VB2_DEBUG(1, "memory in use, cannot free\n");
 			return -EBUSY;
@@ -625,11 +629,11 @@ int vb2_core_reqbufs(struct vb2_queue *q, unsigned int memory, unsigned int *cou
 	/*
 	 * Make sure the requested values and current defaults are sane.
 	 */
-	num_buffers = min_t(unsigned int, *count, VIDEO_MAX_FRAME);
+	num_buffers = min_t(unsigned int, *count, VB2_MAX_FRAME);
 	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
 	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
-	q->memory = memory;
+	q->vb2_memory = memory;
 
 	/*
 	 * Ask the driver how many buffers and planes per buffer it requires.
@@ -691,10 +695,11 @@ int vb2_core_reqbufs(struct vb2_queue *q, unsigned int memory, unsigned int *cou
 	 * to the userspace.
 	 */
 	*count = allocated_buffers;
-	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	q->waiting_for_buffers = !VB2_TYPE_IS_OUTPUT(q->vb2_type);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
 
 /**
  * vb2_core_create_bufs() - Allocate buffers and any required auxiliary structs
@@ -711,13 +716,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, unsigned int memory, unsigned int *cou
  * The return values from this function are intended to be directly returned
  * from vidioc_create_bufs handler in driver.
  */
-int vb2_core_create_bufs(struct vb2_queue *q, unsigned int memory,
+int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count, void *parg)
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
 	int ret;
 
-	if (q->num_buffers == VIDEO_MAX_FRAME) {
+	if (q->num_buffers == VB2_MAX_FRAME) {
 		VB2_DEBUG(1, "maximum number of buffers already allocated\n");
 		return -ENOBUFS;
 	}
@@ -725,11 +730,11 @@ int vb2_core_create_bufs(struct vb2_queue *q, unsigned int memory,
 	if (!q->num_buffers) {
 		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
-		q->memory = memory;
-		q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+		q->vb2_memory = memory;
+		q->waiting_for_buffers = !VB2_TYPE_IS_OUTPUT(q->vb2_type);
 	}
 
-	num_buffers = min(*count, VIDEO_MAX_FRAME - q->num_buffers);
+	num_buffers = min(*count, VB2_MAX_FRAME - q->num_buffers);
 
 	/*
 	 * Ask the driver, whether the requested number of buffers, planes per
@@ -792,6 +797,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, unsigned int memory,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
 
 /**
  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
@@ -887,7 +893,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	atomic_dec(&q->owned_by_drv_count);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
-	trace_vb2_buf_done(q, vb);
+	trace_op(q, buf_done, q, vb);
 
 	if (state == VB2_BUF_STATE_QUEUED) {
 		if (q->start_streaming_called)
@@ -935,7 +941,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->owned_by_drv_count);
 
-	trace_vb2_buf_queue(q, vb);
+	trace_op(q, buf_queue, q, vb);
 
 	/* sync buffers */
 	for (plane = 0; plane < vb->num_planes; ++plane)
@@ -944,11 +950,11 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 	call_void_vb_qop(vb, buf_queue, vb);
 }
 
-static int vb2_queue_or_prepare_buf(struct vb2_queue *q, unsigned int memory,
-		unsigned int type, unsigned int index, void *pb,
+static int vb2_queue_or_prepare_buf(struct vb2_queue *q, enum vb2_memory memory,
+		enum vb2_buf_type type, unsigned int index, void *pb,
 		const char *opname)
 {
-	if (type != q->type) {
+	if (type != q->vb2_type) {
 		VB2_DEBUG(1, "%s: invalid buffer type\n", opname);
 		return -EINVAL;
 	}
@@ -964,7 +970,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, unsigned int memory,
 		return -EINVAL;
 	}
 
-	if (memory != q->memory) {
+	if (memory != q->vb2_memory) {
 		VB2_DEBUG(1, "%s: invalid memory type\n", opname);
 		return -EINVAL;
 	}
@@ -987,8 +993,8 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, unsigned int memory,
  * The return values from this function are intended to be directly returned
  * from vidioc_prepare_buf handler in driver.
  */
-int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int memory,
-		unsigned int type, unsigned int index, void *pb)
+int vb2_core_prepare_buf(struct vb2_queue *q, enum vb2_memory memory,
+		enum vb2_buf_type type, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
 	int ret;
@@ -1019,6 +1025,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int memory,
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
 /**
  * vb2_start_streaming() - Attempt to start streaming.
@@ -1083,8 +1090,8 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int memory,
-		unsigned int type, unsigned int index, void *pb)
+int vb2_core_qbuf(struct vb2_queue *q, enum vb2_memory memory,
+		enum vb2_buf_type type, unsigned int index, void *pb)
 {
 	int ret = vb2_queue_or_prepare_buf(q, memory, type, index, pb, "qbuf");
 	struct vb2_buffer *vb;
@@ -1118,7 +1125,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int memory,
 	q->queued_count++;
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+	if (VB2_TYPE_IS_OUTPUT(q->vb2_type)) {
 		/*
 		 * For output buffers copy the timestamp if needed,
 		 * and the timecode field and flag if needed.
@@ -1126,7 +1133,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int memory,
 		call_bufop(q, set_timestamp, vb, pb);
 	}
 
-	trace_vb2_qbuf(q, vb);
+	trace_op(q, qbuf, q, vb);
 
 	/*
 	 * If already streaming, give the buffer to driver for processing.
@@ -1154,6 +1161,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int memory,
 	VB2_DEBUG(1, "qbuf of buffer %d succeeded\n", vb2_index(vb));
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_qbuf);
 
 /**
  * __vb2_wait_for_done_vb() - wait for a buffer to become available
@@ -1305,7 +1313,7 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 	vb->state = VB2_BUF_STATE_DEQUEUED;
 
 	/* unmap DMABUF buffer */
-	if (q->memory == V4L2_MEMORY_DMABUF)
+	if (q->vb2_memory == VB2_MEMORY_DMABUF)
 		for (i = 0; i < vb->num_planes; ++i) {
 			if (!vb->planes[i].dbuf_mapped)
 				continue;
@@ -1314,13 +1322,13 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 		}
 }
 
-int vb2_core_dqbuf(struct vb2_queue *q, unsigned int type, void *pb,
+int vb2_core_dqbuf(struct vb2_queue *q, enum vb2_buf_type type, void *pb,
 		bool nonblocking)
 {
 	struct vb2_buffer *vb = NULL;
 	int ret;
 
-	if (type != q->type) {
+	if (type != q->vb2_type) {
 		VB2_DEBUG(1, "invalid buffer type\n");
 		return -EINVAL;
 	}
@@ -1348,9 +1356,9 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int type, void *pb,
 	list_del(&vb->queued_entry);
 	q->queued_count--;
 
-	trace_vb2_dqbuf(q, vb);
+	trace_op(q, dqbuf, q, vb);
 
-	if (!V4L2_TYPE_IS_OUTPUT(q->type) && call_bufop(q, is_last, vb))
+	if (!VB2_TYPE_IS_OUTPUT(q->vb2_type) && call_bufop(q, is_last, vb))
 		q->last_buffer_dequeued = true;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
@@ -1360,6 +1368,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int type, void *pb,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
 
 /**
  * __vb2_queue_cancel() - cancel and stop (pause) streaming
@@ -1429,11 +1438,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	}
 }
 
-int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
+int vb2_core_streamon(struct vb2_queue *q, enum vb2_buf_type type)
 {
 	int ret;
 
-	if (type != q->type) {
+	if (type != q->vb2_type) {
 		VB2_DEBUG(1, "invalid stream type\n");
 		return -EINVAL;
 	}
@@ -1471,6 +1480,7 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 	VB2_DEBUG(3, "successful\n");
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_streamon);
 
 /**
  * vb2_queue_error() - signal a fatal error on the queue
@@ -1493,9 +1503,9 @@ void vb2_queue_error(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_queue_error);
 
-int vb2_core_streamoff(struct vb2_queue *q, unsigned int type)
+int vb2_core_streamoff(struct vb2_queue *q, enum vb2_buf_type type)
 {
-	if (type != q->type) {
+	if (type != q->vb2_type) {
 		VB2_DEBUG(1, "invalid stream type\n");
 		return -EINVAL;
 	}
@@ -1510,12 +1520,13 @@ int vb2_core_streamoff(struct vb2_queue *q, unsigned int type)
 	 * their normal dequeued state.
 	 */
 	__vb2_queue_cancel(q);
-	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	q->waiting_for_buffers = !VB2_TYPE_IS_OUTPUT(q->vb2_type);
 	q->last_buffer_dequeued = false;
 
 	VB2_DEBUG(3, "successful\n");
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_streamoff);
 
 /**
  * __find_plane_by_offset() - find plane associated with the given offset off
@@ -1555,7 +1566,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
  * The return values from this function are intended to be directly returned
  * from vidioc_expbuf handler in driver.
  */
-int vb2_core_expbuf(struct vb2_queue *q, unsigned int type, unsigned int index,
+int vb2_core_expbuf(struct vb2_queue *q, enum vb2_buf_type type, unsigned int index,
 		unsigned int plane, unsigned int flags)
 {
 	struct vb2_buffer *vb = NULL;
@@ -1563,7 +1574,7 @@ int vb2_core_expbuf(struct vb2_queue *q, unsigned int type, unsigned int index,
 	int ret;
 	struct dma_buf *dbuf;
 
-	if (q->memory != V4L2_MEMORY_MMAP) {
+	if (q->vb2_memory != VB2_MEMORY_MMAP) {
 		VB2_DEBUG(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
@@ -1578,7 +1589,7 @@ int vb2_core_expbuf(struct vb2_queue *q, unsigned int type, unsigned int index,
 		return -EINVAL;
 	}
 
-	if (type != q->type) {
+	if (type != q->vb2_type) {
 		VB2_DEBUG(1, "invalid buffer type\n");
 		return -EINVAL;
 	}
@@ -1621,6 +1632,7 @@ int vb2_core_expbuf(struct vb2_queue *q, unsigned int type, unsigned int index,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_core_expbuf);
 
 /**
  * vb2_mmap() - map video buffers into application address space
@@ -1649,7 +1661,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	int ret;
 	unsigned long length;
 
-	if (q->memory != V4L2_MEMORY_MMAP) {
+	if (q->vb2_memory != VB2_MEMORY_MMAP) {
 		VB2_DEBUG(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
@@ -1661,7 +1673,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 		VB2_DEBUG(1, "invalid vma flags, VM_SHARED needed\n");
 		return -EINVAL;
 	}
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+	if (VB2_TYPE_IS_OUTPUT(q->vb2_type)) {
 		if (!(vma->vm_flags & VM_WRITE)) {
 			VB2_DEBUG(1, "invalid vma flags, VM_WRITE needed\n");
 			return -EINVAL;
@@ -1722,7 +1734,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 	void *vaddr;
 	int ret;
 
-	if (q->memory != V4L2_MEMORY_MMAP) {
+	if (q->vb2_memory != VB2_MEMORY_MMAP) {
 		VB2_DEBUG(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
@@ -1749,7 +1761,7 @@ EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
  * The vb2_queue structure should be allocated by the driver. The driver is
  * responsible of clearing it's content and setting initial values for some
  * required entries before calling this function.
- * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
+ * q->ops, q->mem_ops, q->vb2_type and q->io_modes are mandatory. Please refer
  * to the struct vb2_queue description in include/media/videobuf2-v4l2.h
  * for more information.
  */
@@ -1761,7 +1773,8 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	if (WARN_ON(!q)			  ||
 	    WARN_ON(!q->ops)		  ||
 	    WARN_ON(!q->mem_ops)	  ||
-	    WARN_ON(!q->type)		  ||
+	    WARN_ON(!q->buf_ops)	  ||
+	    WARN_ON(!q->vb2_type)	  ||
 	    WARN_ON(!q->io_modes)	  ||
 	    WARN_ON(!q->ops->queue_setup) ||
 	    WARN_ON(!q->ops->buf_queue))
@@ -1775,6 +1788,7 @@ int vb2_core_queue_init(struct vb2_queue *q)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_queue_init);
 
 /**
  * vb2_core_queue_release() - stop streaming, release the queue and free memory
@@ -1791,6 +1805,7 @@ void vb2_core_queue_release(struct vb2_queue *q)
 	__vb2_queue_free(q, q->num_buffers);
 	mutex_unlock(&q->mmap_lock);
 }
+EXPORT_SYMBOL_GPL(vb2_core_queue_release);
 
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 85527e9..22dd19c 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -30,8 +30,46 @@
 #include <media/v4l2-common.h>
 #include <media/videobuf2-v4l2.h>
 
+#define CREATE_TRACE_POINTS
 #include <trace/events/v4l2.h>
 
+static const enum vb2_buf_type _tbl_buf_type[] = {
+	[V4L2_BUF_TYPE_VIDEO_CAPTURE]		= VB2_BUF_TYPE_VIDEO_CAPTURE,
+	[V4L2_BUF_TYPE_VIDEO_OUTPUT]		= VB2_BUF_TYPE_VIDEO_OUTPUT,
+	[V4L2_BUF_TYPE_VIDEO_OVERLAY]		= VB2_BUF_TYPE_VIDEO_OVERLAY,
+	[V4L2_BUF_TYPE_VBI_CAPTURE]		= VB2_BUF_TYPE_VBI_CAPTURE,
+	[V4L2_BUF_TYPE_VBI_OUTPUT]		= VB2_BUF_TYPE_VBI_OUTPUT,
+	[V4L2_BUF_TYPE_SLICED_VBI_CAPTURE]	= VB2_BUF_TYPE_SLICED_VBI_CAPTURE,
+	[V4L2_BUF_TYPE_SLICED_VBI_OUTPUT]	= VB2_BUF_TYPE_SLICED_VBI_OUTPUT,
+	[V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY]	= VB2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY,
+	[V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE]	= VB2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+	[V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE]	= VB2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
+	[V4L2_BUF_TYPE_SDR_CAPTURE]		= VB2_BUF_TYPE_SDR_CAPTURE,
+	[V4L2_BUF_TYPE_PRIVATE]			= VB2_BUF_TYPE_PRIVATE,
+};
+
+static const enum vb2_memory _tbl_memory[] = {
+	[V4L2_MEMORY_MMAP]	= VB2_MEMORY_MMAP,
+	[V4L2_MEMORY_USERPTR]	= VB2_MEMORY_USERPTR,
+	[V4L2_MEMORY_DMABUF]	= VB2_MEMORY_DMABUF,
+};
+
+#define to_vb2_buf_type(type)					\
+({								\
+	enum vb2_buf_type ret = 0;				\
+	if( type > 0 && type < ARRAY_SIZE(_tbl_buf_type) )	\
+		ret = (_tbl_buf_type[type]);			\
+	ret;							\
+})
+
+#define to_vb2_memory(memory)					\
+({								\
+	enum vb2_memory ret = 0;				\
+	if( memory > 0 && memory < ARRAY_SIZE(_tbl_memory) )	\
+		ret = (_tbl_memory[memory]);			\
+	ret;							\
+})
+
 /* Flags that are set by the vb2 core */
 #define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
 				 V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR | \
@@ -41,19 +79,19 @@
 #define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
 				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
 
-static int v4l2_init_buffer(struct vb2_buffer *vb,
-		unsigned int memory, unsigned int type, unsigned int index,
-		unsigned int planes)
+static int v4l2_init_buffer(struct vb2_buffer *vb, enum vb2_memory memory,
+		unsigned int index, unsigned int planes)
 {
+	struct vb2_queue *q = vb->vb2_queue;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
 	/* Length stores number of planes for multiplanar buffers */
-	if (V4L2_TYPE_IS_MULTIPLANAR(type))
+	if (VB2_TYPE_IS_MULTIPLANAR(q->vb2_type))
 		vbuf->v4l2_buf.length = planes;
 
 	vbuf->v4l2_buf.index = index;
-	vbuf->v4l2_buf.type = type;
-	vbuf->v4l2_buf.memory = memory;
+	vbuf->v4l2_buf.type = q->type;
+	vbuf->v4l2_buf.memory = q->memory;
 
 	return 0;
 }
@@ -139,7 +177,7 @@ static int v4l2_fill_buffer(struct vb2_buffer *vb, void *pb)
 	b->reserved2 = vbuf->v4l2_buf.reserved2;
 	b->reserved = vbuf->v4l2_buf.reserved;
 
-	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
+	if (VB2_TYPE_IS_MULTIPLANAR(q->vb2_type)) {
 		/*
 		 * Fill in plane-related data if userspace provided an array
 		 * for it. The caller has already verified memory and size.
@@ -154,11 +192,11 @@ static int v4l2_fill_buffer(struct vb2_buffer *vb, void *pb)
 		 */
 		b->length = vbuf->v4l2_planes[0].length;
 		b->bytesused = vbuf->v4l2_planes[0].bytesused;
-		if (q->memory == V4L2_MEMORY_MMAP)
+		if (q->vb2_memory == VB2_MEMORY_MMAP)
 			b->m.offset = vbuf->v4l2_planes[0].m.mem_offset;
-		else if (q->memory == V4L2_MEMORY_USERPTR)
+		else if (q->vb2_memory == VB2_MEMORY_USERPTR)
 			b->m.userptr = vbuf->v4l2_planes[0].m.userptr;
-		else if (q->memory == V4L2_MEMORY_DMABUF)
+		else if (q->vb2_memory == VB2_MEMORY_DMABUF)
 			b->m.fd = vbuf->v4l2_planes[0].m.fd;
 	}
 
@@ -418,7 +456,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	unsigned int plane;
 	int ret;
 	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+		VB2_TYPE_IS_OUTPUT(q->vb2_type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -523,7 +561,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	unsigned int plane;
 	int ret;
 	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+		VB2_TYPE_IS_OUTPUT(q->vb2_type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -643,7 +681,7 @@ static int v4l2_buf_prepare(struct vb2_buffer *vb, void *pb)
 		VB2_DEBUG(1, "plane parameters verification failed: %d\n", ret);
 		return ret;
 	}
-	if (b->field == V4L2_FIELD_ALTERNATE && V4L2_TYPE_IS_OUTPUT(q->type)) {
+	if (b->field == V4L2_FIELD_ALTERNATE && VB2_TYPE_IS_OUTPUT(q->vb2_type)) {
 		/*
 		 * If the format's field is ALTERNATE, then the buffer's field
 		 * should be either TOP or BOTTOM, not ALTERNATE since that
@@ -667,16 +705,16 @@ static int v4l2_buf_prepare(struct vb2_buffer *vb, void *pb)
 	vbuf->v4l2_buf.timestamp.tv_usec = 0;
 	vbuf->v4l2_buf.sequence = 0;
 
-	switch (q->memory) {
-	case V4L2_MEMORY_MMAP:
+	switch (q->vb2_memory) {
+	case VB2_MEMORY_MMAP:
 		ret = __qbuf_mmap(vb, b);
 		break;
-	case V4L2_MEMORY_USERPTR:
+	case VB2_MEMORY_USERPTR:
 		down_read(&current->mm->mmap_sem);
 		ret = __qbuf_userptr(vb, b);
 		up_read(&current->mm->mmap_sem);
 		break;
-	case V4L2_MEMORY_DMABUF:
+	case VB2_MEMORY_DMABUF:
 		ret = __qbuf_dmabuf(vb, b);
 		break;
 	default:
@@ -698,7 +736,7 @@ static int v4l2_set_timestamp(struct vb2_buffer *vb, void *pb)
 	struct vb2_queue *q = vb->vb2_queue;
 
 	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY)
+			V4L2_BUF_FLAG_TIMESTAMP_COPY)
 		vbuf->v4l2_buf.timestamp = b->timestamp;
 	vbuf->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
 	if (b->flags & V4L2_BUF_FLAG_TIMECODE)
@@ -729,6 +767,33 @@ const struct vb2_buf_ops vb2_v4l2_buf_ops = {
 	.is_last		= v4l2_is_last,
 };
 
+static void v4l2_trace_buf_done(struct vb2_queue *q, struct vb2_buffer *vb)
+{
+	trace_vb2_buf_done(q, vb);
+}
+
+static void v4l2_trace_buf_queue(struct vb2_queue *q, struct vb2_buffer *vb)
+{
+	trace_vb2_buf_queue(q, vb);
+}
+
+static void v4l2_trace_qbuf(struct vb2_queue *q, struct vb2_buffer *vb)
+{
+	trace_vb2_qbuf(q, vb);
+}
+
+static void v4l2_trace_dqbuf(struct vb2_queue *q, struct vb2_buffer *vb)
+{
+	trace_vb2_dqbuf(q, vb);
+}
+
+const struct vb2_trace_ops vb2_v4l2_trace_ops = {
+	.buf_done		= v4l2_trace_buf_done,
+	.buf_queue 		= v4l2_trace_buf_queue,
+	.qbuf			= v4l2_trace_qbuf,
+	.dqbuf			= v4l2_trace_dqbuf,
+};
+
 /**
  * vb2_querybuf() - query video buffer information
  * @q:		videobuf queue
@@ -744,7 +809,7 @@ const struct vb2_buf_ops vb2_v4l2_buf_ops = {
  */
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	return vb2_core_querybuf(q, b->type, b->index, b);
+	return vb2_core_querybuf(q, to_vb2_buf_type(b->type), b->index, b);
 }
 EXPORT_SYMBOL(vb2_querybuf);
 
@@ -756,9 +821,10 @@ EXPORT_SYMBOL(vb2_querybuf);
  */
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
-	int ret = __verify_memory_type(q, req->memory, req->type);
-
-	return ret ? ret : vb2_core_reqbufs(q, req->memory, &req->count);
+	int ret = __verify_memory_type(q, to_vb2_memory(req->memory),
+			to_vb2_buf_type(req->type));
+	q->memory = req->memory;
+	return ret ? ret : vb2_core_reqbufs(q, to_vb2_memory(req->memory), &req->count);
 }
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
@@ -771,12 +837,14 @@ EXPORT_SYMBOL_GPL(vb2_reqbufs);
  */
 int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *cb)
 {
-	int ret = __verify_memory_type(q, cb->memory, cb->format.type);
+	int ret = __verify_memory_type(q, to_vb2_memory(cb->memory),
+			to_vb2_buf_type(cb->format.type));
 
 	cb->index = q->num_buffers;
 	if (cb->count == 0)
 		return ret != -EBUSY ? ret : 0;
-	return ret ? ret : vb2_core_create_bufs(q, cb->memory, &cb->count, &cb->format);
+	q->memory = cb->memory;
+	return ret ? ret : vb2_core_create_bufs(q, to_vb2_memory(cb->memory), &cb->count, &cb->format);
 }
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
@@ -797,7 +865,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
  */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	return vb2_core_prepare_buf(q, b->memory, b->type, b->index, b);
+	return vb2_core_prepare_buf(q, to_vb2_memory(b->memory), to_vb2_buf_type(b->type), b->index, b);
 }
 EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
@@ -825,7 +893,7 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return -EBUSY;
 	}
 
-	return vb2_core_qbuf(q, b->memory, b->type, b->index, b);
+	return vb2_core_qbuf(q, to_vb2_memory(b->memory), to_vb2_buf_type(b->type), b->index, b);
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
@@ -856,7 +924,7 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 		VB2_DEBUG(1, "file io in progress\n");
 		return -EBUSY;
 	}
-	return vb2_core_dqbuf(q, b->type, b, nonblocking);
+	return vb2_core_dqbuf(q, to_vb2_buf_type(b->type), b, nonblocking);
 }
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
@@ -871,7 +939,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
  */
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 {
-	eb->fd = vb2_core_expbuf(q, eb->type, eb->index, eb->plane, eb->flags);
+	eb->fd = vb2_core_expbuf(q, to_vb2_buf_type(eb->type), eb->index, eb->plane, eb->flags);
 
 	return 0;
 }
@@ -897,7 +965,7 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 		return -EBUSY;
 	}
 
-	return vb2_core_streamon(q, type);
+	return vb2_core_streamon(q, to_vb2_buf_type(type));
 }
 EXPORT_SYMBOL_GPL(vb2_streamon);
 
@@ -922,7 +990,7 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 		VB2_DEBUG(1, "file io in progress\n");
 		return -EBUSY;
 	}
-	return vb2_core_streamoff(q, type);
+	return vb2_core_streamoff(q, to_vb2_buf_type(type));
 }
 EXPORT_SYMBOL_GPL(vb2_streamoff);
 
@@ -965,21 +1033,21 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 			poll_wait(file, &fh->wait, wait);
 	}
 
-	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
+	if (!VB2_TYPE_IS_OUTPUT(q->vb2_type) && !(req_events & (POLLIN | POLLRDNORM)))
 		return res;
-	if (V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLOUT | POLLWRNORM)))
+	if (VB2_TYPE_IS_OUTPUT(q->vb2_type) && !(req_events & (POLLOUT | POLLWRNORM)))
 		return res;
 
 	/*
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
+		if (!VB2_TYPE_IS_OUTPUT(q->vb2_type) && (q->io_modes & VB2_READ) &&
 				(req_events & (POLLIN | POLLRDNORM))) {
 			if (__vb2_init_fileio(q, 1))
 				return res | POLLERR;
 		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
+		if (VB2_TYPE_IS_OUTPUT(q->vb2_type) && (q->io_modes & VB2_WRITE) &&
 				(req_events & (POLLOUT | POLLWRNORM))) {
 			if (__vb2_init_fileio(q, 0))
 				return res | POLLERR;
@@ -1008,7 +1076,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * For output streams you can write as long as there are fewer buffers
 	 * queued than there are buffers available.
 	 */
-	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
+	if (VB2_TYPE_IS_OUTPUT(q->vb2_type) && q->queued_count < q->num_buffers)
 		return res | POLLOUT | POLLWRNORM;
 
 	if (list_empty(&q->done_list)) {
@@ -1033,7 +1101,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 
 	if (vb && (vb->state == VB2_BUF_STATE_DONE
 			|| vb->state == VB2_BUF_STATE_ERROR)) {
-		return (V4L2_TYPE_IS_OUTPUT(q->type)) ?
+		return (VB2_TYPE_IS_OUTPUT(q->vb2_type)) ?
 				res | POLLOUT | POLLWRNORM :
 				res | POLLIN | POLLRDNORM;
 	}
@@ -1048,20 +1116,18 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  * The vb2_queue structure should be allocated by the driver. The driver is
  * responsible of clearing it's content and setting initial values for some
  * required entries before calling this function.
- * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
+ * q->ops, q->mem_ops, q->vb2_type and q->io_modes are mandatory. Please refer
  * to the struct vb2_queue description in include/media/videobuf2-core.h
  * for more information.
  */
 int vb2_queue_init(struct vb2_queue *q)
 {
-	int ret = vb2_core_queue_init(q);
-
-	if (ret < 0)
-		return ret;
-
 	/*
 	 * Sanity check
 	 */
+	if (WARN_ON(!q)	|| WARN_ON(!q->type))
+		return -EINVAL;
+
 	if (WARN_ON(q->timestamp_flags &
 		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
 		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
@@ -1075,8 +1141,10 @@ int vb2_queue_init(struct vb2_queue *q)
 		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
 
 	q->buf_ops = &vb2_v4l2_buf_ops;
+	q->trace_ops = &vb2_v4l2_trace_ops;
+	q->vb2_type = to_vb2_buf_type(q->type);
 
-	return 0;
+	return vb2_core_queue_init(q);
 }
 EXPORT_SYMBOL_GPL(vb2_queue_init);
 
@@ -1197,10 +1265,10 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * to allocate buffers by itself.
 	 */
 	fileio->req.count = count;
-	fileio->req.memory = V4L2_MEMORY_MMAP;
+	fileio->req.memory = q->memory = V4L2_MEMORY_MMAP;
 	fileio->req.type = q->type;
 	q->fileio = fileio;
-	ret = vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
+	ret = vb2_core_reqbufs(q, to_vb2_memory(fileio->req.memory), &fileio->req.count);
 	if (ret)
 		goto err_kfree;
 
@@ -1229,7 +1297,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Read mode requires pre queuing of all buffers.
 	 */
 	if (read) {
-		bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+		bool is_multiplanar = VB2_TYPE_IS_MULTIPLANAR(q->vb2_type);
 
 		/*
 		 * Queue all buffers.
@@ -1246,7 +1314,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 			}
 			b->memory = q->memory;
 			b->index = i;
-			ret = vb2_core_qbuf(q, b->memory, b->type, i, b);
+			ret = vb2_core_qbuf(q, q->vb2_memory, q->vb2_type, i, b);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -1262,7 +1330,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	/*
 	 * Start streaming.
 	 */
-	ret = vb2_core_streamon(q, q->type);
+	ret = vb2_core_streamon(q, q->vb2_type);
 	if (ret)
 		goto err_reqbufs;
 
@@ -1270,7 +1338,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 
 err_reqbufs:
 	fileio->req.count = 0;
-	vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
+	vb2_core_reqbufs(q, to_vb2_memory(fileio->req.memory), &fileio->req.count);
 
 err_kfree:
 	q->fileio = NULL;
@@ -1287,7 +1355,7 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
 	struct vb2_fileio_data *fileio = q->fileio;
 
 	if (fileio) {
-		vb2_core_streamoff(q, q->type);
+		vb2_core_streamoff(q, q->vb2_type);
 		q->fileio = NULL;
 		fileio->req.count = 0;
 		vb2_reqbufs(q, &fileio->req);
@@ -1311,7 +1379,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 {
 	struct vb2_fileio_data *fileio;
 	struct vb2_fileio_buf *buf;
-	bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+	bool is_multiplanar = VB2_TYPE_IS_MULTIPLANAR(q->vb2_type);
 	/*
 	 * When using write() to write data to an output video node the vb2 core
 	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
@@ -1356,7 +1424,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 			fileio->b.m.planes = &fileio->p;
 			fileio->b.length = 1;
 		}
-		ret = vb2_core_dqbuf(q, fileio->b.type, &fileio->b, nonblock);
+		ret = vb2_core_dqbuf(q, q->vb2_type, &fileio->b, nonblock);
 		VB2_DEBUG(5, "vb2_dqbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -1438,7 +1506,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		}
 		if (set_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
-		ret = vb2_core_qbuf(q, fileio->b.memory, fileio->b.type, index,
+		ret = vb2_core_qbuf(q, q->vb2_memory, q->vb2_type, index,
 				&fileio->b);
 		VB2_DEBUG(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
@@ -1507,7 +1575,7 @@ static int vb2_thread(void *data)
 	int index = 0;
 	int ret = 0;
 
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+	if (VB2_TYPE_IS_OUTPUT(q->vb2_type)) {
 		prequeue = q->num_buffers;
 		set_timestamp =
 			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
@@ -1531,7 +1599,7 @@ static int vb2_thread(void *data)
 		} else {
 			call_void_qop(q, wait_finish, q);
 			if (!threadio->stop)
-				ret = vb2_core_dqbuf(q, fileio->b.type, &fileio->b, 0);
+				ret = vb2_core_dqbuf(q, q->vb2_type, &fileio->b, 0);
 			call_void_qop(q, wait_prepare, q);
 			VB2_DEBUG(5, "file io: vb2_dqbuf result: %d\n", ret);
 		}
@@ -1547,8 +1615,8 @@ static int vb2_thread(void *data)
 		if (set_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
 		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, fileio->b.memory,
-				fileio->b.type, fileio->b.index, &fileio->b);
+			ret = vb2_core_qbuf(q, q->vb2_memory,
+				q->vb2_type, fileio->b.index, &fileio->b);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
@@ -1586,7 +1654,7 @@ int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
 	threadio->fnc = fnc;
 	threadio->priv = priv;
 
-	ret = __vb2_init_fileio(q, !V4L2_TYPE_IS_OUTPUT(q->type));
+	ret = __vb2_init_fileio(q, !VB2_TYPE_IS_OUTPUT(q->vb2_type));
 	VB2_DEBUG(3, "file io: vb2_init_fileio result: %d\n", ret);
 	if (ret)
 		goto nomem;
@@ -1646,13 +1714,15 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *p)
 {
 	struct video_device *vdev = video_devdata(file);
-	int res = __verify_memory_type(vdev->queue, p->memory, p->type);
+	int res = __verify_memory_type(vdev->queue, to_vb2_memory(p->memory),
+			to_vb2_buf_type(p->type));
 
 	if (res)
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	res = vb2_core_reqbufs(vdev->queue, p->memory, &p->count);
+	vdev->queue->memory = p->memory;
+	res = vb2_core_reqbufs(vdev->queue, to_vb2_memory(p->memory), &p->count);
 	/* If count == 0, then the owner has released all buffers and he
 	   is no longer owner of the queue. Otherwise we have a new owner. */
 	if (res == 0)
@@ -1665,7 +1735,8 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 			  struct v4l2_create_buffers *p)
 {
 	struct video_device *vdev = video_devdata(file);
-	int res = __verify_memory_type(vdev->queue, p->memory, p->format.type);
+	int res = __verify_memory_type(vdev->queue, to_vb2_memory(p->memory),
+			to_vb2_buf_type(p->format.type));
 
 	p->index = vdev->queue->num_buffers;
 	/* If count == 0, then just check if memory and type are valid.
@@ -1676,7 +1747,9 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	res = vb2_core_create_bufs(vdev->queue, p->memory, &p->count, &p->format);
+	vdev->queue->memory = p->memory;
+	res = vb2_core_create_bufs(vdev->queue, to_vb2_memory(p->memory),
+			&p->count, &p->format);
 	if (res == 0)
 		vdev->queue->owner = file->private_data;
 	return res;
@@ -1690,8 +1763,8 @@ int vb2_ioctl_prepare_buf(struct file *file, void *priv,
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_core_prepare_buf(vdev->queue,
-			p->memory, p->type, p->index, p);
+	return vb2_core_prepare_buf(vdev->queue, to_vb2_memory(p->memory),
+			to_vb2_buf_type(p->type), p->index, p);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
 
@@ -1724,23 +1797,23 @@ int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_dqbuf);
 
-int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
 {
 	struct video_device *vdev = video_devdata(file);
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_streamon(vdev->queue, i);
+	return vb2_streamon(vdev->queue, to_vb2_buf_type(type));
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_streamon);
 
-int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
 {
 	struct video_device *vdev = video_devdata(file);
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_streamoff(vdev->queue, i);
+	return vb2_streamoff(vdev->queue, to_vb2_buf_type(type));
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index dc405da..871fcc6 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -15,9 +15,47 @@
 #include <linux/mm_types.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
-#include <linux/videodev2.h>
 #include <linux/dma-buf.h>
 
+#define VB2_MAX_FRAME               32
+#define VB2_MAX_PLANES               8
+
+enum vb2_buf_type {
+	VB2_BUF_TYPE_UNKNOWN			= 0,
+	VB2_BUF_TYPE_VIDEO_CAPTURE		= 1,
+	VB2_BUF_TYPE_VIDEO_OUTPUT		= 2,
+	VB2_BUF_TYPE_VIDEO_OVERLAY		= 3,
+	VB2_BUF_TYPE_VBI_CAPTURE		= 4,
+	VB2_BUF_TYPE_VBI_OUTPUT			= 5,
+	VB2_BUF_TYPE_SLICED_VBI_CAPTURE		= 6,
+	VB2_BUF_TYPE_SLICED_VBI_OUTPUT		= 7,
+	VB2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY	= 8,
+	VB2_BUF_TYPE_VIDEO_CAPTURE_MPLANE	= 9,
+	VB2_BUF_TYPE_VIDEO_OUTPUT_MPLANE	= 10,
+	VB2_BUF_TYPE_SDR_CAPTURE		= 11,
+	VB2_BUF_TYPE_DVB_CAPTURE		= 12,
+	VB2_BUF_TYPE_PRIVATE			= 0x80,
+};
+
+enum vb2_memory {
+	VB2_MEMORY_UNKNOWN	= 0,
+	VB2_MEMORY_MMAP		= 1,
+	VB2_MEMORY_USERPTR	= 2,
+	VB2_MEMORY_DMABUF	= 4,
+};
+
+#define VB2_TYPE_IS_MULTIPLANAR(type)			\
+	((type) == VB2_BUF_TYPE_VIDEO_CAPTURE_MPLANE	\
+	 || (type) == VB2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+
+#define VB2_TYPE_IS_OUTPUT(type)				\
+	((type) == VB2_BUF_TYPE_VIDEO_OUTPUT			\
+	 || (type) == VB2_BUF_TYPE_VIDEO_OUTPUT_MPLANE		\
+	 || (type) == VB2_BUF_TYPE_VIDEO_OVERLAY		\
+	 || (type) == VB2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY		\
+	 || (type) == VB2_BUF_TYPE_VBI_OUTPUT			\
+	 || (type) == VB2_BUF_TYPE_SLICED_VBI_OUTPUT)
+
 struct vb2_alloc_ctx;
 struct vb2_fileio_data;
 struct vb2_threadio_data;
@@ -181,7 +219,7 @@ struct vb2_buffer {
 	struct list_head	queued_entry;
 	struct list_head	done_entry;
 
-	struct vb2_plane	planes[VIDEO_MAX_PLANES];
+	struct vb2_plane	planes[VB2_MAX_PLANES];
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
@@ -314,8 +352,8 @@ struct vb2_ops {
 };
 
 struct vb2_buf_ops {
-	int (*init_buffer)(struct vb2_buffer *vb, unsigned int memory,
-		unsigned int type, unsigned int index, unsigned int planes);
+	int (*init_buffer)(struct vb2_buffer *vb, enum vb2_memory memory,
+		unsigned int index, unsigned int planes);
 	unsigned int (*get_index)(struct vb2_buffer *vb);
 	int (*set_plane_length)(struct vb2_buffer *vb, int plane,
 		unsigned int length);
@@ -332,10 +370,19 @@ struct vb2_buf_ops {
 	int (*is_last)(struct vb2_buffer *vb);
 };
 
+struct vb2_trace_ops {
+	void (*buf_done)(struct vb2_queue *q, struct vb2_buffer *vb);
+	void (*buf_queue)(struct vb2_queue *q, struct vb2_buffer *vb);
+	void (*qbuf)(struct vb2_queue *q, struct vb2_buffer *vb);
+	void (*dqbuf)(struct vb2_queue *q, struct vb2_buffer *vb);
+};
+
 /**
  * struct vb2_queue - a videobuf queue
  *
- * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
+ * @vb2_type:	queue type (see enum vb2_buf_type avobe)
+ * @type:	queue type for backward compatibility with v4l2
+ *		(see V4L2_BUF_TYPE_* in linux/videodev2.h)
  * @io_modes:	supported io methods (see vb2_io_modes enum)
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
@@ -367,7 +414,8 @@ struct vb2_buf_ops {
  *		have been queued into the driver.
  *
  * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
- * @memory:	current memory type used
+ * @vb2_memory:	current memory type used
+ * @memory:	memory type for backward compatibility with v4l2
  * @bufs:	videobuf buffer structures
  * @num_buffers: number of allocated/used buffers
  * @queued_list: list of buffers currently queued from userspace
@@ -392,6 +440,7 @@ struct vb2_buf_ops {
  */
 struct vb2_queue {
 	unsigned int			type;
+	enum vb2_buf_type		vb2_type;
 	unsigned int			io_modes;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
@@ -403,6 +452,7 @@ struct vb2_queue {
 	const struct vb2_ops		*ops;
 	const struct vb2_mem_ops	*mem_ops;
 	const struct vb2_buf_ops	*buf_ops;
+	const struct vb2_trace_ops	*trace_ops;
 
 	void				*drv_priv;
 	unsigned int			buf_struct_size;
@@ -413,7 +463,8 @@ struct vb2_queue {
 /* private: internal use only */
 	struct mutex			mmap_lock;
 	unsigned int			memory;
-	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
+	enum vb2_memory			vb2_memory;
+	struct vb2_buffer		*bufs[VB2_MAX_FRAME];
 	unsigned int			num_buffers;
 
 	struct list_head		queued_list;
@@ -424,8 +475,8 @@ struct vb2_queue {
 	spinlock_t			done_lock;
 	wait_queue_head_t		done_wq;
 
-	void				*alloc_ctx[VIDEO_MAX_PLANES];
-	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
+	void				*alloc_ctx[VB2_MAX_PLANES];
+	unsigned int			plane_sizes[VB2_MAX_PLANES];
 
 	unsigned int			streaming:1;
 	unsigned int			start_streaming_called:1;
@@ -475,6 +526,12 @@ extern int vb2_debug;
 	ret;								\
 })
 
+#define trace_op(q, op, args...)					\
+({ 									\
+	if(q && q->trace_ops && q->trace_ops->op)			\
+		q->trace_ops->op(args);					\
+})
+
 #define vb2_index(vb) (call_u32_bufop((vb)->vb2_queue, get_index, vb))
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -617,27 +674,27 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
 void vb2_discard_done(struct vb2_queue *q);
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
-int vb2_core_querybuf(struct vb2_queue *q, unsigned int type,
+int vb2_core_querybuf(struct vb2_queue *q, enum vb2_buf_type type,
 		unsigned int index, void *pb);
-int vb2_core_reqbufs(struct vb2_queue *q, unsigned int memory, unsigned int *count);
-int vb2_core_create_bufs(struct vb2_queue *q, unsigned int memory,
+int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory, unsigned int *count);
+int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count, void *parg);
-int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int memory,
-		unsigned int type, unsigned int index, void *pb);
+int vb2_core_prepare_buf(struct vb2_queue *q, enum vb2_memory memory,
+		enum vb2_buf_type type, unsigned int index, void *pb);
 
 int __must_check vb2_core_queue_init(struct vb2_queue *q);
 
 void vb2_core_queue_release(struct vb2_queue *q);
 void vb2_queue_error(struct vb2_queue *q);
 
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int memory, unsigned int type,
+int vb2_core_qbuf(struct vb2_queue *q, enum vb2_memory memory, enum vb2_buf_type type,
 		unsigned int index, void *pb);
-int vb2_core_dqbuf(struct vb2_queue *q, unsigned int type, void *pb, bool nonblock);
-int vb2_core_expbuf(struct vb2_queue *q, unsigned int type, unsigned int index,
+int vb2_core_dqbuf(struct vb2_queue *q, enum vb2_buf_type type, void *pb, bool nonblock);
+int vb2_core_expbuf(struct vb2_queue *q, enum vb2_buf_type type, unsigned int index,
 		unsigned int plane, unsigned int flags);
 
-int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
-int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
+int vb2_core_streamon(struct vb2_queue *q, enum vb2_buf_type type);
+int vb2_core_streamoff(struct vb2_queue *q, enum vb2_buf_type type);
 
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
 #ifndef CONFIG_MMU
@@ -649,13 +706,13 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 #endif
 
 /*
- * The following functions are for internal uses.
+ * The following functions are for videobuf2 internal use.
  */
 bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
 void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p);
 void __vb2_buf_dmabuf_put(struct vb2_buffer *vb);
 int __verify_memory_type(struct vb2_queue *q,
-		enum v4l2_memory memory, enum v4l2_buf_type type);
+		enum vb2_memory memory, enum vb2_buf_type type);
 
 /**
  * vb2_is_streaming() - return streaming status of the queue
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 3f76e53..7460d0b 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -12,6 +12,7 @@
 #ifndef _MEDIA_VIDEOBUF2_V4L2_H
 #define _MEDIA_VIDEOBUF2_V4L2_H
 
+#include <linux/videodev2.h>
 #include <media/videobuf2-core.h>
 
 /**
@@ -42,13 +43,6 @@ struct vb2_v4l2_buffer {
 #define to_vb2_v4l2_buffer(vb) \
 	(container_of(vb, struct vb2_v4l2_buffer, vb2_buf))
 
-#define vb2_v4l2_index(vb)					\
-({								\
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);	\
-	unsigned int ret = vbuf->v4l2_buf.index;		\
-	ret;							\
-})
-
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
 
@@ -164,8 +158,8 @@ int vb2_ioctl_prepare_buf(struct file *file, void *priv,
 int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p);
 int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
 int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p);
-int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i);
-int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i);
+int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type type);
+int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type type);
 int vb2_ioctl_expbuf(struct file *file, void *priv,
 	struct v4l2_exportbuffer *p);
 
-- 
1.7.9.5

