Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:45952 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbbIVNas (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 09:30:48 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NV202P6OYV4TR50@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Sep 2015 22:30:40 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v5 7/8] media: videobuf2: Prepare to divide videobuf2
Date: Tue, 22 Sep 2015 22:30:35 +0900
Message-id: <1442928636-3589-8-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare to divide videobuf2
- Separate vb2 trace events from v4l2 trace event.
- Make wrapper functions that will move to v4l2-side
- Make vb2_core_* functions that remain in vb2 core side
- Rename internal functions as vb2_*

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/Makefile         |    2 +-
 drivers/media/v4l2-core/v4l2-trace.c     |    8 +-
 drivers/media/v4l2-core/vb2-trace.c      |    9 +
 drivers/media/v4l2-core/videobuf2-core.c |  556 ++++++++++++++++++++----------
 include/trace/events/v4l2.h              |   28 +-
 include/trace/events/vb2.h               |   65 ++++
 6 files changed, 457 insertions(+), 211 deletions(-)
 create mode 100644 drivers/media/v4l2-core/vb2-trace.c
 create mode 100644 include/trace/events/vb2.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index ad07401..1dc8bba 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -14,7 +14,7 @@ ifeq ($(CONFIG_OF),y)
   videodev-objs += v4l2-of.o
 endif
 ifeq ($(CONFIG_TRACEPOINTS),y)
-  videodev-objs += v4l2-trace.o
+  videodev-objs += vb2-trace.o v4l2-trace.o
 endif
 
 obj-$(CONFIG_VIDEO_V4L2) += videodev.o
diff --git a/drivers/media/v4l2-core/v4l2-trace.c b/drivers/media/v4l2-core/v4l2-trace.c
index 4004814..7416010 100644
--- a/drivers/media/v4l2-core/v4l2-trace.c
+++ b/drivers/media/v4l2-core/v4l2-trace.c
@@ -5,7 +5,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/v4l2.h>
 
-EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_done);
-EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_queue);
-EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_dqbuf);
-EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_qbuf);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_buf_done);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_buf_queue);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_dqbuf);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_qbuf);
diff --git a/drivers/media/v4l2-core/vb2-trace.c b/drivers/media/v4l2-core/vb2-trace.c
new file mode 100644
index 0000000..61e74f5
--- /dev/null
+++ b/drivers/media/v4l2-core/vb2-trace.c
@@ -0,0 +1,9 @@
+#include <media/videobuf2-core.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/vb2.h>
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_done);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_queue);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_dqbuf);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_qbuf);
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 32fa425..380536d 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-common.h>
 #include <media/videobuf2-v4l2.h>
 
-#include <trace/events/v4l2.h>
+#include <trace/events/vb2.h>
 
 static int debug;
 module_param(debug, int, 0644);
@@ -612,10 +612,10 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 }
 
 /**
- * __buffer_in_use() - return true if the buffer is in use and
+ * vb2_buffer_in_use() - return true if the buffer is in use and
  * the queue cannot be freed (by the means of REQBUFS(0)) call
  */
