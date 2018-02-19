Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56987 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753004AbeBSPpG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 10:45:06 -0500
From: Maciej Purski <m.purski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Cc: Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Maciej Purski <m.purski@samsung.com>
Subject: [PATCH 2/8] media: s5p-jpeg: Use bulk clk API
Date: Mon, 19 Feb 2018 16:44:00 +0100
Message-id: <1519055046-2399-3-git-send-email-m.purski@samsung.com>
In-reply-to: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
References: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
        <CGME20180219154457eucas1p163264992903698a8878aa5abbc8aa17b@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using bulk clk functions simplifies the driver's code. Use devm_clk_bulk
functions instead of iterating over an array of clks.

Signed-off-by: Maciej Purski <m.purski@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 45 ++++++++++++-----------------
 drivers/media/platform/s5p-jpeg/jpeg-core.h |  2 +-
 2 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 79b63da..681a515 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2903,7 +2903,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 {
 	struct s5p_jpeg *jpeg;
 	struct resource *res;
-	int i, ret;
+	int ret;
 
 	/* JPEG IP abstraction struct */
 	jpeg = devm_kzalloc(&pdev->dev, sizeof(struct s5p_jpeg), GFP_KERNEL);
@@ -2938,15 +2938,16 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	}
 
 	/* clocks */
-	for (i = 0; i < jpeg->variant->num_clocks; i++) {
-		jpeg->clocks[i] = devm_clk_get(&pdev->dev,
-					      jpeg->variant->clk_names[i]);
-		if (IS_ERR(jpeg->clocks[i])) {
-			dev_err(&pdev->dev, "failed to get clock: %s\n",
-				jpeg->variant->clk_names[i]);
-			return PTR_ERR(jpeg->clocks[i]);
-		}
-	}
+	jpeg->clocks = devm_clk_bulk_alloc(&pdev->dev,
+					   jpeg->variant->num_clocks,
+					   jpeg->variant->clk_names);
+	if (IS_ERR(jpeg->clocks))
+		return PTR_ERR(jpeg->clocks);
+
+	ret = devm_clk_bulk_get(&pdev->dev, jpeg->variant->num_clocks,
+				jpeg->clocks);
+	if (ret < 0)
+		return ret;
 
 	/* v4l2 device */
 	ret = v4l2_device_register(&pdev->dev, &jpeg->v4l2_dev);
@@ -3047,7 +3048,6 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 static int s5p_jpeg_remove(struct platform_device *pdev)
 {
 	struct s5p_jpeg *jpeg = platform_get_drvdata(pdev);
-	int i;
 
 	pm_runtime_disable(jpeg->dev);
 
@@ -3058,8 +3058,8 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
 	if (!pm_runtime_status_suspended(&pdev->dev)) {
-		for (i = jpeg->variant->num_clocks - 1; i >= 0; i--)
-			clk_disable_unprepare(jpeg->clocks[i]);
+		clk_bulk_disable_unprepare(jpeg->variant->num_clocks,
+					   jpeg->clocks);
 	}
 
 	return 0;
@@ -3069,10 +3069,8 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 static int s5p_jpeg_runtime_suspend(struct device *dev)
 {
 	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
-	int i;
 
-	for (i = jpeg->variant->num_clocks - 1; i >= 0; i--)
-		clk_disable_unprepare(jpeg->clocks[i]);
+	clk_bulk_disable_unprepare(jpeg->variant->num_clocks, jpeg->clocks);
 
 	return 0;
 }
@@ -3081,16 +3079,11 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 {
 	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
 	unsigned long flags;
-	int i, ret;
-
-	for (i = 0; i < jpeg->variant->num_clocks; i++) {
-		ret = clk_prepare_enable(jpeg->clocks[i]);
-		if (ret) {
-			while (--i >= 0)
-				clk_disable_unprepare(jpeg->clocks[i]);
-			return ret;
-		}
-	}
+	int ret;
+
+	ret = clk_bulk_prepare_enable(jpeg->variant->num_clocks, jpeg->clocks);
+	if (ret)
+		return ret;
 
 	spin_lock_irqsave(&jpeg->slock, flags);
 
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index a46465e..dc6ed98 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -133,7 +133,7 @@ struct s5p_jpeg {
 	void __iomem		*regs;
 	unsigned int		irq;
 	enum exynos4_jpeg_result irq_ret;
-	struct clk		*clocks[JPEG_MAX_CLOCKS];
+	struct clk_bulk_data	*clocks;
 	struct device		*dev;
 	struct s5p_jpeg_variant *variant;
 	u32			irq_status;
-- 
2.7.4
