Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62106 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755258AbdEHPEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 11:04:38 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 16/18] vb2: Do sync plane cache only for CAPTURE buffers in finish memop
Date: Mon,  8 May 2017 18:03:28 +0300
Message-Id: <1494255810-12672-17-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need synchronise buffer cache for OUTPUT devices when the
buffer is dequeued as the hardware only reads from the buffer. Only sync
for capture buffers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 5 +++--
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 320e53a..41d5782 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -115,9 +115,10 @@ static void vb2_dc_finish(void *buf_priv)
 	 * DMABUF exporter will flush the cache for us; only USERPTR
 	 * and MMAP buffers with non-coherent memory will be flushed.
 	 */
-	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt))
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt) &&
+	    buf->dma_dir == DMA_FROM_DEVICE)
 		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents,
-				    buf->dma_dir);
+				    DMA_FROM_DEVICE);
 }
 
 /*********************************************/
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 88b2530..e30c869 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -218,9 +218,10 @@ static void vb2_dma_sg_finish(void *buf_priv)
 	 * DMABUF exporter will flush the cache for us; only USERPTR
 	 * and MMAP buffers with non-coherent memory will be flushed.
 	 */
-	if (buf->dma_attrs & DMA_ATTR_NON_CONSISTENT)
+	if (buf->dma_attrs & DMA_ATTR_NON_CONSISTENT &&
+	    buf->dma_dir == DMA_FROM_DEVICE)
 		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents,
-				    buf->dma_dir);
+				    DMA_FROM_DEVICE);
 }
 
 static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
-- 
2.7.4
