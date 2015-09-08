Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40850 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbbIHKf4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2015 06:35:56 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Subject: [RFC 11/11] vb2: dma-contig: Add WARN_ON_ONCE() to check for potential bugs
Date: Tue,  8 Sep 2015 13:33:55 +0300
Message-Id: <1441708435-12736-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441708435-12736-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441708435-12736-1-git-send-email-sakari.ailus@linux.intel.com>
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

