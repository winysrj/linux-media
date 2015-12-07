Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21732 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbbLGMJl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2015 07:09:41 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4/7] media: vb2-dma-contig: add helper for setting dma max seg
 size
Date: Mon, 07 Dec 2015 13:08:59 +0100
Message-id: <1449490142-27502-5-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1449490142-27502-1-git-send-email-m.szyprowski@samsung.com>
References: <1449490142-27502-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a helper function for device drivers to set DMA's max_seg_size.
Setting it to largest possible value lets DMA-mapping API always create
contiguous mappings in DMA address space. This is essential for all
devices, which use dma-contig videobuf2 memory allocator and shared
buffers.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
Changelog:
v3:
- make this code a helper function instead of chaning max_seg_size
  unconditionally on vb2_dma_contig_init_ctx

v2:
- set max segment size only if a new dma params structure has been
  allocated, as suggested by Laurent Pinchart
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 15 +++++++++++++++
 include/media/videobuf2-dma-contig.h           |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index c33127284cfe..628518dc3aad 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -742,6 +742,21 @@ void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
 }
 EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
 
+int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
+{
+	if (!dev->dma_parms) {
+		dev->dma_parms = devm_kzalloc(dev, sizeof(dev->dma_parms),
+					      GFP_KERNEL);
+		if (!dev->dma_parms)
+			return -ENOMEM;
+	}
+	if (dma_get_max_seg_size(dev) < size)
+		return dma_set_max_seg_size(dev, size);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_dma_contig_set_max_seg_size);
+
 MODULE_DESCRIPTION("DMA-contig memory handling routines for videobuf2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index c33dfa69d7ab..0e6ba644939e 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -26,6 +26,7 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 
 void *vb2_dma_contig_init_ctx(struct device *dev);
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
+int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size);
 
 extern const struct vb2_mem_ops vb2_dma_contig_memops;
 
-- 
1.9.2

