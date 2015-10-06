Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44727 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbbJFJh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2015 05:37:57 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NVS01NK4LF7XGE0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2015 18:37:55 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [PATCH 4/4] media: videobuf2: Move v4l2-specific stuff to
 videobuf2-v4l2
Date: Tue, 06 Oct 2015 18:37:49 +0900
Message-id: <1444124269-1084-5-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1444124269-1084-1-git-send-email-jh1009.sung@samsung.com>
References: <1444124269-1084-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move v4l2-specific stuff from videobu2-core to videobuf2-v4l2
without doing any functional changes.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c     | 1843 +-------------------------
 drivers/media/v4l2-core/videobuf2-internal.h |  161 +++
 drivers/media/v4l2-core/videobuf2-v4l2.c     | 1630 +++++++++++++++++++++++
 include/media/videobuf2-core.h               |  108 +-
 include/media/videobuf2-dvb.h                |    8 +-
 include/media/videobuf2-v4l2.h               |   96 ++
 6 files changed, 1951 insertions(+), 1895 deletions(-)
 create mode 100644 drivers/media/v4l2-core/videobuf2-internal.h

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 2c05705..33bdd81 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -24,172 +24,15 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 
-#include <media/v4l2-dev.h>
-#include <media/v4l2-fh.h>
-#include <media/v4l2-event.h>
-#include <media/v4l2-common.h>
-#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-core.h>
 
 #include <trace/events/vb2.h>
 
-static int debug;
-module_param(debug, int, 0644);
+#include "videobuf2-internal.h"
 
-#define dprintk(level, fmt, arg...)					      \
-	do {								      \
-		if (debug >= level)					      \
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
-/* Flags that are set by the vb2 core */
-#define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
-				 V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR | \
-				 V4L2_BUF_FLAG_PREPARED | \
-				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
-/* Output buffer flags that should be passed on to the driver */
-#define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
-				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
+int vb2_debug;
+EXPORT_SYMBOL_GPL(vb2_debug);
+module_param_named(debug, vb2_debug, int, 0644);
 
 static void __vb2_queue_cancel(struct vb2_queue *q);
 static void __enqueue_in_driver(struct vb2_buffer *vb);
@@ -487,7 +330,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 		bool unbalanced = q->cnt_start_streaming != q->cnt_stop_streaming ||
 				  q->cnt_wait_prepare != q->cnt_wait_finish;
 
-		if (unbalanced || debug) {
+		if (unbalanced || vb2_debug) {
 			pr_info("vb2: counters for queue %p:%s\n", q,
 				unbalanced ? " UNBALANCED!" : "");
 			pr_info("vb2:     setup: %u start_streaming: %u stop_streaming: %u\n",
@@ -513,7 +356,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 				  vb->cnt_buf_prepare != vb->cnt_buf_finish ||
 				  vb->cnt_buf_init != vb->cnt_buf_cleanup;
 
-		if (unbalanced || debug) {
+		if (unbalanced || vb2_debug) {
 			pr_info("vb2:   counters for queue %p, buffer %d:%s\n",
 				q, buffer, unbalanced ? " UNBALANCED!" : "");
 			pr_info("vb2:     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
@@ -555,75 +398,10 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 }
 
 /**
- * __verify_planes_array() - verify that the planes array passed in struct
- * v4l2_buffer from userspace can be safely used
- */
-static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
-{
-	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
-		return 0;
-
-	/* Is memory for copying plane information present? */
-	if (NULL == b->m.planes) {
-		dprintk(1, "multi-planar buffer passed but "
-			   "planes array not provided\n");
-		return -EINVAL;
-	}
-
-	if (b->length < vb->num_planes || b->length > VB2_MAX_PLANES) {
-		dprintk(1, "incorrect planes array length, "
-			   "expected %d, got %d\n", vb->num_planes, b->length);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/**
- * __verify_length() - Verify that the bytesused value for each plane fits in
- * the plane length and that the data offset doesn't exceed the bytesused value.
- */
-static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
-{
-	unsigned int length;
-	unsigned int bytesused;
-	unsigned int plane;
-
-	if (!V4L2_TYPE_IS_OUTPUT(b->type))
-		return 0;
-
-	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			length = (b->memory == VB2_MEMORY_USERPTR ||
-				  b->memory == VB2_MEMORY_DMABUF)
-			       ? b->m.planes[plane].length
-				: vb->planes[plane].length;
-			bytesused = b->m.planes[plane].bytesused
-				  ? b->m.planes[plane].bytesused : length;
-
-			if (b->m.planes[plane].bytesused > length)
-				return -EINVAL;
-
-			if (b->m.planes[plane].data_offset > 0 &&
-			    b->m.planes[plane].data_offset >= bytesused)
-				return -EINVAL;
-		}
-	} else {
-		length = (b->memory == VB2_MEMORY_USERPTR)
-			? b->length : vb->planes[0].length;
-
-		if (b->bytesused > length)
-			return -EINVAL;
-	}
-
-	return 0;
-}
-
-/**
  * vb2_buffer_in_use() - return true if the buffer is in use and
  * the queue cannot be freed (by the means of REQBUFS(0)) call
  */
-static bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
+bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 {
 	unsigned int plane;
 	for (plane = 0; plane < vb->num_planes; ++plane) {
@@ -639,6 +417,7 @@ static bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 	}
 	return false;
 }
+EXPORT_SYMBOL(vb2_buffer_in_use);
 
 /**
  * __buffers_in_use() - return true if any buffers on the queue are in use and
@@ -655,109 +434,6 @@ static bool __buffers_in_use(struct vb2_queue *q)
 }
 
 /**
- * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
- * returned to userspace
- */
-static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
-{
-	struct v4l2_buffer *b = pb;
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int plane;
-
-	/* Copy back data such as timestamp, flags, etc. */
-	b->index = vb->index;
-	b->type = vb->type;
-	b->memory = vb->memory;
-	b->bytesused = 0;
-
-	b->flags = vbuf->flags;
-	b->field = vbuf->field;
-	b->timestamp = vbuf->timestamp;
-	b->timecode = vbuf->timecode;
-	b->sequence = vbuf->sequence;
-	b->reserved2 = 0;
-	b->reserved = 0;
-
-	if (q->is_multiplanar) {
-		/*
-		 * Fill in plane-related data if userspace provided an array
-		 * for it. The caller has already verified memory and size.
-		 */
-		b->length = vb->num_planes;
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			struct v4l2_plane *pdst = &b->m.planes[plane];
-			struct vb2_plane *psrc = &vb->planes[plane];
-
-			pdst->bytesused = psrc->bytesused;
-			pdst->length = psrc->length;
-			if (q->memory == VB2_MEMORY_MMAP)
-				pdst->m.mem_offset = psrc->m.offset;
-			else if (q->memory == VB2_MEMORY_USERPTR)
-				pdst->m.userptr = psrc->m.userptr;
-			else if (q->memory == VB2_MEMORY_DMABUF)
-				pdst->m.fd = psrc->m.fd;
-			pdst->data_offset = psrc->data_offset;
-			memset(pdst->reserved, 0, sizeof(pdst->reserved));
-		}
-	} else {
-		/*
-		 * We use length and offset in v4l2_planes array even for
-		 * single-planar buffers, but userspace does not.
-		 */
-		b->length = vb->planes[0].length;
-		b->bytesused = vb->planes[0].bytesused;
-		if (q->memory == VB2_MEMORY_MMAP)
-			b->m.offset = vb->planes[0].m.offset;
-		else if (q->memory == VB2_MEMORY_USERPTR)
-			b->m.userptr = vb->planes[0].m.userptr;
-		else if (q->memory == VB2_MEMORY_DMABUF)
-			b->m.fd = vb->planes[0].m.fd;
-	}
-
-	/*
-	 * Clear any buffer state related flags.
-	 */
-	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
-	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
-	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
-		/*
-		 * For non-COPY timestamps, drop timestamp source bits
-		 * and obtain the timestamp source from the queue.
-		 */
-		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	}
-
-	switch (vb->state) {
-	case VB2_BUF_STATE_QUEUED:
-	case VB2_BUF_STATE_ACTIVE:
-		b->flags |= V4L2_BUF_FLAG_QUEUED;
-		break;
-	case VB2_BUF_STATE_ERROR:
-		b->flags |= V4L2_BUF_FLAG_ERROR;
-		/* fall through */
-	case VB2_BUF_STATE_DONE:
-		b->flags |= V4L2_BUF_FLAG_DONE;
-		break;
-	case VB2_BUF_STATE_PREPARED:
-		b->flags |= V4L2_BUF_FLAG_PREPARED;
-		break;
-	case VB2_BUF_STATE_PREPARING:
-	case VB2_BUF_STATE_DEQUEUED:
-	case VB2_BUF_STATE_REQUEUEING:
-		/* nothing */
-		break;
-	}
-
-	if (vb2_buffer_in_use(q, vb))
-		b->flags |= V4L2_BUF_FLAG_MAPPED;
-
-	return 0;
-}
-
-/**
  * vb2_core_querybuf() - query video buffer information
  * @q:		videobuf queue
  * @index:	id number of the buffer
@@ -770,44 +446,11 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
  * The return values from this function are intended to be directly returned
  * from vidioc_querybuf handler in driver.
  */
-static int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
+int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	return call_bufop(q, fill_user_buffer, q->bufs[index], pb);
 }
-
-/**
- * vb2_querybuf() - query video buffer information
- * @q:		videobuf queue
- * @b:		buffer struct passed from userspace to vidioc_querybuf handler
- *		in driver
- *
- * Should be called from vidioc_querybuf ioctl handler in driver.
- * This function will verify the passed v4l2_buffer structure and fill the
- * relevant information for the userspace.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_querybuf handler in driver.
- */
-int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
-{
-	struct vb2_buffer *vb;
-	int ret;
-
-	if (b->type != q->type) {
-		dprintk(1, "wrong buffer type\n");
-		return -EINVAL;
-	}
-
-	if (b->index >= q->num_buffers) {
-		dprintk(1, "buffer index out of range\n");
-		return -EINVAL;
-	}
-	vb = q->bufs[b->index];
-	ret = __verify_planes_array(vb, b);
-
-	return ret ? ret : vb2_core_querybuf(q, b->index, b);
-}
-EXPORT_SYMBOL(vb2_querybuf);
+EXPORT_SYMBOL_GPL(vb2_core_querybuf);
 
 /**
  * __verify_userptr_ops() - verify that all memory operations required for
@@ -853,7 +496,7 @@ static int __verify_dmabuf_ops(struct vb2_queue *q)
  * vb2_verify_memory_type() - Check whether the memory type and buffer type
  * passed to a buffer operation are compatible with the queue.
  */
-static int vb2_verify_memory_type(struct vb2_queue *q,
+int vb2_verify_memory_type(struct vb2_queue *q,
 		enum vb2_memory memory, unsigned int type)
 {
 	if (memory != VB2_MEMORY_MMAP && memory != VB2_MEMORY_USERPTR &&
@@ -897,6 +540,7 @@ static int vb2_verify_memory_type(struct vb2_queue *q,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(vb2_verify_memory_type);
 
 /**
  * vb2_core_reqbufs() - Initiate streaming
@@ -922,7 +566,7 @@ static int vb2_verify_memory_type(struct vb2_queue *q,
  * The return values from this function are intended to be directly returned
  * from vidioc_reqbufs handler in driver.
  */
-static int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
+int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count)
 {
 	unsigned int num_buffers, allocated_buffers, num_planes = 0;
@@ -1038,21 +682,7 @@ static int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 
 	return 0;
 }
-
-/**
- * vb2_reqbufs() - Wrapper for vb2_core_reqbufs() that also verifies
- * the memory and type values.
- * @q:		videobuf2 queue
- * @req:	struct passed from userspace to vidioc_reqbufs handler
- *		in driver
- */
-int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
-{
-	int ret = vb2_verify_memory_type(q, req->memory, req->type);
-
-	return ret ? ret : vb2_core_reqbufs(q, req->memory, &req->count);
-}
-EXPORT_SYMBOL_GPL(vb2_reqbufs);
+EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
 
 /**
  * vb2_core_create_bufs() - Allocate buffers and any required auxiliary structs
@@ -1070,7 +700,7 @@ EXPORT_SYMBOL_GPL(vb2_reqbufs);
  * The return values from this function are intended to be directly returned
  * from vidioc_create_bufs handler in driver.
  */
-static int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
+int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count, const void *parg)
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
@@ -1151,26 +781,7 @@ static int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 
 	return 0;
 }
-
-/**
- * vb2_create_bufs() - Wrapper for vb2_core_create_bufs() that also verifies
- * the memory and type values.
- * @q:		videobuf2 queue
- * @create:	creation parameters, passed from userspace to vidioc_create_bufs
- *		handler in driver
- */
-int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
-{
-	int ret = vb2_verify_memory_type(q, create->memory,
-			create->format.type);
-
-	create->index = q->num_buffers;
-	if (create->count == 0)
-		return ret != -EBUSY ? ret : 0;
-	return ret ? ret : vb2_core_create_bufs(q, create->memory,
-		&create->count, &create->format);
-}
-EXPORT_SYMBOL_GPL(vb2_create_bufs);
+EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
 
 /**
  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
@@ -1312,201 +923,6 @@ void vb2_discard_done(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_discard_done);
 
-static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
-{
-	static bool check_once;
-
-	if (check_once)
-		return;
-
-	check_once = true;
-	WARN_ON(1);
-
-	pr_warn("use of bytesused == 0 is deprecated and will be removed in the future,\n");
-	if (vb->vb2_queue->allow_zero_bytesused)
-		pr_warn("use VIDIOC_DECODER_CMD(V4L2_DEC_CMD_STOP) instead.\n");
-	else
-		pr_warn("use the actual size instead.\n");
-}
-
-static int __set_timestamp(struct vb2_buffer *vb, const void *pb)
-{
-	const struct v4l2_buffer *b = pb;
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct vb2_queue *q = vb->vb2_queue;
-
-	if (q->is_output) {
-		/*
-		 * For output buffers copy the timestamp if needed,
-		 * and the timecode field and flag if needed.
-		 */
-		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-				V4L2_BUF_FLAG_TIMESTAMP_COPY)
-			vbuf->timestamp = b->timestamp;
-		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
-		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
-			vbuf->timecode = b->timecode;
-	}
-
-	return 0;
-};
-
-/**
- * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
- * v4l2_buffer by the userspace. It also verifies that struct
- * v4l2_buffer has a valid number of planes.
- */
-static int __fill_vb2_buffer(struct vb2_buffer *vb,
-		const void *pb, struct vb2_plane *planes)
-{
-	struct vb2_queue *q = vb->vb2_queue;
-	const struct v4l2_buffer *b = pb;
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	unsigned int plane;
-	int ret;
-
-	ret = __verify_length(vb, b);
-	if (ret < 0) {
-		dprintk(1, "plane parameters verification failed: %d\n", ret);
-		return ret;
-	}
-	if (b->field == V4L2_FIELD_ALTERNATE && q->is_output) {
-		/*
-		 * If the format's field is ALTERNATE, then the buffer's field
-		 * should be either TOP or BOTTOM, not ALTERNATE since that
-		 * makes no sense. The driver has to know whether the
-		 * buffer represents a top or a bottom field in order to
-		 * program any DMA correctly. Using ALTERNATE is wrong, since
-		 * that just says that it is either a top or a bottom field,
-		 * but not which of the two it is.
-		 */
-		dprintk(1, "the field is incorrectly set to ALTERNATE "
-					"for an output buffer\n");
-		return -EINVAL;
-	}
-	vbuf->timestamp.tv_sec = 0;
-	vbuf->timestamp.tv_usec = 0;
-	vbuf->sequence = 0;
-
-	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		if (b->memory == VB2_MEMORY_USERPTR) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
-				planes[plane].m.userptr =
-					b->m.planes[plane].m.userptr;
-				planes[plane].length =
-					b->m.planes[plane].length;
-			}
-		}
-		if (b->memory == VB2_MEMORY_DMABUF) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
-				planes[plane].m.fd =
-					b->m.planes[plane].m.fd;
-				planes[plane].length =
-					b->m.planes[plane].length;
-			}
-		}
-
-		/* Fill in driver-provided information for OUTPUT types */
-		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
-			/*
-			 * Will have to go up to b->length when API starts
-			 * accepting variable number of planes.
-			 *
-			 * If bytesused == 0 for the output buffer, then fall
-			 * back to the full buffer size. In that case
-			 * userspace clearly never bothered to set it and
-			 * it's a safe assumption that they really meant to
-			 * use the full plane sizes.
-			 *
-			 * Some drivers, e.g. old codec drivers, use bytesused == 0
-			 * as a way to indicate that streaming is finished.
-			 * In that case, the driver should use the
-			 * allow_zero_bytesused flag to keep old userspace
-			 * applications working.
-			 */
-			for (plane = 0; plane < vb->num_planes; ++plane) {
-				struct vb2_plane *pdst = &planes[plane];
-				struct v4l2_plane *psrc = &b->m.planes[plane];
-
-				if (psrc->bytesused == 0)
-					vb2_warn_zero_bytesused(vb);
-
-				if (vb->vb2_queue->allow_zero_bytesused)
-					pdst->bytesused = psrc->bytesused;
-				else
-					pdst->bytesused = psrc->bytesused ?
-						psrc->bytesused : pdst->length;
-				pdst->data_offset = psrc->data_offset;
-			}
-		}
-	} else {
-		/*
-		 * Single-planar buffers do not use planes array,
-		 * so fill in relevant v4l2_buffer struct fields instead.
-		 * In videobuf we use our internal V4l2_planes struct for
-		 * single-planar buffers as well, for simplicity.
-		 *
-		 * If bytesused == 0 for the output buffer, then fall back
-		 * to the full buffer size as that's a sensible default.
-		 *
-		 * Some drivers, e.g. old codec drivers, use bytesused == 0 as
-		 * a way to indicate that streaming is finished. In that case,
-		 * the driver should use the allow_zero_bytesused flag to keep
-		 * old userspace applications working.
-		 */
-		if (b->memory == VB2_MEMORY_USERPTR) {
-			planes[0].m.userptr = b->m.userptr;
-			planes[0].length = b->length;
-		}
-
-		if (b->memory == VB2_MEMORY_DMABUF) {
-			planes[0].m.fd = b->m.fd;
-			planes[0].length = b->length;
-		}
-
-		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
-			if (b->bytesused == 0)
-				vb2_warn_zero_bytesused(vb);
-
-			if (vb->vb2_queue->allow_zero_bytesused)
-				planes[0].bytesused = b->bytesused;
-			else
-				planes[0].bytesused = b->bytesused ?
-					b->bytesused : planes[0].length;
-		} else
-			planes[0].bytesused = 0;
-
-	}
-
-	/* Zero flags that the vb2 core handles */
-	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
-	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
-		/*
-		 * Non-COPY timestamps and non-OUTPUT queues will get
-		 * their timestamp and timestamp source flags from the
-		 * queue.
-		 */
-		vbuf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	}
-
-	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
-		/*
-		 * For output buffers mask out the timecode flag:
-		 * this will be handled later in vb2_internal_qbuf().
-		 * The 'field' is valid metadata for this output buffer
-		 * and so that needs to be copied here.
-		 */
-		vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
-		vbuf->field = b->field;
-	} else {
-		/* Zero any output buffer flags as this is a capture buffer */
-		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
-	}
-
-	return 0;
-}
-
 /**
  * __qbuf_mmap() - handle qbuf of an MMAP buffer
  */
