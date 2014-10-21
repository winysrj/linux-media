Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34289 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaJULIC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:08:02 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	kiran@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH v3 09/13] [media] s5p-mfc: De-init MFC when watchdog kicks in
Date: Tue, 21 Oct 2014 16:37:03 +0530
Message-Id: <1413889627-8431-10-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
References: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arun Mankuzhi <arun.m@samsung.com>

If the software watchdog kicks in, we need to de-init MFC
before reloading firmware and re-intializing it again.

Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8620236..39f8f2a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -159,6 +159,10 @@ static void s5p_mfc_watchdog_worker(struct work_struct *work)
 	}
 	clear_bit(0, &dev->hw_lock);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	/* De-init MFC */
+	s5p_mfc_deinit_hw(dev);
+
 	/* Double check if there is at least one instance running.
 	 * If no instance is in memory than no firmware should be present */
 	if (dev->num_inst > 0) {
-- 
1.7.9.5

