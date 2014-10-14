Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:51261 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaJNHP6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 03:15:58 -0400
Received: by mail-la0-f41.google.com with SMTP id pn19so7989827lab.14
        for <linux-media@vger.kernel.org>; Tue, 14 Oct 2014 00:15:57 -0700 (PDT)
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
Subject: [PATCH 2/7] [media] exynos-gsc: Convert gsc_m2m_resume() from int to void
Date: Tue, 14 Oct 2014 09:15:35 +0200
Message-Id: <1413270940-4378-3-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
References: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since gsc_m2m_resume() always returns 0, convert it into void instead.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 3fca4fd..13d0226 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1022,7 +1022,7 @@ static int gsc_m2m_suspend(struct gsc_dev *gsc)
 	return timeout == 0 ? -EAGAIN : 0;
 }
 
-static int gsc_m2m_resume(struct gsc_dev *gsc)
+static void gsc_m2m_resume(struct gsc_dev *gsc)
 {
 	struct gsc_ctx *ctx;
 	unsigned long flags;
@@ -1035,8 +1035,6 @@ static int gsc_m2m_resume(struct gsc_dev *gsc)
 
 	if (test_and_clear_bit(ST_M2M_SUSPENDED, &gsc->state))
 		gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
-
-	return 0;
 }
 
 static int gsc_probe(struct platform_device *pdev)
@@ -1165,8 +1163,9 @@ static int gsc_runtime_resume(struct device *dev)
 
 	gsc_hw_set_sw_reset(gsc);
 	gsc_wait_reset(gsc);
+	gsc_m2m_resume(gsc);
 
-	return gsc_m2m_resume(gsc);
+	return 0;
 }
 
 static int gsc_runtime_suspend(struct device *dev)
-- 
1.9.1

