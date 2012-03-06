Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56327 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965161Ab2CFLiU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 06:38:20 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0G003KLOBR18@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:15 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0G00CLSOBRW5@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:15 +0000 (GMT)
Date: Tue, 06 Mar 2012 12:38:08 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2 PATCH 7/9] v4l: vb2-dma-contig: change map/unmap behaviour
In-reply-to: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com
Message-id: <1331033890-10350-8-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMABUF documentation says that the map_dma_buf callback should return
scatterlist that is mapped into a caller's address space. In practice, almost
none of existing implementations of DMABUF exporter does it.  This patch breaks
the DMABUF specification in order to allow exchange DMABUF buffers between
other APIs like DRM.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   64 ++++++++++++----------------
 1 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index d95b23a..32bb16b 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -315,11 +315,6 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 /*         DMABUF ops for exporters          */
 /*********************************************/
 
-struct vb2_dc_attachment {
-	struct sg_table sgt;
-	enum dma_data_direction dir;
-};
-
 static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
 	struct dma_buf_attachment *dbuf_attach)
 {
@@ -330,17 +325,13 @@ static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
 static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
 	struct dma_buf_attachment *db_attach)
 {
-	struct vb2_dc_attachment *attach = db_attach->priv;
-	struct sg_table *sgt;
+	struct sg_table *sgt = db_attach->priv;
 
-	if (!attach)
+	if (!sgt)
 		return;
 
-	sgt = &attach->sgt;
-
-	dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->nents, attach->dir);
 	sg_free_table(sgt);
-	kfree(attach);
+	kfree(sgt);
 	db_attach->priv = NULL;
 }
 
@@ -349,26 +340,22 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 {
 	struct dma_buf *dbuf = db_attach->dmabuf;
 	struct vb2_dc_buf *buf = dbuf->priv;
-	struct vb2_dc_attachment *attach = db_attach->priv;
-	struct sg_table *sgt;
+	struct sg_table *sgt = db_attach->priv;
 	struct scatterlist *rd, *wr;
 	int i, ret;
 
 	/* return previously mapped sg table */
-	if (attach)
-		return &attach->sgt;
+	if (sgt)
+		return sgt;
 
-	attach = kzalloc(sizeof *attach, GFP_KERNEL);
-	if (!attach)
+	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
+	if (!sgt)
 		return ERR_PTR(-ENOMEM);
 
-	sgt = &attach->sgt;
-	attach->dir = dir;
-
 	/* copying the buf->base_sgt to attachment */
 	ret = sg_alloc_table(sgt, buf->sgt_base->orig_nents, GFP_KERNEL);
 	if (ret) {
-		kfree(attach);
+		kfree(sgt);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -380,16 +367,7 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 		wr = sg_next(wr);
 	}
 
-	/* mapping new sglist to the client */
-	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
-	if (ret <= 0) {
-		printk(KERN_ERR "failed to map scatterlist\n");
-		sg_free_table(sgt);
-		kfree(attach);
-		return ERR_PTR(-EIO);
-	}
-
-	db_attach->priv = attach;
+	db_attach->priv = sgt;
 
 	return sgt;
 }
@@ -623,7 +601,7 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 	struct vb2_dc_buf *buf = mem_priv;
 	struct sg_table *sgt;
 	unsigned long contig_size;
-	int ret = 0;
+	int ret = -EFAULT;
 
 	if (WARN_ON(!buf->db_attach)) {
 		printk(KERN_ERR "trying to pin a non attached buffer\n");
@@ -642,12 +620,20 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 		return -EINVAL;
 	}
 
+	/* mapping new sglist to the client */
+	sgt->nents = dma_map_sg(buf->dev, sgt->sgl, sgt->orig_nents,
+		buf->dma_dir);
+	if (sgt->nents <= 0) {
+		printk(KERN_ERR "failed to map scatterlist\n");
+		goto fail_map_attachment;
+	}
+
 	/* checking if dmabuf is big enough to store contiguous chunk */
 	contig_size = vb2_dc_get_contiguous_size(sgt);
 	if (contig_size < buf->size) {
-		printk(KERN_ERR "contiguous chunk of dmabuf is too small\n");
-		ret = -EFAULT;
-		goto fail_map;
+		printk(KERN_ERR "contiguous chunk of dmabuf is too small "
+			"%lu/%lu bytes\n", contig_size, buf->size);
+		goto fail_map_sg;
 	}
 
 	buf->dma_addr = sg_dma_address(sgt->sgl);
@@ -655,7 +641,10 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 
 	return 0;
 
-fail_map:
+fail_map_sg:
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+
+fail_map_attachment:
 	dma_buf_unmap_attachment(buf->db_attach, sgt);
 
 	return ret;
@@ -676,6 +665,7 @@ static void vb2_dc_unmap_dmabuf(void *mem_priv)
 		return;
 	}
 
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	dma_buf_unmap_attachment(buf->db_attach, sgt);
 
 	buf->dma_addr = 0;
-- 
1.7.5.4

