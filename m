Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64424 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbaIZE6S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 00:58:18 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NCH006IESH5BRE0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Sep 2014 13:58:17 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com, kiran@chromium.org
Subject: [PATCH v2 03/14] [media] s5p-mfc: clear 'enter_suspend' flag if
 suspend fails
Date: Fri, 26 Sep 2014 10:22:11 +0530
Message-id: <1411707142-4881-4-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
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
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d180440..e876839 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1279,11 +1279,17 @@ static int s5p_mfc_suspend(struct device *dev)
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

