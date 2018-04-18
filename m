Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.154]:27403 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753821AbeDRNNs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 09:13:48 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 7427B400CF2ED
        for <linux-media@vger.kernel.org>; Wed, 18 Apr 2018 07:50:18 -0500 (CDT)
Date: Wed, 18 Apr 2018 07:50:16 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] staging: media: davinci_vpfe: fix spin_lock/unlock imbalance
Message-ID: <20180418125016.GA25606@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that this is a copy-paste error and that the proper
variable to use in this particular case is video_out2 instead
of video_out.

Addresses-Coverity-ID: 1467961 ("Copy-paste error")
Fixes: 45e46b3bbe18 ("[media] davinci: vpfe: dm365: resizer driver based on media framework")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index df6d55e..2b79747 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1060,7 +1060,7 @@ static void resizer_ss_isr(struct vpfe_resizer_device *resizer)
 	/* If resizer B is enabled */
 	if (pipe->output_num > 1 && resizer->resizer_b.output ==
 	    RESIZER_OUTPUT_MEMORY) {
-		spin_lock(&video_out->dma_queue_lock);
+		spin_lock(&video_out2->dma_queue_lock);
 		vpfe_video_process_buffer_complete(video_out2);
 		video_out2->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
 		vpfe_video_schedule_next_buffer(video_out2);
-- 
2.7.4
