Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:25255 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3BFFpa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 00:45:30 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHS00IHUAN5FPC0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 14:45:29 +0900 (KST)
Received: from shaik-linux.sisodomain.com ([107.108.207.106])
 by mmp1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MHS00K16ANI8HT0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 14:45:28 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com
Subject: [PATCH] s5p-fimc: send valid m2m ctx to fimc_m2m_job_finish
Date: Wed, 06 Feb 2013 11:17:10 +0530
Message-id: <1360129630-22742-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fimc_m2m_job_finish() has to be called with the m2m context for the necessary
cleanup while resume. But currently fimc_m2m_job_finish() always passes m2m
context as NULL.

This patch preserves the context before making it null, for necessary cleanup.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 29f7bb7..a5d7cea 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -850,16 +850,18 @@ static int fimc_m2m_suspend(struct fimc_dev *fimc)
 
 static int fimc_m2m_resume(struct fimc_dev *fimc)
 {
+	struct fimc_ctx *ctx;
 	unsigned long flags;
 
 	spin_lock_irqsave(&fimc->slock, flags);
 	/* Clear for full H/W setup in first run after resume */
+	ctx = fimc->m2m.ctx;
 	fimc->m2m.ctx = NULL;
 	spin_unlock_irqrestore(&fimc->slock, flags);
 
 	if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
-		fimc_m2m_job_finish(fimc->m2m.ctx,
-				    VB2_BUF_STATE_ERROR);
+		fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+
 	return 0;
 }
 
-- 
1.7.9.5

