Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:50969 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbbIILUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 07:20:14 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NUE00SICQ5EP1B0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Sep 2015 20:20:02 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v4 8/8] [media] videobuf2: Remove v4l2-dependencies from
 videobuf2-core
Date: Wed, 09 Sep 2015 20:19:57 +0900
Message-id: <1441797597-17389-9-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com>
References: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move v4l2-stuffs from videobuf2-core to videobuf2-v4l2. And make
wrappers that use the vb2_core_* functions.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c     |  517 ++++++++++++++++----------
 drivers/media/v4l2-core/videobuf2-internal.h |   51 +--
 drivers/media/v4l2-core/videobuf2-v4l2.c     |  312 ++++++++++++----
 include/media/videobuf2-core.h               |   20 +-
 include/media/videobuf2-v4l2.h               |    3 +-
 5 files changed, 601 insertions(+), 302 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 3e6ee0e..56d34f2 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -24,20 +24,16 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 
-#include <media/v4l2-dev.h>
-#include <media/v4l2-fh.h>
-#include <media/v4l2-event.h>
-#include <media/v4l2-common.h>
-#include <media/videobuf2-v4l2.h>
-
 #include <trace/events/v4l2.h>
 
+#include <media/videobuf2-core.h>
 #include "videobuf2-internal.h"
 
 int vb2_debug;
 EXPORT_SYMBOL_GPL(vb2_debug);
 module_param_named(debug, vb2_debug, int, 0644);
 
+static void __vb2_queue_cancel(struct vb2_queue *q);
 static void __enqueue_in_driver(struct vb2_buffer *vb);
 
 /**
@@ -47,7 +43,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+			q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
 	int plane;
 
@@ -289,7 +285,7 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
  * related information, if no buffers are left return the queue to an
  * uninitialized state. Might be called even if the queue has already been freed.
  */
-int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
+static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 {
 	unsigned int buffer;
 
@@ -401,35 +397,10 @@ int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 }
 
 /**
- * __verify_planes_array() - verify that the planes array passed in struct
- * v4l2_buffer from userspace can be safely used
- */
-int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
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
- * __buffer_in_use() - return true if the buffer is in use and
+ * vb2_buffer_in_use() - return true if the buffer is in use and
  * the queue cannot be freed (by the means of REQBUFS(0)) call
  */
-bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
+bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 {
 	unsigned int plane;
 	for (plane = 0; plane < vb->num_planes; ++plane) {
@@ -445,6 +416,7 @@ bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 	}
 	return false;
 }
+EXPORT_SYMBOL_GPL(vb2_buffer_in_use);
 
 /**
  * __buffers_in_use() - return true if any buffers on the queue are in use and
@@ -454,13 +426,34 @@ static bool __buffers_in_use(struct vb2_queue *q)
 {
 	unsigned int buffer;
 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		if (__buffer_in_use(q, q->bufs[buffer]))
+		if (vb2_buffer_in_use(q, q->bufs[buffer]))
 			return true;
 	}
 	return false;
 }
 
 /**
+ * vb2_core_querybuf() - query video buffer information
+ * @q:		videobuf queue
+ * @index:	id number of the buffer
+ * @pb:		buffer struct passed from userspace
+ *
+ * Should be called from vidioc_querybuf ioctl handler in driver.
+ * The passed buffer should have been verified.
+ * This function fills the relevant information for the userspace.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_querybuf handler in driver.
+ */
+int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
+{
+	call_bufop(q, fill_user_buffer, q->bufs[index], pb);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_core_querybuf);
+
+/**
  * __verify_userptr_ops() - verify that all memory operations required for
  * USERPTR queue type have been provided
  */
@@ -501,10 +494,10 @@ static int __verify_dmabuf_ops(struct vb2_queue *q)
 }
 
 /**
- * __verify_memory_type() - Check whether the memory type and buffer type
+ * vb2_verify_memory_type() - Check whether the memory type and buffer type
  * passed to a buffer operation are compatible with the queue.
  */
-int __verify_memory_type(struct vb2_queue *q,
+int vb2_verify_memory_type(struct vb2_queue *q,
 		enum vb2_memory memory, unsigned int type)
 {
 	if (memory != VB2_MEMORY_MMAP && memory != VB2_MEMORY_USERPTR &&
@@ -537,22 +530,15 @@ int __verify_memory_type(struct vb2_queue *q,
 		return -EINVAL;
 	}
 
-	/*
-	 * Place the busy tests at the end: -EBUSY can be ignored when
-	 * create_bufs is called with count == 0, but count == 0 should still
-	 * do the memory and type validation.
-	 */
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_verify_memory_type);
 
 /**
- * __reqbufs() - Initiate streaming
+ * vb2_core_reqbufs() - Initiate streaming
  * @q:		videobuf2 queue
- * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
+ * @memory: memory type
+ * @count: requested buffer count
  *
  * Should be called from vidioc_reqbufs ioctl handler of a driver.
  * This function:
@@ -572,7 +558,8 @@ int __verify_memory_type(struct vb2_queue *q,
  * The return values from this function are intended to be directly returned
  * from vidioc_reqbufs handler in driver.
  */
-int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
+int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
+		unsigned int *count)
 {
 	unsigned int num_buffers, allocated_buffers, num_planes = 0;
 	int ret;
@@ -582,7 +569,7 @@ int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return -EBUSY;
 	}
 
-	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
+	if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
 		/*
 		 * We already have buffers allocated, so first check if they
 		 * are not in use and can be freed.
@@ -609,18 +596,18 @@ int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		 * In case of REQBUFS(0) return immediately without calling
 		 * driver's queue_setup() callback and allocating resources.
 		 */
-		if (req->count == 0)
+		if (*count == 0)
 			return 0;
 	}
 
 	/*
 	 * Make sure the requested values and current defaults are sane.
 	 */
-	num_buffers = min_t(unsigned int, req->count, VB2_MAX_FRAME);
+	num_buffers = min_t(unsigned int, *count, VB2_MAX_FRAME);
 	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
 	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
-	q->memory = req->memory;
+	q->memory = memory;
 
 	/*
 	 * Ask the driver how many buffers and planes per buffer it requires.
@@ -632,7 +619,8 @@ int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return ret;
 
 	/* Finally, allocate buffers and video memory */
