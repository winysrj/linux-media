Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52045 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2EWNHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:47 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H000NL8GN1U@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:35 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00KKP8GW5D@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:45 +0100 (BST)
Date: Wed, 23 May 2012 15:07:28 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 05/12] v4l: vb2-dma-contig: add support for DMABUF exporting
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-6-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for exporting a dma-contig buffer using
DMABUF interface.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |  119 ++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index ae656be..b5826e0 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -325,6 +325,124 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 }
 
 /*********************************************/
+/*         DMABUF ops for exporters          */
+/*********************************************/
+
+struct vb2_dc_attachment {
+	struct sg_table sgt;
+	enum dma_data_direction dir;
+};
+
+static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
+	struct dma_buf_attachment *dbuf_attach)
+{
+	/* nothing to be done */
+	return 0;
+}
+
+static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
+	struct dma_buf_attachment *db_attach)
+{
+	struct vb2_dc_attachment *attach = db_attach->priv;
+	struct sg_table *sgt;
+
+	if (!attach)
+		return;
+
+	sgt = &attach->sgt;
+
+	dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->nents, attach->dir);
+	sg_free_table(sgt);
+	kfree(attach);
+	db_attach->priv = NULL;
+}
+
+static struct sg_table *vb2_dc_dmabuf_ops_map(
+	struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
+{
+	struct dma_buf *dbuf = db_attach->dmabuf;
+	struct vb2_dc_buf *buf = dbuf->priv;
+	struct vb2_dc_attachment *attach = db_attach->priv;
+	struct sg_table *sgt;
+	struct scatterlist *rd, *wr;
+	int i, ret;
+
+	/* return previously mapped sg table */
+	if (attach)
+		return &attach->sgt;
+
+	attach = kzalloc(sizeof *attach, GFP_KERNEL);
+	if (!attach)
+		return ERR_PTR(-ENOMEM);
+
+	sgt = &attach->sgt;
+	attach->dir = dir;
+
+	/* copying the buf->base_sgt to attachment */
+	ret = sg_alloc_table(sgt, buf->sgt_base->orig_nents, GFP_KERNEL);
+	if (ret) {
+		kfree(attach);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	rd = buf->sgt_base->sgl;
+	wr = sgt->sgl;
+	for (i = 0; i < sgt->orig_nents; ++i) {
+		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
+		rd = sg_next(rd);
+		wr = sg_next(wr);
+	}
+
+	/* mapping new sglist to the client */
+	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
+	if (ret <= 0) {
+		printk(KERN_ERR "failed to map scatterlist\n");
+		sg_free_table(sgt);
+		kfree(attach);
+		return ERR_PTR(-EIO);
+	}
+
+	db_attach->priv = attach;
+
+	return sgt;
+}
+
+static void vb2_dc_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
+	struct sg_table *sgt, enum dma_data_direction dir)
+{
+	/* nothing to be done here */
+}
+
+static void vb2_dc_dmabuf_ops_release(struct dma_buf *dbuf)
+{
+	/* drop reference obtained in vb2_dc_get_dmabuf */
+	vb2_dc_put(dbuf->priv);
+}
+
+static struct dma_buf_ops vb2_dc_dmabuf_ops = {
+	.attach = vb2_dc_dmabuf_ops_attach,
+	.detach = vb2_dc_dmabuf_ops_detach,
+	.map_dma_buf = vb2_dc_dmabuf_ops_map,
+	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
+	.release = vb2_dc_dmabuf_ops_release,
+};
+
+static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	struct dma_buf *dbuf;
+
+	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, 0);
+	if (IS_ERR(dbuf))
+		return NULL;
+
+	/* dmabuf keeps reference to vb2 buffer */
+	atomic_inc(&buf->refcount);
+
+	return dbuf;
+}
+
+/*********************************************/
 /*       callbacks for USERPTR buffers       */
 /*********************************************/
 
@@ -621,6 +739,7 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.alloc		= vb2_dc_alloc,
 	.put		= vb2_dc_put,
+	.get_dmabuf	= vb2_dc_get_dmabuf,
 	.cookie		= vb2_dc_cookie,
 	.vaddr		= vb2_dc_vaddr,
 	.mmap		= vb2_dc_mmap,
-- 
1.7.9.5

