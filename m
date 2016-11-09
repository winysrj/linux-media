Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60632 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754107AbcKIOYU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:20 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 12/12] exynos-gsc: Use of_device_get_match_data() helper
Date: Wed, 09 Nov 2016 15:24:01 +0100
Message-id: <1478701441-29107-13-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142412eucas1p17e8eeb9c289771e8a093d35d1fde28f7@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace open-coded driver data extraction code with generic helper.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index ac4c96c..664398c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <media/v4l2-ioctl.h>
 
 #include "gsc-core.h"
@@ -975,24 +976,12 @@ static irqreturn_t gsc_irq_handler(int irq, void *priv)
 };
 MODULE_DEVICE_TABLE(of, exynos_gsc_match);
 
-static void *gsc_get_drv_data(struct platform_device *pdev)
-{
-	struct gsc_driverdata *driver_data = NULL;
-	const struct of_device_id *match;
-
-	match = of_match_node(exynos_gsc_match, pdev->dev.of_node);
-	if (match)
-		driver_data = (struct gsc_driverdata *)match->data;
-
-	return driver_data;
-}
-
 static int gsc_probe(struct platform_device *pdev)
 {
 	struct gsc_dev *gsc;
 	struct resource *res;
-	struct gsc_driverdata *drv_data = gsc_get_drv_data(pdev);
 	struct device *dev = &pdev->dev;
+	const struct gsc_driverdata *drv_data = of_device_get_match_data(dev);
 	int ret;
 
 	gsc = devm_kzalloc(dev, sizeof(struct gsc_dev), GFP_KERNEL);
-- 
1.9.1

