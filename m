Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27127 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752915AbcJEHXU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:23:20 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 2973320F9C
        for <linux-media@vger.kernel.org>; Wed,  5 Oct 2016 10:23:17 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [RFC 5/5] smiapp: Switch to fwnode API
Date: Wed,  5 Oct 2016 10:21:49 +0300
Message-Id: <1475652109-22164-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e0d7586..e07d38e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -27,12 +27,13 @@
 #include <linux/gpio/consumer.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/smiapp.h>
 #include <linux/v4l2-mediabus.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-of.h>
 
 #include "smiapp.h"
 
@@ -2793,19 +2794,20 @@ static int smiapp_resume(struct device *dev)
 static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 {
 	struct smiapp_hwconfig *hwcfg;
-	struct v4l2_of_endpoint *bus_cfg;
-	struct device_node *ep;
+	struct v4l2_fwnode_endpoint *bus_cfg;
+	struct fwnode_handle *ep;
+	struct fwnode_handle *fwn = device_fwnode_handle(dev);
 	int i;
 	int rval;
 
-	if (!dev->of_node)
+	if (!fwn)
 		return dev->platform_data;
 
-	ep = of_graph_get_next_endpoint(dev->of_node, NULL);
+	ep = fwnode_graph_get_next_endpoint(fwn, NULL);
 	if (!ep)
 		return NULL;
 
-	bus_cfg = v4l2_of_alloc_parse_endpoint(ep);
+	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(ep);
 	if (IS_ERR(bus_cfg))
 		goto out_err;
 
@@ -2826,11 +2828,10 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
 
 	/* NVM size is not mandatory */
-	of_property_read_u32(dev->of_node, "nokia,nvm-size",
-				    &hwcfg->nvm_size);
+	fwnode_property_read_u32(fwn, "nokia,nvm-size", &hwcfg->nvm_size);
 
-	rval = of_property_read_u32(dev->of_node, "clock-frequency",
-				    &hwcfg->ext_clk);
+	rval = fwnode_property_read_u32(fwn, "clock-frequency",
+					&hwcfg->ext_clk);
 	if (rval) {
 		dev_warn(dev, "can't get clock-frequency\n");
 		goto out_err;
@@ -2855,13 +2856,13 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 		dev_dbg(dev, "freq %d: %lld\n", i, hwcfg->op_sys_clock[i]);
 	}
 
-	v4l2_of_free_endpoint(bus_cfg);
-	of_node_put(ep);
+	v4l2_fwnode_endpoint_free(bus_cfg);
+	fwnode_handle_put(ep);
 	return hwcfg;
 
 out_err:
-	v4l2_of_free_endpoint(bus_cfg);
-	of_node_put(ep);
+	v4l2_fwnode_endpoint_free(bus_cfg);
+	fwnode_handle_put(ep);
 	return NULL;
 }
 
-- 
2.7.4

