Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41004 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdIMLmR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 07:42:17 -0400
From: Hoegeun Kwon <hoegeun.kwon@samsung.com>
To: inki.dae@samsung.com, airlied@linux.ie, kgene@kernel.org,
        krzk@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, will.deacon@arm.com, mchehab@kernel.org,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, a.hajda@samsung.com,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>
Subject: [PATCH v4 3/4] drm/exynos/gsc: Add hardware rotation limits
Date: Wed, 13 Sep 2017 20:41:54 +0900
Message-id: <1505302915-15699-4-git-send-email-hoegeun.kwon@samsung.com>
In-reply-to: <1505302915-15699-1-git-send-email-hoegeun.kwon@samsung.com>
References: <1505302915-15699-1-git-send-email-hoegeun.kwon@samsung.com>
        <CGME20170913114215epcas2p17ade0c243f3b9cfeaec5175ba6747885@epcas2p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The gscaler has hardware rotation limits that need to be hardcoded
into driver. Distinguish them and add them to the property list.

The hardware rotation limits are related to the cropped source size.
When swap occurs, use rot_max size instead of crop_max size.

Also the scaling limits are related to pos size, use pos size to check
the limits.

Signed-off-by: Hoegeun Kwon <hoegeun.kwon@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_gsc.c | 104 +++++++++++++++++++++++---------
 include/uapi/drm/exynos_drm.h           |   2 +
 2 files changed, 77 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 0506b2b..66a19d7 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -17,6 +17,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/of_device.h>
 
 #include <drm/drmP.h>
 #include <drm/exynos_drm.h>
@@ -150,6 +151,15 @@ struct gsc_context {
 	bool	suspended;
 };
 