@@ -1814,33 +1230,6 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 	return ret;
 }
 
-static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
-				    const char *opname)
-{
-	if (b->type != q->type) {
-		dprintk(1, "%s: invalid buffer type\n", opname);
-		return -EINVAL;
-	}
-
-	if (b->index >= q->num_buffers) {
-		dprintk(1, "%s: buffer index out of range\n", opname);
-		return -EINVAL;
-	}
-
-	if (q->bufs[b->index] == NULL) {
-		/* Should never happen */
-		dprintk(1, "%s: buffer is NULL\n", opname);
-		return -EINVAL;
-	}
-
-	if (b->memory != q->memory) {
-		dprintk(1, "%s: invalid memory type\n", opname);
-		return -EINVAL;
-	}
-
-	return __verify_planes_array(q->bufs[b->index], b);
-}
-
 /**
  * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace
  *			to the kernel
@@ -1857,7 +1246,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
  * The return values from this function are intended to be directly returned
  * from vidioc_prepare_buf handler in driver.
  */
-static int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
+int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
 	int ret;
@@ -1882,36 +1271,7 @@ static int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *p
 
 	return ret;
 }
-
-/**
- * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_prepare_buf
- *		handler in driver
- *
- * Should be called from vidioc_prepare_buf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) calls buf_prepare callback in the driver (if provided), in which
- *    driver-specific buffer initialization can be performed,
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_prepare_buf handler in driver.
- */
-int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
-{
-	int ret;
-
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
-
-	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
-
-	return ret ? ret : vb2_core_prepare_buf(q, b->index, b);
-}
-EXPORT_SYMBOL_GPL(vb2_prepare_buf);
+EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
 /**
  * vb2_start_streaming() - Attempt to start streaming.
@@ -1994,7 +1354,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
  * The return values from this function are intended to be directly returned
  * from vidioc_qbuf handler in driver.
  */
-static int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
 	int ret;
@@ -2026,7 +1386,7 @@ static int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
 
