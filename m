Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0056.outbound.protection.outlook.com ([104.47.34.56]:43232
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752667AbeEABfZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 21:35:25 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v4 01/10] v4l: xilinx: dma: Remove colorspace check in xvip_dma_verify_format
Date: Mon, 30 Apr 2018 18:35:04 -0700
Message-ID: <3b02c211b800dd40bd6e34a193eca4a6842af950.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

In current implementation driver only checks the colorspace
between the last subdev in the pipeline and the connected video node,
the pipeline could be configured with wrong colorspace information
until the very end. It thus makes little sense to check the
colorspace only at the video node. So check can be dropped until
we find a better solution to carry colorspace information
through pipelines and to userspace.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 522cdfd..cb20ada 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -75,8 +75,7 @@ static int xvip_dma_verify_format(struct xvip_dma *dma)
 
 	if (dma->fmtinfo->code != fmt.format.code ||
 	    dma->format.height != fmt.format.height ||
-	    dma->format.width != fmt.format.width ||
-	    dma->format.colorspace != fmt.format.colorspace)
+	    dma->format.width != fmt.format.width)
 		return -EINVAL;
 
 	return 0;
-- 
2.1.1
