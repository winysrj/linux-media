Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:30569 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbeKCBIf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:08:35 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 3/4] i2c: adv748x: store number of CSI-2 lanes described in device tree
Date: Fri,  2 Nov 2018 17:00:08 +0100
Message-Id: <20181102160009.17267-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv748x CSI-2 transmitters TXA and TXB can use different number of
lanes to transmit data. In order to be able to configure the device
correctly this information need to be parsed from device tree and stored
in each TX private data structure.

TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---
* Changes since v2
- Rebase to latest media-tree requires the bus_type filed in struct
  v4l2_fwnode_endpoint to be initialized, set it to V4L2_MBUS_CSI2_DPHY.

* Changes since v1
- Use %u instead of %d to print unsigned int.
- Fix spelling in commit message, thanks Laurent.
---
 drivers/media/i2c/adv748x/adv748x-core.c | 50 ++++++++++++++++++++++++
 drivers/media/i2c/adv748x/adv748x.h      |  1 +
 2 files changed, 51 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 2384f50dacb0ccff..9d80d7f3062b16bc 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -23,6 +23,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-dv-timings.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-ioctl.h>
 
 #include "adv748x.h"
@@ -521,12 +522,56 @@ void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
 	sd->entity.ops = &adv748x_media_ops;
 }
 
+static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
+				    unsigned int port,
+				    struct device_node *ep)
+{
+	struct v4l2_fwnode_endpoint vep;
+	unsigned int num_lanes;
+	int ret;
+
+	if (port != ADV748X_PORT_TXA && port != ADV748X_PORT_TXB)
+		return 0;
+
+	vep.bus_type = V4L2_MBUS_CSI2_DPHY;
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &vep);
+	if (ret)
+		return ret;
+
+	num_lanes = vep.bus.mipi_csi2.num_data_lanes;
+
+	if (vep.base.port == ADV748X_PORT_TXA) {
+		if (num_lanes != 1 && num_lanes != 2 && num_lanes != 4) {
+			adv_err(state, "TXA: Invalid number (%u) of lanes\n",
+				num_lanes);
+			return -EINVAL;
+		}
+
+		state->txa.num_lanes = num_lanes;
+		adv_dbg(state, "TXA: using %u lanes\n", state->txa.num_lanes);
+	}
+
+	if (vep.base.port == ADV748X_PORT_TXB) {
+		if (num_lanes != 1) {
+			adv_err(state, "TXB: Invalid number (%u) of lanes\n",
+				num_lanes);
+			return -EINVAL;
+		}
+
+		state->txb.num_lanes = num_lanes;
+		adv_dbg(state, "TXB: using %u lanes\n", state->txb.num_lanes);
+	}
+
+	return 0;
+}
+
 static int adv748x_parse_dt(struct adv748x_state *state)
 {
 	struct device_node *ep_np = NULL;
 	struct of_endpoint ep;
 	bool out_found = false;
 	bool in_found = false;
+	int ret;
 
 	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
 		of_graph_parse_endpoint(ep_np, &ep);
@@ -557,6 +602,11 @@ static int adv748x_parse_dt(struct adv748x_state *state)
 			in_found = true;
 		else
 			out_found = true;
+
+		/* Store number of CSI-2 lanes used for TXA and TXB. */
+		ret = adv748x_parse_csi2_lanes(state, ep.port, ep_np);
+		if (ret)
+			return ret;
 	}
 
 	return in_found && out_found ? 0 : -ENODEV;
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 39c2fdc3b41667d8..b482c7fe6957eb85 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -79,6 +79,7 @@ struct adv748x_csi2 {
 	struct v4l2_mbus_framefmt format;
 	unsigned int page;
 	unsigned int port;
+	unsigned int num_lanes;
 
 	struct media_pad pads[ADV748X_CSI2_NR_PADS];
 	struct v4l2_ctrl_handler ctrl_hdl;
-- 
2.19.1
