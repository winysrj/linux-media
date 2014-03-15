Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4795 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549AbaCONIY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 09:08:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH for v3.15 2/4] videobuf2-core: fix sparse errors.
Date: Sat, 15 Mar 2014 14:08:01 +0100
Message-Id: <1394888883-46850-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394888883-46850-1-git-send-email-hverkuil@xs4all.nl>
References: <1394888883-46850-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Sparse generated a bunch of errors like this:

drivers/media/v4l2-core/videobuf2-core.c:2045:25: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:136:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:151:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:168:25: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:183:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:185:9: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:385:25: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1115:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1268:33: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1270:25: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1315:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1324:25: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1396:25: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1457:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1482:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1484:9: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1523:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1525:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1815:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1828:17: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1914:25: error: incompatible types in conditional expression (different base types)
drivers/media/v4l2-core/videobuf2-core.c:1944:9: error: incompatible types in conditional expression (different base types)

These are caused by the call*op defines which do something like this:

	(ops->op) ? ops->op(args) : 0

which is OK as long as op is not a void function, because in that case one part
of the conditional expression returns void, the other an integer. Hence the sparse
errors.

I've replaced this by introducing three variants of the call_ macros:
call_*op for int returns, call_void_*op for void returns and call_ptr_*op for
pointer returns.

That's the bad news. The good news is that the fail_*op macros could be removed
since the call_*op macros now have enough information to determine if the op
succeeded or not and can increment the op counter only on success. This at least
makes it more robust w.r.t. future changes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 211 +++++++++++++++++++------------
 1 file changed, 130 insertions(+), 81 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f9059bb..61149eb 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -36,58 +36,133 @@ module_param(debug, int, 0644);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 
 /*
- * If advanced debugging is on, then count how often each op is called,
- * which can either be per-buffer or per-queue.
+ * If advanced debugging is on, then count how often each op is called
+ * sucessfully, which can either be per-buffer or per-queue.
  *
- * If the op failed then the 'fail_' variant is called to decrease the
- * counter. That makes it easy to check that the 'init' and 'cleanup'
+ * This makes it easy to check that the 'init' and 'cleanup'
  * (and variations thereof) stay balanced.
  */
 
+#define log_memop(vb, op)						\
+	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
+		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
+		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
+
 #define call_memop(vb, op, args...)					\
 ({									\
 	struct vb2_queue *_q = (vb)->vb2_queue;				\
-	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
-		_q, (vb)->v4l2_buf.index, #op,				\
-		_q->mem_ops->op ? "" : " (nop)");			\
+	int err;							\
+									\
+	log_memop(vb, op);						\
+	err = _q->mem_ops->op ? _q->mem_ops->op(args) : 0;		\
+	if (!err)							\
+		(vb)->cnt_mem_ ## op++;					\
+	err;								\
+})
+
+#define call_ptr_memop(vb, op, args...)					\
+({									\
+	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	void *ptr;							\
+									\
+	log_memop(vb, op);						\
+	ptr = _q->mem_ops->op ? _q->mem_ops->op(args) : NULL;		\
+	if (!IS_ERR_OR_NULL(ptr))					\
+		(vb)->cnt_mem_ ## op++;					\
+	ptr;								\
+})
+
+#define call_void_memop(vb, op, args...)				\
+({									\
+	struct vb2_queue *_q = (vb)->vb2_queue;				\
+									\
+	log_memop(vb, op);						\
+	if (_q->mem_ops->op)						\
+		_q->mem_ops->op(args);					\
 	(vb)->cnt_mem_ ## op++;						\
-	_q->mem_ops->op ? _q->mem_ops->op(args) : 0;			\
 })
-#define fail_memop(vb, op) ((vb)->cnt_mem_ ## op--)
+
+#define log_qop(q, op)							\
+	dprintk(2, "call_qop(%p, %s)%s\n", q, #op,			\
+		(q)->ops->op ? "" : " (nop)")
 
 #define call_qop(q, op, args...)					\
 ({									\
-	dprintk(2, "call_qop(%p, %s)%s\n", q, #op,			\
-		(q)->ops->op ? "" : " (nop)");				\
+	int err;							\
+									\
+	log_qop(q, op);							\
+	err = (q)->ops->op ? (q)->ops->op(args) : 0;			\
+	if (!err)							\
+		(q)->cnt_ ## op++;					\
+	err;								\
+})
+
+#define call_void_qop(q, op, args...)					\
+({									\
+	log_qop(q, op);							\
+	if ((q)->ops->op)						\
+		(q)->ops->op(args);					\
 	(q)->cnt_ ## op++;						\
-	(q)->ops->op ? (q)->ops->op(args) : 0;				\
 })
