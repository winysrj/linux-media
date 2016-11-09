Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60632 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753161AbcKIOYQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:16 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 06/12] exynos-gsc: Do full clock gating at runtime PM suspend
Date: Wed, 09 Nov 2016 15:23:55 +0100
Message-id: <1478701441-29107-7-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142409eucas1p1cb35ebbee01d819417ed2565667e99f9@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulf Hansson <ulf.hansson@linaro.org>

To potentially save more power in runtime PM suspend state, let's also
prepare/unprepare the clock from the runtime PM callbacks.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[mszyprow: rebased onto v4.9-rc4]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 1d3bde3..9ba1619 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1141,7 +1141,7 @@ static int gsc_runtime_resume(struct device *dev)
 
 	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
 
-	ret = clk_enable(gsc->clock);
+	ret = clk_prepare_enable(gsc->clock);
 	if (ret)
 		return ret;
 
@@ -1159,7 +1159,7 @@ static int gsc_runtime_suspend(struct device *dev)
 
 	ret = gsc_m2m_suspend(gsc);
 	if (!ret)
-		clk_disable(gsc->clock);
+		clk_disable_unprepare(gsc->clock);
 
 	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
 	return ret;
-- 
1.9.1

