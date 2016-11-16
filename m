Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64098 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934006AbcKPJFY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:24 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 4/9] s5p-mfc: Ensure that clock is disabled before turning
 power off
Date: Wed, 16 Nov 2016 10:04:53 +0100
Message-id: <1479287098-30493-5-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
References: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161116090519eucas1p1021f0aab03499906974608d33aeac4eb@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move clock disabling before turning power off. This will enable later to
add calls to clk_prepare/unprepare in the s5p_mfc_power_off() function
to avoid keeping clocks prepared all the time when driver is bound.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index a0a29194ccd1..30ceae7eabc5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -963,11 +963,13 @@ static int s5p_mfc_release(struct file *file)
 			mfc_debug(2, "Last instance\n");
 			s5p_mfc_deinit_hw(dev);
 			del_timer_sync(&dev->watchdog_timer);
+			s5p_mfc_clock_off();
 			if (s5p_mfc_power_off() < 0)
 				mfc_err("Power off failed\n");
+		} else {
+			mfc_debug(2, "Shutting down clock\n");
+			s5p_mfc_clock_off();
 		}
-		mfc_debug(2, "Shutting down clock\n");
-		s5p_mfc_clock_off();
 	}
 	if (dev)
 		dev->ctx[ctx->num] = NULL;
-- 
1.9.1

