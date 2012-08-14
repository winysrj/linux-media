Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:9080 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab2HNPfz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:35:55 -0400
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R00BOJ4NMGBC0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:35:54 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8R004J44MBC810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:35:53 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de, dmitriyz@google.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
Subject: [PATCHv8 05/26] v4l: vb2-dma-contig: Shorten vb2_dma_contig prefix to
 vb2_dc
Date: Tue, 14 Aug 2012 17:34:35 +0200
Message-id: <1344958496-9373-6-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
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