+/*
+ * struct gsc_driverdata - per device type driver data for init time.
+ *
+ * @rot_max: rotation max resolution.
+ */
+struct gsc_driverdata {
+	struct drm_exynos_sz rot_max;
+};
+
 /* 8-tap Filter Coefficient */
 static const int h_coef_8t[GSC_COEF_RATIO][GSC_COEF_ATTR][GSC_COEF_H_8T] = {
 	{	/* Ratio <= 65536 (~8:8) */
@@ -1401,6 +1411,23 @@ static int gsc_ippdrv_check_property(struct device *dev,
 	bool swap;
 	int i;
 
+	config = &property->config[EXYNOS_DRM_OPS_DST];
+
+	/* check for degree */
+	switch (config->degree) {
+	case EXYNOS_DRM_DEGREE_90:
+	case EXYNOS_DRM_DEGREE_270:
+		swap = true;
+		break;
+	case EXYNOS_DRM_DEGREE_0:
+	case EXYNOS_DRM_DEGREE_180:
+		swap = false;
+		break;
+	default:
+		DRM_ERROR("invalid degree.\n");
+		goto err_property;
+	}
+
 	for_each_ipp_ops(i) {
 		if ((i == EXYNOS_DRM_OPS_SRC) &&
 			(property->cmd == IPP_CMD_WB))
@@ -1416,21 +1443,6 @@ static int gsc_ippdrv_check_property(struct device *dev,
 			goto err_property;
 		}
 
-		/* check for degree */
-		switch (config->degree) {
-		case EXYNOS_DRM_DEGREE_90:
-		case EXYNOS_DRM_DEGREE_270:
-			swap = true;
-			break;
-		case EXYNOS_DRM_DEGREE_0:
-		case EXYNOS_DRM_DEGREE_180:
-			swap = false;
-			break;
-		default:
-			DRM_ERROR("invalid degree.\n");
-			goto err_property;
-		}
-
 		/* check for buffer bound */
 		if ((pos->x + pos->w > sz->hsize) ||
 			(pos->y + pos->h > sz->vsize)) {
@@ -1438,21 +1450,27 @@ static int gsc_ippdrv_check_property(struct device *dev,
 			goto err_property;
 		}
 
+		/*
+		 * The rotation hardware limits are related to the cropped
+		 * source size. So use rot_max size to check the limits when
+		 * swap happens. And also the scaling limits are related to pos
+		 * size, use pos size to check the limits.
+		 */
 		/* check for crop */
 		if ((i == EXYNOS_DRM_OPS_SRC) && (pp->crop)) {
 			if (swap) {
 				if ((pos->h < pp->crop_min.hsize) ||
-					(sz->vsize > pp->crop_max.hsize) ||
+					(pos->h > pp->rot_max.hsize) ||
 					(pos->w < pp->crop_min.vsize) ||
-					(sz->hsize > pp->crop_max.vsize)) {
+					(pos->w > pp->rot_max.vsize)) {
 					DRM_ERROR("out of crop size.\n");
 					goto err_property;
 				}
 			} else {
 				if ((pos->w < pp->crop_min.hsize) ||
-					(sz->hsize > pp->crop_max.hsize) ||
+					(pos->w > pp->crop_max.hsize) ||
 					(pos->h < pp->crop_min.vsize) ||
-					(sz->vsize > pp->crop_max.vsize)) {
+					(pos->h > pp->crop_max.vsize)) {
 					DRM_ERROR("out of crop size.\n");
 					goto err_property;
 				}
@@ -1463,17 +1481,17 @@ static int gsc_ippdrv_check_property(struct device *dev,
 		if ((i == EXYNOS_DRM_OPS_DST) && (pp->scale)) {
 			if (swap) {
 				if ((pos->h < pp->scale_min.hsize) ||
-					(sz->vsize > pp->scale_max.hsize) ||
+					(pos->h > pp->scale_max.hsize) ||
 					(pos->w < pp->scale_min.vsize) ||
-					(sz->hsize > pp->scale_max.vsize)) {
+					(pos->w > pp->scale_max.vsize)) {
 					DRM_ERROR("out of scale size.\n");
 					goto err_property;
 				}
 			} else {
 				if ((pos->w < pp->scale_min.hsize) ||
-					(sz->hsize > pp->scale_max.hsize) ||
+					(pos->w > pp->scale_max.hsize) ||
 					(pos->h < pp->scale_min.vsize) ||
-					(sz->vsize > pp->scale_max.vsize)) {
+					(pos->h > pp->scale_max.vsize)) {
 					DRM_ERROR("out of scale size.\n");
 					goto err_property;
 				}
@@ -1657,12 +1675,42 @@ static void gsc_ippdrv_stop(struct device *dev, enum drm_exynos_ipp_cmd cmd)
 	gsc_write(cfg, GSC_ENABLE);
 }
 
+static struct gsc_driverdata gsc_exynos5250_drvdata = {
+	.rot_max = { 2048, 2048 },
+};
+
+static struct gsc_driverdata gsc_exynos5420_drvdata = {
+	.rot_max = { 2016, 2016 },
+};
+
+static struct gsc_driverdata gsc_exynos5_drvdata = {
+	.rot_max = { 2016, 2016 },
+};
+
+static const struct of_device_id exynos_drm_gsc_of_match[] = {
+	{
+		.compatible = "samsung,exynos5250-gsc",
+		.data = &gsc_exynos5250_drvdata,
+	},
+	{
+		.compatible = "samsung,exynos5420-gsc",
+		.data = &gsc_exynos5420_drvdata,
+	},
+	{
+		.compatible = "samsung,exynos5-gsc",
+		.data = &gsc_exynos5_drvdata,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_drm_gsc_of_match);
+
 static int gsc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct gsc_context *ctx;
 	struct resource *res;
 	struct exynos_drm_ippdrv *ippdrv;
+	const struct gsc_driverdata *drv_data = of_device_get_match_data(dev);
 	int ret;
 
 	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
@@ -1723,6 +1771,10 @@ static int gsc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ctx->ippdrv.prop_list.rot_max = drv_data->rot_max;
+	if (drv_data == &gsc_exynos5_drvdata)
+		dev_info(dev, "compatible 'exynos5-gsc' is deprecated\n");
+
 	DRM_DEBUG_KMS("id[%d]ippdrv[%pK]\n", ctx->id, ippdrv);
 
 	mutex_init(&ctx->lock);
@@ -1784,12 +1836,6 @@ static int __maybe_unused gsc_runtime_resume(struct device *dev)
 	SET_RUNTIME_PM_OPS(gsc_runtime_suspend, gsc_runtime_resume, NULL)
 };
 
-static const struct of_device_id exynos_drm_gsc_of_match[] = {
-	{ .compatible = "samsung,exynos5-gsc" },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, exynos_drm_gsc_of_match);
-
 struct platform_driver gsc_driver = {
 	.probe		= gsc_probe,
 	.remove		= gsc_remove,
diff --git a/include/uapi/drm/exynos_drm.h b/include/uapi/drm/exynos_drm.h
index cb3e9f9..d5d5518 100644
--- a/include/uapi/drm/exynos_drm.h
+++ b/include/uapi/drm/exynos_drm.h
@@ -192,6 +192,7 @@ enum drm_exynos_planer {
  * @crop_max: crop max resolution.
  * @scale_min: scale min resolution.
  * @scale_max: scale max resolution.
+ * @rot_max: rotation max resolution.
  */
 struct drm_exynos_ipp_prop_list {
 	__u32	version;
@@ -210,6 +211,7 @@ struct drm_exynos_ipp_prop_list {
 	struct drm_exynos_sz	crop_max;
 	struct drm_exynos_sz	scale_min;
 	struct drm_exynos_sz	scale_max;
+	struct drm_exynos_sz	rot_max;
 };
 
 /**
-- 
1.9.1
