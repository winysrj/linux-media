Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56338 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388320AbeGWOsb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:31 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 17/21] v4l: fwnode: Print bus type
Date: Mon, 23 Jul 2018 16:47:02 +0300
Message-Id: <20180723134706.15334-18-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Print bus type either as set by the driver or as parsed from the bus-type
property, as well as the guessed V4L2 media bus type.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 0a9d85b3892f..8914abd20ee8 100644
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
 
@@ -415,6 +449,10 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		if (vep->bus_type == V4L2_MBUS_UNKNOWN)
 			return -EINVAL;
 
+		pr_debug("assuming media bus type %s (%u)\n",
+			 v4l2_fwnode_mbus_type_to_string(vep->bus_type),
+			 vep->bus_type);
+
 		break;
 
 	case V4L2_MBUS_CCP2:
-- 
2.11.0
