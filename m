Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56362 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388309AbeGWOsc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:32 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 13/21] v4l: fwnode: Parse the graph endpoint as last
Date: Mon, 23 Jul 2018 16:46:58 +0300
Message-Id: <20180723134706.15334-14-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parsing the graph endpoint is always successful; therefore parse it as
last.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 19f4e331c7d8..1e64182b74dd 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -308,7 +308,11 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 
 	pr_debug("===== begin V4L2 endpoint properties\n");
 
-	fwnode_graph_parse_endpoint(fwnode, &vep->base);
+	/*
+	 * Zero the fwnode graph endpoint memory in case we don't end up parsing
+	 * the endpoint.
+	 */
+	memset(&vep->base, 0, sizeof(vep->base));
 
 	/* Zero fields from bus_type to until the end */
 	memset(&vep->bus_type, 0, sizeof(*vep) -
@@ -327,25 +331,37 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			v4l2_fwnode_endpoint_parse_parallel_bus(
 				fwnode, vep, V4L2_MBUS_UNKNOWN);
 
-		return vep->bus_type == V4L2_MBUS_UNKNOWN ? -EINVAL : 0;
+		if (vep->bus_type == V4L2_MBUS_UNKNOWN)
+			return -EINVAL;
+
+		break;
+
 	case V4L2_FWNODE_BUS_TYPE_CCP2:
 	case V4L2_FWNODE_BUS_TYPE_CSI1:
 		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, bus_type);
+		break;
 
-		return 0;
 	case V4L2_FWNODE_BUS_TYPE_CSI2_DPHY:
 		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
-		return v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep,
+		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep,
 							   bus_type);
+		if (rval)
+			return rval;
+
+		break;
 	case V4L2_FWNODE_BUS_TYPE_PARALLEL:
 	case V4L2_FWNODE_BUS_TYPE_BT656:
 		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep, bus_type);
 
-		return 0;
+		break;
 	default:
 		pr_warn("unsupported bus type %u\n", bus_type);
 		return -EINVAL;
 	}
+
+	fwnode_graph_parse_endpoint(fwnode, &vep->base);
+
+	return 0;
 }
 
 int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
-- 
2.11.0
