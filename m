Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28125 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbbIROWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 10:22:01 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/4] s5p-jpeg: generalize clocks handling
Date: Fri, 18 Sep 2015 16:20:57 +0200
Message-id: <1442586060-23657-2-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Allow jpeg codec variants declare clocks they need.
Before this patch is applied jpeg-core gets jpeg->sclk
"speculatively": if it is not there, we assume no problem.

This patch eliminates this by explicitly declaring
what clocks are needed for each variant.

This is a preparation for adding Exynos 5433 variant support, which
needs 4 clocks of names not compatible with any previous version of
jpeg hw module.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
[Rebase and commit message]
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 66 ++++++++++++++---------------
 drivers/media/platform/s5p-jpeg/jpeg-core.h | 10 +++--
 2 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index bfbf157..03d0904 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2455,7 +2455,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 {
 	struct s5p_jpeg *jpeg;
 	struct resource *res;
-	int ret;
+	int i, ret;
 
 	/* JPEG IP abstraction struct */
 	jpeg = devm_kzalloc(&pdev->dev, sizeof(struct s5p_jpeg), GFP_KERNEL);
@@ -2490,23 +2490,21 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	}
 
 	/* clocks */
-	jpeg->clk = clk_get(&pdev->dev, "jpeg");
-	if (IS_ERR(jpeg->clk)) {
-		dev_err(&pdev->dev, "cannot get clock\n");
-		ret = PTR_ERR(jpeg->clk);
-		return ret;
+	for (i = 0; i < jpeg->variant->num_clocks; i++) {
+		jpeg->clocks[i] = devm_clk_get(&pdev->dev,
+					      jpeg->variant->clk_names[i]);
+		if (IS_ERR(jpeg->clocks[i])) {
+			dev_err(&pdev->dev, "failed to get clock: %s\n",
+				jpeg->variant->clk_names[i]);
+			return PTR_ERR(jpeg->clocks[i]);
+		}
 	}
-	dev_dbg(&pdev->dev, "clock source %p\n", jpeg->clk);
-
-	jpeg->sclk = clk_get(&pdev->dev, "sclk");
-	if (IS_ERR(jpeg->sclk))
-		dev_info(&pdev->dev, "sclk clock not available\n");
 
 	/* v4l2 device */
 	ret = v4l2_device_register(&pdev->dev, &jpeg->v4l2_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
-		goto clk_get_rollback;
+		return ret;
 	}
 
 	/* mem2mem device */
@@ -2607,17 +2605,13 @@ m2m_init_rollback:
 device_register_rollback:
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
-clk_get_rollback:
-	clk_put(jpeg->clk);
-	if (!IS_ERR(jpeg->sclk))
-		clk_put(jpeg->sclk);
-
 	return ret;
 }
 
 static int s5p_jpeg_remove(struct platform_device *pdev)
 {
 	struct s5p_jpeg *jpeg = platform_get_drvdata(pdev);
+	int i;
 
 	pm_runtime_disable(jpeg->dev);
 
@@ -2630,15 +2624,10 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
 	if (!pm_runtime_status_suspended(&pdev->dev)) {
-		clk_disable_unprepare(jpeg->clk);
-		if (!IS_ERR(jpeg->sclk))
-			clk_disable_unprepare(jpeg->sclk);
+		for (i = jpeg->variant->num_clocks - 1; i >= 0; i--)
+			clk_disable_unprepare(jpeg->clocks[i]);
 	}
 
-	clk_put(jpeg->clk);
-	if (!IS_ERR(jpeg->sclk))
-		clk_put(jpeg->sclk);
-
 	return 0;
 }
 
@@ -2646,10 +2635,10 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 static int s5p_jpeg_runtime_suspend(struct device *dev)
 {
 	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
+	int i;
 
-	clk_disable_unprepare(jpeg->clk);
-	if (!IS_ERR(jpeg->sclk))
-		clk_disable_unprepare(jpeg->sclk);
+	for (i = jpeg->variant->num_clocks - 1; i >= 0; i--)
+		clk_disable_unprepare(jpeg->clocks[i]);
 
 	return 0;
 }