-	allocated_buffers = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
+	allocated_buffers =
+		__vb2_queue_alloc(q, memory, num_buffers, num_planes);
 	if (allocated_buffers == 0) {
 		dprintk(1, "memory allocation failed\n");
 		return -ENOMEM;
@@ -681,17 +669,19 @@ int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * Return the number of successfully allocated buffers
 	 * to the userspace.
 	 */
-	req->count = allocated_buffers;
-	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	*count = allocated_buffers;
+	q->waiting_for_buffers = !q->is_output;
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
 
 /**
- * __create_bufs() - Allocate buffers and any required auxiliary structs
+ * vb2_core_create_bufs() - Allocate buffers and any required auxiliary structs
  * @q:		videobuf2 queue
- * @create:	creation parameters, passed from userspace to vidioc_create_bufs
- *		handler in driver
+ * @memory: memory type
+ * @count: requested buffer count
+ * @parg: parameter passed to device driver
  *
  * Should be called from vidioc_create_bufs ioctl handler of a driver.
  * This function:
@@ -702,7 +692,8 @@ int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
  * The return values from this function are intended to be directly returned
  * from vidioc_create_bufs handler in driver.
  */
-int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
+int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
+		unsigned int *count, void *parg)
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
 	int ret;
@@ -715,23 +706,23 @@ int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 	if (!q->num_buffers) {
 		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
-		q->memory = create->memory;
-		q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+		q->memory = memory;
+		q->waiting_for_buffers = !q->is_output;
 	}
 
-	num_buffers = min(create->count, VB2_MAX_FRAME - q->num_buffers);
+	num_buffers = min(*count, VB2_MAX_FRAME - q->num_buffers);
 
 	/*
 	 * Ask the driver, whether the requested number of buffers, planes per
 	 * buffer and their sizes are acceptable
 	 */
-	ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
-		       &num_planes, q->plane_sizes, q->alloc_ctx);
+	ret = call_qop(q, queue_setup, q, parg, &num_buffers,
+			&num_planes, q->plane_sizes, q->alloc_ctx);
 	if (ret)
 		return ret;
 
 	/* Finally, allocate buffers and video memory */
-	allocated_buffers = __vb2_queue_alloc(q, create->memory, num_buffers,
+	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
 				num_planes);
 	if (allocated_buffers == 0) {
 		dprintk(1, "memory allocation failed\n");
@@ -748,8 +739,8 @@ int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 		 * q->num_buffers contains the total number of buffers, that the
 		 * queue driver has set up
 		 */
-		ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
-			       &num_planes, q->plane_sizes, q->alloc_ctx);
+		ret = call_qop(q, queue_setup, q, parg, &num_buffers,
+				&num_planes, q->plane_sizes, q->alloc_ctx);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
@@ -778,10 +769,11 @@ int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 	 * Return the number of successfully allocated buffers
 	 * to the userspace.
 	 */
-	create->count = allocated_buffers;
+	*count = allocated_buffers;
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
 
 /**
  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
@@ -917,16 +909,16 @@ EXPORT_SYMBOL_GPL(vb2_discard_done);
 /**
  * __qbuf_mmap() - handle qbuf of an MMAP buffer
  */
-static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_mmap(struct vb2_buffer *vb, void *pb)
 {
-	__fill_vb2_buffer(vb, b, vb->planes);
+	call_bufop(vb->vb2_queue, fill_vb2_buffer, vb, pb, vb->planes);
 	return call_vb_qop(vb, buf_prepare, vb);
 }
 
 /**
  * __qbuf_userptr() - handle qbuf of a USERPTR buffer
  */
