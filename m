Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59204 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754480AbeDZUGK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 16:06:10 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: paul.elder@ideasonboard.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media: vb2: Print the queue pointer in debug messages
Date: Thu, 26 Apr 2018 23:06:10 +0300
Message-Id: <20180426200610.28195-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When debugging issues that involve more than one video queue, messages
related to multiple queues get interleaved without any easy way to tell
which queue they relate to. Fix this by printing the queue pointer for
all debug messages in the vb2 core and V4L2 layers.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 193 ++++++++++++------------
 drivers/media/common/videobuf2/videobuf2-v4l2.c |  39 ++---
 2 files changed, 118 insertions(+), 114 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index d3f7bb33a54d..e35e79c32550 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -34,10 +34,10 @@
 static int debug;
 module_param(debug, int, 0644);
 
-#define dprintk(level, fmt, arg...)				\
-	do {							\
-		if (debug >= level)				\
-			pr_info("%s: " fmt, __func__, ## arg);	\
+#define dprintk(q, level, fmt, arg...)					\
+	do {								\
+		if (debug >= level)					\
+			pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
 	} while (0)
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -51,8 +51,8 @@ module_param(debug, int, 0644);
  */
 
 #define log_memop(vb, op)						\
-	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->index, #op,			\
+	dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n",	\
+		(vb)->index, #op,					\
 		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
 
 #define call_memop(vb, op, args...)					\
@@ -90,7 +90,7 @@ module_param(debug, int, 0644);
 })
 
 #define log_qop(q, op)							\
-	dprintk(2, "call_qop(%p, %s)%s\n", q, #op,			\
+	dprintk(q, 2, "call_qop(%p, %s)%s\n", q, #op,			\
 		(q)->ops->op ? "" : " (nop)")
 
 #define call_qop(q, op, args...)					\
@@ -113,8 +113,8 @@ module_param(debug, int, 0644);
 })
 
 #define log_vb_qop(vb, op, args...)					\
-	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->index, #op,			\
+	dprintk((vb)->vb2_queue, 2, "call_vb_qop(%p, %d, %s)%s\n",	\
+		(vb)->index, #op,					\
 		(vb)->vb2_queue->ops->op ? "" : " (nop)")
 
 #define call_vb_qop(vb, op, args...)					\
@@ -241,7 +241,8 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		call_void_memop(vb, put, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
-		dprintk(3, "freed plane %d of buffer %d\n", plane, vb->index);
+		dprintk(vb->vb2_queue, 3, "freed plane %d of buffer %d\n",
+			plane, vb->index);
 	}
 }
 
