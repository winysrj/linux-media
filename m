Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52822 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751714AbdBMQQc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 11:16:32 -0500
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id CAB13600AD
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 18:16:27 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] smiapp: Verify clock frequency after setting it, prevent changing it
Date: Mon, 13 Feb 2017 18:16:24 +0200
Message-Id: <1487002586-1480-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1487002586-1480-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1487002586-1480-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The external clock frequency was set by the driver but the obtained
frequency was never verified. Do that.

Being able to obtain the exact frequency is important as the value is used
for PLL calculations which may result in frequencies that violate the PLL
tree limits.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 0ea0303..64ee215 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2861,6 +2861,7 @@ static int smiapp_probe(struct i2c_client *client,
 {
 	struct smiapp_sensor *sensor;
 	struct smiapp_hwconfig *hwcfg = smiapp_get_hwconfig(&client->dev);
+	unsigned long rate;
 	unsigned int i;
 	int rval;
 
@@ -2899,6 +2900,14 @@ static int smiapp_probe(struct i2c_client *client,
 		return rval;
 	}
 
+	rate = clk_get_rate(sensor->ext_clk);
+	if (rate != sensor->hwcfg->ext_clk) {
+		dev_err(&client->dev,
+			"can't set clock freq, asked for %u but got %lu\n",
+			sensor->hwcfg->ext_clk, rate);
+		return rval;
+	}
+
 	sensor->xshutdown = devm_gpiod_get_optional(&client->dev, "xshutdown",
 						    GPIOD_OUT_LOW);
 	if (IS_ERR(sensor->xshutdown))
-- 
2.1.4
