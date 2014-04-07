Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2724 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbaDGNLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 09:11:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 12/13] vb2: start messages with a lower-case for consistency.
Date: Mon,  7 Apr 2014 15:11:11 +0200
Message-Id: <1396876272-18222-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl>
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The kernel debug messages produced by vb2 started either with a
lower or an upper case character. Switched all to use lower-case
which seemed to be what was used in the majority of the messages.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 58 ++++++++++++++++----------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index d33c69b..e79d70c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -151,7 +151,7 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		call_memop(vb, put, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
-		dprintk(3, "Freed plane %d of buffer %d\n", plane,
+		dprintk(3, "freed plane %d of buffer %d\n", plane,
 			vb->v4l2_buf.index);
 	}
 }
@@ -246,7 +246,7 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 		for (plane = 0; plane < vb->num_planes; ++plane) {
 			vb->v4l2_planes[plane].m.mem_offset = off;
 
-			dprintk(3, "Buffer %d, plane %d offset 0x%08lx\n",
+			dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
 					buffer, plane, off);
 
 			off += vb->v4l2_planes[plane].length;
@@ -273,7 +273,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 		/* Allocate videobuf buffer structures */
 		vb = kzalloc(q->buf_struct_size, GFP_KERNEL);
 		if (!vb) {
-			dprintk(1, "Memory alloc for buffer struct failed\n");
+			dprintk(1, "memory alloc for buffer struct failed\n");
 			break;
 		}
 
@@ -292,7 +292,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 		if (memory == V4L2_MEMORY_MMAP) {
 			ret = __vb2_buf_mem_alloc(vb);
 			if (ret) {
-				dprintk(1, "Failed allocating memory for "
+				dprintk(1, "failed allocating memory for "
 						"buffer %d\n", buffer);
 				kfree(vb);
 				break;
@@ -304,7 +304,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 			 */
 			ret = call_vb_qop(vb, buf_init, vb);
 			if (ret) {
-				dprintk(1, "Buffer %d %p initialization"
+				dprintk(1, "buffer %d %p initialization"
 					" failed\n", buffer, vb);
 				fail_vb_qop(vb, buf_init);
 				__vb2_buf_mem_free(vb);
@@ -320,7 +320,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 	if (memory == V4L2_MEMORY_MMAP)
 		__setup_offsets(q, buffer);
 
-	dprintk(1, "Allocated %d buffers, %d plane(s) each\n",
+	dprintk(1, "allocated %d buffers, %d plane(s) each\n",
 			buffer, num_planes);
 
 	return buffer;
@@ -477,13 +477,13 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 
 	/* Is memory for copying plane information present? */
 	if (NULL == b->m.planes) {
-		dprintk(1, "Multi-planar buffer passed but "
+		dprintk(1, "multi-planar buffer passed but "
 			   "planes array not provided\n");
 		return -EINVAL;
 	}
 
 	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
-		dprintk(1, "Incorrect planes array length, "
+		dprintk(1, "incorrect planes array length, "
 			   "expected %d, got %d\n", vb->num_planes, b->length);
 		return -EINVAL;
 	}
@@ -847,7 +847,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
 	if (allocated_buffers == 0) {
-		dprintk(1, "Memory allocation failed\n");
+		dprintk(1, "memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -960,7 +960,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	allocated_buffers = __vb2_queue_alloc(q, create->memory, num_buffers,
 				num_planes);
 	if (allocated_buffers == 0) {
-		dprintk(1, "Memory allocation failed\n");
+		dprintk(1, "memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -1107,7 +1107,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	 */
 	vb->cnt_buf_done++;
 #endif
-	dprintk(4, "Done processing on buffer %d, state: %d\n",
+	dprintk(4, "done processing on buffer %d, state: %d\n",
 			vb->v4l2_buf.index, state);
 
 	/* sync buffers */
@@ -1817,7 +1817,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		int ret;
 
 		if (!q->streaming) {
-			dprintk(1, "Streaming off, will not wait for buffers\n");
+			dprintk(1, "streaming off, will not wait for buffers\n");
 			return -EINVAL;
 		}
 
@@ -1829,7 +1829,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		}
 
 		if (nonblocking) {
-			dprintk(1, "Nonblocking and no buffers to dequeue, "
+			dprintk(1, "nonblocking and no buffers to dequeue, "
 								"will not wait\n");
 			return -EAGAIN;
 		}
@@ -1844,7 +1844,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		/*
 		 * All locks have been released, it is safe to sleep now.
 		 */
-		dprintk(3, "Will sleep waiting for buffers\n");
+		dprintk(3, "will sleep waiting for buffers\n");
 		ret = wait_event_interruptible(q->done_wq,
 				!list_empty(&q->done_list) || !q->streaming);
 
@@ -1854,7 +1854,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		 */
 		call_qop(q, wait_finish, q);
 		if (ret) {
-			dprintk(1, "Sleep was interrupted\n");
+			dprintk(1, "sleep was interrupted\n");
 			return ret;
 		}
 	}
@@ -1909,7 +1909,7 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
 int vb2_wait_for_all_buffers(struct vb2_queue *q)
 {
 	if (!q->streaming) {
-		dprintk(1, "Streaming off, will not wait for buffers\n");
+		dprintk(1, "streaming off, will not wait for buffers\n");
 		return -EINVAL;
 	}
 
@@ -1958,13 +1958,13 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DONE:
-		dprintk(3, "Returning done buffer\n");
+		dprintk(3, "returning done buffer\n");
 		break;
 	case VB2_BUF_STATE_ERROR:
-		dprintk(3, "Returning done buffer with errors\n");
+		dprintk(3, "returning done buffer with errors\n");
 		break;
 	default:
-		dprintk(1, "Invalid buffer state\n");
+		dprintk(1, "invalid buffer state\n");
 		return -EINVAL;
 	}
 
@@ -2238,17 +2238,17 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 	struct dma_buf *dbuf;
 
 	if (q->memory != V4L2_MEMORY_MMAP) {
-		dprintk(1, "Queue is not currently set up for mmap\n");
+		dprintk(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
 
 	if (!q->mem_ops->get_dmabuf) {
-		dprintk(1, "Queue does not support DMA buffer exporting\n");
+		dprintk(1, "queue does not support DMA buffer exporting\n");
 		return -EINVAL;
 	}
 
 	if (eb->flags & ~(O_CLOEXEC | O_ACCMODE)) {
-		dprintk(1, "Queue does support only O_CLOEXEC and access mode flags\n");
+		dprintk(1, "queue does support only O_CLOEXEC and access mode flags\n");
 		return -EINVAL;
 	}
 
@@ -2278,7 +2278,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 
 	dbuf = call_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
 	if (IS_ERR_OR_NULL(dbuf)) {
-		dprintk(1, "Failed to export buffer %d, plane %d\n",
+		dprintk(1, "failed to export buffer %d, plane %d\n",
 			eb->index, eb->plane);
 		fail_memop(vb, get_dmabuf);
 		return -EINVAL;
@@ -2328,7 +2328,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	unsigned long length;
 
 	if (q->memory != V4L2_MEMORY_MMAP) {
-		dprintk(1, "Queue is not currently set up for mmap\n");
+		dprintk(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
 
@@ -2336,17 +2336,17 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	 * Check memory area access mode.
 	 */
 	if (!(vma->vm_flags & VM_SHARED)) {
-		dprintk(1, "Invalid vma flags, VM_SHARED needed\n");
+		dprintk(1, "invalid vma flags, VM_SHARED needed\n");
 		return -EINVAL;
 	}
 	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
 		if (!(vma->vm_flags & VM_WRITE)) {
-			dprintk(1, "Invalid vma flags, VM_WRITE needed\n");
+			dprintk(1, "invalid vma flags, VM_WRITE needed\n");
 			return -EINVAL;
 		}
 	} else {
 		if (!(vma->vm_flags & VM_READ)) {
-			dprintk(1, "Invalid vma flags, VM_READ needed\n");
+			dprintk(1, "invalid vma flags, VM_READ needed\n");
 			return -EINVAL;
 		}
 	}
@@ -2382,7 +2382,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 		return ret;
 	}
 
-	dprintk(3, "Buffer %d, plane %d successfully mapped\n", buffer, plane);
+	dprintk(3, "buffer %d, plane %d successfully mapped\n", buffer, plane);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_mmap);
@@ -2400,7 +2400,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 	int ret;
 
 	if (q->memory != V4L2_MEMORY_MMAP) {
-		dprintk(1, "Queue is not currently set up for mmap\n");
+		dprintk(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
 
-- 
1.9.1

