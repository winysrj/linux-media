Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22268 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1HJIVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 04:21:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LPP00AB5DW3Q450@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Aug 2011 09:21:39 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPP00264DW2IS@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Aug 2011 09:21:38 +0100 (BST)
Date: Wed, 10 Aug 2011 10:21:28 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: add a check if queued userptr buffer is large
 enough
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-id: <1312964488-2924-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Videobuf2 accepted any userptr buffer without verifying if its size is
large enough to store the video data from the driver. The driver reports
the minimal size of video data once in queue_setup and expects that
videobuf2 provides buffers that match these requirements. This patch
adds the required check.

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |   41 +++++++++++++++++++--------------
 include/media/videobuf2-core.h       |    1 +
 2 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 3015e60..c360627 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -43,8 +43,7 @@ module_param(debug, int, 0644);
 /**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
  */
-static int __vb2_buf_mem_alloc(struct vb2_buffer *vb,
-				unsigned long *plane_sizes)
+static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
@@ -53,13 +52,13 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb,
 	/* Allocate memory for all planes in this buffer */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		mem_priv = call_memop(q, plane, alloc, q->alloc_ctx[plane],
-					plane_sizes[plane]);
+				      q->plane_sizes[plane]);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
 		/* Associate allocator private data with this plane */
 		vb->planes[plane].mem_priv = mem_priv;
-		vb->v4l2_planes[plane].length = plane_sizes[plane];
+		vb->v4l2_planes[plane].length = q->plane_sizes[plane];
 	}
 
 	return 0;
@@ -141,8 +140,7 @@ static void __setup_offsets(struct vb2_queue *q)
  * Returns the number of buffers successfully allocated.
  */
 static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
-			     unsigned int num_buffers, unsigned int num_planes,
-			     unsigned long plane_sizes[])
+			     unsigned int num_buffers, unsigned int num_planes)
 {
 	unsigned int buffer;
 	struct vb2_buffer *vb;
@@ -169,7 +167,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 
 		/* Allocate video buffer memory for the MMAP type */
 		if (memory == V4L2_MEMORY_MMAP) {
-			ret = __vb2_buf_mem_alloc(vb, plane_sizes);
+			ret = __vb2_buf_mem_alloc(vb);
 			if (ret) {
 				dprintk(1, "Failed allocating memory for "
 						"buffer %d\n", buffer);
@@ -454,7 +452,6 @@ static bool __buffers_in_use(struct vb2_queue *q)
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
 	unsigned int num_buffers, num_planes;
-	unsigned long plane_sizes[VIDEO_MAX_PLANES];
 	int ret = 0;
 
 	if (q->fileio) {
@@ -516,7 +513,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * Make sure the requested values and current defaults are sane.
 	 */
 	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
-	memset(plane_sizes, 0, sizeof(plane_sizes));
+	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
 	q->memory = req->memory;
 
@@ -525,13 +522,12 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * Driver also sets the size and allocator context for each plane.
 	 */
 	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
-		       plane_sizes, q->alloc_ctx);
+		       q->plane_sizes, q->alloc_ctx);
 	if (ret)
 		return ret;
 
 	/* Finally, allocate buffers and video memory */
-	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes,
-				plane_sizes);
+	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
 	if (ret == 0) {
 		dprintk(1, "Memory allocation failed\n");
 		return -ENOMEM;
@@ -545,7 +541,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 
 		orig_num_buffers = num_buffers = ret;
 		ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
-			       plane_sizes, q->alloc_ctx);
+			       q->plane_sizes, q->alloc_ctx);
 		if (ret)
 			goto free_mem;
 
@@ -745,12 +741,20 @@ static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		dprintk(3, "qbuf: userspace address for plane %d changed, "
 				"reacquiring memory\n", plane);
 
+		/* Check if the provided plane buffer is large enough */
+		if (planes[plane].length < q->plane_sizes[plane]) {
+			ret = EINVAL;
+			goto err;
+		}
+
 		/* Release previously acquired memory if present */
 		if (vb->planes[plane].mem_priv)
 			call_memop(q, plane, put_userptr,
 					vb->planes[plane].mem_priv);
 
 		vb->planes[plane].mem_priv = NULL;
+		vb->v4l2_planes[plane].m.userptr = 0;
+		vb->v4l2_planes[plane].length = 0;
 
 		/* Acquire each plane's memory */
 		if (q->mem_ops->get_userptr) {
@@ -788,10 +792,13 @@ static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	return 0;
 err:
 	/* In case of errors, release planes that were already acquired */
-	for (; plane > 0; --plane) {
-		call_memop(q, plane, put_userptr,
-				vb->planes[plane - 1].mem_priv);
-		vb->planes[plane - 1].mem_priv = NULL;
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		if (vb->planes[plane].mem_priv)
+			call_memop(q, plane, put_userptr,
+				   vb->planes[plane].mem_priv);
+		vb->planes[plane].mem_priv = NULL;
+		vb->v4l2_planes[plane].m.userptr = 0;
+		vb->v4l2_planes[plane].length = 0;
 	}
 
 	return ret;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f87472a..496d6e5 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -276,6 +276,7 @@ struct vb2_queue {
 	wait_queue_head_t		done_wq;
 
 	void				*alloc_ctx[VIDEO_MAX_PLANES];
+	unsigned long			plane_sizes[VIDEO_MAX_PLANES];
 
 	unsigned int			streaming:1;
 
-- 
1.7.1.569.g6f426

