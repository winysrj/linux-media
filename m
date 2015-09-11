Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12487 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbbIKLwa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 07:52:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	sumit.semwal@linaro.org, robdclark@gmail.com,
	daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC RESEND 11/11] vb2: dma-contig: Add WARN_ON_ONCE() to check for potential bugs
Date: Fri, 11 Sep 2015 14:50:34 +0300
Message-Id: <1441972234-8643-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The scatterlist should always be present when the cache would need to be
flushed. Each buffer type has its own means to provide that. Add
WARN_ON_ONCE() to check the scatterist exists.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 65ee122..58c35c5 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -145,6 +145,9 @@ static void vb2_dc_prepare(void *buf_priv)
 	    !dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs))
 		return;
 
+	if (WARN_ON_ONCE(!sgt))
+		return;
+
 	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 }
 
@@ -161,6 +164,9 @@ static void vb2_dc_finish(void *buf_priv)
 	    !dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs))
 		return;
 
+	if (WARN_ON_ONCE(!sgt))
+		return;
+
 	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 }
 
-- 
2.1.0.231.g7484e3b

