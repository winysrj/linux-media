Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60038 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752013AbdGRTEI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 17/19] omap3isp: Drop the async notifier callback
Date: Tue, 18 Jul 2017 22:03:59 +0300
Message-Id: <20170718190401.14797-18-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_device_register_subdev_nodes() is now nop and can be dropped without
side effects. Do so.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 68c02ea1fe6f..ae867eb3fd15 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2102,18 +2102,6 @@ static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
 	return isp_link_entity(isp, &sd->entity, isd->bus.interface);
 }
 
-static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
-{
-	struct isp_device *isp = container_of(async, struct isp_device,
-					      notifier);
-	struct v4l2_device *v4l2_dev = &isp->v4l2_dev;
-	struct v4l2_subdev *sd;
-	struct isp_bus_cfg *bus;
-	int ret;
-
-        return v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
-}
-
 /*
  * isp_probe - Probe ISP platform device
  * @pdev: Pointer to ISP platform device
@@ -2289,7 +2277,6 @@ static int isp_probe(struct platform_device *pdev)
 		goto error_register_entities;
 
 	isp->notifier.bound = isp_subdev_notifier_bound;
-	isp->notifier.complete = isp_subdev_notifier_complete;
 
 	ret = v4l2_async_notifier_register(&isp->v4l2_dev, &isp->notifier);
 	if (ret)
-- 
2.11.0
