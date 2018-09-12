Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40954 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728256AbeIMCgL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 15/23] v4l: fwnode: Use default parallel flags
Date: Thu, 13 Sep 2018 00:29:34 +0300
Message-Id: <20180912212942.19641-16-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The caller may provide default flags for the endpoint. Change the
configuration based on what is available through the fwnode property API.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index bdb0a355b66b..de4a43765ac2 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -183,31 +183,44 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 	unsigned int flags = 0;
 	u32 v;
 
+	if (bus_type == V4L2_MBUS_PARALLEL || bus_type == V4L2_MBUS_BT656)
+		flags = bus->flags;
+
 	if (!fwnode_property_read_u32(fwnode, "hsync-active", &v)) {
+		flags &= ~(V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+			   V4L2_MBUS_HSYNC_ACTIVE_LOW);
 		flags |= v ? V4L2_MBUS_HSYNC_ACTIVE_HIGH :
 			V4L2_MBUS_HSYNC_ACTIVE_LOW;
 		pr_debug("hsync-active %s\n", v ? "high" : "low");
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "vsync-active", &v)) {
+		flags &= ~(V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+			   V4L2_MBUS_VSYNC_ACTIVE_LOW);
 		flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
 			V4L2_MBUS_VSYNC_ACTIVE_LOW;
 		pr_debug("vsync-active %s\n", v ? "high" : "low");
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "field-even-active", &v)) {
+		flags &= ~(V4L2_MBUS_FIELD_EVEN_HIGH |
+			   V4L2_MBUS_FIELD_EVEN_LOW);
 		flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
 			V4L2_MBUS_FIELD_EVEN_LOW;
 		pr_debug("field-even-active %s\n", v ? "high" : "low");
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "pclk-sample", &v)) {
+		flags &= ~(V4L2_MBUS_PCLK_SAMPLE_RISING |
+			   V4L2_MBUS_PCLK_SAMPLE_FALLING);
 		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
 			V4L2_MBUS_PCLK_SAMPLE_FALLING;
 		pr_debug("pclk-sample %s\n", v ? "high" : "low");
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "data-active", &v)) {
+		flags &= ~(V4L2_MBUS_PCLK_SAMPLE_RISING |
+			   V4L2_MBUS_PCLK_SAMPLE_FALLING);
 		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
 			V4L2_MBUS_DATA_ACTIVE_LOW;
 		pr_debug("data-active %s\n", v ? "high" : "low");
@@ -215,8 +228,10 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 
 	if (fwnode_property_present(fwnode, "slave-mode")) {
 		pr_debug("slave mode\n");
+		flags &= ~V4L2_MBUS_MASTER;
 		flags |= V4L2_MBUS_SLAVE;
 	} else {
+		flags &= ~V4L2_MBUS_SLAVE;
 		flags |= V4L2_MBUS_MASTER;
 	}
 
@@ -231,12 +246,16 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "sync-on-green-active", &v)) {
+		flags &= ~(V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH |
+			   V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW);
 		flags |= v ? V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH :
 			V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW;
 		pr_debug("sync-on-green-active %s\n", v ? "high" : "low");
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "data-enable-active", &v)) {
+		flags &= ~(V4L2_MBUS_DATA_ENABLE_HIGH |
+			   V4L2_MBUS_DATA_ENABLE_LOW);
 		flags |= v ? V4L2_MBUS_DATA_ENABLE_HIGH :
 			V4L2_MBUS_DATA_ENABLE_LOW;
 		pr_debug("data-enable-active %s\n", v ? "high" : "low");
-- 
2.11.0
