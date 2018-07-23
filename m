Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56330 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388280AbeGWOsa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 06/21] v4l: fwnode: Add definitions for CSI-2 D-PHY, parallel and Bt.656 busses
Date: Mon, 23 Jul 2018 16:46:51 +0300
Message-Id: <20180723134706.15334-7-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add definitions corresponding to DT bindings to the CSI-2 D-PHY, parallel
and Bt.656 busses.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 291b3dcc19f3..4c98d17ab124 100644
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
