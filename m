Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47870 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab2AEKme (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 05:42:34 -0500
From: Sumit Semwal <sumit.semwal@ti.com>
To: <linaro-mm-sig@lists.linaro.org>, <linux-media@vger.kernel.org>,
	<arnd@arndb.de>
CC: <jesse.barker@linaro.org>, <m.szyprowski@samsung.com>,
	<rob@ti.com>, <daniel@ffwll.ch>, <t.stanislaws@samsung.com>,
	<patches@linaro.org>, Sumit Semwal <sumit.semwal@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFCv1 4/4] v4l:vb2: Add dma-contig allocator as dma_buf user
Date: Thu, 5 Jan 2012 16:11:58 +0530
Message-ID: <1325760118-27997-5-git-send-email-sumit.semwal@ti.com>
In-Reply-To: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch makes changes for adding dma-contig as a dma_buf user. It provides
function implementations for the {attach, detach, map, unmap}_dmabuf()
mem_ops of DMABUF memory type.

Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 drivers/media/video/videobuf2-dma-contig.c |  125 ++++++++++++++++++++++++++++
 1 files changed, 125 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index f17ad98..e671371 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -13,6 +13,8 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-buf.h>
 
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-memops.h>
@@ -27,6 +29,7 @@ struct vb2_dc_buf {
 	dma_addr_t			dma_addr;
 	unsigned long			size;
 	struct vm_area_struct		*vma;
+	struct dma_buf_attachment	*db_attach;
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
 };
@@ -37,6 +40,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct vb2_dc_buf *buf;
+	/* TODO: add db_attach processing while adding DMABUF as exporter */
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -106,6 +110,8 @@ static int vb2_dma_contig_mmap(void *buf_priv, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
+	WARN_ON(buf->db_attach);
+
 	return vb2_mmap_pfn_range(vma, buf->dma_addr, buf->size,
 				  &vb2_common_vm_ops, &buf->handler);
 }
@@ -148,6 +154,121 @@ static void vb2_dma_contig_put_userptr(void *mem_priv)
 	kfree(buf);
 }
 
+static int vb2_dma_contig_map_dmabuf(void *mem_priv,
+					enum dma_data_direction direction)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+	struct dma_buf *dmabuf;
+	struct sg_table *sg;
+
+	if (!buf || !buf->db_attach) {
+		printk(KERN_ERR "No dma buffer to pin\n");
+		return -EINVAL;
+	}
+
+	WARN_ON(buf->dma_addr);
+
+	if (direction == DMA_NONE) {
+		printk(KERN_ERR "Incorrect DMA direction\n");
+		return -EINVAL;
+	}
+
+	dmabuf = buf->db_attach->dmabuf;
+
+	/* get the associated scatterlist for this buffer */
+	sg = dma_buf_map_attachment(buf->db_attach, direction);
+
+	if (!sg) {
+		printk(KERN_ERR "Error getting dmabuf scatterlist\n");
+		return -EINVAL;
+	}
+
+	/*
+	 *  convert sglist to paddr:
+	 *  Assumption: for dma-contig, dmabuf would map to single entry
+	 *  Will return an error if it has more than one.
+	 */
+	if (sg->nents > 1) {
+		printk(KERN_ERR
+			"dmabuf scatterlist has more than 1 entry\n");
+		return -EINVAL;
+	}
+
+	buf->dma_addr = sg_dma_address(sg->sgl);
+	/* TODO: check the buffer size as per S_FMT */
+	buf->size = sg_dma_len(sg->sgl);
+
+	/* save this scatterlist in dmabuf for put_scatterlist */
+	dmabuf->priv = sg;
+
+	return 0;
+}
+
+static void vb2_dma_contig_unmap_dmabuf(void *mem_priv)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+	struct dma_buf *dmabuf;
+	struct sg_table *sg;
+
+	if (!buf || !buf->db_attach)
+		return;
+
+	WARN_ON(!buf->dma_addr);
+
+	dmabuf = buf->db_attach->dmabuf;
+	sg = dmabuf->priv;
+
+	/* Put the sg for this buffer */
+	dma_buf_unmap_attachment(buf->db_attach, sg);
+
+	buf->dma_addr = 0;
+	buf->size = 0;
+}
+
+static void *vb2_dma_contig_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf)
+{
+	struct vb2_dc_conf *conf = alloc_ctx;
+	struct vb2_dc_buf *buf;
+	struct dma_buf_attachment *dba;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	/* create attachment for the dmabuf with the user device */
+	dba = dma_buf_attach(dbuf, conf->dev);
+	if (IS_ERR(dba)) {
+		printk(KERN_ERR "failed to attach dmabuf\n");
+		kfree(buf);
+		return dba;
+	}
+
+	buf->conf = conf;
+	buf->size = dba->dmabuf->size;
+	buf->db_attach = dba;
+	buf->dma_addr = 0; /* dma_addr is available only after map */
+
+	return buf;
+}
+
+static void vb2_dma_contig_detach_dmabuf(void *mem_priv)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+
+	if (!buf)
+		return;
+
+	if (buf->dma_addr) {
+		vb2_dma_contig_unmap_dmabuf(buf);
+	}
+
+	/* detach this attachment */
+	dma_buf_detach(buf->db_attach->dmabuf, buf->db_attach);
+	buf->db_attach = NULL;
+
+	kfree(buf);
+}
+
 const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.alloc		= vb2_dma_contig_alloc,
 	.put		= vb2_dma_contig_put,
@@ -156,6 +277,10 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.mmap		= vb2_dma_contig_mmap,
 	.get_userptr	= vb2_dma_contig_get_userptr,
 	.put_userptr	= vb2_dma_contig_put_userptr,
+	.map_dmabuf	= vb2_dma_contig_map_dmabuf,
+	.unmap_dmabuf	= vb2_dma_contig_unmap_dmabuf,
+	.attach_dmabuf	= vb2_dma_contig_attach_dmabuf,
+	.detach_dmabuf	= vb2_dma_contig_detach_dmabuf,
 	.num_users	= vb2_dma_contig_num_users,
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
-- 
1.7.5.4

