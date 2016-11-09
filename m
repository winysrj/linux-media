Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60632 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753525AbcKIOYN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:13 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 02/12] exynos-gsc: Convert gsc_m2m_resume() from int to void
Date: Wed, 09 Nov 2016 15:23:51 +0100
Message-id: <1478701441-29107-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142407eucas1p11730c21fb7320ba3271665afe92d2a1c@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulf Hansson <ulf.hansson@linaro.org>

Since gsc_m2m_resume() always returns 0, convert it to a void instead.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[mszyprow: rebased onto v4.9-rc4]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index abebbdb..cb4e8bd 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1010,7 +1010,7 @@ static int gsc_m2m_suspend(struct gsc_dev *gsc)
 	return timeout == 0 ? -EAGAIN : 0;
 }
 
-static int gsc_m2m_resume(struct gsc_dev *gsc)
+static void gsc_m2m_resume(struct gsc_dev *gsc)
 {
 	struct gsc_ctx *ctx;
 	unsigned long flags;
@@ -1023,8 +1023,6 @@ static int gsc_m2m_resume(struct gsc_dev *gsc)
 
 	if (test_and_clear_bit(ST_M2M_SUSPENDED, &gsc->state))
 		gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
-
-	return 0;
 }
 
 static int gsc_probe(struct platform_device *pdev)
@@ -1146,8 +1144,9 @@ static int gsc_runtime_resume(struct device *dev)
 
 	gsc_hw_set_sw_reset(gsc);
 	gsc_wait_reset(gsc);
+	gsc_m2m_resume(gsc);
 
-	return gsc_m2m_resume(gsc);
+	return 0;
 }
 
 static int gsc_runtime_suspend(struct device *dev)
-- 
1.9.1

