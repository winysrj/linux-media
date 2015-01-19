Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33910 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbbASNXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 08:23:00 -0500
Received: by mail-la0-f46.google.com with SMTP id s18so7851917lam.5
        for <linux-media@vger.kernel.org>; Mon, 19 Jan 2015 05:22:59 -0800 (PST)
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH V2 2/8] [media] exynos-gsc: Convert gsc_m2m_resume() from int to void
Date: Mon, 19 Jan 2015 14:22:34 +0100
Message-Id: <1421673760-2600-3-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
References: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since gsc_m2m_resume() always returns 0, convert it to a void instead.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index bd769d4..1865738 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1025,7 +1025,7 @@ static int gsc_m2m_suspend(struct gsc_dev *gsc)
 	return timeout == 0 ? -EAGAIN : 0;
 }
 
-static int gsc_m2m_resume(struct gsc_dev *gsc)
+static void gsc_m2m_resume(struct gsc_dev *gsc)
 {
 	struct gsc_ctx *ctx;
 	unsigned long flags;
@@ -1038,8 +1038,6 @@ static int gsc_m2m_resume(struct gsc_dev *gsc)
 
 	if (test_and_clear_bit(ST_M2M_SUSPENDED, &gsc->state))
 		gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
-
-	return 0;
 }
 
 static int gsc_probe(struct platform_device *pdev)
@@ -1168,8 +1166,9 @@ static int gsc_runtime_resume(struct device *dev)
 
 	gsc_hw_set_sw_reset(gsc);
 	gsc_wait_reset(gsc);
+	gsc_m2m_resume(gsc);
 
-	return gsc_m2m_resume(gsc);
+	return 0;
 }
 
 static int gsc_runtime_suspend(struct device *dev)
-- 
1.9.1

