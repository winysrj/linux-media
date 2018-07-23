Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56294 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388091AbeGWOs2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:28 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 01/21] v4l: fwnode: Add debug prints for V4L2 endpoint property parsing
Date: Mon, 23 Jul 2018 16:46:46 +0300
Message-Id: <20180723134706.15334-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Print debug info as standard V4L2 endpoint are parsed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 108 ++++++++++++++++++++++++++--------
 1 file changed, 85 insertions(+), 23 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 5a65ca19ba05..dae01d5f570e 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -66,6 +66,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 			lanes_used |= BIT(array[i]);
 
 			bus->data_lanes[i] = array[i];
+			pr_debug("lane %u position %u\n", i, array[i]);
 		}
 
 		rval = fwnode_property_read_u32_array(fwnode,
@@ -82,8 +83,13 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 						       "lane-polarities", array,
 						       1 + bus->num_data_lanes);
 
-			for (i = 0; i < 1 + bus->num_data_lanes; i++)
+			for (i = 0; i < 1 + bus->num_data_lanes; i++) {
 				bus->lane_polarities[i] = array[i];
+				pr_debug("lane %u polarity %sinverted",
+					 i, array[i] ? "" : "not ");
+			}
+		} else {
+			pr_debug("no lane polarities defined, assuming not inverted\n");
 		}
 
 	}
@@ -95,12 +101,15 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 
 		bus->clock_lane = v;
 		have_clk_lane = true;
+		pr_debug("clock lane position %u\n", v);
 	}
 
-	if (fwnode_property_present(fwnode, "clock-noncontinuous"))
+	if (fwnode_property_present(fwnode, "clock-noncontinuous")) {
 		flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
-	else if (have_clk_lane || bus->num_data_lanes > 0)
+		pr_debug("non-continuous clock\n");
+	} else if (have_clk_lane || bus->num_data_lanes > 0) {
 		flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	}
 
 	bus->flags = flags;
 	vep->bus_type = V4L2_MBUS_CSI2;
@@ -115,48 +124,69 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 	unsigned int flags = 0;
 	u32 v;
 
-	if (!fwnode_property_read_u32(fwnode, "hsync-active", &v))
+	if (!fwnode_property_read_u32(fwnode, "hsync-active", &v)) {
 		flags |= v ? V4L2_MBUS_HSYNC_ACTIVE_HIGH :
 			V4L2_MBUS_HSYNC_ACTIVE_LOW;
+		pr_debug("hsync-active %s\n", v ? "high" : "low");
+	}
 
-	if (!fwnode_property_read_u32(fwnode, "vsync-active", &v))
+	if (!fwnode_property_read_u32(fwnode, "vsync-active", &v)) {
 		flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
 			V4L2_MBUS_VSYNC_ACTIVE_LOW;
+		pr_debug("vsync-active %s\n", v ? "high" : "low");
+	}
 
-	if (!fwnode_property_read_u32(fwnode, "field-even-active", &v))
+	if (!fwnode_property_read_u32(fwnode, "field-even-active", &v)) {
 		flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
 			V4L2_MBUS_FIELD_EVEN_LOW;
+		pr_debug("field-even-active %s\n", v ? "high" : "low");
+	}
+
 	if (flags)
 		vep->bus_type = V4L2_MBUS_PARALLEL;
 	else
 		vep->bus_type = V4L2_MBUS_BT656;
 
-	if (!fwnode_property_read_u32(fwnode, "pclk-sample", &v))
+	if (!fwnode_property_read_u32(fwnode, "pclk-sample", &v)) {
 		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
 			V4L2_MBUS_PCLK_SAMPLE_FALLING;
+		pr_debug("pclk-sample %s\n", v ? "high" : "low");
+	}
 
-	if (!fwnode_property_read_u32(fwnode, "data-active", &v))
+	if (!fwnode_property_read_u32(fwnode, "data-active", &v)) {
 		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
 			V4L2_MBUS_DATA_ACTIVE_LOW;
+		pr_debug("data-active %s\n", v ? "high" : "low");
+	}
 
-	if (fwnode_property_present(fwnode, "slave-mode"))
+	if (fwnode_property_present(fwnode, "slave-mode")) {
+		pr_debug("slave mode\n");
 		flags |= V4L2_MBUS_SLAVE;
-	else
+	} else {
 		flags |= V4L2_MBUS_MASTER;
+	}
 
-	if (!fwnode_property_read_u32(fwnode, "bus-width", &v))
+	if (!fwnode_property_read_u32(fwnode, "bus-width", &v)) {
 		bus->bus_width = v;
+		pr_debug("bus-width %u\n", v);
+	}
 
-	if (!fwnode_property_read_u32(fwnode, "data-shift", &v))
+	if (!fwnode_property_read_u32(fwnode, "data-shift", &v)) {
 		bus->data_shift = v;
+		pr_debug("data-shift %u\n", v);
+	}
 
