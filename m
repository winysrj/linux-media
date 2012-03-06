Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25078 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965144Ab2CFLiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 06:38:19 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0G00LFROBQ0I80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:14 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0G0030YOBQ0B@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:14 +0000 (GMT)
Date: Tue, 06 Mar 2012 12:38:04 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2 PATCH 3/9] v4l: vb2: Add dma-contig allocator as dma_buf user
In-reply-to: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, Sumit Semwal <sumit.semwal@linaro.org>
Message-id: <1331033890-10350-4-git-send-email-t.stanislaws@samsung.com>
References: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sumit Semwal <sumit.semwal@ti.com>

This patch makes changes for adding dma-contig as a dma_buf user. It provides
function implementations for the {attach, detach, map, unmap}_dmabuf()
mem_ops of DMABUF memory type.

Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
	[author of the original patch]
Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
	[integration with refactored dma-contig allocator]
---
 drivers/media/video/videobuf2-dma-contig.c |  116 ++++++++++++++++++++++++++++
 1 files changed, 116 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index c1dc043..746dd5f 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -35,6 +35,9 @@ struct vb2_dc_buf {
 
 	/* USERPTR related */
 	struct vm_area_struct		*vma;
+
+	/* DMABUF related */
+	struct dma_buf_attachment	*db_attach;
 };
 
 /*********************************************/
@@ -485,6 +488,115 @@ fail_buf:
 }
 
 /*********************************************/
+/*       callbacks for DMABUF buffers        */
+/*********************************************/
+
+static int vb2_dc_map_dmabuf(void *mem_priv)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+	struct sg_table *sgt;
+	unsigned long contig_size;
+	int ret = 0;
+
+	if (WARN_ON(!buf->db_attach)) {
+		printk(KERN_ERR "trying to pin a non attached buffer\n");
+		return -EINVAL;
+	}
+
+	if (WARN_ON(buf->dma_sgt)) {
+		printk(KERN_ERR "dmabuf buffer is already pinned\n");
+		return 0;
+	}
+
+	/* get the associated scatterlist for this buffer */
+	sgt = dma_buf_map_attachment(buf->db_attach, buf->dma_dir);
+	if (IS_ERR_OR_NULL(sgt)) {
+		printk(KERN_ERR "Error getting dmabuf scatterlist\n");
+		return -EINVAL;
+	}
+
+	/* checking if dmabuf is big enough to store contiguous chunk */
+	contig_size = vb2_dc_get_contiguous_size(sgt);
+	if (contig_size < buf->size) {
+		printk(KERN_ERR "contiguous chunk of dmabuf is too small\n");
+		ret = -EFAULT;
+		goto fail_map;
+	}
+
+	buf->dma_addr = sg_dma_address(sgt->sgl);
+	buf->dma_sgt = sgt;
+
+	return 0;
+
+fail_map:
+	dma_buf_unmap_attachment(buf->db_attach, sgt);
+
+	return ret;
+}
+
+static void vb2_dc_unmap_dmabuf(void *mem_priv)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	if (WARN_ON(!buf->db_attach)) {
+		printk(KERN_ERR "trying to unpin a not attached buffer\n");
+		return;
+	}
+
+	if (WARN_ON(!sgt)) {
+		printk(KERN_ERR "dmabuf buffer is already unpinned\n");
+		return;
+	}
+
+	dma_buf_unmap_attachment(buf->db_attach, sgt);
+
+	buf->dma_addr = 0;
+	buf->dma_sgt = NULL;
+}
+
+static void vb2_dc_detach_dmabuf(void *mem_priv)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+
+	if (buf->dma_addr)
+		vb2_dc_unmap_dmabuf(buf);
+
+	/* detach this attachment */
+	dma_buf_detach(buf->db_attach->dmabuf, buf->db_attach);
+	kfree(buf);
+}
+
+static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
+	unsigned long size, int write)
+{
+	struct vb2_dc_buf *buf;
+	struct dma_buf_attachment *dba;
+
+	if (dbuf->size < size)
+		return ERR_PTR(-EFAULT);
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->dev = alloc_ctx;
+	/* create attachment for the dmabuf with the user device */
+	dba = dma_buf_attach(dbuf, buf->dev);
+	if (IS_ERR(dba)) {
+		printk(KERN_ERR "failed to attach dmabuf\n");
+		kfree(buf);
+		return dba;
+	}
+
+	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	buf->size = size;
+	buf->db_attach = dba;
+
+	return buf;
+}
+
+/*********************************************/
 /*       DMA CONTIG exported functions       */
 /*********************************************/
 
@@ -498,6 +610,10 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.put_userptr	= vb2_dc_put_userptr,
 	.prepare	= vb2_dc_prepare,
 	.finish		= vb2_dc_finish,
+	.map_dmabuf	= vb2_dc_map_dmabuf,
+	.unmap_dmabuf	= vb2_dc_unmap_dmabuf,
+	.attach_dmabuf	= vb2_dc_attach_dmabuf,
+	.detach_dmabuf	= vb2_dc_detach_dmabuf,
 	.num_users	= vb2_dc_num_users,
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
-- 
1.7.5.4

