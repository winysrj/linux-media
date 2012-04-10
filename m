Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16881 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729Ab2DJNKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 09:10:55 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2900LLSLWHV7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:09:54 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900G9JLY1GU@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:49 +0100 (BST)
Date: Tue, 10 Apr 2012 15:10:42 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 08/13] v4l: vb2-dma-contig: change map/unmap behaviour for
 exporters
In-reply-to: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334063447-16824-9-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
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
 drivers/media/video/videobuf2-dma-contig.c |   42 ++++++---------------------
 1 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 7f4a58a..a6676bd 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -312,11 +312,6 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
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
@@ -327,17 +322,13 @@ static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
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
 
@@ -346,26 +337,22 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
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
 
@@ -377,16 +364,7 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
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
-- 
1.7.5.4