-#define fail_qop(q, op) ((q)->cnt_ ## op--)
+
+#define log_vb_qop(vb, op, args...)					\
+	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
+		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
+		(vb)->vb2_queue->ops->op ? "" : " (nop)")
 
 #define call_vb_qop(vb, op, args...)					\
 ({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
-	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
-		_q, (vb)->v4l2_buf.index, #op,				\
-		_q->ops->op ? "" : " (nop)");				\
+	int err;							\
+									\
+	log_vb_qop(vb, op);						\
+	err = (vb)->vb2_queue->ops->op ?				\
+		(vb)->vb2_queue->ops->op(args) : 0;			\
+	if (!err)							\
+		(vb)->cnt_ ## op++;					\
+	err;								\
+})
+
+#define call_void_vb_qop(vb, op, args...)				\
+({									\
+	log_vb_qop(vb, op);						\
+	if ((vb)->vb2_queue->ops->op)					\
+		(vb)->vb2_queue->ops->op(args);				\
 	(vb)->cnt_ ## op++;						\
-	_q->ops->op ? _q->ops->op(args) : 0;				\
 })
-#define fail_vb_qop(vb, op) ((vb)->cnt_ ## op--)
 
 #else
 
 #define call_memop(vb, op, args...)					\
-	((vb)->vb2_queue->mem_ops->op ? (vb)->vb2_queue->mem_ops->op(args) : 0)
-#define fail_memop(vb, op)
+	((vb)->vb2_queue->mem_ops->op ?					\
+		(vb)->vb2_queue->mem_ops->op(args) : 0)
+
+#define call_ptr_memop(vb, op, args...)					\
+	((vb)->vb2_queue->mem_ops->op ?					\
+		(vb)->vb2_queue->mem_ops->op(args) : NULL)
+
+#define call_void_memop(vb, op, args...)				\
+	do {								\
+		if ((vb)->vb2_queue->mem_ops->op)			\
+			(vb)->vb2_queue->mem_ops->op(args);		\
+	} while (0)
 
 #define call_qop(q, op, args...)					\
 	((q)->ops->op ? (q)->ops->op(args) : 0)
-#define fail_qop(q, op)
+
+#define call_void_qop(q, op, args...)					\
+	do {								\
+		if ((q)->ops->op)					\
+			(q)->ops->op(args);				\
+	} while (0)
 
 #define call_vb_qop(vb, op, args...)					\
 	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
-#define fail_vb_qop(vb, op)
+
+#define call_void_vb_qop(vb, op, args...)				\
+	do {								\
+		if ((vb)->vb2_queue->ops->op)				\
+			(vb)->vb2_queue->ops->op(args);			\
+	} while (0)
 
 #endif
 
@@ -118,7 +193,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
 
-		mem_priv = call_memop(vb, alloc, q->alloc_ctx[plane],
+		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
 				      size, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
@@ -130,10 +205,9 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 
 	return 0;
 free:
-	fail_memop(vb, alloc);
 	/* Free already allocated memory if one of the allocations failed */
 	for (; plane > 0; --plane) {
-		call_memop(vb, put, vb->planes[plane - 1].mem_priv);
+		call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
 		vb->planes[plane - 1].mem_priv = NULL;
 	}
 
@@ -148,7 +222,7 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
 	unsigned int plane;
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
-		call_memop(vb, put, vb->planes[plane].mem_priv);
+		call_void_memop(vb, put, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
 		dprintk(3, "Freed plane %d of buffer %d\n", plane,
 			vb->v4l2_buf.index);
@@ -165,7 +239,7 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		if (vb->planes[plane].mem_priv)
-			call_memop(vb, put_userptr, vb->planes[plane].mem_priv);
+			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
 	}
 }
@@ -180,9 +254,9 @@ static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
 		return;
 
 	if (p->dbuf_mapped)
-		call_memop(vb, unmap_dmabuf, p->mem_priv);
+		call_void_memop(vb, unmap_dmabuf, p->mem_priv);
 
-	call_memop(vb, detach_dmabuf, p->mem_priv);
+	call_void_memop(vb, detach_dmabuf, p->mem_priv);
 	dma_buf_put(p->dbuf);
 	memset(p, 0, sizeof(*p));
 }
