Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44514 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726945AbeIMOwb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 10:52:31 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3.1 09/23] v4l: fwnode: Make use of newly specified bus types
Date: Thu, 13 Sep 2018 12:43:48 +0300
Message-Id: <20180913094348.10967-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20180913091452.GQ20333@w540>
References: <20180913091452.GQ20333@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for parsing CSI-2 D-PHY, parallel or Bt.656 bus explicitly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
since v3:

- Use PARALLEL_MBUS_FLAGS where appropriate --- thanks, Jacopo!

 drivers/media/v4l2-core/v4l2-fwnode.c | 48 +++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index aa3d28c4a50b..2d0d2facf20f 100644
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
@@ -189,16 +197,23 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
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
+		if (flags & PARALLEL_MBUS_FLAGS)
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
@@ -258,7 +273,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			return rval;
 
 		if (vep->bus_type == V4L2_MBUS_UNKNOWN)
-			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep);
+			v4l2_fwnode_endpoint_parse_parallel_bus(
+				fwnode, vep, V4L2_MBUS_UNKNOWN);
 
 		break;
 	case V4L2_FWNODE_BUS_TYPE_CCP2:
@@ -266,6 +282,18 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
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
