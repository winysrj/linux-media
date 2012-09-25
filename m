Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab2IYN2p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 09:28:45 -0400
Date: Tue, 25 Sep 2012 10:28:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fw: [PATCH] [media] s5p-mfc: Remove unreachable code
Message-ID: <20120925102839.2a90ab26@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Please review.

Thanks!
Mauro

Forwarded message:

Date: Fri, 14 Sep 2012 14:50:17 +0530
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com, k.debski@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5p-mfc: Remove unreachable code


Code after return statement never gets executed.
Hence can be deleted.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index e3e616d..56876be 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1144,30 +1144,11 @@ static int s5p_mfc_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct s5p_mfc_dev *m_dev = platform_get_drvdata(pdev);
-	int ret;
 
 	if (m_dev->num_inst == 0)
 		return 0;
-	return s5p_mfc_sleep(m_dev);
-	if (test_and_set_bit(0, &m_dev->enter_suspend) != 0) {
-		mfc_err("Error: going to suspend for a second time\n");
-		return -EIO;
-	}
 
-	/* Check if we're processing then wait if it necessary. */
-	while (test_and_set_bit(0, &m_dev->hw_lock) != 0) {
-		/* Try and lock the HW */
-		/* Wait on the interrupt waitqueue */
-		ret = wait_event_interruptible_timeout(m_dev->queue,
-			m_dev->int_cond || m_dev->ctx[m_dev->curr_ctx]->int_cond,
-			msecs_to_jiffies(MFC_INT_TIMEOUT));
-
-		if (ret == 0) {
-			mfc_err("Waiting for hardware to finish timed out\n");
-			return -EIO;
-		}
-	}
-	return 0;
+	return s5p_mfc_sleep(m_dev);
 }
 
 static int s5p_mfc_resume(struct device *dev)
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Regards,
Mauro
