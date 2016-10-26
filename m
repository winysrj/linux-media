Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40515 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbcJZIwZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 04:52:25 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3 1/2] [media] videobuf2-dc: Move vb2_dc_get_base_sgt() above mmap callbacks
Date: Wed, 26 Oct 2016 10:52:05 +0200
Message-Id: <1477471926-15796-2-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1477471926-15796-1-git-send-email-thierry.escande@collabora.com>
References: <1477471926-15796-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves vb2_dc_get_base_sgt() function above mmap buffers
callbacks, particularly vb2_dc_alloc() and vb2_dc_mmap() from where it
will be called for cacheable MMAP support introduced in the next patch.

Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 44 +++++++++++++-------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index a44e383..0d9665d 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -61,6 +61,28 @@ static unsigned long vb2_dc_get_contiguous_size(struct sg_table *sgt)
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
+	ret = dma_get_sgtable_attrs(buf->dev, sgt, buf->cookie, buf->dma_addr,
+		buf->size, buf->attrs);
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
@@ -363,28 +385,6 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
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
-	ret = dma_get_sgtable_attrs(buf->dev, sgt, buf->cookie, buf->dma_addr,
-		buf->size, buf->attrs);
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
2.7.4

