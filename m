Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:37436 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732763AbeHNRIO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 13:08:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv18 17/35] videobuf2-v4l2: move __fill_v4l2_buffer() function
Date: Tue, 14 Aug 2018 16:20:29 +0200
Message-Id: <20180814142047.93856-18-hverkuil@xs4all.nl>
In-Reply-To: <20180814142047.93856-1-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Move the __fill_v4l2_buffer() to before the vb2_queue_or_prepare_buf()
function to prepare for the next two patches.

No other changes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/common/videobuf2/videobuf2-v4l2.c   | 264 +++++++++---------
 1 file changed, 132 insertions(+), 132 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 886a2d8d5c6c..408fd7ce9c09 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -154,138 +154,6 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
 		pr_warn("use the actual size instead.\n");
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
-/*
- * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
- * returned to userspace
- */
-static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
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
-	b->timestamp = ns_to_timeval(vb->timestamp);
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
-	if (!q->copy_timestamp) {
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
-	if (!q->is_output &&
-		b->flags & V4L2_BUF_FLAG_DONE &&
-		b->flags & V4L2_BUF_FLAG_LAST)
-		q->last_buffer_dequeued = true;
-}
-
 /*
  * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
  * v4l2_buffer by the userspace. It also verifies that struct
@@ -441,6 +309,138 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 	return 0;
 }
 
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
+/*
+ * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
+ * returned to userspace
+ */
+static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
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
+	b->timestamp = ns_to_timeval(vb->timestamp);
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
+	if (!q->copy_timestamp) {
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
+	if (!q->is_output &&
+		b->flags & V4L2_BUF_FLAG_DONE &&
+		b->flags & V4L2_BUF_FLAG_LAST)
+		q->last_buffer_dequeued = true;
+}
+
 static const struct vb2_buf_ops v4l2_buf_ops = {
 	.verify_planes_array	= __verify_planes_array_core,
 	.fill_user_buffer	= __fill_v4l2_buffer,
-- 
2.18.0
