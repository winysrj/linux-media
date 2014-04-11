Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4692 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaDKIMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 04:12:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 04/13] vb2: use correct prefix
Date: Fri, 11 Apr 2014 10:11:10 +0200
Message-Id: <1397203879-37443-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Many dprintk's in vb2 use a hardcoded prefix with the function name. In
many cases that is now outdated. To keep things consistent the dprintk
macro has been changed to print the function name in addition to the "vb2:"
prefix. Superfluous prefixes elsewhere in the code have been removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pawel Osciak <pawel@osciak.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 133 +++++++++++++++----------------
 1 file changed, 65 insertions(+), 68 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index b2582cb..1421075 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -27,10 +27,10 @@
 static int debug;
 module_param(debug, int, 0644);
 
-#define dprintk(level, fmt, arg...)					\
-	do {								\
-		if (debug >= level)					\
-			printk(KERN_DEBUG "vb2: " fmt, ## arg);		\
+#define dprintk(level, fmt, arg...)					      \
+	do {								      \
+		if (debug >= level)					      \
+			pr_debug("vb2: %s: " fmt, __func__, ## arg); \
 	} while (0)
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -371,7 +371,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 		if (q->bufs[buffer] == NULL)
 			continue;
 		if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
-			dprintk(1, "reqbufs: preparing buffers, cannot free\n");
+			dprintk(1, "preparing buffers, cannot free\n");
 			return -EAGAIN;
 		}
 	}
@@ -656,12 +656,12 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	int ret;
 
 	if (b->type != q->type) {
-		dprintk(1, "querybuf: wrong buffer type\n");
+		dprintk(1, "wrong buffer type\n");
 		return -EINVAL;
 	}
 
 	if (b->index >= q->num_buffers) {
-		dprintk(1, "querybuf: buffer index out of range\n");
+		dprintk(1, "buffer index out of range\n");
 		return -EINVAL;
 	}
 	vb = q->bufs[b->index];
@@ -721,12 +721,12 @@ static int __verify_memory_type(struct vb2_queue *q,
 {
 	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR &&
 	    memory != V4L2_MEMORY_DMABUF) {
-		dprintk(1, "reqbufs: unsupported memory type\n");
+		dprintk(1, "unsupported memory type\n");
 		return -EINVAL;
 	}
 
 	if (type != q->type) {
-		dprintk(1, "reqbufs: requested type is incorrect\n");
+		dprintk(1, "requested type is incorrect\n");
 		return -EINVAL;
 	}
 
@@ -735,17 +735,17 @@ static int __verify_memory_type(struct vb2_queue *q,
 	 * are available.
 	 */
 	if (memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
-		dprintk(1, "reqbufs: MMAP for current setup unsupported\n");
+		dprintk(1, "MMAP for current setup unsupported\n");
 		return -EINVAL;
 	}
 
 	if (memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
-		dprintk(1, "reqbufs: USERPTR for current setup unsupported\n");
+		dprintk(1, "USERPTR for current setup unsupported\n");
 		return -EINVAL;
 	}
 
 	if (memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
-		dprintk(1, "reqbufs: DMABUF for current setup unsupported\n");
+		dprintk(1, "DMABUF for current setup unsupported\n");
 		return -EINVAL;
 	}
 
@@ -755,7 +755,7 @@ static int __verify_memory_type(struct vb2_queue *q,
 	 * do the memory and type validation.
 	 */
 	if (q->fileio) {
-		dprintk(1, "reqbufs: file io in progress\n");
+		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
 	return 0;
@@ -790,7 +790,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	int ret;
 
 	if (q->streaming) {
-		dprintk(1, "reqbufs: streaming active\n");
+		dprintk(1, "streaming active\n");
 		return -EBUSY;
 	}
 
@@ -800,7 +800,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		 * are not in use and can be freed.
 		 */
 		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
-			dprintk(1, "reqbufs: memory in use, cannot free\n");
+			dprintk(1, "memory in use, cannot free\n");
 			return -EBUSY;
 		}
 
@@ -931,8 +931,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	int ret;
 
 	if (q->num_buffers == VIDEO_MAX_FRAME) {
-		dprintk(1, "%s(): maximum number of buffers already allocated\n",
-			__func__);
+		dprintk(1, "maximum number of buffers already allocated\n");
 		return -ENOBUFS;
 	}
 
@@ -1264,12 +1263,12 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		    && vb->v4l2_planes[plane].length == planes[plane].length)
 			continue;
 
-		dprintk(3, "qbuf: userspace address for plane %d changed, "
+		dprintk(3, "userspace address for plane %d changed, "
 				"reacquiring memory\n", plane);
 
 		/* Check if the provided plane buffer is large enough */
 		if (planes[plane].length < q->plane_sizes[plane]) {
-			dprintk(1, "qbuf: provided buffer size %u is less than "
+			dprintk(1, "provided buffer size %u is less than "
 						"setup size %u for plane %d\n",
 						planes[plane].length,
 						q->plane_sizes[plane], plane);
@@ -1294,7 +1293,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 				      planes[plane].m.userptr,
 				      planes[plane].length, write);
 		if (IS_ERR_OR_NULL(mem_priv)) {
-			dprintk(1, "qbuf: failed acquiring userspace "
+			dprintk(1, "failed acquiring userspace "
 						"memory for plane %d\n", plane);
 			fail_memop(vb, get_userptr);
 			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
@@ -1318,7 +1317,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		 */
 		ret = call_vb_qop(vb, buf_init, vb);
 		if (ret) {
-			dprintk(1, "qbuf: buffer initialization failed\n");
+			dprintk(1, "buffer initialization failed\n");
 			fail_vb_qop(vb, buf_init);
 			goto err;
 		}
@@ -1326,7 +1325,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
-		dprintk(1, "qbuf: buffer preparation failed\n");
+		dprintk(1, "buffer preparation failed\n");
 		fail_vb_qop(vb, buf_prepare);
 		call_vb_qop(vb, buf_cleanup, vb);
 		goto err;
@@ -1381,7 +1380,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
 
 		if (IS_ERR_OR_NULL(dbuf)) {
-			dprintk(1, "qbuf: invalid dmabuf fd for plane %d\n",
+			dprintk(1, "invalid dmabuf fd for plane %d\n",
 				plane);
 			ret = -EINVAL;
 			goto err;
@@ -1392,7 +1391,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			planes[plane].length = dbuf->size;
 
 		if (planes[plane].length < q->plane_sizes[plane]) {
-			dprintk(1, "qbuf: invalid dmabuf length for plane %d\n",
+			dprintk(1, "invalid dmabuf length for plane %d\n",
 				plane);
 			ret = -EINVAL;
 			goto err;
@@ -1405,7 +1404,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			continue;
 		}
 
-		dprintk(1, "qbuf: buffer for plane %d changed\n", plane);
+		dprintk(1, "buffer for plane %d changed\n", plane);
 
 		if (!reacquired) {
 			reacquired = true;
@@ -1420,7 +1419,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		mem_priv = call_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
 			dbuf, planes[plane].length, write);
 		if (IS_ERR(mem_priv)) {
-			dprintk(1, "qbuf: failed to attach dmabuf\n");
+			dprintk(1, "failed to attach dmabuf\n");
 			fail_memop(vb, attach_dmabuf);
 			ret = PTR_ERR(mem_priv);
 			dma_buf_put(dbuf);
@@ -1438,7 +1437,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
 		if (ret) {
-			dprintk(1, "qbuf: failed to map dmabuf for plane %d\n",
+			dprintk(1, "failed to map dmabuf for plane %d\n",
 				plane);
 			fail_memop(vb, map_dmabuf);
 			goto err;
@@ -1460,7 +1459,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		 */
 		ret = call_vb_qop(vb, buf_init, vb);
 		if (ret) {
-			dprintk(1, "qbuf: buffer initialization failed\n");
+			dprintk(1, "buffer initialization failed\n");
 			fail_vb_qop(vb, buf_init);
 			goto err;
 		}
@@ -1468,7 +1467,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
-		dprintk(1, "qbuf: buffer preparation failed\n");
+		dprintk(1, "buffer preparation failed\n");
 		fail_vb_qop(vb, buf_prepare);
 		call_vb_qop(vb, buf_cleanup, vb);
 		goto err;
@@ -1508,8 +1507,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	ret = __verify_length(vb, b);
 	if (ret < 0) {
-		dprintk(1, "%s(): plane parameters verification failed: %d\n",
-			__func__, ret);
+		dprintk(1, "plane parameters verification failed: %d\n", ret);
 		return ret;
 	}
 
@@ -1553,7 +1551,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	}
 
 	if (ret)
-		dprintk(1, "qbuf: buffer preparation failed: %d\n", ret);
+		dprintk(1, "buffer preparation failed: %d\n", ret);
 	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
 
 	return ret;
@@ -1563,23 +1561,23 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 				    const char *opname)
 {
 	if (b->type != q->type) {
-		dprintk(1, "%s(): invalid buffer type\n", opname);
+		dprintk(1, "%s: invalid buffer type\n", opname);
 		return -EINVAL;
 	}
 
 	if (b->index >= q->num_buffers) {
-		dprintk(1, "%s(): buffer index out of range\n", opname);
+		dprintk(1, "%s: buffer index out of range\n", opname);
 		return -EINVAL;
 	}
 
 	if (q->bufs[b->index] == NULL) {
 		/* Should never happen */
-		dprintk(1, "%s(): buffer is NULL\n", opname);
+		dprintk(1, "%s: buffer is NULL\n", opname);
 		return -EINVAL;
 	}
 
 	if (b->memory != q->memory) {
-		dprintk(1, "%s(): invalid memory type\n", opname);
+		dprintk(1, "%s: invalid memory type\n", opname);
 		return -EINVAL;
 	}
 
@@ -1607,7 +1605,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 	int ret;
 
 	if (q->fileio) {
-		dprintk(1, "%s(): file io in progress\n", __func__);
+		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
 
@@ -1617,7 +1615,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 
 	vb = q->bufs[b->index];
 	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-		dprintk(1, "%s(): invalid buffer state %d\n", __func__,
+		dprintk(1, "invalid buffer state %d\n",
 			vb->state);
 		return -EINVAL;
 	}
@@ -1627,7 +1625,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 		/* Fill buffer information for the userspace */
 		__fill_v4l2_buffer(vb, b);
 
-		dprintk(1, "%s() of buffer %d succeeded\n", __func__, vb->v4l2_buf.index);
+		dprintk(1, "prepare of buffer %d succeeded\n", vb->v4l2_buf.index);
 	}
 	return ret;
 }
@@ -1664,7 +1662,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
 		return 0;
 
 	fail_qop(q, start_streaming);
-	dprintk(1, "qbuf: driver refused to start streaming\n");
+	dprintk(1, "driver refused to start streaming\n");
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		unsigned i;
 
@@ -1702,11 +1700,10 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	case VB2_BUF_STATE_PREPARED:
 		break;
 	case VB2_BUF_STATE_PREPARING:
-		dprintk(1, "qbuf: buffer still being prepared\n");
+		dprintk(1, "buffer still being prepared\n");
 		return -EINVAL;
 	default:
-		dprintk(1, "%s(): invalid buffer state %d\n", __func__,
-			vb->state);
+		dprintk(1, "invalid buffer state %d\n", vb->state);
 		return -EINVAL;
 	}
 
@@ -1753,7 +1750,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 			return ret;
 	}
 
-	dprintk(1, "%s() of buffer %d succeeded\n", __func__, vb->v4l2_buf.index);
+	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
 	return 0;
 }
 
@@ -1777,7 +1774,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	if (q->fileio) {
-		dprintk(1, "%s(): file io in progress\n", __func__);
+		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
 
@@ -1938,7 +1935,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	int ret;
 
 	if (b->type != q->type) {
-		dprintk(1, "dqbuf: invalid buffer type\n");
+		dprintk(1, "invalid buffer type\n");
 		return -EINVAL;
 	}
 	ret = __vb2_get_done_vb(q, &vb, b, nonblocking);
@@ -1947,13 +1944,13 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DONE:
-		dprintk(3, "dqbuf: Returning done buffer\n");
+		dprintk(3, "Returning done buffer\n");
 		break;
 	case VB2_BUF_STATE_ERROR:
-		dprintk(3, "dqbuf: Returning done buffer with errors\n");
+		dprintk(3, "Returning done buffer with errors\n");
 		break;
 	default:
-		dprintk(1, "dqbuf: Invalid buffer state\n");
+		dprintk(1, "Invalid buffer state\n");
 		return -EINVAL;
 	}
 
@@ -1997,7 +1994,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
 	if (q->fileio) {
-		dprintk(1, "dqbuf: file io in progress\n");
+		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
 	return vb2_internal_dqbuf(q, b, nonblocking);
@@ -2069,26 +2066,26 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 	int ret;
 
 	if (type != q->type) {
-		dprintk(1, "streamon: invalid stream type\n");
+		dprintk(1, "invalid stream type\n");
 		return -EINVAL;
 	}
 
 	if (q->streaming) {
-		dprintk(3, "streamon successful: already streaming\n");
+		dprintk(3, "already streaming\n");
 		return 0;
 	}
 
 	if (!q->num_buffers) {
-		dprintk(1, "streamon: no buffers have been allocated\n");
+		dprintk(1, "no buffers have been allocated\n");
 		return -EINVAL;
 	}
 
 	if (!q->num_buffers) {
-		dprintk(1, "streamon: no buffers have been allocated\n");
+		dprintk(1, "no buffers have been allocated\n");
 		return -EINVAL;
 	}
 	if (q->num_buffers < q->min_buffers_needed) {
-		dprintk(1, "streamon: need at least %u allocated buffers\n",
+		dprintk(1, "need at least %u allocated buffers\n",
 				q->min_buffers_needed);
 		return -EINVAL;
 	}
@@ -2107,7 +2104,7 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 
 	q->streaming = 1;
 
-	dprintk(3, "Streamon successful\n");
+	dprintk(3, "successful\n");
 	return 0;
 }
 
@@ -2127,7 +2124,7 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (q->fileio) {
-		dprintk(1, "streamon: file io in progress\n");
+		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
 	return vb2_internal_streamon(q, type);
@@ -2137,7 +2134,7 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
 static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (type != q->type) {
-		dprintk(1, "streamoff: invalid stream type\n");
+		dprintk(1, "invalid stream type\n");
 		return -EINVAL;
 	}
 
@@ -2152,7 +2149,7 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 	 */
 	__vb2_queue_cancel(q);
 
-	dprintk(3, "Streamoff successful\n");
+	dprintk(3, "successful\n");
 	return 0;
 }
 
@@ -2174,7 +2171,7 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (q->fileio) {
-		dprintk(1, "streamoff: file io in progress\n");
+		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
 	return vb2_internal_streamoff(q, type);
@@ -2242,7 +2239,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 	}
 
 	if (eb->type != q->type) {
-		dprintk(1, "qbuf: invalid buffer type\n");
+		dprintk(1, "invalid buffer type\n");
 		return -EINVAL;
 	}
 
@@ -2756,7 +2753,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	struct vb2_fileio_buf *buf;
 	int ret, index;
 
-	dprintk(3, "file io: mode %s, offset %ld, count %zd, %sblocking\n",
+	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
 		read ? "read" : "write", (long)*ppos, count,
 		nonblock ? "non" : "");
 
@@ -2768,7 +2765,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 */
 	if (!q->fileio) {
 		ret = __vb2_init_fileio(q, read);
-		dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
+		dprintk(3, "vb2_init_fileio result: %d\n", ret);
 		if (ret)
 			return ret;
 	}
@@ -2786,7 +2783,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		fileio->b.type = q->type;
 		fileio->b.memory = q->memory;
 		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
-		dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
+		dprintk(5, "vb2_dqbuf result: %d\n", ret);
 		if (ret)
 			return ret;
 		fileio->dq_count += 1;
@@ -2816,14 +2813,14 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	/*
 	 * Transfer data to userspace.
 	 */
-	dprintk(3, "file io: copying %zd bytes - buffer %d, offset %u\n",
+	dprintk(3, "copying %zd bytes - buffer %d, offset %u\n",
 		count, index, buf->pos);
 	if (read)
 		ret = copy_to_user(data, buf->vaddr + buf->pos, count);
 	else
 		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
 	if (ret) {
-		dprintk(3, "file io: error copying data\n");
+		dprintk(3, "error copying data\n");
 		return -EFAULT;
 	}
 
@@ -2843,7 +2840,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		 */
 		if (read && (fileio->flags & VB2_FILEIO_READ_ONCE) &&
 		    fileio->dq_count == 1) {
-			dprintk(3, "file io: read limit reached\n");
+			dprintk(3, "read limit reached\n");
 			return __vb2_cleanup_fileio(q);
 		}
 
@@ -2856,7 +2853,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		fileio->b.index = index;
 		fileio->b.bytesused = buf->pos;
 		ret = vb2_internal_qbuf(q, &fileio->b);
-		dprintk(5, "file io: vb2_dbuf result: %d\n", ret);
+		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
 
-- 
1.9.1

