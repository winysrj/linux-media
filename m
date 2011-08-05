Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:64316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab1HEHsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 03:48:36 -0400
Date: Fri, 5 Aug 2011 09:47:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/6 v4] V4L: vb2: add support for buffers of different sizes
 on a single queue
In-Reply-To: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
Message-ID: <Pine.LNX.4.64.1108050930450.26715@axis700.grange>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two recently added ioctl()s VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF
allow user-space applications to allocate video buffers of different
sizes and hand them over to the driver for fast switching between
different frame formats. This patch adds support for buffers of different
sizes on the same buffer-queue to vb2.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/videobuf2-core.c |  266 +++++++++++++++++++++++++++++-----
 include/media/videobuf2-core.h       |   31 +++--
 2 files changed, 246 insertions(+), 51 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 7045d1f..6e7f9e5 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -44,7 +44,7 @@ module_param(debug, int, 0644);
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
  */
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb,
-				unsigned int *plane_sizes)
+				const unsigned int *plane_sizes)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
@@ -110,13 +110,22 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
  * __setup_offsets() - setup unique offsets ("cookies") for every plane in
  * every buffer on the queue
  */
-static void __setup_offsets(struct vb2_queue *q)
+static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 {
 	unsigned int buffer, plane;
 	struct vb2_buffer *vb;
-	unsigned long off = 0;
+	unsigned long off;
 
-	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+	if (q->num_buffers) {
+		struct v4l2_plane *p;
+		vb = q->bufs[q->num_buffers - 1];
+		p = &vb->v4l2_planes[vb->num_planes - 1];
+		off = PAGE_ALIGN(p->m.mem_offset + p->length);
+	} else {
+		off = 0;
+	}
+
+	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
 		vb = q->bufs[buffer];
 		if (!vb)
 			continue;
@@ -142,7 +151,7 @@ static void __setup_offsets(struct vb2_queue *q)
  */
 static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 			     unsigned int num_buffers, unsigned int num_planes,
-			     unsigned int plane_sizes[])
+			     const unsigned int *plane_sizes)
 {
 	unsigned int buffer;
 	struct vb2_buffer *vb;
@@ -163,7 +172,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 		vb->state = VB2_BUF_STATE_DEQUEUED;
 		vb->vb2_queue = q;
 		vb->num_planes = num_planes;
-		vb->v4l2_buf.index = buffer;
+		vb->v4l2_buf.index = q->num_buffers + buffer;
 		vb->v4l2_buf.type = q->type;
 		vb->v4l2_buf.memory = memory;
 
@@ -191,15 +200,13 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 			}
 		}
 
-		q->bufs[buffer] = vb;
+		q->bufs[q->num_buffers + buffer] = vb;
 	}
 
-	q->num_buffers = buffer;
-
-	__setup_offsets(q);
+	__setup_offsets(q, buffer);
 
 	dprintk(1, "Allocated %d buffers, %d plane(s) each\n",
-			q->num_buffers, num_planes);
+			buffer, num_planes);
 
 	return buffer;
 }
@@ -207,12 +214,13 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 /**
  * __vb2_free_mem() - release all video buffer memory for a given queue
  */
-static void __vb2_free_mem(struct vb2_queue *q)
+static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
 {
 	unsigned int buffer;
 	struct vb2_buffer *vb;
 
-	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
+	     ++buffer) {
 		vb = q->bufs[buffer];
 		if (!vb)
 			continue;
@@ -226,17 +234,18 @@ static void __vb2_free_mem(struct vb2_queue *q)
 }
 
 /**
- * __vb2_queue_free() - free the queue - video memory and related information
- * and return the queue to an uninitialized state. Might be called even if the
- * queue has already been freed.
+ * __vb2_queue_free() - free buffers at the end of the queue - video memory and
+ * related information, if no buffers are left return the queue to an
+ * uninitialized state. Might be called even if the queue has already been freed.
  */
-static void __vb2_queue_free(struct vb2_queue *q)
+static void __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 {
 	unsigned int buffer;
 
 	/* Call driver-provided cleanup function for each buffer, if provided */
 	if (q->ops->buf_cleanup) {
-		for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+		for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
+		     ++buffer) {
 			if (NULL == q->bufs[buffer])
 				continue;
 			q->ops->buf_cleanup(q->bufs[buffer]);
@@ -244,16 +253,18 @@ static void __vb2_queue_free(struct vb2_queue *q)
 	}
 
 	/* Release video buffer memory */
-	__vb2_free_mem(q);
+	__vb2_free_mem(q, buffers);
 
 	/* Free videobuf buffers */
-	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
+	     ++buffer) {
 		kfree(q->bufs[buffer]);
 		q->bufs[buffer] = NULL;
 	}
 