-	__set_timestamp(vb, pb);
+	call_bufop(q, set_timestamp, vb, pb);
 
 	trace_vb2_qbuf(q, vb);
 
@@ -2058,41 +1418,7 @@ static int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
 	return 0;
 }
-
-static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
-{
-	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-
-	return ret ? ret : vb2_core_qbuf(q, b->index, b);
-}
-
-/**
- * vb2_qbuf() - Queue a buffer from userspace
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_qbuf handler
- *		in driver
- *
- * Should be called from vidioc_qbuf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
- *    which driver-specific buffer initialization can be performed,
- * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
- *    callback for processing.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_qbuf handler in driver.
- */
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
-{
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
-
-	return vb2_internal_qbuf(q, b);
-}
-EXPORT_SYMBOL_GPL(vb2_qbuf);
+EXPORT_SYMBOL_GPL(vb2_core_qbuf);
 
 /**
  * __vb2_wait_for_done_vb() - wait for a buffer to become available
@@ -2273,7 +1599,7 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
  * The return values from this function are intended to be directly returned
  * from vidioc_dqbuf handler in driver.
  */
-static int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking)
+int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking)
 {
 	struct vb2_buffer *vb = NULL;
 	int ret;
@@ -2316,66 +1642,17 @@ static int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking)
 	return 0;
 
 }
+EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
 
-static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
-		bool nonblocking)
+/**
+ * __vb2_queue_cancel() - cancel and stop (pause) streaming
+ *
+ * Removes all queued buffers from driver's queue and all buffers queued by
+ * userspace from videobuf's queue. Returns to state after reqbufs.
+ */
+static void __vb2_queue_cancel(struct vb2_queue *q)
 {
-	int ret;
-
-	if (b->type != q->type) {
-		dprintk(1, "invalid buffer type\n");
-		return -EINVAL;
-	}
-
-	ret = vb2_core_dqbuf(q, b, nonblocking);
-
-	if (!ret && !q->is_output &&
-			b->flags & V4L2_BUF_FLAG_LAST)
-		q->last_buffer_dequeued = true;
-
-	return ret;
-}
-
-/**
- * vb2_dqbuf() - Dequeue a buffer to the userspace
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
- *		in driver
- * @nonblocking: if true, this call will not sleep waiting for a buffer if no
- *		 buffers ready for dequeuing are present. Normally the driver
- *		 would be passing (file->f_flags & O_NONBLOCK) here
- *
- * Should be called from vidioc_dqbuf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) calls buf_finish callback in the driver (if provided), in which
- *    driver can perform any additional operations that may be required before
- *    returning the buffer to userspace, such as cache sync,
- * 3) the buffer struct members are filled with relevant information for
- *    the userspace.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_dqbuf handler in driver.
- */
-int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
-{
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
-	return vb2_internal_dqbuf(q, b, nonblocking);
-}
-EXPORT_SYMBOL_GPL(vb2_dqbuf);
-
-/**
- * __vb2_queue_cancel() - cancel and stop (pause) streaming
- *
- * Removes all queued buffers from driver's queue and all buffers queued by
- * userspace from videobuf's queue. Returns to state after reqbufs.
- */
-static void __vb2_queue_cancel(struct vb2_queue *q)
-{
-	unsigned int i;
+	unsigned int i;
 
 	/*
 	 * Tell driver to stop all transactions and release all queued
@@ -2435,7 +1712,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	}
 }
 
-static int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
+int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 {
 	int ret;
 
@@ -2477,6 +1754,7 @@ static int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 	dprintk(3, "successful\n");
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_streamon);
 
 /**
  * vb2_queue_error() - signal a fatal error on the queue
@@ -2499,30 +1777,7 @@ void vb2_queue_error(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_queue_error);
 
-/**
- * vb2_streamon - start streaming
- * @q:		videobuf2 queue
- * @type:	type argument passed from userspace to vidioc_streamon handler
- *
- * Should be called from vidioc_streamon handler of a driver.
- * This function:
- * 1) verifies current state
- * 2) passes any previously queued buffers to the driver and starts streaming
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_streamon handler in the driver.
- */
-int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
-{
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
-	return vb2_core_streamon(q, type);
-}
-EXPORT_SYMBOL_GPL(vb2_streamon);
-
-static int vb2_core_streamoff(struct vb2_queue *q, unsigned int type)
+int vb2_core_streamoff(struct vb2_queue *q, unsigned int type)
 {
 	if (type != q->type) {
 		dprintk(1, "invalid stream type\n");
@@ -2545,31 +1800,7 @@ static int vb2_core_streamoff(struct vb2_queue *q, unsigned int type)
 	dprintk(3, "successful\n");
 	return 0;
 }
-
-/**
- * vb2_streamoff - stop streaming
- * @q:		videobuf2 queue
- * @type:	type argument passed from userspace to vidioc_streamoff handler
- *
- * Should be called from vidioc_streamoff handler of a driver.
- * This function:
- * 1) verifies current state,
- * 2) stop streaming and dequeues any queued buffers, including those previously
- *    passed to the driver (after waiting for the driver to finish).
- *
- * This call can be used for pausing playback.
- * The return values from this function are intended to be directly returned
- * from vidioc_streamoff handler in the driver
- */
-int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
-{
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
-	return vb2_core_streamoff(q, type);
-}
-EXPORT_SYMBOL_GPL(vb2_streamoff);
+EXPORT_SYMBOL_GPL(vb2_core_streamoff);
 
 /**
  * __find_plane_by_offset() - find plane associated with the given offset off
@@ -2613,7 +1844,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
  * The return values from this function are intended to be directly returned
  * from vidioc_expbuf handler in driver.
  */
-static int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
+int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
 		unsigned int index, unsigned int plane, unsigned int flags)
 {
 	struct vb2_buffer *vb = NULL;
@@ -2682,22 +1913,7 @@ static int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
 
 	return 0;
 }
-
-/**
- * vb2_expbuf() - Export a buffer as a file descriptor
- * @q:		videobuf2 queue
- * @eb:		export buffer structure passed from userspace to vidioc_expbuf
- *		handler in driver
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_expbuf handler in driver.
- */
-int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
-{
-	return vb2_core_expbuf(q, &eb->fd, eb->type, eb->index,
-				eb->plane, eb->flags);
-}
-EXPORT_SYMBOL_GPL(vb2_expbuf);
+EXPORT_SYMBOL_GPL(vb2_core_expbuf);
 
 /**
  * vb2_mmap() - map video buffers into application address space
@@ -2819,121 +2035,6 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
 #endif
 
-static int __vb2_init_fileio(struct vb2_queue *q, int read);
-static int __vb2_cleanup_fileio(struct vb2_queue *q);
-
-/**
- * vb2_poll() - implements poll userspace operation
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
- * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
- * pending events.
- *
- * The return values from this function are intended to be directly returned
- * from poll handler in driver.
- */
-unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
-{
-	struct video_device *vfd = video_devdata(file);
-	unsigned long req_events = poll_requested_events(wait);
-	struct vb2_buffer *vb = NULL;
-	unsigned int res = 0;
-	unsigned long flags;
-
-	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
-		struct v4l2_fh *fh = file->private_data;
-
-		if (v4l2_event_pending(fh))
-			res = POLLPRI;
-		else if (req_events & POLLPRI)
-			poll_wait(file, &fh->wait, wait);
-	}
-
-	if (!q->is_output && !(req_events & (POLLIN | POLLRDNORM)))
-		return res;
-	if (q->is_output && !(req_events & (POLLOUT | POLLWRNORM)))
-		return res;
-
-	/*
-	 * Start file I/O emulator only if streaming API has not been used yet.
-	 */
-	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
-		if (!q->is_output && (q->io_modes & VB2_READ) &&
-				(req_events & (POLLIN | POLLRDNORM))) {
-			if (__vb2_init_fileio(q, 1))
-				return res | POLLERR;
-		}
-		if (q->is_output && (q->io_modes & VB2_WRITE) &&
-				(req_events & (POLLOUT | POLLWRNORM))) {
-			if (__vb2_init_fileio(q, 0))
-				return res | POLLERR;
-			/*
-			 * Write to OUTPUT queue can be done immediately.
-			 */
-			return res | POLLOUT | POLLWRNORM;
-		}
-	}
-
-	/*
-	 * There is nothing to wait for if the queue isn't streaming, or if the
-	 * error flag is set.
-	 */
-	if (!vb2_is_streaming(q) || q->error)
-		return res | POLLERR;
-	/*
-	 * For compatibility with vb1: if QBUF hasn't been called yet, then
-	 * return POLLERR as well. This only affects capture queues, output
-	 * queues will always initialize waiting_for_buffers to false.
-	 */
-	if (q->waiting_for_buffers)
-		return res | POLLERR;
-
-	/*
-	 * For output streams you can write as long as there are fewer buffers
-	 * queued than there are buffers available.
-	 */
-	if (q->is_output && q->queued_count < q->num_buffers)
-		return res | POLLOUT | POLLWRNORM;
-
-	if (list_empty(&q->done_list)) {
-		/*
-		 * If the last buffer was dequeued from a capture queue,
-		 * return immediately. DQBUF will return -EPIPE.
-		 */
-		if (q->last_buffer_dequeued)
-			return res | POLLIN | POLLRDNORM;
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
-				res | POLLOUT | POLLWRNORM :
-				res | POLLIN | POLLRDNORM;
-	}
-	return res;
-}
-EXPORT_SYMBOL_GPL(vb2_poll);
-
 /**
  * vb2_core_queue_init() - initialize a videobuf2 queue
  * @q:		videobuf2 queue; this structure should be allocated in driver
@@ -2945,7 +2046,7 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  * to the struct vb2_queue description in include/media/videobuf2-core.h
  * for more information.
  */
