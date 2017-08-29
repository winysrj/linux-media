Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51940 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751390AbdH2Ml2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 08:41:28 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id B90AC600F6
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 15:41:26 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] smiapp: Get clock rate if it's not available through DT
Date: Tue, 29 Aug 2017 15:41:24 +0300
Message-Id: <20170829124125.30879-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20170829124125.30879-1-sakari.ailus@linux.intel.com>
References: <20170829124125.30879-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Obtain the clock rate from the clock framework if it's not available
through DT. The assumption is that the parent device (camera module)
defines the rate as clock control is a part of the power on and power off
sequences --- which are camera module specific.

Also use the clock rate from DT if no clock is provided.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 52 +++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 55771826b446..009b5e26204b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2829,12 +2829,10 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 	/* NVM size is not mandatory */
 	fwnode_property_read_u32(fwnode, "nokia,nvm-size", &hwcfg->nvm_size);
 
-	rval = fwnode_property_read_u32(fwnode, "clock-frequency",
+	rval = fwnode_property_read_u32(dev_fwnode(dev), "clock-frequency",
 					&hwcfg->ext_clk);
-	if (rval) {
-		dev_warn(dev, "can't get clock-frequency\n");
-		goto out_err;
-	}
+	if (rval)
+		dev_info(dev, "can't get clock-frequency\n");
 
 	dev_dbg(dev, "nvm %d, clk %d, mode %d\n",
 		hwcfg->nvm_size, hwcfg->ext_clk, hwcfg->csi_signalling_mode);
@@ -2870,7 +2868,6 @@ static int smiapp_probe(struct i2c_client *client,
 {
 	struct smiapp_sensor *sensor;
 	struct smiapp_hwconfig *hwcfg = smiapp_get_hwconfig(&client->dev);
-	unsigned long rate;
 	unsigned int i;
 	int rval;
 
@@ -2901,20 +2898,37 @@ static int smiapp_probe(struct i2c_client *client,
 		return -EPROBE_DEFER;
 	}
 
-	rval = clk_set_rate(sensor->ext_clk, sensor->hwcfg->ext_clk);
-	if (rval < 0) {
-		dev_err(&client->dev,
-			"unable to set clock freq to %u\n",
-			sensor->hwcfg->ext_clk);
-		return rval;
-	}
+	if (sensor->ext_clk) {
+		if (sensor->hwcfg->ext_clk) {
+			unsigned long rate;
 
-	rate = clk_get_rate(sensor->ext_clk);
-	if (rate != sensor->hwcfg->ext_clk) {
-		dev_err(&client->dev,
-			"can't set clock freq, asked for %u but got %lu\n",
-			sensor->hwcfg->ext_clk, rate);
-		return rval;
+			rval = clk_set_rate(sensor->ext_clk,
+					    sensor->hwcfg->ext_clk);
+			if (rval < 0) {
+				dev_err(&client->dev,
+					"unable to set clock freq to %u\n",
+					sensor->hwcfg->ext_clk);
+				return rval;
+			}
+
+			rate = clk_get_rate(sensor->ext_clk);
+			if (rate != sensor->hwcfg->ext_clk) {
+				dev_err(&client->dev,
+					"can't set clock freq, asked for %u but got %lu\n",
+					sensor->hwcfg->ext_clk, rate);
+				return rval;
+			}
+		} else {
+			sensor->hwcfg->ext_clk = clk_get_rate(sensor->ext_clk);
+			dev_dbg(&client->dev, "obtained clock freq %u\n",
+				sensor->hwcfg->ext_clk);
+		}
+	} else if (sensor->hwcfg->ext_clk) {
+		dev_dbg(&client->dev, "assuming clock freq %u\n",
+			sensor->hwcfg->ext_clk);
+	} else {
+		dev_err(&client->dev, "unable to obtain clock freq\n");
+		return -EINVAL;
 	}
 
 	sensor->xshutdown = devm_gpiod_get_optional(&client->dev, "xshutdown",
-- 
2.11.0