-	q->num_buffers = 0;
-	q->memory = 0;
+	q->num_buffers -= buffers;
+	if (!q->num_buffers)
+		q->memory = 0;
 }
 
 /**
@@ -454,7 +465,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
  */
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
-	unsigned int num_buffers, num_planes;
+	unsigned int num_buffers, allocated_buffers, num_planes = 0;
 	unsigned int plane_sizes[VIDEO_MAX_PLANES];
 	int ret = 0;
 
@@ -503,7 +514,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 			return -EBUSY;
 		}
 
-		__vb2_queue_free(q);
+		__vb2_queue_free(q, q->num_buffers);
 
 		/*
 		 * In case of REQBUFS(0) return immediately without calling
@@ -538,44 +549,166 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return -ENOMEM;
 	}
 
+	allocated_buffers = ret;
+
 	/*
 	 * Check if driver can handle the allocated number of buffers.
 	 */
 	if (ret < num_buffers) {
-		unsigned int orig_num_buffers;
+		num_buffers = ret;
 
-		orig_num_buffers = num_buffers = ret;
 		ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
 			       plane_sizes, q->alloc_ctx);
-		if (ret)
-			goto free_mem;
 
-		if (orig_num_buffers < num_buffers) {
+		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
-			goto free_mem;
-		}
 
 		/*
-		 * Ok, driver accepted smaller number of buffers.
+		 * Either the driver has accepted a smaller number of buffers,
+		 * or .queue_setup() returned an error
 		 */
-		ret = num_buffers;
+	}
+
+	q->num_buffers = allocated_buffers;
+
+	if (ret < 0) {
+		__vb2_queue_free(q, allocated_buffers);
+		return ret;
 	}
 
 	/*
 	 * Return the number of successfully allocated buffers
 	 * to the userspace.
 	 */
-	req->count = ret;
+	req->count = allocated_buffers;
 
 	return 0;
