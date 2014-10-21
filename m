Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45526 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaJULHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:07:34 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	kiran@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH v3 03/13] [media] s5p-mfc: clear 'enter_suspend' flag if suspend fails
Date: Tue, 21 Oct 2014 16:36:57 +0530
Message-Id: <1413889627-8431-4-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
References: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Prathyush K <prathyush.k@samsung.com>

The enter_suspend flag is set after we enter mfc suspend function but if
suspend fails after that due to any reason (like hardware timeout etc),
this flag must be cleared before returning an error. Otherwise, this
flag never gets cleared and the MFC suspend will always return an error
on subsequent tries. If clock off fails, disable hw_lock also.

Signed-off-by: Prathyush K <prathyush.k@samsung.com>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 165bc86..79c9537 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1284,11 +1284,17 @@ static int s5p_mfc_suspend(struct device *dev)
 			m_dev->int_cond, msecs_to_jiffies(MFC_INT_TIMEOUT));
 		if (ret == 0) {
 			mfc_err("Waiting for hardware to finish timed out\n");
+			clear_bit(0, &m_dev->enter_suspend);
 			return -EIO;
 		}
 	}
 
-	return s5p_mfc_sleep(m_dev);
+	ret = s5p_mfc_sleep(m_dev);
+	if (ret) {
+		clear_bit(0, &m_dev->enter_suspend);
+		clear_bit(0, &m_dev->hw_lock);
+	}
+	return ret;
 }
 
 static int s5p_mfc_resume(struct device *dev)
-- 
1.7.9.5

