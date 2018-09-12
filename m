Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40954 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728287AbeIMCgM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:12 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 23/23] smiapp: Query the V4L2 endpoint for a specific bus type
Date: Thu, 13 Sep 2018 00:29:42 +0300
Message-Id: <20180912212942.19641-24-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of opportunistically trying to gather some information from the
V4L2 endpoint, set the bus type and let the V4L2 fwnode framework figure
out the configuration.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 048ab6cfaa97..0d660349b13c 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2775,7 +2775,13 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 	if (!ep)
 		return NULL;
 
+	bus_cfg.bus_type = V4L2_MBUS_CSI2_DPHY;
 	rval = v4l2_fwnode_endpoint_alloc_parse(ep, &bus_cfg);
+	if (rval == -ENXIO) {
+		bus_cfg = (struct v4l2_fwnode_endpoint)
+			{ .bus_type = V4L2_MBUS_CCP2 };
+		rval = v4l2_fwnode_endpoint_alloc_parse(ep, &bus_cfg);
+	}
 	if (rval)
 		goto out_err;
 
-- 
2.11.0