@@ -305,7 +379,6 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 			if (ret) {
 				dprintk(1, "Buffer %d %p initialization"
 					" failed\n", buffer, vb);
-				fail_vb_qop(vb, buf_init);
 				__vb2_buf_mem_free(vb);
 				kfree(vb);
 				break;
@@ -382,7 +455,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 		struct vb2_buffer *vb = q->bufs[buffer];
 
 		if (vb && vb->planes[0].mem_priv)
-			call_vb_qop(vb, buf_cleanup, vb);
+			call_void_vb_qop(vb, buf_cleanup, vb);
 	}
 
 	/* Release video buffer memory */
@@ -837,10 +910,8 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 */
 	ret = call_qop(q, queue_setup, q, NULL, &num_buffers, &num_planes,
 		       q->plane_sizes, q->alloc_ctx);
-	if (ret) {
-		fail_qop(q, queue_setup);
+	if (ret)
 		return ret;
-	}
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
@@ -864,8 +935,6 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 
 		ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
 			       &num_planes, q->plane_sizes, q->alloc_ctx);
-		if (ret)
-			fail_qop(q, queue_setup);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
@@ -950,10 +1019,8 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	 */
 	ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
 		       &num_planes, q->plane_sizes, q->alloc_ctx);
-	if (ret) {
-		fail_qop(q, queue_setup);
+	if (ret)
 		return ret;
-	}
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers = __vb2_queue_alloc(q, create->memory, num_buffers,
@@ -975,8 +1042,6 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 		 */
 		ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
 			       &num_planes, q->plane_sizes, q->alloc_ctx);
-		if (ret)
-			fail_qop(q, queue_setup);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
@@ -1038,7 +1103,7 @@ void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
 	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;
 
-	return call_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
+	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
 
 }
 EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
@@ -1059,7 +1124,7 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
 	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;
 
-	return call_memop(vb, cookie, vb->planes[plane_no].mem_priv);
+	return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
 }
 EXPORT_SYMBOL_GPL(vb2_plane_cookie);
 
@@ -1112,7 +1177,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 
 	/* sync buffers */
 	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_memop(vb, finish, vb->planes[plane].mem_priv);
+		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
 
 	/* Add the buffer to the done buffers list */
 	spin_lock_irqsave(&q->done_lock, flags);
@@ -1265,22 +1330,21 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		if (vb->planes[plane].mem_priv) {
 			if (!reacquired) {
 				reacquired = true;
-				call_vb_qop(vb, buf_cleanup, vb);
+				call_void_vb_qop(vb, buf_cleanup, vb);
 			}
-			call_memop(vb, put_userptr, vb->planes[plane].mem_priv);
+			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
 		}
 
 		vb->planes[plane].mem_priv = NULL;
 		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
 
 		/* Acquire each plane's memory */
-		mem_priv = call_memop(vb, get_userptr, q->alloc_ctx[plane],
+		mem_priv = call_ptr_memop(vb, get_userptr, q->alloc_ctx[plane],
 				      planes[plane].m.userptr,
 				      planes[plane].length, write);
 		if (IS_ERR_OR_NULL(mem_priv)) {
 			dprintk(1, "qbuf: failed acquiring userspace "
 						"memory for plane %d\n", plane);
-			fail_memop(vb, get_userptr);
 			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
 			goto err;
 		}
@@ -1303,7 +1367,6 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		ret = call_vb_qop(vb, buf_init, vb);
 		if (ret) {
 			dprintk(1, "qbuf: buffer initialization failed\n");
-			fail_vb_qop(vb, buf_init);
 			goto err;
 		}
 	}
@@ -1311,8 +1374,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
 		dprintk(1, "qbuf: buffer preparation failed\n");
-		fail_vb_qop(vb, buf_prepare);
-		call_vb_qop(vb, buf_cleanup, vb);
+		call_void_vb_qop(vb, buf_cleanup, vb);
 		goto err;
 	}
 
@@ -1321,7 +1383,7 @@ err:
 	/* In case of errors, release planes that were already acquired */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		if (vb->planes[plane].mem_priv)
-			call_memop(vb, put_userptr, vb->planes[plane].mem_priv);
+			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
 		vb->v4l2_planes[plane].m.userptr = 0;
 		vb->v4l2_planes[plane].length = 0;
@@ -1335,13 +1397,8 @@ err:
  */
 static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
-	int ret;
-
 	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
-	ret = call_vb_qop(vb, buf_prepare, vb);
-	if (ret)
-		fail_vb_qop(vb, buf_prepare);
-	return ret;
+	return call_vb_qop(vb, buf_prepare, vb);
 }
 
 /**
@@ -1393,7 +1450,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		if (!reacquired) {
 			reacquired = true;
-			call_vb_qop(vb, buf_cleanup, vb);
+			call_void_vb_qop(vb, buf_cleanup, vb);
 		}
 
 		/* Release previously acquired memory if present */
