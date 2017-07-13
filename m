Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47670 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752578AbdGMQTH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 12:19:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 2/2] omap3isp: add CSI1 support
Date: Thu, 13 Jul 2017 19:19:03 +0300
Message-Id: <20170713161903.9974-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
References: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pavel Machek <pavel@ucw.cz>

CSI-2 PHY power management is only needed for major version 15 of the ISP.
Additionally, set the CCP2 PHY for previous ISP versions as well.

These changes are necessary for CCP2 support.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/ispccp2.c   |  1 +
 drivers/media/platform/omap3isp/ispcsiphy.c | 19 ++++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index ca095238510d..588f67a89f79 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1141,6 +1141,7 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 				"Could not get regulator vdds_csib\n");
 			ccp2->vdds_csib = NULL;
 		}
+		ccp2->phy = &isp->isp_csiphy2;
 	} else if (isp->revision == ISP_REVISION_15_0) {
 		ccp2->phy = &isp->isp_csiphy1;
 	}
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index 3efa71396aae..addc6efbb033 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -292,13 +292,16 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
 	if (rval < 0)
 		goto done;
 
-	rval = csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
-	if (rval) {
-		regulator_disable(phy->vdd);
-		goto done;
+	if (phy->isp->revision == ISP_REVISION_15_0) {
+		rval = csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
+		if (rval) {
+			regulator_disable(phy->vdd);
+			goto done;
+		}
+
+		csiphy_power_autoswitch_enable(phy, true);
 	}
 
-	csiphy_power_autoswitch_enable(phy, true);
 	phy->phy_in_use = 1;
 
 done:
@@ -317,8 +320,10 @@ void omap3isp_csiphy_release(struct isp_csiphy *phy)
 
 		csiphy_routing_cfg(phy, buscfg->interface, false,
 				   buscfg->bus.ccp2.phy_layer);
-		csiphy_power_autoswitch_enable(phy, false);
-		csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_OFF);
+		if (phy->isp->revision == ISP_REVISION_15_0) {
+			csiphy_power_autoswitch_enable(phy, false);
+			csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_OFF);
+		}
 		regulator_disable(phy->vdd);
 		phy->phy_in_use = 0;
 	}
-- 
2.11.0
