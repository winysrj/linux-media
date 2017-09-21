Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57379 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751811AbdIUPbn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:31:43 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] tc358743: validate lane count and order
Date: Thu, 21 Sep 2017 17:31:39 +0200
Message-Id: <20170921153139.16657-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TC358743 does not support reordering lanes, or more than 4 data
lanes.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index a35043cefe128..b7285e45b908a 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1743,6 +1743,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	struct clk *refclk;
 	u32 bps_pr_lane;
 	int ret = -EINVAL;
+	int i;
 
 	refclk = devm_clk_get(dev, "refclk");
 	if (IS_ERR(refclk)) {
@@ -1771,6 +1772,21 @@ static int tc358743_probe_of(struct tc358743_state *state)
 		goto free_endpoint;
 	}
 
+	if (endpoint->bus.mipi_csi2.num_data_lanes > 4) {
+		dev_err(dev, "invalid number of lanes\n");
+		goto free_endpoint;
+	}
+
+	for (i = 0; i < endpoint->bus.mipi_csi2.num_data_lanes; i++) {
+		if (endpoint->bus.mipi_csi2.data_lanes[i] != i + 1)
+			break;
+	}
+	if (i != endpoint->bus.mipi_csi2.num_data_lanes ||
+	    endpoint->bus.mipi_csi2.clock_lane != 0) {
+		dev_err(dev, "invalid lane order\n");
+		goto free_endpoint;
+	}
+
 	state->bus = endpoint->bus.mipi_csi2;
 
 	ret = clk_prepare_enable(refclk);
-- 
2.11.0
