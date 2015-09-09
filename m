Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34254 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbbIILUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 07:20:10 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NUE030BCQ5DSLD0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Sep 2015 20:20:01 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v4 6/8] [media] videobuf2: Replace v4l2-specific data with
 vb2 data.
Date: Wed, 09 Sep 2015 20:19:55 +0900
Message-id: <1441797597-17389-7-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com>
References: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

enum v4l2_memory -> enum vb2_memory
VIDEO_MAX_FRAME -> VB2_MAX_FRAME
VIDEO_MAX_PLANES -> VB2_MAX_PLANES

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |   80 +++++++++++++++---------------
 include/media/videobuf2-core.h           |   29 +++++++----
 include/trace/events/v4l2.h              |    5 +-
 3 files changed, 64 insertions(+), 50 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index ebdb318..34e27d2 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -347,7 +347,7 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
  *
  * Returns the number of buffers successfully allocated.
  */
-static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
+static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			     unsigned int num_buffers, unsigned int num_planes)
 {
 	unsigned int buffer;
@@ -370,7 +370,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 		vb->memory = memory;
 
 		/* Allocate video buffer memory for the MMAP type */
-		if (memory == V4L2_MEMORY_MMAP) {
+		if (memory == VB2_MEMORY_MMAP) {
 			ret = __vb2_buf_mem_alloc(vb);
 			if (ret) {
 				dprintk(1, "failed allocating memory for "
@@ -397,7 +397,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 	}
 
 	__setup_lengths(q, buffer);
-	if (memory == V4L2_MEMORY_MMAP)
+	if (memory == VB2_MEMORY_MMAP)
 		__setup_offsets(q, buffer);
 
 	dprintk(1, "allocated %d buffers, %d plane(s) each\n",
@@ -421,9 +421,9 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
 			continue;
 
 		/* Free MMAP buffers or release USERPTR buffers */
-		if (q->memory == V4L2_MEMORY_MMAP)
+		if (q->memory == VB2_MEMORY_MMAP)
 			__vb2_buf_mem_free(vb);
-		else if (q->memory == V4L2_MEMORY_DMABUF)
+		else if (q->memory == VB2_MEMORY_DMABUF)
 			__vb2_buf_dmabuf_put(vb);
 		else
 			__vb2_buf_userptr_put(vb);
@@ -562,7 +562,7 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 		return -EINVAL;
 	}
 
-	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
+	if (b->length < vb->num_planes || b->length > VB2_MAX_PLANES) {
 		dprintk(1, "incorrect planes array length, "
 			   "expected %d, got %d\n", vb->num_planes, b->length);
 		return -EINVAL;
@@ -586,8 +586,8 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		for (plane = 0; plane < vb->num_planes; ++plane) {
-			length = (b->memory == V4L2_MEMORY_USERPTR ||
-				  b->memory == V4L2_MEMORY_DMABUF)
+			length = (b->memory == VB2_MEMORY_USERPTR ||
+				  b->memory == VB2_MEMORY_DMABUF)
 			       ? b->m.planes[plane].length
 				: vb->planes[plane].length;
 			bytesused = b->m.planes[plane].bytesused
@@ -601,7 +601,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 				return -EINVAL;
 		}
 	} else {
-		length = (b->memory == V4L2_MEMORY_USERPTR)
+		length = (b->memory == VB2_MEMORY_USERPTR)
 			? b->length : vb->planes[0].length;
 
 		if (b->bytesused > length)
@@ -682,11 +682,11 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 
 			pdst->bytesused = psrc->bytesused;
 			pdst->length = psrc->length;
-			if (q->memory == V4L2_MEMORY_MMAP)
+			if (q->memory == VB2_MEMORY_MMAP)
 				pdst->m.mem_offset = psrc->m.offset;
-			else if (q->memory == V4L2_MEMORY_USERPTR)
+			else if (q->memory == VB2_MEMORY_USERPTR)
 				pdst->m.userptr = psrc->m.userptr;
-			else if (q->memory == V4L2_MEMORY_DMABUF)
+			else if (q->memory == VB2_MEMORY_DMABUF)
 				pdst->m.fd = psrc->m.fd;
 			pdst->data_offset = psrc->data_offset;
 			memset(pdst->reserved, 0, sizeof(pdst->reserved));
@@ -698,11 +698,11 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		 */
 		b->length = vb->planes[0].length;
 		b->bytesused = vb->planes[0].bytesused;
-		if (q->memory == V4L2_MEMORY_MMAP)
+		if (q->memory == VB2_MEMORY_MMAP)
 			b->m.offset = vb->planes[0].m.offset;
-		else if (q->memory == V4L2_MEMORY_USERPTR)
+		else if (q->memory == VB2_MEMORY_USERPTR)
 			b->m.userptr = vb->planes[0].m.userptr;
-		else if (q->memory == V4L2_MEMORY_DMABUF)
+		else if (q->memory == VB2_MEMORY_DMABUF)
 			b->m.fd = vb->planes[0].m.fd;
 	}
 
@@ -825,10 +825,10 @@ static int __verify_dmabuf_ops(struct vb2_queue *q)
  * passed to a buffer operation are compatible with the queue.
  */
 static int __verify_memory_type(struct vb2_queue *q,
-		enum v4l2_memory memory, enum v4l2_buf_type type)
+		enum vb2_memory memory, unsigned int type)
 {
-	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR &&
-	    memory != V4L2_MEMORY_DMABUF) {
+	if (memory != VB2_MEMORY_MMAP && memory != VB2_MEMORY_USERPTR &&
+	    memory != VB2_MEMORY_DMABUF) {
 		dprintk(1, "unsupported memory type\n");
 		return -EINVAL;
 	}
@@ -842,17 +842,17 @@ static int __verify_memory_type(struct vb2_queue *q,
 	 * Make sure all the required memory ops for given memory type
 	 * are available.
 	 */
-	if (memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
+	if (memory == VB2_MEMORY_MMAP && __verify_mmap_ops(q)) {
 		dprintk(1, "MMAP for current setup unsupported\n");
 		return -EINVAL;
 	}
 
-	if (memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
+	if (memory == VB2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
 		dprintk(1, "USERPTR for current setup unsupported\n");
 		return -EINVAL;
 	}
 
-	if (memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
+	if (memory == VB2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
 		dprintk(1, "DMABUF for current setup unsupported\n");
 		return -EINVAL;
 	}
@@ -908,7 +908,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		 * are not in use and can be freed.
 		 */
 		mutex_lock(&q->mmap_lock);
-		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
+		if (q->memory == VB2_MEMORY_MMAP && __buffers_in_use(q)) {
 			mutex_unlock(&q->mmap_lock);
 			dprintk(1, "memory in use, cannot free\n");
 			return -EBUSY;
@@ -936,7 +936,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	/*
 	 * Make sure the requested values and current defaults are sane.
 	 */
-	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
+	num_buffers = min_t(unsigned int, req->count, VB2_MAX_FRAME);
 	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
 	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
@@ -1041,7 +1041,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
 	int ret;
 
-	if (q->num_buffers == VIDEO_MAX_FRAME) {
+	if (q->num_buffers == VB2_MAX_FRAME) {
 		dprintk(1, "maximum number of buffers already allocated\n");
 		return -ENOBUFS;
 	}
@@ -1053,7 +1053,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 		q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
 	}
 
-	num_buffers = min(create->count, VIDEO_MAX_FRAME - q->num_buffers);
+	num_buffers = min(create->count, VB2_MAX_FRAME - q->num_buffers);
 
 	/*
 	 * Ask the driver, whether the requested number of buffers, planes per
@@ -1295,7 +1295,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb,
 	unsigned int plane;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		if (b->memory == V4L2_MEMORY_USERPTR) {
+		if (b->memory == VB2_MEMORY_USERPTR) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				planes[plane].m.userptr =
 					b->m.planes[plane].m.userptr;
@@ -1303,7 +1303,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb,
 					b->m.planes[plane].length;
 			}
 		}
-		if (b->memory == V4L2_MEMORY_DMABUF) {
+		if (b->memory == VB2_MEMORY_DMABUF) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				planes[plane].m.fd =
 					b->m.planes[plane].m.fd;
@@ -1360,12 +1360,12 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb,
 		 * the driver should use the allow_zero_bytesused flag to keep
 		 * old userspace applications working.
 		 */
-		if (b->memory == V4L2_MEMORY_USERPTR) {
+		if (b->memory == VB2_MEMORY_USERPTR) {
 			planes[0].m.userptr = b->m.userptr;
 			planes[0].length = b->length;
 		}
 
-		if (b->memory == V4L2_MEMORY_DMABUF) {
+		if (b->memory == VB2_MEMORY_DMABUF) {
 			planes[0].m.fd = b->m.fd;
 			planes[0].length = b->length;
 		}
@@ -1425,7 +1425,7 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
  */
 static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
-	struct vb2_plane planes[VIDEO_MAX_PLANES];
+	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
@@ -1537,7 +1537,7 @@ err:
  */
 static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
-	struct vb2_plane planes[VIDEO_MAX_PLANES];
+	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
@@ -1715,15 +1715,15 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	vbuf->sequence = 0;
 
 	switch (q->memory) {
-	case V4L2_MEMORY_MMAP:
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
@@ -2130,7 +2130,7 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 	vb->state = VB2_BUF_STATE_DEQUEUED;
 
 	/* unmap DMABUF buffer */
-	if (q->memory == V4L2_MEMORY_DMABUF)
+	if (q->memory == VB2_MEMORY_DMABUF)
 		for (i = 0; i < vb->num_planes; ++i) {
 			if (!vb->planes[i].dbuf_mapped)
 				continue;
@@ -2469,7 +2469,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 	int ret;
 	struct dma_buf *dbuf;
 
-	if (q->memory != V4L2_MEMORY_MMAP) {
+	if (q->memory != VB2_MEMORY_MMAP) {
 		dprintk(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
@@ -2558,7 +2558,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	int ret;
 	unsigned long length;
 
-	if (q->memory != V4L2_MEMORY_MMAP) {
+	if (q->memory != VB2_MEMORY_MMAP) {
 		dprintk(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
@@ -2631,7 +2631,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 	void *vaddr;
 	int ret;
 
-	if (q->memory != V4L2_MEMORY_MMAP) {
+	if (q->memory != VB2_MEMORY_MMAP) {
 		dprintk(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
@@ -2871,7 +2871,7 @@ struct vb2_fileio_data {
 	struct v4l2_requestbuffers req;
 	struct v4l2_plane p;
 	struct v4l2_buffer b;
-	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
+	struct vb2_fileio_buf bufs[VB2_MAX_FRAME];
 	unsigned int cur_index;
 	unsigned int initial_index;
 	unsigned int q_count;
@@ -2931,7 +2931,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * to allocate buffers by itself.
 	 */
 	fileio->req.count = count;
-	fileio->req.memory = V4L2_MEMORY_MMAP;
+	fileio->req.memory = VB2_MEMORY_MMAP;
 	fileio->req.type = q->type;
 	q->fileio = fileio;
 	ret = __reqbufs(q, &fileio->req);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5899f09..e6fa520 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -18,6 +18,16 @@
 #include <linux/videodev2.h>
 #include <linux/dma-buf.h>
 
+#define VB2_MAX_FRAME	(32)
+#define VB2_MAX_PLANES	(8)
+
+enum vb2_memory {
+	VB2_MEMORY_UNKNOWN	= 0,
+	VB2_MEMORY_MMAP		= 1,
+	VB2_MEMORY_USERPTR	= 2,
+	VB2_MEMORY_DMABUF	= 4,
+};
+
 struct vb2_alloc_ctx;
 struct vb2_fileio_data;
 struct vb2_threadio_data;
@@ -208,7 +218,7 @@ struct vb2_buffer {
 	unsigned int		type;
 	unsigned int		memory;
 	unsigned int		num_planes;
-	struct vb2_plane	planes[VIDEO_MAX_PLANES];
+	struct vb2_plane	planes[VB2_MAX_PLANES];
 
 	/* Private: internal use only */
 	enum vb2_buffer_state	state;
@@ -345,12 +355,13 @@ struct vb2_ops {
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
 
-struct v4l2_fh;
 
 /**
  * struct vb2_queue - a videobuf queue
  *
- * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
+ * @type:	private buffer type whose content is defined by the vb2-core
+ *		caller. For example, for V4L2, it should match
+ *		the V4L2_BUF_TYPE_* in include/uapi/linux/videodev2.h
  * @io_modes:	supported io methods (see vb2_io_modes enum)
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
@@ -407,14 +418,14 @@ struct v4l2_fh;
  * @threadio:	thread io internal data, used only if thread is active
  */
 struct vb2_queue {
-	enum v4l2_buf_type		type;
+	unsigned int			type;
 	unsigned int			io_modes;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
 
 	struct mutex			*lock;
-	struct v4l2_fh			*owner;
+	void				*owner;
 
 	const struct vb2_ops		*ops;
 	const struct vb2_mem_ops	*mem_ops;
@@ -426,8 +437,8 @@ struct vb2_queue {
 
 	/* private: internal use only */
 	struct mutex			mmap_lock;
-	enum v4l2_memory		memory;
-	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
+	unsigned int			memory;
+	struct vb2_buffer		*bufs[VB2_MAX_FRAME];
 	unsigned int			num_buffers;
 
 	struct list_head		queued_list;
@@ -438,8 +449,8 @@ struct vb2_queue {
 	spinlock_t			done_lock;
 	wait_queue_head_t		done_wq;
 
-	void				*alloc_ctx[VIDEO_MAX_PLANES];
-	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
+	void				*alloc_ctx[VB2_MAX_PLANES];
+	unsigned int			plane_sizes[VB2_MAX_PLANES];
 
 	unsigned int			streaming:1;
 	unsigned int			start_streaming_called:1;
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index b015b38..b3616ab 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -5,6 +5,7 @@
 #define _TRACE_V4L2_H
 
 #include <linux/tracepoint.h>
+#include <media/videobuf2-v4l2.h>
 
 /* Enums require being exported to userspace, for user tool parsing */
 #undef EM
@@ -203,7 +204,9 @@ DECLARE_EVENT_CLASS(vb2_event_class,
 
 	TP_fast_assign(
 		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-		__entry->minor = q->owner ? q->owner->vdev->minor : -1;
+		struct v4l2_fh *owner = (struct v4l2_fh *) q->owner;
+
+		__entry->minor = owner ? owner->vdev->minor : -1;
 		__entry->queued_count = q->queued_count;
 		__entry->owned_by_drv_count =
 			atomic_read(&q->owned_by_drv_count);
-- 
1.7.9.5

