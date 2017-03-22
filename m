Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49429 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758514AbdCVHyK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 03:54:10 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] media: s5p-mfc: Fix unbalanced call to clock management
Date: Wed, 22 Mar 2017 08:53:57 +0100
Message-id: <1490169240-25957-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170322075405eucas1p1896d5fdc8729295cc775350e8e85ab62@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clock should be turned off after calling s5p_mfc_init_hw() from the
watchdog worker, like it is already done in the s5p_mfc_open() which also
calls this function.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: af93574678108 ("[media] MFC: Add MFC 5.1 V4L2 driver")
CC: stable@vger.kernel.org # v3.7+
---
This issue was there from the beggining of the driver, but this patch applies
cleanly only to v3.7+ kernels.
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 0c7ef6251252..76d4681a1c79 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -211,6 +211,7 @@ static void s5p_mfc_watchdog_worker(struct work_struct *work)
 		}
 		s5p_mfc_clock_on();
 		ret = s5p_mfc_init_hw(dev);
+		s5p_mfc_clock_off();
 		if (ret)
 			mfc_err("Failed to reinit FW\n");
 	}
-- 
1.9.1