-static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
+static bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 {
 	unsigned int plane;
 	for (plane = 0; plane < vb->num_planes; ++plane) {
@@ -640,7 +640,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
 {
 	unsigned int buffer;
 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		if (__buffer_in_use(q, q->bufs[buffer]))
+		if (vb2_buffer_in_use(q, q->bufs[buffer]))
 			return true;
 	}
 	return false;
@@ -650,8 +650,9 @@ static bool __buffers_in_use(struct vb2_queue *q)
  * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
  * returned to userspace
  */
-static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
+static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 {
+	struct v4l2_buffer *b = pb;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned int plane;
@@ -742,8 +743,28 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		break;
 	}
 
-	if (__buffer_in_use(q, vb))
+	if (vb2_buffer_in_use(q, vb))
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
+
+	return 0;
+}
+
+/**
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
+static int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
+{
+	return __fill_v4l2_buffer(q->bufs[index], pb);
 }
 
 /**
@@ -775,11 +796,10 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	}
 	vb = q->bufs[b->index];
 	ret = __verify_planes_array(vb, b);
-	if (!ret)
-		__fill_v4l2_buffer(vb, b);
-	return ret;
+
+	return ret ? ret : vb2_core_querybuf(q, b->index, b);
 }
-EXPORT_SYMBOL(vb2_querybuf);
+EXPORT_SYMBOL_GPL(vb2_querybuf);
 
 /**
  * __verify_userptr_ops() - verify that all memory operations required for
@@ -822,10 +842,10 @@ static int __verify_dmabuf_ops(struct vb2_queue *q)
 }
 
 /**
- * __verify_memory_type() - Check whether the memory type and buffer type
+ * vb2_verify_memory_type() - Check whether the memory type and buffer type
  * passed to a buffer operation are compatible with the queue.
  */
-static int __verify_memory_type(struct vb2_queue *q,
+static int vb2_verify_memory_type(struct vb2_queue *q,
 		enum vb2_memory memory, unsigned int type)
 {
 	if (memory != VB2_MEMORY_MMAP && memory != VB2_MEMORY_USERPTR &&
@@ -871,9 +891,10 @@ static int __verify_memory_type(struct vb2_queue *q,
 }
 
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
@@ -893,7 +914,8 @@ static int __verify_memory_type(struct vb2_queue *q,
  * The return values from this function are intended to be directly returned
  * from vidioc_reqbufs handler in driver.
  */
-static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
+static int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
+		unsigned int *count)
 {
 	unsigned int num_buffers, allocated_buffers, num_planes = 0;
 	int ret;
@@ -903,7 +925,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return -EBUSY;
 	}
 
-	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
+	if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
 		/*
 		 * We already have buffers allocated, so first check if they
 		 * are not in use and can be freed.
@@ -930,18 +952,18 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
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
@@ -953,7 +975,8 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return ret;
 
 	/* Finally, allocate buffers and video memory */
-	allocated_buffers = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
+	allocated_buffers =
+		__vb2_queue_alloc(q, memory, num_buffers, num_planes);
 	if (allocated_buffers == 0) {
 		dprintk(1, "memory allocation failed\n");
 		return -ENOMEM;
@@ -1002,23 +1025,24 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * Return the number of successfully allocated buffers
 	 * to the userspace.
 	 */
-	req->count = allocated_buffers;
+	*count = allocated_buffers;
 	q->waiting_for_buffers = !q->is_output;
 
 	return 0;
 }
 
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
+	return ret ? ret : vb2_core_reqbufs(q, req->memory, &req->count);
 }
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
@@ -1068,10 +1092,11 @@ static struct vb2_format *__to_vb2_format(struct vb2_format *dfmt,
 }
 
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
@@ -1082,10 +1107,10 @@ static struct vb2_format *__to_vb2_format(struct vb2_format *dfmt,
  * The return values from this function are intended to be directly returned
  * from vidioc_create_bufs handler in driver.
  */
-static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
+static int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
+		unsigned int *count, struct vb2_format *fmt)
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
-	struct vb2_format fmt;
 	int ret;
 
 	if (q->num_buffers == VB2_MAX_FRAME) {
@@ -1096,25 +1121,23 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	if (!q->num_buffers) {
 		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
-		q->memory = create->memory;
+		q->memory = memory;
 		q->waiting_for_buffers = !q->is_output;
 	}
 
-	num_buffers = min(create->count, VB2_MAX_FRAME - q->num_buffers);
+	num_buffers = min(*count, VB2_MAX_FRAME - q->num_buffers);
 
 	/*
 	 * Ask the driver, whether the requested number of buffers, planes per
 	 * buffer and their sizes are acceptable
 	 */
-	ret = call_qop(q, queue_setup, q,
-			__to_vb2_format(&fmt, &create->format),
-			&num_buffers, &num_planes, q->plane_sizes,
-			q->alloc_ctx);
+	ret = call_qop(q, queue_setup, q, fmt, &num_buffers,
+			&num_planes, q->plane_sizes, q->alloc_ctx);
 	if (ret)
 		return ret;
 
 	/* Finally, allocate buffers and video memory */
-	allocated_buffers = __vb2_queue_alloc(q, create->memory, num_buffers,
+	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
 				num_planes);
 	if (allocated_buffers == 0) {
 		dprintk(1, "memory allocation failed\n");
@@ -1131,10 +1154,8 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 		 * q->num_buffers contains the total number of buffers, that the
 		 * queue driver has set up
 		 */
-		ret = call_qop(q, queue_setup, q,
-				__to_vb2_format(&fmt, &create->format),
-				&num_buffers, &num_planes, q->plane_sizes,
-				q->alloc_ctx);
+		ret = call_qop(q, queue_setup, q, fmt, &num_buffers,
+				&num_planes, q->plane_sizes, q->alloc_ctx);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
@@ -1163,26 +1184,29 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	 * Return the number of successfully allocated buffers
 	 * to the userspace.
 	 */
-	create->count = allocated_buffers;
+	*count = allocated_buffers;
 
 	return 0;
 }
 
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
+	int ret = vb2_verify_memory_type(q, create->memory,
+			create->format.type);
+	struct vb2_format fmt;
 
 	create->index = q->num_buffers;
 	if (create->count == 0)
 		return ret != -EBUSY ? ret : 0;
-	return ret ? ret : __create_bufs(q, create);
+	return ret ? ret : vb2_core_create_bufs(q, create->memory,
+		&create->count, __to_vb2_format(&fmt, &create->format));
 }
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
@@ -1343,16 +1367,62 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
 		pr_warn("use the actual size instead.\n");
 }
 
+static void __set_timestamp(struct vb2_buffer *vb, const void *pb)
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
+};
+
 /**
  * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
- * v4l2_buffer by the userspace. The caller has already verified that struct
+ * v4l2_buffer by the userspace. It also verifies that struct
  * v4l2_buffer has a valid number of planes.
  */
-static void __fill_vb2_buffer(struct vb2_buffer *vb,
-		const struct v4l2_buffer *b, struct vb2_plane *planes)
+static int __fill_vb2_buffer(struct vb2_buffer *vb,
+		const void *pb, struct vb2_plane *planes)
 {
+	struct vb2_queue *q = vb->vb2_queue;
+	const struct v4l2_buffer *b = pb;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	unsigned int plane;
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
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		if (b->memory == VB2_MEMORY_USERPTR) {
@@ -1469,21 +1539,23 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb,
 		/* Zero any output buffer flags as this is a capture buffer */
 		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
 	}
+
+	return 0;
 }
 
 /**
  * __qbuf_mmap() - handle qbuf of an MMAP buffer
  */
-static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_mmap(struct vb2_buffer *vb, const void *pb)
 {
-	__fill_vb2_buffer(vb, b, vb->planes);
-	return call_vb_qop(vb, buf_prepare, vb);
+	int ret = __fill_vb2_buffer(vb, pb, vb->planes);
+	return ret ? ret : call_vb_qop(vb, buf_prepare, vb);
 }
 
 /**
  * __qbuf_userptr() - handle qbuf of a USERPTR buffer
  */
-static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 {
 	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
@@ -1496,7 +1568,9 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
 	/* Copy relevant information provided by the userspace */
-	__fill_vb2_buffer(vb, b, planes);
+	ret = __fill_vb2_buffer(vb, pb, planes);
+	if (ret)
+		return ret;
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		/* Skip the plane if already verified */
@@ -1595,7 +1669,7 @@ err:
 /**
  * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
  */
-static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 {
 	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
@@ -1608,7 +1682,9 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
 	/* Copy relevant information provided by the userspace */
-	__fill_vb2_buffer(vb, b, planes);
+	ret = __fill_vb2_buffer(vb, pb, planes);
+	if (ret)
+		return ret;
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
@@ -1739,50 +1815,27 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 	call_void_vb_qop(vb, buf_queue, vb);
 }
 
-static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 {
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
 	int ret;
 
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
-		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
-		return -EINVAL;
-	}
-
 	if (q->error) {
 		dprintk(1, "fatal error occurred on queue\n");
 		return -EIO;
 	}
 
 	vb->state = VB2_BUF_STATE_PREPARING;
-	vbuf->timestamp.tv_sec = 0;
-	vbuf->timestamp.tv_usec = 0;
-	vbuf->sequence = 0;
 
 	switch (q->memory) {
 	case VB2_MEMORY_MMAP:
-		ret = __qbuf_mmap(vb, b);
+		ret = __qbuf_mmap(vb, pb);
 		break;
 	case VB2_MEMORY_USERPTR:
-		ret = __qbuf_userptr(vb, b);
+		ret = __qbuf_userptr(vb, pb);
 		break;
 	case VB2_MEMORY_DMABUF:
-		ret = __qbuf_dmabuf(vb, b);
+		ret = __qbuf_dmabuf(vb, pb);
 		break;
 	default:
 		WARN(1, "Invalid queue type\n");
@@ -1824,6 +1877,48 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 }
 
 /**
+ * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace
+ *			to the kernel
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
+static int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
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
+	if (ret)
+		return ret;
+
+	/* Fill buffer information for the userspace */
+	ret = __fill_v4l2_buffer(vb, pb);
+	if (ret)
+		return ret;
+
+	dprintk(1, "prepare of buffer %d succeeded\n", vb->index);
+
+	return ret;
+}
+
+/**
  * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
  * @q:		videobuf2 queue
  * @b:		buffer structure passed from userspace to vidioc_prepare_buf
@@ -1840,7 +1935,6 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
  */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb;
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
@@ -1849,24 +1943,8 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 	}
 
 	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
