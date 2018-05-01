Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-cys01nam02on0066.outbound.protection.outlook.com ([104.47.37.66]:59586
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752294AbeEABfY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 21:35:24 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Rohit Athavale <rathaval@xilinx.com>,
        Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v4 03/10] xilinx: v4l: dma: Update driver to allow for probe defer
Date: Mon, 30 Apr 2018 18:35:06 -0700
Message-ID: <6736d42d3e6b284188ebde3453050cd83cba090d.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rohit Athavale <rathaval@xilinx.com>

Update xvip_dma_init() to use dma_request_chan(), enabling probe
deferral. Also update the cleanup routine to prevent dereferencing
an ERR_PTR().

Signed-off-by: Rohit Athavale <rathaval@xilinx.com>
Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index a5bf345..16aeb46 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -730,10 +730,13 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 
 	/* ... and the DMA channel. */
 	snprintf(name, sizeof(name), "port%u", port);
-	dma->dma = dma_request_slave_channel(dma->xdev->dev, name);
-	if (dma->dma == NULL) {
-		dev_err(dma->xdev->dev, "no VDMA channel found\n");
-		ret = -ENODEV;
+	dma->dma = dma_request_chan(dma->xdev->dev, name);
+	if (IS_ERR(dma->dma)) {
+		ret = PTR_ERR(dma->dma);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dma->xdev->dev,
+				"No Video DMA channel found");
+
 		goto error;
 	}
 
@@ -757,7 +760,7 @@ void xvip_dma_cleanup(struct xvip_dma *dma)
 	if (video_is_registered(&dma->video))
 		video_unregister_device(&dma->video);
 
-	if (dma->dma)
+	if (!IS_ERR(dma->dma))
 		dma_release_channel(dma->dma);
 
 	media_entity_cleanup(&dma->video.entity);
-- 
2.1.1
