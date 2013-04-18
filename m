Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936435Ab3DRVf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:57 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 07/24] soc-camera: switch to using the new struct v4l2_subdev_platform_data
Date: Thu, 18 Apr 2013 23:35:28 +0200
Message-Id: <1366320945-21591-8-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This prepares soc-camera to use struct v4l2_subdev_platform_data for its
subdevice-facing API, which would allow subdevice driver re-use.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |   20 ++++++++++----------
 include/media/soc_camera.h                     |   17 +++++++++--------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index a790f81..c06e660 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -76,8 +76,8 @@ int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd,
 		dev_err(dev, "Cannot enable clock: %d\n", ret);
 		return ret;
 	}
-	ret = regulator_bulk_enable(ssdd->num_regulators,
-					ssdd->regulators);
+	ret = regulator_bulk_enable(ssdd->sd_pdata.num_regulators,
+				    ssdd->sd_pdata.regulators);
 	if (ret < 0) {
 		dev_err(dev, "Cannot enable regulators\n");
 		goto eregenable;
@@ -95,8 +95,8 @@ int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd,
 	return 0;
 
 epwron:
-	regulator_bulk_disable(ssdd->num_regulators,
-			       ssdd->regulators);
+	regulator_bulk_disable(ssdd->sd_pdata.num_regulators,
+			       ssdd->sd_pdata.regulators);
 eregenable:
 	if (clk)
 		v4l2_clk_disable(clk);
@@ -120,8 +120,8 @@ int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd
 		}
 	}
 
-	err = regulator_bulk_disable(ssdd->num_regulators,
-				     ssdd->regulators);
+	err = regulator_bulk_disable(ssdd->sd_pdata.num_regulators,
+				     ssdd->sd_pdata.regulators);
 	if (err < 0) {
 		dev_err(dev, "Cannot disable regulators\n");
 		ret = ret ? : err;
@@ -137,8 +137,8 @@ EXPORT_SYMBOL(soc_camera_power_off);
 int soc_camera_power_init(struct device *dev, struct soc_camera_subdev_desc *ssdd)
 {
 
-	return devm_regulator_bulk_get(dev, ssdd->num_regulators,
-				       ssdd->regulators);
+	return devm_regulator_bulk_get(dev, ssdd->sd_pdata.num_regulators,
+				       ssdd->sd_pdata.regulators);
 }
 EXPORT_SYMBOL(soc_camera_power_init);
 
@@ -2033,8 +2033,8 @@ static int soc_camera_pdrv_probe(struct platform_device *pdev)
 	 * in soc_camera_async_bind(). Also note, that in that case regulators
 	 * are attached to the I2C device and not to the camera platform device.
 	 */
-	ret = devm_regulator_bulk_get(&pdev->dev, ssdd->num_regulators,
-				      ssdd->regulators);
+	ret = devm_regulator_bulk_get(&pdev->dev, ssdd->sd_pdata.num_regulators,
+				      ssdd->sd_pdata.regulators);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2d3c939..1331278 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -146,10 +146,6 @@ struct soc_camera_subdev_desc {
 	/* sensor driver private platform data */
 	void *drv_priv;
 
-	/* Optional regulators that have to be managed on power on/off events */
-	struct regulator_bulk_data *regulators;
-	int num_regulators;
-
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
@@ -162,6 +158,9 @@ struct soc_camera_subdev_desc {
 	int (*set_bus_param)(struct soc_camera_subdev_desc *, unsigned long flags);
 	unsigned long (*query_bus_param)(struct soc_camera_subdev_desc *);
 	void (*free_bus)(struct soc_camera_subdev_desc *);
+
+	/* Optional regulators that have to be managed on power on/off events */
+	struct v4l2_subdev_platform_data sd_pdata;
 };
 
 struct soc_camera_host_desc {
@@ -202,10 +201,6 @@ struct soc_camera_link {
 
 	void *priv;
 
-	/* Optional regulators that have to be managed on power on/off events */
-	struct regulator_bulk_data *regulators;
-	int num_regulators;
-
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
@@ -218,6 +213,12 @@ struct soc_camera_link {
 	unsigned long (*query_bus_param)(struct soc_camera_link *);
 	void (*free_bus)(struct soc_camera_link *);
 
+	/* Optional regulators that have to be managed on power on/off events */
+	struct regulator_bulk_data *regulators;
+	int num_regulators;
+
+	void *host_priv;
+
 	/*
 	 * Host part - keep at bottom and compatible to
 	 * struct soc_camera_host_desc
-- 
1.7.2.5

