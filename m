Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51541 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3CZSin (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 14:38:43 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/4] exynos4-is: Use common driver data for all FIMC-LITE IP
 instances
Date: Tue, 26 Mar 2013 19:38:14 +0100
Message-id: <1364323101-22046-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
References: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to use separate variant data structure for each
FIMC-LITE IP instance. According to my knowledge there are no
differences across them on Exynos4 as well as Exynos5 SoCs. Drop
flite_variant data structure and use struct flite_drvdata instead.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   35 ++++++++++---------------
 drivers/media/platform/exynos4-is/fimc-lite.h |   10 +++----
 2 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 70c0cc2..ba35328 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -528,7 +528,7 @@ static const struct fimc_fmt *fimc_lite_try_format(struct fimc_lite *fimc,
 					u32 *width, u32 *height,
 					u32 *code, u32 *fourcc, int pad)
 {
-	struct flite_variant *variant = fimc->variant;
+	struct flite_drvdata *dd = fimc->dd;
 	const struct fimc_fmt *fmt;
 
 	fmt = fimc_lite_find_format(fourcc, code, 0);
@@ -541,12 +541,12 @@ static const struct fimc_fmt *fimc_lite_try_format(struct fimc_lite *fimc,
 		*fourcc = fmt->fourcc;
 
 	if (pad == FLITE_SD_PAD_SINK) {
-		v4l_bound_align_image(width, 8, variant->max_width,
-				      ffs(variant->out_width_align) - 1,
-				      height, 0, variant->max_height, 0, 0);
+		v4l_bound_align_image(width, 8, dd->max_width,
+				      ffs(dd->out_width_align) - 1,
+				      height, 0, dd->max_height, 0, 0);
 	} else {
 		v4l_bound_align_image(width, 8, fimc->inp_frame.rect.width,
-				      ffs(variant->out_width_align) - 1,
+				      ffs(dd->out_width_align) - 1,
 				      height, 0, fimc->inp_frame.rect.height,
 				      0, 0);
 	}
@@ -566,7 +566,7 @@ static void fimc_lite_try_crop(struct fimc_lite *fimc, struct v4l2_rect *r)
 
 	/* Adjust left/top if cropping rectangle got out of bounds */
 	r->left = clamp_t(u32, r->left, 0, frame->f_width - r->width);
-	r->left = round_down(r->left, fimc->variant->win_hor_offs_align);
+	r->left = round_down(r->left, fimc->dd->win_hor_offs_align);
 	r->top  = clamp_t(u32, r->top, 0, frame->f_height - r->height);
 
 	v4l2_dbg(1, debug, &fimc->subdev, "(%d,%d)/%dx%d, sink fmt: %dx%d\n",
@@ -586,7 +586,7 @@ static void fimc_lite_try_compose(struct fimc_lite *fimc, struct v4l2_rect *r)
 
 	/* Adjust left/top if the composing rectangle got out of bounds */
 	r->left = clamp_t(u32, r->left, 0, frame->f_width - r->width);
-	r->left = round_down(r->left, fimc->variant->out_hor_offs_align);
+	r->left = round_down(r->left, fimc->dd->out_hor_offs_align);
 	r->top  = clamp_t(u32, r->top, 0, fimc->out_frame.f_height - r->height);
 
 	v4l2_dbg(1, debug, &fimc->subdev, "(%d,%d)/%dx%d, source fmt: %dx%d\n",
@@ -647,8 +647,8 @@ static int fimc_lite_try_fmt(struct fimc_lite *fimc,
 			     struct v4l2_pix_format_mplane *pixm,
 			     const struct fimc_fmt **ffmt)
 {
-	struct flite_variant *variant = fimc->variant;
 	u32 bpl = pixm->plane_fmt[0].bytesperline;
+	struct flite_drvdata *dd = fimc->dd;
 	const struct fimc_fmt *fmt;
 
 	fmt = fimc_lite_find_format(&pixm->pixelformat, NULL, 0);
@@ -656,9 +656,9 @@ static int fimc_lite_try_fmt(struct fimc_lite *fimc,
 		return -EINVAL;
 	if (ffmt)
 		*ffmt = fmt;
-	v4l_bound_align_image(&pixm->width, 8, variant->max_width,
-			      ffs(variant->out_width_align) - 1,
-			      &pixm->height, 0, variant->max_height, 0, 0);
+	v4l_bound_align_image(&pixm->width, 8, dd->max_width,
+			      ffs(dd->out_width_align) - 1,
+			      &pixm->height, 0, dd->max_height, 0, 0);
 
 	if ((bpl == 0 || ((bpl * 8) / fmt->depth[0]) < pixm->width))
 		pixm->plane_fmt[0].bytesperline = (pixm->width *
@@ -1429,7 +1429,7 @@ static int fimc_lite_probe(struct platform_device *pdev)
 	if (!drv_data || fimc->index < 0 || fimc->index >= FIMC_LITE_MAX_DEVS)
 		return -EINVAL;
 
-	fimc->variant = drv_data->variant[fimc->index];
+	fimc->dd = drv_data;
 	fimc->pdev = pdev;
 
 	init_waitqueue_head(&fimc->irq_queue);
@@ -1577,7 +1577,8 @@ static const struct dev_pm_ops fimc_lite_pm_ops = {
 			   NULL)
 };
 
-static struct flite_variant fimc_lite0_variant_exynos4 = {
+/* EXYNOS4212, EXYNOS4412 */
+static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
 	.max_width		= 8192,
 	.max_height		= 8192,
 	.out_width_align	= 8,
@@ -1585,14 +1586,6 @@ static struct flite_variant fimc_lite0_variant_exynos4 = {
 	.out_hor_offs_align	= 8,
 };
 
-/* EXYNOS4212, EXYNOS4412 */
-static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
-	.variant = {
-		[0] = &fimc_lite0_variant_exynos4,
-		[1] = &fimc_lite0_variant_exynos4,
-	},
-};
-
 static struct platform_device_id fimc_lite_driver_ids[] = {
 	{
 		.name		= "exynos-fimc-lite",
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 4c234508..0b6380b 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -48,7 +48,7 @@ enum {
 #define FLITE_SD_PAD_SOURCE_ISP	2
 #define FLITE_SD_PADS_NUM	3
 
-struct flite_variant {
+struct flite_drvdata {
 	unsigned short max_width;
 	unsigned short max_height;
 	unsigned short out_width_align;
@@ -56,10 +56,6 @@ struct flite_variant {
 	unsigned short out_hor_offs_align;
 };
 
-struct flite_drvdata {
-	struct flite_variant *variant[FIMC_LITE_MAX_DEVS];
-};
-
 #define fimc_lite_get_drvdata(_pdev) \
 	((struct flite_drvdata *) platform_get_device_id(_pdev)->driver_data)
 
@@ -96,7 +92,7 @@ struct flite_buffer {
 /**
  * struct fimc_lite - fimc lite structure
  * @pdev: pointer to FIMC-LITE platform device
- * @variant: variant information for this IP
+ * @dd: SoC specific driver data structure
  * @v4l2_dev: pointer to top the level v4l2_device
  * @vfd: video device node
  * @fh: v4l2 file handle
@@ -132,7 +128,7 @@ struct flite_buffer {
  */
 struct fimc_lite {
 	struct platform_device	*pdev;
-	struct flite_variant	*variant;
+	struct flite_drvdata	*dd;
 	struct v4l2_device	*v4l2_dev;
 	struct video_device	vfd;
 	struct v4l2_fh		fh;
-- 
1.7.9.5

