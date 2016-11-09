Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60632 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753589AbcKIOYT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:19 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 10/12] exynos-gsc: Remove unused lclk_freqency entry
Date: Wed, 09 Nov 2016 15:23:59 +0100
Message-id: <1478701441-29107-11-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142411eucas1p29fd9c9622fd1294ef82bc0090d7b6dff@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove dead, unused code.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 1 -
 drivers/media/platform/exynos-gsc/gsc-core.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 1e8b216..ff35909 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -964,7 +964,6 @@ static irqreturn_t gsc_irq_handler(int irq, void *priv)
 		[3] = &gsc_v_100_variant,
 	},
 	.num_entities = 4,
-	.lclk_frequency = 266000000UL,
 };
 
 static const struct of_device_id exynos_gsc_match[] = {
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 8480aec..e5aa8f4 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -303,12 +303,10 @@ struct gsc_variant {
  * struct gsc_driverdata - per device type driver data for init time.
  *
  * @variant: the variant information for this driver.
- * @lclk_frequency: G-Scaler clock frequency
  * @num_entities: the number of g-scalers
  */
 struct gsc_driverdata {
 	struct gsc_variant *variant[GSC_MAX_DEVS];
-	unsigned long	lclk_frequency;
 	int		num_entities;
 };
 
-- 
1.9.1

