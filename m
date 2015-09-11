Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20267 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbbIKLwa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 07:52:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	sumit.semwal@linaro.org, robdclark@gmail.com,
	daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC RESEND 08/11] vb2: dma-contig: Move vb2_dc_get_base_sgt() up
Date: Fri, 11 Sep 2015 14:50:31 +0300
Message-Id: <1441972234-8643-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just move the function up. It'll be soon needed earlier than previously.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 44 +++++++++++++-------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 26a0a0f..3260392 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -82,6 +82,28 @@ static unsigned long vb2_dc_get_contiguous_size(struct sg_table *sgt)
 	return size;
 }
 
+static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
+{
+	int ret;
+	struct sg_table *sgt;
+
+	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
+	if (!sgt) {
+		dev_err(buf->dev, "failed to alloc sg table\n");
+		return NULL;
+	}
+
+	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
+		buf->size);
+	if (ret < 0) {
+		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
+		kfree(sgt);
+		return NULL;
+	}
+
+	return sgt;
+}
+
 /*********************************************/
 /*         callbacks for all buffers         */
 /*********************************************/
@@ -375,28 +397,6 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.release = vb2_dc_dmabuf_ops_release,
 };
 
-static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
-{
-	int ret;
-	struct sg_table *sgt;
-
-	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
-	if (!sgt) {
-		dev_err(buf->dev, "failed to alloc sg table\n");
-		return NULL;
-	}
-
-	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
-		buf->size);
-	if (ret < 0) {
-		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
-		kfree(sgt);
-		return NULL;
-	}
-
-	return sgt;
-}
-
 static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 {
 	struct vb2_dc_buf *buf = buf_priv;
-- 
2.1.0.231.g7484e3b