-static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_userptr(struct vb2_buffer *vb, void *pb)
 {
 	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
@@ -934,12 +926,12 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	unsigned int plane;
 	int ret;
 	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
 	/* Copy relevant information provided by the userspace */
-	__fill_vb2_buffer(vb, b, planes);
+	call_bufop(vb->vb2_queue, fill_vb2_buffer, vb, pb, planes);
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		/* Skip the plane if already verified */
@@ -1038,7 +1030,7 @@ err:
 /**
  * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
  */
-static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_dmabuf(struct vb2_buffer *vb, void *pb)
 {
 	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
@@ -1046,12 +1038,12 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	unsigned int plane;
 	int ret;
 	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
 	/* Copy relevant information provided by the userspace */
-	__fill_vb2_buffer(vb, b, planes);
+	call_bufop(vb->vb2_queue, fill_vb2_buffer, vb, pb, planes);
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
@@ -1182,52 +1174,27 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 	call_void_vb_qop(vb, buf_queue, vb);
 }
 
-int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __buf_prepare(struct vb2_buffer *vb, void *pb)
 {
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
 	int ret;
 
-	ret = __verify_length(vb, b);
-	if (ret < 0) {
-		dprintk(1, "plane parameters verification failed: %d\n", ret);
-		return ret;
-	}
-	if (b->field == V4L2_FIELD_ALTERNATE && V4L2_TYPE_IS_OUTPUT(q->type)) {
-		/*
-		 * If the format's field is ALTERNATE, then the buffer's field
-		 * should be either TOP or BOTTOM, not ALTERNATE since that
-		 * makes no sense. The driver has to know whether the
-		 * buffer represents a top or a bottom field in order to
-		 * program any DMA correctly. Using ALTERNATE is wrong, since
-		 * that just says that it is either a top or a bottom field,
-		 * but not which of the two it is.
-		 */
-		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
-		return -EINVAL;
-	}
-
 	if (q->error) {
 		dprintk(1, "fatal error occurred on queue\n");
 		return -EIO;
 	}
 
-	vb->state = VB2_BUF_STATE_PREPARING;
-	vbuf->timestamp.tv_sec = 0;
-	vbuf->timestamp.tv_usec = 0;
-	vbuf->sequence = 0;
-
 	switch (q->memory) {
 	case VB2_MEMORY_MMAP:
-		ret = __qbuf_mmap(vb, b);
+		ret = __qbuf_mmap(vb, pb);
 		break;
 	case VB2_MEMORY_USERPTR:
 		down_read(&current->mm->mmap_sem);
-		ret = __qbuf_userptr(vb, b);
+		ret = __qbuf_userptr(vb, pb);
 		up_read(&current->mm->mmap_sem);
 		break;
 	case VB2_MEMORY_DMABUF:
-		ret = __qbuf_dmabuf(vb, b);
+		ret = __qbuf_dmabuf(vb, pb);
 		break;
 	default:
 		WARN(1, "Invalid queue type\n");
@@ -1241,32 +1208,94 @@ int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	return ret;
 }
 
-int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
-				    const char *opname)
+/**
+ * vb2_verify_buffer() - verify the buffer information passed from userspace
+ */
+int vb2_verify_buffer(struct vb2_queue *q,
+			enum vb2_memory memory, unsigned int type,
+			unsigned int index, unsigned int nplanes,
+			void *pplane, const char *opname)
 {
-	if (b->type != q->type) {
+	if (type != q->type) {
 		dprintk(1, "%s: invalid buffer type\n", opname);
 		return -EINVAL;
 	}
 
-	if (b->index >= q->num_buffers) {
+	if (index >= q->num_buffers) {
 		dprintk(1, "%s: buffer index out of range\n", opname);
 		return -EINVAL;
 	}
 
-	if (q->bufs[b->index] == NULL) {
+	if (q->bufs[index] == NULL) {
 		/* Should never happen */
 		dprintk(1, "%s: buffer is NULL\n", opname);
 		return -EINVAL;
 	}
 
-	if (b->memory != q->memory) {
+	if (memory != VB2_MEMORY_UNKNOWN && memory != q->memory) {
 		dprintk(1, "%s: invalid memory type\n", opname);
 		return -EINVAL;
 	}
 
-	return __verify_planes_array(q->bufs[b->index], b);
+	if (q->is_multiplanar) {
+		struct vb2_buffer *vb = q->bufs[index];
+
+		/* Is memory for copying plane information present? */
+		if (NULL == pplane) {
+			dprintk(1, "%s: multi-planar buffer passed but "
+				"planes array not provided\n", opname);
+			return -EINVAL;
+		}
+
+		if (nplanes < vb->num_planes || nplanes > VB2_MAX_PLANES) {
+			dprintk(1, "%s: incorrect planes array length, "
+				"expected %d, got %d\n",
+				opname, vb->num_planes, nplanes);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_verify_buffer);
+
+/**
+ * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
+ * @q:		videobuf2 queue
+ * @index:	id number of the buffer
+ * @pb:		buffer structure passed from userspace to vidioc_prepare_buf
+ *		handler in driver
+ *
+ * Should be called from vidioc_prepare_buf ioctl handler of a driver.
+ * The passed buffer should have been verified.
+ * This function calls buf_prepare callback in the driver (if provided),
+ * in which driver-specific buffer initialization can be performed,
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_prepare_buf handler in driver.
+ */
+int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
+{
+	struct vb2_buffer *vb;
+	int ret;
+
+	vb = q->bufs[index];
+	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+		dprintk(1, "invalid buffer state %d\n",
+			vb->state);
+		return -EINVAL;
+	}
+
+	ret = __buf_prepare(vb, pb);
+	if (!ret) {
+		/* Fill buffer information for the userspace */
+		call_bufop(q, fill_user_buffer, vb, pb);
+
+		dprintk(1, "prepare of buffer %d succeeded\n", vb->index);
+	}
+	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
 /**
  * vb2_start_streaming() - Attempt to start streaming.
@@ -1331,21 +1360,34 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+/**
+ * vb2_qbuf() - Queue a buffer from userspace
+ * @q:		videobuf2 queue
+ * @index:	id number of the buffer
+ * @pb:		buffer structure passed from userspace to vidioc_qbuf handler
+ *		in driver
+ *
+ * Should be called from vidioc_qbuf ioctl handler of a driver.
+ * The passed buffer should have been verified.
+ * This function:
+ * 1) if necessary, calls buf_prepare callback in the driver (if provided), in
+ *    which driver-specific buffer initialization can be performed,
+ * 2) if streaming is on, queues the buffer in driver by the means of buf_queue
+ *    callback for processing.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_qbuf handler in driver.
+ */
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 {
-	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
+	int ret;
 	struct vb2_buffer *vb;
-	struct vb2_v4l2_buffer *vbuf;
-
-	if (ret)
-		return ret;
 
-	vb = q->bufs[b->index];
-	vbuf = to_vb2_v4l2_buffer(vb);
+	vb = q->bufs[index];
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DEQUEUED:
-		ret = __buf_prepare(vb, b);
+		ret = __buf_prepare(vb, pb);
 		if (ret)
 			return ret;
 		break;
@@ -1367,18 +1409,13 @@ int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	q->queued_count++;
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
-		/*
-		 * For output buffers copy the timestamp if needed,
-		 * and the timecode field and flag if needed.
-		 */
-		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-		    V4L2_BUF_FLAG_TIMESTAMP_COPY)
-			vbuf->timestamp = b->timestamp;
-		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
-		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
-			vbuf->timecode = b->timecode;
-	}
+
+	/*
+	 * For output buffers copy the timestamp if needed,
+	 * and the timecode field and flag if needed.
+	 */
+	if (q->is_output)
+		call_bufop(q, fill_vb2_timestamp, vb, pb);
 
 	trace_vb2_qbuf(q, vb);
 
@@ -1390,7 +1427,7 @@ int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		__enqueue_in_driver(vb);
 
 	/* Fill buffer information for the userspace */
-	__fill_v4l2_buffer(vb, b);
+	call_bufop(q, fill_user_buffer, vb, pb);
 
 	/*
 	 * If streamon has been called, and we haven't yet called
@@ -1408,6 +1445,7 @@ int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_qbuf);
 
 /**
  * __vb2_wait_for_done_vb() - wait for a buffer to become available
@@ -1491,7 +1529,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
  * Will sleep if required for nonblocking == false.
  */
 static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
-				struct v4l2_buffer *b, int nonblocking)
+				int nonblocking)
 {
 	unsigned long flags;
 	int ret;
@@ -1512,10 +1550,11 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
 	/*
 	 * Only remove the buffer from done_list if v4l2_buffer can handle all
 	 * the planes.
+	 * ret = __verify_planes_array(*vb, pb);
+	 * But, actually that's unnecessary since this is checked already
+	 * before the buffer is queued/prepared. So it can never fails
 	 */
-	ret = __verify_planes_array(*vb, b);
-	if (!ret)
-		list_del(&(*vb)->done_entry);
+	list_del(&(*vb)->done_entry);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
 	return ret;
@@ -1567,18 +1606,33 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 		}
 }
 
-int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
-		bool nonblocking)
+/**
+ * vb2_dqbuf() - Dequeue a buffer to the userspace
+ * @q:		videobuf2 queue
+ * @pb:		buffer structure passed from userspace to vidioc_dqbuf handler
+ *		in driver
+ * @nonblocking: if true, this call will not sleep waiting for a buffer if no
+ *		 buffers ready for dequeuing are present. Normally the driver
+ *		 would be passing (file->f_flags & O_NONBLOCK) here
+ *
+ * Should be called from vidioc_dqbuf ioctl handler of a driver.
+ * The passed buffer should have been verified.
+ * This function:
+ * 1) calls buf_finish callback in the driver (if provided), in which
+ *    driver can perform any additional operations that may be required before
+ *    returning the buffer to userspace, such as cache sync,
+ * 2) the buffer struct members are filled with relevant information for
+ *    the userspace.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_dqbuf handler in driver.
+ */
+int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking)
 {
 	struct vb2_buffer *vb = NULL;
-	struct vb2_v4l2_buffer *vbuf = NULL;
 	int ret;
 
-	if (b->type != q->type) {
-		dprintk(1, "invalid buffer type\n");
-		return -EINVAL;
-	}
-	ret = __vb2_get_done_vb(q, &vb, b, nonblocking);
+	ret = __vb2_get_done_vb(q, &vb, nonblocking);
 	if (ret < 0)
 		return ret;
 
@@ -1597,16 +1651,15 @@ int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 	call_void_vb_qop(vb, buf_finish, vb);
 
 	/* Fill buffer information for the userspace */
-	__fill_v4l2_buffer(vb, b);
+	call_bufop(q, fill_user_buffer, vb, pb);
 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
 	q->queued_count--;
 
 	trace_vb2_dqbuf(q, vb);
 
-	vbuf = to_vb2_v4l2_buffer(vb);
-	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
-			vbuf->flags & V4L2_BUF_FLAG_LAST)
+	if (!q->is_output &&
+			call_bufop(q, is_last, vb))
 		q->last_buffer_dequeued = true;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
@@ -1616,6 +1669,7 @@ int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
 
 /**
  * __vb2_queue_cancel() - cancel and stop (pause) streaming
@@ -1623,7 +1677,7 @@ int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
  * Removes all queued buffers from driver's queue and all buffers queued by
  * userspace from videobuf's queue. Returns to state after reqbufs.
  */
-void __vb2_queue_cancel(struct vb2_queue *q)
+static void __vb2_queue_cancel(struct vb2_queue *q)
 {
 	unsigned int i;
 
@@ -1685,15 +1739,22 @@ void __vb2_queue_cancel(struct vb2_queue *q)
 	}
 }
 
