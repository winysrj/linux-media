Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34266 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754309AbdLNTJV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:09:21 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH/RFC v2 08/15] rcar-csi2: add get_routing support
Date: Thu, 14 Dec 2017 20:08:28 +0100
Message-Id: <20171214190835.7672-9-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To support multiplexed streams the internal routing between the
rcar-csi2 sink pad and its source pads needs to be described.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 54 +++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 2dd7d03d622d5510..fd1133e72482fc19 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -334,6 +334,14 @@ static int rcar_csi2_pad_to_vc(unsigned int pad)
 	return pad - RCAR_CSI2_SOURCE_VC0;
 }
 
+static int rcar_csi2_vc_to_pad(unsigned int vc)
+{
+	if (vc > 3)
+		return -EINVAL;
+
+	return vc + RCAR_CSI2_SOURCE_VC0;
+}
+
 struct rcar_csi2_info {
 	const struct phypll_hsfreqrange *hsfreqrange;
 	const struct phtw_testdin_data *testdin_data;
@@ -752,9 +760,55 @@ static int rcar_csi2_get_pad_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int rcar_csi2_get_routing(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_routing *routing)
+{
+	struct rcar_csi2 *priv = sd_to_csi2(sd);
+	struct v4l2_mbus_frame_desc fd;
+	struct v4l2_subdev_route *r = routing->routes;
+	struct v4l2_subdev *rsubdev;
+	unsigned int i, rpad;
+	int ret;
+
+	/* Get information about multiplexed link */
+	ret = rcar_csi2_get_source_info(priv, &rsubdev, &rpad, &fd);
+	if (ret)
+		return ret;
+
+	if (routing->num_routes < fd.num_entries) {
+		routing->num_routes = fd.num_entries;
+		return -ENOSPC;
+	}
+
+	routing->num_routes = fd.num_entries;
+
+	for (i = 0; i < fd.num_entries; i++) {
+		struct v4l2_mbus_frame_desc_entry *entry = &fd.entry[i];
+		int source_pad;
+
+		source_pad = rcar_csi2_vc_to_pad(entry->bus.csi2.channel);
+		if (source_pad < 0) {
+			dev_err(priv->dev, "Virtual Channel out of range: %u\n",
+				entry->bus.csi2.channel);
+			return -ENOSPC;
+		}
+
+		r->sink_pad = RCAR_CSI2_SINK;
+		r->sink_stream = entry->stream;
+		r->source_pad = source_pad;
+		r->source_stream = 0;
+		r->flags = V4L2_SUBDEV_ROUTE_FL_ACTIVE |
+			V4L2_SUBDEV_ROUTE_FL_IMMUTABLE;
+		r++;
+	}
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops rcar_csi2_pad_ops = {
 	.set_fmt = rcar_csi2_set_pad_format,
 	.get_fmt = rcar_csi2_get_pad_format,
+	.get_routing = rcar_csi2_get_routing,
 	.s_stream = rcar_csi2_s_stream,
 };
 
-- 
2.15.1
