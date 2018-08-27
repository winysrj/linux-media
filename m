Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54566 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727169AbeH0NP5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 09:15:57 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org
Subject: [PATCH v2 08/23] v4l: fwnode: Detect bus type correctly
Date: Mon, 27 Aug 2018 12:29:45 +0300
Message-Id: <20180827093000.29165-9-sakari.ailus@linux.intel.com>
In-Reply-To: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case the device supports multiple video bus types on an endpoint, the
V4L2 fwnode framework attempts to detect the type based on the available
information. This wasn't working really well, and sometimes could lead to
the V4L2 fwnode endpoint struct as being mishandled between the bus types.

Default to Bt.656 if no properties suggesting a bus type are found.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 31 +++++++++++++++++--------------
 include/media/v4l2-mediabus.h         |  2 ++
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 801831c802a9..52bd9f839fb2 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -114,8 +114,11 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 	}
 
-	bus->flags = flags;
-	vep->bus_type = V4L2_MBUS_CSI2_DPHY;
+	if (lanes_used || have_clk_lane ||
+	    (flags & ~V4L2_MBUS_CSI2_CONTINUOUS_CLOCK)) {
+		bus->flags = flags;
+		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
+	}
 
 	return 0;
 }
@@ -145,11 +148,6 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
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
@@ -192,13 +190,21 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 	}
 
 	bus->flags = flags;
-
+	if (flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+		     V4L2_MBUS_HSYNC_ACTIVE_LOW |
+		     V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+		     V4L2_MBUS_VSYNC_ACTIVE_LOW |
+		     V4L2_MBUS_FIELD_EVEN_HIGH |
+		     V4L2_MBUS_FIELD_EVEN_LOW))
+		vep->bus_type = V4L2_MBUS_PARALLEL;
+	else
+		vep->bus_type = V4L2_MBUS_BT656;
 }
 
 static void
 v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
 				    struct v4l2_fwnode_endpoint *vep,
-				    u32 bus_type)
+				    enum v4l2_fwnode_bus_type bus_type)
 {
 	struct v4l2_fwnode_bus_mipi_csi1 *bus = &vep->bus.mipi_csi1;
 	u32 v;
@@ -250,11 +256,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
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
 
 		break;
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 26e1c644ded6..df1d552e9df6 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -70,6 +70,7 @@
 
 /**
  * enum v4l2_mbus_type - media bus type
+ * @V4L2_MBUS_UNKNOWN:	unknown bus type, no V4L2 mediabus configuration
  * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
  * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
  *			also be used for BT.1120
@@ -79,6 +80,7 @@
  * @V4L2_MBUS_CSI2_CPHY: MIPI CSI-2 serial interface, with C-PHY
  */
 enum v4l2_mbus_type {
+	V4L2_MBUS_UNKNOWN,
 	V4L2_MBUS_PARALLEL,
 	V4L2_MBUS_BT656,
 	V4L2_MBUS_CSI1,
-- 
2.11.0