@@ -2658,16 +2647,15 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 {
 	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
 	unsigned long flags;
-	int ret;
+	int i, ret;
 
-	ret = clk_prepare_enable(jpeg->clk);
-	if (ret < 0)
-		return ret;
-
-	if (!IS_ERR(jpeg->sclk)) {
-		ret = clk_prepare_enable(jpeg->sclk);
-		if (ret < 0)
+	for (i = 0; i < jpeg->variant->num_clocks; i++) {
+		ret = clk_prepare_enable(jpeg->clocks[i]);
+		if (ret) {
+			while (--i > 0)
+				clk_disable_unprepare(jpeg->clocks[i]);
 			return ret;
+		}
 	}
 
 	spin_lock_irqsave(&jpeg->slock, flags);
@@ -2721,6 +2709,8 @@ static struct s5p_jpeg_variant s5p_jpeg_drvdata = {
 	.jpeg_irq	= s5p_jpeg_irq,
 	.m2m_ops	= &s5p_jpeg_m2m_ops,
 	.fmt_ver_flag	= SJPEG_FMT_FLAG_S5P,
+	.clk_names	= {"jpeg"},
+	.num_clocks	= 1,
 };
 
 static struct s5p_jpeg_variant exynos3250_jpeg_drvdata = {
@@ -2729,6 +2719,8 @@ static struct s5p_jpeg_variant exynos3250_jpeg_drvdata = {
 	.m2m_ops	= &exynos3250_jpeg_m2m_ops,
 	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS3250,
 	.hw3250_compat	= 1,
+	.clk_names	= {"jpeg", "sclk"},
+	.num_clocks	= 2,
 };
 
 static struct s5p_jpeg_variant exynos4_jpeg_drvdata = {
@@ -2737,6 +2729,8 @@ static struct s5p_jpeg_variant exynos4_jpeg_drvdata = {
 	.m2m_ops	= &exynos4_jpeg_m2m_ops,
 	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS4,
 	.htbl_reinit	= 1,
+	.clk_names	= {"jpeg"},
+	.num_clocks	= 1,
 };
 
 static struct s5p_jpeg_variant exynos5420_jpeg_drvdata = {
@@ -2746,6 +2740,8 @@ static struct s5p_jpeg_variant exynos5420_jpeg_drvdata = {
 	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS3250,	/* intentionally 3250 */
 	.hw3250_compat	= 1,
 	.htbl_reinit	= 1,
+	.clk_names	= {"jpeg"},
+	.num_clocks	= 1,
 };
 
 static const struct of_device_id samsung_jpeg_match[] = {
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 7d9a9ed..d0076fe 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -20,6 +20,8 @@
 
 #define S5P_JPEG_M2M_NAME		"s5p-jpeg"
 
+#define JPEG_MAX_CLOCKS			4
+
 /* JPEG compression quality setting */
 #define S5P_JPEG_COMPR_QUAL_BEST	0
 #define S5P_JPEG_COMPR_QUAL_WORST	3
@@ -100,8 +102,7 @@ enum  exynos4_jpeg_img_quality_level {
  * @m2m_dev:		v4l2 mem2mem device data
  * @regs:		JPEG IP registers mapping
  * @irq:		JPEG IP irq
- * @clk:		JPEG IP clock
- * @sclk:		Exynos3250 JPEG IP special clock
+ * @clocks:		JPEG IP clock(s)
  * @dev:		JPEG IP struct device
  * @alloc_ctx:		videobuf2 memory allocator's context
  * @variant:		driver variant to be used
@@ -121,8 +122,7 @@ struct s5p_jpeg {
 	void __iomem		*regs;
 	unsigned int		irq;
 	enum exynos4_jpeg_result irq_ret;
-	struct clk		*clk;
-	struct clk		*sclk;
+	struct clk		*clocks[JPEG_MAX_CLOCKS];
 	struct device		*dev;
 	void			*alloc_ctx;
 	struct s5p_jpeg_variant *variant;
@@ -136,6 +136,8 @@ struct s5p_jpeg_variant {
 	unsigned int		htbl_reinit:1;
 	struct v4l2_m2m_ops	*m2m_ops;
 	irqreturn_t		(*jpeg_irq)(int irq, void *priv);
+	const char		*clk_names[JPEG_MAX_CLOCKS];
+	int			num_clocks;
 };
 
 /**
-- 
1.9.1