-int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+/**
+ * vb2_streamon - start streaming
+ * @q:		videobuf2 queue
+ *
+ * Should be called from vidioc_streamon handler of a driver.
+ * This function :
+ * 1) verifies current state
+ * 2) passes any previously queued buffers to the driver and starts streaming
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_streamon handler in the driver.
+ */
+int vb2_core_streamon(struct vb2_queue *q)
 {
 	int ret;
 
-	if (type != q->type) {
-		dprintk(1, "invalid stream type\n");
-		return -EINVAL;
-	}
-
 	if (q->streaming) {
 		dprintk(3, "already streaming\n");
 		return 0;
@@ -1727,6 +1788,7 @@ int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 	dprintk(3, "successful\n");
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_streamon);
 
 /**
  * vb2_queue_error() - signal a fatal error on the queue
@@ -1749,13 +1811,22 @@ void vb2_queue_error(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_queue_error);
 
-int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+/**
+ * vb2_streamoff - stop streaming
+ * @q:		videobuf2 queue
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
+int vb2_core_streamoff(struct vb2_queue *q)
 {
-	if (type != q->type) {
-		dprintk(1, "invalid stream type\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Cancel will pause streaming and remove all buffers from the driver
 	 * and videobuf, effectively returning control over them to userspace.
@@ -1766,12 +1837,13 @@ int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 	 * their normal dequeued state.
 	 */
 	__vb2_queue_cancel(q);
-	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	q->waiting_for_buffers = !q->is_output;
 	q->last_buffer_dequeued = false;
 
 	dprintk(3, "successful\n");
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_core_streamoff);
 
 /**
  * __find_plane_by_offset() - find plane associated with the given offset off
@@ -1803,15 +1875,20 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 }
 
 /**
- * vb2_expbuf() - Export a buffer as a file descriptor
+ * vb2_core_expbuf() - Export a buffer as a file descriptor
  * @q:		videobuf2 queue
- * @eb:		export buffer structure passed from userspace to vidioc_expbuf
- *		handler in driver
+ * @fd:		file descriptor associated with DMABUF (set by driver) *
+ * @type:	buffer type
+ * @index:	id number of the buffer
+ * @plane:	index of the plane to be exported, 0 for single plane queues
+ * @flags:	flags for newly created file, currently only O_CLOEXEC is
+ *		supported, refer to manual of open syscall for more details
  *
  * The return values from this function are intended to be directly returned
  * from vidioc_expbuf handler in driver.
  */
-int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
+int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
+		unsigned int index, unsigned int plane, unsigned int flags)
 {
 	struct vb2_buffer *vb = NULL;
 	struct vb2_plane *vb_plane;
@@ -1828,60 +1905,56 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 		return -EINVAL;
 	}
 
-	if (eb->flags & ~(O_CLOEXEC | O_ACCMODE)) {
+	if (flags & ~(O_CLOEXEC | O_ACCMODE)) {
 		dprintk(1, "queue does support only O_CLOEXEC and access mode flags\n");
 		return -EINVAL;
 	}
 
-	if (eb->type != q->type) {
+	if (type != q->type) {
 		dprintk(1, "invalid buffer type\n");
 		return -EINVAL;
 	}
 
-	if (eb->index >= q->num_buffers) {
+	if (index >= q->num_buffers) {
 		dprintk(1, "buffer index out of range\n");
 		return -EINVAL;
 	}
 
-	vb = q->bufs[eb->index];
+	vb = q->bufs[index];
 
-	if (eb->plane >= vb->num_planes) {
+	if (plane >= vb->num_planes) {
 		dprintk(1, "buffer plane out of range\n");
 		return -EINVAL;
 	}
 
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "expbuf: file io in progress\n");
-		return -EBUSY;
-	}
+	vb_plane = &vb->planes[plane];
 
-	vb_plane = &vb->planes[eb->plane];
-
-	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
+	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv,
+				flags & O_ACCMODE);
 	if (IS_ERR_OR_NULL(dbuf)) {
 		dprintk(1, "failed to export buffer %d, plane %d\n",
-			eb->index, eb->plane);
+			index, plane);
 		return -EINVAL;
 	}
 
