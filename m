Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14329 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2FNNiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 09:38:15 -0400
Received: from euspt2 (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5M005NS0KS2N60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 14:38:52 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M5M00FVD0JK8T@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 14:38:08 +0100 (BST)
Date: Thu, 14 Jun 2012 15:37:46 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv7 12/15] v4l: vb2-vmalloc: add support for dmabuf importing
In-reply-to: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1339681069-8483-13-git-send-email-t.stanislaws@samsung.com>
Content-transfer-encoding: 7BIT
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for importing DMABUF files for
vmalloc allocator in Videobuf2.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-vmalloc.c |   56 +++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

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
1.7.9.5

