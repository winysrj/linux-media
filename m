Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:40381 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728370AbeKBIiU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:38:20 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 27/30] adv748x: csi2: add internal routing configuration
Date: Fri,  2 Nov 2018 00:31:41 +0100
Message-Id: <20181101233144.31507-28-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support to get and set the internal routing between the adv748x
CSI-2 transmitters sink pad and its multiplexed source pad. This routing
includes which stream of the multiplexed pad to use, allowing the user
to select which CSI-2 virtual channel to use when transmitting the
stream.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 65 ++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index d83ae8e5d802a3bd..ef588567313574c7 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -14,6 +14,8 @@
 
 #include "adv748x.h"
 
+#define ADV748X_CSI2_ROUTES_MAX 4
+
 struct adv748x_csi2_format {
 	unsigned int code;
 	unsigned int datatype;
@@ -249,10 +251,73 @@ static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
 	return 0;
 }
 
+static int adv748x_csi2_get_routing(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_routing *routing)
+{
+	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
+	struct v4l2_subdev_route *r = routing->routes;
+	unsigned int vc;
+
+	if (routing->num_routes < ADV748X_CSI2_ROUTES_MAX) {
+		routing->num_routes = ADV748X_CSI2_ROUTES_MAX;
+		return -ENOSPC;
+	}
+
+	routing->num_routes = ADV748X_CSI2_ROUTES_MAX;
+
+	for (vc = 0; vc < ADV748X_CSI2_ROUTES_MAX; vc++) {
+		r->sink_pad = ADV748X_CSI2_SINK;
+		r->sink_stream = 0;
+		r->source_pad = ADV748X_CSI2_SOURCE;
+		r->source_stream = vc;
+		r->flags = vc == tx->vc ? V4L2_SUBDEV_ROUTE_FL_ACTIVE : 0;
+		r++;
+	}
+
+	return 0;
+}
+
+static int adv748x_csi2_set_routing(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_routing *routing)
+{
+	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
+	struct v4l2_subdev_route *r = routing->routes;
+	unsigned int i;
+	int vc = -1;
+
+	if (routing->num_routes > ADV748X_CSI2_ROUTES_MAX)
+		return -ENOSPC;
+
+	for (i = 0; i < routing->num_routes; i++) {
+		if (r->sink_pad != ADV748X_CSI2_SINK ||
+		    r->sink_stream != 0 ||
+		    r->source_pad != ADV748X_CSI2_SOURCE ||
+		    r->source_stream >= ADV748X_CSI2_ROUTES_MAX)
+			return -EINVAL;
+
+		if (r->flags & V4L2_SUBDEV_ROUTE_FL_ACTIVE) {
+			if (vc != -1)
+				return -EMLINK;
+
+			vc = r->source_stream;
+		}
+		r++;
+	}
+
+	if (vc != -1)
+		tx->vc = vc;
+
+	adv748x_csi2_set_virtual_channel(tx, tx->vc);
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
 	.get_fmt = adv748x_csi2_get_format,
 	.set_fmt = adv748x_csi2_set_format,
 	.get_frame_desc = adv748x_csi2_get_frame_desc,
+	.get_routing = adv748x_csi2_get_routing,
+	.set_routing = adv748x_csi2_set_routing,
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.19.1
