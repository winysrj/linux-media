Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1937 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab2ISOic (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 10:38:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/6] videobuf2-core: move num_planes from vb2_buffer to vb2_queue.
Date: Wed, 19 Sep 2012 16:37:35 +0200
Message-Id: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
In-Reply-To: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It's a queue-global value, so keep it there rather than with the
buffer struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |   40 ++++++++++++++++--------------
 include/media/videobuf2-core.h           |   12 ++++-----
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 4da3df6..febc23b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -54,7 +54,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	int plane;
 
 	/* Allocate memory for all planes in this buffer */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < q->num_planes; ++plane) {
 		mem_priv = call_memop(q, alloc, q->alloc_ctx[plane],
 				      q->plane_sizes[plane]);
 		if (IS_ERR_OR_NULL(mem_priv))
@@ -84,7 +84,7 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned int plane;
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < q->num_planes; ++plane) {
 		call_memop(q, put, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
 		dprintk(3, "Freed plane %d of buffer %d\n", plane,
@@ -101,7 +101,7 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned int plane;
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < q->num_planes; ++plane) {
 		if (vb->planes[plane].mem_priv)
 			call_memop(q, put_userptr, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
@@ -121,7 +121,7 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 	if (q->num_buffers) {
 		struct v4l2_plane *p;
 		vb = q->bufs[q->num_buffers - 1];
-		p = &vb->v4l2_planes[vb->num_planes - 1];
+		p = &vb->v4l2_planes[q->num_planes - 1];
 		off = PAGE_ALIGN(p->m.mem_offset + p->length);
 	} else {
 		off = 0;
@@ -132,7 +132,7 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 		if (!vb)
 			continue;
 
-		for (plane = 0; plane < vb->num_planes; ++plane) {
+		for (plane = 0; plane < q->num_planes; ++plane) {
 			vb->v4l2_planes[plane].length = q->plane_sizes[plane];
 			vb->v4l2_planes[plane].m.mem_offset = off;
 
@@ -173,7 +173,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 
 		vb->state = VB2_BUF_STATE_DEQUEUED;
 		vb->vb2_queue = q;
-		vb->num_planes = num_planes;
+		q->num_planes = num_planes;
 		vb->v4l2_buf.index = q->num_buffers + buffer;
 		vb->v4l2_buf.type = q->type;
 		vb->v4l2_buf.memory = memory;
@@ -276,6 +276,8 @@ static void __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
  */
 static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
+	struct vb2_queue *q = vb->vb2_queue;
+
 	/* Is memory for copying plane information present? */
 	if (NULL == b->m.planes) {
 		dprintk(1, "Multi-planar buffer passed but "
@@ -283,9 +285,9 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 		return -EINVAL;
 	}
 
-	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
+	if (b->length < q->num_planes || b->length > VIDEO_MAX_PLANES) {
 		dprintk(1, "Incorrect planes array length, "
-			   "expected %d, got %d\n", vb->num_planes, b->length);
+			   "expected %d, got %d\n", q->num_planes, b->length);
 		return -EINVAL;
 	}
 
@@ -299,7 +301,7 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 {
 	unsigned int plane;
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < q->num_planes; ++plane) {
 		void *mem_priv = vb->planes[plane].mem_priv;
 		/*
 		 * If num_users() has not been provided, call_memop
@@ -744,7 +746,7 @@ void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 
-	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
+	if (plane_no > q->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;
 
 	return call_memop(q, vaddr, vb->planes[plane_no].mem_priv);
@@ -767,7 +769,7 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 
-	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
+	if (plane_no > q->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;
 
 	return call_memop(q, cookie, vb->planes[plane_no].mem_priv);
@@ -823,6 +825,8 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 	int ret;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		struct vb2_queue *q = vb->vb2_queue;
+
 		/*
 		 * Verify that the userspace gave us a valid array for
 		 * plane information.
@@ -837,7 +841,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 			 * Will have to go up to b->length when API starts
 			 * accepting variable number of planes.
 			 */
-			for (plane = 0; plane < vb->num_planes; ++plane) {
+			for (plane = 0; plane < q->num_planes; ++plane) {
 				v4l2_planes[plane].bytesused =
 					b->m.planes[plane].bytesused;
 				v4l2_planes[plane].data_offset =
@@ -846,7 +850,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 		}
 
 		if (b->memory == V4L2_MEMORY_USERPTR) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
+			for (plane = 0; plane < q->num_planes; ++plane) {
 				v4l2_planes[plane].m.userptr =
 					b->m.planes[plane].m.userptr;
 				v4l2_planes[plane].length =
@@ -893,7 +897,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	if (ret)
 		return ret;
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < q->num_planes; ++plane) {
 		/* Skip the plane if already verified */
 		if (vb->v4l2_planes[plane].m.userptr &&
 		    vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
@@ -944,13 +948,13 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	 * Now that everything is in order, copy relevant information
 	 * provided by userspace.
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane)
+	for (plane = 0; plane < q->num_planes; ++plane)
 		vb->v4l2_planes[plane] = planes[plane];
 
 	return 0;
 err:
 	/* In case of errors, release planes that were already acquired */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < q->num_planes; ++plane) {
 		if (vb->planes[plane].mem_priv)
 			call_memop(q, put_userptr, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
@@ -1528,7 +1532,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
 		vb = q->bufs[buffer];
 
-		for (plane = 0; plane < vb->num_planes; ++plane) {
+		for (plane = 0; plane < q->num_planes; ++plane) {
 			if (vb->v4l2_planes[plane].m.mem_offset == off) {
 				*_buffer = buffer;
 				*_plane = plane;
@@ -1866,7 +1870,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Check if plane_count is correct
 	 * (multiplane buffers are not supported).
 	 */
-	if (q->bufs[0]->num_planes != 1) {
+	if (q->num_planes != 1) {
 		ret = -EBUSY;
 		goto err_reqbufs;
 	}
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 8dd9b6c..45f6e1c 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -140,8 +140,6 @@ struct vb2_queue;
  *			instead of v4l2_buf for filling bytesused - drivers
  *			should use the vb2_set_plane_payload() function for that
  * @vb2_queue:		the queue to which this driver belongs
- * @num_planes:		number of planes in the buffer
- *			on an internal driver queue
  * @state:		current buffer state; do not change
  * @queued_entry:	entry on the queued buffers list, which holds all
  *			buffers queued from userspace
@@ -155,8 +153,6 @@ struct vb2_buffer {
 
 	struct vb2_queue	*vb2_queue;
 
-	unsigned int		num_planes;
-
 /* Private: internal use only */
 	enum vb2_buffer_state	state;
 
@@ -271,6 +267,7 @@ struct v4l2_fh;
  * @memory:	current memory type used
  * @bufs:	videobuf buffer structures
  * @num_buffers: number of allocated/used buffers
+ * @num_planes:	number of planes in the buffers
  * @queued_list: list of buffers currently queued from userspace
  * @queued_count: number of buffers owned by the driver
  * @done_list:	list of buffers ready to be dequeued to userspace
@@ -296,6 +293,7 @@ struct vb2_queue {
 	enum v4l2_memory		memory;
 	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
 	unsigned int			num_buffers;
+	unsigned int			num_planes;
 
 	struct list_head		queued_list;
 
@@ -386,7 +384,7 @@ static inline void *vb2_get_drv_priv(struct vb2_queue *q)
 static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no, unsigned long size)
 {
-	if (plane_no < vb->num_planes)
+	if (plane_no < vb->vb2_queue->num_planes)
 		vb->v4l2_planes[plane_no].bytesused = size;
 }
 
@@ -399,7 +397,7 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
 static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no)
 {
-	if (plane_no < vb->num_planes)
+	if (plane_no < vb->vb2_queue->num_planes)
 		return vb->v4l2_planes[plane_no].bytesused;
 	return 0;
 }
@@ -412,7 +410,7 @@ static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
 static inline unsigned long
 vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
 {
-	if (plane_no < vb->num_planes)
+	if (plane_no < vb->vb2_queue->num_planes)
 		return vb->v4l2_planes[plane_no].length;
 	return 0;
 }
-- 
1.7.10.4

