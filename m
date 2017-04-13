Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19302 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751256AbdDMH6E (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 03:58:04 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC v3 11/14] vb2: dma-contig: Add WARN_ON_ONCE() to check for potential bugs
Date: Thu, 13 Apr 2017 10:57:16 +0300
Message-Id: <1492070239-21532-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The scatterlist should always be present when the cache would need to be
flushed. Each buffer type has its own means to provide that. Add
WARN_ON_ONCE() to check the scatterist exists.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 6a707d3..2847fbf 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -120,7 +120,7 @@ static void vb2_dc_prepare(void *buf_priv)
 	 * DMABUF exporter will flush the cache for us; only USERPTR
 	 * and MMAP buffers with non-coherent memory will be flushed.
 	 */
-	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt))
 		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
 				       buf->dma_dir);
 }
@@ -134,7 +134,7 @@ static void vb2_dc_finish(void *buf_priv)
 	 * DMABUF exporter will flush the cache for us; only USERPTR
 	 * and MMAP buffers with non-coherent memory will be flushed.
 	 */
-	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt))
 		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents,
 				    buf->dma_dir);
 }
@@ -380,7 +380,7 @@ static int vb2_dc_dmabuf_ops_begin_cpu_access(struct dma_buf *dbuf,
 	 * DMABUF exporter will flush the cache for us; only USERPTR
 	 * and MMAP buffers with non-coherent memory will be flushed.
 	 */
-	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt))
 		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents,
 				    buf->dma_dir);
 
@@ -397,7 +397,7 @@ static int vb2_dc_dmabuf_ops_end_cpu_access(struct dma_buf *dbuf,
 	 * DMABUF exporter will flush the cache for us; only USERPTR
 	 * and MMAP buffers with non-coherent memory will be flushed.
 	 */
-	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt))
 		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents,
 				       buf->dma_dir);
 
-- 
2.7.4