-	ret = dma_buf_fd(dbuf, eb->flags & ~O_ACCMODE);
+	ret = dma_buf_fd(dbuf, flags & ~O_ACCMODE);
 	if (ret < 0) {
 		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
-			eb->index, eb->plane, ret);
+			index, plane, ret);
 		dma_buf_put(dbuf);
 		return ret;
 	}
 
 	dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
-		eb->index, eb->plane, ret);
-	eb->fd = ret;
+		index, plane, ret);
+	*fd = ret;
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_expbuf);
+EXPORT_SYMBOL_GPL(vb2_core_expbuf);
 
 /**
- * vb2_mmap() - map video buffers into application address space
+ * vb2_core_mmap() - map video buffers into application address space
  * @q:		videobuf2 queue
  * @vma:	vma passed to the mmap file operation handler in the driver
  *
@@ -1899,7 +1972,7 @@ EXPORT_SYMBOL_GPL(vb2_expbuf);
  * The return values from this function are intended to be directly returned
  * from the mmap handler in driver.
  */
-int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
+int vb2_core_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 {
 	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
 	struct vb2_buffer *vb;
@@ -1919,7 +1992,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 		dprintk(1, "invalid vma flags, VM_SHARED needed\n");
 		return -EINVAL;
 	}
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+	if (q->is_output) {
 		if (!(vma->vm_flags & VM_WRITE)) {
 			dprintk(1, "invalid vma flags, VM_WRITE needed\n");
 			return -EINVAL;
@@ -1930,10 +2003,6 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 			return -EINVAL;
 		}
 	}
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "mmap: file io in progress\n");
-		return -EBUSY;
-	}
 
 	/*
 	 * Find the plane corresponding to the offset passed by userspace.
@@ -1965,7 +2034,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	dprintk(3, "buffer %d, plane %d successfully mapped\n", buffer, plane);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_mmap);
+EXPORT_SYMBOL_GPL(vb2_core_mmap);
 
 #ifndef CONFIG_MMU
 unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
@@ -2000,6 +2069,62 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
 #endif
 
+/**
+ * vb2_core_queue_init() - initialize a videobuf2 queue
+ * @q:		videobuf2 queue; this structure should be allocated in driver
+ *
+ * The vb2_queue structure should be allocated by the driver. The driver is
+ * responsible of clearing it's content and setting initial values for some
+ * required entries before calling this function.
+ * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
+ * to the struct vb2_queue description in include/media/videobuf2-core.h
+ * for more information.
+ */
+int vb2_core_queue_init(struct vb2_queue *q)
+{
+	/*
+	 * Sanity check
+	 */
+	if (WARN_ON(!q)				||
+		WARN_ON(!q->ops)		||
+		WARN_ON(!q->mem_ops)		||
+		WARN_ON(!q->buf_ops)		||
+		WARN_ON(!q->type)		||
+		WARN_ON(!q->io_modes)		||
+		WARN_ON(!q->ops->queue_setup)	||
+		WARN_ON(!q->ops->buf_queue))
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&q->queued_list);
+	INIT_LIST_HEAD(&q->done_list);
+	spin_lock_init(&q->done_lock);
+	mutex_init(&q->mmap_lock);
+	init_waitqueue_head(&q->done_wq);
+
+	if (q->buf_struct_size == 0)
+		q->buf_struct_size = sizeof(struct vb2_buffer);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_core_queue_init);
+
+/**
+ * vb2_core_queue_release() - stop streaming, release the queue and free memory
+ * @q:		videobuf2 queue
+ *
+ * This function stops streaming and performs necessary clean ups, including
+ * freeing video buffer memory. The driver is responsible for freeing
+ * the vb2_queue structure itself.
+ */
+void vb2_core_queue_release(struct vb2_queue *q)
+{
+	__vb2_queue_cancel(q);
+	mutex_lock(&q->mmap_lock);
+	__vb2_queue_free(q, q->num_buffers);
+	mutex_unlock(&q->mmap_lock);
+}
+EXPORT_SYMBOL_GPL(vb2_core_queue_release);
+
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/v4l2-core/videobuf2-internal.h b/drivers/media/v4l2-core/videobuf2-internal.h
index bf2339e..edde353 100644
--- a/drivers/media/v4l2-core/videobuf2-internal.h
+++ b/drivers/media/v4l2-core/videobuf2-internal.h
@@ -147,27 +147,36 @@ extern int vb2_debug;
 
 #endif
 
-bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
-int __verify_memory_type(struct vb2_queue *q,
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
 		enum vb2_memory memory, unsigned int type);
-int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
-int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
-int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b);
-int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b);
-int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b);
-void __vb2_queue_cancel(struct vb2_queue *q);
-int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers);
-void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b);
-void __fill_vb2_buffer(struct vb2_buffer *vb,
-		const struct v4l2_buffer *b, struct vb2_plane *planes);
-int __vb2_cleanup_fileio(struct vb2_queue *q);
-
-int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
-				    const char *opname);
-int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
-int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
-		bool nonblocking);
-int vb2_internal_streamon(struct vb2_queue *q, unsigned int type);
-int vb2_internal_streamoff(struct vb2_queue *q, unsigned int type);
+int vb2_verify_buffer(struct vb2_queue *q,
+			enum vb2_memory memory, unsigned int type,
+			unsigned int index, unsigned int nplanes,
+			void *pplane, const char *opname);
+int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
+		unsigned int *count);
+int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
+		unsigned int *count, void *parg);
+int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblock);
+int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
+		unsigned int index, unsigned int plane, unsigned int flags);
+int vb2_core_streamon(struct vb2_queue *q);
+int vb2_core_streamoff(struct vb2_queue *q);
+int vb2_core_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
+
+int __must_check vb2_core_queue_init(struct vb2_queue *q);
+void vb2_core_queue_release(struct vb2_queue *q);
 
 #endif /* _MEDIA_VIDEOBUF2_INTERNAL_H */
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 1a0526c..8690b91 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -102,8 +102,9 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
  * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
  * returned to userspace
  */
