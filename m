Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41986 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752092AbdGEXAX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 19:00:23 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 4/8] v4l: fwnode: Obtain data bus type from FW
Date: Thu,  6 Jul 2017 02:00:15 +0300
Message-Id: <20170705230019.5461-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Just obtain it. It'll actually get used soon with CSI-1/CCP2.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 8df26010d006..d71dd3913cd9 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -28,6 +28,14 @@
 
 #include <media/v4l2-fwnode.h>
 
+enum v4l2_fwnode_bus_type {
+	V4L2_FWNODE_BUS_TYPE_GUESS = 0,
+	V4L2_FWNODE_BUS_TYPE_CSI2_CPHY,
+	V4L2_FWNODE_BUS_TYPE_CSI1,
+	V4L2_FWNODE_BUS_TYPE_CCP2,
+	NR_OF_V4L2_FWNODE_BUS_TYPE,
+};
+
 static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 					       struct v4l2_fwnode_endpoint *vep)
 {
@@ -168,6 +176,7 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			       struct v4l2_fwnode_endpoint *vep)
 {
+	u32 bus_type = 0;
 	int rval;
 
 	fwnode_graph_parse_endpoint(fwnode, &vep->base);
@@ -176,6 +185,8 @@ int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 	memset(&vep->bus_type, 0, sizeof(*vep) -
 	       offsetof(typeof(*vep), bus_type));
 
+	fwnode_property_read_u32(fwnode, "bus-type", &bus_type);
+
 	rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
 	if (rval)
 		return rval;
-- 
2.11.0
