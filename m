Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27153 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755087AbdEHPEh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 11:04:37 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 11/18] vb2: dma-contig: Add WARN_ON_ONCE() to check for potential bugs
Date: Mon,  8 May 2017 18:03:23 +0300
Message-Id: <1494255810-12672-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 8b0298a..f572911 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -101,7 +101,7 @@ static void vb2_dc_prepare(void *buf_priv)
 	 * DMABUF exporter will flush the cache for us; only USERPTR
 	 * and MMAP buffers with non-coherent memory will be flushed.
 	 */
-	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt))
 		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
 				       buf->dma_dir);
 }
@@ -115,7 +115,7 @@ static void vb2_dc_finish(void *buf_priv)
 	 * DMABUF exporter will flush the cache for us; only USERPTR
 	 * and MMAP buffers with non-coherent memory will be flushed.
 	 */
-	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt))
 		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents,
 				    buf->dma_dir);
 }
@@ -363,7 +363,7 @@ static int vb2_dc_dmabuf_ops_begin_cpu_access(struct dma_buf *dbuf,
 	 * DMABUF exporter will flush the cache for us; only USERPTR
 	 * and MMAP buffers with non-coherent memory will be flushed.
 	 */
-	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt))
 		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents,
 				    buf->dma_dir);
 
@@ -380,7 +380,7 @@ static int vb2_dc_dmabuf_ops_end_cpu_access(struct dma_buf *dbuf,
 	 * DMABUF exporter will flush the cache for us; only USERPTR
 	 * and MMAP buffers with non-coherent memory will be flushed.
 	 */
-	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt))
 		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents,
 				       buf->dma_dir);
 
-- 
2.7.4
