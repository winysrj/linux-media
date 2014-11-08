Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53014 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753351AbaKHXJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 18:09:44 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 08/10] smiapp: Obtain device information from the Device Tree if OF node exists
Date: Sun,  9 Nov 2014 01:09:29 +0200
Message-Id: <1415488171-27636-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
References: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Platform data support is retained.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |  100 +++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index c2c9a1f..bc57e5d 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -25,11 +25,13 @@
 #include <linux/device.h>
 #include <linux/gpio.h>
 #include <linux/module.h>
+#include <linux/of_gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/smiapp.h>
 #include <linux/v4l2-mediabus.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
 
 #include "smiapp.h"
 
@@ -2920,19 +2922,107 @@ static int smiapp_resume(struct device *dev)
 
 #endif /* CONFIG_PM */
 
+static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
+{
+	struct smiapp_platform_data *pdata;
+	struct v4l2_of_endpoint bus_cfg;
+	struct device_node *ep;
+	uint32_t asize;
+	int rval;
+
+	if (!IS_ENABLED(CONFIG_OF) || !dev->of_node)
+		return dev->platform_data;
+
+	ep = of_graph_get_next_endpoint(dev->of_node, NULL);
+	if (!ep)
+		return NULL;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		rval = -ENOMEM;
+		goto out_err;
+	}
+
+	v4l2_of_parse_endpoint(ep, &bus_cfg);
+
+	switch (bus_cfg.bus_type) {
+	case V4L2_MBUS_CSI2:
+		pdata->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
+		break;
+		/* FIXME: add CCP2 support. */
+	default:
+		rval = -EINVAL;
+		goto out_err;
+	}
+
+	pdata->lanes = bus_cfg.bus.mipi_csi2.num_data_lanes;
+	dev_dbg(dev, "lanes %u\n", pdata->lanes);
+
+	/* xshutdown GPIO is optional */
+	pdata->xshutdown = of_get_named_gpio(dev->of_node, "reset-gpios", 0);
+
+	/* NVM size is not mandatory */
+	of_property_read_u32(dev->of_node, "nokia,nvm-size",
+				    &pdata->nvm_size);
+
+	rval = of_property_read_u32(dev->of_node, "clock-frequency",
+				    &pdata->ext_clk);
+	if (rval) {
+		dev_warn(dev, "can't get clock-frequency\n");
+		goto out_err;
+	}
+
+	dev_dbg(dev, "reset %d, nvm %d, clk %d, csi %d\n", pdata->xshutdown,
+		pdata->nvm_size, pdata->ext_clk, pdata->csi_signalling_mode);
+
+	rval = of_get_property(
+		dev->of_node, "link-frequency", &asize) ? 0 : -ENOENT;
+	if (rval) {
+		dev_warn(dev, "can't get link-frequency array size\n");
+		goto out_err;
+	}
+
+	pdata->op_sys_clock = devm_kzalloc(dev, asize, GFP_KERNEL);
+	if (!pdata->op_sys_clock) {
+		rval = -ENOMEM;
+		goto out_err;
+	}
+
+	asize /= sizeof(*pdata->op_sys_clock);
+	rval = of_property_read_u64_array(
+		dev->of_node, "link-frequency", pdata->op_sys_clock, asize);
+	if (rval) {
+		dev_warn(dev, "can't get link-frequency\n");
+		goto out_err;
+	}
+
+	for (; asize > 0; asize--)
+		dev_dbg(dev, "freq %d: %lld\n", asize - 1,
+			pdata->op_sys_clock[asize - 1]);
+
+	of_node_put(ep);
+	return pdata;
+
+out_err:
+	of_node_put(ep);
+	return NULL;
+}
+
 static int smiapp_probe(struct i2c_client *client,
 			const struct i2c_device_id *devid)
 {
 	struct smiapp_sensor *sensor;
+	struct smiapp_platform_data *pdata = smiapp_get_pdata(&client->dev);
+	int rval;
 
-	if (client->dev.platform_data == NULL)
+	if (pdata == NULL)
 		return -ENODEV;
 
 	sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
 	if (sensor == NULL)
 		return -ENOMEM;
 
-	sensor->platform_data = client->dev.platform_data;
+	sensor->platform_data = pdata;
 	mutex_init(&sensor->mutex);
 	mutex_init(&sensor->power_mutex);
 	sensor->src = &sensor->ssds[sensor->ssds_used];
@@ -2991,6 +3081,11 @@ static int smiapp_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct of_device_id smiapp_of_table[] = {
+	{ .compatible = "nokia,smia" },
+	{ },
+};
+
 static const struct i2c_device_id smiapp_id_table[] = {
 	{ SMIAPP_NAME, 0 },
 	{ },
@@ -3004,6 +3099,7 @@ static const struct dev_pm_ops smiapp_pm_ops = {
 
 static struct i2c_driver smiapp_i2c_driver = {
 	.driver	= {
+		.of_match_table = smiapp_of_table,
 		.name = SMIAPP_NAME,
 		.pm = &smiapp_pm_ops,
 	},
-- 
1.7.10.4

