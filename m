Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:40792 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754679AbcHWNjx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 09:39:53 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <mchehab@kernel.org>
CC: <hans.verkuil@cisco.com>, <nenggun.kim@samsung.com>,
        <jh1009.sung@samsung.com>, <sw0312.kim@samsung.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] [media] m2m-deinterlace: Fix error print during probe
Date: Tue, 23 Aug 2016 16:39:39 +0300
Message-ID: <20160823133939.2890-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_err() can not be used for printing error for missing interleaved
support in DMA as this point the pcdev->v4l2_dev is not valid.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/media/platform/m2m-deinterlace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 0fcb5c78031d..5a5dec348f4d 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -1016,7 +1016,7 @@ static int deinterlace_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if (!dma_has_cap(DMA_INTERLEAVE, pcdev->dma_chan->device->cap_mask)) {
-		v4l2_err(&pcdev->v4l2_dev, "DMA does not support INTERLEAVE\n");
+		dev_err(&pdev->dev, "DMA does not support INTERLEAVE\n");
 		goto rel_dma;
 	}
 
-- 
2.9.2