-	if (ret)
-		return ret;
-
-	vb = q->bufs[b->index];
-	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-		dprintk(1, "invalid buffer state %d\n",
-			vb->state);
-		return -EINVAL;
-	}
 
-	ret = __buf_prepare(vb, b);
-	if (!ret) {
-		/* Fill buffer information for the userspace */
-		__fill_v4l2_buffer(vb, b);
-
-		dprintk(1, "prepare of buffer %d succeeded\n", vb->index);
-	}
-	return ret;
+	return ret ? ret : vb2_core_prepare_buf(q, b->index, b);
 }
 EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
@@ -1933,21 +2011,34 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+/**
+ * vb2_core_qbuf() - Queue a buffer from userspace
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
+static int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 {
-	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
 	struct vb2_buffer *vb;
-	struct vb2_v4l2_buffer *vbuf;
-
-	if (ret)
-		return ret;
+	int ret;
 
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
@@ -1969,18 +2060,8 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	q->queued_count++;
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
-	if (q->is_output) {
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
+	__set_timestamp(vb, pb);
 
 	trace_vb2_qbuf(q, vb);
 
@@ -1992,7 +2073,9 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		__enqueue_in_driver(vb);
 
 	/* Fill buffer information for the userspace */
-	__fill_v4l2_buffer(vb, b);
+	ret = __fill_v4l2_buffer(vb, pb);
+	if (ret)
+		return ret;
 
 	/*
 	 * If streamon has been called, and we haven't yet called
@@ -2011,6 +2094,13 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	return 0;
 }
 
+static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
+
+	return ret ? ret : vb2_core_qbuf(q, b->index, b);
+}
+
 /**
  * vb2_qbuf() - Queue a buffer from userspace
  * @q:		videobuf2 queue
@@ -2121,7 +2211,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
  * Will sleep if required for nonblocking == false.
  */
 static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
