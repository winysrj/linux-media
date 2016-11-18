Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:60380 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753676AbcKRXVW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:22 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 26/35] media: ti-vpe: vpdma: Use bidirectional cached buffers
Date: Fri, 18 Nov 2016 17:20:36 -0600
Message-ID: <20161118232045.24665-27-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

VPDMA buffer will be used by CPU as well as by the VPDMA.
CPU will write/update the VPDMA descriptors containing data
about the video buffer DMA addresses.
VPDMA will write the "write descriptor" containing the
data about the DMA operation.

When mapping/unmapping the buffer, driver has to take care of
WriteBack and invalidation of the cache so that all the
coherency is maintained from both directions.

Use DMA_BIDIRECTIONAL to maintain coherency between CPU and VPDMA.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 070937fe1af6..2d13644a28a8 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -367,7 +367,7 @@ int vpdma_map_desc_buf(struct vpdma_data *vpdma, struct vpdma_buf *buf)
 
 	WARN_ON(buf->mapped);
 	buf->dma_addr = dma_map_single(dev, buf->addr, buf->size,
-				DMA_TO_DEVICE);
+				DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, buf->dma_addr)) {
 		dev_err(dev, "failed to map buffer\n");
 		return -EINVAL;
@@ -388,7 +388,8 @@ void vpdma_unmap_desc_buf(struct vpdma_data *vpdma, struct vpdma_buf *buf)
 	struct device *dev = &vpdma->pdev->dev;
 
 	if (buf->mapped)
-		dma_unmap_single(dev, buf->dma_addr, buf->size, DMA_TO_DEVICE);
+		dma_unmap_single(dev, buf->dma_addr, buf->size,
+				DMA_BIDIRECTIONAL);
 
 	buf->mapped = false;
 }
-- 
2.9.0

