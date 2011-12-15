Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19991 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1LOPR4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 10:17:56 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW90046M3TU5770@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Dec 2011 15:17:54 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW900KCI3TU4A@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Dec 2011 15:17:54 +0000 (GMT)
Date: Thu, 15 Dec 2011 16:17:49 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: review mem_priv usage and fix potential bugs
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Message-id: <1323962269-3478-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is a result of review of mem_priv entry usage in videobuf2 core.
It fixes all all potential places where it was not checked against NULL or
zeroed after freeing as well as a few style issues.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |   44 ++++++++++++++-------------------
 1 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 9dc887b..26cfbf5 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -65,8 +65,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	return 0;
 free:
 	/* Free already allocated memory if one of the allocations failed */
-	for (; plane > 0; --plane)
+	for (; plane > 0; --plane) {
 		call_memop(q, put, vb->planes[plane - 1].mem_priv);
+		vb->planes[plane - 1].mem_priv = NULL;
+	}
 
 	return -ENOMEM;
 }
@@ -82,8 +84,8 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		call_memop(q, put, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
-		dprintk(3, "Freed plane %d of buffer %d\n",
-				plane, vb->v4l2_buf.index);
+		dprintk(3, "Freed plane %d of buffer %d\n", plane,
+			vb->v4l2_buf.index);
 	}
 }
 
@@ -97,12 +99,9 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
 	unsigned int plane;
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
-		void *mem_priv = vb->planes[plane].mem_priv;
-
-		if (mem_priv) {
-			call_memop(q, put_userptr, mem_priv);
-			vb->planes[plane].mem_priv = NULL;
-		}
+		if (vb->planes[plane].mem_priv)
+			call_memop(q, put_userptr, vb->planes[plane].mem_priv);
+		vb->planes[plane].mem_priv = NULL;
 	}
 }
 
@@ -731,7 +730,7 @@ void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 
-	if (plane_no > vb->num_planes)
+	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;
 
 	return call_memop(q, vaddr, vb->planes[plane_no].mem_priv);
@@ -754,7 +753,7 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 
-	if (plane_no > vb->num_planes)
+	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;
 
 	return call_memop(q, cookie, vb->planes[plane_no].mem_priv);
@@ -906,19 +905,16 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		vb->v4l2_planes[plane].length = 0;
 
 		/* Acquire each plane's memory */
-		if (q->mem_ops->get_userptr) {
-			mem_priv = q->mem_ops->get_userptr(q->alloc_ctx[plane],
-							planes[plane].m.userptr,
-							planes[plane].length,
-							write);
-			if (IS_ERR(mem_priv)) {
-				dprintk(1, "qbuf: failed acquiring userspace "
+		mem_priv = call_memop(q, get_userptr, q->alloc_ctx[plane],
+				      planes[plane].m.userptr,
+				      planes[plane].length, write);
+		if (IS_ERR_OR_NULL(mem_priv)) {
+			dprintk(1, "qbuf: failed acquiring userspace "
 						"memory for plane %d\n", plane);
-				ret = PTR_ERR(mem_priv);
-				goto err;
-			}
-			vb->planes[plane].mem_priv = mem_priv;
+			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
+			goto err;
 		}
+		vb->planes[plane].mem_priv = mem_priv;
 	}
 
 	/*
@@ -1553,7 +1549,6 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 {
 	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
-	struct vb2_plane *vb_plane;
 	struct vb2_buffer *vb;
 	unsigned int buffer, plane;
 	int ret;
@@ -1590,9 +1585,8 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 		return ret;
 
 	vb = q->bufs[buffer];
-	vb_plane = &vb->planes[plane];
 
-	ret = q->mem_ops->mmap(vb_plane->mem_priv, vma);
+	ret = call_memop(q, mmap, vb->planes[plane].mem_priv, vma);
 	if (ret)
 		return ret;
 
-- 
1.7.1.569.g6f426

