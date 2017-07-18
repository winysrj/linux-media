Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60012 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751693AbdGRTEI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 16/19] omap3isp: Move media device registration to probe
Date: Tue, 18 Jul 2017 22:03:58 +0300
Message-Id: <20170718190401.14797-17-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register the media device in probe, thus making the omap3isp device usable
once the driver is registered.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 90da8343b3dd..68c02ea1fe6f 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1592,6 +1592,7 @@ static void isp_pm_complete(struct device *dev)
 
 static void isp_unregister_entities(struct isp_device *isp)
 {
+	media_device_unregister(&isp->media_dev);
 	media_entity_enum_cleanup(&isp->crashed);
 	omap3isp_csi2_unregister_entities(&isp->isp_csi2a);
 	omap3isp_ccp2_unregister_entities(&isp->isp_ccp2);
@@ -1603,7 +1604,6 @@ static void isp_unregister_entities(struct isp_device *isp)
 	omap3isp_stat_unregister_entities(&isp->isp_hist);
 
 	v4l2_device_unregister(&isp->v4l2_dev);
-	media_device_unregister(&isp->media_dev);
 	media_device_cleanup(&isp->media_dev);
 }
 
@@ -2111,11 +2111,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 	struct isp_bus_cfg *bus;
 	int ret;
 
-	ret = v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
-	if (ret < 0)
-		return ret;
-
-	return media_device_register(&isp->media_dev);
+        return v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
 }
 
 /*
@@ -2284,6 +2280,10 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_modules;
 
+	ret = media_device_register(&isp->media_dev);
+	if (ret < 0)
+		goto error_media_device;
+
 	ret = isp_create_links(isp);
 	if (ret < 0)
 		goto error_register_entities;
@@ -2301,6 +2301,8 @@ static int isp_probe(struct platform_device *pdev)
 	return 0;
 
 error_register_entities:
+	media_device_unregister(&isp->media_dev);
+error_media_device:
 	isp_unregister_entities(isp);
 error_modules:
 	isp_cleanup_modules(isp);
-- 
2.11.0
