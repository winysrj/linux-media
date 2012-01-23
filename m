Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61833 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2AWNvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 08:51:38 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LY9008107TZ9Q@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:35 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LY900D9F7TYTD@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:35 +0000 (GMT)
Date: Mon, 23 Jan 2012 14:51:07 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 02/10] [media] media: vb2: remove plane argument from
 call_memop and cleanup mempriv usage
In-reply-to: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com, Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <1327326675-8431-3-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch removes unused 'plane' argument from call_memop macro.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/videobuf2-core.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6cd2f97..4c3a82e 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -30,7 +30,7 @@ module_param(debug, int, 0644);
 			printk(KERN_DEBUG "vb2: " fmt, ## arg);		\
 	} while (0)
 
-#define call_memop(q, plane, op, args...)				\
+#define call_memop(q, op, args...)					\
 	(((q)->mem_ops->op) ?						\
 		((q)->mem_ops->op(args)) : 0)
 
@@ -52,7 +52,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 
 	/* Allocate memory for all planes in this buffer */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
-		mem_priv = call_memop(q, plane, alloc, q->alloc_ctx[plane],
+		mem_priv = call_memop(q, alloc, q->alloc_ctx[plane],
 				      q->plane_sizes[plane]);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
@@ -66,7 +66,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 free:
 	/* Free already allocated memory if one of the allocations failed */
 	for (; plane > 0; --plane)
-		call_memop(q, plane, put, vb->planes[plane - 1].mem_priv);
+		call_memop(q, put, vb->planes[plane - 1].mem_priv);
 
 	return -ENOMEM;
 }
@@ -80,7 +80,7 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
 	unsigned int plane;
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
-		call_memop(q, plane, put, vb->planes[plane].mem_priv);
+		call_memop(q, put, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
 		dprintk(3, "Freed plane %d of buffer %d\n",
 				plane, vb->v4l2_buf.index);
@@ -100,7 +100,7 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
 		void *mem_priv = vb->planes[plane].mem_priv;
 
 		if (mem_priv) {
-			call_memop(q, plane, put_userptr, mem_priv);
+			call_memop(q, put_userptr, mem_priv);
 			vb->planes[plane].mem_priv = NULL;
 		}
 	}
@@ -328,7 +328,7 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 		 * case anyway. If num_users() returns more than 1,
 		 * we are not the only user of the plane's memory.
 		 */
-		if (mem_priv && call_memop(q, plane, num_users, mem_priv) > 1)
+		if (mem_priv && call_memop(q, num_users, mem_priv) > 1)
 			return true;
 	}
 	return false;
@@ -793,7 +793,7 @@ void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
 	if (plane_no > vb->num_planes)
 		return NULL;
 
-	return call_memop(q, plane_no, vaddr, vb->planes[plane_no].mem_priv);
+	return call_memop(q, vaddr, vb->planes[plane_no].mem_priv);
 
 }
 EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
@@ -816,7 +816,7 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
 	if (plane_no > vb->num_planes)
 		return NULL;
 
-	return call_memop(q, plane_no, cookie, vb->planes[plane_no].mem_priv);
+	return call_memop(q, cookie, vb->planes[plane_no].mem_priv);
 }
 EXPORT_SYMBOL_GPL(vb2_plane_cookie);
 
@@ -966,8 +966,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		/* Release previously acquired memory if present */
 		if (vb->planes[plane].mem_priv)
-			call_memop(q, plane, put_userptr,
-					vb->planes[plane].mem_priv);
+			call_memop(q, put_userptr, vb->planes[plane].mem_priv);
 
 		vb->planes[plane].mem_priv = NULL;
 		vb->v4l2_planes[plane].m.userptr = 0;
@@ -1011,8 +1010,7 @@ err:
 	/* In case of errors, release planes that were already acquired */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		if (vb->planes[plane].mem_priv)
-			call_memop(q, plane, put_userptr,
-				   vb->planes[plane].mem_priv);
+			call_memop(q, put_userptr, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
 		vb->v4l2_planes[plane].m.userptr = 0;
 		vb->v4l2_planes[plane].length = 0;
-- 
1.7.5.4

