Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61896 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3JDEqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 00:46:40 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	prathyush.k@samsung.com, arun.m@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH] [media] s5p-mfc: call wake_up_dev if in suspend mode
Date: Fri,  4 Oct 2013 10:17:19 +0530
Message-Id: <1380862039-30819-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Prathyush K <prathyush.k@samsung.com>

If a frame is still decoding when system enters suspend mode, we wait
on the device queue for a interrupt condition. This sometimes leads to a
timeout because the device queue might not be woken up everytime.
Usually, the context queue gets woken up when that context's frame gets
decoded. This patch adds a condition to wake up the device queue along
with the context queue when the system is in suspend mode.

Since the device queue is now woken up, we don't have to check the
context's int_cond flag while waiting. Also, we can skip calling try_run
after waking up the device queue to ensure that we don't have to wait
for more than one frame to be processed.

Signed-off-by: Prathyush K <prathyush.k@samsung.com>
Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 084263d..bec0f61 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -404,7 +404,11 @@ leave_handle_frame:
 	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 		BUG();
 	s5p_mfc_clock_off();
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	/* if suspending, wake up device and do not try_run again*/
+	if (test_bit(0, &dev->enter_suspend))
+		wake_up_dev(dev, reason, err);
+	else
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 }
 
 /* Error handling for interrupt */
@@ -1286,9 +1290,7 @@ static int s5p_mfc_suspend(struct device *dev)
 		/* Try and lock the HW */
 		/* Wait on the interrupt waitqueue */
 		ret = wait_event_interruptible_timeout(m_dev->queue,
-			m_dev->int_cond || m_dev->ctx[m_dev->curr_ctx]->int_cond,
-			msecs_to_jiffies(MFC_INT_TIMEOUT));
-
+			m_dev->int_cond, msecs_to_jiffies(MFC_INT_TIMEOUT));
 		if (ret == 0) {
 			mfc_err("Waiting for hardware to finish timed out\n");
 			return -EIO;
-- 
1.7.9.5