-static int vb2_core_queue_init(struct vb2_queue *q)
+int vb2_core_queue_init(struct vb2_queue *q)
 {
 	/*
 	 * Sanity check
@@ -2970,55 +2071,7 @@ static int vb2_core_queue_init(struct vb2_queue *q)
 
 	return 0;
 }
-
-static const struct vb2_buf_ops v4l2_buf_ops = {
-	.fill_user_buffer	= __fill_v4l2_buffer,
-	.fill_vb2_buffer	= __fill_vb2_buffer,
-	.set_timestamp		= __set_timestamp,
-};
-
-/**
- * vb2_queue_init() - initialize a videobuf2 queue
- * @q:		videobuf2 queue; this structure should be allocated in driver
- *
- * The vb2_queue structure should be allocated by the driver. The driver is
- * responsible of clearing it's content and setting initial values for some
- * required entries before calling this function.
- * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
- * to the struct vb2_queue description in include/media/videobuf2-core.h
- * for more information.
- */
-int vb2_queue_init(struct vb2_queue *q)
-{
-	/*
-	 * Sanity check
-	 */
-	if (WARN_ON(!q)			  ||
-	    WARN_ON(q->timestamp_flags &
-		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
-		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
-		return -EINVAL;
-
-	/* Warn that the driver should choose an appropriate timestamp type */
-	WARN_ON((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-		V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
-
-	/* Warn that vb2_memory should match with v4l2_memory */
-	if (WARN_ON(VB2_MEMORY_MMAP != (int)V4L2_MEMORY_MMAP)
-		|| WARN_ON(VB2_MEMORY_USERPTR != (int)V4L2_MEMORY_USERPTR)
-		|| WARN_ON(VB2_MEMORY_DMABUF != (int)V4L2_MEMORY_DMABUF))
-		return -EINVAL;
-
-	if (q->buf_struct_size == 0)
-		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
-
-	q->buf_ops = &v4l2_buf_ops;
-	q->is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
-	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);
-
-	return vb2_core_queue_init(q);
-}
-EXPORT_SYMBOL_GPL(vb2_queue_init);
+EXPORT_SYMBOL_GPL(vb2_core_queue_init);
 
 /**
  * vb2_core_queue_release() - stop streaming, release the queue and free memory
@@ -3028,826 +2081,14 @@ EXPORT_SYMBOL_GPL(vb2_queue_init);
  * freeing video buffer memory. The driver is responsible for freeing
  * the vb2_queue structure itself.
  */
-static void vb2_core_queue_release(struct vb2_queue *q)
+void vb2_core_queue_release(struct vb2_queue *q)
 {
 	__vb2_queue_cancel(q);
 	mutex_lock(&q->mmap_lock);
 	__vb2_queue_free(q, q->num_buffers);
 	mutex_unlock(&q->mmap_lock);
 }
-
-/**
- * vb2_queue_release() - stop streaming, release the queue and free memory
- * @q:		videobuf2 queue
- *
- * This function stops streaming and performs necessary clean ups, including
- * freeing video buffer memory. The driver is responsible for freeing
- * the vb2_queue structure itself.
- */
-void vb2_queue_release(struct vb2_queue *q)
-{
-	__vb2_cleanup_fileio(q);
-	vb2_core_queue_release(q);
-}
-EXPORT_SYMBOL_GPL(vb2_queue_release);
-
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
-	struct v4l2_requestbuffers req;
-	struct v4l2_plane p;
-	struct v4l2_buffer b;
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
-	fileio->read_once = q->fileio_read_once;
-	fileio->write_immediately = q->fileio_write_immediately;
-
-	/*
-	 * Request buffers and use MMAP type to force driver
-	 * to allocate buffers by itself.
-	 */
-	fileio->req.count = count;
-	fileio->req.memory = VB2_MEMORY_MMAP;
-	fileio->req.type = q->type;
-	q->fileio = fileio;
-	ret = vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
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
-		bool is_multiplanar = q->is_multiplanar;
-
-		/*
-		 * Queue all buffers.
-		 */
-		for (i = 0; i < q->num_buffers; i++) {
-			struct v4l2_buffer *b = &fileio->b;
-
-			memset(b, 0, sizeof(*b));
-			b->type = q->type;
-			if (is_multiplanar) {
-				memset(&fileio->p, 0, sizeof(fileio->p));
-				b->m.planes = &fileio->p;
-				b->length = 1;
-			}
-			b->memory = q->memory;
-			b->index = i;
-			ret = vb2_internal_qbuf(q, b);
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
-	fileio->req.count = 0;
-	vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
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
-		fileio->req.count = 0;
-		vb2_reqbufs(q, &fileio->req);
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
-	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
-	 * else is able to provide this information with the write() operation.
-	 */
-	bool set_timestamp = !read &&
-		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-		V4L2_BUF_FLAG_TIMESTAMP_COPY;
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
-		/*
-		 * Call vb2_dqbuf to get buffer back.
-		 */
-		memset(&fileio->b, 0, sizeof(fileio->b));
-		fileio->b.type = q->type;
-		fileio->b.memory = q->memory;
-		if (is_multiplanar) {
-			memset(&fileio->p, 0, sizeof(fileio->p));
-			fileio->b.m.planes = &fileio->p;
-			fileio->b.length = 1;
-		}
-		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
-		dprintk(5, "vb2_dqbuf result: %d\n", ret);
-		if (ret)
-			return ret;
-		fileio->dq_count += 1;
-
-		fileio->cur_index = index = fileio->b.index;
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
-		    fileio->b.m.planes[0].data_offset < buf->size) {
-			buf->pos = fileio->b.m.planes[0].data_offset;
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
-		memset(&fileio->b, 0, sizeof(fileio->b));
-		fileio->b.type = q->type;
-		fileio->b.memory = q->memory;
-		fileio->b.index = index;
-		fileio->b.bytesused = buf->pos;
-		if (is_multiplanar) {
-			memset(&fileio->p, 0, sizeof(fileio->p));
-			fileio->p.bytesused = buf->pos;
-			fileio->b.m.planes = &fileio->p;
-			fileio->b.length = 1;
-		}
-		if (set_timestamp)
-			v4l2_get_timestamp(&fileio->b.timestamp);
-		ret = vb2_internal_qbuf(q, &fileio->b);
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
-	bool set_timestamp = false;
-	int prequeue = 0;
-	int index = 0;
-	int ret = 0;
-
-	if (q->is_output) {
-		prequeue = q->num_buffers;
-		set_timestamp =
-			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-			V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	}
-
-	set_freezable();
-
-	for (;;) {
-		struct vb2_buffer *vb;
-
-		/*
-		 * Call vb2_dqbuf to get buffer back.
-		 */
-		memset(&fileio->b, 0, sizeof(fileio->b));
-		fileio->b.type = q->type;
-		fileio->b.memory = q->memory;
-		if (prequeue) {
-			fileio->b.index = index++;
-			prequeue--;
-		} else {
-			call_void_qop(q, wait_finish, q);
-			if (!threadio->stop)
-				ret = vb2_internal_dqbuf(q, &fileio->b, 0);
-			call_void_qop(q, wait_prepare, q);
-			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
-		}
-		if (ret || threadio->stop)
-			break;
-		try_to_freeze();
-
-		vb = q->bufs[fileio->b.index];
-		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
-			if (threadio->fnc(vb, threadio->priv))
-				break;
-		call_void_qop(q, wait_finish, q);
-		if (set_timestamp)
-			v4l2_get_timestamp(&fileio->b.timestamp);
-		if (!threadio->stop)
-			ret = vb2_internal_qbuf(q, &fileio->b);
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
-/*
- * The following functions are not part of the vb2 core API, but are helper
- * functions that plug into struct v4l2_ioctl_ops, struct v4l2_file_operations
- * and struct vb2_ops.
- * They contain boilerplate code that most if not all drivers have to do
- * and so they simplify the driver code.
- */
-
-/* The queue is busy if there is a owner and you are not that owner. */
-static inline bool vb2_queue_is_busy(struct video_device *vdev, struct file *file)
-{
-	return vdev->queue->owner && vdev->queue->owner != file->private_data;
-}
-
-/* vb2 ioctl helpers */
-
-int vb2_ioctl_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *p)
-{
-	struct video_device *vdev = video_devdata(file);
-	int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);
-
-	if (res)
-		return res;
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	res = vb2_core_reqbufs(vdev->queue, p->memory, &p->count);
-	/* If count == 0, then the owner has released all buffers and he
-	   is no longer owner of the queue. Otherwise we have a new owner. */
-	if (res == 0)
-		vdev->queue->owner = p->count ? file->private_data : NULL;
-	return res;
-}
-EXPORT_SYMBOL_GPL(vb2_ioctl_reqbufs);
-
-int vb2_ioctl_create_bufs(struct file *file, void *priv,
-			  struct v4l2_create_buffers *p)
-{
-	struct video_device *vdev = video_devdata(file);
-	int res = vb2_verify_memory_type(vdev->queue, p->memory,
-			p->format.type);
-
-	p->index = vdev->queue->num_buffers;
-	/*
-	 * If count == 0, then just check if memory and type are valid.
-	 * Any -EBUSY result from vb2_verify_memory_type can be mapped to 0.
-	 */
-	if (p->count == 0)
-		return res != -EBUSY ? res : 0;
-	if (res)
-		return res;
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	res = vb2_core_create_bufs(vdev->queue, p->memory,
-			&p->count, &p->format);
-	if (res == 0)
-		vdev->queue->owner = file->private_data;
-	return res;
-}
-EXPORT_SYMBOL_GPL(vb2_ioctl_create_bufs);
-
-int vb2_ioctl_prepare_buf(struct file *file, void *priv,
-			  struct v4l2_buffer *p)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_prepare_buf(vdev->queue, p);
-}
-EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
-
-int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	/* No need to call vb2_queue_is_busy(), anyone can query buffers. */
-	return vb2_querybuf(vdev->queue, p);
-}
-EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
-
-int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_qbuf(vdev->queue, p);
-}
-EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
-
-int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_dqbuf(vdev->queue, p, file->f_flags & O_NONBLOCK);
-}
-EXPORT_SYMBOL_GPL(vb2_ioctl_dqbuf);
-
-int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_streamon(vdev->queue, i);
-}
-EXPORT_SYMBOL_GPL(vb2_ioctl_streamon);
-
-int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_streamoff(vdev->queue, i);
-}
-EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
-
-int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_expbuf(vdev->queue, p);
-}
-EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
-
-/* v4l2_file_operations helpers */
-
-int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	return vb2_mmap(vdev->queue, vma);
-}
-EXPORT_SYMBOL_GPL(vb2_fop_mmap);
-
-int _vb2_fop_release(struct file *file, struct mutex *lock)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	if (lock)
-		mutex_lock(lock);
-	if (file->private_data == vdev->queue->owner) {
-		vb2_queue_release(vdev->queue);
-		vdev->queue->owner = NULL;
-	}
-	if (lock)
-		mutex_unlock(lock);
-	return v4l2_fh_release(file);
-}
-EXPORT_SYMBOL_GPL(_vb2_fop_release);
-
-int vb2_fop_release(struct file *file)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
-
-	return _vb2_fop_release(file, lock);
-}
-EXPORT_SYMBOL_GPL(vb2_fop_release);
-
-ssize_t vb2_fop_write(struct file *file, const char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
-	int err = -EBUSY;
-
-	if (!(vdev->queue->io_modes & VB2_WRITE))
-		return -EINVAL;
-	if (lock && mutex_lock_interruptible(lock))
-		return -ERESTARTSYS;
-	if (vb2_queue_is_busy(vdev, file))
-		goto exit;
-	err = vb2_write(vdev->queue, buf, count, ppos,
-		       file->f_flags & O_NONBLOCK);
-	if (vdev->queue->fileio)
-		vdev->queue->owner = file->private_data;
-exit:
-	if (lock)
-		mutex_unlock(lock);
-	return err;
-}
-EXPORT_SYMBOL_GPL(vb2_fop_write);
-
-ssize_t vb2_fop_read(struct file *file, char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
-	int err = -EBUSY;
-
-	if (!(vdev->queue->io_modes & VB2_READ))
-		return -EINVAL;
-	if (lock && mutex_lock_interruptible(lock))
-		return -ERESTARTSYS;
-	if (vb2_queue_is_busy(vdev, file))
-		goto exit;
-	err = vb2_read(vdev->queue, buf, count, ppos,
-		       file->f_flags & O_NONBLOCK);
-	if (vdev->queue->fileio)
-		vdev->queue->owner = file->private_data;
-exit:
-	if (lock)
-		mutex_unlock(lock);
-	return err;
-}
-EXPORT_SYMBOL_GPL(vb2_fop_read);
-
-unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct vb2_queue *q = vdev->queue;
-	struct mutex *lock = q->lock ? q->lock : vdev->lock;
-	unsigned res;
-	void *fileio;
-
-	/*
-	 * If this helper doesn't know how to lock, then you shouldn't be using
-	 * it but you should write your own.
-	 */
-	WARN_ON(!lock);
-
-	if (lock && mutex_lock_interruptible(lock))
-		return POLLERR;
-
-	fileio = q->fileio;
-
-	res = vb2_poll(vdev->queue, file, wait);
-
-	/* If fileio was started, then we have a new queue owner. */
-	if (!fileio && q->fileio)
-		q->owner = file->private_data;
-	if (lock)
-		mutex_unlock(lock);
-	return res;
-}
-EXPORT_SYMBOL_GPL(vb2_fop_poll);
-
-#ifndef CONFIG_MMU
-unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
-}
-EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
-#endif
-
-/* vb2_ops helpers. Only use if vq->lock is non-NULL. */
-
-void vb2_ops_wait_prepare(struct vb2_queue *vq)
-{
-	mutex_unlock(vq->lock);
-}
-EXPORT_SYMBOL_GPL(vb2_ops_wait_prepare);
-
-void vb2_ops_wait_finish(struct vb2_queue *vq)
-{
-	mutex_lock(vq->lock);
-}
-EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
+EXPORT_SYMBOL_GPL(vb2_core_queue_release);
 
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
diff --git a/drivers/media/v4l2-core/videobuf2-internal.h b/drivers/media/v4l2-core/videobuf2-internal.h
new file mode 100644
index 0000000..79018c7
--- /dev/null
+++ b/drivers/media/v4l2-core/videobuf2-internal.h
@@ -0,0 +1,161 @@
+#ifndef _MEDIA_VIDEOBUF2_INTERNAL_H
+#define _MEDIA_VIDEOBUF2_INTERNAL_H
+
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <media/videobuf2-core.h>
+
+extern int vb2_debug;
+
+#define dprintk(level, fmt, arg...)					      \
+	do {								      \
+		if (vb2_debug >= level)					      \
+			pr_info("vb2: %s: " fmt, __func__, ## arg); \
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
+
+bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
+int vb2_verify_memory_type(struct vb2_queue *q,
+		enum vb2_memory memory, unsigned int type);
+#endif /* _MEDIA_VIDEOBUF2_INTERNAL_H */
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 2f2b738..27b4b9e 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -24,8 +24,1638 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-common.h>
+
 #include <media/videobuf2-v4l2.h>
 
+#include "videobuf2-internal.h"
+
+/* Flags that are set by the vb2 core */
+#define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
+				 V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR | \
+				 V4L2_BUF_FLAG_PREPARED | \
+				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
+/* Output buffer flags that should be passed on to the driver */
+#define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
+				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
+
+/**
+ * __verify_planes_array() - verify that the planes array passed in struct
+ * v4l2_buffer from userspace can be safely used
+ */
+static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+{
+	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
+		return 0;
+
+	/* Is memory for copying plane information present? */
+	if (NULL == b->m.planes) {
+		dprintk(1, "multi-planar buffer passed but "
+			   "planes array not provided\n");
+		return -EINVAL;
+	}
+
+	if (b->length < vb->num_planes || b->length > VB2_MAX_PLANES) {
+		dprintk(1, "incorrect planes array length, "
+			   "expected %d, got %d\n", vb->num_planes, b->length);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * __verify_length() - Verify that the bytesused value for each plane fits in
+ * the plane length and that the data offset doesn't exceed the bytesused value.
+ */
+static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+{
+	unsigned int length;
+	unsigned int bytesused;
+	unsigned int plane;
+
+	if (!V4L2_TYPE_IS_OUTPUT(b->type))
+		return 0;
+
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			length = (b->memory == VB2_MEMORY_USERPTR ||
+				  b->memory == VB2_MEMORY_DMABUF)
+			       ? b->m.planes[plane].length
+				: vb->planes[plane].length;
+			bytesused = b->m.planes[plane].bytesused
+				  ? b->m.planes[plane].bytesused : length;
+
+			if (b->m.planes[plane].bytesused > length)
+				return -EINVAL;
+
+			if (b->m.planes[plane].data_offset > 0 &&
+			    b->m.planes[plane].data_offset >= bytesused)
+				return -EINVAL;
+		}
+	} else {
+		length = (b->memory == VB2_MEMORY_USERPTR)
+			? b->length : vb->planes[0].length;
+
+		if (b->bytesused > length)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __set_timestamp(struct vb2_buffer *vb, const void *pb)
+{
+	const struct v4l2_buffer *b = pb;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vb2_queue *q = vb->vb2_queue;
+
+	if (q->is_output) {
+		/*
+		 * For output buffers copy the timestamp if needed,
+		 * and the timecode field and flag if needed.
+		 */
+		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+				V4L2_BUF_FLAG_TIMESTAMP_COPY)
+			vbuf->timestamp = b->timestamp;
+		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
+		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
+			vbuf->timecode = b->timecode;
+	}
+	return 0;
+};
+
+static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
+{
+	static bool check_once;
+
+	if (check_once)
+		return;
+
+	check_once = true;
+	WARN_ON(1);
+
+	pr_warn("use of bytesused == 0 is deprecated and will be removed in the future,\n");
+	if (vb->vb2_queue->allow_zero_bytesused)
+		pr_warn("use VIDIOC_DECODER_CMD(V4L2_DEC_CMD_STOP) instead.\n");
+	else
+		pr_warn("use the actual size instead.\n");
+}
+
+static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
+				    const char *opname)
+{
+	if (b->type != q->type) {
+		dprintk(1, "%s: invalid buffer type\n", opname);
+		return -EINVAL;
+	}
+
+	if (b->index >= q->num_buffers) {
+		dprintk(1, "%s: buffer index out of range\n", opname);
+		return -EINVAL;
+	}
+
+	if (q->bufs[b->index] == NULL) {
+		/* Should never happen */
+		dprintk(1, "%s: buffer is NULL\n", opname);
+		return -EINVAL;
+	}
+
+	if (b->memory != q->memory) {
+		dprintk(1, "%s: invalid memory type\n", opname);
+		return -EINVAL;
+	}
+
+	return __verify_planes_array(q->bufs[b->index], b);
+}
+
+/**
+ * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
+ * returned to userspace
+ */
+static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
+{
+	struct v4l2_buffer *b = pb;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
+
+	/* Copy back data such as timestamp, flags, etc. */
+	b->index = vb->index;
+	b->type = vb->type;
+	b->memory = vb->memory;
+	b->bytesused = 0;
+
+	b->flags = vbuf->flags;
+	b->field = vbuf->field;
+	b->timestamp = vbuf->timestamp;
+	b->timecode = vbuf->timecode;
+	b->sequence = vbuf->sequence;
+	b->reserved2 = 0;
+	b->reserved = 0;
+
+	if (q->is_multiplanar) {
+		/*
+		 * Fill in plane-related data if userspace provided an array
+		 * for it. The caller has already verified memory and size.
+		 */
+		b->length = vb->num_planes;
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			struct v4l2_plane *pdst = &b->m.planes[plane];
+			struct vb2_plane *psrc = &vb->planes[plane];
+
+			pdst->bytesused = psrc->bytesused;
+			pdst->length = psrc->length;
+			if (q->memory == VB2_MEMORY_MMAP)
+				pdst->m.mem_offset = psrc->m.offset;
+			else if (q->memory == VB2_MEMORY_USERPTR)
+				pdst->m.userptr = psrc->m.userptr;
+			else if (q->memory == VB2_MEMORY_DMABUF)
+				pdst->m.fd = psrc->m.fd;
+			pdst->data_offset = psrc->data_offset;
+			memset(pdst->reserved, 0, sizeof(pdst->reserved));
+		}
+	} else {
+		/*
+		 * We use length and offset in v4l2_planes array even for
+		 * single-planar buffers, but userspace does not.
+		 */
+		b->length = vb->planes[0].length;
+		b->bytesused = vb->planes[0].bytesused;
+		if (q->memory == VB2_MEMORY_MMAP)
+			b->m.offset = vb->planes[0].m.offset;
+		else if (q->memory == VB2_MEMORY_USERPTR)
+			b->m.userptr = vb->planes[0].m.userptr;
+		else if (q->memory == VB2_MEMORY_DMABUF)
+			b->m.fd = vb->planes[0].m.fd;
+	}
+
+	/*
+	 * Clear any buffer state related flags.
+	 */
+	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
+	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
+	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
+	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
+		/*
+		 * For non-COPY timestamps, drop timestamp source bits
+		 * and obtain the timestamp source from the queue.
+		 */
+		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	}
+
+	switch (vb->state) {
+	case VB2_BUF_STATE_QUEUED:
+	case VB2_BUF_STATE_ACTIVE:
+		b->flags |= V4L2_BUF_FLAG_QUEUED;
+		break;
+	case VB2_BUF_STATE_ERROR:
+		b->flags |= V4L2_BUF_FLAG_ERROR;
+		/* fall through */
+	case VB2_BUF_STATE_DONE:
+		b->flags |= V4L2_BUF_FLAG_DONE;
+		break;
+	case VB2_BUF_STATE_PREPARED:
+		b->flags |= V4L2_BUF_FLAG_PREPARED;
+		break;
+	case VB2_BUF_STATE_PREPARING:
+	case VB2_BUF_STATE_DEQUEUED:
+	case VB2_BUF_STATE_REQUEUEING:
+		/* nothing */
+		break;
+	}
+
+	if (vb2_buffer_in_use(q, vb))
+		b->flags |= V4L2_BUF_FLAG_MAPPED;
+
+	return 0;
+}
+
+/**
+ * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
+ * v4l2_buffer by the userspace. It also verifies that struct
+ * v4l2_buffer has a valid number of planes.
+ */
+static int __fill_vb2_buffer(struct vb2_buffer *vb,
+		const void *pb, struct vb2_plane *planes)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	const struct v4l2_buffer *b = pb;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	unsigned int plane;
+	int ret;
+
+	ret = __verify_length(vb, b);
+	if (ret < 0) {
+		dprintk(1, "plane parameters verification failed: %d\n", ret);
+		return ret;
+	}
+	if (b->field == V4L2_FIELD_ALTERNATE && q->is_output) {
+		/*
+		 * If the format's field is ALTERNATE, then the buffer's field
+		 * should be either TOP or BOTTOM, not ALTERNATE since that
+		 * makes no sense. The driver has to know whether the
+		 * buffer represents a top or a bottom field in order to
+		 * program any DMA correctly. Using ALTERNATE is wrong, since
+		 * that just says that it is either a top or a bottom field,
+		 * but not which of the two it is.
+		 */
+		dprintk(1, "the field is incorrectly set to ALTERNATE "
+					"for an output buffer\n");
+		return -EINVAL;
+	}
+	vbuf->timestamp.tv_sec = 0;
+	vbuf->timestamp.tv_usec = 0;
+	vbuf->sequence = 0;
+
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		if (b->memory == VB2_MEMORY_USERPTR) {
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				planes[plane].m.userptr =
+					b->m.planes[plane].m.userptr;
+				planes[plane].length =
+					b->m.planes[plane].length;
+			}
+		}
+		if (b->memory == VB2_MEMORY_DMABUF) {
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				planes[plane].m.fd =
+					b->m.planes[plane].m.fd;
+				planes[plane].length =
+					b->m.planes[plane].length;
+			}
+		}
+
+		/* Fill in driver-provided information for OUTPUT types */
+		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+			/*
+			 * Will have to go up to b->length when API starts
+			 * accepting variable number of planes.
+			 *
+			 * If bytesused == 0 for the output buffer, then fall
+			 * back to the full buffer size. In that case
+			 * userspace clearly never bothered to set it and
+			 * it's a safe assumption that they really meant to
+			 * use the full plane sizes.
+			 *
+			 * Some drivers, e.g. old codec drivers, use bytesused == 0
+			 * as a way to indicate that streaming is finished.
+			 * In that case, the driver should use the
+			 * allow_zero_bytesused flag to keep old userspace
+			 * applications working.
+			 */
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				struct vb2_plane *pdst = &planes[plane];
+				struct v4l2_plane *psrc = &b->m.planes[plane];
+
+				if (psrc->bytesused == 0)
+					vb2_warn_zero_bytesused(vb);
+
+				if (vb->vb2_queue->allow_zero_bytesused)
+					pdst->bytesused = psrc->bytesused;
+				else
+					pdst->bytesused = psrc->bytesused ?
+						psrc->bytesused : pdst->length;
+				pdst->data_offset = psrc->data_offset;
+			}
+		}
+	} else {
+		/*
+		 * Single-planar buffers do not use planes array,
+		 * so fill in relevant v4l2_buffer struct fields instead.
+		 * In videobuf we use our internal V4l2_planes struct for
+		 * single-planar buffers as well, for simplicity.
+		 *
+		 * If bytesused == 0 for the output buffer, then fall back
+		 * to the full buffer size as that's a sensible default.
+		 *
+		 * Some drivers, e.g. old codec drivers, use bytesused == 0 as
+		 * a way to indicate that streaming is finished. In that case,
+		 * the driver should use the allow_zero_bytesused flag to keep
+		 * old userspace applications working.
+		 */
+		if (b->memory == VB2_MEMORY_USERPTR) {
+			planes[0].m.userptr = b->m.userptr;
+			planes[0].length = b->length;
+		}
+
+		if (b->memory == VB2_MEMORY_DMABUF) {
+			planes[0].m.fd = b->m.fd;
+			planes[0].length = b->length;
+		}
+
+		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+			if (b->bytesused == 0)
+				vb2_warn_zero_bytesused(vb);
+
+			if (vb->vb2_queue->allow_zero_bytesused)
+				planes[0].bytesused = b->bytesused;
+			else
+				planes[0].bytesused = b->bytesused ?
+					b->bytesused : planes[0].length;
+		} else
+			planes[0].bytesused = 0;
+
+	}
+
+	/* Zero flags that the vb2 core handles */
+	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
+	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
+	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
+		/*
+		 * Non-COPY timestamps and non-OUTPUT queues will get
+		 * their timestamp and timestamp source flags from the
+		 * queue.
+		 */
+		vbuf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	}
+
+	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+		/*
+		 * For output buffers mask out the timecode flag:
+		 * this will be handled later in vb2_internal_qbuf().
+		 * The 'field' is valid metadata for this output buffer
+		 * and so that needs to be copied here.
+		 */
+		vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
+		vbuf->field = b->field;
+	} else {
+		/* Zero any output buffer flags as this is a capture buffer */
+		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
+	}
+
+	return 0;
+}
+
+static const struct vb2_buf_ops v4l2_buf_ops = {
+	.fill_user_buffer	= __fill_v4l2_buffer,
+	.fill_vb2_buffer	= __fill_vb2_buffer,
+	.set_timestamp		= __set_timestamp,
+};
+
+/**
+ * vb2_querybuf() - query video buffer information
+ * @q:		videobuf queue
+ * @b:		buffer struct passed from userspace to vidioc_querybuf handler
+ *		in driver
+ *
+ * Should be called from vidioc_querybuf ioctl handler in driver.
+ * This function will verify the passed v4l2_buffer structure and fill the
+ * relevant information for the userspace.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_querybuf handler in driver.
+ */
+int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	struct vb2_buffer *vb;
+	int ret;
+
+	if (b->type != q->type) {
+		dprintk(1, "wrong buffer type\n");
+		return -EINVAL;
+	}
+
+	if (b->index >= q->num_buffers) {
+		dprintk(1, "buffer index out of range\n");
+		return -EINVAL;
+	}
+	vb = q->bufs[b->index];
+	ret = __verify_planes_array(vb, b);
+
+	return ret ? ret : vb2_core_querybuf(q, b->index, b);
+}
+EXPORT_SYMBOL(vb2_querybuf);
+
+/**
+ * vb2_reqbufs() - Wrapper for vb2_core_reqbufs() that also verifies
+ * the memory and type values.
+ * @q:		videobuf2 queue
+ * @req:	struct passed from userspace to vidioc_reqbufs handler
+ *		in driver
+ */
+int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
+{
+	int ret = vb2_verify_memory_type(q, req->memory, req->type);
+
+	return ret ? ret : vb2_core_reqbufs(q, req->memory, &req->count);
+}
+EXPORT_SYMBOL_GPL(vb2_reqbufs);
+
+/**
+ * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_prepare_buf
+ *		handler in driver
+ *
+ * Should be called from vidioc_prepare_buf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) calls buf_prepare callback in the driver (if provided), in which
+ *    driver-specific buffer initialization can be performed,
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_prepare_buf handler in driver.
+ */
+int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	int ret;
+
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+
+	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
+
+	return ret ? ret : vb2_core_prepare_buf(q, b->index, b);
+}
+EXPORT_SYMBOL_GPL(vb2_prepare_buf);
+
+/**
+ * vb2_create_bufs() - Wrapper for vb2_core_create_bufs() that also verifies
+ * the memory and type values.
+ * @q:		videobuf2 queue
+ * @create:	creation parameters, passed from userspace to vidioc_create_bufs
+ *		handler in driver
+ */
+int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
+{
+	int ret = vb2_verify_memory_type(q, create->memory,
+			create->format.type);
+
+	create->index = q->num_buffers;
+	if (create->count == 0)
+		return ret != -EBUSY ? ret : 0;
+	return ret ? ret : vb2_core_create_bufs(q, create->memory,
+		&create->count, &create->format);
+}
+EXPORT_SYMBOL_GPL(vb2_create_bufs);
+
+static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
+
+	return ret ? ret : vb2_core_qbuf(q, b->index, b);
+}
+
+/**
+ * vb2_qbuf() - Queue a buffer from userspace
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_qbuf handler
+ *		in driver
+ *
+ * Should be called from vidioc_qbuf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
+ *    which driver-specific buffer initialization can be performed,
+ * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
+ *    callback for processing.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_qbuf handler in driver.
+ */
+int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+
+	return vb2_internal_qbuf(q, b);
+}
+EXPORT_SYMBOL_GPL(vb2_qbuf);
+
+static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
+		bool nonblocking)
+{
+	int ret;
+
+	if (b->type != q->type) {
+		dprintk(1, "invalid buffer type\n");
+		return -EINVAL;
+	}
+
+	ret = vb2_core_dqbuf(q, b, nonblocking);
+
+	if (!ret && !q->is_output &&
+			b->flags & V4L2_BUF_FLAG_LAST)
+		q->last_buffer_dequeued = true;
+
+	return ret;
+}
+
+/**
+ * vb2_dqbuf() - Dequeue a buffer to the userspace
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
+ *		in driver
+ * @nonblocking: if true, this call will not sleep waiting for a buffer if no
+ *		 buffers ready for dequeuing are present. Normally the driver
+ *		 would be passing (file->f_flags & O_NONBLOCK) here
+ *
+ * Should be called from vidioc_dqbuf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) calls buf_finish callback in the driver (if provided), in which
+ *    driver can perform any additional operations that may be required before
+ *    returning the buffer to userspace, such as cache sync,
+ * 3) the buffer struct members are filled with relevant information for
+ *    the userspace.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_dqbuf handler in driver.
+ */
+int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+{
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+	return vb2_internal_dqbuf(q, b, nonblocking);
+}
+EXPORT_SYMBOL_GPL(vb2_dqbuf);
+
+/**
+ * vb2_streamon - start streaming
+ * @q:		videobuf2 queue
+ * @type:	type argument passed from userspace to vidioc_streamon handler
+ *
+ * Should be called from vidioc_streamon handler of a driver.
+ * This function:
+ * 1) verifies current state
+ * 2) passes any previously queued buffers to the driver and starts streaming
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_streamon handler in the driver.
+ */
+int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+{
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+	return vb2_core_streamon(q, type);
+}
+EXPORT_SYMBOL_GPL(vb2_streamon);
+
+/**
+ * vb2_streamoff - stop streaming
+ * @q:		videobuf2 queue
+ * @type:	type argument passed from userspace to vidioc_streamoff handler
+ *
+ * Should be called from vidioc_streamoff handler of a driver.
+ * This function:
+ * 1) verifies current state,
+ * 2) stop streaming and dequeues any queued buffers, including those previously
+ *    passed to the driver (after waiting for the driver to finish).
+ *
+ * This call can be used for pausing playback.
+ * The return values from this function are intended to be directly returned
+ * from vidioc_streamoff handler in the driver
+ */
+int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+{
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+	return vb2_core_streamoff(q, type);
+}
+EXPORT_SYMBOL_GPL(vb2_streamoff);
+
+/**
+ * vb2_expbuf() - Export a buffer as a file descriptor
+ * @q:		videobuf2 queue
+ * @eb:		export buffer structure passed from userspace to vidioc_expbuf
+ *		handler in driver
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_expbuf handler in driver.
+ */
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
+{
+	return vb2_core_expbuf(q, &eb->fd, eb->type, eb->index,
+				eb->plane, eb->flags);
+}
+EXPORT_SYMBOL_GPL(vb2_expbuf);
+
+/**
+ * vb2_queue_init() - initialize a videobuf2 queue
+ * @q:		videobuf2 queue; this structure should be allocated in driver
+ *
+ * The vb2_queue structure should be allocated by the driver. The driver is
+ * responsible of clearing it's content and setting initial values for some
+ * required entries before calling this function.
+ * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
+ * to the struct vb2_queue description in include/media/videobuf2-core.h
+ * for more information.
+ */
+int vb2_queue_init(struct vb2_queue *q)
+{
+	/*
+	 * Sanity check
+	 */
+	if (WARN_ON(!q)			  ||
+	    WARN_ON(q->timestamp_flags &
+		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
+		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
+		return -EINVAL;
+
+	/* Warn that the driver should choose an appropriate timestamp type */
+	WARN_ON((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+		V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
+
+	/* Warn that vb2_memory should match with v4l2_memory */
+	if (WARN_ON(VB2_MEMORY_MMAP != (int)V4L2_MEMORY_MMAP)
+		|| WARN_ON(VB2_MEMORY_USERPTR != (int)V4L2_MEMORY_USERPTR)
+		|| WARN_ON(VB2_MEMORY_DMABUF != (int)V4L2_MEMORY_DMABUF))
+		return -EINVAL;
+
+	if (q->buf_struct_size == 0)
+		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
+
+	q->buf_ops = &v4l2_buf_ops;
+	q->is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);
+
+	return vb2_core_queue_init(q);
+}
+EXPORT_SYMBOL_GPL(vb2_queue_init);
+
+static int __vb2_init_fileio(struct vb2_queue *q, int read);
+static int __vb2_cleanup_fileio(struct vb2_queue *q);
+
+/**
+ * vb2_queue_release() - stop streaming, release the queue and free memory
+ * @q:		videobuf2 queue
+ *
+ * This function stops streaming and performs necessary clean ups, including
+ * freeing video buffer memory. The driver is responsible for freeing
+ * the vb2_queue structure itself.
+ */
+void vb2_queue_release(struct vb2_queue *q)
+{
+	__vb2_cleanup_fileio(q);
+	vb2_core_queue_release(q);
+}
+EXPORT_SYMBOL_GPL(vb2_queue_release);
+
+/**
+ * vb2_poll() - implements poll userspace operation
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
+ * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
+ * pending events.
+ *
+ * The return values from this function are intended to be directly returned
+ * from poll handler in driver.
+ */
+unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
+{
+	struct video_device *vfd = video_devdata(file);
+	unsigned long req_events = poll_requested_events(wait);
+	struct vb2_buffer *vb = NULL;
+	unsigned int res = 0;
+	unsigned long flags;
+
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
+		struct v4l2_fh *fh = file->private_data;
+
+		if (v4l2_event_pending(fh))
+			res = POLLPRI;
+		else if (req_events & POLLPRI)
+			poll_wait(file, &fh->wait, wait);
+	}
+
+	if (!q->is_output && !(req_events & (POLLIN | POLLRDNORM)))
+		return res;
+	if (q->is_output && !(req_events & (POLLOUT | POLLWRNORM)))
+		return res;
+
+	/*
+	 * Start file I/O emulator only if streaming API has not been used yet.
+	 */
+	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
+		if (!q->is_output && (q->io_modes & VB2_READ) &&
+				(req_events & (POLLIN | POLLRDNORM))) {
+			if (__vb2_init_fileio(q, 1))
+				return res | POLLERR;
+		}
+		if (q->is_output && (q->io_modes & VB2_WRITE) &&
+				(req_events & (POLLOUT | POLLWRNORM))) {
+			if (__vb2_init_fileio(q, 0))
+				return res | POLLERR;
+			/*
+			 * Write to OUTPUT queue can be done immediately.
+			 */
+			return res | POLLOUT | POLLWRNORM;
+		}
+	}
+
+	/*
+	 * There is nothing to wait for if the queue isn't streaming, or if the
+	 * error flag is set.
+	 */
+	if (!vb2_is_streaming(q) || q->error)
+		return res | POLLERR;
+	/*
+	 * For compatibility with vb1: if QBUF hasn't been called yet, then
+	 * return POLLERR as well. This only affects capture queues, output
+	 * queues will always initialize waiting_for_buffers to false.
+	 */
+	if (q->waiting_for_buffers)
+		return res | POLLERR;
+
+	/*
+	 * For output streams you can write as long as there are fewer buffers
+	 * queued than there are buffers available.
+	 */
+	if (q->is_output && q->queued_count < q->num_buffers)
+		return res | POLLOUT | POLLWRNORM;
+
+	if (list_empty(&q->done_list)) {
+		/*
+		 * If the last buffer was dequeued from a capture queue,
+		 * return immediately. DQBUF will return -EPIPE.
+		 */
+		if (q->last_buffer_dequeued)
+			return res | POLLIN | POLLRDNORM;
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
+				res | POLLOUT | POLLWRNORM :
+				res | POLLIN | POLLRDNORM;
+	}
+	return res;
+}
+EXPORT_SYMBOL_GPL(vb2_poll);
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
+	struct v4l2_requestbuffers req;
+	struct v4l2_plane p;
+	struct v4l2_buffer b;
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
+	fileio->read_once = q->fileio_read_once;
+	fileio->write_immediately = q->fileio_write_immediately;
+
+	/*
+	 * Request buffers and use MMAP type to force driver
+	 * to allocate buffers by itself.
+	 */
+	fileio->req.count = count;
+	fileio->req.memory = VB2_MEMORY_MMAP;
+	fileio->req.type = q->type;
+	q->fileio = fileio;
+	ret = vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
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
+		bool is_multiplanar = q->is_multiplanar;
+
+		/*
+		 * Queue all buffers.
+		 */
+		for (i = 0; i < q->num_buffers; i++) {
+			struct v4l2_buffer *b = &fileio->b;
+
+			memset(b, 0, sizeof(*b));
+			b->type = q->type;
+			if (is_multiplanar) {
+				memset(&fileio->p, 0, sizeof(fileio->p));
+				b->m.planes = &fileio->p;
+				b->length = 1;
+			}
+			b->memory = q->memory;
+			b->index = i;
+			ret = vb2_internal_qbuf(q, b);
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
+	fileio->req.count = 0;
+	vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
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
+		fileio->req.count = 0;
+		vb2_reqbufs(q, &fileio->req);
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
+	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
+	 * else is able to provide this information with the write() operation.
+	 */
+	bool set_timestamp = !read &&
+		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+		V4L2_BUF_FLAG_TIMESTAMP_COPY;
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
+		/*
+		 * Call vb2_dqbuf to get buffer back.
+		 */
+		memset(&fileio->b, 0, sizeof(fileio->b));
+		fileio->b.type = q->type;
+		fileio->b.memory = q->memory;
+		if (is_multiplanar) {
+			memset(&fileio->p, 0, sizeof(fileio->p));
+			fileio->b.m.planes = &fileio->p;
+			fileio->b.length = 1;
+		}
+		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
+		dprintk(5, "vb2_dqbuf result: %d\n", ret);
+		if (ret)
+			return ret;
+		fileio->dq_count += 1;
+
+		fileio->cur_index = index = fileio->b.index;
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
+		    fileio->b.m.planes[0].data_offset < buf->size) {
+			buf->pos = fileio->b.m.planes[0].data_offset;
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
+		memset(&fileio->b, 0, sizeof(fileio->b));
+		fileio->b.type = q->type;
+		fileio->b.memory = q->memory;
+		fileio->b.index = index;
+		fileio->b.bytesused = buf->pos;
+		if (is_multiplanar) {
+			memset(&fileio->p, 0, sizeof(fileio->p));
+			fileio->p.bytesused = buf->pos;
+			fileio->b.m.planes = &fileio->p;
+			fileio->b.length = 1;
+		}
+		if (set_timestamp)
+			v4l2_get_timestamp(&fileio->b.timestamp);
+		ret = vb2_internal_qbuf(q, &fileio->b);
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
+	bool set_timestamp = false;
+	int prequeue = 0;
+	int index = 0;
+	int ret = 0;
+
+	if (q->is_output) {
+		prequeue = q->num_buffers;
+		set_timestamp =
+			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+			V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	}
+
+	set_freezable();
+
+	for (;;) {
+		struct vb2_buffer *vb;
+
+		/*
+		 * Call vb2_dqbuf to get buffer back.
+		 */
+		memset(&fileio->b, 0, sizeof(fileio->b));
+		fileio->b.type = q->type;
+		fileio->b.memory = q->memory;
+		if (prequeue) {
+			fileio->b.index = index++;
+			prequeue--;
+		} else {
+			call_void_qop(q, wait_finish, q);
+			if (!threadio->stop)
+				ret = vb2_internal_dqbuf(q, &fileio->b, 0);
+			call_void_qop(q, wait_prepare, q);
+			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
+		}
+		if (ret || threadio->stop)
+			break;
+		try_to_freeze();
+
+		vb = q->bufs[fileio->b.index];
+		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
+			if (threadio->fnc(vb, threadio->priv))
+				break;
+		call_void_qop(q, wait_finish, q);
+		if (set_timestamp)
+			v4l2_get_timestamp(&fileio->b.timestamp);
+		if (!threadio->stop)
+			ret = vb2_internal_qbuf(q, &fileio->b);
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
+/*
+ * The following functions are not part of the vb2 core API, but are helper
+ * functions that plug into struct v4l2_ioctl_ops, struct v4l2_file_operations
+ * and struct vb2_ops.
+ * They contain boilerplate code that most if not all drivers have to do
+ * and so they simplify the driver code.
+ */
+
+/* The queue is busy if there is a owner and you are not that owner. */
+static inline bool vb2_queue_is_busy(struct video_device *vdev, struct file *file)
+{
+	return vdev->queue->owner && vdev->queue->owner != file->private_data;
+}
+
+/* vb2 ioctl helpers */
+
+int vb2_ioctl_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p)
+{
+	struct video_device *vdev = video_devdata(file);
+	int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);
+
+	if (res)
+		return res;
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	res = vb2_core_reqbufs(vdev->queue, p->memory, &p->count);
+	/* If count == 0, then the owner has released all buffers and he
+	   is no longer owner of the queue. Otherwise we have a new owner. */
+	if (res == 0)
+		vdev->queue->owner = p->count ? file->private_data : NULL;
+	return res;
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_reqbufs);
+
+int vb2_ioctl_create_bufs(struct file *file, void *priv,
+			  struct v4l2_create_buffers *p)
+{
+	struct video_device *vdev = video_devdata(file);
+	int res = vb2_verify_memory_type(vdev->queue, p->memory,
+			p->format.type);
+
+	p->index = vdev->queue->num_buffers;
+	/*
+	 * If count == 0, then just check if memory and type are valid.
+	 * Any -EBUSY result from vb2_verify_memory_type can be mapped to 0.
+	 */
+	if (p->count == 0)
+		return res != -EBUSY ? res : 0;
+	if (res)
+		return res;
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	res = vb2_core_create_bufs(vdev->queue, p->memory, &p->count,
+			&p->format);
+	if (res == 0)
+		vdev->queue->owner = file->private_data;
+	return res;
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_create_bufs);
+
+int vb2_ioctl_prepare_buf(struct file *file, void *priv,
+			  struct v4l2_buffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_prepare_buf(vdev->queue, p);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
+
+int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	/* No need to call vb2_queue_is_busy(), anyone can query buffers. */
+	return vb2_querybuf(vdev->queue, p);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
+
+int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_qbuf(vdev->queue, p);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
+
+int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_dqbuf(vdev->queue, p, file->f_flags & O_NONBLOCK);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_dqbuf);
+
+int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_streamon(vdev->queue, i);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_streamon);
+
+int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_streamoff(vdev->queue, i);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
+
+int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_expbuf(vdev->queue, p);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
+
+/* v4l2_file_operations helpers */
+
+int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	return vb2_mmap(vdev->queue, vma);
+}
+EXPORT_SYMBOL_GPL(vb2_fop_mmap);
+
+int _vb2_fop_release(struct file *file, struct mutex *lock)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (lock)
+		mutex_lock(lock);
+	if (file->private_data == vdev->queue->owner) {
+		vb2_queue_release(vdev->queue);
+		vdev->queue->owner = NULL;
+	}
+	if (lock)
+		mutex_unlock(lock);
+	return v4l2_fh_release(file);
+}
+EXPORT_SYMBOL_GPL(_vb2_fop_release);
+
+int vb2_fop_release(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
+
+	return _vb2_fop_release(file, lock);
+}
+EXPORT_SYMBOL_GPL(vb2_fop_release);
+
+ssize_t vb2_fop_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
+	int err = -EBUSY;
+
+	if (!(vdev->queue->io_modes & VB2_WRITE))
+		return -EINVAL;
+	if (lock && mutex_lock_interruptible(lock))
+		return -ERESTARTSYS;
+	if (vb2_queue_is_busy(vdev, file))
+		goto exit;
+	err = vb2_write(vdev->queue, buf, count, ppos,
+		       file->f_flags & O_NONBLOCK);
+	if (vdev->queue->fileio)
+		vdev->queue->owner = file->private_data;
+exit:
+	if (lock)
+		mutex_unlock(lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vb2_fop_write);
+
+ssize_t vb2_fop_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
+	int err = -EBUSY;
+
+	if (!(vdev->queue->io_modes & VB2_READ))
+		return -EINVAL;
+	if (lock && mutex_lock_interruptible(lock))
+		return -ERESTARTSYS;
+	if (vb2_queue_is_busy(vdev, file))
+		goto exit;
+	err = vb2_read(vdev->queue, buf, count, ppos,
+		       file->f_flags & O_NONBLOCK);
+	if (vdev->queue->fileio)
+		vdev->queue->owner = file->private_data;
+exit:
+	if (lock)
+		mutex_unlock(lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vb2_fop_read);
+
+unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct vb2_queue *q = vdev->queue;
+	struct mutex *lock = q->lock ? q->lock : vdev->lock;
+	unsigned res;
+	void *fileio;
+
+	/*
+	 * If this helper doesn't know how to lock, then you shouldn't be using
+	 * it but you should write your own.
+	 */
+	WARN_ON(!lock);
+
+	if (lock && mutex_lock_interruptible(lock))
+		return POLLERR;
+
+	fileio = q->fileio;
+
+	res = vb2_poll(vdev->queue, file, wait);
+
+	/* If fileio was started, then we have a new queue owner. */
+	if (!fileio && q->fileio)
+		q->owner = file->private_data;
+	if (lock)
+		mutex_unlock(lock);
+	return res;
+}
+EXPORT_SYMBOL_GPL(vb2_fop_poll);
+
+#ifndef CONFIG_MMU
+unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
+}
+EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
+#endif
+
+/* vb2_ops helpers. Only use if vq->lock is non-NULL. */
+
+void vb2_ops_wait_prepare(struct vb2_queue *vq)
+{
+	mutex_unlock(vq->lock);
+}
+EXPORT_SYMBOL_GPL(vb2_ops_wait_prepare);
+
+void vb2_ops_wait_finish(struct vb2_queue *vq)
+{
+	mutex_lock(vq->lock);
+}
+EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
+
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index d3659d7..647ebfe 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -15,7 +15,6 @@
 #include <linux/mm_types.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
