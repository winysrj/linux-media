Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:53216
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751987AbeECCnM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 22:43:12 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Vishal Sagar <vishal.sagar@xilinx.com>,
        Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v5 3/8] xilinx: v4l: dma: Terminate DMA when media pipeline fail to start
Date: Wed, 2 May 2018 19:42:48 -0700
Message-ID: <8d18eea81b7d477d3802ebf185f995082f948ac5.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vishal Sagar <vishal.sagar@xilinx.com>

If an incorrectly configured media pipeline is started, the allocated
dma descriptors aren't freed. This leads to kernel oops when pipeline
is configured correctly and run subsequently.

This patch also replaces dmaengine_terminate_all() with
dmaengine_terminate_sync() as the former one is deprecated.

Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 5426efe..727dc6e 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -437,6 +437,7 @@ static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
 	media_pipeline_stop(&dma->video.entity);
 
 error:
+	dmaengine_terminate_sync(dma->dma);
 	/* Give back all queued buffers to videobuf2. */
 	spin_lock_irq(&dma->queued_lock);
 	list_for_each_entry_safe(buf, nbuf, &dma->queued_bufs, queue) {
@@ -458,7 +459,7 @@ static void xvip_dma_stop_streaming(struct vb2_queue *vq)
 	xvip_pipeline_set_stream(pipe, false);
 
 	/* Stop and reset the DMA engine. */
-	dmaengine_terminate_all(dma->dma);
+	dmaengine_terminate_sync(dma->dma);
 
 	/* Cleanup the pipeline and mark it as being stopped. */
 	xvip_pipeline_cleanup(pipe);
-- 
2.7.4
