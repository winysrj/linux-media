Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40956 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728229AbeIMCgL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 17/23] v4l: fwnode: Only zero the struct if bus type is set to V4L2_MBUS_UNKNOWN
Date: Thu, 13 Sep 2018 00:29:36 +0300
Message-Id: <20180912212942.19641-18-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to prepare for allowing drivers to set the defaults for a given
bus, make zeroing the struct conditional based on detecting the bus.
All callers now set the bus type to zero which allows only zeroing the
remaining bus union.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index de4a43765ac2..8244a7b8414e 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -325,6 +325,12 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 	u32 bus_type = 0;
 	int rval;
 
+	if (vep->bus_type == V4L2_MBUS_UNKNOWN) {
+		/* Zero fields from bus union to until the end */
+		memset(&vep->bus, 0,
+		       sizeof(*vep) - offsetof(typeof(*vep), bus));
+	}
+
 	pr_debug("===== begin V4L2 endpoint properties\n");
 
 	/*
@@ -333,10 +339,6 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 	 */
 	memset(&vep->base, 0, sizeof(vep->base));
 
-	/* Zero fields from bus_type to until the end */
-	memset(&vep->bus_type, 0, sizeof(*vep) -
-	       offsetof(typeof(*vep), bus_type));
-
 	fwnode_property_read_u32(fwnode, "bus-type", &bus_type);
 
 	switch (bus_type) {
-- 
2.11.0
