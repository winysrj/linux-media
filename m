Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:18150 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965168AbaDJHca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 03:32:30 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3T00L310Y5GHE0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Apr 2014 16:32:29 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 3/8] s5p-jpeg: Add m2m_ops field to the s5p_jpeg_variant
 structure
Date: Thu, 10 Apr 2014 09:32:13 +0200
Message-id: <1397115138-1095-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1397115138-1095-1-git-send-email-j.anaszewski@samsung.com>
References: <1397115138-1095-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the code by adding m2m_ops field to the
s5p_jpeg_variant structure which allows to avoid
"if" statement in the s5p_jpeg_probe function.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   12 ++++--------
 drivers/media/platform/s5p-jpeg/jpeg-core.h |    7 ++++---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index d307c0f..1b69b69 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1566,7 +1566,7 @@ static struct v4l2_m2m_ops s5p_jpeg_m2m_ops = {
 	.job_abort	= s5p_jpeg_job_abort,
 }
 ;
-static struct v4l2_m2m_ops exynos_jpeg_m2m_ops = {
+static struct v4l2_m2m_ops exynos4_jpeg_m2m_ops = {
 	.device_run	= exynos4_jpeg_device_run,
 	.job_ready	= s5p_jpeg_job_ready,
 	.job_abort	= s5p_jpeg_job_abort,
@@ -1852,7 +1852,6 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 {
 	struct s5p_jpeg *jpeg;
 	struct resource *res;
-	struct v4l2_m2m_ops *samsung_jpeg_m2m_ops;
 	int ret;
 
 	if (!pdev->dev.of_node)
@@ -1906,13 +1905,8 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 		goto clk_get_rollback;
 	}
 
-	if (jpeg->variant->version == SJPEG_S5P)
-		samsung_jpeg_m2m_ops = &s5p_jpeg_m2m_ops;
-	else
-		samsung_jpeg_m2m_ops = &exynos_jpeg_m2m_ops;
-
 	/* mem2mem device */
-	jpeg->m2m_dev = v4l2_m2m_init(samsung_jpeg_m2m_ops);
+	jpeg->m2m_dev = v4l2_m2m_init(jpeg->variant->m2m_ops);
 	if (IS_ERR(jpeg->m2m_dev)) {
 		v4l2_err(&jpeg->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(jpeg->m2m_dev);
@@ -2101,12 +2095,14 @@ static const struct dev_pm_ops s5p_jpeg_pm_ops = {
 static struct s5p_jpeg_variant s5p_jpeg_drvdata = {
 	.version	= SJPEG_S5P,
 	.jpeg_irq	= s5p_jpeg_irq,
+	.m2m_ops	= &s5p_jpeg_m2m_ops,
 	.fmt_ver_flag	= SJPEG_FMT_FLAG_S5P,
 };
 
 static struct s5p_jpeg_variant exynos4_jpeg_drvdata = {
 	.version	= SJPEG_EXYNOS4,
 	.jpeg_irq	= exynos4_jpeg_irq,
+	.m2m_ops	= &exynos4_jpeg_m2m_ops,
 	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS4,
 };
 
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index c222436..3e47863 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -117,9 +117,10 @@ struct s5p_jpeg {
 };
 
 struct s5p_jpeg_variant {
-	unsigned int	version;
-	unsigned int	fmt_ver_flag;
-	irqreturn_t	(*jpeg_irq)(int irq, void *priv);
+	unsigned int		version;
+	unsigned int		fmt_ver_flag;
+	struct v4l2_m2m_ops	*m2m_ops;
+	irqreturn_t		(*jpeg_irq)(int irq, void *priv);
 };
 
 /**
-- 
1.7.9.5

