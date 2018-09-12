Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40982 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728267AbeIMCgL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 18/23] v4l: fwnode: Use media bus type for bus parser selection
Date: Thu, 13 Sep 2018 00:29:37 +0300
Message-Id: <20180912212942.19641-19-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the media bus types instead of the fwnode bus types internally. This
is the interface to the drivers as well, making the use of the fwnode bus
types more localised to the V4L2 fwnode framework.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 100 +++++++++++++++++++++++++++-------
 1 file changed, 80 insertions(+), 20 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 8244a7b8414e..4b588418074a 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -42,9 +42,66 @@ enum v4l2_fwnode_bus_type {
 	NR_OF_V4L2_FWNODE_BUS_TYPE,
 };
 
+static const struct v4l2_fwnode_bus_conv {
+	enum v4l2_fwnode_bus_type fwnode_bus_type;
+	enum v4l2_mbus_type mbus_type;
+	const char *name;
+} busses[] = {
+	{
+		V4L2_FWNODE_BUS_TYPE_GUESS,
+		V4L2_MBUS_UNKNOWN,
+		"not specified",
+	}, {
+		V4L2_FWNODE_BUS_TYPE_CSI2_CPHY,
+		V4L2_MBUS_CSI2_CPHY,
+		"MIPI CSI-2 C-PHY",
+	}, {
+		V4L2_FWNODE_BUS_TYPE_CSI1,
+		V4L2_MBUS_CSI1,
+		"MIPI CSI-1",
+	}, {
+		V4L2_FWNODE_BUS_TYPE_CCP2,
+		V4L2_MBUS_CCP2,
+		"compact camera port 2",
+	}, {
+		V4L2_FWNODE_BUS_TYPE_CSI2_DPHY,
+		V4L2_MBUS_CSI2_DPHY,
+		"MIPI CSI-2 D-PHY",
+	}, {
+		V4L2_FWNODE_BUS_TYPE_PARALLEL,
+		V4L2_MBUS_PARALLEL,
+		"parallel",
+	}, {
+		V4L2_FWNODE_BUS_TYPE_BT656,
+		V4L2_MBUS_BT656,
+		"Bt.656",
+	}
+};
+
+static const struct v4l2_fwnode_bus_conv *
+get_v4l2_fwnode_bus_conv_by_fwnode_bus(enum v4l2_fwnode_bus_type type)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(busses); i++)
+		if (busses[i].fwnode_bus_type == type)
+			return &busses[i];
+
+	return NULL;
+}
+
+static enum v4l2_mbus_type
+v4l2_fwnode_bus_type_to_mbus(enum v4l2_fwnode_bus_type type)
+{
+	const struct v4l2_fwnode_bus_conv *conv =
+		get_v4l2_fwnode_bus_conv_by_fwnode_bus(type);
+
+	return conv ? conv->mbus_type : V4L2_MBUS_UNKNOWN;
+}
+
 static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 					       struct v4l2_fwnode_endpoint *vep,