@@ -311,7 +312,7 @@ static void __setup_offsets(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		vb->planes[plane].m.offset = off;
 
-		dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
+		dprintk(q, 3, "buffer %d, plane %d offset 0x%08lx\n",
 				vb->index, plane, off);
 
 		off += vb->planes[plane].length;
@@ -342,7 +343,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 		/* Allocate videobuf buffer structures */
 		vb = kzalloc(q->buf_struct_size, GFP_KERNEL);
 		if (!vb) {
-			dprintk(1, "memory alloc for buffer struct failed\n");
+			dprintk(q, 1, "memory alloc for buffer struct failed\n");
 			break;
 		}
 
@@ -362,7 +363,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 		if (memory == VB2_MEMORY_MMAP) {
 			ret = __vb2_buf_mem_alloc(vb);
 			if (ret) {
-				dprintk(1, "failed allocating memory for buffer %d\n",
+				dprintk(q, 1, "failed allocating memory for buffer %d\n",
 					buffer);
 				q->bufs[vb->index] = NULL;
 				kfree(vb);
@@ -376,7 +377,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			 */
 			ret = call_vb_qop(vb, buf_init, vb);
 			if (ret) {
-				dprintk(1, "buffer %d %p initialization failed\n",
+				dprintk(q, 1, "buffer %d %p initialization failed\n",
 					buffer, vb);
 				__vb2_buf_mem_free(vb);
 				q->bufs[vb->index] = NULL;
@@ -386,7 +387,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 		}
 	}
 
-	dprintk(1, "allocated %d buffers, %d plane(s) each\n",
+	dprintk(q, 1, "allocated %d buffers, %d plane(s) each\n",
 			buffer, num_planes);
 
 	return buffer;
@@ -438,7 +439,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 		if (q->bufs[buffer] == NULL)
 			continue;
 		if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
-			dprintk(1, "preparing buffers, cannot free\n");
+			dprintk(q, 1, "preparing buffers, cannot free\n");
 			return -EAGAIN;
 		}
 	}
@@ -615,12 +616,12 @@ int vb2_verify_memory_type(struct vb2_queue *q,
 {
 	if (memory != VB2_MEMORY_MMAP && memory != VB2_MEMORY_USERPTR &&
 	    memory != VB2_MEMORY_DMABUF) {
-		dprintk(1, "unsupported memory type\n");
+		dprintk(q, 1, "unsupported memory type\n");
 		return -EINVAL;
 	}
 
 	if (type != q->type) {
-		dprintk(1, "requested type is incorrect\n");
+		dprintk(q, 1, "requested type is incorrect\n");
 		return -EINVAL;
 	}
 
@@ -629,17 +630,17 @@ int vb2_verify_memory_type(struct vb2_queue *q,
 	 * are available.
 	 */
 	if (memory == VB2_MEMORY_MMAP && __verify_mmap_ops(q)) {
-		dprintk(1, "MMAP for current setup unsupported\n");
+		dprintk(q, 1, "MMAP for current setup unsupported\n");
 		return -EINVAL;
 	}
 
 	if (memory == VB2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
-		dprintk(1, "USERPTR for current setup unsupported\n");
+		dprintk(q, 1, "USERPTR for current setup unsupported\n");
 		return -EINVAL;
 	}
 
 	if (memory == VB2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
-		dprintk(1, "DMABUF for current setup unsupported\n");
+		dprintk(q, 1, "DMABUF for current setup unsupported\n");
 		return -EINVAL;
 	}
 
@@ -649,7 +650,7 @@ int vb2_verify_memory_type(struct vb2_queue *q,
 	 * do the memory and type validation.
 	 */
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+		dprintk(q, 1, "file io in progress\n");
 		return -EBUSY;
 	}
 	return 0;
@@ -664,7 +665,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	int ret;
 
 	if (q->streaming) {
-		dprintk(1, "streaming active\n");
+		dprintk(q, 1, "streaming active\n");
 		return -EBUSY;
 	}
 
@@ -677,7 +678,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		mutex_lock(&q->mmap_lock);
 		if (q->memory == VB2_MEMORY_MMAP && __buffers_in_use(q)) {
 			mutex_unlock(&q->mmap_lock);
-			dprintk(1, "memory in use, cannot free\n");
+			dprintk(q, 1, "memory in use, cannot free\n");
 			return -EBUSY;
 		}
 
@@ -722,7 +723,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	allocated_buffers =
 		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
-		dprintk(1, "memory allocation failed\n");
+		dprintk(q, 1, "memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -792,7 +793,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	int ret;
 
 	if (q->num_buffers == VB2_MAX_FRAME) {
-		dprintk(1, "maximum number of buffers already allocated\n");
+		dprintk(q, 1, "maximum number of buffers already allocated\n");
 		return -ENOBUFS;
 	}
 
@@ -822,7 +823,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
 				num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
-		dprintk(1, "memory allocation failed\n");
+		dprintk(q, 1, "memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -913,7 +914,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	 */
 	vb->cnt_buf_done++;
 #endif
-	dprintk(4, "done processing on buffer %d, state: %d\n",
+	dprintk(q, 4, "done processing on buffer %d, state: %d\n",
 			vb->index, state);
 
 	/* sync buffers */
@@ -1002,12 +1003,12 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 			&& vb->planes[plane].length == planes[plane].length)
 			continue;
 
-		dprintk(3, "userspace address for plane %d changed, reacquiring memory\n",
+		dprintk(q, 3, "userspace address for plane %d changed, reacquiring memory\n",
 			plane);
 
 		/* Check if the provided plane buffer is large enough */
 		if (planes[plane].length < vb->planes[plane].min_length) {
-			dprintk(1, "provided buffer size %u is less than setup size %u for plane %d\n",
+			dprintk(q, 1, "provided buffer size %u is less than setup size %u for plane %d\n",
 						planes[plane].length,
 						vb->planes[plane].min_length,
 						plane);
@@ -1036,7 +1037,7 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 				planes[plane].m.userptr,
 				planes[plane].length, q->dma_dir);
 		if (IS_ERR(mem_priv)) {
-			dprintk(1, "failed acquiring userspace memory for plane %d\n",
+			dprintk(q, 1, "failed acquiring userspace memory for plane %d\n",
 				plane);
 			ret = PTR_ERR(mem_priv);
 			goto err;
@@ -1063,14 +1064,14 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 		 */
 		ret = call_vb_qop(vb, buf_init, vb);
 		if (ret) {
-			dprintk(1, "buffer initialization failed\n");
+			dprintk(q, 1, "buffer initialization failed\n");
 			goto err;
 		}
 	}
 
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
-		dprintk(1, "buffer preparation failed\n");
+		dprintk(q, 1, "buffer preparation failed\n");
 		call_void_vb_qop(vb, buf_cleanup, vb);
 		goto err;
 	}
@@ -1115,7 +1116,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
 
 		if (IS_ERR_OR_NULL(dbuf)) {
-			dprintk(1, "invalid dmabuf fd for plane %d\n",
+			dprintk(q, 1, "invalid dmabuf fd for plane %d\n",
 				plane);
 			ret = -EINVAL;
 			goto err;
@@ -1126,7 +1127,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 			planes[plane].length = dbuf->size;
 
 		if (planes[plane].length < vb->planes[plane].min_length) {
-			dprintk(1, "invalid dmabuf length %u for plane %d, minimum length %u\n",
+			dprintk(q, 1, "invalid dmabuf length %u for plane %d, minimum length %u\n",
 				planes[plane].length, plane,
 				vb->planes[plane].min_length);
 			dma_buf_put(dbuf);
@@ -1141,7 +1142,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 			continue;
 		}
 
-		dprintk(3, "buffer for plane %d changed\n", plane);
+		dprintk(q, 3, "buffer for plane %d changed\n", plane);
 
 		if (!reacquired) {
 			reacquired = true;
@@ -1160,7 +1161,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 				q->alloc_devs[plane] ? : q->dev,
 				dbuf, planes[plane].length, q->dma_dir);
 		if (IS_ERR(mem_priv)) {
-			dprintk(1, "failed to attach dmabuf\n");
+			dprintk(q, 1, "failed to attach dmabuf\n");
 			ret = PTR_ERR(mem_priv);
 			dma_buf_put(dbuf);
 			goto err;
@@ -1178,7 +1179,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
 		if (ret) {
-			dprintk(1, "failed to map dmabuf for plane %d\n",
+			dprintk(q, 1, "failed to map dmabuf for plane %d\n",
 				plane);
 			goto err;
 		}
@@ -1203,14 +1204,14 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 		 */
 		ret = call_vb_qop(vb, buf_init, vb);
 		if (ret) {
-			dprintk(1, "buffer initialization failed\n");
+			dprintk(q, 1, "buffer initialization failed\n");
 			goto err;
 		}
 	}
 
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
-		dprintk(1, "buffer preparation failed\n");
+		dprintk(q, 1, "buffer preparation failed\n");
 		call_void_vb_qop(vb, buf_cleanup, vb);
 		goto err;
 	}
@@ -1245,7 +1246,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 	int ret;
 
 	if (q->error) {
-		dprintk(1, "fatal error occurred on queue\n");
+		dprintk(q, 1, "fatal error occurred on queue\n");
 		return -EIO;
 	}
 
@@ -1267,7 +1268,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 	}
 
 	if (ret) {
-		dprintk(1, "buffer preparation failed: %d\n", ret);
+		dprintk(q, 1, "buffer preparation failed: %d\n", ret);
 		vb->state = VB2_BUF_STATE_DEQUEUED;
 		return ret;
 	}
@@ -1288,7 +1289,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 
 	vb = q->bufs[index];
 	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-		dprintk(1, "invalid buffer state %d\n",
+		dprintk(q, 1, "invalid buffer state %d\n",
 			vb->state);
 		return -EINVAL;
 	}
@@ -1300,7 +1301,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 	/* Fill buffer information for the userspace */
 	call_void_bufop(q, fill_user_buffer, vb, pb);
 
-	dprintk(2, "prepare of buffer %d succeeded\n", vb->index);
+	dprintk(q, 2, "prepare of buffer %d succeeded\n", vb->index);
 
 	return ret;
 }
@@ -1338,7 +1339,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
 
 	q->start_streaming_called = 0;
 
-	dprintk(1, "driver refused to start streaming\n");
+	dprintk(q, 1, "driver refused to start streaming\n");
 	/*
 	 * If you see this warning, then the driver isn't cleaning up properly
 	 * after a failed start_streaming(). See the start_streaming()
@@ -1385,10 +1386,10 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	case VB2_BUF_STATE_PREPARED:
 		break;
 	case VB2_BUF_STATE_PREPARING:
-		dprintk(1, "buffer still being prepared\n");
+		dprintk(q, 1, "buffer still being prepared\n");
 		return -EINVAL;
 	default:
-		dprintk(1, "invalid buffer state %d\n", vb->state);
+		dprintk(q, 1, "invalid buffer state %d\n", vb->state);
 		return -EINVAL;
 	}
 
@@ -1430,7 +1431,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 			return ret;
 	}
 
-	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
+	dprintk(q, 2, "qbuf of buffer %d succeeded\n", vb->index);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_core_qbuf);
@@ -1456,17 +1457,17 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		int ret;
 
 		if (!q->streaming) {
-			dprintk(1, "streaming off, will not wait for buffers\n");
+			dprintk(q, 1, "streaming off, will not wait for buffers\n");
 			return -EINVAL;
 		}
 
 		if (q->error) {
-			dprintk(1, "Queue in error state, will not wait for buffers\n");
+			dprintk(q, 1, "Queue in error state, will not wait for buffers\n");
 			return -EIO;
 		}
 
 		if (q->last_buffer_dequeued) {
-			dprintk(3, "last buffer dequeued already, will not wait for buffers\n");
+			dprintk(q, 3, "last buffer dequeued already, will not wait for buffers\n");
 			return -EPIPE;
 		}
 
@@ -1478,7 +1479,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		}
 
 		if (nonblocking) {
-			dprintk(3, "nonblocking and no buffers to dequeue, will not wait\n");
+			dprintk(q, 3, "nonblocking and no buffers to dequeue, will not wait\n");
 			return -EAGAIN;
 		}
 
@@ -1492,7 +1493,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		/*
 		 * All locks have been released, it is safe to sleep now.
 		 */
-		dprintk(3, "will sleep waiting for buffers\n");
+		dprintk(q, 3, "will sleep waiting for buffers\n");
 		ret = wait_event_interruptible(q->done_wq,
 				!list_empty(&q->done_list) || !q->streaming ||
 				q->error);
@@ -1503,7 +1504,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		 */
 		call_void_qop(q, wait_finish, q);
 		if (ret) {
-			dprintk(1, "sleep was interrupted\n");
+			dprintk(q, 1, "sleep was interrupted\n");
 			return ret;
 		}
 	}
@@ -1551,7 +1552,7 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
 int vb2_wait_for_all_buffers(struct vb2_queue *q)
 {
 	if (!q->streaming) {
-		dprintk(1, "streaming off, will not wait for buffers\n");
+		dprintk(q, 1, "streaming off, will not wait for buffers\n");
 		return -EINVAL;
 	}
 
@@ -1597,13 +1598,13 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DONE:
-		dprintk(3, "returning done buffer\n");
+		dprintk(q, 3, "returning done buffer\n");
 		break;
 	case VB2_BUF_STATE_ERROR:
-		dprintk(3, "returning done buffer with errors\n");
+		dprintk(q, 3, "returning done buffer with errors\n");
 		break;
 	default:
-		dprintk(1, "invalid buffer state\n");
+		dprintk(q, 1, "invalid buffer state\n");
 		return -EINVAL;
 	}
 
@@ -1625,7 +1626,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
-	dprintk(2, "dqbuf of buffer %d, with state %d\n",
+	dprintk(q, 2, "dqbuf of buffer %d, with state %d\n",
 			vb->index, vb->state);
 
 	return 0;
@@ -1718,22 +1719,22 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 	int ret;
 
 	if (type != q->type) {
-		dprintk(1, "invalid stream type\n");
+		dprintk(q, 1, "invalid stream type\n");
 		return -EINVAL;
 	}
 
 	if (q->streaming) {
-		dprintk(3, "already streaming\n");
+		dprintk(q, 3, "already streaming\n");
 		return 0;
 	}
 
 	if (!q->num_buffers) {
-		dprintk(1, "no buffers have been allocated\n");
+		dprintk(q, 1, "no buffers have been allocated\n");
 		return -EINVAL;
 	}
 
 	if (q->num_buffers < q->min_buffers_needed) {
-		dprintk(1, "need at least %u allocated buffers\n",
+		dprintk(q, 1, "need at least %u allocated buffers\n",
 				q->min_buffers_needed);
 		return -EINVAL;
 	}
@@ -1755,7 +1756,7 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 
 	q->streaming = 1;
 
-	dprintk(3, "successful\n");
+	dprintk(q, 3, "successful\n");
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_core_streamon);
@@ -1771,7 +1772,7 @@ EXPORT_SYMBOL_GPL(vb2_queue_error);
 int vb2_core_streamoff(struct vb2_queue *q, unsigned int type)
 {
 	if (type != q->type) {
-		dprintk(1, "invalid stream type\n");
+		dprintk(q, 1, "invalid stream type\n");
 		return -EINVAL;
 	}
 
@@ -1788,7 +1789,7 @@ int vb2_core_streamoff(struct vb2_queue *q, unsigned int type)
 	q->waiting_for_buffers = !q->is_output;
 	q->last_buffer_dequeued = false;
 
-	dprintk(3, "successful\n");
+	dprintk(q, 3, "successful\n");
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_core_streamoff);
@@ -1831,39 +1832,39 @@ int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
 	struct dma_buf *dbuf;
 
 	if (q->memory != VB2_MEMORY_MMAP) {
-		dprintk(1, "queue is not currently set up for mmap\n");
+		dprintk(q, 1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
 
 	if (!q->mem_ops->get_dmabuf) {
-		dprintk(1, "queue does not support DMA buffer exporting\n");
+		dprintk(q, 1, "queue does not support DMA buffer exporting\n");
 		return -EINVAL;
 	}
 
 	if (flags & ~(O_CLOEXEC | O_ACCMODE)) {
-		dprintk(1, "queue does support only O_CLOEXEC and access mode flags\n");
+		dprintk(q, 1, "queue does support only O_CLOEXEC and access mode flags\n");
 		return -EINVAL;
 	}
 
 	if (type != q->type) {
-		dprintk(1, "invalid buffer type\n");
+		dprintk(q, 1, "invalid buffer type\n");
 		return -EINVAL;
 	}
 
 	if (index >= q->num_buffers) {
-		dprintk(1, "buffer index out of range\n");
+		dprintk(q, 1, "buffer index out of range\n");
 		return -EINVAL;
 	}
 
 	vb = q->bufs[index];
 
 	if (plane >= vb->num_planes) {
-		dprintk(1, "buffer plane out of range\n");
+		dprintk(q, 1, "buffer plane out of range\n");
 		return -EINVAL;
 	}
 
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "expbuf: file io in progress\n");
+		dprintk(q, 1, "expbuf: file io in progress\n");
 		return -EBUSY;
 	}
 
@@ -1872,20 +1873,20 @@ int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
 	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv,
 				flags & O_ACCMODE);
 	if (IS_ERR_OR_NULL(dbuf)) {
-		dprintk(1, "failed to export buffer %d, plane %d\n",
+		dprintk(q, 1, "failed to export buffer %d, plane %d\n",
 			index, plane);
 		return -EINVAL;
 	}
 
 	ret = dma_buf_fd(dbuf, flags & ~O_ACCMODE);
 	if (ret < 0) {
-		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
+		dprintk(q, 3, "buffer %d, plane %d failed to export (%d)\n",
 			index, plane, ret);
 		dma_buf_put(dbuf);
 		return ret;
 	}
 
-	dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
+	dprintk(q, 3, "buffer %d, plane %d exported as %d descriptor\n",
 		index, plane, ret);
 	*fd = ret;
 
@@ -1902,7 +1903,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	unsigned long length;
 
 	if (q->memory != VB2_MEMORY_MMAP) {
-		dprintk(1, "queue is not currently set up for mmap\n");
+		dprintk(q, 1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
 
@@ -1910,22 +1911,22 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	 * Check memory area access mode.
 	 */
 	if (!(vma->vm_flags & VM_SHARED)) {
-		dprintk(1, "invalid vma flags, VM_SHARED needed\n");
+		dprintk(q, 1, "invalid vma flags, VM_SHARED needed\n");
 		return -EINVAL;
 	}
 	if (q->is_output) {
 		if (!(vma->vm_flags & VM_WRITE)) {
-			dprintk(1, "invalid vma flags, VM_WRITE needed\n");
+			dprintk(q, 1, "invalid vma flags, VM_WRITE needed\n");
 			return -EINVAL;
 		}
 	} else {
 		if (!(vma->vm_flags & VM_READ)) {
-			dprintk(1, "invalid vma flags, VM_READ needed\n");
+			dprintk(q, 1, "invalid vma flags, VM_READ needed\n");
 			return -EINVAL;
 		}
 	}
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "mmap: file io in progress\n");
+		dprintk(q, 1, "mmap: file io in progress\n");
 		return -EBUSY;
 	}
 
@@ -1945,7 +1946,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	 */
 	length = PAGE_ALIGN(vb->planes[plane].length);
 	if (length < (vma->vm_end - vma->vm_start)) {
-		dprintk(1,
+		dprintk(q, 1,
 			"MMAP invalid, as it would overflow buffer length\n");
 		return -EINVAL;
 	}
@@ -1956,7 +1957,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	if (ret)
 		return ret;
 
-	dprintk(3, "buffer %d, plane %d successfully mapped\n", buffer, plane);
+	dprintk(q, 3, "buffer %d, plane %d successfully mapped\n", buffer, plane);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_mmap);
@@ -1975,7 +1976,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 	int ret;
 
 	if (q->memory != VB2_MEMORY_MMAP) {
-		dprintk(1, "queue is not currently set up for mmap\n");
+		dprintk(q, 1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
 
@@ -2212,7 +2213,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 */
 	count = 1;
 
-	dprintk(3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d\n",
+	dprintk(q, 3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d\n",
 		(read) ? "read" : "write", count, q->fileio_read_once,
 		q->fileio_write_immediately);
 
@@ -2310,7 +2311,7 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
 		fileio->count = 0;
 		vb2_core_reqbufs(q, fileio->memory, &fileio->count);
 		kfree(fileio);
-		dprintk(3, "file io emulator closed\n");
+		dprintk(q, 3, "file io emulator closed\n");
 	}
 	return 0;
 }
@@ -2339,7 +2340,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	unsigned index;
 	int ret;
 
-	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
+	dprintk(q, 3, "mode %s, offset %ld, count %zd, %sblocking\n",
 		read ? "read" : "write", (long)*ppos, count,
 		nonblock ? "non" : "");
 
@@ -2351,7 +2352,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 */
 	if (!vb2_fileio_is_active(q)) {
 		ret = __vb2_init_fileio(q, read);
-		dprintk(3, "vb2_init_fileio result: %d\n", ret);
+		dprintk(q, 3, "vb2_init_fileio result: %d\n", ret);
 		if (ret)
 			return ret;
 	}
@@ -2368,7 +2369,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		 * Call vb2_dqbuf to get buffer back.
 		 */
 		ret = vb2_core_dqbuf(q, &index, NULL, nonblock);
-		dprintk(5, "vb2_dqbuf result: %d\n", ret);
+		dprintk(q, 5, "vb2_dqbuf result: %d\n", ret);
 		if (ret)
 			return ret;
 		fileio->dq_count += 1;
@@ -2399,20 +2400,20 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 */
 	if (buf->pos + count > buf->size) {
 		count = buf->size - buf->pos;
-		dprintk(5, "reducing read count: %zd\n", count);
+		dprintk(q, 5, "reducing read count: %zd\n", count);
 	}
 
 	/*
 	 * Transfer data to userspace.
 	 */
-	dprintk(3, "copying %zd bytes - buffer %d, offset %u\n",
+	dprintk(q, 3, "copying %zd bytes - buffer %d, offset %u\n",
 		count, index, buf->pos);
 	if (read)
 		ret = copy_to_user(data, buf->vaddr + buf->pos, count);
 	else
 		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
 	if (ret) {
-		dprintk(3, "error copying data\n");
+		dprintk(q, 3, "error copying data\n");
 		return -EFAULT;
 	}
 
@@ -2432,7 +2433,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		 * Check if this is the last buffer to read.
 		 */
 		if (read && fileio->read_once && fileio->dq_count == 1) {
-			dprintk(3, "read limit reached\n");
+			dprintk(q, 3, "read limit reached\n");
 			return __vb2_cleanup_fileio(q);
 		}
 
@@ -2444,7 +2445,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		if (copy_timestamp)
 			b->timestamp = ktime_get_ns();
 		ret = vb2_core_qbuf(q, index, NULL);
-		dprintk(5, "vb2_dbuf result: %d\n", ret);
+		dprintk(q, 5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
 
@@ -2531,7 +2532,7 @@ static int vb2_thread(void *data)
 			if (!threadio->stop)
 				ret = vb2_core_dqbuf(q, &index, NULL, 0);
 			call_void_qop(q, wait_prepare, q);
-			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
+			dprintk(q, 5, "file io: vb2_dqbuf result: %d\n", ret);
 			if (!ret)
 				vb = q->bufs[index];
 		}
@@ -2585,7 +2586,7 @@ int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
 	threadio->priv = priv;
 
 	ret = __vb2_init_fileio(q, !q->is_output);
-	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
+	dprintk(q, 3, "file io: vb2_init_fileio result: %d\n", ret);
 	if (ret)
 		goto nomem;
 	q->threadio = threadio;
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 886a2d8d5c6c..9e97bc347b38 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -34,10 +34,11 @@
 static int debug;
 module_param(debug, int, 0644);
 
-#define dprintk(level, fmt, arg...)					      \
+#define dprintk(q, level, fmt, arg...)					      \
 	do {								      \
 		if (debug >= level)					      \
-			pr_info("vb2-v4l2: %s: " fmt, __func__, ## arg); \
+			pr_info("vb2-v4l2: (q=%p) %s: " fmt,		      \
+				q, __func__, ## arg);			      \
 	} while (0)
 
 /* Flags that are set by the vb2 core */
@@ -60,12 +61,14 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 
 	/* Is memory for copying plane information present? */
 	if (b->m.planes == NULL) {
-		dprintk(1, "multi-planar buffer passed but planes array not provided\n");
+		dprintk(vb->vb2_queue, 1,
+			"multi-planar buffer passed but planes array not provided\n");
 		return -EINVAL;
 	}
 
 	if (b->length < vb->num_planes || b->length > VB2_MAX_PLANES) {
-		dprintk(1, "incorrect planes array length, expected %d, got %d\n",
+		dprintk(vb->vb2_queue, 1,
+			"incorrect planes array length, expected %d, got %d\n",
 			vb->num_planes, b->length);
 		return -EINVAL;
 	}
@@ -158,23 +161,23 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 				    const char *opname)
 {
 	if (b->type != q->type) {
-		dprintk(1, "%s: invalid buffer type\n", opname);
+		dprintk(q, 1, "%s: invalid buffer type\n", opname);
 		return -EINVAL;
 	}
 
 	if (b->index >= q->num_buffers) {
-		dprintk(1, "%s: buffer index out of range\n", opname);
+		dprintk(q, 1, "%s: buffer index out of range\n", opname);
 		return -EINVAL;
 	}
 
 	if (q->bufs[b->index] == NULL) {
 		/* Should never happen */
-		dprintk(1, "%s: buffer is NULL\n", opname);
+		dprintk(q, 1, "%s: buffer is NULL\n", opname);
 		return -EINVAL;
 	}
 
 	if (b->memory != q->memory) {
-		dprintk(1, "%s: invalid memory type\n", opname);
+		dprintk(q, 1, "%s: invalid memory type\n", opname);
 		return -EINVAL;
 	}
 
@@ -302,7 +305,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 
 	ret = __verify_length(vb, b);
 	if (ret < 0) {
-		dprintk(1, "plane parameters verification failed: %d\n", ret);
+		dprintk(q, 1, "plane parameters verification failed: %d\n", ret);
 		return ret;
 	}
 	if (b->field == V4L2_FIELD_ALTERNATE && q->is_output) {
@@ -315,7 +318,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 		 * that just says that it is either a top or a bottom field,
 		 * but not which of the two it is.
 		 */
-		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
+		dprintk(q, 1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
 		return -EINVAL;
 	}
 	vb->timestamp = 0;
@@ -467,12 +470,12 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	int ret;
 
 	if (b->type != q->type) {
-		dprintk(1, "wrong buffer type\n");
+		dprintk(q, 1, "wrong buffer type\n");
 		return -EINVAL;
 	}
 
 	if (b->index >= q->num_buffers) {
-		dprintk(1, "buffer index out of range\n");
+		dprintk(q, 1, "buffer index out of range\n");
 		return -EINVAL;
 	}
 	vb = q->bufs[b->index];
@@ -496,7 +499,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+		dprintk(q, 1, "file io in progress\n");
 		return -EBUSY;
 	}
 
@@ -565,7 +568,7 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+		dprintk(q, 1, "file io in progress\n");
 		return -EBUSY;
 	}
 
@@ -579,12 +582,12 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+		dprintk(q, 1, "file io in progress\n");
 		return -EBUSY;
 	}
 
 	if (b->type != q->type) {
-		dprintk(1, "invalid buffer type\n");
+		dprintk(q, 1, "invalid buffer type\n");
 		return -EINVAL;
 	}
 
@@ -603,7 +606,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+		dprintk(q, 1, "file io in progress\n");
 		return -EBUSY;
 	}
 	return vb2_core_streamon(q, type);
@@ -613,7 +616,7 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+		dprintk(q, 1, "file io in progress\n");
 		return -EBUSY;
 	}
 	return vb2_core_streamoff(q, type);
-- 
Regards,

Laurent Pinchart
