Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40954 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727818AbeIMCgJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:09 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 05/23] v4l: fwnode: Add definitions for CSI-2 D-PHY, parallel and Bt.656 busses
Date: Thu, 13 Sep 2018 00:29:24 +0300
Message-Id: <20180912212942.19641-6-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add definitions corresponding to DT bindings to the CSI-2 D-PHY, parallel
and Bt.656 busses.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index cf90ddb5c430..104ef7f1754d 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -36,6 +36,9 @@ enum v4l2_fwnode_bus_type {
 	V4L2_FWNODE_BUS_TYPE_CSI2_CPHY,
 	V4L2_FWNODE_BUS_TYPE_CSI1,
 	V4L2_FWNODE_BUS_TYPE_CCP2,
+	V4L2_FWNODE_BUS_TYPE_CSI2_DPHY,
+	V4L2_FWNODE_BUS_TYPE_PARALLEL,
+	V4L2_FWNODE_BUS_TYPE_BT656,
 	NR_OF_V4L2_FWNODE_BUS_TYPE,
 };
 
-- 
2.11.0
