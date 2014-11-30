Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40190 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751917AbaK3Q24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Nov 2014 11:28:56 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org
Subject: [REVIEW PATCH v2.1 09/11] smiapp: Obtain device information from the Device Tree if OF node exists
Date: Sun, 30 Nov 2014 18:28:47 +0200
Message-Id: <1417364927-4894-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289426-804-10-git-send-email-sakari.ailus@iki.fi>
References: <1416289426-804-10-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Platform data support is retained.

of_property_read_u64_array() isn't used yet as it's not in yet.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
since v2:
- Don't use of_property_read_u64_array() yet.

 drivers/media/i2c/smiapp/smiapp-core.c |  114 +++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index b02fa64..465c42f 100644
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
 
@@ -2921,19 +2923,121 @@ static int smiapp_resume(struct device *dev)
 
 #endif /* CONFIG_PM */
 
+static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
+{
+	struct smiapp_platform_data *pdata;
+	struct v4l2_of_endpoint bus_cfg;
+	struct device_node *ep;
+	struct property *prop;
+	__be32 *val;
+	uint32_t asize;
+	unsigned int i;
+	int rval;
+
+	if (!dev->of_node)
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
+	/*
+	 * Read a 64-bit array --- this will be replaced with a
+	 * of_property_read_u64_array() once it's merged.
+	 */
+	prop = of_find_property(dev->of_node, "link-frequency", NULL);
+	if (!prop)
+		goto out_err;
+	if (!prop->value)
+		goto out_err;
+	if (asize * sizeof(*pdata->op_sys_clock) > prop->length)
+		goto out_err;
+	val = prop->value;
+	if (IS_ERR(val))
+		goto out_err;
+
+	for (i = 0; i < asize; i++)
+		pdata->op_sys_clock[i] = of_read_number(val + i * 2, 2);
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
@@ -2992,6 +3096,11 @@ static int smiapp_remove(struct i2c_client *client)
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
@@ -3005,6 +3114,7 @@ static const struct dev_pm_ops smiapp_pm_ops = {
 
 static struct i2c_driver smiapp_i2c_driver = {
 	.driver	= {
+		.of_match_table = smiapp_of_table,
 		.name = SMIAPP_NAME,
 		.pm = &smiapp_pm_ops,
 	},
-- 
1.7.10.4

