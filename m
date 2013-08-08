Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271Ab3HHO4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 10:56:16 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 1/6] V4L2: soc-camera: fix requesting regulators in synchronous case
Date: Thu,  8 Aug 2013 16:52:32 +0200
Message-Id: <1375973557-23333-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1375973557-23333-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375973557-23333-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With synchronous subdevice probing regulators should be requested by the
soc-camera core in soc_camera_pdrv_probe(). Subdevice drivers, supporting
asynchronous probing, call soc_camera_power_init() to request regulators.
Erroneously, the same regulator array is used in the latter case as in
the former, which leads to a failure. This patch fixes it by preventing
the second regulator request from being executed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Since currently only one sensor driver, used with soc-camera supports 
asynchronous probing and no platforms in the mainline are using it, 
this fix is only theoretical, no platform in the mainline can trigger it. 
But I did observe it when working with mx3_camera + mt9m111. Just to say, 
that there's no need in stable for this.

 drivers/media/platform/soc_camera/soc_camera.c |   33 +++++++++++++++++++----
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 2dd0e52..9a96cf1 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -136,7 +136,7 @@ EXPORT_SYMBOL(soc_camera_power_off);
 
 int soc_camera_power_init(struct device *dev, struct soc_camera_subdev_desc *ssdd)
 {
-
+	/* Should not have any effect in synchronous case */
 	return devm_regulator_bulk_get(dev, ssdd->num_regulators,
 				       ssdd->regulators);
 }
@@ -1311,6 +1311,7 @@ eusrfmt:
 static int soc_camera_i2c_init(struct soc_camera_device *icd,
 			       struct soc_camera_desc *sdesc)
 {
+	struct soc_camera_subdev_desc *ssdd;
 	struct i2c_client *client;
 	struct soc_camera_host *ici;
 	struct soc_camera_host_desc *shd = &sdesc->host_desc;
@@ -1333,7 +1334,21 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
-	shd->board_info->platform_data = &sdesc->subdev_desc;
+	ssdd = kzalloc(sizeof(*ssdd), GFP_KERNEL);
+	if (!ssdd) {
+		ret = -ENOMEM;
+		goto ealloc;
+	}
+
+	memcpy(ssdd, &sdesc->subdev_desc, sizeof(*ssdd));
+	/*
+	 * In synchronous case we request regulators ourselves in
+	 * soc_camera_pdrv_probe(), make sure the subdevice driver doesn't try
+	 * to allocate them again.
+	 */
+	ssdd->num_regulators = 0;
+	ssdd->regulators = NULL;
+	shd->board_info->platform_data = ssdd;
 
 	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
 		 shd->i2c_adapter_id, shd->board_info->addr);
@@ -1359,8 +1374,10 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 	return 0;
 ei2cnd:
 	v4l2_clk_unregister(icd->clk);
-eclkreg:
 	icd->clk = NULL;
+eclkreg:
+	kfree(ssdd);
+ealloc:
 	i2c_put_adapter(adap);
 	return ret;
 }
@@ -1370,15 +1387,18 @@ static void soc_camera_i2c_free(struct soc_camera_device *icd)
 	struct i2c_client *client =
 		to_i2c_client(to_soc_camera_control(icd));
 	struct i2c_adapter *adap;
+	struct soc_camera_subdev_desc *ssdd;
 
 	icd->control = NULL;
 	if (icd->sasc)
 		return;
 
 	adap = client->adapter;
+	ssdd = client->dev.platform_data;
 	v4l2_device_unregister_subdev(i2c_get_clientdata(client));
 	i2c_unregister_device(client);
 	i2c_put_adapter(adap);
+	kfree(ssdd);
 	v4l2_clk_unregister(icd->clk);
 	icd->clk = NULL;
 }
@@ -1994,9 +2014,10 @@ static int soc_camera_pdrv_probe(struct platform_device *pdev)
 
 	/*
 	 * In the asynchronous case ssdd->num_regulators == 0 yet, so, the below
-	 * regulator allocation is a dummy. They will be really requested later
-	 * in soc_camera_async_bind(). Also note, that in that case regulators
-	 * are attached to the I2C device and not to the camera platform device.
+	 * regulator allocation is a dummy. They are actually requested by the
+	 * subdevice driver, using soc_camera_power_init(). Also note, that in
+	 * that case regulators are attached to the I2C device and not to the
+	 * camera platform device.
 	 */
 	ret = devm_regulator_bulk_get(&pdev->dev, ssdd->num_regulators,
 				      ssdd->regulators);
-- 
1.7.2.5

