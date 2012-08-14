Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:9318 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2HNPgr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:36:47 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R00BPG4PAGBC0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:36:46 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8R004J44MBC810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:36:46 +0900 (KST)
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
Subject: [PATCHv8 12/26] v4l: vb2-vmalloc: add support for dmabuf importing
Date: Tue, 14 Aug 2012 17:34:42 +0200
Message-id: <1344958496-9373-13-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
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
index 94efa04..a47fd4f 100644
--- a/drivers/media/video/videobuf2-vmalloc.c
+++ b/drivers/media/video/videobuf2-vmalloc.c
@@ -30,6 +30,7 @@ struct vb2_vmalloc_buf {
 	unsigned int			n_pages;
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
+	struct dma_buf			*dbuf;
 };
 
 static void vb2_vmalloc_put(void *buf_priv);
@@ -207,11 +208,66 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
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
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
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

