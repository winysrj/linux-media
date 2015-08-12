Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39136 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbHLJ7A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 05:59:00 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NSY00DECRQAEJ20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Aug 2015 10:58:58 +0100 (BST)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2] media: videobuf2-dc: set properly dma_max_segment_size
Date: Wed, 12 Aug 2015 11:58:53 +0200
Message-id: <1439373533-23299-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If device has no DMA max_seg_size set, we assume that there is no limit
and it is safe to force it to use DMA_BIT_MASK(32) as max_seg_size to
let DMA-mapping API always create contiguous mappings in DMA address
space. This is essential for all devices, which use dma-contig
videobuf2 memory allocator.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
Changelog:
v2:
- set max segment size only if a new dma params structure has been
  allocated, as suggested by Laurent Pinchart
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 94c1e64..455e925 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -862,6 +862,21 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 void *vb2_dma_contig_init_ctx(struct device *dev)
 {
 	struct vb2_dc_conf *conf;
+	int err;
+
+	/*
+	 * if device has no max_seg_size set, we assume that there is no limit
+	 * and force it to DMA_BIT_MASK(32) to always use contiguous mappings
+	 * in DMA address space
+	 */
+	if (!dev->dma_parms) {
+		dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);
+		if (!dev->dma_parms)
+			return ERR_PTR(-ENOMEM);
+		err = dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
+		if (err)
+			return ERR_PTR(err);
+	}
 
 	conf = kzalloc(sizeof *conf, GFP_KERNEL);
 	if (!conf)
-- 
1.9.2

