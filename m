Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41992 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752040AbdGEXAZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 19:00:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 6/8] smiapp: add CCP2 support
Date: Thu,  6 Jul 2017 02:00:17 +0300
Message-Id: <20170705230019.5461-7-sakari.ailus@linux.intel.com>
In-Reply-To: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pavel Machek <pavel@ucw.cz>

Add support for CCP2 connected SMIA sensors as found
on the Nokia N900.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e0b0c032c4ac..aff55e1dffe7 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2809,13 +2809,19 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 	switch (bus_cfg->bus_type) {
 	case V4L2_MBUS_CSI2:
 		hwcfg->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
+		hwcfg->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
+		break;
+	case V4L2_MBUS_CCP2:
+		hwcfg->csi_signalling_mode = (bus_cfg->bus.mipi_csi1.strobe) ?
+		SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE :
+		SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK;
+		hwcfg->lanes = 1;
 		break;
-		/* FIXME: add CCP2 support. */
 	default:
+		dev_err(dev, "unsupported bus %u\n", bus_cfg->bus_type);
 		goto out_err;
 	}
 
-	hwcfg->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
 	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
 
 	/* NVM size is not mandatory */
@@ -2828,8 +2834,8 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 		goto out_err;
 	}
 
-	dev_dbg(dev, "nvm %d, clk %d, csi %d\n", hwcfg->nvm_size,
-		hwcfg->ext_clk, hwcfg->csi_signalling_mode);
+	dev_dbg(dev, "nvm %d, clk %d, mode %d\n",
+		hwcfg->nvm_size, hwcfg->ext_clk, hwcfg->csi_signalling_mode);
 
 	if (!bus_cfg->nr_of_link_frequencies) {
 		dev_warn(dev, "no link frequencies defined\n");
-- 
2.11.0
