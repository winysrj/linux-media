Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58120 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdGRPvb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 11:51:31 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] v4l: omap3isp: Get the parallel bus type from DT
Date: Tue, 18 Jul 2017 18:51:35 +0300
Message-Id: <20170718155135.29632-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OMAP3 ISP supports both external and embedded BT.656 synchronization
for parallel buses. It currently gets the bus type information from the
source subdev through the .g_mbus_config() operation, but should instead
get it from DT as that's the authoritative source of bus configuration
information.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c      | 1 +
 drivers/media/platform/omap3isp/ispccdc.c  | 8 +-------
 drivers/media/platform/omap3isp/omap3isp.h | 2 ++
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 9df64c189883..5ddf3396b7da 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2039,6 +2039,7 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 			!!(vep.bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
 		buscfg->bus.parallel.data_pol =
 			!!(vep.bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
+		buscfg->bus.parallel.bt656 = vep.bus_type == V4L2_MBUS_BT656;
 		break;
 
 	case ISP_OF_PHY_CSIPHY1:
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 7207558d722c..4947876cfadf 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1139,15 +1139,9 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	pad = media_entity_remote_pad(&ccdc->pads[CCDC_PAD_SINK]);
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
 	if (ccdc->input == CCDC_INPUT_PARALLEL) {
-		struct v4l2_mbus_config cfg;
-		int ret;
-
-		ret = v4l2_subdev_call(sensor, video, g_mbus_config, &cfg);
-		if (!ret)
-			ccdc->bt656 = cfg.type == V4L2_MBUS_BT656;
-
 		parcfg = &((struct isp_bus_cfg *)sensor->host_priv)
 			->bus.parallel;
+		ccdc->bt656 = parcfg->bt656;
 	}
 
 	/* CCDC_PAD_SINK */
diff --git a/drivers/media/platform/omap3isp/omap3isp.h b/drivers/media/platform/omap3isp/omap3isp.h
index 443e8f7673e2..48508d452556 100644
--- a/drivers/media/platform/omap3isp/omap3isp.h
+++ b/drivers/media/platform/omap3isp/omap3isp.h
@@ -46,6 +46,7 @@ enum isp_interface_type {
  *		0 - Positive, 1 - Negative
  * @data_pol: Data polarity
  *		0 - Normal, 1 - One's complement
+ * @bt656: Data contain BT.656 embedded synchronization
  */
 struct isp_parallel_cfg {
 	unsigned int data_lane_shift:3;
@@ -54,6 +55,7 @@ struct isp_parallel_cfg {
 	unsigned int vs_pol:1;
 	unsigned int fld_pol:1;
 	unsigned int data_pol:1;
+	unsigned int bt656;
 };
 
 enum {
-- 
Regards,

Laurent Pinchart
