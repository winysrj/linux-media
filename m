Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56306 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388129AbeGWOs2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:28 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 03/21] v4l: fwnode: Detect bus type correctly
Date: Mon, 23 Jul 2018 16:46:48 +0300
Message-Id: <20180723134706.15334-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case the device supports multiple video bus types on an endpoint, the
V4L2 fwnode framework attempts to detect the type based on the available
information. This wasn't working really well, and sometimes could lead to
the V4L2 fwnode endpoint struct as being mishandled between the bus types.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 43 +++++++++++++++++++----------------
 include/media/v4l2-mediabus.h         |  2 ++
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index da13348b1f4a..55214ff5a616 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -111,8 +111,10 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 	}
 
-	bus->flags = flags;
-	vep->bus_type = V4L2_MBUS_CSI2;
+	if (lanes_used || have_clk_lane || flags) {
+		bus->flags = flags;
+		vep->bus_type = V4L2_MBUS_CSI2;
+	}
 
 	return 0;
 }
@@ -122,6 +124,7 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 {
 	struct v4l2_fwnode_bus_parallel *bus = &vep->bus.parallel;
 	unsigned int flags = 0;
+	bool is_parallel = false;
 	u32 v;
 
 	if (!fwnode_property_read_u32(fwnode, "hsync-active", &v)) {
@@ -142,11 +145,6 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 		pr_debug("field-even-active %s\n", v ? "high" : "low");
 	}
 
-	if (flags)
-		vep->bus_type = V4L2_MBUS_PARALLEL;
-	else
-		vep->bus_type = V4L2_MBUS_BT656;
-
 	if (!fwnode_property_read_u32(fwnode, "pclk-sample", &v)) {
 		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
 			V4L2_MBUS_PCLK_SAMPLE_FALLING;
@@ -168,11 +166,13 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 
 	if (!fwnode_property_read_u32(fwnode, "bus-width", &v)) {
 		bus->bus_width = v;
+		is_parallel = true;
 		pr_debug("bus-width %u\n", v);
 	}
 
 	if (!fwnode_property_read_u32(fwnode, "data-shift", &v)) {
 		bus->data_shift = v;
+		is_parallel = true;
 		pr_debug("data-shift %u\n", v);
 	}
 
@@ -188,14 +188,24 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 		pr_debug("data-enable-active %s\n", v ? "high" : "low");
 	}
 
-	bus->flags = flags;
-
+	if (flags || is_parallel) {
+		bus->flags = flags;
+		if (flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+			     V4L2_MBUS_HSYNC_ACTIVE_LOW |
+			     V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+			     V4L2_MBUS_VSYNC_ACTIVE_LOW |
+			     V4L2_MBUS_FIELD_EVEN_HIGH |
+			     V4L2_MBUS_FIELD_EVEN_LOW))
+			vep->bus_type = V4L2_MBUS_PARALLEL;
+		else
+			vep->bus_type = V4L2_MBUS_BT656;
+	}
 }
 
 static void
 v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
 				    struct v4l2_fwnode_endpoint *vep,
-				    u32 bus_type)
+				    enum v4l2_fwnode_bus_type bus_type)
 {
 	struct v4l2_fwnode_bus_mipi_csi1 *bus = &vep->bus.mipi_csi1;
 	u32 v;
@@ -247,25 +257,20 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
 		if (rval)
 			return rval;
-		/*
-		 * Parse the parallel video bus properties only if none
-		 * of the MIPI CSI-2 specific properties were found.
-		 */
-		if (vep->bus.mipi_csi2.flags == 0)
+
+		if (vep->bus_type == V4L2_MBUS_UNKNOWN)
 			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep);
 
-		break;
+		return vep->bus_type == V4L2_MBUS_UNKNOWN ? -EINVAL : 0;
 	case V4L2_FWNODE_BUS_TYPE_CCP2:
 	case V4L2_FWNODE_BUS_TYPE_CSI1:
 		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, bus_type);
 
-		break;
+		return 0;
 	default:
 		pr_warn("unsupported bus type %u\n", bus_type);
 		return -EINVAL;
 	}
-
-	return 0;
 }
 
 int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 4bbb5f3d2b02..66d74c813f53 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -70,6 +70,7 @@
 
 /**
  * enum v4l2_mbus_type - media bus type
+ * @V4L2_MBUS_UNKNOWN:	unknown bus type, no V4L2 mediabus configuration
  * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
  * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
  *			also be used for BT.1120
@@ -78,6 +79,7 @@
  * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
  */
 enum v4l2_mbus_type {
+	V4L2_MBUS_UNKNOWN,
 	V4L2_MBUS_PARALLEL,
 	V4L2_MBUS_BT656,
 	V4L2_MBUS_CSI1,
-- 
2.11.0
