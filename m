Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:57619 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbbIKLwa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 07:52:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	sumit.semwal@linaro.org, robdclark@gmail.com,
	daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC RESEND 07/11] vb2: dma-contig: Remove redundant sgt_base field
Date: Fri, 11 Sep 2015 14:50:30 +0300
Message-Id: <1441972234-8643-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct vb2_dc_buf contains two struct sg_table fields: sgt_base and
dma_sgt. The former is used by DMA-BUF buffers whereas the latter is used
by USERPTR.

Unify the two, leaving dma_sgt.

MMAP buffers do not need cache flushing since they have been allocated
using dma_alloc_coherent().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 94c1e64..26a0a0f 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -36,7 +36,6 @@ struct vb2_dc_buf {
 	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
 	atomic_t			refcount;
-	struct sg_table			*sgt_base;
 
 	/* USERPTR related */
 	struct vm_area_struct		*vma;
@@ -117,7 +116,7 @@ static void vb2_dc_prepare(void *buf_priv)
 	struct sg_table *sgt = buf->dma_sgt;
 
 	/* DMABUF exporter will flush the cache for us */
-	if (!sgt || buf->db_attach)
+	if (!buf->vma)
 		return;
 
 	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
@@ -129,7 +128,7 @@ static void vb2_dc_finish(void *buf_priv)
 	struct sg_table *sgt = buf->dma_sgt;
 
 	/* DMABUF exporter will flush the cache for us */
-	if (!sgt || buf->db_attach)
+	if (!buf->vma)
 		return;
 
 	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
@@ -146,9 +145,9 @@ static void vb2_dc_put(void *buf_priv)
 	if (!atomic_dec_and_test(&buf->refcount))
 		return;
 
-	if (buf->sgt_base) {
-		sg_free_table(buf->sgt_base);
-		kfree(buf->sgt_base);
+	if (buf->dma_sgt) {
+		sg_free_table(buf->dma_sgt);
+		kfree(buf->dma_sgt);
 	}
 	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
 	put_device(buf->dev);
@@ -252,13 +251,13 @@ static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
 	/* Copy the buf->base_sgt scatter list to the attachment, as we can't
 	 * map the same scatter list to multiple attachments at the same time.
 	 */
-	ret = sg_alloc_table(sgt, buf->sgt_base->orig_nents, GFP_KERNEL);
+	ret = sg_alloc_table(sgt, buf->dma_sgt->orig_nents, GFP_KERNEL);
 	if (ret) {
 		kfree(attach);
 		return -ENOMEM;
 	}
 
-	rd = buf->sgt_base->sgl;
+	rd = buf->dma_sgt->sgl;
 	wr = sgt->sgl;
 	for (i = 0; i < sgt->orig_nents; ++i) {
 		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
@@ -409,10 +408,10 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 	exp_info.flags = flags;
 	exp_info.priv = buf;
 
-	if (!buf->sgt_base)
-		buf->sgt_base = vb2_dc_get_base_sgt(buf);
+	if (!buf->dma_sgt)
+		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
 
-	if (WARN_ON(!buf->sgt_base))
+	if (WARN_ON(!buf->dma_sgt))
 		return NULL;
 
 	dbuf = dma_buf_export(&exp_info);
-- 
2.1.0.231.g7484e3b

