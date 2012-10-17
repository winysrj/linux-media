Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42343 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab2JQLQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 07:16:43 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so6997024pad.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 04:16:43 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 5/8] [media] exynos-gsc: Use clk_prepare_enable and clk_disable_unprepare
Date: Wed, 17 Oct 2012 16:41:48 +0530
Message-Id: <1350472311-9748-5-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace clk_enable/clk_disable with clk_prepare_enable/clk_disable_unprepare
as required by the common clock framework.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index bfec9e6..d11668b 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1009,7 +1009,7 @@ static int gsc_clk_get(struct gsc_dev *gsc)
 	if (IS_ERR(gsc->clock))
 		goto err_print;
 
-	ret = clk_prepare(gsc->clock);
+	ret = clk_prepare_enable(gsc->clock);
 	if (ret < 0) {
 		clk_put(gsc->clock);
 		gsc->clock = NULL;
@@ -1186,7 +1186,7 @@ static int gsc_runtime_suspend(struct device *dev)
 
 	ret = gsc_m2m_suspend(gsc);
 	if (!ret)
-		clk_disable(gsc->clock);
+		clk_disable_unprepare(gsc->clock);
 
 	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
 	return ret;
-- 
1.7.4.1

