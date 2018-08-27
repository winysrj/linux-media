Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54574 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727119AbeH0NP4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 09:15:56 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org
Subject: [PATCH v2 09/23] v4l: fwnode: Make use of newly specified bus types
Date: Mon, 27 Aug 2018 12:29:46 +0300
Message-Id: <20180827093000.29165-10-sakari.ailus@linux.intel.com>
In-Reply-To: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for parsing CSI-2 D-PHY, parallel or Bt.656 bus explicitly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 53 ++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 52bd9f839fb2..ff34a7e47967 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -123,8 +123,16 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 	return 0;
 }
 
+#define PARALLEL_MBUS_FLAGS (V4L2_MBUS_HSYNC_ACTIVE_HIGH |	\
+			     V4L2_MBUS_HSYNC_ACTIVE_LOW |	\
+			     V4L2_MBUS_VSYNC_ACTIVE_HIGH |	\
+			     V4L2_MBUS_VSYNC_ACTIVE_LOW |	\
+			     V4L2_MBUS_FIELD_EVEN_HIGH |	\
+			     V4L2_MBUS_FIELD_EVEN_LOW)
+
 static void v4l2_fwnode_endpoint_parse_parallel_bus(
-	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep)
+	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep,
+	enum v4l2_fwnode_bus_type bus_type)
 {
 	struct v4l2_fwnode_bus_parallel *bus = &vep->bus.parallel;
 	unsigned int flags = 0;
@@ -189,16 +197,28 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 		pr_debug("data-enable-active %s\n", v ? "high" : "low");
 	}
 
-	bus->flags = flags;
-	if (flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
-		     V4L2_MBUS_HSYNC_ACTIVE_LOW |
-		     V4L2_MBUS_VSYNC_ACTIVE_HIGH |
-		     V4L2_MBUS_VSYNC_ACTIVE_LOW |
-		     V4L2_MBUS_FIELD_EVEN_HIGH |
-		     V4L2_MBUS_FIELD_EVEN_LOW))
+	switch (bus_type) {
+	default:
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
+		break;
+	case V4L2_FWNODE_BUS_TYPE_PARALLEL:
 		vep->bus_type = V4L2_MBUS_PARALLEL;
-	else
+		bus->flags = flags;
+		break;
+	case V4L2_FWNODE_BUS_TYPE_BT656:
 		vep->bus_type = V4L2_MBUS_BT656;
+		bus->flags = flags & ~PARALLEL_MBUS_FLAGS;
+		break;
+	}
 }
 
 static void
@@ -258,7 +278,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			return rval;
 
 		if (vep->bus_type == V4L2_MBUS_UNKNOWN)
-			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep);
+			v4l2_fwnode_endpoint_parse_parallel_bus(
+				fwnode, vep, V4L2_MBUS_UNKNOWN);
 
 		break;
 	case V4L2_FWNODE_BUS_TYPE_CCP2:
@@ -266,6 +287,18 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, bus_type);
 
 		break;
+	case V4L2_FWNODE_BUS_TYPE_CSI2_DPHY:
+		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
+		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
+		if (rval)
+			return rval;
+
+		break;
+	case V4L2_FWNODE_BUS_TYPE_PARALLEL:
+	case V4L2_FWNODE_BUS_TYPE_BT656:
+		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep, bus_type);
+
+		break;
 	default:
 		pr_warn("unsupported bus type %u\n", bus_type);
 		return -EINVAL;
-- 
2.11.0
