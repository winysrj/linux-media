Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41990 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752259AbdGEXAZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 19:00:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 5/8] v4l: Add support for CSI-1 and CCP2 busses
Date: Thu,  6 Jul 2017 02:00:16 +0300
Message-Id: <20170705230019.5461-6-sakari.ailus@linux.intel.com>
In-Reply-To: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

CCP2 and CSI-1, are older single data lane serial busses.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/platform/pxa_camera.c              |  3 ++
 drivers/media/platform/soc_camera/soc_mediabus.c |  3 ++
 drivers/media/v4l2-core/v4l2-fwnode.c            | 58 +++++++++++++++++++-----
 include/media/v4l2-fwnode.h                      | 19 ++++++++
 include/media/v4l2-mediabus.h                    |  4 ++
 5 files changed, 76 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 399095170b6e..17e797c9559f 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -638,6 +638,9 @@ static unsigned int pxa_mbus_config_compatible(const struct v4l2_mbus_config *cf
 		mipi_clock = common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
 					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
 		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
+	default:
+		__WARN();
+		return -EINVAL;
 	}
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index 57581f626f4c..43192d80beef 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -508,6 +508,9 @@ unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
 		mipi_clock = common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
 					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
 		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
+	default:
+		__WARN();
+		return -EINVAL;
 	}
 	return 0;
 }
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index d71dd3913cd9..76a88f210cb6 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -154,6 +154,31 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 
 }
 
+void v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
+					 struct v4l2_fwnode_endpoint *vep,
+					 u32 bus_type)
+{
+       struct v4l2_fwnode_bus_mipi_csi1 *bus = &vep->bus.mipi_csi1;
+       u32 v;
+
+       if (!fwnode_property_read_u32(fwnode, "clock-inv", &v))
+               bus->clock_inv = v;
+
+       if (!fwnode_property_read_u32(fwnode, "strobe", &v))
+               bus->strobe = v;
+
+       if (!fwnode_property_read_u32(fwnode, "data-lanes", &v))
+               bus->data_lane = v;
+
+       if (!fwnode_property_read_u32(fwnode, "clock-lanes", &v))
+               bus->clock_lane = v;
+
+       if (bus_type == V4L2_FWNODE_BUS_TYPE_CCP2)
+	       vep->bus_type = V4L2_MBUS_CCP2;
+       else
+	       vep->bus_type = V4L2_MBUS_CSI1;
+}
+
 /**
  * v4l2_fwnode_endpoint_parse() - parse all fwnode node properties
  * @fwnode: pointer to the endpoint's fwnode handle
@@ -187,17 +212,28 @@ int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 
 	fwnode_property_read_u32(fwnode, "bus-type", &bus_type);
 
-	rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
-	if (rval)
-		return rval;
-	/*
-	 * Parse the parallel video bus properties only if none
-	 * of the MIPI CSI-2 specific properties were found.
-	 */
-	if (vep->bus.mipi_csi2.flags == 0)
-		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep);
-
-	return 0;
+	switch (bus_type) {
+	case V4L2_FWNODE_BUS_TYPE_GUESS:
+		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
+		if (rval)
+			return rval;
+		/*
+		 * Parse the parallel video bus properties only if none
+		 * of the MIPI CSI-2 specific properties were found.
+		 */
+		if (vep->bus.mipi_csi2.flags == 0)
+			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep);
+
+		return 0;
+	case V4L2_FWNODE_BUS_TYPE_CCP2:
+	case V4L2_FWNODE_BUS_TYPE_CSI1:
+		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, bus_type);
+
+		return 0;
+	default:
+		pr_warn("unsupported bus type %u\n", bus_type);
+		return -EINVAL;
+	}
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_parse);
 
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index ecc1233a873e..29ae22bbbbaf 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -56,6 +56,24 @@ struct v4l2_fwnode_bus_parallel {
 };
 
 /**
+ * struct v4l2_fwnode_bus_mipi_csi1 - CSI-1/CCP2 data bus structure
+ * @clock_inv: polarity of clock/strobe signal
+ *	       false - not inverted, true - inverted
+ * @strobe: false - data/clock, true - data/strobe
+ * @lane_polarity: the polarities of the clock (index 0) and data lanes
+		   index (1)
+ * @data_lane: the number of the data lane
+ * @clock_lane: the number of the clock lane
+ */
+struct v4l2_fwnode_bus_mipi_csi1 {
+	bool clock_inv;
+	bool strobe;
+	bool lane_polarity[2];
+	unsigned char data_lane;
+	unsigned char clock_lane;
+};
+
+/**
  * struct v4l2_fwnode_endpoint - the endpoint data structure
  * @base: fwnode endpoint of the v4l2_fwnode
  * @bus_type: bus type
@@ -72,6 +90,7 @@ struct v4l2_fwnode_endpoint {
 	enum v4l2_mbus_type bus_type;
 	union {
 		struct v4l2_fwnode_bus_parallel parallel;
+		struct v4l2_fwnode_bus_mipi_csi1 mipi_csi1;
 		struct v4l2_fwnode_bus_mipi_csi2 mipi_csi2;
 	} bus;
 	u64 *link_frequencies;
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 34cc99e093ef..315c167a95dc 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -69,11 +69,15 @@
  * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
  * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
  *			also be used for BT.1120
+ * @V4L2_MBUS_CSI1:	MIPI CSI-1 serial interface
+ * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
  * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
  */
 enum v4l2_mbus_type {
 	V4L2_MBUS_PARALLEL,
 	V4L2_MBUS_BT656,
+	V4L2_MBUS_CSI1,
+	V4L2_MBUS_CCP2,
 	V4L2_MBUS_CSI2,
 };
 
-- 
2.11.0