-#include <linux/videodev2.h>
 #include <linux/dma-buf.h>
 
 #define VB2_MAX_FRAME	(32)
@@ -504,23 +503,25 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
 void vb2_discard_done(struct vb2_queue *q);
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
-int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
-int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
+int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
+		unsigned int *count);
+int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
+		unsigned int *count, const void *parg);
+int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking);
 
-int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
-int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
+int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
 
-int __must_check vb2_queue_init(struct vb2_queue *q);
+int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
+		unsigned int index, unsigned int plane, unsigned int flags);
 
-void vb2_queue_release(struct vb2_queue *q);
-void vb2_queue_error(struct vb2_queue *q);
-
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
-int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
-int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
+int vb2_core_queue_init(struct vb2_queue *q);
+void vb2_core_queue_release(struct vb2_queue *q);
 
-int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
-int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
+void vb2_queue_error(struct vb2_queue *q);
 
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
 #ifndef CONFIG_MMU
@@ -530,41 +531,6 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 				    unsigned long pgoff,
 				    unsigned long flags);
 #endif
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
 
 /**
  * vb2_is_streaming() - return streaming status of the queue
@@ -669,48 +635,4 @@ static inline void vb2_clear_last_buffer_dequeued(struct vb2_queue *q)
 	q->last_buffer_dequeued = false;
 }
 
-/*
- * The following functions are not part of the vb2 core API, but are simple
- * helper functions that you can use in your struct v4l2_file_operations,
- * struct v4l2_ioctl_ops and struct vb2_ops. They will serialize if vb2_queue->lock
- * or video_device->lock is set, and they will set and test vb2_queue->owner
- * to check if the calling filehandle is permitted to do the queuing operation.
- */
-
-/* struct v4l2_ioctl_ops helpers */
-
-int vb2_ioctl_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *p);
-int vb2_ioctl_create_bufs(struct file *file, void *priv,
-			  struct v4l2_create_buffers *p);
-int vb2_ioctl_prepare_buf(struct file *file, void *priv,
-			  struct v4l2_buffer *p);
-int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p);
-int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
-int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p);
-int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i);
-int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i);
-int vb2_ioctl_expbuf(struct file *file, void *priv,
-	struct v4l2_exportbuffer *p);
-
-/* struct v4l2_file_operations helpers */
-
-int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
-int vb2_fop_release(struct file *file);
-int _vb2_fop_release(struct file *file, struct mutex *lock);
-ssize_t vb2_fop_write(struct file *file, const char __user *buf,
-		size_t count, loff_t *ppos);
-ssize_t vb2_fop_read(struct file *file, char __user *buf,
-		size_t count, loff_t *ppos);
-unsigned int vb2_fop_poll(struct file *file, poll_table *wait);
-#ifndef CONFIG_MMU
-unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags);
-#endif
-
-/* struct vb2_ops helpers, only use if vq->lock is non-NULL. */
-
-void vb2_ops_wait_prepare(struct vb2_queue *vq);
-void vb2_ops_wait_finish(struct vb2_queue *vq);
-
 #endif /* _MEDIA_VIDEOBUF2_CORE_H */
