Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58994 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab2DEOAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:00:35 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M200021BEWSKP@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:28 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2000AZ3EWVV9@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:32 +0100 (BST)
Date: Thu, 05 Apr 2012 16:00:02 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 05/11] v4l: vb2-dma-contig: Shorten vb2_dma_contig prefix to
 vb2_dc
In-reply-to: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com
Message-id: <1333634408-4960-6-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   36 ++++++++++++++--------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index f17ad98..5207eb1 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -31,9 +31,9 @@ struct vb2_dc_buf {
 	struct vb2_vmarea_handler	handler;
 };
 
-static void vb2_dma_contig_put(void *buf_priv);
+static void vb2_dc_put(void *buf_priv);
 
-static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
+static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct vb2_dc_buf *buf;
@@ -55,7 +55,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
 	buf->size = size;
 
 	buf->handler.refcount = &buf->refcount;
-	buf->handler.put = vb2_dma_contig_put;
+	buf->handler.put = vb2_dc_put;
 	buf->handler.arg = buf;
 
 	atomic_inc(&buf->refcount);
@@ -63,7 +63,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
 	return buf;
 }
 
-static void vb2_dma_contig_put(void *buf_priv)
+static void vb2_dc_put(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
@@ -74,14 +74,14 @@ static void vb2_dma_contig_put(void *buf_priv)
 	}
 }
 
-static void *vb2_dma_contig_cookie(void *buf_priv)
+static void *vb2_dc_cookie(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
 	return &buf->dma_addr;
 }
 
-static void *vb2_dma_contig_vaddr(void *buf_priv)
+static void *vb2_dc_vaddr(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 	if (!buf)
@@ -90,14 +90,14 @@ static void *vb2_dma_contig_vaddr(void *buf_priv)
 	return buf->vaddr;
 }
 
-static unsigned int vb2_dma_contig_num_users(void *buf_priv)
+static unsigned int vb2_dc_num_users(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
 	return atomic_read(&buf->refcount);
 }
 
-static int vb2_dma_contig_mmap(void *buf_priv, struct vm_area_struct *vma)
+static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
@@ -110,7 +110,7 @@ static int vb2_dma_contig_mmap(void *buf_priv, struct vm_area_struct *vma)
 				  &vb2_common_vm_ops, &buf->handler);
 }
 
-static void *vb2_dma_contig_get_userptr(void *alloc_ctx, unsigned long vaddr,
+static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 					unsigned long size, int write)
 {
 	struct vb2_dc_buf *buf;
@@ -137,7 +137,7 @@ static void *vb2_dma_contig_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	return buf;
 }
 
-static void vb2_dma_contig_put_userptr(void *mem_priv)
+static void vb2_dc_put_userptr(void *mem_priv)
 {
 	struct vb2_dc_buf *buf = mem_priv;
 
@@ -149,14 +149,14 @@ static void vb2_dma_contig_put_userptr(void *mem_priv)
 }
 
 const struct vb2_mem_ops vb2_dma_contig_memops = {
-	.alloc		= vb2_dma_contig_alloc,
-	.put		= vb2_dma_contig_put,
-	.cookie		= vb2_dma_contig_cookie,
-	.vaddr		= vb2_dma_contig_vaddr,
-	.mmap		= vb2_dma_contig_mmap,
-	.get_userptr	= vb2_dma_contig_get_userptr,
-	.put_userptr	= vb2_dma_contig_put_userptr,
-	.num_users	= vb2_dma_contig_num_users,
+	.alloc		= vb2_dc_alloc,
+	.put		= vb2_dc_put,
+	.cookie		= vb2_dc_cookie,
+	.vaddr		= vb2_dc_vaddr,
+	.mmap		= vb2_dc_mmap,
+	.get_userptr	= vb2_dc_get_userptr,
+	.put_userptr	= vb2_dc_put_userptr,
+	.num_users	= vb2_dc_num_users,
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 
-- 
1.7.5.4

