Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61095 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753187AbcKIOYR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:17 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 11/12] exynos-gsc: Add missing newline char in debug messages
Date: Wed, 09 Nov 2016 15:24:00 +0100
Message-id: <1478701441-29107-12-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142411eucas1p1b3627f165173225e2ee763d9f75f30f7@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix missing newline char in debug messages.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index ff35909..ac4c96c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1138,7 +1138,7 @@ static int gsc_runtime_resume(struct device *dev)
 	struct gsc_dev *gsc = dev_get_drvdata(dev);
 	int ret = 0;
 
-	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
+	pr_debug("gsc%d: state: 0x%lx\n", gsc->id, gsc->state);
 
 	ret = clk_prepare_enable(gsc->clock);
 	if (ret)
@@ -1160,7 +1160,7 @@ static int gsc_runtime_suspend(struct device *dev)
 	if (!ret)
 		clk_disable_unprepare(gsc->clock);
 
-	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
+	pr_debug("gsc%d: state: 0x%lx\n", gsc->id, gsc->state);
 	return ret;
 }
 #endif
-- 
1.9.1