-					       enum v4l2_fwnode_bus_type bus_type)
+					       enum v4l2_mbus_type bus_type)
 {
 	struct v4l2_fwnode_bus_mipi_csi2 *bus = &vep->bus.mipi_csi2;
 	bool have_clk_lane = false, have_data_lanes = false,
@@ -58,7 +115,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 	u32 v;
 	int rval;
 
-	if (bus_type == V4L2_FWNODE_BUS_TYPE_CSI2_DPHY) {
+	if (bus_type == V4L2_MBUS_CSI2_DPHY) {
 		use_default_lane_mapping = true;
 
 		num_data_lanes = min_t(u32, bus->num_data_lanes,
@@ -134,7 +191,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 	}
 
-	if (bus_type == V4L2_FWNODE_BUS_TYPE_CSI2_DPHY || lanes_used ||
+	if (bus_type == V4L2_MBUS_CSI2_DPHY || lanes_used ||
 	    have_clk_lane || (flags & ~V4L2_MBUS_CSI2_CONTINUOUS_CLOCK)) {
 		bus->flags = flags;
 		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
@@ -177,7 +234,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 
 static void v4l2_fwnode_endpoint_parse_parallel_bus(
 	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep,
-	enum v4l2_fwnode_bus_type bus_type)
+	enum v4l2_mbus_type bus_type)
 {
 	struct v4l2_fwnode_bus_parallel *bus = &vep->bus.parallel;
 	unsigned int flags = 0;
@@ -274,11 +331,11 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 		else
 			vep->bus_type = V4L2_MBUS_BT656;
 		break;
-	case V4L2_FWNODE_BUS_TYPE_PARALLEL:
+	case V4L2_MBUS_PARALLEL:
 		vep->bus_type = V4L2_MBUS_PARALLEL;
 		bus->flags = flags;
 		break;
-	case V4L2_FWNODE_BUS_TYPE_BT656:
+	case V4L2_MBUS_BT656:
 		vep->bus_type = V4L2_MBUS_BT656;
 		bus->flags = flags & ~PARALLEL_MBUS_FLAGS;
 		break;
@@ -288,7 +345,7 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 static void
 v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
 				    struct v4l2_fwnode_endpoint *vep,
-				    enum v4l2_fwnode_bus_type bus_type)
+				    enum v4l2_mbus_type bus_type)
 {
 	struct v4l2_fwnode_bus_mipi_csi1 *bus = &vep->bus.mipi_csi1;
 	u32 v;
@@ -313,7 +370,7 @@ v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
 		pr_debug("clock-lanes %u\n", v);
 	}
 
-	if (bus_type == V4L2_FWNODE_BUS_TYPE_CCP2)
+	if (bus_type == V4L2_MBUS_CCP2)
 		vep->bus_type = V4L2_MBUS_CCP2;
 	else
 		vep->bus_type = V4L2_MBUS_CSI1;
@@ -323,6 +380,7 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 					struct v4l2_fwnode_endpoint *vep)
 {
 	u32 bus_type = 0;
+	enum v4l2_mbus_type mbus_type;
 	int rval;
 
 	if (vep->bus_type == V4L2_MBUS_UNKNOWN) {
@@ -341,10 +399,12 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 
 	fwnode_property_read_u32(fwnode, "bus-type", &bus_type);
 
-	switch (bus_type) {
-	case V4L2_FWNODE_BUS_TYPE_GUESS:
+	mbus_type = v4l2_fwnode_bus_type_to_mbus(bus_type);
+
+	switch (mbus_type) {
+	case V4L2_MBUS_UNKNOWN:
 		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep,
-							   bus_type);
+							   mbus_type);
 		if (rval)
 			return rval;
 
@@ -353,26 +413,26 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 				fwnode, vep, V4L2_MBUS_UNKNOWN);
 
 		break;
-	case V4L2_FWNODE_BUS_TYPE_CCP2:
-	case V4L2_FWNODE_BUS_TYPE_CSI1:
-		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, bus_type);
+	case V4L2_MBUS_CCP2:
+	case V4L2_MBUS_CSI1:
+		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, mbus_type);
 
 		break;
-	case V4L2_FWNODE_BUS_TYPE_CSI2_DPHY:
+	case V4L2_MBUS_CSI2_DPHY:
 		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
 		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep,
-							   bus_type);
+							   mbus_type);
 		if (rval)
 			return rval;
 
 		break;
-	case V4L2_FWNODE_BUS_TYPE_PARALLEL:
-	case V4L2_FWNODE_BUS_TYPE_BT656:
-		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep, bus_type);
+	case V4L2_MBUS_PARALLEL:
+	case V4L2_MBUS_BT656:
+		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep, mbus_type);
 
 		break;
 	default:
-		pr_warn("unsupported bus type %u\n", bus_type);
+		pr_warn("unsupported bus type %u\n", mbus_type);
 		return -EINVAL;
 	}
 
-- 
2.11.0
