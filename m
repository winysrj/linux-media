Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40525 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752269AbcJZIwZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 04:52:25 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3 2/2] [media] videobuf2-dc: Support cacheable MMAP
Date: Wed, 26 Oct 2016 10:52:06 +0200
Message-Id: <1477471926-15796-3-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1477471926-15796-1-git-send-email-thierry.escande@collabora.com>
References: <1477471926-15796-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Heng-Ruey Hsu <henryhsu@chromium.org>

DMA allocations for MMAP type are uncached by default. But for
some cases, CPU has to access the buffers. ie: memcpy for format
converter. Supporting cacheable MMAP improves huge performance.

This patch enables cacheable memory for DMA coherent allocator in mmap
buffer allocation if non-consistent DMA attribute is set and kernel
mapping is present. Even if userspace doesn't mmap the buffer, sync
still should be happening if kernel mapping is present.
If not done in allocation, it is enabled when memory is mapped from
userspace (if non-consistent DMA attribute is set).

Signed-off-by: Heng-Ruey Hsu <henryhsu@chromium.org>
Tested-by: Heng-ruey Hsu <henryhsu@chromium.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 0d9665d..89b534a 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -151,6 +151,10 @@ static void vb2_dc_put(void *buf_priv)
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
@@ -192,6 +196,14 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 	buf->handler.put = vb2_dc_put;
 	buf->handler.arg = buf;
 
+	/*
+	 * Enable cache maintenance. Even if userspace doesn't mmap the buffer,
+	 * sync still should be happening if kernel mapping is present.
+	 */
+	if (!(buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
+	    buf->attrs & DMA_ATTR_NON_CONSISTENT)
+		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
+
 	atomic_inc(&buf->refcount);
 
 	return buf;
@@ -227,6 +239,10 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 
 	vma->vm_ops->open(vma);
 
+	/* Enable cache maintenance if not enabled in allocation. */
+	if (!buf->dma_sgt && buf->attrs & DMA_ATTR_NON_CONSISTENT)
+		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
+
 	pr_debug("%s: mapped dma addr 0x%08lx at 0x%08lx, size %ld\n",
 		__func__, (unsigned long)buf->dma_addr, vma->vm_start,
 		buf->size);
-- 
2.7.4

