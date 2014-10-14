Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:43873 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbaJNHQK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 03:16:10 -0400
Received: by mail-lb0-f171.google.com with SMTP id z12so7629799lbi.2
        for <linux-media@vger.kernel.org>; Tue, 14 Oct 2014 00:16:09 -0700 (PDT)
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kevin Hilman <khilman@linaro.org>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Pavel Machek <pavel@ucw.cz>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 7/7] [media] exynos-gsc: Do full clock gating at runtime PM suspend
Date: Tue, 14 Oct 2014 09:15:40 +0200
Message-Id: <1413270940-4378-8-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
References: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To potentially save more power in runtime PM suspend state, let's also
prepare/unprepare the clock from the runtime PM callbacks.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index e48aefa..e90ba09 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1161,7 +1161,7 @@ static int gsc_runtime_resume(struct device *dev)
 
 	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
 
-	ret = clk_enable(gsc->clock);
+	ret = clk_prepare_enable(gsc->clock);
 	if (ret)
 		return ret;
 
@@ -1179,7 +1179,7 @@ static int gsc_runtime_suspend(struct device *dev)
 
 	ret = gsc_m2m_suspend(gsc);
 	if (!ret)
-		clk_disable(gsc->clock);
+		clk_disable_unprepare(gsc->clock);
 
 	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
 	return ret;
-- 
1.9.1

