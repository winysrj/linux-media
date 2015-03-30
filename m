Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60949 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbbC3LLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 07:11:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC 08/12] [media] tc358743: parse MIPI CSI-2 endpoint, support noncontinuous clock
Date: Mon, 30 Mar 2015 13:10:52 +0200
Message-Id: <1427713856-10240-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse the MIPI CSI-2 specific properties in the OF graph endpoint and
add support for the 'clock-noncontinuous' property.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index a510a14..e1059cc 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -38,6 +38,7 @@
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
 #include <media/tc358743.h>
 
 #include "tc358743_regs.h"
@@ -67,6 +68,7 @@ static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
 
 struct tc358743_state {
 	struct tc358743_platform_data pdata;
+	struct v4l2_of_bus_mipi_csi2 bus;
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
@@ -760,7 +762,8 @@ static void tc358743_set_csi(struct v4l2_subdev *sd)
 			((lanes > 2) ? MASK_D2M_HSTXVREGEN : 0x0) |
 			((lanes > 3) ? MASK_D3M_HSTXVREGEN : 0x0));
 
-	i2c_wr32(sd, TXOPTIONCNTRL, MASK_CONTCLKMODE);
+	i2c_wr32(sd, TXOPTIONCNTRL, (state->bus.flags &
+		 V4L2_MBUS_CSI2_CONTINUOUS_CLOCK) ? MASK_CONTCLKMODE : 0);
 }
 
 static void tc358743_start_csi(struct v4l2_subdev *sd)
@@ -1674,6 +1677,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 {
 	struct device *dev = &state->i2c_client->dev;
 	struct device_node *np = dev->of_node;
+	struct device_node *ep;
 	struct clk *refclk;
 	u32 bps_pr_lane;
 
@@ -1685,6 +1689,23 @@ static int tc358743_probe_of(struct tc358743_state *state)
 		return PTR_ERR(refclk);
 	}
 
+	ep = of_graph_get_next_endpoint(dev->of_node, NULL);
+	if (ep) {
+		struct v4l2_of_endpoint endpoint;
+
+		v4l2_of_parse_endpoint(ep, &endpoint);
+		if (endpoint.bus_type != V4L2_MBUS_CSI2 ||
+		    endpoint.bus.mipi_csi2.num_data_lanes == 0) {
+			dev_err(dev, "missing CSI-2 properties in endpoint\n");
+			return -EINVAL;
+		}
+
+		state->bus = endpoint.bus.mipi_csi2;
+	} else {
+		dev_err(dev, "missing endpoint node\n");
+		return -EINVAL;
+	}
+
 	clk_prepare_enable(refclk);
 
 	state->pdata.refclk_hz = clk_get_rate(refclk);
-- 
2.1.4

