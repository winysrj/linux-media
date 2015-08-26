Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:44682 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450AbbHZL7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 07:59:39 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NTO01B6LUNB62A0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Aug 2015 20:59:35 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	jh1009.sung@samsung.com, rany.kwon@samsung.com
Subject: [RFC PATCH v3 2/5] media: videobuf2: Restructure vb2_buffer
Date: Wed, 26 Aug 2015 20:59:29 +0900
Message-id: <1440590372-2377-3-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com>
References: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove v4l2-specific stuff from struct vb2_buffer and add member variables
related with buffer management.

struct vb2_plane {
        <snip>
        /* plane information */
        unsigned int            bytesused;
        unsigned int            length;
        union {
                unsigned int    offset;
                unsigned long   userptr;
                int             fd;
        } m;
        unsigned int            data_offset;
}

struct vb2_buffer {
        <snip>
        /* buffer information */
        unsigned int            num_planes;
        unsigned int            index;
        unsigned int            type;
        unsigned int            memory;

        struct vb2_plane        planes[VIDEO_MAX_PLANES];
        <snip>
};

And create struct vb2_v4l2_buffer as container buffer for v4l2 use.

struct vb2_v4l2_buffer {
        struct vb2_buffer       vb2_buf;

        __u32                   flags;
        __u32                   field;
        struct timeval          timestamp;
        struct v4l2_timecode    timecode;
        __u32                   sequence;
};

This patch includes only changes inside of videobuf2. So, it is required to
modify all device drivers which use videobuf2.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |  324 +++++++++++++++++-------------
 include/media/videobuf2-core.h           |   50 ++---
 include/media/videobuf2-v4l2.h           |   26 +++
 3 files changed, 236 insertions(+), 164 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index ab00ea0..9266d50 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -35,10 +35,10 @@
 static int debug;
 module_param(debug, int, 0644);
 
-#define dprintk(level, fmt, arg...)					      \
-	do {								      \
-		if (debug >= level)					      \
-			pr_info("vb2: %s: " fmt, __func__, ## arg); \
+#define dprintk(level, fmt, arg...)					\
+	do {								\
+		if (debug >= level)					\
+			pr_info("vb2: %s: " fmt, __func__, ## arg);	\
 	} while (0)
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -53,7 +53,7 @@ module_param(debug, int, 0644);
 
 #define log_memop(vb, op)						\
 	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
+		(vb)->vb2_queue, (vb)->index, #op,			\
 		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
 
 #define call_memop(vb, op, args...)					\
@@ -115,7 +115,7 @@ module_param(debug, int, 0644);
 
 #define log_vb_qop(vb, op, args...)					\
 	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
+		(vb)->vb2_queue, (vb)->index, #op,			\
 		(vb)->vb2_queue->ops->op ? "" : " (nop)")
 
 #define call_vb_qop(vb, op, args...)					\
@@ -205,13 +205,13 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
 
 		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
-				      size, dma_dir, q->gfp_flags);
+					size, dma_dir, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
 		/* Associate allocator private data with this plane */
 		vb->planes[plane].mem_priv = mem_priv;
-		vb->v4l2_planes[plane].length = q->plane_sizes[plane];
+		vb->planes[plane].length = q->plane_sizes[plane];
 	}
 
 	return 0;
@@ -235,8 +235,7 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		call_void_memop(vb, put, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
-		dprintk(3, "freed plane %d of buffer %d\n", plane,
-			vb->v4l2_buf.index);
+		dprintk(3, "freed plane %d of buffer %d\n", plane, vb->index);
 	}
 }
 
@@ -269,7 +268,9 @@ static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
 
 	call_void_memop(vb, detach_dmabuf, p->mem_priv);
 	dma_buf_put(p->dbuf);
