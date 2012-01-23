Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61833 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2AWNvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 08:51:38 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LY9008107TZ9Q@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:35 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LY900C877TYFR@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:35 +0000 (GMT)
Date: Mon, 23 Jan 2012 14:51:09 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 04/10] v4l: vb2: fixes for DMABUF support
In-reply-to: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com
Message-id: <1327326675-8431-5-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-core.c |   21 +++++++++------------
 include/media/videobuf2-core.h       |    6 +++---
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index cb85874..59bb1bc 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -119,7 +119,7 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
 		void *mem_priv = vb->planes[plane].mem_priv;
 
 		if (mem_priv) {
-			call_memop(q, plane, detach_dmabuf, mem_priv);
+			call_memop(q, detach_dmabuf, mem_priv);
 			dma_buf_put(vb->planes[plane].dbuf);
 			vb->planes[plane].dbuf = NULL;
 			vb->planes[plane].mem_priv = NULL;
@@ -907,6 +907,8 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 		if (b->memory == V4L2_MEMORY_DMABUF) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				v4l2_planes[plane].m.fd = b->m.planes[plane].m.fd;
+				v4l2_planes[plane].length =
+					b->m.planes[plane].length;
 			}
 		}
 	} else {
@@ -1055,15 +1057,10 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
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
 			dma_buf_put(dbuf);
@@ -1075,7 +1072,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		/* Release previously acquired memory if present */
 		if (vb->planes[plane].mem_priv) {
-			call_memop(q, plane, detach_dmabuf,
+			call_memop(q, detach_dmabuf,
 				vb->planes[plane].mem_priv);
 			dma_buf_put(vb->planes[plane].dbuf);
 		}
@@ -1083,8 +1080,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		vb->planes[plane].mem_priv = NULL;
 
 		/* Acquire each plane's memory */
-		mem_priv = q->mem_ops->attach_dmabuf(
-				q->alloc_ctx[plane], dbuf);
+		mem_priv = q->mem_ops->attach_dmabuf(q->alloc_ctx[plane],
+			dbuf, planes[plane].length, write);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "qbuf: failed acquiring dmabuf "
 				"memory for plane %d\n", plane);
@@ -1102,7 +1099,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	 */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		ret = q->mem_ops->map_dmabuf(
-				vb->planes[plane].mem_priv, write);
+			vb->planes[plane].mem_priv);
 		if (ret) {
 			dprintk(1, "qbuf: failed mapping dmabuf "
 				"memory for plane %d\n", plane);
@@ -1497,7 +1494,7 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
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

