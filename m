Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6782 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751058AbdHCMwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Aug 2017 08:52:21 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: use relevant lock
Date: Thu,  3 Aug 2017 14:26:52 +0200
Message-Id: <1501763212-1394-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The data protected is video_out2 and the lock that is released is
&video_out2->dma_queue_lock, so it seems that that lock should be
taken as well.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 857b0e8..4910cb7 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1059,7 +1059,7 @@ static void resizer_ss_isr(struct vpfe_resizer_device *resizer)
 	/* If resizer B is enabled */
 	if (pipe->output_num > 1 && resizer->resizer_b.output ==
 	    RESIZER_OUTPUT_MEMORY) {
-		spin_lock(&video_out->dma_queue_lock);
+		spin_lock(&video_out2->dma_queue_lock);
 		vpfe_video_process_buffer_complete(video_out2);
 		video_out2->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
 		vpfe_video_schedule_next_buffer(video_out2);