-	memset(p, 0, sizeof(*p));
+	p->mem_priv = NULL;
+	p->dbuf = NULL;
+	p->dbuf_mapped = 0;
 }
 
 /**
@@ -299,7 +300,7 @@ static void __setup_lengths(struct vb2_queue *q, unsigned int n)
 			continue;
 
 		for (plane = 0; plane < vb->num_planes; ++plane)
-			vb->v4l2_planes[plane].length = q->plane_sizes[plane];
+			vb->planes[plane].length = q->plane_sizes[plane];
 	}
 }
 
@@ -314,10 +315,10 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 	unsigned long off;
 
 	if (q->num_buffers) {
-		struct v4l2_plane *p;
+		struct vb2_plane *p;
 		vb = q->bufs[q->num_buffers - 1];
-		p = &vb->v4l2_planes[vb->num_planes - 1];
-		off = PAGE_ALIGN(p->m.mem_offset + p->length);
+		p = &vb->planes[vb->num_planes - 1];
+		off = PAGE_ALIGN(p->m.offset + p->length);
 	} else {
 		off = 0;
 	}
@@ -328,12 +329,12 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 			continue;
 
 		for (plane = 0; plane < vb->num_planes; ++plane) {
-			vb->v4l2_planes[plane].m.mem_offset = off;
+			vb->planes[plane].m.offset = off;
 
 			dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
 					buffer, plane, off);
 
-			off += vb->v4l2_planes[plane].length;
+			off += vb->planes[plane].length;
 			off = PAGE_ALIGN(off);
 		}
 	}
@@ -347,7 +348,7 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
  * Returns the number of buffers successfully allocated.
  */
 static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
-			     unsigned int num_buffers, unsigned int num_planes)
+			unsigned int num_buffers, unsigned int num_planes)
 {
 	unsigned int buffer;
 	struct vb2_buffer *vb;
@@ -361,16 +362,12 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 			break;
 		}
 
-		/* Length stores number of planes for multiplanar buffers */
-		if (V4L2_TYPE_IS_MULTIPLANAR(q->type))
-			vb->v4l2_buf.length = num_planes;
-
 		vb->state = VB2_BUF_STATE_DEQUEUED;
 		vb->vb2_queue = q;
 		vb->num_planes = num_planes;
-		vb->v4l2_buf.index = q->num_buffers + buffer;
-		vb->v4l2_buf.type = q->type;
-		vb->v4l2_buf.memory = memory;
+		vb->index = q->num_buffers + buffer;
+		vb->type = q->type;
+		vb->memory = memory;
 
 		/* Allocate video buffer memory for the MMAP type */
 		if (memory == V4L2_MEMORY_MMAP) {
@@ -418,7 +415,7 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
 	struct vb2_buffer *vb;
 
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
+			++buffer) {
 		vb = q->bufs[buffer];
 		if (!vb)
 			continue;
@@ -451,7 +448,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	 * just return -EAGAIN.
 	 */
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
+			++buffer) {
 		if (q->bufs[buffer] == NULL)
 			continue;
 		if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
@@ -462,7 +459,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 
 	/* Call driver-provided cleanup function for each buffer, if provided */
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
+			++buffer) {
 		struct vb2_buffer *vb = q->bufs[buffer];
 
 		if (vb && vb->planes[0].mem_priv)
@@ -536,7 +533,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 
 	/* Free videobuf buffers */
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
+			++buffer) {
 		kfree(q->bufs[buffer]);
 		q->bufs[buffer] = NULL;
 	}
@@ -590,23 +587,22 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		for (plane = 0; plane < vb->num_planes; ++plane) {
 			length = (b->memory == V4L2_MEMORY_USERPTR ||
-				  b->memory == V4L2_MEMORY_DMABUF)
-			       ? b->m.planes[plane].length
-			       : vb->v4l2_planes[plane].length;
+				b->memory == V4L2_MEMORY_DMABUF)
+				? b->m.planes[plane].length
+				: vb->planes[plane].length;
 			bytesused = b->m.planes[plane].bytesused
