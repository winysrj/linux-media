Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0082.outbound.protection.outlook.com ([104.47.32.82]:36667
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751969AbeECCnL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 22:43:11 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Rohit Athavale <rathaval@xilinx.com>,
        Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v5 2/8] xilinx: v4l: dma: Update driver to allow for probe defer
Date: Wed, 2 May 2018 19:42:47 -0700
Message-ID: <956455000d75b749cdaadea2662d09f4a905e056.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
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
index cb20ada..5426efe 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -729,10 +729,13 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 
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
 
@@ -756,7 +759,7 @@ void xvip_dma_cleanup(struct xvip_dma *dma)
 	if (video_is_registered(&dma->video))
 		video_unregister_device(&dma->video);
 
-	if (dma->dma)
+	if (!IS_ERR(dma->dma))
 		dma_release_channel(dma->dma);
 
 	media_entity_cleanup(&dma->video.entity);
-- 
2.7.4