@@ -1401,11 +1458,10 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
 
 		/* Acquire each plane's memory */
-		mem_priv = call_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
+		mem_priv = call_ptr_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
 			dbuf, planes[plane].length, write);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "qbuf: failed to attach dmabuf\n");
-			fail_memop(vb, attach_dmabuf);
 			ret = PTR_ERR(mem_priv);
 			dma_buf_put(dbuf);
 			goto err;
@@ -1424,7 +1480,6 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		if (ret) {
 			dprintk(1, "qbuf: failed to map dmabuf for plane %d\n",
 				plane);
-			fail_memop(vb, map_dmabuf);
 			goto err;
 		}
 		vb->planes[plane].dbuf_mapped = 1;
@@ -1445,7 +1500,6 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		ret = call_vb_qop(vb, buf_init, vb);
 		if (ret) {
 			dprintk(1, "qbuf: buffer initialization failed\n");
-			fail_vb_qop(vb, buf_init);
 			goto err;
 		}
 	}
@@ -1453,8 +1507,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
 		dprintk(1, "qbuf: buffer preparation failed\n");
-		fail_vb_qop(vb, buf_prepare);
-		call_vb_qop(vb, buf_cleanup, vb);
+		call_void_vb_qop(vb, buf_cleanup, vb);
 		goto err;
 	}
 
@@ -1479,9 +1532,9 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 
 	/* sync buffers */
 	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_memop(vb, prepare, vb->planes[plane].mem_priv);
+		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
 
-	call_vb_qop(vb, buf_queue, vb);
+	call_void_vb_qop(vb, buf_queue, vb);
 }
 
 static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
@@ -1520,9 +1573,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		 * mmap_sem and then takes the driver's lock again.
 		 */
 		mmap_sem = &current->mm->mmap_sem;
-		call_qop(q, wait_prepare, q);
+		call_void_qop(q, wait_prepare, q);
 		down_read(mmap_sem);
-		call_qop(q, wait_finish, q);
+		call_void_qop(q, wait_finish, q);
 
 		ret = __qbuf_userptr(vb, b);
 
@@ -1647,7 +1700,6 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	if (!ret)
 		return 0;
 
-	fail_qop(q, start_streaming);
 	dprintk(1, "qbuf: driver refused to start streaming\n");
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		unsigned i;
@@ -1812,7 +1864,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		 * become ready or for streamoff. Driver's lock is released to
 		 * allow streamoff or qbuf to be called while waiting.
 		 */
-		call_qop(q, wait_prepare, q);
+		call_void_qop(q, wait_prepare, q);
 
 		/*
 		 * All locks have been released, it is safe to sleep now.
@@ -1825,7 +1877,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		 * We need to reevaluate both conditions again after reacquiring
 		 * the locks or return an error if one occurred.
 		 */
-		call_qop(q, wait_finish, q);
+		call_void_qop(q, wait_finish, q);
 		if (ret) {
 			dprintk(1, "Sleep was interrupted\n");
 			return ret;
@@ -1911,7 +1963,7 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 		for (i = 0; i < vb->num_planes; ++i) {
 			if (!vb->planes[i].dbuf_mapped)
 				continue;
-			call_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
+			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
 			vb->planes[i].dbuf_mapped = 0;
 		}
 }
@@ -1941,7 +1993,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 		return -EINVAL;
 	}
 
-	call_vb_qop(vb, buf_finish, vb);
+	call_void_vb_qop(vb, buf_finish, vb);
 
 	/* Fill buffer information for the userspace */
 	__fill_v4l2_buffer(vb, b);
@@ -2042,7 +2094,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 
 		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
 			vb->state = VB2_BUF_STATE_PREPARED;
-			call_vb_qop(vb, buf_finish, vb);
+			call_void_vb_qop(vb, buf_finish, vb);
 		}
 		__vb2_dqbuf(vb);
 	}
@@ -2244,11 +2296,10 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 
 	vb_plane = &vb->planes[eb->plane];
 
-	dbuf = call_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
+	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
 	if (IS_ERR_OR_NULL(dbuf)) {
 		dprintk(1, "Failed to export buffer %d, plane %d\n",
 			eb->index, eb->plane);
-		fail_memop(vb, get_dmabuf);
 		return -EINVAL;
 	}
 
@@ -2341,10 +2392,8 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	}
 
 	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
-	if (ret) {
-		fail_memop(vb, mmap);
+	if (ret)
 		return ret;
-	}
 
 	dprintk(3, "Buffer %d, plane %d successfully mapped\n", buffer, plane);
 	return 0;
-- 
1.9.0

