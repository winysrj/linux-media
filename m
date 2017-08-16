Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49022 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751949AbdHPMvy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:51:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 5/5] omap3isp: Correctly configure routing in PHY release
Date: Wed, 16 Aug 2017 15:51:50 +0300
Message-Id: <20170816125150.27199-6-sakari.ailus@linux.intel.com>
In-Reply-To: <20170816125150.27199-1-sakari.ailus@linux.intel.com>
References: <20170816125150.27199-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PHY configuration was obtained from DT when the PHY was acquired but
the same was not done when it was released. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/ispcsiphy.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index ed1eb9907ae0..45ed1adbd9ae 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -155,6 +155,17 @@ static int csiphy_set_power(struct isp_csiphy *phy, u32 power)
 	return 0;
 }
 
+static struct isp_bus_cfg *omap3isp_csiphy_get_phy_cfg(
+	struct isp_csiphy *phy)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(phy->entity);
+	struct isp_async_subdev *isd =
+		container_of(pipe->external->asd, struct isp_async_subdev, asd);
+
+	return pipe->external->host_priv ?
+		pipe->external->host_priv : &isd->bus;
+}
+
 /*
  * TCLK values are OK at their reset values
  */
@@ -165,10 +176,7 @@ static int csiphy_set_power(struct isp_csiphy *phy, u32 power)
 static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 {
 	struct isp_pipeline *pipe = to_isp_pipeline(phy->entity);
-	struct isp_async_subdev *isd =
-		container_of(pipe->external->asd, struct isp_async_subdev, asd);
-	struct isp_bus_cfg *buscfg = pipe->external->host_priv ?
-		pipe->external->host_priv : &isd->bus;
+	struct isp_bus_cfg *buscfg = omap3isp_csiphy_get_phy_cfg(phy);
 	struct isp_csiphy_lanes_cfg *lanes;
 	int csi2_ddrclk_khz;
 	unsigned int num_data_lanes, used_lanes = 0;
@@ -310,8 +318,7 @@ void omap3isp_csiphy_release(struct isp_csiphy *phy)
 {
 	mutex_lock(&phy->mutex);
 	if (phy->entity) {
-		struct isp_pipeline *pipe = to_isp_pipeline(phy->entity);
-		struct isp_bus_cfg *buscfg = pipe->external->host_priv;
+		struct isp_bus_cfg *buscfg = omap3isp_csiphy_get_phy_cfg(phy);
 
 		csiphy_routing_cfg(phy, buscfg->interface, false,
 				   buscfg->bus.ccp2.phy_layer);
-- 
2.11.0
