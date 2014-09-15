Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:62385 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaIOGsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:48:03 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00CU2K827G40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:48:02 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 04/17] [media] s5p-mfc: clear 'enter_suspend' flag if suspend
 fails
Date: Mon, 15 Sep 2014 12:12:59 +0530
Message-id: <1410763393-12183-5-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
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
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index ebfe381..e37fb99 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1312,11 +1312,17 @@ static int s5p_mfc_suspend(struct device *dev)
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
1.7.3.rc2

