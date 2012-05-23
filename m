Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47472 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab2EWMKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 08:10:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4H00B4A5U9EU20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:10:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00FNJ5TSCC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:10:41 +0100 (BST)
Date: Wed, 23 May 2012 14:10:19 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv6 05/13] v4l: vb2-dma-contig: Shorten vb2_dma_contig prefix to
 vb2_dc
In-reply-to: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337775027-9489-6-git-send-email-t.stanislaws@samsung.com>
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   36 ++++++++++++++--------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 4b71326..a05784f 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -32,9 +32,9 @@ struct vb2_dc_buf {
 	struct vb2_vmarea_handler	handler;
 };
 
-static void vb2_dma_contig_put(void *buf_priv);
+static void vb2_dc_put(void *buf_priv);
 
-static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
+static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct vb2_dc_buf *buf;
@@ -56,7 +56,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
 	buf->size = size;
 
 	buf->handler.refcount = &buf->refcount;
-	buf->handler.put = vb2_dma_contig_put;
+	buf->handler.put = vb2_dc_put;
 	buf->handler.arg = buf;
 
 	atomic_inc(&buf->refcount);
@@ -64,7 +64,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
 	return buf;
 }
 
-static void vb2_dma_contig_put(void *buf_priv)
+static void vb2_dc_put(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
@@ -75,14 +75,14 @@ static void vb2_dma_contig_put(void *buf_priv)
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
@@ -91,14 +91,14 @@ static void *vb2_dma_contig_vaddr(void *buf_priv)
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
 
@@ -111,7 +111,7 @@ static int vb2_dma_contig_mmap(void *buf_priv, struct vm_area_struct *vma)
 				  &vb2_common_vm_ops, &buf->handler);
 }
 
-static void *vb2_dma_contig_get_userptr(void *alloc_ctx, unsigned long vaddr,
+static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 					unsigned long size, int write)
 {
 	struct vb2_dc_buf *buf;
@@ -138,7 +138,7 @@ static void *vb2_dma_contig_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	return buf;
 }
 
-static void vb2_dma_contig_put_userptr(void *mem_priv)
+static void vb2_dc_put_userptr(void *mem_priv)
 {
 	struct vb2_dc_buf *buf = mem_priv;
 
@@ -150,14 +150,14 @@ static void vb2_dma_contig_put_userptr(void *mem_priv)
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
1.7.9.5

