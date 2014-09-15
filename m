Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17415 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaIOGs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:48:59 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00LXSK9MQY30@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:48:58 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 11/17] [media] s5p-mfc: De-init MFC when watchdog kicks in
Date: Mon, 15 Sep 2014 12:13:06 +0530
Message-id: <1410763393-12183-12-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arun Mankuzhi <arun.m@samsung.com>

If the software watchdog kicks in, we need to de-init MFC
before reloading firmware and re-intializing it again.

Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index cc9fd0c..f4cb7f2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -167,6 +167,10 @@ static void s5p_mfc_watchdog_worker(struct work_struct *work)
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
1.7.3.rc2