-				  ? b->m.planes[plane].bytesused : length;
+				? b->m.planes[plane].bytesused : length;
 
 			if (b->m.planes[plane].bytesused > length)
 				return -EINVAL;
 
 			if (b->m.planes[plane].data_offset > 0 &&
-			    b->m.planes[plane].data_offset >= bytesused)
+				b->m.planes[plane].data_offset >= bytesused)
 				return -EINVAL;
 		}
 	} else {
 		length = (b->memory == V4L2_MEMORY_USERPTR)
-		       ? b->length : vb->v4l2_planes[0].length;
-		bytesused = b->bytesused ? b->bytesused : length;
+			? b->length : vb->planes[0].length;
 
 		if (b->bytesused > length)
 			return -EINVAL;
@@ -656,12 +652,21 @@ static bool __buffers_in_use(struct vb2_queue *q)
  */
 static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
 
 	/* Copy back data such as timestamp, flags, etc. */
-	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
-	b->reserved2 = vb->v4l2_buf.reserved2;
-	b->reserved = vb->v4l2_buf.reserved;
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
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
 		/*
@@ -669,21 +674,33 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		 * for it. The caller has already verified memory and size.
 		 */
 		b->length = vb->num_planes;
-		memcpy(b->m.planes, vb->v4l2_planes,
-			b->length * sizeof(struct v4l2_plane));
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			struct v4l2_plane *pdst = &b->m.planes[plane];
+			struct vb2_plane *psrc = &vb->planes[plane];
+
+			pdst->bytesused = psrc->bytesused;
+			pdst->length = psrc->length;
+			if (q->memory == V4L2_MEMORY_MMAP)
+				pdst->m.mem_offset = psrc->m.offset;
+			else if (q->memory == V4L2_MEMORY_USERPTR)
+				pdst->m.userptr = psrc->m.userptr;
+			else if (q->memory == V4L2_MEMORY_DMABUF)
+				pdst->m.fd = psrc->m.fd;
+			pdst->data_offset = psrc->data_offset;
+		}
 	} else {
 		/*
 		 * We use length and offset in v4l2_planes array even for
 		 * single-planar buffers, but userspace does not.
 		 */
-		b->length = vb->v4l2_planes[0].length;
-		b->bytesused = vb->v4l2_planes[0].bytesused;
+		b->length = vb->planes[0].length;
+		b->bytesused = vb->planes[0].bytesused;
 		if (q->memory == V4L2_MEMORY_MMAP)
-			b->m.offset = vb->v4l2_planes[0].m.mem_offset;
+			b->m.offset = vb->planes[0].m.offset;
 		else if (q->memory == V4L2_MEMORY_USERPTR)
-			b->m.userptr = vb->v4l2_planes[0].m.userptr;
+			b->m.userptr = vb->planes[0].m.userptr;
 		else if (q->memory == V4L2_MEMORY_DMABUF)
-			b->m.fd = vb->v4l2_planes[0].m.fd;
+			b->m.fd = vb->planes[0].m.fd;
 	}
 
 	/*
@@ -692,7 +709,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
 	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
 	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
+			V4L2_BUF_FLAG_TIMESTAMP_COPY) {
 		/*
 		 * For non-COPY timestamps, drop timestamp source bits
 		 * and obtain the timestamp source from the queue.
@@ -767,7 +784,7 @@ EXPORT_SYMBOL(vb2_querybuf);
 static int __verify_userptr_ops(struct vb2_queue *q)
 {
 	if (!(q->io_modes & VB2_USERPTR) || !q->mem_ops->get_userptr ||
-	    !q->mem_ops->put_userptr)
+			!q->mem_ops->put_userptr)
 		return -EINVAL;
 
 	return 0;
@@ -780,7 +797,7 @@ static int __verify_userptr_ops(struct vb2_queue *q)
 static int __verify_mmap_ops(struct vb2_queue *q)
 {
 	if (!(q->io_modes & VB2_MMAP) || !q->mem_ops->alloc ||
-	    !q->mem_ops->put || !q->mem_ops->mmap)
+			!q->mem_ops->put || !q->mem_ops->mmap)
 		return -EINVAL;
 
 	return 0;
@@ -793,8 +810,8 @@ static int __verify_mmap_ops(struct vb2_queue *q)
 static int __verify_dmabuf_ops(struct vb2_queue *q)
 {
 	if (!(q->io_modes & VB2_DMABUF) || !q->mem_ops->attach_dmabuf ||
-	    !q->mem_ops->detach_dmabuf  || !q->mem_ops->map_dmabuf ||
-	    !q->mem_ops->unmap_dmabuf)
+		!q->mem_ops->detach_dmabuf  || !q->mem_ops->map_dmabuf ||
+		!q->mem_ops->unmap_dmabuf)
 		return -EINVAL;
 
 	return 0;
@@ -808,7 +825,7 @@ static int __verify_memory_type(struct vb2_queue *q,
 		enum v4l2_memory memory, enum v4l2_buf_type type)
 {
 	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR &&
-	    memory != V4L2_MEMORY_DMABUF) {
+			memory != V4L2_MEMORY_DMABUF) {
 		dprintk(1, "unsupported memory type\n");
 		return -EINVAL;
 	}
@@ -927,7 +944,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * Driver also sets the size and allocator context for each plane.
 	 */
 	ret = call_qop(q, queue_setup, q, NULL, &num_buffers, &num_planes,
-		       q->plane_sizes, q->alloc_ctx);
+			q->plane_sizes, q->alloc_ctx);
 	if (ret)
 		return ret;
 
@@ -952,7 +969,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		num_buffers = allocated_buffers;
 
 		ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
-			       &num_planes, q->plane_sizes, q->alloc_ctx);
+				&num_planes, q->plane_sizes, q->alloc_ctx);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
@@ -1040,7 +1057,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	 * buffer and their sizes are acceptable
 	 */
 	ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