-	if (!fwnode_property_read_u32(fwnode, "sync-on-green-active", &v))
+	if (!fwnode_property_read_u32(fwnode, "sync-on-green-active", &v)) {
 		flags |= v ? V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH :
 			V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW;
+		pr_debug("sync-on-green-active %s\n", v ? "high" : "low");
+	}
 
-	if (!fwnode_property_read_u32(fwnode, "data-enable-active", &v))
+	if (!fwnode_property_read_u32(fwnode, "data-enable-active", &v)) {
 		flags |= v ? V4L2_MBUS_DATA_ENABLE_HIGH :
 			V4L2_MBUS_DATA_ENABLE_LOW;
+		pr_debug("data-enable-active %s\n", v ? "high" : "low");
+	}
 
 	bus->flags = flags;
 
@@ -170,17 +200,25 @@ v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
 	struct v4l2_fwnode_bus_mipi_csi1 *bus = &vep->bus.mipi_csi1;
 	u32 v;
 
-	if (!fwnode_property_read_u32(fwnode, "clock-inv", &v))
+	if (!fwnode_property_read_u32(fwnode, "clock-inv", &v)) {
 		bus->clock_inv = v;
+		pr_debug("clock-inv %u\n", v);
+	}
 
-	if (!fwnode_property_read_u32(fwnode, "strobe", &v))
+	if (!fwnode_property_read_u32(fwnode, "strobe", &v)) {
 		bus->strobe = v;
+		pr_debug("strobe %u\n", v);
+	}
 
-	if (!fwnode_property_read_u32(fwnode, "data-lanes", &v))
+	if (!fwnode_property_read_u32(fwnode, "data-lanes", &v)) {
 		bus->data_lane = v;
+		pr_debug("data-lanes %u\n", v);
+	}
 
-	if (!fwnode_property_read_u32(fwnode, "clock-lanes", &v))
+	if (!fwnode_property_read_u32(fwnode, "clock-lanes", &v)) {
 		bus->clock_lane = v;
+		pr_debug("clock-lanes %u\n", v);
+	}
 
 	if (bus_type == V4L2_FWNODE_BUS_TYPE_CCP2)
 		vep->bus_type = V4L2_MBUS_CCP2;
@@ -188,12 +226,14 @@ v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
 		vep->bus_type = V4L2_MBUS_CSI1;
 }
 
-int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
-			       struct v4l2_fwnode_endpoint *vep)
+static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
+					struct v4l2_fwnode_endpoint *vep)
 {
 	u32 bus_type = 0;
 	int rval;
 
+	pr_debug("===== begin V4L2 endpoint properties\n");
+
 	fwnode_graph_parse_endpoint(fwnode, &vep->base);
 
 	/* Zero fields from bus_type to until the end */
@@ -214,16 +254,30 @@ int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		if (vep->bus.mipi_csi2.flags == 0)
 			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep);
 
-		return 0;
+		break;
 	case V4L2_FWNODE_BUS_TYPE_CCP2:
 	case V4L2_FWNODE_BUS_TYPE_CSI1:
 		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, bus_type);
 
-		return 0;
+		break;
 	default:
 		pr_warn("unsupported bus type %u\n", bus_type);
 		return -EINVAL;
 	}
+
+	return 0;
+}
+
+int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
+			       struct v4l2_fwnode_endpoint *vep)
+{
+	int ret;
+
+	ret = __v4l2_fwnode_endpoint_parse(fwnode, vep);
+
+	pr_debug("===== end V4L2 endpoint properties\n");
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_parse);
 
@@ -247,13 +301,15 @@ struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
 	if (!vep)
 		return ERR_PTR(-ENOMEM);
 
-	rval = v4l2_fwnode_endpoint_parse(fwnode, vep);
+	rval = __v4l2_fwnode_endpoint_parse(fwnode, vep);
 	if (rval < 0)
 		goto out_err;
 
 	rval = fwnode_property_read_u64_array(fwnode, "link-frequencies",
 					      NULL, 0);
 	if (rval > 0) {
+		unsigned int i;
+
 		vep->link_frequencies =
 			kmalloc_array(rval, sizeof(*vep->link_frequencies),
 				      GFP_KERNEL);
@@ -269,8 +325,14 @@ struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
 			vep->nr_of_link_frequencies);
 		if (rval < 0)
 			goto out_err;
+
+		for (i = 0; i < vep->nr_of_link_frequencies; i++)
+			pr_info("link-frequencies %u value %llu\n", i,
+				vep->link_frequencies[i]);
 	}
 
+	pr_debug("===== end V4L2 endpoint properties\n");
+
 	return vep;
 
 out_err:
-- 
2.11.0