-void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
+static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 {
+	struct v4l2_buffer *b = pb;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned int plane;
@@ -193,20 +194,34 @@ void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		break;
 	}
 
-	if (__buffer_in_use(q, vb))
+	if (vb2_buffer_in_use(q, vb))
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
+
+	return 0;
 }
 
 /**
  * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
- * v4l2_buffer by the userspace. The caller has already verified that struct
+ * v4l2_buffer by the userspace. It also verifies that struct
  * v4l2_buffer has a valid number of planes.
  */
-void __fill_vb2_buffer(struct vb2_buffer *vb,
-		const struct v4l2_buffer *b, struct vb2_plane *planes)
+static int __fill_vb2_buffer(struct vb2_buffer *vb,
+		void *pb, struct vb2_plane *planes)
 {
+	struct v4l2_buffer *b = pb;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	unsigned int plane;
+	int ret;
+
+	ret = __verify_length(vb, b);
+	if (ret < 0) {
+		dprintk(1, "plane parameters verification failed: %d\n", ret);
+		return ret;
+	}
+	vb->state = VB2_BUF_STATE_PREPARING;
+	vbuf->timestamp.tv_sec = 0;
+	vbuf->timestamp.tv_usec = 0;
+	vbuf->sequence = 0;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		if (b->memory == V4L2_MEMORY_USERPTR) {
@@ -323,8 +338,44 @@ void __fill_vb2_buffer(struct vb2_buffer *vb,
 		/* Zero any output buffer flags as this is a capture buffer */
 		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
 	}
+
+	return 0;
+}
+
+static int __fill_vb2_timestamp(struct vb2_buffer *vb, void *pb)
+{
+	struct v4l2_buffer *b = pb;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vb2_queue *q = vb->vb2_queue;
+
+	/*
+	 * For output buffers copy the timestamp if needed,
+	 * and the timecode field and flag if needed.
+	 */
+	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+			V4L2_BUF_FLAG_TIMESTAMP_COPY)
+		vbuf->timestamp = b->timestamp;
+	vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
+	if (b->flags & V4L2_BUF_FLAG_TIMECODE)
+		vbuf->timecode = b->timecode;
+
+	return 0;
+};
+
+static int __is_last(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	return (vbuf->flags & V4L2_BUF_FLAG_LAST);
 }
 
+const struct vb2_buf_ops v4l2_buf_ops = {
+	.fill_user_buffer	= __fill_v4l2_buffer,
+	.fill_vb2_buffer	= __fill_vb2_buffer,
+	.fill_vb2_timestamp	= __fill_vb2_timestamp,
+	.is_last		= __is_last,
+};
+
 /**
  * vb2_querybuf() - query video buffer information
  * @q:		videobuf queue
@@ -340,55 +391,55 @@ void __fill_vb2_buffer(struct vb2_buffer *vb,
  */
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb;
-	int ret;
-
-	if (b->type != q->type) {
-		dprintk(1, "wrong buffer type\n");
-		return -EINVAL;
-	}
+	int ret = vb2_verify_buffer(q, b->memory, b->type, b->index,
+			b->length, b->m.planes, "querybuf");
 
-	if (b->index >= q->num_buffers) {
-		dprintk(1, "buffer index out of range\n");
-		return -EINVAL;
-	}
-	vb = q->bufs[b->index];
-	ret = __verify_planes_array(vb, b);
-	if (!ret)
-		__fill_v4l2_buffer(vb, b);
-	return ret;
+	return ret ? ret : vb2_core_querybuf(q, b->index, b);
 }
 EXPORT_SYMBOL(vb2_querybuf);
 
 /**
- * vb2_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
- * type values.
+ * vb2_reqbufs() - Wrapper for vb2_core_reqbufs() that also verifies
+ * the memory and type values.
  * @q:		videobuf2 queue
- * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
+ * @req:	struct passed from userspace to vidioc_reqbufs handler
+ *		in driver
  */
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
-	int ret = __verify_memory_type(q, req->memory, req->type);
+	int ret = vb2_verify_memory_type(q, req->memory, req->type);
 
-	return ret ? ret : __reqbufs(q, req);
+	if (ret)
+		return ret;
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+
+	return vb2_core_reqbufs(q, req->memory, &req->count);
 }
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
 /**
- * vb2_create_bufs() - Wrapper for __create_bufs() that also verifies the
- * memory and type values.
+ * vb2_create_bufs() - Wrapper for vb2_core_create_bufs() that also verifies
+ * the memory and type values.
  * @q:		videobuf2 queue
  * @create:	creation parameters, passed from userspace to vidioc_create_bufs
  *		handler in driver
  */
 int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 {
-	int ret = __verify_memory_type(q, create->memory, create->format.type);
+	int ret = vb2_verify_memory_type(q, create->memory, create->format.type);
 
 	create->index = q->num_buffers;
-	if (create->count == 0)
-		return ret != -EBUSY ? ret : 0;
-	return ret ? ret : __create_bufs(q, create);
+	if (ret || create->count == 0)
+		return ret;
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+
+	return vb2_core_create_bufs(q, create->memory, &create->count, &create->format);
 }
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
@@ -409,7 +460,6 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
  */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb;
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
@@ -417,27 +467,50 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return -EBUSY;
 	}
 
-	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
+	ret = vb2_verify_buffer(q, b->memory, b->type, b->index,
+			b->length, b->m.planes, "prepare_buf");
 	if (ret)
 		return ret;
 
-	vb = q->bufs[b->index];
-	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-		dprintk(1, "invalid buffer state %d\n",
-			vb->state);
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
+				"for an output buffer\n");
 		return -EINVAL;
 	}
 
-	ret = __buf_prepare(vb, b);
-	if (!ret) {
-		/* Fill buffer information for the userspace */
-		__fill_v4l2_buffer(vb, b);
+	return vb2_core_prepare_buf(q, b->index, b);
+}
+EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
-		dprintk(1, "prepare of buffer %d succeeded\n", vb->index);
+static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	int ret = vb2_verify_buffer(q, b->memory, b->type, b->index,
+			b->length, b->m.planes, "qbuf");
+	struct vb2_buffer *vb;
+
+	if (ret)
+		return ret;
+
+	vb = q->bufs[b->index];
+
+	if (vb->state == VB2_BUF_STATE_DEQUEUED
+			&& b->field == V4L2_FIELD_ALTERNATE && q->is_output) {
+		dprintk(1, "the field is incorrectly set to ALTERNATE "
+				"for an output buffer\n");
+		return -EINVAL;
 	}
