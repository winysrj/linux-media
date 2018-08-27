Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54468 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726921AbeH0NPz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 09:15:55 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org
Subject: [PATCH v2 03/23] v4l: fwnode: The CSI-2 clock is continuous if it's not non-continuous
Date: Mon, 27 Aug 2018 12:29:40 +0300
Message-Id: <20180827093000.29165-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The continuous clock flag was only set if there was a clock or data lanes.
This isn't needed as such a configuration is invalid to begin with. Always
set the continuous clock flag if the non-continuous property is not found.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index da13348b1f4a..0cc96ee5f1e5 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -107,7 +107,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 	if (fwnode_property_present(fwnode, "clock-noncontinuous")) {
 		flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
 		pr_debug("non-continuous clock\n");
-	} else if (have_clk_lane || bus->num_data_lanes > 0) {
+	} else {
 		flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 	}
 
-- 
2.11.0