-
-free_mem:
-	__vb2_queue_free(q);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
 /**
+ * vb2_create_bufs() - Allocate buffers and any required auxiliary structs
+ * @q:		videobuf2 queue
+ * @create:	creation parameters, passed from userspace to vidioc_create_bufs
+ *		handler in driver
+ *
+ * Should be called from vidioc_create_bufs ioctl handler of a driver.
+ * This function:
+ * 1) verifies parameter sanity
+ * 2) calls the .queue_setup() queue operation
+ * 3) performs any necessary memory allocations
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_create_bufs handler in driver.
+ */
+int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
+{
+	unsigned int num_planes = create->num_planes,
+		num_buffers = create->count, allocated_buffers;
+	int ret = 0;
+
+	if (q->fileio) {
+		dprintk(1, "%s(): file io in progress\n", __func__);
+		return -EBUSY;
+	}
+
+	if (create->memory != V4L2_MEMORY_MMAP
+			&& create->memory != V4L2_MEMORY_USERPTR) {
+		dprintk(1, "%s(): unsupported memory type\n", __func__);
+		return -EINVAL;
+	}
+
+	if (create->type != q->type) {
+		dprintk(1, "%s(): requested type is incorrect\n", __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * Make sure all the required memory ops for given memory type
+	 * are available.
+	 */
+	if (create->memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
+		dprintk(1, "%s(): MMAP for current setup unsupported\n", __func__);
+		return -EINVAL;
+	}
+
+	if (create->memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
+		dprintk(1, "%s(): USERPTR for current setup unsupported\n", __func__);
+		return -EINVAL;
+	}
+
+	if (q->num_buffers == VIDEO_MAX_FRAME) {
+		dprintk(1, "%s(): maximum number of buffers already allocated\n",
+			__func__);
+		return -ENOBUFS;
+	}
+
+	create->index = q->num_buffers;
+
+	if (!q->num_buffers) {
+		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
+		q->memory = create->memory;
+	}
+
+	/*
+	 * Ask the driver, whether the requested number of buffers, planes per
+	 * buffer and their sizes are acceptable
+	 */
+	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
+		       create->sizes, q->alloc_ctx);
+	if (ret)
+		return ret;
+
+	/* Finally, allocate buffers and video memory */
+	ret = __vb2_queue_alloc(q, create->memory, num_buffers,
+				num_planes, create->sizes);
+	if (ret < 0) {
+		dprintk(1, "Memory allocation failed with error: %d\n", ret);
+		return ret;
+	}
+
+	allocated_buffers = ret;
+
+	/*
+	 * Check if driver can handle the so far allocated number of buffers.
+	 */
+	if (ret < num_buffers) {
+		num_buffers = ret;
+
+		/*
+		 * q->num_buffers contains the total number of buffers, that the
+		 * queue driver has set up
+		 */
+		ret = call_qop(q, queue_setup, q, &num_buffers,
+			       &num_planes, create->sizes, q->alloc_ctx);
+
+		if (!ret && allocated_buffers < num_buffers)
+			ret = -ENOMEM;
+
+		/*
+		 * Either the driver has accepted a smaller number of buffers,
+		 * or .queue_setup() returned an error
+		 */
+	}
+
+	q->num_buffers += allocated_buffers;
+
+	if (ret < 0) {
+		__vb2_queue_free(q, allocated_buffers);
+		return ret;
+	}
+
+	/*
+	 * Return the number of successfully allocated buffers
+	 * to the userspace.
+	 */
+	create->count = allocated_buffers;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_create_bufs);
+
+/**
  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
  * @vb:		vb2_buffer to which the plane in question belongs to
  * @plane_no:	plane number for which the address is to be returned
@@ -844,6 +977,61 @@ static int __buf_prepare(struct vb2_buffer *vb, struct v4l2_buffer *b)
 }
 
 /**
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
+	struct vb2_buffer *vb;
+
+	if (q->fileio) {
+		dprintk(1, "%s(): file io in progress\n", __func__);
+		return -EBUSY;
+	}
+
+	if (b->type != q->type) {
+		dprintk(1, "%s(): invalid buffer type\n", __func__);
+		return -EINVAL;
+	}
+
+	if (b->index >= q->num_buffers) {
+		dprintk(1, "%s(): buffer index out of range\n", __func__);
+		return -EINVAL;
+	}
+
+	vb = q->bufs[b->index];
+	if (NULL == vb) {
+		/* Should never happen */
+		dprintk(1, "%s(): buffer is NULL\n", __func__);
+		return -EINVAL;
+	}
+
+	if (b->memory != q->memory) {
+		dprintk(1, "%s(): invalid memory type\n", __func__);
+		return -EINVAL;
+	}
+
+	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+		dprintk(1, "%s(): invalid buffer state %d\n", __func__, vb->state);
+		return -EINVAL;
+	}
+
+	return __buf_prepare(vb, b);
+}
+EXPORT_SYMBOL_GPL(vb2_prepare_buf);
+
+/**
  * vb2_qbuf() - Queue a buffer from userspace
  * @q:		videobuf2 queue
  * @b:		buffer structure passed from userspace to vidioc_qbuf handler
@@ -1476,7 +1664,7 @@ void vb2_queue_release(struct vb2_queue *q)
 {
 	__vb2_cleanup_fileio(q);
 	__vb2_queue_cancel(q);
-	__vb2_queue_free(q);
+	__vb2_queue_free(q, q->num_buffers);
 }
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 7dd6bca..8900e25 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -172,13 +172,17 @@ struct vb2_buffer {
 /**
  * struct vb2_ops - driver-specific callbacks
  *
- * @queue_setup:	called from a VIDIOC_REQBUFS handler, before
- *			memory allocation; driver should return the required
- *			number of buffers in num_buffers, the required number
- *			of planes per buffer in num_planes; the size of each
- *			plane should be set in the sizes[] array and optional
- *			per-plane allocator specific context in alloc_ctxs[]
- *			array
+ * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
+ *			handlers, before memory allocation. When called with
+ *			zeroed num_planes or plane sizes, the driver should
+ *			return the required number of buffers in num_buffers,
+ *			the required number of planes per buffer in num_planes;
+ *			the size of each plane should be set in the sizes[]
+ *			array and optional per-plane allocator specific context
+ *			in alloc_ctxs[] array. If num_planes and sizes[] are
+ *			both non-zero, the driver should use them. Otherwise the
+ *			driver must make no assumptions about the buffers, that
+ *			will be made available to it.
  * @wait_prepare:	release any locks taken while calling vb2 functions;
  *			it is called before an ioctl needs to wait for a new
  *			buffer to arrive; required to avoid a deadlock in
@@ -191,11 +195,11 @@ struct vb2_buffer {
  *			perform additional buffer-related initialization;
  *			initialization failure (return != 0) will prevent
  *			queue setup from completing successfully; optional
- * @buf_prepare:	called every time the buffer is queued from userspace;
- *			drivers may perform any initialization required before
- *			each hardware operation in this callback;
- *			if an error is returned, the buffer will not be queued
- *			in driver; optional
+ * @buf_prepare:	called every time the buffer is queued from userspace
+ *			and from the VIDIOC_PREPARE_BUF ioctl; drivers may
+ *			perform any initialization required before each hardware
+ *			operation in this callback; if an error is returned, the
+ *			buffer will not be queued in driver; optional
  * @buf_finish:		called before every dequeue of the buffer back to
  *			userspace; drivers may perform any operations required
  *			before userspace accesses the buffer; optional
@@ -293,6 +297,9 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q);
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
 
+int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
+int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
+
 int vb2_queue_init(struct vb2_queue *q);
 
 void vb2_queue_release(struct vb2_queue *q);
-- 
1.7.2.5