-	return ret;
+
+	return ret ? ret : vb2_core_qbuf(q, b->index, b);
 }
-EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
 /**
  * vb2_qbuf() - Queue a buffer from userspace
@@ -467,6 +540,16 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
+static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
+			bool nonblocking)
+{
+	if (b->type != q->type) {
+		dprintk(1, "invalid buffer type\n");
+		return -EINVAL;
+	}
+	return vb2_core_dqbuf(q, b, nonblocking);
+}
+
 /**
  * vb2_dqbuf() - Dequeue a buffer to the userspace
  * @q:		videobuf2 queue
@@ -499,6 +582,36 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
 /**
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
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+
+	return vb2_core_expbuf(q, &eb->fd, eb->type, eb->index,
+				eb->plane, eb->flags);
+}
+EXPORT_SYMBOL_GPL(vb2_expbuf);
+
+static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+{
+	if (type != q->type) {
+		dprintk(1, "invalid stream type\n");
+		return -EINVAL;
+	}
+	return vb2_core_streamon(q);
+}
+
+/**
  * vb2_streamon - start streaming
  * @q:		videobuf2 queue
  * @type:	type argument passed from userspace to vidioc_streamon handler
@@ -521,6 +634,15 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 }
 EXPORT_SYMBOL_GPL(vb2_streamon);
 
+static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+{
+	if (type != q->type) {
+		dprintk(1, "invalid stream type\n");
+		return -EINVAL;
+	}
+	return vb2_core_streamoff(q);
+}
+
 /**
  * vb2_streamoff - stop streaming
  * @q:		videobuf2 queue
@@ -547,6 +669,36 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 EXPORT_SYMBOL_GPL(vb2_streamoff);
 
 /**
+ * vb2_mmap() - map video buffers into application address space
+ * @q:		videobuf2 queue
+ * @vma:	vma passed to the mmap file operation handler in the driver
+ *
+ * Should be called from mmap file operation handler of a driver.
+ * This function maps one plane of one of the available video buffers to
+ * userspace. To map whole video memory allocated on reqbufs, this function
+ * has to be called once per each plane per each buffer previously allocated.
+ *
+ * When the userspace application calls mmap, it passes to it an offset returned
+ * to it earlier by the means of vidioc_querybuf handler. That offset acts as
+ * a "cookie", which is then used to identify the plane to be mapped.
+ * This function finds a plane with a matching offset and a mapping is performed
+ * by the means of a provided memory operation.
+ *
+ * The return values from this function are intended to be directly returned
+ * from the mmap handler in driver.
+ */
+int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
+{
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "mmap: file io in progress\n");
+		return -EBUSY;
+	}
+
+	return vb2_core_mmap(q, vma);
+}
+EXPORT_SYMBOL_GPL(vb2_mmap);
+
+/**
  * vb2_queue_init() - initialize a videobuf2 queue
  * @q:		videobuf2 queue; this structure should be allocated in driver
  *
@@ -559,17 +711,17 @@ EXPORT_SYMBOL_GPL(vb2_streamoff);
  */
 int vb2_queue_init(struct vb2_queue *q)
 {
+	if (WARN_ON(VB2_MEMORY_MMAP != (int)V4L2_MEMORY_MMAP)
+		|| WARN_ON(VB2_MEMORY_USERPTR != (int)V4L2_MEMORY_USERPTR)
+		|| WARN_ON(VB2_MEMORY_DMABUF != (int)V4L2_MEMORY_DMABUF))
+		return -EINVAL;
 	/*
 	 * Sanity check
 	 */
-	if (WARN_ON(!q)			  ||
-	    WARN_ON(!q->ops)		  ||
-	    WARN_ON(!q->mem_ops)	  ||
-	    WARN_ON(!q->type)		  ||
-	    WARN_ON(!q->io_modes)	  ||
-	    WARN_ON(!q->ops->queue_setup) ||
-	    WARN_ON(!q->ops->buf_queue)   ||
-	    WARN_ON(q->timestamp_flags &
+	if (WARN_ON(!q)	|| WARN_ON(!q->type))
+		return -EINVAL;
+
+	if (WARN_ON(q->timestamp_flags &
 		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
 		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
 		return -EINVAL;
@@ -578,19 +730,18 @@ int vb2_queue_init(struct vb2_queue *q)
 	WARN_ON((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
 		V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
 
-	INIT_LIST_HEAD(&q->queued_list);
-	INIT_LIST_HEAD(&q->done_list);
-	spin_lock_init(&q->done_lock);
-	mutex_init(&q->mmap_lock);
-	init_waitqueue_head(&q->done_wq);
-
 	if (q->buf_struct_size == 0)
-		q->buf_struct_size = sizeof(struct vb2_buffer);
+		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
 
-	return 0;
+	q->buf_ops = &v4l2_buf_ops;
+	q->is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);
+
+	return vb2_core_queue_init(q);
 }
 EXPORT_SYMBOL_GPL(vb2_queue_init);
 
+static int __vb2_cleanup_fileio(struct vb2_queue *q);
 /**
  * vb2_queue_release() - stop streaming, release the queue and free memory
  * @q:		videobuf2 queue
@@ -602,10 +753,7 @@ EXPORT_SYMBOL_GPL(vb2_queue_init);
 void vb2_queue_release(struct vb2_queue *q)
 {
 	__vb2_cleanup_fileio(q);
-	__vb2_queue_cancel(q);
-	mutex_lock(&q->mmap_lock);
-	__vb2_queue_free(q, q->num_buffers);
-	mutex_unlock(&q->mmap_lock);
+	vb2_core_queue_release(q);
 }
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
@@ -714,7 +862,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	fileio->req.memory = V4L2_MEMORY_MMAP;
 	fileio->req.type = q->type;
 	q->fileio = fileio;
-	ret = __reqbufs(q, &fileio->req);
+	ret = vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
 	if (ret)
 		goto err_kfree;
 
@@ -743,7 +891,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Read mode requires pre queuing of all buffers.
 	 */
 	if (read) {
-		bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+		bool is_multiplanar = q->is_multiplanar;
 
 		/*
 		 * Queue all buffers.
@@ -784,7 +932,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 
 err_reqbufs:
 	fileio->req.count = 0;
-	__reqbufs(q, &fileio->req);
+	vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
 
 err_kfree:
 	q->fileio = NULL;
@@ -796,7 +944,7 @@ err_kfree:
  * __vb2_cleanup_fileio() - free resourced used by file io emulator
  * @q:		videobuf2 queue
  */
-int __vb2_cleanup_fileio(struct vb2_queue *q)
+static int __vb2_cleanup_fileio(struct vb2_queue *q)
 {
 	struct vb2_fileio_data *fileio = q->fileio;
 
@@ -820,12 +968,12 @@ int __vb2_cleanup_fileio(struct vb2_queue *q)
  * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
  * @read:	access mode selector (1 means read, 0 means write)
  */
-static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
-		loff_t *ppos, int nonblock, int read)
+static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data,
+		size_t count, loff_t *ppos, int nonblock, int read)
 {
 	struct vb2_fileio_data *fileio;
 	struct vb2_fileio_buf *buf;
-	bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+	bool is_multiplanar = q->is_multiplanar;
 	/*
 	 * When using write() to write data to an output video node the vb2 core
 	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
@@ -1132,7 +1280,7 @@ static int vb2_thread(void *data)
 	int index = 0;
 	int ret = 0;
 
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+	if (q->is_output) {
 		prequeue = q->num_buffers;
 		set_timestamp =
 			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
@@ -1210,7 +1358,7 @@ int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
 	threadio->fnc = fnc;
 	threadio->priv = priv;
 
-	ret = __vb2_init_fileio(q, !V4L2_TYPE_IS_OUTPUT(q->type));
+	ret = __vb2_init_fileio(q, !q->is_output);
 	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
 	if (ret)
 		goto nomem;
@@ -1270,13 +1418,15 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *p)
 {
 	struct video_device *vdev = video_devdata(file);
-	int res = __verify_memory_type(vdev->queue, p->memory, p->type);
+	int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);
 
 	if (res)
 		return res;
+	if (vb2_fileio_is_active(vdev->queue))
+		return -EBUSY;
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	res = __reqbufs(vdev->queue, p);
+	res = vb2_core_reqbufs(vdev->queue, p->memory, &p->count);
 	/* If count == 0, then the owner has released all buffers and he
 	   is no longer owner of the queue. Otherwise we have a new owner. */
 	if (res == 0)
@@ -1289,18 +1439,22 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 			  struct v4l2_create_buffers *p)
 {
 	struct video_device *vdev = video_devdata(file);
-	int res = __verify_memory_type(vdev->queue, p->memory, p->format.type);
+	int res = vb2_verify_memory_type(vdev->queue,
+				p->memory, p->format.type);
 
+	if (vb2_fileio_is_active(vdev->queue))
+		return -EBUSY;
 	p->index = vdev->queue->num_buffers;
 	/* If count == 0, then just check if memory and type are valid.
-	   Any -EBUSY result from __verify_memory_type can be mapped to 0. */
+	   Any -EBUSY result from vb2_verify_memory_type can be mapped to 0. */
 	if (p->count == 0)
 		return res != -EBUSY ? res : 0;
 	if (res)
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	res = __create_bufs(vdev->queue, p);
+	res = vb2_core_create_bufs(vdev->queue,
+				p->memory, &p->count, &p->format);
 	if (res == 0)
 		vdev->queue->owner = file->private_data;
 	return res;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 3894e1e..89c7982 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -15,7 +15,6 @@
 #include <linux/mm_types.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
-#include <linux/videodev2.h>
 #include <linux/dma-buf.h>
 
 #define VB2_MAX_FRAME	(32)
@@ -355,6 +354,13 @@ struct vb2_ops {
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
 
+struct vb2_buf_ops {
+	int (*fill_user_buffer)(struct vb2_buffer *vb, void *pb);
+	int (*fill_vb2_buffer)(struct vb2_buffer *vb, void *pb,
+				struct vb2_plane *planes);
+	int (*fill_vb2_timestamp)(struct vb2_buffer *vb, void *pb);
+	int (*is_last)(struct vb2_buffer *vb);
+};
 
 /**
  * struct vb2_queue - a videobuf queue
@@ -377,6 +383,8 @@ struct vb2_ops {
  *		drivers to easily associate an owner filehandle with the queue.
  * @ops:	driver-specific callbacks
  * @mem_ops:	memory allocator specific callbacks
+ * @buf_ops:	callbacks to deliver buffer information
+ *		between user-space and kernel-space
  * @drv_priv:	driver private data
  * @buf_struct_size: size of the driver-specific buffer structure;
  *		"0" indicates the driver doesn't want to use a custom buffer
@@ -412,6 +420,8 @@ struct vb2_ops {
  * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
  *		buffers. Only set for capture queues if qbuf has not yet been
  *		called since poll() needs to return POLLERR in that situation.
+ * @is_multiplanar: set if buffer type is multiplanar
+ * @is_output:	set if buffer type is output
  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
  *		last decoded buffer was already dequeued. Set for capture queues
  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
@@ -430,6 +440,8 @@ struct vb2_queue {
 
 	const struct vb2_ops		*ops;
 	const struct vb2_mem_ops	*mem_ops;
+	const struct vb2_buf_ops	*buf_ops;
+
 	void				*drv_priv;
 	unsigned int			buf_struct_size;
 	u32				timestamp_flags;
@@ -457,6 +469,8 @@ struct vb2_queue {
 	unsigned int			start_streaming_called:1;
 	unsigned int			error:1;
 	unsigned int			waiting_for_buffers:1;
+	unsigned int			is_multiplanar:1;
+	unsigned int			is_output:1;
 	unsigned int			last_buffer_dequeued:1;
 
 	struct vb2_fileio_data		*fileio;
@@ -483,10 +497,6 @@ void vb2_discard_done(struct vb2_queue *q);
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
 void vb2_queue_error(struct vb2_queue *q);
-
-int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
-
-int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
 #ifndef CONFIG_MMU
 unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 				    unsigned long addr,
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 255727c..420e7ae 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -53,11 +53,12 @@ int __must_check vb2_queue_init(struct vb2_queue *q);
 void vb2_queue_release(struct vb2_queue *q);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
-
+int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
 size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
-- 
1.7.9.5

