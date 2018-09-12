Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40980 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728270AbeIMCgL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 19/23] v4l: fwnode: Print bus type
Date: Thu, 13 Sep 2018 00:29:38 +0300
Message-Id: <20180912212942.19641-20-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Print bus type either as set by the driver or as parsed from the bus-type
property, as well as the guessed V4L2 media bus type.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 4b588418074a..48fb90660c6b 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -99,6 +99,36 @@ v4l2_fwnode_bus_type_to_mbus(enum v4l2_fwnode_bus_type type)
 	return conv ? conv->mbus_type : V4L2_MBUS_UNKNOWN;
 }
 
+static const char *
+v4l2_fwnode_bus_type_to_string(enum v4l2_fwnode_bus_type type)
+{
+	const struct v4l2_fwnode_bus_conv *conv =
+		get_v4l2_fwnode_bus_conv_by_fwnode_bus(type);
+
+	return conv ? conv->name : "not found";
+}
+
+static const struct v4l2_fwnode_bus_conv *
+get_v4l2_fwnode_bus_conv_by_mbus(enum v4l2_mbus_type type)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(busses); i++)
+		if (busses[i].mbus_type == type)
+			return &busses[i];
+
+	return NULL;
+}
+
+static const char *
+v4l2_fwnode_mbus_type_to_string(enum v4l2_mbus_type type)
+{
+	const struct v4l2_fwnode_bus_conv *conv =
+		get_v4l2_fwnode_bus_conv_by_mbus(type);
+
+	return conv ? conv->name : "not found";
+}
+
 static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 					       struct v4l2_fwnode_endpoint *vep,
 					       enum v4l2_mbus_type bus_type)
@@ -398,6 +428,10 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 	memset(&vep->base, 0, sizeof(vep->base));
 
 	fwnode_property_read_u32(fwnode, "bus-type", &bus_type);
+	pr_debug("fwnode video bus type %s (%u), mbus type %s (%u)\n",
+		 v4l2_fwnode_bus_type_to_string(bus_type), bus_type,
+		 v4l2_fwnode_mbus_type_to_string(vep->bus_type),
+		 vep->bus_type);
 
 	mbus_type = v4l2_fwnode_bus_type_to_mbus(bus_type);
 
@@ -412,6 +446,10 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			v4l2_fwnode_endpoint_parse_parallel_bus(
 				fwnode, vep, V4L2_MBUS_UNKNOWN);
 
+		pr_debug("assuming media bus type %s (%u)\n",
+			 v4l2_fwnode_mbus_type_to_string(vep->bus_type),
+			 vep->bus_type);
+
 		break;
 	case V4L2_MBUS_CCP2:
 	case V4L2_MBUS_CSI1:
-- 
2.11.0