-		       &num_planes, q->plane_sizes, q->alloc_ctx);
+			&num_planes, q->plane_sizes, q->alloc_ctx);
 	if (ret)
 		return ret;
 
@@ -1063,7 +1080,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 		 * queue driver has set up
 		 */
 		ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
-			       &num_planes, q->plane_sizes, q->alloc_ctx);
+				&num_planes, q->plane_sizes, q->alloc_ctx);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
@@ -1183,8 +1200,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 		return;
 
 	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
-		    state != VB2_BUF_STATE_ERROR &&
-		    state != VB2_BUF_STATE_QUEUED))
+		state != VB2_BUF_STATE_ERROR &&
+		state != VB2_BUF_STATE_QUEUED))
 		state = VB2_BUF_STATE_ERROR;
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -1195,7 +1212,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	vb->cnt_buf_done++;
 #endif
 	dprintk(4, "done processing on buffer %d, state: %d\n",
-			vb->v4l2_buf.index, state);
+			vb->index, state);
 
 	/* sync buffers */
 	for (plane = 0; plane < vb->num_planes; ++plane)
@@ -1268,25 +1285,26 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
  * v4l2_buffer by the userspace. The caller has already verified that struct
  * v4l2_buffer has a valid number of planes.
  */
-static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
-				struct v4l2_plane *v4l2_planes)
+static void __fill_vb2_buffer(struct vb2_buffer *vb,
+		const struct v4l2_buffer *b, struct vb2_plane *planes)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	unsigned int plane;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		if (b->memory == V4L2_MEMORY_USERPTR) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
-				v4l2_planes[plane].m.userptr =
+				planes[plane].m.userptr =
 					b->m.planes[plane].m.userptr;
-				v4l2_planes[plane].length =
+				planes[plane].length =
 					b->m.planes[plane].length;
 			}
 		}
 		if (b->memory == V4L2_MEMORY_DMABUF) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
-				v4l2_planes[plane].m.fd =
+				planes[plane].m.fd =
 					b->m.planes[plane].m.fd;
-				v4l2_planes[plane].length =
+				planes[plane].length =
 					b->m.planes[plane].length;
 			}
 		}
@@ -1310,7 +1328,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 			 * applications working.
 			 */
 			for (plane = 0; plane < vb->num_planes; ++plane) {
-				struct v4l2_plane *pdst = &v4l2_planes[plane];
+				struct vb2_plane *pdst = &planes[plane];
 				struct v4l2_plane *psrc = &b->m.planes[plane];
 
 				if (psrc->bytesused == 0)
@@ -1340,13 +1358,13 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		 * old userspace applications working.
 		 */
 		if (b->memory == V4L2_MEMORY_USERPTR) {
-			v4l2_planes[0].m.userptr = b->m.userptr;
-			v4l2_planes[0].length = b->length;
+			planes[0].m.userptr = b->m.userptr;
+			planes[0].length = b->length;
 		}
 
 		if (b->memory == V4L2_MEMORY_DMABUF) {
-			v4l2_planes[0].m.fd = b->m.fd;
-			v4l2_planes[0].length = b->length;
+			planes[0].m.fd = b->m.fd;
+			planes[0].length = b->length;
 		}
 
 		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
@@ -1354,25 +1372,26 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 				vb2_warn_zero_bytesused(vb);
 
 			if (vb->vb2_queue->allow_zero_bytesused)
-				v4l2_planes[0].bytesused = b->bytesused;
+				planes[0].bytesused = b->bytesused;
 			else
-				v4l2_planes[0].bytesused = b->bytesused ?
-					b->bytesused : v4l2_planes[0].length;
+				planes[0].bytesused = b->bytesused ?
+					b->bytesused : planes[0].length;
 		} else
-			v4l2_planes[0].bytesused = 0;
+			planes[0].bytesused = 0;
 
 	}
 
 	/* Zero flags that the vb2 core handles */
-	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
+	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
 	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
+			V4L2_BUF_FLAG_TIMESTAMP_COPY ||
+			!V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
 		 * Non-COPY timestamps and non-OUTPUT queues will get
 		 * their timestamp and timestamp source flags from the
 		 * queue.
 		 */
-		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		vbuf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	}
 
 	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
@@ -1382,11 +1401,11 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		 * The 'field' is valid metadata for this output buffer
 		 * and so that needs to be copied here.
 		 */
