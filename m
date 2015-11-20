Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:39272 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162616AbbKTQkJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:40:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv10 14/15] videobuf2-core: fix plane_sizes handling in VIDIOC_CREATE_BUFS
Date: Fri, 20 Nov 2015 17:34:17 +0100
Message-Id: <1448037258-36305-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The handling of q->plane_sizes was wrong in vb2_core_create_bufs().
The q->plane_sizes array was global and it was overwritten by create_bufs.
So if reqbufs was called with e.g. size 100000 then q->plane_sizes[0] would
be set to 100000. If create_bufs was called afterwards with size 200000,
then q->plane_sizes[0] would be overwritten with the new value. Calling
create_bufs again for size 100000 would cause an error since 100000 is now
less than q->plane_sizes[0].

This patch fixes this problem by 1) removing q->plane_sizes and using the
vb->planes[].length field instead, and 2) by introducing a min_length field
in struct vb2_plane. This field is set to the plane size as returned by
the queue_setup op and is the minimum required plane size. So user pointers
or dmabufs should all be at least this size.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 39 +++++++++++++++++---------------
 include/media/videobuf2-core.h           |  4 +++-
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 26ba9e4..e6890d4 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -203,7 +203,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	 * NOTE: mmapped areas should be page aligned
 	 */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
-		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
+		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
 
 		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
 				      size, dma_dir, q->gfp_flags);
@@ -212,7 +212,6 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 
 		/* Associate allocator private data with this plane */
 		vb->planes[plane].mem_priv = mem_priv;
-		vb->planes[plane].length = q->plane_sizes[plane];
 	}
 
 	return 0;
@@ -322,7 +321,8 @@ static void __setup_offsets(struct vb2_buffer *vb)
  * Returns the number of buffers successfully allocated.
  */
 static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
-			     unsigned int num_buffers, unsigned int num_planes)
+			     unsigned int num_buffers, unsigned int num_planes,
+			     const unsigned plane_sizes[VB2_MAX_PLANES])
 {
 	unsigned int buffer, plane;
 	struct vb2_buffer *vb;
@@ -342,8 +342,10 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 		vb->index = q->num_buffers + buffer;
 		vb->type = q->type;
 		vb->memory = memory;
-		for (plane = 0; plane < num_planes; ++plane)
-			vb->planes[plane].length = q->plane_sizes[plane];
+		for (plane = 0; plane < num_planes; ++plane) {
+			vb->planes[plane].length = plane_sizes[plane];
+			vb->planes[plane].min_length = plane_sizes[plane];
+		}
 		q->bufs[vb->index] = vb;
 
 		/* Allocate video buffer memory for the MMAP type */
@@ -352,8 +354,8 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			if (ret) {
 				dprintk(1, "failed allocating memory for "
 						"buffer %d\n", buffer);
-				kfree(vb);
 				q->bufs[vb->index] = NULL;
+				kfree(vb);
 				break;
 			}
 			__setup_offsets(vb);
@@ -690,6 +692,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count)
 {
 	unsigned int num_buffers, allocated_buffers, num_planes = 0;
+	unsigned plane_sizes[VB2_MAX_PLANES] = { };
 	int ret;
 
 	if (q->streaming) {
@@ -733,7 +736,6 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	 */
 	num_buffers = min_t(unsigned int, *count, VB2_MAX_FRAME);
 	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
-	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
 	q->memory = memory;
 
@@ -742,13 +744,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	 * Driver also sets the size and allocator context for each plane.
 	 */
 	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
-		       q->plane_sizes, q->alloc_ctx);
+		       plane_sizes, q->alloc_ctx);
 	if (ret)
 		return ret;
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers =
-		__vb2_queue_alloc(q, memory, num_buffers, num_planes);
+		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
 		dprintk(1, "memory allocation failed\n");
 		return -ENOMEM;