-				struct v4l2_buffer *b, int nonblocking)
+				int nonblocking)
 {
 	unsigned long flags;
 	int ret;
@@ -2142,10 +2232,10 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
 	/*
 	 * Only remove the buffer from done_list if v4l2_buffer can handle all
 	 * the planes.
+	 * Verifing planes is NOT necessary since it aleady has been checked
+	 * before the buffer is queued/prepared. So it can never fails
 	 */
-	ret = __verify_planes_array(*vb, b);
-	if (!ret)
-		list_del(&(*vb)->done_entry);
+	list_del(&(*vb)->done_entry);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
 	return ret;
@@ -2197,18 +2287,33 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 		}
 }
 
-static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
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
+static int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking)
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
 
@@ -2227,17 +2332,16 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 	call_void_vb_qop(vb, buf_finish, vb);
 
 	/* Fill buffer information for the userspace */
-	__fill_v4l2_buffer(vb, b);
+	ret = __fill_v4l2_buffer(vb, pb);
+	if (ret)
+		return ret;
+
 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
 	q->queued_count--;
 
 	trace_vb2_dqbuf(q, vb);
 
-	vbuf = to_vb2_v4l2_buffer(vb);
-	if (!q->is_output &&
-			vbuf->flags & V4L2_BUF_FLAG_LAST)
-		q->last_buffer_dequeued = true;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
@@ -2245,6 +2349,26 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 			vb->index, vb->state);
 
 	return 0;
