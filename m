Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25078 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab2CFLiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 06:38:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0G00KFTOBQZK80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:14 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0G0030XOBQ0B@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:14 +0000 (GMT)
Date: Tue, 06 Mar 2012 12:38:02 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2 PATCH 1/9] v4l: vb2: fixes for DMABUF support
In-reply-to: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com
Message-id: <1331033890-10350-2-git-send-email-t.stanislaws@samsung.com>
References: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch contains fixes to DMABUF support in vb2-core.
- fixes number of arguments of call_memop macro
- fixes setup of plane length
- fixes handling of error pointers

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-core.c |   24 +++++++++++-------------
 include/media/videobuf2-core.h       |    6 +++---
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 951cb56..e7df560 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -118,7 +118,7 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
 		void *mem_priv = vb->planes[plane].mem_priv;
 
 		if (mem_priv) {
-			call_memop(q, plane, detach_dmabuf, mem_priv);
+			call_memop(q, detach_dmabuf, mem_priv);
 			dma_buf_put(vb->planes[plane].dbuf);
 			vb->planes[plane].dbuf = NULL;
 			vb->planes[plane].mem_priv = NULL;
@@ -905,6 +905,8 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 		}
 		if (b->memory == V4L2_MEMORY_DMABUF) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
+				v4l2_planes[plane].bytesused =
+					b->m.planes[plane].bytesused;
 				v4l2_planes[plane].m.fd = b->m.planes[plane].m.fd;
 			}
 		}
@@ -1052,17 +1054,13 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		if (IS_ERR_OR_NULL(dbuf)) {
 			dprintk(1, "qbuf: invalid dmabuf fd for "
 				"plane %d\n", plane);
-			ret = PTR_ERR(dbuf);
+			ret = -EINVAL;
 			goto err;
 		}
 
-		/* this doesn't get filled in until __fill_vb2_buffer(),
-		 * since it isn't known until after dma_buf_get()..
-		 */
-		planes[plane].length = dbuf->size;
-
 		/* Skip the plane if already verified */
 		if (dbuf == vb->planes[plane].dbuf) {
+			planes[plane].length = dbuf->size;
 			dma_buf_put(dbuf);
 			continue;
 		}
@@ -1072,7 +1070,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		/* Release previously acquired memory if present */
 		if (vb->planes[plane].mem_priv) {
-			call_memop(q, plane, detach_dmabuf,
+			call_memop(q, detach_dmabuf,
 				vb->planes[plane].mem_priv);
 			dma_buf_put(vb->planes[plane].dbuf);
 		}
@@ -1080,8 +1078,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		vb->planes[plane].mem_priv = NULL;
 
 		/* Acquire each plane's memory */
-		mem_priv = q->mem_ops->attach_dmabuf(
-				q->alloc_ctx[plane], dbuf);
+		mem_priv = call_memop(q, attach_dmabuf, q->alloc_ctx[plane],
+			dbuf, q->plane_sizes[plane], write);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "qbuf: failed acquiring dmabuf "
 				"memory for plane %d\n", plane);
@@ -1089,6 +1087,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			goto err;
 		}
 
+		planes[plane].length = dbuf->size;
 		vb->planes[plane].dbuf = dbuf;
 		vb->planes[plane].mem_priv = mem_priv;
 	}
@@ -1098,8 +1097,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	 * the buffer(s)..
 	 */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
-		ret = q->mem_ops->map_dmabuf(
-				vb->planes[plane].mem_priv, write);
+		ret = call_memop(q, map_dmabuf, vb->planes[plane].mem_priv);
 		if (ret) {
 			dprintk(1, "qbuf: failed mapping dmabuf "
 				"memory for plane %d\n", plane);
@@ -1527,7 +1525,7 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 	 */
 	if (q->memory == V4L2_MEMORY_DMABUF)
 		for (plane = 0; plane < vb->num_planes; ++plane)
-			call_memop(q, plane, unmap_dmabuf,
+			call_memop(q, unmap_dmabuf,
 				vb->planes[plane].mem_priv);
 
 	switch (vb->state) {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index d8b8171..412c6a4 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -88,10 +88,10 @@ struct vb2_mem_ops {
 	 * in the vb2 core, and vb2_mem_ops really just need to get/put the
 	 * sglist (and make sure that the sglist fits it's needs..)
 	 */
-	void		*(*attach_dmabuf)(void *alloc_ctx,
-					  struct dma_buf *dbuf);
+	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
+				unsigned long size, int write);
 	void		(*detach_dmabuf)(void *buf_priv);
-	int		(*map_dmabuf)(void *buf_priv, int write);
+	int		(*map_dmabuf)(void *buf_priv);
 	void		(*unmap_dmabuf)(void *buf_priv);
 
 	void		*(*vaddr)(void *buf_priv);
-- 
1.7.5.4

