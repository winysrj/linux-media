Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:33585 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3ARJjw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 04:39:52 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGT00C77EUE9DW0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Jan 2013 18:39:50 +0900 (KST)
Received: from chrome-ubuntu.sisodomain.com ([107.108.73.106])
 by mmp1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MGT00HHDETSPZ00@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Jan 2013 18:39:50 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com
Subject: [PATCH] s5p-fimc: set m2m context to null at the end of fimc_m2m_resume
Date: Fri, 18 Jan 2013 05:01:18 -0500
Message-id: <1358503278-13414-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fimc_m2m_job_finish() has to be called with the m2m context for the necessary
cleanup while resume. But currently fimc_m2m_job_finish() always passes
fimc->m2m.ctx as NULL.

This patch changes the order of the calls for proper cleanup while resume.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 2a1558a..5b11544 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -868,14 +868,15 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 {
 	unsigned long flags;
 
+	if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
+		fimc_m2m_job_finish(fimc->m2m.ctx,
+				    VB2_BUF_STATE_ERROR);
+
 	spin_lock_irqsave(&fimc->slock, flags);
 	/* Clear for full H/W setup in first run after resume */
 	fimc->m2m.ctx = NULL;
 	spin_unlock_irqrestore(&fimc->slock, flags);
 
-	if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
-		fimc_m2m_job_finish(fimc->m2m.ctx,
-				    VB2_BUF_STATE_ERROR);
 	return 0;
 }
 
-- 
1.8.0

