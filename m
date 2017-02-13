Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52820 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751023AbdBMQQb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 11:16:31 -0500
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id DB883600AE
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 18:16:27 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] smiapp: Get clock rate if it's not available through DT
Date: Mon, 13 Feb 2017 18:16:25 +0200
Message-Id: <1487002586-1480-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1487002586-1480-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1487002586-1480-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Obtain the clock rate from the clock framework if it's not available
through DT. The assumption is that the parent device (camera module)
defines the rate as clock control is a part of the power on and power off
sequences --- which are camera module specific.

Also use the clock rate from DT if no clock is provided.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 50 ++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 64ee215..caf376c 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2822,10 +2822,8 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 
 	rval = of_property_read_u32(dev->of_node, "clock-frequency",
 				    &hwcfg->ext_clk);
-	if (rval) {
-		dev_warn(dev, "can't get clock-frequency\n");
-		goto out_err;
-	}
+	if (rval)
+		dev_info(dev, "can't get clock-frequency\n");
 
 	dev_dbg(dev, "nvm %d, clk %d, csi %d\n", hwcfg->nvm_size,
 		hwcfg->ext_clk, hwcfg->csi_signalling_mode);
@@ -2861,7 +2859,6 @@ static int smiapp_probe(struct i2c_client *client,
 {
 	struct smiapp_sensor *sensor;
 	struct smiapp_hwconfig *hwcfg = smiapp_get_hwconfig(&client->dev);
-	unsigned long rate;
 	unsigned int i;
 	int rval;
 
@@ -2892,20 +2889,37 @@ static int smiapp_probe(struct i2c_client *client,
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
+					"can't set clock freq, asked for %lu but got %lu\n",
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
2.1.4