-		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TIMECODE;
-		vb->v4l2_buf.field = b->field;
+		vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
+		vbuf->field = b->field;
 	} else {
 		/* Zero any output buffer flags as this is a capture buffer */
-		vb->v4l2_buf.flags &= ~V4L2_BUFFER_OUT_FLAGS;
+		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
 	}
 }
 
@@ -1395,7 +1414,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
  */
 static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
-	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
+	__fill_vb2_buffer(vb, b, vb->planes);
 	return call_vb_qop(vb, buf_prepare, vb);
 }
 
@@ -1404,7 +1423,7 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
  */
 static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
-	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct vb2_plane planes[VIDEO_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
@@ -1419,9 +1438,9 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		/* Skip the plane if already verified */
-		if (vb->v4l2_planes[plane].m.userptr &&
-		    vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
-		    && vb->v4l2_planes[plane].length == planes[plane].length)
+		if (vb->planes[plane].m.userptr &&
+			vb->planes[plane].m.userptr == planes[plane].m.userptr
+			&& vb->planes[plane].length == planes[plane].length)
 			continue;
 
 		dprintk(3, "userspace address for plane %d changed, "
@@ -1447,12 +1466,15 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 
 		vb->planes[plane].mem_priv = NULL;
-		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
+		vb->planes[plane].bytesused = 0;
+		vb->planes[plane].length = 0;
+		vb->planes[plane].m.userptr = 0;
+		vb->planes[plane].data_offset = 0;
 
 		/* Acquire each plane's memory */
 		mem_priv = call_ptr_memop(vb, get_userptr, q->alloc_ctx[plane],
-				      planes[plane].m.userptr,
-				      planes[plane].length, dma_dir);
+					planes[plane].m.userptr,
+					planes[plane].length, dma_dir);
 		if (IS_ERR_OR_NULL(mem_priv)) {
 			dprintk(1, "failed acquiring userspace "
 						"memory for plane %d\n", plane);
@@ -1466,8 +1488,12 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	 * Now that everything is in order, copy relevant information
 	 * provided by userspace.
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		vb->v4l2_planes[plane] = planes[plane];
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		vb->planes[plane].bytesused = planes[plane].bytesused;
+		vb->planes[plane].length = planes[plane].length;
+		vb->planes[plane].m.userptr = planes[plane].m.userptr;
+		vb->planes[plane].data_offset = planes[plane].data_offset;
+	}
 
 	if (reacquired) {
 		/*
@@ -1494,10 +1520,11 @@ err:
 	/* In case of errors, release planes that were already acquired */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		if (vb->planes[plane].mem_priv)
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
+			call_void_memop(vb, put_userptr,
+				vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
-		vb->v4l2_planes[plane].m.userptr = 0;
-		vb->v4l2_planes[plane].length = 0;
+		vb->planes[plane].m.userptr = 0;
+		vb->planes[plane].length = 0;
 	}
 
 	return ret;
@@ -1508,7 +1535,7 @@ err:
  */
 static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
-	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct vb2_plane planes[VIDEO_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
@@ -1544,7 +1571,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		/* Skip the plane if already verified */
 		if (dbuf == vb->planes[plane].dbuf &&
-		    vb->v4l2_planes[plane].length == planes[plane].length) {
+			vb->planes[plane].length == planes[plane].length) {
 			dma_buf_put(dbuf);
 			continue;
 		}
@@ -1558,11 +1585,15 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		/* Release previously acquired memory if present */
 		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
-		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
+		vb->planes[plane].bytesused = 0;
+		vb->planes[plane].length = 0;
+		vb->planes[plane].m.fd = 0;
+		vb->planes[plane].data_offset = 0;
 
 		/* Acquire each plane's memory */
-		mem_priv = call_ptr_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
-			dbuf, planes[plane].length, dma_dir);
+		mem_priv = call_ptr_memop(vb, attach_dmabuf,
+			q->alloc_ctx[plane], dbuf, planes[plane].length,
+			dma_dir);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed to attach dmabuf\n");
 			ret = PTR_ERR(mem_priv);
@@ -1592,8 +1623,12 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	 * Now that everything is in order, copy relevant information
 	 * provided by userspace.
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		vb->v4l2_planes[plane] = planes[plane];
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		vb->planes[plane].bytesused = planes[plane].bytesused;
+		vb->planes[plane].length = planes[plane].length;
+		vb->planes[plane].m.fd = planes[plane].m.userptr;
+		vb->planes[plane].data_offset = planes[plane].data_offset;
+	}
 
 	if (reacquired) {
 		/*
@@ -1644,6 +1679,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 
 static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
 	int ret;
 
@@ -1672,9 +1708,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	}
 
 	vb->state = VB2_BUF_STATE_PREPARING;
-	vb->v4l2_buf.timestamp.tv_sec = 0;
-	vb->v4l2_buf.timestamp.tv_usec = 0;
-	vb->v4l2_buf.sequence = 0;
+	vbuf->timestamp.tv_sec = 0;
+	vbuf->timestamp.tv_usec = 0;
+	vbuf->sequence = 0;
 
 	switch (q->memory) {
 	case V4L2_MEMORY_MMAP:
@@ -1701,7 +1737,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 }
 
 static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
-				    const char *opname)
+					const char *opname)
 {
 	if (b->type != q->type) {
 		dprintk(1, "%s: invalid buffer type\n", opname);
@@ -1768,7 +1804,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 		/* Fill buffer information for the userspace */
 		__fill_v4l2_buffer(vb, b);
 
-		dprintk(1, "prepare of buffer %d succeeded\n", vb->v4l2_buf.index);
+		dprintk(1, "prepare of buffer %d succeeded\n", vb->index);
 	}
 	return ret;
 }
