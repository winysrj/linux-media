Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60052 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751990AbdGRTEI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 14/19] omap3isp: Move sub-device link creation to notifier bound callback
Date: Tue, 18 Jul 2017 22:03:56 +0300
Message-Id: <20170718190401.14797-15-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The external sub-device links may well be created from the bound callback.
Don't postpone creation to the complete callback.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 92245a457d18..ef6ce2b214ce 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2085,16 +2085,18 @@ static int isp_fwnode_parse(struct device *dev,
 }
 
 static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
-				     struct v4l2_subdev *subdev,
+				     struct v4l2_subdev *sd,
 				     struct v4l2_async_subdev *asd)
 {
+	struct isp_device *isp = container_of(async, struct isp_device,
+					      notifier);
 	struct isp_async_subdev *isd =
 		container_of(asd, struct isp_async_subdev, asd);
 
-	isd->sd = subdev;
-	isd->sd->host_priv = &isd->bus;
+	isd->sd = sd;
+	sd->host_priv = &isd->bus;
 
-	return 0;
+	return isp_link_entity(isp, &sd->entity, isd->bus.interface);
 }
 
 static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
@@ -2110,16 +2112,6 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 	if (ret)
 		return ret;
 
-	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
-		/* Only try to link entities whose interface was set on bound */
-		if (sd->host_priv) {
-			bus = (struct isp_bus_cfg *)sd->host_priv;
-			ret = isp_link_entity(isp, &sd->entity, bus->interface);
-			if (ret < 0)
-				return ret;
-		}
-	}
-
 	ret = v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
 	if (ret < 0)
 		return ret;
-- 
2.11.0
