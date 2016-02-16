Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:34654 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbcBPCqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 21:46:40 -0500
From: Insu Yun <wuninsu@gmail.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@osg.samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] s5p_mfc: handling failed allocation for workqueue
Date: Mon, 15 Feb 2016 21:46:37 -0500
Message-Id: <1455590797-8522-1-git-send-email-wuninsu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

create_singlethread_workqueue() can be failed in memory pressure.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 927ab49..631aea814 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1239,6 +1239,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 
 	dev->hw_lock = 0;
 	dev->watchdog_workqueue = create_singlethread_workqueue(S5P_MFC_NAME);
+	if (!dev->watchdog_workqueue) {
+		ret = -ENOMEM;
+		goto err_enc_reg;
+	}
 	INIT_WORK(&dev->watchdog_work, s5p_mfc_watchdog_worker);
 	atomic_set(&dev->watchdog_cnt, 0);
 	init_timer(&dev->watchdog_timer);
-- 
1.9.1

