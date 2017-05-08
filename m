Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27153 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755246AbdEHPEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 11:04:38 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 15/18] vb2: Dma direction is always DMA_TO_DEVICE in buffer preparation
Date: Mon,  8 May 2017 18:03:27 +0300
Message-Id: <1494255810-12672-16-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch changes the DMA direction from DMA_FROM_DEVICE to DMA_TO_DEVICE
for capture buffers.

The DMA API does not require that any synchronisation is done to the
buffer when it is passed to hardware for writing _but_ there's a caveat:
the user *must not* have written to the buffer.

The V4L2 API does however not require this. Instead, it requires that the
user does not access the buffer since it is queued to the device using
VIDIOC_QBUF IOCTL until the buffer is dequeued again using VIDIOC_DQBUF
IOCTL.

So in this case we want to ensure there will be no dirty cache lines that
could end up to memory possibly after the device has written to the same
memory area. What data gets written to the system memory from the cache is
not extremely important. Still, an for debugging purposes an application
capturing images could fill the buffer with a known pattern which will be
overwritten by the device, hence DMA_TO_DEVICE.

If an application can guarantee that it has not written to the buffer, it
can specify the V4L2_BUF_FLAG_NO_CACHE_SYNC flag to omit the sync
operation.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 2 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index f572911..320e53a 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -103,7 +103,7 @@ static void vb2_dc_prepare(void *buf_priv)
 	 */
 	if (buf->attrs & DMA_ATTR_NON_CONSISTENT && !WARN_ON_ONCE(!sgt))
 		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
-				       buf->dma_dir);
+				       DMA_TO_DEVICE);
 }
 
 static void vb2_dc_finish(void *buf_priv)
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 5662f00..88b2530 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -206,7 +206,7 @@ static void vb2_dma_sg_prepare(void *buf_priv)
 	 */
 	if (buf->dma_attrs & DMA_ATTR_NON_CONSISTENT)
 		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
-				       buf->dma_dir);
+				       DMA_TO_DEVICE);
 }
 
 static void vb2_dma_sg_finish(void *buf_priv)
-- 
2.7.4