@@ -775,7 +777,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		num_planes = 0;
 
 		ret = call_qop(q, queue_setup, q, &num_buffers,
-			       &num_planes, q->plane_sizes, q->alloc_ctx);
+			       &num_planes, plane_sizes, q->alloc_ctx);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
@@ -832,6 +834,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		const unsigned requested_sizes[])
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
+	unsigned plane_sizes[VB2_MAX_PLANES] = { };
 	int ret;
 
 	if (q->num_buffers == VB2_MAX_FRAME) {
@@ -840,7 +843,6 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	}
 
 	if (!q->num_buffers) {
-		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
 		q->memory = memory;
 		q->waiting_for_buffers = !q->is_output;
@@ -850,7 +852,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 
 	if (requested_planes && requested_sizes) {
 		num_planes = requested_planes;
-		memcpy(q->plane_sizes, requested_sizes, sizeof(q->plane_sizes));
+		memcpy(plane_sizes, requested_sizes, sizeof(plane_sizes));
 	}
 
 	/*
@@ -858,13 +860,13 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	 * buffer and their sizes are acceptable
 	 */
 	ret = call_qop(q, queue_setup, q, &num_buffers,
-		       &num_planes, q->plane_sizes, q->alloc_ctx);
+		       &num_planes, plane_sizes, q->alloc_ctx);
 	if (ret)
 		return ret;
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
-				num_planes);
+				num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
 		dprintk(1, "memory allocation failed\n");
 		return -ENOMEM;
@@ -881,7 +883,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		 * queue driver has set up
 		 */
 		ret = call_qop(q, queue_setup, q, &num_buffers,
-			       &num_planes, q->plane_sizes, q->alloc_ctx);
+			       &num_planes, plane_sizes, q->alloc_ctx);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
@@ -1097,11 +1099,12 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 				"reacquiring memory\n", plane);
 
 		/* Check if the provided plane buffer is large enough */
-		if (planes[plane].length < q->plane_sizes[plane]) {
+		if (planes[plane].length < vb->planes[plane].min_length) {
 			dprintk(1, "provided buffer size %u is less than "
 						"setup size %u for plane %d\n",
 						planes[plane].length,
-						q->plane_sizes[plane], plane);
+						vb->planes[plane].min_length,
+						plane);
 			ret = -EINVAL;
 			goto err;
 		}
@@ -1214,7 +1217,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 		if (planes[plane].length == 0)
 			planes[plane].length = dbuf->size;
 
-		if (planes[plane].length < q->plane_sizes[plane]) {
+		if (planes[plane].length < vb->planes[plane].min_length) {
 			dprintk(1, "invalid dmabuf length for plane %d\n",
 				plane);
 			ret = -EINVAL;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index b88dbba..ef03ae5 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -129,6 +129,8 @@ struct vb2_mem_ops {
  * @dbuf_mapped:	flag to show whether dbuf is mapped or not
  * @bytesused:	number of bytes occupied by data in the plane (payload)
  * @length:	size of this plane (NOT the payload) in bytes
+ * @min_length:	minimum required size of this plane (NOT the payload) in bytes.
+ *		@length is always greater or equal to @min_length.
  * @offset:	when memory in the associated struct vb2_buffer is
  *		VB2_MEMORY_MMAP, equals the offset from the start of
  *		the device memory for this plane (or is a "cookie" that
@@ -150,6 +152,7 @@ struct vb2_plane {
 	unsigned int		dbuf_mapped;
 	unsigned int		bytesused;
 	unsigned int		length;
+	unsigned int		min_length;
 	union {
 		unsigned int	offset;
 		unsigned long	userptr;
@@ -489,7 +492,6 @@ struct vb2_queue {
 	wait_queue_head_t		done_wq;
 
 	void				*alloc_ctx[VB2_MAX_PLANES];
-	unsigned int			plane_sizes[VB2_MAX_PLANES];
 
 	unsigned int			streaming:1;
 	unsigned int			start_streaming_called:1;
-- 
2.6.2

