Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:40578 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbbJFJh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2015 05:37:56 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NVS01I1ALF66O00@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2015 18:37:54 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [PATCH 2/4] media: videobuf2: Replace v4l2-specific data with vb2 data.
Date: Tue, 06 Oct 2015 18:37:47 +0900
Message-id: <1444124269-1084-3-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1444124269-1084-1-git-send-email-jh1009.sung@samsung.com>
References: <1444124269-1084-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simple changes that replace v4l2-specific data with vb2 data
in videobuf2-core.

enum v4l2_buf_type --> int
enum v4l2_memory --> enum vb2_memory
VIDEO_MAX_FRAME --> VB2_MAX_FRAME
VIDEO_MAX_PLANES --> VB2_MAX_PLANES
struct v4l2_fh *owner --> void *owner
V4L2_TYPE_IS_MULTIPLANAR() --> is_multiplanar
V4L2_TYPE_IS_OUTPUT() --> is_output

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |  131 ++++++++++++++++--------------
 include/media/videobuf2-core.h           |   33 ++++++--
 include/media/videobuf2-v4l2.h           |    8 ++
 include/trace/events/v4l2.h              |    5 +-
 4 files changed, 106 insertions(+), 71 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 8c456f7..db685e8 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -193,7 +193,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
 	int plane;
 
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
@@ -670,7 +670,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	b->reserved2 = 0;
 	b->reserved = 0;
 
