Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0040.outbound.protection.outlook.com ([104.47.38.40]:60288
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752531AbeEABfZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 21:35:25 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v4 02/10] xilinx: v4l: dma: Use the dmaengine_terminate_all() wrapper
Date: Mon, 30 Apr 2018 18:35:05 -0700
Message-ID: <2e5f2c04ea48a617f86206c1b7f0f799649fa6dc.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Calling dmaengine_device_control() to terminate transfers is an internal
API that will disappear, use the stable API wrapper instead.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index cb20ada..a5bf345 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -434,6 +434,7 @@ static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 
 error_stop:
+	dmaengine_terminate_all(dma->dma);
 	media_pipeline_stop(&dma->video.entity);
 
 error:
-- 
2.1.1
