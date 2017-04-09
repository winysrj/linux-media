Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36473 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752487AbdDIBfJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:35:09 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] [media] s5p-mfc: use setup_timer
Date: Sun,  9 Apr 2017 09:34:05 +0800
Message-Id: <f35bda17a884852135983ab4128976b9c220a768.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index bb0a588..2c363aa 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1266,9 +1266,8 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	dev->hw_lock = 0;
 	INIT_WORK(&dev->watchdog_work, s5p_mfc_watchdog_worker);
 	atomic_set(&dev->watchdog_cnt, 0);
-	init_timer(&dev->watchdog_timer);
-	dev->watchdog_timer.data = (unsigned long)dev;
-	dev->watchdog_timer.function = s5p_mfc_watchdog;
+	setup_timer(&dev->watchdog_timer, s5p_mfc_watchdog,
+		    (unsigned long)dev);
 
 	/* Initialize HW ops and commands based on MFC version */
 	s5p_mfc_init_hw_ops(dev);
-- 
2.9.3