@@ -1800,7 +1836,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	/* Tell the driver to start streaming */
 	q->start_streaming_called = 1;
 	ret = call_qop(q, start_streaming, q,
-		       atomic_read(&q->owned_by_drv_count));
+			atomic_read(&q->owned_by_drv_count));
 	if (!ret)
 		return 0;
 
@@ -1810,7 +1846,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	/*
 	 * If you see this warning, then the driver isn't cleaning up properly
 	 * after a failed start_streaming(). See the start_streaming()
-	 * documentation in videobuf2-v4l2.h for more information how buffers
+	 * documentation in videobuf2-core.h for more information how buffers
 	 * should be returned to vb2 in start_streaming().
 	 */
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
@@ -1841,11 +1877,13 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
 	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 
 	if (ret)
 		return ret;
 
 	vb = q->bufs[b->index];
+	vbuf = to_vb2_v4l2_buffer(vb);
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DEQUEUED:
@@ -1877,11 +1915,11 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		 * and the timecode field and flag if needed.
 		 */
 		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-		    V4L2_BUF_FLAG_TIMESTAMP_COPY)
-			vb->v4l2_buf.timestamp = b->timestamp;
-		vb->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
+				V4L2_BUF_FLAG_TIMESTAMP_COPY)
+			vbuf->timestamp = b->timestamp;
+		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
 		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
-			vb->v4l2_buf.timecode = b->timecode;
+			vbuf->timecode = b->timecode;
 	}
 
 	trace_vb2_qbuf(q, vb);
@@ -1903,13 +1941,13 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 * then we can finally call start_streaming().
 	 */
 	if (q->streaming && !q->start_streaming_called &&
-	    q->queued_count >= q->min_buffers_needed) {
+			q->queued_count >= q->min_buffers_needed) {
 		ret = vb2_start_streaming(q);
 		if (ret)
 			return ret;
 	}
 
-	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
+	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
 	return 0;
 }
 
@@ -2099,9 +2137,11 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 		}
 }
 
-static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
+		bool nonblocking)
 {
 	struct vb2_buffer *vb = NULL;
+	struct vb2_v4l2_buffer *vbuf = NULL;
 	int ret;
 
 	if (b->type != q->type) {
@@ -2134,14 +2174,15 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 
 	trace_vb2_dqbuf(q, vb);
 
+	vbuf = to_vb2_v4l2_buffer(vb);
 	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
-	    vb->v4l2_buf.flags & V4L2_BUF_FLAG_LAST)
+			vbuf->flags & V4L2_BUF_FLAG_LAST)
 		q->last_buffer_dequeued = true;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
 	dprintk(1, "dqbuf of buffer %d, with state %d\n",
-			vb->v4l2_buf.index, vb->state);
+			vb->index, vb->state);
 
 	return 0;
 }
