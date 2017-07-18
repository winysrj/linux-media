Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60014 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751995AbdGRTEI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 15/19] omap3isp: Initialise "crashed" media entity enum in probe
Date: Tue, 18 Jul 2017 22:03:57 +0300
Message-Id: <20170718190401.14797-16-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialise the struct isp_device.crashed media entity enum field when the
ISP's local media entities have been registered, in probe. This is to make
sure that the enumeration is initialised and large enough when the media
device is made visible.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index ef6ce2b214ce..90da8343b3dd 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1592,6 +1592,7 @@ static void isp_pm_complete(struct device *dev)
 
 static void isp_unregister_entities(struct isp_device *isp)
 {
+	media_entity_enum_cleanup(&isp->crashed);
 	omap3isp_csi2_unregister_entities(&isp->isp_csi2a);
 	omap3isp_ccp2_unregister_entities(&isp->isp_ccp2);
 	omap3isp_ccdc_unregister_entities(&isp->isp_ccdc);
@@ -1730,6 +1731,10 @@ static int isp_register_entities(struct isp_device *isp)
 	if (ret < 0)
 		goto done;
 
+	ret = media_entity_enum_init(&isp->crashed, &isp->media_dev);
+	if (ret)
+		return ret;
+
 done:
 	if (ret < 0)
 		isp_unregister_entities(isp);
@@ -1997,8 +2002,6 @@ static int isp_remove(struct platform_device *pdev)
 	isp_detach_iommu(isp);
 	__omap3isp_put(isp, false);
 
-	media_entity_enum_cleanup(&isp->crashed);
-
 	return 0;
 }
 
@@ -2108,10 +2111,6 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 	struct isp_bus_cfg *bus;
 	int ret;
 
-	ret = media_entity_enum_init(&isp->crashed, &isp->media_dev);
-	if (ret)
-		return ret;
-
 	ret = v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
 	if (ret < 0)
 		return ret;
-- 
2.11.0
