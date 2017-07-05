Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41980 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752100AbdGEXAX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 19:00:23 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 3/8] v4l: fwnode: Call CSI2 bus csi2, not csi
Date: Thu,  6 Jul 2017 02:00:14 +0300
Message-Id: <20170705230019.5461-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function to parse CSI2 bus parameters was called
v4l2_fwnode_endpoint_parse_csi_bus(), rename it as
v4l2_fwnode_endpoint_parse_csi2_bus() in anticipation of CSI1/CCP2
support.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 153c53ca3925..8df26010d006 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -28,8 +28,8 @@
 
 #include <media/v4l2-fwnode.h>
 
-static int v4l2_fwnode_endpoint_parse_csi_bus(struct fwnode_handle *fwnode,
-					      struct v4l2_fwnode_endpoint *vep)
+static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
+					       struct v4l2_fwnode_endpoint *vep)
 {
 	struct v4l2_fwnode_bus_mipi_csi2 *bus = &vep->bus.mipi_csi2;
 	bool have_clk_lane = false;
@@ -176,7 +176,7 @@ int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 	memset(&vep->bus_type, 0, sizeof(*vep) -
 	       offsetof(typeof(*vep), bus_type));
 
-	rval = v4l2_fwnode_endpoint_parse_csi_bus(fwnode, vep);
+	rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
 	if (rval)
 		return rval;
 	/*
-- 
2.11.0
