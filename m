Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13593 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab2FNNiQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 09:38:16 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5M005150KIWO60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 14:38:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M5M00MIB0JM1H@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 14:38:11 +0100 (BST)
Date: Thu, 14 Jun 2012 15:37:45 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv7 11/15] v4l: vb2-dma-contig: add support for dma_buf importing
In-reply-to: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de,
	Sumit Semwal <sumit.semwal@linaro.org>
Message-id: <1339681069-8483-12-git-send-email-t.stanislaws@samsung.com>
Content-transfer-encoding: 7BIT
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
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
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-dma-contig.c |  120 +++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index f9286d7..040829b 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -10,6 +10,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/dma-buf.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
@@ -38,6 +39,9 @@ struct vb2_dc_buf {
 
 	/* USERPTR related */
 	struct vm_area_struct		*vma;
+
+	/* DMABUF related */
+	struct dma_buf_attachment	*db_attach;
 };
 
 /*********************************************/
@@ -108,7 +112,8 @@ static void vb2_dc_prepare(void *buf_priv)
 	struct vb2_dc_buf *buf = buf_priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	if (!sgt)
+	/* DMABUF exporter will flush the cache for us */
+	if (!sgt || buf->db_attach)
 		return;
 
 	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
@@ -119,7 +124,8 @@ static void vb2_dc_finish(void *buf_priv)
 	struct vb2_dc_buf *buf = buf_priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	if (!sgt)
+	/* DMABUF exporter will flush the cache for us */
+	if (!sgt || buf->db_attach)
 		return;
 
 	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
@@ -380,6 +386,112 @@ fail_buf:
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
+		printk(KERN_ERR "contiguous chunk is too small %lu/%lu b\n",
+			contig_size, buf->size);
+		dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
+		return -EFAULT;
+	}
+
+	buf->dma_addr = sg_dma_address(sgt->sgl);
+	buf->dma_sgt = sgt;
+
+	return 0;
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
+	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
+
+	buf->dma_addr = 0;
+	buf->dma_sgt = NULL;
+}
+
+static void vb2_dc_detach_dmabuf(void *mem_priv)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+
+	/* if vb2 works correctly you should never detach mapped buffer */
+	if (WARN_ON(buf->dma_addr))
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
+	struct vb2_dc_conf *conf = alloc_ctx;
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
+	buf->dev = conf->dev;
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
 
@@ -393,6 +505,10 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
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
1.7.9.5

