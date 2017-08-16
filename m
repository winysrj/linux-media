Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53234 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751847AbdHPRjp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 13:39:45 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2.3 5/5] omap3isp: Quit using struct v4l2_subdev.host_priv field
Date: Wed, 16 Aug 2017 20:39:43 +0300
Message-Id: <20170816173943.10960-1-sakari.ailus@linux.intel.com>
In-Reply-To: <2067172.E4Ie4fgXf9@avalon>
References: <2067172.E4Ie4fgXf9@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct v4l2_subdev.host_priv is intended to be used by another driver. This
is hardly good design but back in the days of platform data was a quick
hack to get things done.

As the sub-device specific bus information can be stored to the ISP driver
specific struct allocated along with v4l2_async_subdev, keep the
information there and only there.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v2.2:

- Introduce a macro v4l2_subdev_to_bus_cfg() in order to remove
  non-trivial usage in places where conversion from sub-device to ISP bus
  configuration is needed.

 drivers/media/platform/omap3isp/isp.c       | 29 +++++++----------------------
 drivers/media/platform/omap3isp/isp.h       |  4 +++-
 drivers/media/platform/omap3isp/ispccdc.c   | 12 ++++++------
 drivers/media/platform/omap3isp/ispccp2.c   |  3 ++-
 drivers/media/platform/omap3isp/ispcsi2.c   |  2 +-
 drivers/media/platform/omap3isp/ispcsiphy.c |  8 +++-----
 6 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 6cb1f0495804..c3014c82d64d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2188,26 +2188,12 @@ static int isp_fwnodes_parse(struct device *dev,
 	return -EINVAL;
 }
 
-static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
-				     struct v4l2_subdev *subdev,
-				     struct v4l2_async_subdev *asd)
-{
-	struct isp_async_subdev *isd =
-		container_of(asd, struct isp_async_subdev, asd);
-
-	isd->sd = subdev;
-	isd->sd->host_priv = &isd->bus;
-
-	return 0;
-}
-
 static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 {
 	struct isp_device *isp = container_of(async, struct isp_device,
 					      notifier);
 	struct v4l2_device *v4l2_dev = &isp->v4l2_dev;
 	struct v4l2_subdev *sd;
-	struct isp_bus_cfg *bus;
 	int ret;
 
 	ret = media_entity_enum_init(&isp->crashed, &isp->media_dev);
@@ -2215,13 +2201,13 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 		return ret;
 
 	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
-		/* Only try to link entities whose interface was set on bound */
-		if (sd->host_priv) {
-			bus = (struct isp_bus_cfg *)sd->host_priv;
-			ret = isp_link_entity(isp, &sd->entity, bus->interface);
-			if (ret < 0)
-				return ret;
-		}
+		if (!sd->asd)
+			continue;
+
+		ret = isp_link_entity(isp, &sd->entity,
+				      v4l2_subdev_to_bus_cfg(sd)->interface);
+		if (ret < 0)
+			return ret;
 	}
 
 	ret = v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
@@ -2399,7 +2385,6 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_register_entities;
 
-	isp->notifier.bound = isp_subdev_notifier_bound;
 	isp->notifier.complete = isp_subdev_notifier_complete;
 
 	ret = v4l2_async_notifier_register(&isp->v4l2_dev, &isp->notifier);
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 2f2ae609c548..e528df6efc09 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -226,11 +226,13 @@ struct isp_device {
 };
 
 struct isp_async_subdev {
-	struct v4l2_subdev *sd;
 	struct isp_bus_cfg bus;
 	struct v4l2_async_subdev asd;
 };
 