+
+}
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
 }
 
 /**
@@ -2346,7 +2470,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	}
 }
 
-static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+static int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 {
 	int ret;
 
@@ -2429,11 +2553,11 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
-	return vb2_internal_streamon(q, type);
+	return vb2_core_streamon(q, type);
 }
 EXPORT_SYMBOL_GPL(vb2_streamon);
 
-static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+static int vb2_core_streamoff(struct vb2_queue *q, unsigned int type)
 {
 	if (type != q->type) {
 		dprintk(1, "invalid stream type\n");
@@ -2478,7 +2602,7 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
-	return vb2_internal_streamoff(q, type);
+	return vb2_core_streamoff(q, type);
 }
 EXPORT_SYMBOL_GPL(vb2_streamoff);
 
@@ -2512,15 +2636,20 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
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
+static int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
+		unsigned int index, unsigned int plane, unsigned int flags)
 {
 	struct vb2_buffer *vb = NULL;
 	struct vb2_plane *vb_plane;
@@ -2537,24 +2666,24 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
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
@@ -2564,29 +2693,45 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 		return -EBUSY;
 	}
 
-	vb_plane = &vb->planes[eb->plane];
+	vb_plane = &vb->planes[plane];
 
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
 EXPORT_SYMBOL_GPL(vb2_expbuf);
 
 /**
@@ -2825,7 +2970,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 EXPORT_SYMBOL_GPL(vb2_poll);
 
 /**
- * vb2_queue_init() - initialize a videobuf2 queue
+ * vb2_core_queue_init() - initialize a videobuf2 queue
  * @q:		videobuf2 queue; this structure should be allocated in driver
  *
  * The vb2_queue structure should be allocated by the driver. The driver is
@@ -2835,7 +2980,7 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  * to the struct vb2_queue description in include/media/videobuf2-core.h
  * for more information.
  */
