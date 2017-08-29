Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51938 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751429AbdH2Ml2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 08:41:28 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 87EBB600E2
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 15:41:26 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] smiapp: Verify clock frequency after setting it, prevent changing it
Date: Tue, 29 Aug 2017 15:41:23 +0300
Message-Id: <20170829124125.30879-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20170829124125.30879-1-sakari.ailus@linux.intel.com>
References: <20170829124125.30879-1-sakari.ailus@linux.intel.com>
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
index d581625d7826..55771826b446 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2870,6 +2870,7 @@ static int smiapp_probe(struct i2c_client *client,
 {
 	struct smiapp_sensor *sensor;
 	struct smiapp_hwconfig *hwcfg = smiapp_get_hwconfig(&client->dev);
+	unsigned long rate;
 	unsigned int i;
 	int rval;
 
@@ -2908,6 +2909,14 @@ static int smiapp_probe(struct i2c_client *client,
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
2.11.0
