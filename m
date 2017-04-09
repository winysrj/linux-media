Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35298 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752198AbdDIBf0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:35:26 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] [media] wl128x: use setup_timer
Date: Sun,  9 Apr 2017 09:34:07 +0800
Message-Id: <51e22bc38526ec47c01030147761a873fac3e894.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 74a1b3e..588e2d6 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1550,9 +1550,8 @@ int fmc_prepare(struct fmdev *fmdev)
 	atomic_set(&fmdev->tx_cnt, 1);
 	fmdev->resp_comp = NULL;
 
-	init_timer(&fmdev->irq_info.timer);
-	fmdev->irq_info.timer.function = &int_timeout_handler;
-	fmdev->irq_info.timer.data = (unsigned long)fmdev;
+	setup_timer(&fmdev->irq_info.timer, &int_timeout_handler,
+		    (unsigned long)fmdev);
 	/*TODO: add FM_STIC_EVENT later */
 	fmdev->irq_info.mask = FM_MAL_EVENT;
 
-- 
2.9.3