diff --git a/include/media/videobuf2-dvb.h b/include/media/videobuf2-dvb.h
index 8f61456..5b64c9e 100644
--- a/include/media/videobuf2-dvb.h
+++ b/include/media/videobuf2-dvb.h
@@ -6,7 +6,13 @@
 #include <dvb_demux.h>
 #include <dvb_net.h>
 #include <dvb_frontend.h>
-#include <media/videobuf2-core.h>
+
+#include <media/videobuf2-v4l2.h>
+/*
+ * TODO: This header file should be replaced with videobuf2-core.h
+ * Currently, vb2_thread is not a stuff of videobuf2-core,
+ * since vb2_thread has many dependencies on videobuf2-v4l2.
+ */
 
 struct vb2_dvb {
 	/* filling that the job of the driver */
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 9d10e3a..5abab1e 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -50,4 +50,100 @@ struct vb2_v4l2_buffer {
 #define to_vb2_v4l2_buffer(vb) \
 	container_of(vb, struct vb2_v4l2_buffer, vb2_buf)
 
+int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
+
+int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
+int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
+
+int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
+int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
+
+int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
+int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
+
+int __must_check vb2_queue_init(struct vb2_queue *q);
+void vb2_queue_release(struct vb2_queue *q);
+
+unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
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
+
+/*
+ * The following functions are not part of the vb2 core API, but are simple
+ * helper functions that you can use in your struct v4l2_file_operations,
+ * struct v4l2_ioctl_ops and struct vb2_ops. They will serialize if vb2_queue->lock
+ * or video_device->lock is set, and they will set and test vb2_queue->owner
+ * to check if the calling filehandle is permitted to do the queuing operation.
+ */
+
+/* struct v4l2_ioctl_ops helpers */
+
+int vb2_ioctl_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p);
+int vb2_ioctl_create_bufs(struct file *file, void *priv,
+			  struct v4l2_create_buffers *p);
+int vb2_ioctl_prepare_buf(struct file *file, void *priv,
+			  struct v4l2_buffer *p);
+int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p);
+int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
+int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p);
+int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i);
+int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i);
+int vb2_ioctl_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *p);
+
+/* struct v4l2_file_operations helpers */
+
+int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
+int vb2_fop_release(struct file *file);
+int _vb2_fop_release(struct file *file, struct mutex *lock);
+ssize_t vb2_fop_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos);
+ssize_t vb2_fop_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos);
+unsigned int vb2_fop_poll(struct file *file, poll_table *wait);
+#ifndef CONFIG_MMU
+unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags);
+#endif
+
+/* struct vb2_ops helpers, only use if vq->lock is non-NULL. */
+
+void vb2_ops_wait_prepare(struct vb2_queue *vq);
+void vb2_ops_wait_finish(struct vb2_queue *vq);
+
 #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
-- 
1.7.9.5

