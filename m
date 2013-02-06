Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:53366 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3BFFol (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 00:44:41 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHS005ZPALFULP0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 14:44:39 +0900 (KST)
Received: from shaik-linux.sisodomain.com ([107.108.207.106])
 by mmp1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MHS00KORAM28HS0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 14:44:39 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com
Subject: [PATCH] [media] exynos-gsc: send valid m2m ctx to gsc_m2m_job_finish
Date: Wed, 06 Feb 2013 11:16:18 +0530
Message-id: <1360129578-22705-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gsc_m2m_job_finish() has to be called with the m2m context for the necessary
cleanup while resume. But currently gsc_m2m_job_finish() always passes m2m
context as NULL.

This patch preserves the context before making it null, for necessary cleanup.
Use gsc_m2m_opened() instead gsc_m2m_active() in gsc_resume().

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 99b841d..4d10845 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1054,16 +1054,18 @@ static int gsc_m2m_suspend(struct gsc_dev *gsc)
 
 static int gsc_m2m_resume(struct gsc_dev *gsc)
 {
+	struct gsc_ctx *ctx;
 	unsigned long flags;
 
 	spin_lock_irqsave(&gsc->slock, flags);
 	/* Clear for full H/W setup in first run after resume */
+	ctx = gsc->m2m.ctx;
 	gsc->m2m.ctx = NULL;
 	spin_unlock_irqrestore(&gsc->slock, flags);
 
 	if (test_and_clear_bit(ST_M2M_SUSPENDED, &gsc->state))
-		gsc_m2m_job_finish(gsc->m2m.ctx,
-				    VB2_BUF_STATE_ERROR);
+		gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+
 	return 0;
 }
 
@@ -1206,7 +1208,7 @@ static int gsc_resume(struct device *dev)
 	/* Do not resume if the device was idle before system suspend */
 	spin_lock_irqsave(&gsc->slock, flags);
 	if (!test_and_clear_bit(ST_SUSPEND, &gsc->state) ||
-	    !gsc_m2m_active(gsc)) {
+	    !gsc_m2m_opened(gsc)) {
 		spin_unlock_irqrestore(&gsc->slock, flags);
 		return 0;
 	}
-- 
1.7.9.5

