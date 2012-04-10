Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58802 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2DJKLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 06:11:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M29005RCDNLLM40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 11:11:45 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900BG1DNFBU@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 11:11:39 +0100 (BST)
Date: Tue, 10 Apr 2012 12:11:30 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/3] v4l: vb2-vmalloc: add support for dmabuf importing
In-reply-to: <1334052691-5145-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334052691-5145-3-git-send-email-t.stanislaws@samsung.com>
References: <1334052691-5145-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for importing DMABUF files for
vmalloc allocator in Videobuf2.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-vmalloc.c |   56 +++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/video/videobuf2-vmalloc.c
index 6b5ca6c..305032f 100644
--- a/drivers/media/video/videobuf2-vmalloc.c
+++ b/drivers/media/video/videobuf2-vmalloc.c
@@ -29,6 +29,7 @@ struct vb2_vmalloc_buf {
 	unsigned int			n_pages;
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
+	struct dma_buf			*dbuf;
 };
 
 static void vb2_vmalloc_put(void *buf_priv);
@@ -206,11 +207,66 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
 	return 0;
 }
 
+/*********************************************/
+/*       callbacks for DMABUF buffers        */
+/*********************************************/
+
+static int vb2_vmalloc_map_dmabuf(void *mem_priv)
+{
+	struct vb2_vmalloc_buf *buf = mem_priv;
+
+	buf->vaddr = dma_buf_vmap(buf->dbuf);
+
+	return buf->vaddr ? 0 : -EFAULT;
+}
+
+static void vb2_vmalloc_unmap_dmabuf(void *mem_priv)
+{
+	struct vb2_vmalloc_buf *buf = mem_priv;
+
+	dma_buf_vunmap(buf->dbuf, buf->vaddr);
+	buf->vaddr = NULL;
+}
+
+static void vb2_vmalloc_detach_dmabuf(void *mem_priv)
+{
+	struct vb2_vmalloc_buf *buf = mem_priv;
+
+	if (buf->vaddr)
+		dma_buf_vunmap(buf->dbuf, buf->vaddr);
+
+	kfree(buf);
+}
+
+static void *vb2_vmalloc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
+	unsigned long size, int write)
+{
+	struct vb2_vmalloc_buf *buf;
+
+	if (dbuf->size < size)
+		return ERR_PTR(-EFAULT);
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->dbuf = dbuf;
+	buf->write = write;
+	buf->size = size;
+
+	return buf;
+}
+
+
 const struct vb2_mem_ops vb2_vmalloc_memops = {
 	.alloc		= vb2_vmalloc_alloc,
 	.put		= vb2_vmalloc_put,
 	.get_userptr	= vb2_vmalloc_get_userptr,
 	.put_userptr	= vb2_vmalloc_put_userptr,
+	.map_dmabuf	= vb2_vmalloc_map_dmabuf,
+	.unmap_dmabuf	= vb2_vmalloc_unmap_dmabuf,
+	.attach_dmabuf	= vb2_vmalloc_attach_dmabuf,
+	.detach_dmabuf	= vb2_vmalloc_detach_dmabuf,
 	.vaddr		= vb2_vmalloc_vaddr,
 	.mmap		= vb2_vmalloc_mmap,
 	.num_users	= vb2_vmalloc_num_users,
-- 
1.7.5.4

