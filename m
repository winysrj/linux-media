Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45664 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2EWNHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:52 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H00EPN8D0GP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:05:26 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00DE68GVYM@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:44 +0100 (BST)
Date: Wed, 23 May 2012 15:07:35 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 12/12] v4l: vb2-dma-contig: Move allocation of dbuf attachment
 to attach cb
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-13-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The allocation of dma_buf_attachment is moved to attach callback.
The initialization is left in map callback.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   39 ++++++++++++++++++----------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index b5caf1d..3bf7c45 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -285,7 +285,15 @@ struct vb2_dc_attachment {
 static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
 	struct dma_buf_attachment *dbuf_attach)
 {
-	/* nothing to be done */
+	struct vb2_dc_attachment *attach;
+
+	attach = kzalloc(sizeof *attach, GFP_KERNEL);
+	if (!attach)
+		return -ENOMEM;
+
+	attach->dir = DMA_NONE;
+	dbuf_attach->priv = attach;
+
 	return 0;
 }
 
@@ -300,7 +308,9 @@ static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
 
 	sgt = &attach->sgt;
 
-	dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->nents, attach->dir);
+	/* checking if scaterlist was ever mapped */
+	if (attach->dir != DMA_NONE)
+		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->nents, attach->dir);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
@@ -314,25 +324,28 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 	struct vb2_dc_attachment *attach = db_attach->priv;
 	struct sg_table *sgt;
 	struct scatterlist *rd, *wr;
-	int i, ret;
+	int ret;
+	unsigned int i;
+
+	if (WARN_ON(dir == DMA_NONE))
+		return ERR_PTR(-EINVAL);
 
 	/* return previously mapped sg table */
-	if (attach)
+	if (attach->dir == dir)
 		return &attach->sgt;
 
-	attach = kzalloc(sizeof *attach, GFP_KERNEL);
-	if (!attach)
-		return ERR_PTR(-ENOMEM);
+	/* reattaching is not allowed */
+	if (WARN_ON(attach->dir != DMA_NONE))
+		return ERR_PTR(-EBUSY);
 
 	sgt = &attach->sgt;
-	attach->dir = dir;
 
-	/* copying the buf->base_sgt to attachment */
+	/* Copy the buf->base_sgt scatter list to the attachment, as we can't
+	 * map the same scatter list to multiple attachments at the same time.
+	 */
 	ret = sg_alloc_table(sgt, buf->sgt_base.orig_nents, GFP_KERNEL);
-	if (ret) {
-		kfree(attach);
+	if (ret)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	rd = buf->sgt_base.sgl;
 	wr = sgt->sgl;
@@ -347,10 +360,10 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 	if (ret <= 0) {
 		printk(KERN_ERR "failed to map scatterlist\n");
 		sg_free_table(sgt);
-		kfree(attach);
 		return ERR_PTR(-EIO);
 	}
 
+	attach->dir = dir;
 	db_attach->priv = attach;
 
 	return sgt;
-- 
1.7.9.5

