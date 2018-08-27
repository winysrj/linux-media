Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54562 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727290AbeH0NP6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 09:15:58 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org
Subject: [PATCH v2 20/23] v4l: fwnode: Use V4L2 fwnode endpoint media bus type if set
Date: Mon, 27 Aug 2018 12:29:57 +0300
Message-Id: <20180827093000.29165-21-sakari.ailus@linux.intel.com>
In-Reply-To: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the given media bus type set by the caller. If none is given (i.e. the
mbus type is V4L2_MBUS_UNKNOWN, or 0), fall back to the old behaviour.
This is to obtain the information from the DT or try to guess the bus
type.

-ENXIO is returned if the caller sets the bus type but that does not match
with what's in DT. Also return -ENXIO if bus type detection failed to
separate this from the rest of the errors.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 4c7f16ff79fa..4c2f7d709c5d 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -409,7 +409,7 @@ v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
 static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 					struct v4l2_fwnode_endpoint *vep)
 {
-	u32 bus_type = 0;
+	u32 bus_type = V4L2_FWNODE_BUS_TYPE_GUESS;
 	enum v4l2_mbus_type mbus_type;
 	int rval;
 
@@ -432,13 +432,24 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		 v4l2_fwnode_bus_type_to_string(bus_type), bus_type,
 		 v4l2_fwnode_mbus_type_to_string(vep->bus_type),
 		 vep->bus_type);
-
 	mbus_type = v4l2_fwnode_bus_type_to_mbus(bus_type);
 
-	switch (mbus_type) {
+	if (vep->bus_type != V4L2_MBUS_UNKNOWN) {
+		if (mbus_type != V4L2_MBUS_UNKNOWN &&
+		    vep->bus_type != mbus_type) {
+			pr_debug("expecting bus type %s\n",
+				 v4l2_fwnode_mbus_type_to_string(
+					 vep->bus_type));
+			return -ENXIO;
+		}
+	} else {
+		vep->bus_type = mbus_type;
+	}
+
+	switch (vep->bus_type) {
 	case V4L2_MBUS_UNKNOWN:
 		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep,
-							   mbus_type);
+							   V4L2_MBUS_UNKNOWN);
 		if (rval)
 			return rval;
 
@@ -453,20 +464,20 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		break;
 	case V4L2_MBUS_CCP2:
 	case V4L2_MBUS_CSI1:
-		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, mbus_type);
+		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, vep->bus_type);
 
 		break;
 	case V4L2_MBUS_CSI2_DPHY:
-		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
 		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep,
-							   mbus_type);
+							   vep->bus_type);
 		if (rval)
 			return rval;
 
 		break;
 	case V4L2_MBUS_PARALLEL:
 	case V4L2_MBUS_BT656:
-		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep, mbus_type);
+		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep,
+							vep->bus_type);
 
 		break;
 	default:
-- 
2.11.0
