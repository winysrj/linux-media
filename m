Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35712 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbcDXVK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:27 -0400
Received: by mail-wm0-f68.google.com with SMTP id e201so17587391wme.2
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:26 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [RFC PATCH 13/24] v4l: of: Support CSI-1 and CCP2 busses
Date: Mon, 25 Apr 2016 00:08:13 +0300
Message-Id: <1461532104-24032-14-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for parsing of CSI-1 and CCP2 bus related properties documented
in video-interfaces.txt.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/v4l2-of.c | 35 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-of.h           | 17 +++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 60bbc5f..5c0d0eb 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -23,6 +23,8 @@
 enum v4l2_of_bus_type {
 	V4L2_OF_BUS_TYPE_CSI2 = 0,
 	V4L2_OF_BUS_TYPE_PARALLEL,
+	V4L2_OF_BUS_TYPE_CSI1,
+	V4L2_OF_BUS_TYPE_CCP2,
 };
 
 static int v4l2_of_parse_lanes(const struct device_node *node,
@@ -163,6 +165,35 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 
 }
 
+void v4l2_of_parse_csi1_bus(const struct device_node *node,
+			    struct v4l2_of_endpoint *endpoint,
+			    enum v4l2_of_bus_type bus_type)
+{
+	struct v4l2_of_bus_mipi_csi1 *bus = &endpoint->bus.mipi_csi1;
+	u32 v;
+
+	v4l2_of_parse_lanes(node, &bus->clock_lane, NULL,
+			    &bus->data_lane, bus->lane_polarity,
+			    NULL, 1);
+
+	if (!of_property_read_u32(node, "clock-inv", &v))
+		bus->clock_inv = v;
+
+	if (!of_property_read_u32(node, "strobe", &v))
+		bus->strobe = v;
+
+	if (!of_property_read_u32(node, "data-lane", &v))
+		bus->data_lane = v;
+
+	if (!of_property_read_u32(node, "clock-lane", &v))
+		bus->clock_lane = v;
+
+	if (bus_type == V4L2_OF_BUS_TYPE_CSI1)
+		endpoint->bus_type = V4L2_MBUS_CSI1;
+	else
+		endpoint->bus_type = V4L2_MBUS_CCP2;
+}
+
 /**
  * v4l2_of_parse_endpoint() - parse all endpoint node properties
  * @node: pointer to endpoint device_node
@@ -216,6 +247,10 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
 	case V4L2_OF_BUS_TYPE_PARALLEL:
 		v4l2_of_parse_parallel_bus(node, endpoint);
 		return 0;
+	case V4L2_OF_BUS_TYPE_CSI1:
+	case V4L2_OF_BUS_TYPE_CCP2:
+		v4l2_of_parse_csi1_bus(node, endpoint, bus_type);
+		return 0;
 	default:
 		pr_warn("bad bus-type %u, device_node \"%s\"\n",
 			bus_type, node->full_name);
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 4dc34b2..63a52ee 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -53,6 +53,22 @@ struct v4l2_of_bus_parallel {
 };
 
 /**
+ * struct v4l2_of_bus_csi1 - CSI-1/CCP2 data bus structure
+ * @clock_inv: polarity of clock/strobe signal
+ *	       false - not inverted, true - inverted
+ * @strobe: false - data/clock, true - data/strobe
+ * @data_lane: the number of the data lane
+ * @clock_lane: the number of the clock lane
+ */
+struct v4l2_of_bus_mipi_csi1 {
+	bool clock_inv;
+	bool strobe;
+	bool lane_polarity[2];
+	unsigned char data_lane;
+	unsigned char clock_lane;
+};
+
+/**
  * struct v4l2_of_endpoint - the endpoint data structure
  * @base: struct of_endpoint containing port, id, and local of_node
  * @bus_type: bus type
@@ -66,6 +82,7 @@ struct v4l2_of_endpoint {
 	enum v4l2_mbus_type bus_type;
 	union {
 		struct v4l2_of_bus_parallel parallel;
+		struct v4l2_of_bus_mipi_csi1 mipi_csi1;
 		struct v4l2_of_bus_mipi_csi2 mipi_csi2;
 	} bus;
 	u64 *link_frequencies;
-- 
1.9.1

