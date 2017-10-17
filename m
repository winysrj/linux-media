Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56343 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756391AbdJQLFP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 07:05:15 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2] [media] tc358743: validate lane count
Date: Tue, 17 Oct 2017 13:05:11 +0200
Message-Id: <20171017110511.18345-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TC358743 does not support more than 4 data lanes. Check that the
lane count is valid.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
v2: drop lane order check, as suggested by Sakari
---
 drivers/media/i2c/tc358743.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index a9355032076f9..8bfb3f56502b7 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1941,6 +1941,11 @@ static int tc358743_probe_of(struct tc358743_state *state)
 		goto free_endpoint;
 	}
 
+	if (endpoint->bus.mipi_csi2.num_data_lanes > 4) {
+		dev_err(dev, "invalid number of lanes\n");
+		goto free_endpoint;
+	}
+
 	state->bus = endpoint->bus.mipi_csi2;
 
 	ret = clk_prepare_enable(refclk);
-- 
2.11.0