-	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
+	if (q->is_multiplanar) {
 		/*
 		 * Fill in plane-related data if userspace provided an array
 		 * for it. The caller has already verified memory and size.
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
 
@@ -826,10 +826,10 @@ static int __verify_dmabuf_ops(struct vb2_queue *q)
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
@@ -843,17 +843,17 @@ static int __verify_memory_type(struct vb2_queue *q,
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
@@ -909,7 +909,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		 * are not in use and can be freed.
 		 */
 		mutex_lock(&q->mmap_lock);
-		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
+		if (q->memory == VB2_MEMORY_MMAP && __buffers_in_use(q)) {
 			mutex_unlock(&q->mmap_lock);
 			dprintk(1, "memory in use, cannot free\n");
 			return -EBUSY;
@@ -937,7 +937,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	/*
 	 * Make sure the requested values and current defaults are sane.
 	 */
-	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
+	num_buffers = min_t(unsigned int, req->count, VB2_MAX_FRAME);
 	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
 	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
@@ -1003,7 +1003,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * to the userspace.
 	 */
 	req->count = allocated_buffers;
-	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	q->waiting_for_buffers = !q->is_output;
 
 	return 0;
 }
@@ -1042,7 +1042,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
 	int ret;
 
-	if (q->num_buffers == VIDEO_MAX_FRAME) {
+	if (q->num_buffers == VB2_MAX_FRAME) {
 		dprintk(1, "maximum number of buffers already allocated\n");
 		return -ENOBUFS;
 	}
@@ -1051,10 +1051,10 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
 		q->memory = create->memory;
-		q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+		q->waiting_for_buffers = !q->is_output;
 	}
 
-	num_buffers = min(create->count, VIDEO_MAX_FRAME - q->num_buffers);
+	num_buffers = min(create->count, VB2_MAX_FRAME - q->num_buffers);
 
 	/*
 	 * Ask the driver, whether the requested number of buffers, planes per
@@ -1305,7 +1305,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb,
 	unsigned int plane;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		if (b->memory == V4L2_MEMORY_USERPTR) {
+		if (b->memory == VB2_MEMORY_USERPTR) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				planes[plane].m.userptr =
 					b->m.planes[plane].m.userptr;
@@ -1313,7 +1313,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb,
 					b->m.planes[plane].length;
 			}
 		}
-		if (b->memory == V4L2_MEMORY_DMABUF) {
+		if (b->memory == VB2_MEMORY_DMABUF) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				planes[plane].m.fd =
 					b->m.planes[plane].m.fd;
@@ -1370,12 +1370,12 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb,
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
@@ -1435,13 +1435,13 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
  */
 static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
-	struct vb2_plane planes[VIDEO_MAX_PLANES];
+	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
 	int ret;
 	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -1547,13 +1547,13 @@ err:
  */
 static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
-	struct vb2_plane planes[VIDEO_MAX_PLANES];
+	struct vb2_plane planes[VB2_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
 	int ret;
 	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -1700,7 +1700,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		dprintk(1, "plane parameters verification failed: %d\n", ret);
 		return ret;
 	}
-	if (b->field == V4L2_FIELD_ALTERNATE && V4L2_TYPE_IS_OUTPUT(q->type)) {
+	if (b->field == V4L2_FIELD_ALTERNATE && q->is_output) {
 		/*
 		 * If the format's field is ALTERNATE, then the buffer's field
 		 * should be either TOP or BOTTOM, not ALTERNATE since that
@@ -1725,13 +1725,13 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	vbuf->sequence = 0;
 
 	switch (q->memory) {
-	case V4L2_MEMORY_MMAP:
+	case VB2_MEMORY_MMAP:
 		ret = __qbuf_mmap(vb, b);
 		break;
-	case V4L2_MEMORY_USERPTR:
+	case VB2_MEMORY_USERPTR:
 		ret = __qbuf_userptr(vb, b);
 		break;
-	case V4L2_MEMORY_DMABUF:
+	case VB2_MEMORY_DMABUF:
 		ret = __qbuf_dmabuf(vb, b);
 		break;
 	default:
@@ -1919,7 +1919,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	q->queued_count++;
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+	if (q->is_output) {
 		/*
 		 * For output buffers copy the timestamp if needed,
 		 * and the timecode field and flag if needed.
@@ -2138,7 +2138,7 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 	vb->state = VB2_BUF_STATE_DEQUEUED;
 
 	/* unmap DMABUF buffer */
-	if (q->memory == V4L2_MEMORY_DMABUF)
+	if (q->memory == VB2_MEMORY_DMABUF)
 		for (i = 0; i < vb->num_planes; ++i) {
 			if (!vb->planes[i].dbuf_mapped)
 				continue;
@@ -2185,7 +2185,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 	trace_vb2_dqbuf(q, vb);
 
 	vbuf = to_vb2_v4l2_buffer(vb);
-	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
+	if (!q->is_output &&
 			vbuf->flags & V4L2_BUF_FLAG_LAST)
 		q->last_buffer_dequeued = true;
 	/* go back to dequeued state */
@@ -2400,7 +2400,7 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 	 * their normal dequeued state.
 	 */
 	__vb2_queue_cancel(q);
-	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	q->waiting_for_buffers = !q->is_output;
 	q->last_buffer_dequeued = false;
 
 	dprintk(3, "successful\n");
@@ -2477,7 +2477,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 	int ret;
 	struct dma_buf *dbuf;
 
-	if (q->memory != V4L2_MEMORY_MMAP) {
+	if (q->memory != VB2_MEMORY_MMAP) {
 		dprintk(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
@@ -2566,7 +2566,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	int ret;
 	unsigned long length;
 
-	if (q->memory != V4L2_MEMORY_MMAP) {
+	if (q->memory != VB2_MEMORY_MMAP) {
 		dprintk(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
@@ -2578,7 +2578,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 		dprintk(1, "invalid vma flags, VM_SHARED needed\n");
 		return -EINVAL;
 	}
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+	if (q->is_output) {
 		if (!(vma->vm_flags & VM_WRITE)) {
 			dprintk(1, "invalid vma flags, VM_WRITE needed\n");
 			return -EINVAL;
@@ -2639,7 +2639,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 	void *vaddr;
 	int ret;
 
-	if (q->memory != V4L2_MEMORY_MMAP) {
+	if (q->memory != VB2_MEMORY_MMAP) {
 		dprintk(1, "queue is not currently set up for mmap\n");
 		return -EINVAL;
 	}
@@ -2698,21 +2698,21 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 			poll_wait(file, &fh->wait, wait);
 	}
 
-	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
+	if (!q->is_output && !(req_events & (POLLIN | POLLRDNORM)))
 		return res;
-	if (V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLOUT | POLLWRNORM)))
+	if (q->is_output && !(req_events & (POLLOUT | POLLWRNORM)))
 		return res;
 
 	/*
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
+		if (!q->is_output && (q->io_modes & VB2_READ) &&
 				(req_events & (POLLIN | POLLRDNORM))) {
 			if (__vb2_init_fileio(q, 1))
 				return res | POLLERR;
 		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
+		if (q->is_output && (q->io_modes & VB2_WRITE) &&
 				(req_events & (POLLOUT | POLLWRNORM))) {
 			if (__vb2_init_fileio(q, 0))
 				return res | POLLERR;
@@ -2741,7 +2741,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * For output streams you can write as long as there are fewer buffers
 	 * queued than there are buffers available.
 	 */
-	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
+	if (q->is_output && q->queued_count < q->num_buffers)
 		return res | POLLOUT | POLLWRNORM;
 
 	if (list_empty(&q->done_list)) {
@@ -2766,7 +2766,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 
 	if (vb && (vb->state == VB2_BUF_STATE_DONE
 			|| vb->state == VB2_BUF_STATE_ERROR)) {
-		return (V4L2_TYPE_IS_OUTPUT(q->type)) ?
+		return (q->is_output) ?
 				res | POLLOUT | POLLWRNORM :
 				res | POLLIN | POLLRDNORM;
 	}
@@ -2806,6 +2806,12 @@ int vb2_queue_init(struct vb2_queue *q)
 	WARN_ON((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
 		V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
 
+	/* Warn that vb2_memory should match with v4l2_memory */
+	if (WARN_ON(VB2_MEMORY_MMAP != (int)V4L2_MEMORY_MMAP)
+		|| WARN_ON(VB2_MEMORY_USERPTR != (int)V4L2_MEMORY_USERPTR)
+		|| WARN_ON(VB2_MEMORY_DMABUF != (int)V4L2_MEMORY_DMABUF))
+		return -EINVAL;
+
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
 	spin_lock_init(&q->done_lock);
@@ -2815,6 +2821,9 @@ int vb2_queue_init(struct vb2_queue *q)
 	if (q->buf_struct_size == 0)
 		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
 
+	q->is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_queue_init);
@@ -2879,7 +2888,7 @@ struct vb2_fileio_data {
 	struct v4l2_requestbuffers req;
 	struct v4l2_plane p;
 	struct v4l2_buffer b;
-	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
+	struct vb2_fileio_buf bufs[VB2_MAX_FRAME];
 	unsigned int cur_index;
 	unsigned int initial_index;
 	unsigned int q_count;
@@ -2939,7 +2948,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * to allocate buffers by itself.
 	 */
 	fileio->req.count = count;
-	fileio->req.memory = V4L2_MEMORY_MMAP;
+	fileio->req.memory = VB2_MEMORY_MMAP;
 	fileio->req.type = q->type;
 	q->fileio = fileio;
 	ret = __reqbufs(q, &fileio->req);
@@ -2971,7 +2980,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Read mode requires pre queuing of all buffers.
 	 */
 	if (read) {
-		bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+		bool is_multiplanar = q->is_multiplanar;
 
 		/*
 		 * Queue all buffers.
@@ -3053,7 +3062,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 {
 	struct vb2_fileio_data *fileio;
 	struct vb2_fileio_buf *buf;
-	bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+	bool is_multiplanar = q->is_multiplanar;
 	/*
 	 * When using write() to write data to an output video node the vb2 core
 	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
@@ -3248,7 +3257,7 @@ static int vb2_thread(void *data)
 	int index = 0;
 	int ret = 0;
 
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+	if (q->is_output) {
 		prequeue = q->num_buffers;
 		set_timestamp =
 			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
@@ -3326,7 +3335,7 @@ int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
 	threadio->fnc = fnc;
 	threadio->priv = priv;
 
-	ret = __vb2_init_fileio(q, !V4L2_TYPE_IS_OUTPUT(q->type));
+	ret = __vb2_init_fileio(q, !q->is_output);
 	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
 	if (ret)
 		goto nomem;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index dce6463d..244ea2e 100644
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
@@ -209,7 +219,7 @@ struct vb2_buffer {
 	unsigned int		type;
 	unsigned int		memory;
 	unsigned int		num_planes;
-	struct vb2_plane	planes[VIDEO_MAX_PLANES];
+	struct vb2_plane	planes[VB2_MAX_PLANES];
 
 	/* private: internal use only
 	 *
@@ -353,12 +363,13 @@ struct vb2_ops {
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
@@ -409,6 +420,8 @@ struct v4l2_fh;
  * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
  *		buffers. Only set for capture queues if qbuf has not yet been
  *		called since poll() needs to return POLLERR in that situation.
+ * @is_multiplanar: set if buffer type is multiplanar
+ * @is_output:	set if buffer type is output
  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
  *		last decoded buffer was already dequeued. Set for capture queues
  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
@@ -416,14 +429,14 @@ struct v4l2_fh;
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
@@ -435,8 +448,8 @@ struct vb2_queue {
 
 	/* private: internal use only */
 	struct mutex			mmap_lock;
-	enum v4l2_memory		memory;
-	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
+	unsigned int			memory;
+	struct vb2_buffer		*bufs[VB2_MAX_FRAME];
 	unsigned int			num_buffers;
 
 	struct list_head		queued_list;
@@ -447,13 +460,15 @@ struct vb2_queue {
 	spinlock_t			done_lock;
 	wait_queue_head_t		done_wq;
 
-	void				*alloc_ctx[VIDEO_MAX_PLANES];
-	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
+	void				*alloc_ctx[VB2_MAX_PLANES];
+	unsigned int			plane_sizes[VB2_MAX_PLANES];
 
 	unsigned int			streaming:1;
 	unsigned int			start_streaming_called:1;
 	unsigned int			error:1;
 	unsigned int			waiting_for_buffers:1;
+	unsigned int			is_multiplanar:1;
+	unsigned int			is_output:1;
 	unsigned int			last_buffer_dequeued:1;
 
 	struct vb2_fileio_data		*fileio;
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 71f7fe2..9d10e3a 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -15,6 +15,14 @@
 #include <linux/videodev2.h>
 #include <media/videobuf2-core.h>
 
+#if VB2_MAX_FRAME != VIDEO_MAX_FRAME
+#error VB2_MAX_FRAME != VIDEO_MAX_FRAME
+#endif
+
+#if VB2_MAX_PLANES != VIDEO_MAX_PLANES
+#error VB2_MAX_PLANES != VIDEO_MAX_PLANES
+#endif
+
 /**
  * struct vb2_v4l2_buffer - video buffer information for v4l2
  * @vb2_buf:	video buffer 2
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index b015b38..375b1a3 100644
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
+		struct v4l2_fh *owner = q->owner;
+
+		__entry->minor = owner ? owner->vdev->minor : -1;
 		__entry->queued_count = q->queued_count;
 		__entry->owned_by_drv_count =
 			atomic_read(&q->owned_by_drv_count);
-- 
1.7.9.5