-int vb2_queue_init(struct vb2_queue *q)
+static int vb2_core_queue_init(struct vb2_queue *q)
 {
 	/*
 	 * Sanity check
@@ -2846,7 +2991,38 @@ int vb2_queue_init(struct vb2_queue *q)
 	    WARN_ON(!q->type)		  ||
 	    WARN_ON(!q->io_modes)	  ||
 	    WARN_ON(!q->ops->queue_setup) ||
-	    WARN_ON(!q->ops->buf_queue)   ||
+	    WARN_ON(!q->ops->buf_queue))
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
 	    WARN_ON(q->timestamp_flags &
 		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
 		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
@@ -2862,38 +3038,45 @@ int vb2_queue_init(struct vb2_queue *q)
 		|| WARN_ON(VB2_MEMORY_DMABUF != (int)V4L2_MEMORY_DMABUF))
 		return -EINVAL;
 
-	INIT_LIST_HEAD(&q->queued_list);
-	INIT_LIST_HEAD(&q->done_list);
-	spin_lock_init(&q->done_lock);
-	mutex_init(&q->mmap_lock);
-	init_waitqueue_head(&q->done_wq);
-
 	if (q->buf_struct_size == 0)
 		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
 
 	q->is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
 	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);
 
-	return 0;
+	return vb2_core_queue_init(q);
 }
 EXPORT_SYMBOL_GPL(vb2_queue_init);
 
 /**
- * vb2_queue_release() - stop streaming, release the queue and free memory
+ * vb2_core_queue_release() - stop streaming, release the queue and free memory
  * @q:		videobuf2 queue
  *
  * This function stops streaming and performs necessary clean ups, including
  * freeing video buffer memory. The driver is responsible for freeing
  * the vb2_queue structure itself.
  */
-void vb2_queue_release(struct vb2_queue *q)
+static void vb2_core_queue_release(struct vb2_queue *q)
 {
-	__vb2_cleanup_fileio(q);
 	__vb2_queue_cancel(q);
 	mutex_lock(&q->mmap_lock);
 	__vb2_queue_free(q, q->num_buffers);
 	mutex_unlock(&q->mmap_lock);
 }
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
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
 /**
@@ -3001,7 +3184,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	fileio->req.memory = VB2_MEMORY_MMAP;
 	fileio->req.type = q->type;
 	q->fileio = fileio;
-	ret = __reqbufs(q, &fileio->req);
+	ret = vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
 	if (ret)
 		goto err_kfree;
 
@@ -3063,7 +3246,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	/*
 	 * Start streaming.
 	 */
-	ret = vb2_internal_streamon(q, q->type);
+	ret = vb2_core_streamon(q, q->type);
 	if (ret)
 		goto err_reqbufs;
 
@@ -3071,7 +3254,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 
 err_reqbufs:
 	fileio->req.count = 0;
-	__reqbufs(q, &fileio->req);
+	vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
 
 err_kfree:
 	q->fileio = NULL;
@@ -3088,7 +3271,7 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
 	struct vb2_fileio_data *fileio = q->fileio;
 
 	if (fileio) {
-		vb2_internal_streamoff(q, q->type);
+		vb2_core_streamoff(q, q->type);
 		q->fileio = NULL;
 		fileio->req.count = 0;
 		vb2_reqbufs(q, &fileio->req);
@@ -3445,13 +3628,13 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *p)
 {
 	struct video_device *vdev = video_devdata(file);
-	int res = __verify_memory_type(vdev->queue, p->memory, p->type);
+	int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);
 
 	if (res)
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	res = __reqbufs(vdev->queue, p);
+	res = vb2_core_reqbufs(vdev->queue, p->memory, &p->count);
 	/* If count == 0, then the owner has released all buffers and he
 	   is no longer owner of the queue. Otherwise we have a new owner. */
 	if (res == 0)
@@ -3464,18 +3647,23 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 			  struct v4l2_create_buffers *p)
 {
 	struct video_device *vdev = video_devdata(file);
-	int res = __verify_memory_type(vdev->queue, p->memory, p->format.type);
+	int res = vb2_verify_memory_type(vdev->queue, p->memory,
+			p->format.type);
+	struct vb2_format fmt;
 
 	p->index = vdev->queue->num_buffers;
-	/* If count == 0, then just check if memory and type are valid.
-	   Any -EBUSY result from __verify_memory_type can be mapped to 0. */
+	/*
+	 * If count == 0, then just check if memory and type are valid.
+	 * Any -EBUSY result from vb2_verify_memory_type can be mapped to 0.
+	 */
 	if (p->count == 0)
 		return res != -EBUSY ? res : 0;
 	if (res)
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	res = __create_bufs(vdev->queue, p);
+	res = vb2_core_create_bufs(vdev->queue, p->memory, &p->count,
+			__to_vb2_format(&fmt, &p->format));
 	if (res == 0)
 		vdev->queue->owner = file->private_data;
 	return res;
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index 375b1a3..04ef89b 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -175,17 +175,12 @@ DEFINE_EVENT(v4l2_event_class, v4l2_qbuf,
 	TP_ARGS(minor, buf)
 );
 
-DECLARE_EVENT_CLASS(vb2_event_class,
+DECLARE_EVENT_CLASS(vb2_v4l2_event_class,
 	TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),
 	TP_ARGS(q, vb),
 
 	TP_STRUCT__entry(
 		__field(int, minor)
-		__field(u32, queued_count)
-		__field(int, owned_by_drv_count)
-		__field(u32, index)
-		__field(u32, type)
-		__field(u32, bytesused)
 		__field(u32, flags)
 		__field(u32, field)
 		__field(s64, timestamp)
@@ -207,12 +202,6 @@ DECLARE_EVENT_CLASS(vb2_event_class,
 		struct v4l2_fh *owner = q->owner;
 
 		__entry->minor = owner ? owner->vdev->minor : -1;
-		__entry->queued_count = q->queued_count;
-		__entry->owned_by_drv_count =
-			atomic_read(&q->owned_by_drv_count);
-		__entry->index = vb->index;
-		__entry->type = vb->type;
-		__entry->bytesused = vb->planes[0].bytesused;
 		__entry->flags = vbuf->flags;
 		__entry->field = vbuf->field;
 		__entry->timestamp = timeval_to_ns(&vbuf->timestamp);
@@ -229,15 +218,10 @@ DECLARE_EVENT_CLASS(vb2_event_class,
 		__entry->sequence = vbuf->sequence;
 	),
 
-	TP_printk("minor = %d, queued = %u, owned_by_drv = %d, index = %u, "
-		  "type = %s, bytesused = %u, flags = %s, field = %s, "
+	TP_printk("minor=%d flags = %s, field = %s, "
 		  "timestamp = %llu, timecode = { type = %s, flags = %s, "
 		  "frames = %u, seconds = %u, minutes = %u, hours = %u, "
 		  "userbits = { %u %u %u %u } }, sequence = %u", __entry->minor,
-		  __entry->queued_count,
-		  __entry->owned_by_drv_count,
-		  __entry->index, show_type(__entry->type),
-		  __entry->bytesused,
 		  show_flags(__entry->flags),
 		  show_field(__entry->field),
 		  __entry->timestamp,
@@ -255,22 +239,22 @@ DECLARE_EVENT_CLASS(vb2_event_class,
 	)
 )
 
-DEFINE_EVENT(vb2_event_class, vb2_buf_done,
+DEFINE_EVENT(vb2_v4l2_event_class, vb2_v4l2_buf_done,
 	TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),
 	TP_ARGS(q, vb)
 );
 
-DEFINE_EVENT(vb2_event_class, vb2_buf_queue,
+DEFINE_EVENT(vb2_v4l2_event_class, vb2_v4l2_buf_queue,
 	TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),
 	TP_ARGS(q, vb)
 );
 
-DEFINE_EVENT(vb2_event_class, vb2_dqbuf,
+DEFINE_EVENT(vb2_v4l2_event_class, vb2_v4l2_dqbuf,
 	TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),
 	TP_ARGS(q, vb)
 );
 
-DEFINE_EVENT(vb2_event_class, vb2_qbuf,
+DEFINE_EVENT(vb2_v4l2_event_class, vb2_v4l2_qbuf,
 	TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),
 	TP_ARGS(q, vb)
 );
diff --git a/include/trace/events/vb2.h b/include/trace/events/vb2.h
new file mode 100644
index 0000000..bfeceeb
--- /dev/null
+++ b/include/trace/events/vb2.h
@@ -0,0 +1,65 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vb2
+
+#if !defined(_TRACE_VB2_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VB2_H
+
+#include <linux/tracepoint.h>
+#include <media/videobuf2-core.h>
+
+DECLARE_EVENT_CLASS(vb2_event_class,
+	TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),
+	TP_ARGS(q, vb),
+
+	TP_STRUCT__entry(
+		__field(void *, owner)
+		__field(u32, queued_count)
+		__field(int, owned_by_drv_count)
+		__field(u32, index)
+		__field(u32, type)
+		__field(u32, bytesused)
+	),
+
+	TP_fast_assign(
+		__entry->owner = q->owner;
+		__entry->queued_count = q->queued_count;
+		__entry->owned_by_drv_count =
+			atomic_read(&q->owned_by_drv_count);
+		__entry->index = vb->index;
+		__entry->type = vb->type;
+		__entry->bytesused = vb->planes[0].bytesused;
+	),
+
+	TP_printk("owner = %p, queued = %u, owned_by_drv = %d, index = %u, "
+		  "type = %u, bytesused = %u", __entry->owner,
+		  __entry->queued_count,
+		  __entry->owned_by_drv_count,
+		  __entry->index, __entry->type,
+		  __entry->bytesused
+	)
+)
+
+DEFINE_EVENT(vb2_event_class, vb2_buf_done,
+	TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),
+	TP_ARGS(q, vb)
+);
+
+DEFINE_EVENT(vb2_event_class, vb2_buf_queue,
+	TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),
+	TP_ARGS(q, vb)
+);
+
+DEFINE_EVENT(vb2_event_class, vb2_dqbuf,
+	TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),
+	TP_ARGS(q, vb)
+);
+
+DEFINE_EVENT(vb2_event_class, vb2_qbuf,
+	TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),
+	TP_ARGS(q, vb)
+);
+
+#endif /* if !defined(_TRACE_VB2_H) || defined(TRACE_HEADER_MULTI_READ) */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.9.5

