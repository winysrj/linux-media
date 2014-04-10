Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63457 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070AbaDJHc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 03:32:26 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3T0091G0Y1ODD0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Apr 2014 16:32:25 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 1/8] s5p-jpeg: Add fmt_ver_flag field to the
 s5p_jpeg_variant structure
Date: Thu, 10 Apr 2014 09:32:11 +0200
Message-id: <1397115138-1095-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the code by adding fmt_ver_flag field
to the s5p_jpeg_variant structure which allows
to avoid "if" statement in the s5p_jpeg_find_format
function.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   11 ++++-------
 drivers/media/platform/s5p-jpeg/jpeg-core.h |    1 +
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 8a18972..3ae9210 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -959,7 +959,7 @@ static int s5p_jpeg_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 static struct s5p_jpeg_fmt *s5p_jpeg_find_format(struct s5p_jpeg_ctx *ctx,
 				u32 pixelformat, unsigned int fmt_type)
 {
-	unsigned int k, fmt_flag, ver_flag;
+	unsigned int k, fmt_flag;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
 		fmt_flag = (fmt_type == FMT_TYPE_OUTPUT) ?
@@ -970,16 +970,11 @@ static struct s5p_jpeg_fmt *s5p_jpeg_find_format(struct s5p_jpeg_ctx *ctx,
 				SJPEG_FMT_FLAG_DEC_OUTPUT :
 				SJPEG_FMT_FLAG_DEC_CAPTURE;
 
-	if (ctx->jpeg->variant->version == SJPEG_S5P)
-		ver_flag = SJPEG_FMT_FLAG_S5P;
-	else
-		ver_flag = SJPEG_FMT_FLAG_EXYNOS4;
-
 	for (k = 0; k < ARRAY_SIZE(sjpeg_formats); k++) {
 		struct s5p_jpeg_fmt *fmt = &sjpeg_formats[k];
 		if (fmt->fourcc == pixelformat &&
 		    fmt->flags & fmt_flag &&
-		    fmt->flags & ver_flag) {
+		    fmt->flags & ctx->jpeg->variant->fmt_ver_flag) {
 			return fmt;
 		}
 	}
@@ -2106,11 +2101,13 @@ static const struct dev_pm_ops s5p_jpeg_pm_ops = {
 static struct s5p_jpeg_variant s5p_jpeg_drvdata = {
 	.version	= SJPEG_S5P,
 	.jpeg_irq	= s5p_jpeg_irq,
+	.fmt_ver_flag	= SJPEG_FMT_FLAG_S5P,
 };
 
 static struct s5p_jpeg_variant exynos4_jpeg_drvdata = {
 	.version	= SJPEG_EXYNOS4,
 	.jpeg_irq	= exynos4_jpeg_irq,
+	.fmt_ver_flag	= SJPEG_FMT_FLAG_EXYNOS4,
 };
 
 static const struct of_device_id samsung_jpeg_match[] = {
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index f482dbf..c222436 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -118,6 +118,7 @@ struct s5p_jpeg {
 
 struct s5p_jpeg_variant {
 	unsigned int	version;
+	unsigned int	fmt_ver_flag;
 	irqreturn_t	(*jpeg_irq)(int irq, void *priv);
 };
 
-- 
1.7.9.5

