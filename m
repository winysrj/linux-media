Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50726 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753093AbcJNNV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 09:21:57 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] [media] videobuf2-dma-contig: Support cacheable MMAP
Date: Fri, 14 Oct 2016 15:21:49 +0200
Message-Id: <1476451309-10645-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Heng-Ruey Hsu <henryhsu@chromium.org>

DMA allocations for MMAP type are uncached by default. But for
some cases, CPU has to access the buffers. ie: memcpy for format
converter. Supporting cacheable MMAP improves huge performance.

Signed-off-by: Heng-Ruey Hsu <henryhsu@chromium.org>
Tested-by: Heng-ruey Hsu <henryhsu@chromium.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index fb6a177..c953c24 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -42,6 +42,12 @@ struct vb2_dc_buf {
 };
 
 /*********************************************/
+/*           Forward declarations            */
+/*********************************************/
+
+static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf);
+
+/*********************************************/
 /*        scatterlist table functions        */
 /*********************************************/
 
@@ -129,6 +135,10 @@ static void vb2_dc_put(void *buf_priv)
 		sg_free_table(buf->sgt_base);
 		kfree(buf->sgt_base);
 	}
+	if (buf->dma_sgt) {
+		sg_free_table(buf->dma_sgt);
+		kfree(buf->dma_sgt);
+	}
 	dma_free_attrs(buf->dev, buf->size, buf->cookie, buf->dma_addr,
 		       buf->attrs);
 	put_device(buf->dev);
@@ -170,6 +180,10 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 	buf->handler.put = vb2_dc_put;
 	buf->handler.arg = buf;
 
+	if (!(buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
+	     (buf->attrs & DMA_ATTR_NON_CONSISTENT))
+		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
+
 	atomic_inc(&buf->refcount);
 
 	return buf;
@@ -205,6 +219,11 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 
 	vma->vm_ops->open(vma);
 
+	if ((buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
+	    (buf->attrs & DMA_ATTR_NON_CONSISTENT) &&
+	    !buf->dma_sgt)
+		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
+
 	pr_debug("%s: mapped dma addr 0x%08lx at 0x%08lx, size %ld\n",
 		__func__, (unsigned long)buf->dma_addr, vma->vm_start,
 		buf->size);
-- 
2.7.4