+#define v4l2_subdev_to_bus_cfg(sd) \
+	(&container_of((sd)->asd, struct isp_async_subdev, asd)->bus)
+
 #define v4l2_dev_to_isp_device(dev) \
 	container_of(dev, struct isp_device, v4l2_dev)
 
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 4947876cfadf..80fed9526945 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1139,7 +1139,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	pad = media_entity_remote_pad(&ccdc->pads[CCDC_PAD_SINK]);
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
 	if (ccdc->input == CCDC_INPUT_PARALLEL) {
-		parcfg = &((struct isp_bus_cfg *)sensor->host_priv)
+		parcfg = &v4l2_subdev_to_bus_cfg(
+			to_isp_pipeline(&ccdc->subdev.entity)->external)
 			->bus.parallel;
 		ccdc->bt656 = parcfg->bt656;
 	}
@@ -2412,11 +2413,10 @@ static int ccdc_link_validate(struct v4l2_subdev *sd,
 
 	/* We've got a parallel sensor here. */
 	if (ccdc->input == CCDC_INPUT_PARALLEL) {
-		struct isp_parallel_cfg *parcfg =
-			&((struct isp_bus_cfg *)
-			  media_entity_to_v4l2_subdev(link->source->entity)
-			  ->host_priv)->bus.parallel;
-		parallel_shift = parcfg->data_lane_shift;
+		parallel_shift =
+			v4l2_subdev_to_bus_cfg(
+				to_isp_pipeline(&ccdc->subdev.entity)->external)
+			->bus.parallel.data_lane_shift;
 	} else {
 		parallel_shift = 0;
 	}
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 3db8df09cd9a..e062939d0d05 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -350,6 +350,7 @@ static void ccp2_lcx_config(struct isp_ccp2_device *ccp2,
  */
 static int ccp2_if_configure(struct isp_ccp2_device *ccp2)
 {
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccp2->subdev.entity);
 	const struct isp_bus_cfg *buscfg;
 	struct v4l2_mbus_framefmt *format;
 	struct media_pad *pad;
@@ -361,7 +362,7 @@ static int ccp2_if_configure(struct isp_ccp2_device *ccp2)
 
 	pad = media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
-	buscfg = sensor->host_priv;
+	buscfg = v4l2_subdev_to_bus_cfg(pipe->external);
 
 	ret = ccp2_phyif_config(ccp2, &buscfg->bus.ccp2);
 	if (ret < 0)
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 3ec37fed710b..a4d3d030e81e 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -566,7 +566,7 @@ static int csi2_configure(struct isp_csi2_device *csi2)
 
 	pad = media_entity_remote_pad(&csi2->pads[CSI2_PAD_SINK]);
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
-	buscfg = sensor->host_priv;
+	buscfg = v4l2_subdev_to_bus_cfg(pipe->external);
 
 	csi2->frame_skip = 0;
 	v4l2_subdev_call(sensor, sensor, g_skip_frames, &csi2->frame_skip);
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index ed1eb9907ae0..a28fb79abaac 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -165,10 +165,7 @@ static int csiphy_set_power(struct isp_csiphy *phy, u32 power)
 static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 {
 	struct isp_pipeline *pipe = to_isp_pipeline(phy->entity);
-	struct isp_async_subdev *isd =
-		container_of(pipe->external->asd, struct isp_async_subdev, asd);
-	struct isp_bus_cfg *buscfg = pipe->external->host_priv ?
-		pipe->external->host_priv : &isd->bus;
+	struct isp_bus_cfg *buscfg = v4l2_subdev_to_bus_cfg(pipe->external);
 	struct isp_csiphy_lanes_cfg *lanes;
 	int csi2_ddrclk_khz;
 	unsigned int num_data_lanes, used_lanes = 0;
@@ -311,7 +308,8 @@ void omap3isp_csiphy_release(struct isp_csiphy *phy)
 	mutex_lock(&phy->mutex);
 	if (phy->entity) {
 		struct isp_pipeline *pipe = to_isp_pipeline(phy->entity);
-		struct isp_bus_cfg *buscfg = pipe->external->host_priv;
+		struct isp_bus_cfg *buscfg =
+			v4l2_subdev_to_bus_cfg(pipe->external);
 
 		csiphy_routing_cfg(phy, buscfg->interface, false,
 				   buscfg->bus.ccp2.phy_layer);
-- 
2.11.0
