Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56338 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388287AbeGWOsa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 08/21] v4l: fwnode: Make use of newly specified bus types
Date: Mon, 23 Jul 2018 16:46:53 +0300
Message-Id: <20180723134706.15334-9-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make use of bus type specified for an endpoint.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 48 ++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 85f409808042..e62a1fcabd8f 100644
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
@@ -192,17 +200,24 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 		pr_debug("data-enable-active %s\n", v ? "high" : "low");
 	}
 
-	if (flags || is_parallel) {
+	switch (bus_type) {
+	default:
 		bus->flags = flags;
-		if (flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
-			     V4L2_MBUS_HSYNC_ACTIVE_LOW |
-			     V4L2_MBUS_VSYNC_ACTIVE_HIGH |
-			     V4L2_MBUS_VSYNC_ACTIVE_LOW |
-			     V4L2_MBUS_FIELD_EVEN_HIGH |
-			     V4L2_MBUS_FIELD_EVEN_LOW))
-			vep->bus_type = V4L2_MBUS_PARALLEL;
-		else
-			vep->bus_type = V4L2_MBUS_BT656;
+		if (flags || is_parallel) {
+			if (flags & PARALLEL_MBUS_FLAGS)
+				vep->bus_type = V4L2_MBUS_PARALLEL;
+			else
+				vep->bus_type = V4L2_MBUS_BT656;
+		}
+		break;
+	case V4L2_FWNODE_BUS_TYPE_PARALLEL:
+		vep->bus_type = V4L2_MBUS_PARALLEL;
+		bus->flags = flags;
+		break;
+	case V4L2_FWNODE_BUS_TYPE_BT656:
+		vep->bus_type = V4L2_MBUS_BT656;
+		bus->flags = flags & ~PARALLEL_MBUS_FLAGS;
+		break;
 	}
 }
 
@@ -263,7 +278,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			return rval;
 
 		if (vep->bus_type == V4L2_MBUS_UNKNOWN)
-			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep);
+			v4l2_fwnode_endpoint_parse_parallel_bus(
+				fwnode, vep, V4L2_MBUS_UNKNOWN);
 
 		return vep->bus_type == V4L2_MBUS_UNKNOWN ? -EINVAL : 0;
 	case V4L2_FWNODE_BUS_TYPE_CCP2:
@@ -271,6 +287,14 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, bus_type);
 
 		return 0;
+	case V4L2_FWNODE_BUS_TYPE_CSI2_DPHY:
+		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
+		return v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
+	case V4L2_FWNODE_BUS_TYPE_PARALLEL:
+	case V4L2_FWNODE_BUS_TYPE_BT656:
+		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep, bus_type);
+
+		return 0;
 	default:
 		pr_warn("unsupported bus type %u\n", bus_type);
 		return -EINVAL;
-- 
2.11.0