@@ -2197,7 +2238,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	/*
 	 * If you see this warning, then the driver isn't cleaning up properly
 	 * in stop_streaming(). See the stop_streaming() documentation in
-	 * videobuf2-v4l2.h for more information how buffers should be returned
+	 * videobuf2-core.h for more information how buffers should be returned
 	 * to vb2 in stop_streaming().
 	 */
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
@@ -2399,7 +2440,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 		vb = q->bufs[buffer];
 
 		for (plane = 0; plane < vb->num_planes; ++plane) {
-			if (vb->v4l2_planes[plane].m.mem_offset == off) {
+			if (vb->planes[plane].m.offset == off) {
 				*_buffer = buffer;
 				*_plane = plane;
 				return 0;
@@ -2557,7 +2598,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	 * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
 	 * so, we need to do the same here.
 	 */
-	length = PAGE_ALIGN(vb->v4l2_planes[plane].length);
+	length = PAGE_ALIGN(vb->planes[plane].length);
 	if (length < (vma->vm_end - vma->vm_start)) {
 		dprintk(1,
 			"MMAP invalid, as it would overflow buffer length\n");
@@ -2577,10 +2618,10 @@ EXPORT_SYMBOL_GPL(vb2_mmap);
 
 #ifndef CONFIG_MMU
 unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
-				    unsigned long addr,
-				    unsigned long len,
-				    unsigned long pgoff,
-				    unsigned long flags)
+					unsigned long addr,
+					unsigned long len,
+					unsigned long pgoff,
+					unsigned long flags)
 {
 	unsigned long off = pgoff << PAGE_SHIFT;
 	struct vb2_buffer *vb;
@@ -2731,7 +2772,7 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  * responsible of clearing it's content and setting initial values for some
  * required entries before calling this function.
  * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
- * to the struct vb2_queue description in include/media/videobuf2-v4l2.h
+ * to the struct vb2_queue description in include/media/videobuf2-core.h
  * for more information.
  */
 int vb2_queue_init(struct vb2_queue *q)
@@ -2739,16 +2780,16 @@ int vb2_queue_init(struct vb2_queue *q)
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
-		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
-		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
+	if (WARN_ON(!q)				||
+		WARN_ON(!q->ops)		||
+		WARN_ON(!q->mem_ops)		||
+		WARN_ON(!q->type)		||
+		WARN_ON(!q->io_modes)		||
+		WARN_ON(!q->ops->queue_setup)	||
+		WARN_ON(!q->ops->buf_queue)	||
+		WARN_ON(q->timestamp_flags &
+			~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
+			V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
 		return -EINVAL;
 
 	/* Warn that the driver should choose an appropriate timestamp type */
@@ -2852,7 +2893,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Sanity check
 	 */
 	if (WARN_ON((read && !(q->io_modes & VB2_READ)) ||
-		    (!read && !(q->io_modes & VB2_WRITE))))
+			(!read && !(q->io_modes & VB2_WRITE))))
 		return -EINVAL;
 
 	/*
@@ -3063,9 +3104,12 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		buf->queued = 0;
 		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
 				 : vb2_plane_size(q->bufs[index], 0);
-		/* Compensate for data_offset on read in the multiplanar case. */
+		/*
+		 * Compensate for data_offset on read
+		 * in the multiplanar case
+		 */
 		if (is_multiplanar && read &&
-		    fileio->b.m.planes[0].data_offset < buf->size) {
+			fileio->b.m.planes[0].data_offset < buf->size) {
 			buf->pos = fileio->b.m.planes[0].data_offset;
 			buf->size -= buf->pos;
 		}
@@ -3257,7 +3301,7 @@ static int vb2_thread(void *data)
  * contact the linux-media mailinglist first.
  */
 int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
-		     const char *thread_name)
+			const char *thread_name)
 {
 	struct vb2_threadio_data *threadio;
 	int ret = 0;
@@ -3491,7 +3535,7 @@ ssize_t vb2_fop_write(struct file *file, const char __user *buf,
 	if (vb2_queue_is_busy(vdev, file))
 		goto exit;
 	err = vb2_write(vdev->queue, buf, count, ppos,
-		       file->f_flags & O_NONBLOCK);
+			file->f_flags & O_NONBLOCK);
 	if (vdev->queue->fileio)
 		vdev->queue->owner = file->private_data;
 exit:
@@ -3515,7 +3559,7 @@ ssize_t vb2_fop_read(struct file *file, char __user *buf,
 	if (vb2_queue_is_busy(vdev, file))
 		goto exit;
 	err = vb2_read(vdev->queue, buf, count, ppos,
-		       file->f_flags & O_NONBLOCK);
+			file->f_flags & O_NONBLOCK);
 	if (vdev->queue->fileio)
 		vdev->queue->owner = file->private_data;
 exit:
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 155991e..8787a6c 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -115,6 +115,16 @@ struct vb2_plane {
 	void			*mem_priv;
 	struct dma_buf		*dbuf;
 	unsigned int		dbuf_mapped;
+
+	/* plane information */
+	unsigned int		bytesused;
+	unsigned int		length;
+	union {
+		unsigned int	offset;
+		unsigned long	userptr;
+		int		fd;
+	} m;
+	unsigned int		data_offset;
 };
 
 /**
@@ -161,41 +171,33 @@ struct vb2_queue;
 
 /**
  * struct vb2_buffer - represents a video buffer
- * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
- *			be read by the driver and relevant entries can be
- *			changed by the driver in case of CAPTURE types
- *			(such as timestamp)
- * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
- *			be read by the driver and relevant entries can be
- *			changed by the driver in case of CAPTURE types
- *			(such as bytesused); NOTE that even for single-planar
- *			types, the v4l2_planes[0] struct should be used
- *			instead of v4l2_buf for filling bytesused - drivers
- *			should use the vb2_set_plane_payload() function for that
  * @vb2_queue:		the queue to which this driver belongs
- * @num_planes:		number of planes in the buffer
- *			on an internal driver queue
  * @state:		current buffer state; do not change
  * @queued_entry:	entry on the queued buffers list, which holds all
  *			buffers queued from userspace
  * @done_entry:		entry on the list that stores all buffers ready to
  *			be dequeued to userspace
+ * @index:		id number of the buffer
+ * @type:		buffer type
+ * @memory:		the method, in which the actual data is passed
+ * @num_planes:		number of planes in the buffer
+ *			on an internal driver queue
  * @planes:		private per-plane information; do not change
  */
 struct vb2_buffer {
-	struct v4l2_buffer	v4l2_buf;
-	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
-
 	struct vb2_queue	*vb2_queue;
 
-	unsigned int		num_planes;
-
-/* Private: internal use only */
+	/* Private: internal use only */
 	enum vb2_buffer_state	state;
 
 	struct list_head	queued_entry;
 	struct list_head	done_entry;
 
+	/* buffer information */
+	unsigned int		index;
+	unsigned int		type;
+	unsigned int		memory;
+	unsigned int		num_planes;
 	struct vb2_plane	planes[VIDEO_MAX_PLANES];
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -390,7 +392,7 @@ struct v4l2_fh;
  * @threadio:	thread io internal data, used only if thread is active
  */
 struct vb2_queue {
-	enum v4l2_buf_type		type;
+	unsigned int			type;
 	unsigned int			io_modes;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
@@ -409,7 +411,7 @@ struct vb2_queue {
 
 	/* private: internal use only */
 	struct mutex			mmap_lock;
-	enum v4l2_memory		memory;
+	unsigned int			memory;
 	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
 	unsigned int			num_buffers;
 
@@ -571,7 +573,7 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no, unsigned long size)
 {
 	if (plane_no < vb->num_planes)
-		vb->v4l2_planes[plane_no].bytesused = size;
+		vb->planes[plane_no].bytesused = size;
 }
 
 /**
@@ -583,7 +585,7 @@ static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no)
 {
 	if (plane_no < vb->num_planes)
-		return vb->v4l2_planes[plane_no].bytesused;
+		return vb->planes[plane_no].bytesused;
 	return 0;
 }
 
@@ -596,7 +598,7 @@ static inline unsigned long
 vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	if (plane_no < vb->num_planes)
-		return vb->v4l2_planes[plane_no].length;
+		return vb->planes[plane_no].length;
 	return 0;
 }
 
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index d4a4d9a..fc2dbe9 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -12,6 +12,32 @@
 #ifndef _MEDIA_VIDEOBUF2_V4L2_H
 #define _MEDIA_VIDEOBUF2_V4L2_H
 
+#include <linux/videodev2.h>
 #include <media/videobuf2-core.h>
 
+/**
+ * struct vb2_v4l2_buffer - video buffer information for v4l2
+ * @vb2_buf:	video buffer 2
+ * @flags:	buffer informational flags
+ * @field:	enum v4l2_field; field order of the image in the buffer
+ * @timestamp:	frame timestamp
+ * @timecode:	frame timecode
+ * @sequence:	sequence count of this frame
+ */
+struct vb2_v4l2_buffer {
+	struct vb2_buffer	vb2_buf;
+
+	__u32			flags;
+	__u32			field;
+	struct timeval		timestamp;
+	struct v4l2_timecode	timecode;
+	__u32			sequence;
+};
+
+/**
+ * to_vb2_v4l2_buffer() - cast struct vb2_buffer * to struct vb2_v4l2_buffer *
+ */
+#define to_vb2_v4l2_buffer(vb) \
+	(container_of(vb, struct vb2_v4l2_buffer, vb2_buf))
+
 #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
-- 
1.7.9.5

